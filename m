Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B793A7E92
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 15:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhFONFE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 09:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhFONFE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 09:05:04 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1867FC061574;
        Tue, 15 Jun 2021 06:02:59 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id f17so14099610wmf.2;
        Tue, 15 Jun 2021 06:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AjbMKCsm09CZAWwwvIw8vYSI3Rl/zjturebHnfP+ukY=;
        b=A5P2MpAN7GBV+kodYMm5PpINkdtG1PnQa7xsar3XI0bB4UeHolmYTYgGKQ3ToKzFqe
         a/f9h02TLsduYYFw/thXRuJEPQ/nnKvNOJvyIMRhvHQuQDUp2qqq84rPopL94B55lEpl
         kztEP8j84kwlXD106qghXgs8KVQoTf0nhnach3q+T2+88oMH8yMgPiyEd9dgjrttOlGn
         KkR1FaF4evRj3P9jQ32fIf+S4tDixOqMNrGwKrojTfjj9OjdIPJAmOXeHHM4Bd15nDi6
         l6qUINCXIyTeVPaSXB6ioTIThfXJ2k/r7KpU0lS7QhuM0AFiiMovYSDfoGGA2984t095
         V3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AjbMKCsm09CZAWwwvIw8vYSI3Rl/zjturebHnfP+ukY=;
        b=VQtvSyPWs3LKgr00yig7Ju6sm7tqr9uoWlIfCwe4/hYJxqGw1rMnnA79b7eSm1MJWG
         L7xLpWPOPEHf2i7k/iKvySKjPT/8kBEfRPbpxu1H/TuY/yc9PofE9Qc6dJGRiHccj2v6
         mikBawuMlKzL6whGT9bs/Syfq3M12UPjNotEwakmBCvfvPXzsHbfbS8xai7jDyZft6IV
         QXskXEj49rjlp+V2dtxF5kRo2wjV4QyZNIyO0M9Aex8gT0e+NU7sTrPDe0Lkb5iyRTJi
         qMI1e3mVFWTzzLR/bl7o4JZ/7/pA3+lY8ZRKpFtoj3fZZZ8TDlRUE+/+2XqAGCHusxSj
         qzog==
X-Gm-Message-State: AOAM532SNjo6SLOFcfmSh/cockpxBCBDRrJpwU7J8X9zAmtSyccHocgk
        5T1S5n+/Q6paeFkbvX+pFps=
X-Google-Smtp-Source: ABdhPJzVz+Y8GBPUYq5j77oXbv0JZQZgJrGTTzdvzT33GuOJYcy2wBDW/v5jWmCKXvIjN4I7ULcn5g==
X-Received: by 2002:a7b:c38f:: with SMTP id s15mr5277335wmj.16.1623762177686;
        Tue, 15 Jun 2021 06:02:57 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id n7sm1993736wmq.37.2021.06.15.06.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 06:02:57 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Fix comment of io_get_sqe
To:     Fam Zheng <fam.zheng@bytedance.com>, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        fam@euphon.net
References: <20210604164256.12242-1-fam.zheng@bytedance.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <9ab231e1-bb3f-9f18-ac17-9dc3b1a35135@gmail.com>
Date:   Tue, 15 Jun 2021 14:02:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210604164256.12242-1-fam.zheng@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/4/21 5:42 PM, Fam Zheng wrote:
> The sqe_ptr argument has been gone since 709b302faddf (io_uring:
> simplify io_get_sqring, 2020-04-08), made the return value of the
> function. Update the comment accordingly.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 903458afd56c..bb3685ba335d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6670,7 +6670,7 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
>  }
>  
>  /*
> - * Fetch an sqe, if one is available. Note that sqe_ptr will point to memory
> + * Fetch an sqe, if one is available. Note this returns a pointer to memory
>   * that is mapped by userspace. This means that care needs to be taken to
>   * ensure that reads are stable, as we cannot rely on userspace always
>   * being a good citizen. If members of the sqe are validated and then later
> 

-- 
Pavel Begunkov
