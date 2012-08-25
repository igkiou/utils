u = ud; v=vd;

clear uM vM;
fig1 = figure;
set(fig1,'NextPlot','replacechildren')
for i=1:2:length(u);
    subplot(1,2,1); imshow(u{i});
    uM(i) = getframe;
    subplot(1,2,2); imshow(v{i}+mean(mean(u{i})));
    vM(i) = getframe;
end


% %fps = 15; 
% figure; 
% subplot(2,2,1); movie(uM,1);%,fps);
% subplot(2,2,2); movie(VM,1);%,fps);
% %mpgwrite(salM,jet,'sal.mpg');


% %if (feat=='thres'); 
%     fps_new = 12;
% %else fps_new = 3; end;
% 
% %movie_name = [vidir filesep name '_video_' scheme '_' feat '_frameNo_' num2str(length(salM)) '_fps_' num2str(fps_new)] 
% movie_name='test';
% movie2avi(uM,movie_name,'compression','Indeo3','quality',100,'fps',fps_new); %change to None
% 


%****************matlab avifile.m example 
fps=10;

fig1=figure;
set(fig1,'DoubleBuffer','on');
%set(gca,'xlim',[-80 80],'ylim',[-80 80],...
%    'NextPlot','replace','Visible','off')
mov = avifile('barb_v.avi','compression','Indeo3','quality',100,'fps',fps)
for i=1:length(v)
    imshow(cropbounds((real(v{i}))+mean(mean(u{i})),2));
    M = getframe(gca);
    mov = addframe(mov,M);
end
mov = close(mov);

fig2=figure;
set(fig2,'DoubleBuffer','on');
%set(gca,'xlim',[-80 80],'ylim',[-80 80],...
%    'NextPlot','replace','Visible','off')
mov = avifile('barb_u.avi','compression','Indeo3','quality',100,'fps',fps)
for i=1:length(u)
    imshow(cropbounds((real(u{i})),2));
    M = getframe(gca);
    mov = addframe(mov,M);
end
mov = close(mov);


fig3=figure;
set(fig3,'DoubleBuffer','on');
%set(gca,'xlim',[-80 80],'ylim',[-80 80],...
%    'NextPlot','replace','Visible','off')
mov = avifile('barb_w.avi','compression','Indeo3','quality',100,'fps',fps)
for i=1:length(w)
    imshow(cropbounds((real(w{i}))+mean(mean(u{i})),2),[]);
    M = getframe(gca);
    mov = addframe(mov,M);
end
mov = close(mov);