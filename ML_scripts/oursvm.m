function [ res ] = oursvm(file,trainsize)
    trainset=file(1:trainsize,:);
    testset=file(trainsize+1:end,:);
    grouping=trainset(:,164);
    options.MaxIter = 150000;
    SVMStruct = svmtrain(trainset(:,1:163),grouping,'Options', options);
    res = svmclassify(SVMStruct,testset(:,1:163));


end

