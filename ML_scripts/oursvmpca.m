function [ res ] = oursvmpca(file,trainsize,d)
    trainset=d(1:trainsize,:);
    testset=d(trainsize+1:end,:);
    grouping=file(:,164);
    options.MaxIter = 150000;
    SVMStruct = svmtrain(trainset,grouping(1:trainsize),'Options', options);
    res = svmclassify(SVMStruct,testset);
end



