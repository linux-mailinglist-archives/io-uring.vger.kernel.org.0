Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB13419551
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 15:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhI0Nrg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 09:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbhI0Nrg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 09:47:36 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B05C061575
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 06:45:58 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id b10so22769782ioq.9
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 06:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f0HCwjIt5DO+Jim5K2FE27BTeWMoVwNj46+vmIU/avc=;
        b=cNI8Bg5rWR340kBR/9fTEK0TMTDLmsh/p9cUuh4WiGUrMDwvvc2djal5ryldkTb+Po
         Gi5sZD4U4hU83DfnXYLADJqUbDdWjAy0pZ5KFL39K5Vy7YgsgSb4aNT/ORwvAej/JGMf
         wuoEy4zyK3onPILLVB3a+HrlMwrshBT4pQ/zI1UJuXAv6yHg99BgVC+sXMwCPOoiY5Yz
         EiVaF1cyTV+e8OQRG+wd2DRcUoBnvjxszvePZwFnV4x85T8GbguQArQHzmlFZRL6oF29
         u7RQs/3VGg8Gv2gOc/hJS9CxVg1H+ACLpujGGTF6jICk8jEsdLr8+rStrFJy14LrhYgS
         XxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f0HCwjIt5DO+Jim5K2FE27BTeWMoVwNj46+vmIU/avc=;
        b=gAIVYiJlFOxuY1tr12TRSq2SdK8ZdG88zCJ8NdlYO2BkseVj3calBoFoBX1+g/Z1Sh
         rQuA+hR1XS65dLNxIN+sRoxn1ICDJLfMYmnzcw7VMIvR2lNDN1Q6N87tmgk4PQ6ixs3w
         3tSr1Vh2k9L4PC5OAJOkMF35j8xLrvrf4BNFouPq/dytdsYwzeS7H8c3/maf8CLknucF
         YPmHf5Y2LDx58EDBAi8nFzdBPcrJYy0qEw8ZRF0td3K64tGMzLurqrguGeV1mEM1rF7I
         VHB1tY1Df7cAad2XvjN+xke01+MdzPyW17v+kYLUrAJiwMGn41xvULkwNCYy0wUlpIap
         hQ5A==
X-Gm-Message-State: AOAM530qMAXknxsqYWYWFHzpJZLStPRioYj8vNuLQeE4mp6M07ZseJWx
        dNHk28MPb0wrsxzXCgXPQa/U74eEfPNFCWAO6ts=
X-Google-Smtp-Source: ABdhPJzomE7i8BahByD2RxDWYcbUWfuA4JwpUWidEh+3hPRQvvmEHH6vm2vm4/nMMVkGUY+jRmip2Q==
X-Received: by 2002:a05:6638:3048:: with SMTP id u8mr4113277jak.103.1632750349826;
        Mon, 27 Sep 2021 06:45:49 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v17sm8743614ilo.1.2021.09.27.06.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 06:45:49 -0700 (PDT)
Subject: Re: [PATCH liburing v2 0/2] Fix endianess issue and add srand()
To:     Ammar Faizi <ammarfaizi2@gmail.com>
Cc:     io_uring Mailing List <io-uring@vger.kernel.org>
References: <7e5e3e4c-5f42-8a17-a051-d7e6a5ced9c9@kernel.dk>
 <20210927134023.294466-1-ammarfaizi2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1a0f62ef-545d-768e-03cc-6e1e51297107@kernel.dk>
Date:   Mon, 27 Sep 2021 07:45:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210927134023.294466-1-ammarfaizi2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/27/21 7:40 AM, Ammar Faizi wrote:
> On Mon, Sep 27, 2021 at 8:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/26/21 10:37 PM, Ammar Faizi wrote:
>>> The use of `rand()` should be accompanied by `srand()`.
>>
>> The idiomatic way that I usually do it for these tests is:
>>
>> srand(getpid());
>>
>> Shouldn't really matter, but we may as well keep it consistent.
> 
> v2: Use getpid() for the random seed.

Applied, thanks.

-- 
Jens Axboe

