Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90AB20F555
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 15:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388159AbgF3NA6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 09:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387860AbgF3NA5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 09:00:57 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B36AC061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 06:00:57 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id a8so14871811edy.1
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 06:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k19d2NeP6ucfNCFesRl5wzbtw02xSfLv9JBqqqEusLQ=;
        b=eOz/Ur+Aw92PrkQZhvJu5xdiTGcMP9wPDiQcOQ5tqExW7QlqK94p9fYH+Y0D6WNJQ0
         Vp+dsJ+Wx4GqM85Bpi/gJ4N1Drc5PueywSTfZSpEXJUrO3V2SdTiHVLZtb//5SNglRqu
         jIwPEKmGSBF40s5tQ/Iw2lAYGZxoKm4tRwwNRSEc+i5Z+NgBA2qDY9lZCQ+eLCGg7NpP
         nGOcyiGvKpEIOQNHpv8F93R+Ke20W9dj/maIQXWWhLCmKwVtFuFEkiqXeI0+NJcgEABs
         AWSSgLVExj2KDYJkvUS5PRhJkmsZe854HgaXoyA115uQgZmwmByeCt6lcaErGsjc0mB/
         W6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=k19d2NeP6ucfNCFesRl5wzbtw02xSfLv9JBqqqEusLQ=;
        b=izgGQm0CkmrGN5vlVQskLZlk4xShTIjUBx/glFs/c7eOFFe7uFenqG41yqOT8SIYmK
         idet0O5ihlgTSm2zZGzsXGjoeEk8lIYH5rQKGlE6ST8DwP4BDH0zh8H/oDgHnq3B+3j3
         vP4cCJ0v7x51+BiHT5zVWFsxYiOizs5DSkIrhLXQc0iMm/EdBYbBuoAoj9pKuN89xIsC
         yepRTSgiUnS2ZZDj+0pgNuovqV1GwoLfUxWxlL0ilMWxXu4AX+BWVYQ81JOOQzEZPTjP
         MKfdadvnn0pQ9ftj4VgWxhPCCePmvJGc3yp7Vy7M0vuR2R/2bhxIsVE8tZTDb0WQpvrE
         8+og==
X-Gm-Message-State: AOAM530dk0YgZ+oic/4S7jxGXGARjq1h3Rs2lKCIy3pl+2KIxanI/DHU
        Y96BVXb0nTO05c6zwqEfxV9g1Rm2
X-Google-Smtp-Source: ABdhPJwN/DWNB7yCVIgiFsLB/rJL+U67wIMPp4TkciVP+O4xErJwTEjVnizXCqL2T093AsYsdUQQPg==
X-Received: by 2002:a05:6402:b23:: with SMTP id bo3mr23273029edb.331.1593522056085;
        Tue, 30 Jun 2020 06:00:56 -0700 (PDT)
Received: from [192.168.43.125] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id z8sm1941289eju.106.2020.06.30.06.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 06:00:55 -0700 (PDT)
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     Dust.li@linux.alibaba.com
References: <2ebb186ebbef9c5a01e27317aae664e9011acf86.1593520864.git.xuanzhuo@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: fix req cannot arm poll after polled
Message-ID: <659c45d9-bdba-fdeb-3f7f-6e2546a11b59@gmail.com>
Date:   Tue, 30 Jun 2020 15:59:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2ebb186ebbef9c5a01e27317aae664e9011acf86.1593520864.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/06/2020 15:41, Xuan Zhuo wrote:
> For example, there are multiple sqes recv with the same connection.
> When there is no data in the connection, the reqs of these sqes will
> be armed poll. Then if only a little data is received, only one req
> receives the data, and the other reqs get EAGAIN again. However,
> due to this flags REQ_F_POLLED, these reqs cannot enter the
> io_arm_poll_handler function. These reqs will be put into wq by
> io_queue_async_work, and the flags passed by io_wqe_worker when recv
> is called are BLOCK, which may make io_wqe_worker enter schedule in the
> network protocol stack. When the main process of io_uring exits,
> these io_wqe_workers still cannot exit. The connection will not be
> actively released until the connection is closed by the peer.

It's a problem unrelated to polling, though it may be a nice optimisation.
E.g. requests submitted with IOSQE_ASYNC will always get into io-wq.

Have you seen it yourself? When, io_uring is going away, it calls
io_wq_cancel_all(), which do send_sig(SIGINT) for all its workers. The
question is why this doesn't halt inflight send/recv down in the network
stack?

> 
> So we should allow req to arm poll again.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e507737..a309832 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4406,7 +4406,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  
>  	if (!req->file || !file_can_poll(req->file))
>  		return false;
> -	if (req->flags & (REQ_F_MUST_PUNT | REQ_F_POLLED))
> +	if (req->flags & REQ_F_MUST_PUNT)

You have a bit outdated sources.

>  		return false;
>  	if (!def->pollin && !def->pollout)
>  		return false;
> 

-- 
Pavel Begunkov
