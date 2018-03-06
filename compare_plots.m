figure(3)
colors1 = jet(truthmodel.state_dim);
colormap(colors1);
colors2 = jet(posteriormodel.state_dim);
colormap(colors2);
subplot(3,1,1);
data_abs = sqrt(data(1,:).^2 + data(2,:).^2);
plot(data_abs)
subplot(3,1,2)
image(truthmodel.states.stateseq);
subplot(3,1,3)
image(posteriormodel.states.stateseq);
