clear za zb ya ea
for i=1:5
   za(i,:)= key(i,nptrain+1:K-2);
   zb(i,:)= rsnet(i,nptrain+1:K-2);
   ya(i,:)=[nptrain+1:K-2];
   ea(i,:)=abs(key(plotpick,nptrain+1:K-2)-rsnet(plotpick,nptrain+1:K-2));
end
ya=ya';
za=za';
zb=zb';
ea=ea';
a1=ones(length(za),1);
z=[a1,a1*2,a1*3,a1*4,a1*5]; 
plot3(z,ya,za,'DisplayName','data'); hold on
plot3(z,ya,zb,'DisplayName','prediction'); hold on
plot3(z,ya,ea,'DisplayName','error'); hold on
xlabel(['frequency point']);
ylabel(['realization']);
zlabel(['output, target and error']);
box on
grid on
hold off
