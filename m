Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6155C474658
	for <lists+io-uring@lfdr.de>; Tue, 14 Dec 2021 16:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhLNPVz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Dec 2021 10:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbhLNPVz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Dec 2021 10:21:55 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAF9C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Dec 2021 07:21:54 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r25so63668876edq.7
        for <io-uring@vger.kernel.org>; Tue, 14 Dec 2021 07:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eNMm154lYl+0BKcaAnxSRcJ29+dBao7bDl+vO3CoxW0=;
        b=axbuwKCfIaoNEdMJAziEg15toonL8iNzuWa6W1hSYMt8yQsCrq1RGeox5LTe03XE0H
         zEOIBS/Rp7RUfcp4ZjQqN9ip2tajc7WeCPZjgqMYeaZjemYJ4601/+iOgzb4QJr6MN59
         2ap+KClDRHtVg/7f5Tkn+k7oESR6CxebpsivRwCocCNfKWYuKyc38Y3EF+th/FWV3nju
         WRNokUDYqUxvNx+FP0378q5deA1CS/Gd+6xJhUrkSF0rw6qqPvspoEp5GlEYE0K/IE1z
         D1lBmyCcUtpYo2VPa5/AmafDeyeRhhtOzvymdRQIy0sNT4lkS1Zh0FfVB04v7hawJHBs
         W/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eNMm154lYl+0BKcaAnxSRcJ29+dBao7bDl+vO3CoxW0=;
        b=GO7YOTVfQ78G1Rcx7nRlo+AfKHMFzUrtJ+b26L+tV/Y9WQ8MtKSFLtA46AKZolxQlJ
         Epjfz9/THNXkxkkSswoqkL0oYRflcBz69dD7B667haoDBhc5b1F7WQGn9jRlaO7+XDXP
         K7sANh3FFf+1s1hBogUPk2eK8MSkkZze8bZDSEXaelv5gMECoBvG4wDBr5GSBE/hlXe3
         +rY2tzHzSJIdVDqRYYxU+VRIvuRVqCZ00SHB07T2PAFLLDggrkfUUpYQqPFRhE/GZwg2
         GjtmHddCNGs/yjxum7hCHR3PTOPH6Pc21ELjQF6laNepDb2E6RgNnUdLgMcbimmOQn93
         oldg==
X-Gm-Message-State: AOAM530EcE1rgI7KBVyUBMTXTb3tkG5nmMGgvw8bMNWSQHNJV663b0N0
        7jmIvo1b5NsgocnWsQuagl5kYH7O7e4=
X-Google-Smtp-Source: ABdhPJx6dpcf2wgLN9k/nb1hREn8Mx2Z1xuvbgSONk1CiTWOng+rfXWWy99zVeYwyC3bZxWrKMkFNQ==
X-Received: by 2002:a05:6402:4312:: with SMTP id m18mr8614000edc.273.1639495313348;
        Tue, 14 Dec 2021 07:21:53 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id s4sm20149ejn.25.2021.12.14.07.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 07:21:52 -0800 (PST)
Message-ID: <4ef630f4-54d8-e8c6-8622-dccef5323864@gmail.com>
Date:   Tue, 14 Dec 2021 15:21:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [POC RFC 0/3] support graph like dependent sqes
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211214055734.61702-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/21 05:57, Hao Xu wrote:
> This is just a proof of concept which is incompleted, send it early for
> thoughts and suggestions.
> 
> We already have IOSQE_IO_LINK to describe linear dependency
> relationship sqes. While this patchset provides a new feature to
> support DAG dependency. For instance, 4 sqes have a relationship
> as below:
>        --> 2 --
>       /        \
> 1 ---          ---> 4
>       \        /
>        --> 3 --
> IOSQE_IO_LINK serializes them to 1-->2-->3-->4, which unneccessarily
> serializes 2 and 3. But a DAG can fully describe it.
> 
> For the detail usage, see the following patches' messages.
> 
> Tested it with 100 direct read sqes, each one reads a BS=4k block data
> in a same file, blocks are not overlapped. These sqes form a graph:
>        2
>        3
> 1 --> 4 --> 100
>       ...
>        99
> 
> This is an extreme case, just to show the idea.
> 
> results below:
> io_link:
> IOPS: 15898251
> graph_link:
> IOPS: 29325513
> io_link:
> IOPS: 16420361
> graph_link:
> IOPS: 29585798
> io_link:
> IOPS: 18148820
> graph_link:
> IOPS: 27932960

Hmm, what do we compare here? IIUC,
"io_link" is a huge link of 100 requests. Around 15898251 IOPS
"graph_link" is a graph of diameter 3. Around 29585798 IOPS

Is that right? If so it'd more more fair to compare with a
similar graph-like scheduling on the userspace side.

submit(req={1});
wait(nr=1);
submit({2-99});
wait(nr=98);
submit(req={100});
wait(nr=1);


> Tested many times, numbers are not very stable but shows the difference.
> 
> something to concern:
> 1. overhead to the hot path: several IF checks
> 2. many memory allocations
> 3. many atomic_read/inc/dec stuff
> 
> many things to be done:
> 1. cancellation, failure path
> 2. integrate with other features.
> 3. maybe need some cache design to overcome the overhead of memory
>     allcation
> 4. some thing like topological sorting to avoid rings in the graph
> 
> Any thoughts?
> 
> Hao Xu (3):
>    io_uring: add data structure for graph sqe feature
>    io_uring: implement new sqe opcode to build graph like links
>    io_uring: implement logic of IOSQE_GRAPH request
> 
>   fs/io_uring.c                 | 231 +++++++++++++++++++++++++++++++++-
>   include/uapi/linux/io_uring.h |   9 ++
>   2 files changed, 235 insertions(+), 5 deletions(-)
> 

-- 
Pavel Begunkov
