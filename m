Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB93474A96
	for <lists+io-uring@lfdr.de>; Tue, 14 Dec 2021 19:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhLNSQq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Dec 2021 13:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbhLNSQq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Dec 2021 13:16:46 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7367C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Dec 2021 10:16:45 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id r11so65321327edd.9
        for <io-uring@vger.kernel.org>; Tue, 14 Dec 2021 10:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CyoOkzG+ILTkOySR7Tmp2jvgY9Vd42hLNdodZoHpXtA=;
        b=Bkz/9wM1UeoF00qdf0TzdohhcWv2uNVDZFpv5UV6xGpflk81IbSlDW52pz6obo76uE
         z5bJdm5OxCEeTvvTI9K36j9y1NWp/WfOlKMhnbHDDxRyZJpeCrIW56lSKHZSE33dtY8c
         4/qwUTuI0s1f8rKC2mxCZGdf1P6HufBsZ4iHkvXUPcSDK7VGNtEnsh/THJtTfeS6cgMH
         7s1KsraTww8PRSUfcHOvLUxZcDNq7ZVbTYwva2+81DKqW+3m5b6O90VzUWhlE8n5rTsI
         4OoBPFCLGpyDG3oAps+/fK3ZNoZy61ADHa/wa2ElOQCr0w0RKkKVgZwHdNWvdAt0danF
         JQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CyoOkzG+ILTkOySR7Tmp2jvgY9Vd42hLNdodZoHpXtA=;
        b=s2Cia9bt/p+eg9om3CLwInHBHGZ3JAlvcF/CyeKVimyJZYQuazHpW2EbNwS6XDorim
         gMcfDOVhM3I4DA1Sre7argRlDpL/I86xIHeknu5voqPMeGQOeq036JdknI9eWo0vM/mY
         Fa0DlYkhTG2bq/y/3O/EHdHiKk47injt8Y0OGHGxrKgRGVvgJ2QFXqmGrViG42HfABCA
         n5LFepEy5YKukzl8foiBTERU4jwicL73zuta3wTNSTXlnxr7zdXCQhzfSXZ6wcsG/Kel
         U+fJSOAk2P8obVHfPw0WvBIFODCJdtVa6UBAMK7H737XVp6RZLkmhGxtFGC1XeMP+d/+
         7LcQ==
X-Gm-Message-State: AOAM530910TkpQDCNL7gP700DhAr4zhtxwti0fvky6ujtQ6yyv7x5kbm
        Py/OXdW5Hg6BUe7BSnSeB+FH0P11K6A=
X-Google-Smtp-Source: ABdhPJweuAQWxLkEU9rusdL1vU7No+WGQwUTSIKZmMvByqlFwuWErI1LotCDOsMf2L9DyUAWTGNS5g==
X-Received: by 2002:a05:6402:5194:: with SMTP id q20mr10225311edd.250.1639505804500;
        Tue, 14 Dec 2021 10:16:44 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id kx3sm164503ejc.112.2021.12.14.10.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 10:16:44 -0800 (PST)
Message-ID: <06e21b01-a168-e25f-1b42-97789392bd89@gmail.com>
Date:   Tue, 14 Dec 2021 18:16:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [POC RFC 0/3] support graph like dependent sqes
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
 <4ef630f4-54d8-e8c6-8622-dccef5323864@gmail.com>
 <7607c0f9-cad3-cfc5-687e-07dc82684b4e@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7607c0f9-cad3-cfc5-687e-07dc82684b4e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/21 16:53, Hao Xu wrote:
> 
> 在 2021/12/14 下午11:21, Pavel Begunkov 写道:
>> On 12/14/21 05:57, Hao Xu wrote:
>>> This is just a proof of concept which is incompleted, send it early for
>>> thoughts and suggestions.
>>>
>>> We already have IOSQE_IO_LINK to describe linear dependency
>>> relationship sqes. While this patchset provides a new feature to
>>> support DAG dependency. For instance, 4 sqes have a relationship
>>> as below:
>>>        --> 2 --
>>>       /        \
>>> 1 ---          ---> 4
>>>       \        /
>>>        --> 3 --
>>> IOSQE_IO_LINK serializes them to 1-->2-->3-->4, which unneccessarily
>>> serializes 2 and 3. But a DAG can fully describe it.
>>>
>>> For the detail usage, see the following patches' messages.
>>>
>>> Tested it with 100 direct read sqes, each one reads a BS=4k block data
>>> in a same file, blocks are not overlapped. These sqes form a graph:
>>>        2
>>>        3
>>> 1 --> 4 --> 100
>>>       ...
>>>        99
>>>
>>> This is an extreme case, just to show the idea.
>>>
>>> results below:
>>> io_link:
>>> IOPS: 15898251
>>> graph_link:
>>> IOPS: 29325513
>>> io_link:
>>> IOPS: 16420361
>>> graph_link:
>>> IOPS: 29585798
>>> io_link:
>>> IOPS: 18148820
>>> graph_link:
>>> IOPS: 27932960
>>
>> Hmm, what do we compare here? IIUC,
>> "io_link" is a huge link of 100 requests. Around 15898251 IOPS
>> "graph_link" is a graph of diameter 3. Around 29585798 IOPS

Diam 2 graph, my bad


>> Is that right? If so it'd more more fair to compare with a
>> similar graph-like scheduling on the userspace side.
> 
> The above test is more like to show the disadvantage of LINK

Oh yeah, links can be slow, especially when it kills potential
parallelism or need extra allocations for keeping state, like
READV and WRITEV.


> But yes, it's better to test the similar userspace  scheduling since
> 
> LINK is definitely not a good choice so have to prove the graph stuff
> 
> beat the userspace scheduling. Will test that soon. Thanks.

Would be also great if you can also post the benchmark once
it's done


>> submit(req={1});
>> wait(nr=1);
>> submit({2-99});
>> wait(nr=98);
>> submit(req={100});
>> wait(nr=1);
>>

-- 
Pavel Begunkov
