function varargout = BasicGUI(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BasicGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BasicGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before BasicGUI is made visible.
function BasicGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BasicGUI (see VARARGIN)

a = - 5;
b = 5;
N = 16384;
fe = N/(b-a);
te = 1/fe;

% N intervalles -> il faut s'arr�ter � b-te
handles.xt = linspace(a,b-te,N);
handles.xf = linspace(-fe/2,fe/2-1/(b-a),N);    %idem

pulse = 2*pi*(50);                %om�ga = 2*PI*f
deltaT = floor(0.0*fe);         %d�calage temporel du Dirac (1 sec = fe)
deltaF = 2*pi*5;                      %d�calage fr�quentiel pour aliasing


%�chantillonnage des diff�rentes fonctions

%constante
handles.constant = ones(1,N); 

%cosinus
for n=1:N
    handles.cos(1,n)= cos(pulse*((n-1)*te + a));
end

%sinus
for n=1:N
    handles.sin(1,n)= sin(pulse*((n-1)*te + a));
end

%dirac en deltaT
handles.dirac = zeros(1,N);
handles.dirac(1,(N/2+1)-deltaT) = 1;

%exponentielle complexe
for n=1:N
    handles.expcmp(1,n)= exp(1i*(pulse*((n-1)*te + a)));
end

%rectangle(0.2)
handles.rectangle = zeros(1,N);
for n=floor(N/2-0.01*N)+2:floor(N/2+0.01*N)+1
    handles.rectangle(1,n)= 1;
end

%exponentielle d�croissante
for n=1:N
    handles.gaussienne(1,n)= exp(-pi*((n-1)*te + a)^2);
end

%cr�neau
handles.creneau = zeros(1,N);
%act = -0.4;

for n=floor(0.01*N)+20:2*floor(0.02*N):N-0.02*N
    for o=n:n+floor(0.02*N)-1
    handles.creneau(1,o)= 1;
    end
end


for n=1:N
    handles.aliasing(1,n)= sin(pulse*((n-1)*te + a)) + sin((pulse+deltaF)*((n-1)*te + a)) + sin((pulse+2*deltaF)*((n-1)*te + a)) + 2*sin((pulse+3*deltaF)*((n-1)*te + a));
end

handles.currentData = handles.constant;

% Choose default command line output for BasicGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = BasicGUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on selection change in MenuFonction.
function MenuFonction_Callback(hObject, eventdata, handles)

str = get(hObject, 'String');
val = get(hObject, 'Value');

switch str{val}
    case 'Constante'
        handles.currentData = handles.constant;
    case 'Cosinus'
        handles.currentData = handles.cos;
    case 'Sinus'
        handles.currentData = handles.sin;
    case 'Dirac'
        handles.currentData = handles.dirac;
    case 'Expontielle complexe'
        handles.currentData = handles.expcmp;
    case  'Rectangle de pas 0.2'
        handles.currentData = handles.rectangle;
    case  'Gaussienne'
        handles.currentData = handles.gaussienne;
    case 'Signal cr�neau'
        handles.currentData = handles.creneau;
    case 'Aliasing'
        handles.currentData = handles.aliasing;
end

guidata(hObject, handles);


% --- Executes on button press in draw.
function draw_Callback(hObject, eventdata, handles)

    axes(handles.fig1);
    
    plot(handles.xt,real(handles.currentData));
    title('Echantillonage temporel');
    
    handles.F = tfour(handles.currentData);
    
    if handles.RB1.Value == 1
        
        minp = min(min(real(handles.F)),min(imag(handles.F)));
        maxp = max(max(real(handles.F)),max(imag(handles.F)));
        
        axes(handles.fig2);
        plot(handles.xf,real(handles.F));
        title('Partie r�elle de la transform�e de Fourier')
        ylim([minp-0.1*(maxp-minp),maxp+0.1*(maxp-minp)]);
        
        axes(handles.fig3);
        plot(handles.xf,imag(handles.F));
        title('Partie imaginaire de la transform�e de Fourier')
        ylim([minp-0.1*(maxp-minp),maxp+0.1*(maxp-minp)]);
        
    elseif handles.RB2.Value == 1
        
        minp = min(abs(handles.F));
        maxp = max(abs(handles.F));
        
        axes(handles.fig2);
        plot(handles.xf,abs(handles.F));
        title('Module de la transform�e de Fourier')
        ylim([minp-0.1*(maxp-minp)-0.1,maxp+0.1*(maxp-minp)+0.1]);
        
        axes(handles.fig3);
        plot(handles.xf,angle(handles.F));
        title('Argument de la transform�e de Fourier')
        ylim([-pi-0.5,pi+0.5]);
        
    end

    axes(handles.fig4);
    plot(handles.xt,real(tfourinv(handles.F)));
    title('Transform�e inverse de Fourier')
    guidata(hObject, handles);
    
% --- Executes during object creation, after setting all properties.
function MenuFonction_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function figure1_SizeChangedFcn(hObject, eventdata, handles)

% --- Executes on button press in RB1.
function RB1_Callback(hObject, eventdata, handles)

% --- Executes on button press in RB2.
function RB2_Callback(hObject, eventdata, handles)
