Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5C12C1688
	for <lists+io-uring@lfdr.de>; Mon, 23 Nov 2020 21:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbgKWU2m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Nov 2020 15:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729369AbgKWU2l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Nov 2020 15:28:41 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCD8C0613CF;
        Mon, 23 Nov 2020 12:28:40 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id x22so544578wmc.5;
        Mon, 23 Nov 2020 12:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JF92Ap9pQq6g3y0WEz7b0UsYbEc+bqYHK8US2snmSeo=;
        b=GY4VQbahRN8elTYkZlz7wW7Z3zAuOwHooXAVjrqrMvZQ33FvSQTdSfri3jjkV1R2jt
         y5/q8DkR9qkrWFiEn8HMMasiYP1r1M1hevpoZQjrnYYlEMDzilznvAVhhJlP+740lcCc
         0fX8iQOcCxCietrgZVr7GI/euURIR6P6JNdcdrPMQVL9fL1Zmx30EMyEL42Qr0refwQZ
         oyvSFoQnIxPLX54eQr8JtG5p3f6AP2FFjmuSpaplL8Vms91guPw4raFgNDKk2K0BIwBA
         pkAiyc0ZU/1IiC20elp3jXIMTbBUf9aWoFbbTteP3leg8nUSmfbpIhazJeG6+rxkH1X1
         LqFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JF92Ap9pQq6g3y0WEz7b0UsYbEc+bqYHK8US2snmSeo=;
        b=tywEEOpOVF9n0A8/2TzOHhdJeNqJH0BU5LWQhrme0IRXSyhRn+nrHsnn+qux8v/sas
         FnhU7biY8n/EvghrQxMLoT6UOcvk1ZCQPcV6ckninTuO7MFD5xhgXVUna2SUZrlZIywL
         LN7WD7FFLIdQKicAjt+WS5+uLN9UMEmk1Fqdy1qUpPFLOyNZjJM7lqEeeSqPjyZq+2st
         6CwqVkcmhZFLXcswU3vvSqFt5/daIP9079YE0sVsAhyzk7gnzsPlZIgIYHp2tww6j50P
         tPbTZiUge481NKAql965Dp5GPN/BUR8Z4AS6fLp8ImmDKP+sGO+9RIWTj7DUUg0qoRW3
         LaXg==
X-Gm-Message-State: AOAM531zSz5FAYBf2VCWmO9v2ZlHMMOvfFSosnMOAiNMw5H7gsSG9zz9
        4cGjzcCsirrVAYFse1M4Sqc=
X-Google-Smtp-Source: ABdhPJwW8YSLI6zMD2OCHTi4wn/kQCYiiPRFN3+6wEWYj15MmxAxu/R4j25lXFV5MQEEtiJEs+CSMw==
X-Received: by 2002:a1c:2dc8:: with SMTP id t191mr632165wmt.73.1606163318879;
        Mon, 23 Nov 2020 12:28:38 -0800 (PST)
Received: from [192.168.1.159] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id 140sm809533wme.14.2020.11.23.12.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 12:28:38 -0800 (PST)
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, will@kernel.org
References: <0000000000002bea4605b4a5931d@google.com>
 <20201122030421.2088-1-hdanton@sina.com>
 <20201122092003.7724-1-hdanton@sina.com>
 <20201123073426.1951-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: INFO: task hung in __io_uring_files_cancel
Message-ID: <eec45499-8b3c-f17f-8d20-a3eaa4144c07@gmail.com>
Date:   Mon, 23 Nov 2020 20:25:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201123073426.1951-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/11/2020 07:34, Hillf Danton wrote:
[...]
> After staring the report and 311daef8013a a bit more, it seems that we
> can have a simpler fix without the help of wakeup. It is implemented
> by busy waiting until there is no more request in flight found.

I think it's better not. It doesn't happen instantly, so may take a
lot of spinning in some cases. Moreover, I don't want an unkillable
task eating up all CPU if this hangs again (eg because of some other
case).

And, I'd love to keep it working similarly to __io_uring_task_cancel()
to not think twice about all corner cases.

> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6077,13 +6077,10 @@ static int io_req_defer(struct io_kiocb
>  static void io_req_drop_files(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
> -	struct io_uring_task *tctx = req->task->io_uring;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&ctx->inflight_lock, flags);
>  	list_del(&req->inflight_entry);
> -	if (atomic_read(&tctx->in_idle))
> -		wake_up(&tctx->wait);
>  	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
>  	req->flags &= ~REQ_F_INFLIGHT;
>  	put_files_struct(req->work.identity->files);
> @@ -8706,7 +8703,6 @@ static void io_uring_cancel_files(struct
>  	while (!list_empty_careful(&ctx->inflight_list)) {
>  		struct io_task_cancel cancel = { .task = task, .files = NULL, };
>  		struct io_kiocb *req;
> -		DEFINE_WAIT(wait);
>  		bool found = false;
>  
>  		spin_lock_irq(&ctx->inflight_lock);
> @@ -8718,9 +8714,6 @@ static void io_uring_cancel_files(struct
>  			found = true;
>  			break;
>  		}
> -		if (found)
> -			prepare_to_wait(&task->io_uring->wait, &wait,
> -					TASK_UNINTERRUPTIBLE);
>  		spin_unlock_irq(&ctx->inflight_lock);
>  
>  		/* We need to keep going until we don't find a matching req */
> @@ -8733,7 +8726,6 @@ static void io_uring_cancel_files(struct
>  		/* cancellations _may_ trigger task work */
>  		io_run_task_work();
>  		schedule();
> -		finish_wait(&task->io_uring->wait, &wait);
>  	}
>  }
>  
> 

-- 
Pavel Begunkov
