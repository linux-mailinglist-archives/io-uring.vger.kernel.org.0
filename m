Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A364794E2
	for <lists+io-uring@lfdr.de>; Fri, 17 Dec 2021 20:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236701AbhLQTeX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Dec 2021 14:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbhLQTeX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Dec 2021 14:34:23 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A847CC061574
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 11:34:22 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id j21so7414042edt.9
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 11:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/ZJYPAEJN1VDKMkEbLQ8WCeKIrC62RKY2REahtJMfwg=;
        b=EFn+EJoiEzm6+PsDWQ4Bt2+Dby9aerc8uy3MZGnDcDH+qYhYNB2jO/F7AW20WWuHj/
         DsHFtoTI6C8/3/8R9FXUEXCu9u6nPZFY5GKtB3NZOE/AkyIEAizR4kdGIIy5LOZgbD9i
         qWzHwOHUwIPmFvd+PyzK4r3xsUeW2QInzjTp96fDcgJmGTC9LwkaOb8OovfbgzN+QYk6
         x88u6iTYzDr6BmciGhFw2EwqbFTGBdg2WMi2/65Wjm3tYimXWAPNllaKRFjgd5TqU73y
         M6EtKdvrQQOqQJZxhSjf4yjPEfUN90dVVoiMj44yfwkKIU9ChimA7umMw64J/7I31nfw
         g9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/ZJYPAEJN1VDKMkEbLQ8WCeKIrC62RKY2REahtJMfwg=;
        b=Ex0tZ1teadFvTVj/ZlfIgtEMg5NOn3MueVAyRBxYO0or4qqIGjCpkqWQ9onY1/TeYg
         6IECglW1bIvM9nVAbZ6M71bmcWlDz9nx0spBlgF8uPmDMOcoocxUYNfNS9qcV9BgPMWF
         GxXldhjeg0f+TfOlkN6kVN/0pXJdoHpIrY+CBZ59HHR8VeDtDv876QKV150q5/U+gKXv
         FyQB2PjiCJAXxoAq5omER6ye7svC/ZHkUZHVoJ2rWMhjiBjD0GakSWu3zi9ccrxbMYmU
         6XCIbD96OM+zCRRgmSA0OQ1k3wGo/dfd+JHlFJ5RQ3dHOGf4lBC/G9saz5bKsZYHzeJB
         oyxw==
X-Gm-Message-State: AOAM530WEt+VbIC9zCaf6qgJTy3sm9UBzCx/i8jn/fd0NUptvUHVZBtu
        A56yxzsd4R/JZ6gnlY1VX8LWhHE5QOg=
X-Google-Smtp-Source: ABdhPJzb7kyQ/7O2zfVq1ci9YdLoSXARbOKCdmonALG2dmgxEORup47CRixd5mJ733cDZB7enOSNgQ==
X-Received: by 2002:a17:906:d15a:: with SMTP id br26mr3666424ejb.390.1639769661210;
        Fri, 17 Dec 2021 11:34:21 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.117])
        by smtp.gmail.com with ESMTPSA id e4sm3327197ejs.13.2021.12.17.11.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 11:34:20 -0800 (PST)
Message-ID: <aebc5433-258d-2d36-9e38-36860b99a669@gmail.com>
Date:   Fri, 17 Dec 2021 19:33:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [POC RFC 0/3] support graph like dependent sqes
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
 <4ef630f4-54d8-e8c6-8622-dccef5323864@gmail.com>
 <7607c0f9-cad3-cfc5-687e-07dc82684b4e@linux.alibaba.com>
 <06e21b01-a168-e25f-1b42-97789392bd89@gmail.com>
 <c6e18c00-7c1b-d1e9-a152-91b86f426289@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c6e18c00-7c1b-d1e9-a152-91b86f426289@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/21 16:55, Hao Xu wrote:
> 在 2021/12/15 上午2:16, Pavel Begunkov 写道:
>> On 12/14/21 16:53, Hao Xu wrote:
>>> 在 2021/12/14 下午11:21, Pavel Begunkov 写道:
>>>> On 12/14/21 05:57, Hao Xu wrote:
>>>>> This is just a proof of concept which is incompleted, send it early for
>>>>> thoughts and suggestions.
>>>>>
>>>>> We already have IOSQE_IO_LINK to describe linear dependency
>>>>> relationship sqes. While this patchset provides a new feature to
>>>>> support DAG dependency. For instance, 4 sqes have a relationship
>>>>> as below:
>>>>>        --> 2 --
>>>>>       /        \
>>>>> 1 ---          ---> 4
>>>>>       \        /
>>>>>        --> 3 --
>>>>> IOSQE_IO_LINK serializes them to 1-->2-->3-->4, which unneccessarily
>>>>> serializes 2 and 3. But a DAG can fully describe it.
>>>>>
>>>>> For the detail usage, see the following patches' messages.
>>>>>
>>>>> Tested it with 100 direct read sqes, each one reads a BS=4k block data
>>>>> in a same file, blocks are not overlapped. These sqes form a graph:
>>>>>        2
>>>>>        3
>>>>> 1 --> 4 --> 100
>>>>>       ...
>>>>>        99
>>>>>
>>>>> This is an extreme case, just to show the idea.
>>>>>
>>>>> results below:
>>>>> io_link:
>>>>> IOPS: 15898251
>>>>> graph_link:
>>>>> IOPS: 29325513
>>>>> io_link:
>>>>> IOPS: 16420361
>>>>> graph_link:
>>>>> IOPS: 29585798
>>>>> io_link:
>>>>> IOPS: 18148820
>>>>> graph_link:
>>>>> IOPS: 27932960
>>>>
>>>> Hmm, what do we compare here? IIUC,
>>>> "io_link" is a huge link of 100 requests. Around 15898251 IOPS
>>>> "graph_link" is a graph of diameter 3. Around 29585798 IOPS
>>
>> Diam 2 graph, my bad
>>
>>
>>>> Is that right? If so it'd more more fair to compare with a
>>>> similar graph-like scheduling on the userspace side.
>>>
>>> The above test is more like to show the disadvantage of LINK
>>
>> Oh yeah, links can be slow, especially when it kills potential
>> parallelism or need extra allocations for keeping state, like
>> READV and WRITEV.
>>
>>
>>> But yes, it's better to test the similar userspace  scheduling since
>>>
>>> LINK is definitely not a good choice so have to prove the graph stuff
>>>
>>> beat the userspace scheduling. Will test that soon. Thanks.
>>
>> Would be also great if you can also post the benchmark once
>> it's done
> 
> Wrote a new test to test nop sqes forming a full binary tree with (2^10)-1 nodes,
> which I think it a more general case.  Turns out the result is still not stable and
> the kernel side graph link is much slow. I'll try to optimize it.

That's expected unfortunately. And without reacting on results
of previous requests, it's hard to imagine to be useful. BPF may
have helped, e.g. not keeping an explicit graph but just generating
new requests from the kernel... But apparently even with this it's
hard to compete with just leaving it in userspace.

> Btw, is there any comparison data between the current io link feature and the
> userspace scheduling.

Don't remember. I'd try to look up the cover-letter for the patches
implementing it, I believe there should've been some numbers and
hopefully test description.

fwiw, before io_uring mailing list got established patches/etc.
were mostly going through linux-block mailing list. Links are old, so
patches might be there.

-- 
Pavel Begunkov
