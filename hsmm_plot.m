function [] = hsmm_plot(hsmm,data)

            data_abs = sqrt(data(1,:).^2 + data(2,:).^2);
            subplot(2,1,[1 2]);
            colors = jet(hsmm.state_dim);
            colormap(colors);
            
            % plot state sequence
            subplot(2,1,1);
            ax = gca();
            image(hsmm.states.stateseq);
            xlabel('Sequence Index','FontSize',20);
            title('Inferred State Sequence','FontSize',20);
            set(ax,'FontSize',20)
            subplot(2,1,2);
            ax = gca();
            plot(data_abs)
            axis([1 length(data_abs) 0 max(data_abs)])
            set(ax,'FontSize',20)
            title('Observed Magnitude After Downsampling','FontSize',20);
            xlabel('Sequence Index','FontSize',20);

