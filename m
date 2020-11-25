Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DEC2C36D5
	for <lists+io-uring@lfdr.de>; Wed, 25 Nov 2020 03:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgKYCbl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Nov 2020 21:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgKYCbl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Nov 2020 21:31:41 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22ADC0613D4
        for <io-uring@vger.kernel.org>; Tue, 24 Nov 2020 18:31:40 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id d142so692214wmd.4
        for <io-uring@vger.kernel.org>; Tue, 24 Nov 2020 18:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PBrArVvqOuNIeSnWkA4F5b9KSo6rzvUY/0qPL5nO/38=;
        b=ef0g0RUkwyt3n1a7UoMmsSiZ1rAjST8zvjwfGV489qGfDeoGhwshq4RSa2zjo6ySgM
         P8WHBkSMz5/uxHSgt5i2lw/7R7gxdRQmWtvaBI/aizyIjH627RA+Ct69+r7M2IL1iTOX
         EB0k+qXoNMSvWnu3rBvJtUZ1SX1ihp1y3e0NnEhOyuwUCuW5I1p7h7yTQrBJFgxL43AA
         H0Dqsf4+RvbytzHdzbM8zHsirPyehJcwgbeluWU3B76/Dp1H4N/vZBjDTvQP4J9/Va9c
         mEucMqlMixOyD6rq4yohGUxw2wccGPto+W+eP8PQ1VPHhpGbVJYVN9v1tpflOROFyrp5
         9iLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PBrArVvqOuNIeSnWkA4F5b9KSo6rzvUY/0qPL5nO/38=;
        b=oHxtjNb2lZ6qLlLZIT61tfL0/5tve3vSA9Xl9nKUDqOqKwjKmkhvEgBnu742u1hOvn
         m/YvoRIIjUb6o6P/byxHt2qWUkLCY8O/qdg/5BTsSNwnIqXG1zkSo7JVjVU2QL1TPlIu
         PbedmKC3JA/S/Q9o+1EiTzAem/2k/yG2bLEYMmRxaP9wHPLf7o5SnJ9AJ5wBytmKNaLx
         cS2NE0Js2cpJsWjBcHxqnJtFnyJ/Ge8eQAc1WtCzJE2uFatvdQKY6o9DlYf+xCRkDWGa
         tnc5dzaT+nbiEWaJ/gNaso6P/Kj+Jd/ezqnZDRIYkJSz3gaLPyIIybENY49dSETxEjdQ
         yw/w==
X-Gm-Message-State: AOAM531x1S1heRlbglERiyC8vBXdwv1rLVW9kvfmY/kbzQPw0gkxGeBw
        nPTnGvUodaw0SOOMzNZkRP0=
X-Google-Smtp-Source: ABdhPJwa5sxp57ISmVJrIxHIuORG/Y2Kz2QlCcG706GibGNwm3aUUw5JnMsFjNnHPvquiPGEZs3gYw==
X-Received: by 2002:a1c:c284:: with SMTP id s126mr1298398wmf.109.1606271499709;
        Tue, 24 Nov 2020 18:31:39 -0800 (PST)
Received: from [192.168.1.141] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id c187sm1665111wmd.23.2020.11.24.18.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 18:31:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com
References: <5c8308053ac64d0fc7df3610b4b05ac4ba1c6d2b.1606270482.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.11] io_uring: fix files cancellation
Message-ID: <5aa1abb2-a4bd-971a-5fc6-3a32cad15daa@gmail.com>
Date:   Wed, 25 Nov 2020 02:28:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5c8308053ac64d0fc7df3610b4b05ac4ba1c6d2b.1606270482.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/11/2020 02:19, Pavel Begunkov wrote:
> io_uring_cancel_files()'s task check condition mistakenly got flipped.
> 
> 1. There can't be a request in the inflight list without
> IO_WQ_WORK_FILES, kill this check to keep the whole condition simpler.
> 2. Also, don't call the function for files==NULL to not do such a check,
> all that staff is already handled well by its counter part,
> __io_uring_cancel_task_requests().
> 
> With that just flip the task check.
> 
> Also, it iowq-cancels all request of current task there, don't forget to
> set right ->files into struct io_task_cancel.> 
> Reported-by: syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com

So, I screwed it just recently and for-5.11. Thanks to syzkaller for 
catching this early.
Just to notice that the reproducer segfaults for me, so I haven't really
reproduced it and needs "syz test" to confirm

> Fixes: c1973b38bf639 ("io_uring: cancel only requests of current task")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7c1f255807f5..f11dc25d975c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8725,15 +8725,14 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  				  struct files_struct *files)
>  {
>  	while (!list_empty_careful(&ctx->inflight_list)) {
> -		struct io_task_cancel cancel = { .task = task, .files = NULL, };
> +		struct io_task_cancel cancel = { .task = task, .files = files };
>  		struct io_kiocb *req;
>  		DEFINE_WAIT(wait);
>  		bool found = false;
>  
>  		spin_lock_irq(&ctx->inflight_lock);
>  		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
> -			if (req->task == task &&
> -			    (req->work.flags & IO_WQ_WORK_FILES) &&
> +			if (req->task != task ||
>  			    req->work.identity->files != files)
>  				continue;
>  			found = true;
> @@ -8805,10 +8804,11 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
>  
>  	io_cancel_defer_files(ctx, task, files);
>  	io_cqring_overflow_flush(ctx, true, task, files);
> -	io_uring_cancel_files(ctx, task, files);
>  
>  	if (!files)
>  		__io_uring_cancel_task_requests(ctx, task);
> +	else
> +		io_uring_cancel_files(ctx, task, files);
>  
>  	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
>  		atomic_dec(&task->io_uring->in_idle);
> 

-- 
Pavel Begunkov
