Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564862D9E3A
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 18:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408735AbgLNRwH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 12:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405812AbgLNRwE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 12:52:04 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A528C0613D3
        for <io-uring@vger.kernel.org>; Mon, 14 Dec 2020 09:51:24 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id 91so17302019wrj.7
        for <io-uring@vger.kernel.org>; Mon, 14 Dec 2020 09:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NUxCcPefukTxqUhkLs8pyFA45MJnkMkQsBmKnb00gP8=;
        b=OzMf3XpnZY3ZzywguwkzKdSVonOKYV4pE6xqrH/iisa6xp3EG7qkZ5hGn9dtzC+1tV
         ihK36mUCw602M3aBcPGO7PSCB/g6IXvva8fDDgNAE3w27hzRm8QSLBFneOF/P5ASSYkr
         97bOCad7wGlRTXnFNCGMPMsBQeXoXRoG3R5SrM4x+IjHimguGdSLXFiax+mB7w4GJuCm
         EQTyf8MdJZNhTV6OSzOSU8X/iyFN8je3itkndOKfvmPrSBPshYvqwd9GyrgARJ0aVcnk
         3p70zEmXf6YY2hjaNITCZw5YrQu18lwgT66gYYAHYxrLLr0wAOjxkPdwPidHoSzgzb/8
         wLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NUxCcPefukTxqUhkLs8pyFA45MJnkMkQsBmKnb00gP8=;
        b=s6CW7KFlq0FhvRthTh4+pvXZy3+TpowBnaDQ0TijpxctmNTQE7NuMtz5JzMz9hUbEA
         f69oeaCAa0rmcyZj8/ZWvMWDGgjtk1oIYJ6/FgbW8+cjpeG96Ep/V612ktrJJU69mDA7
         IvAKqlVvZ4d5onsl7FAGQ0J8Q0UQFuvN8WIJNaKiVOmIc26JintIOsp1eCuGCp3giqmF
         nGkqcad3ed1a8skRv8daqmlCs97wqnbTgtglwhCqqsjHBwTkapE3g207XNOUw+GEXVeU
         Bj/9QYWVMdwG1adSHRBrPJIsOuydudnzrRz2uKAx+GVygoxwVN3GyWt+jSOrF2msYNxT
         tUoQ==
X-Gm-Message-State: AOAM532PtxvXwzSfdN1nR1yNyobVDo14oJwajjgLo5PU1KOV16l5dPWm
        zfGuclVAAORI7kTSRNpxM37q22uGpBeS+w==
X-Google-Smtp-Source: ABdhPJwWDOZEew4OS1COeuymjS+a8LcNYYTSs6SJDqAbGyn/nEbHzY1zOB/K4SGpCsV7qkXn6ODK4g==
X-Received: by 2002:adf:92a4:: with SMTP id 33mr29859716wrn.347.1607968282785;
        Mon, 14 Dec 2020 09:51:22 -0800 (PST)
Received: from [192.168.8.128] ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id n17sm30489416wmc.33.2020.12.14.09.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 09:51:22 -0800 (PST)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20201214154941.10907-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: hold uring_lock to complete faild polled io in
 io_wq_submit_work()
Message-ID: <23ec9427-e904-f87f-2345-d040d9b10673@gmail.com>
Date:   Mon, 14 Dec 2020 17:48:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201214154941.10907-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/12/2020 15:49, Xiaoguang Wang wrote:
> io_iopoll_complete() does not hold completion_lock to complete polled
> io, so in io_wq_submit_work(), we can not call io_req_complete() directly,
> to complete polled io, otherwise there maybe concurrent access to cqring,
> defer_list, etc, which is not safe. Commit dad1b1242fd5 ("io_uring: always
> let io_iopoll_complete() complete polled io") has fixed this issue, but
> Pavel reported that IOPOLL apart from rw can do buf reg/unreg requests(
> IORING_OP_PROVIDE_BUFFERS or IORING_OP_REMOVE_BUFFERS), so the fix is
> not good.
> 
> Given that io_iopoll_complete() is always called under uring_lock, so here
> for polled io, we can also get uring_lock to fix this issue.

One thing I don't like is that io_wq_submit_work() won't be able to
publish an event while someone polling io_uring_enter(ENTER_GETEVENTS),
that's because both take the lock. The problem is when the poller waits
for an event that is currently in io-wq (i.e. io_wq_submit_work()).
The polling loop will eventually exit, so that's not a deadlock, but
latency,etc. would be huge.

> 
> Fixes: dad1b1242fd5 ("io_uring: always let io_iopoll_complete() complete polled io")
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f53356ced5ab..eab3d2b7d232 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6354,19 +6354,24 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
>  	}
>  
>  	if (ret) {
> +		bool iopoll_enabled = req->ctx->flags & IORING_SETUP_IOPOLL;
> +
>  		/*
> -		 * io_iopoll_complete() does not hold completion_lock to complete
> -		 * polled io, so here for polled io, just mark it done and still let
> -		 * io_iopoll_complete() complete it.
> +		 * io_iopoll_complete() does not hold completion_lock to complete polled
> +		 * io, so here for polled io, we can not call io_req_complete() directly,
> +		 * otherwise there maybe concurrent access to cqring, defer_list, etc,
> +		 * which is not safe. Given that io_iopoll_complete() is always called
> +		 * under uring_lock, so here for polled io, we also get uring_lock to
> +		 * complete it.
>  		 */
> -		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
> -			struct kiocb *kiocb = &req->rw.kiocb;
> +		if (iopoll_enabled)
> +			mutex_lock(&req->ctx->uring_lock);
>  
> -			kiocb_done(kiocb, ret, NULL);
> -		} else {
> -			req_set_fail_links(req);
> -			io_req_complete(req, ret);
> -		}
> +		req_set_fail_links(req);
> +		io_req_complete(req, ret);
> +
> +		if (iopoll_enabled)
> +			mutex_unlock(&req->ctx->uring_lock);
>  	}
>  
>  	return io_steal_work(req);
> 

-- 
Pavel Begunkov
