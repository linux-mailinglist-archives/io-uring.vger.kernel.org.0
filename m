Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758C016F116
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 22:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgBYVXF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 16:23:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42264 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbgBYVXE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 16:23:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id p18so391487wre.9
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 13:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=56mz9ustrTDZePuxGS4fxd/f00qQHqZxYu9f6gHZSY8=;
        b=VPnx91C8h0PdOjJpPg0gblt8vOMOJPINg1ptW57J6gs/mLQolG2x887NHtRwHyn8QX
         n0fNJTDB2HF/CsbW15NhU5iSIfz8NYTB1/ni+rW3QABqTsYEPqvGnBygYVesUE4tyooI
         0DLxyQ7M4gRuOVsxC54atVo/pdN1AzVyH2DRAm3jY0sxU/oXWN1yCCj8IU7lOhsIU6R6
         /hGIJpm3Ev/dDBGfUiijCFwt+wZowt8iOB+qPwKy4WblqOw8vAxH8cIPJ6ejaf2sUHM7
         uyh+b+1cU/eKv7JinMnEqB153OcYvQLFsUhkUI1u9QwpSK1hem1UbX7itS7s6Ui9Nocc
         UFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=56mz9ustrTDZePuxGS4fxd/f00qQHqZxYu9f6gHZSY8=;
        b=JsksHzrxzLjYHxAtH10Za3AIQ6x9w5rN6XqB5Qfn4zz+HY3MXM/6svunQKHPg7byVT
         1Mor1MqOVOKfTdge7+IK2VoA+TwKUFoKVY33fp51gCwB5TjZ97rsySDOdzvh4bFnTrqk
         3Q9MH1XMT+MkBoMtpDlIH7deeAxkz+43EhrsL/3LPxWd3j9BXuhXH6Dul0nelQb7iquU
         FviMI6jrvqQ0SGx1/5R9cIo3df4n0yzgSsTZHEXxcI/3FMPQtlk8VD2Zvg2dIBx1ctu2
         tIWkwTs6MXbURkFMO2joMzSfgfLwX99HpZKURO/DyA94cG/rc/eH0/eWkuskA3kB6FfF
         D/5Q==
X-Gm-Message-State: APjAAAWB7aW6Nc8ftV7pZuKJ4aLRX4HCBkh7Lp76mMWvyT0+vhTk/al7
        U4399SjzU9mN4jY83D0JAYxX8/3P
X-Google-Smtp-Source: APXvYqw7ES/2aRso3xUk0qJvy9FxUWYktS2L4V3jZUnnldsWcMlggC8jiN515Ka8vjabjJHevHvCXg==
X-Received: by 2002:adf:e40f:: with SMTP id g15mr1024322wrm.223.1582665781417;
        Tue, 25 Feb 2020 13:23:01 -0800 (PST)
Received: from [192.168.43.62] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id a16sm146585wrx.87.2020.02.25.13.22.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 13:23:00 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
Message-ID: <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
Date:   Wed, 26 Feb 2020 00:22:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/02/2020 23:27, Jens Axboe wrote:
> If work completes inline, then we should pick up a dependent link item
> in __io_queue_sqe() as well. If we don't do so, we're forced to go async
> with that item, which is suboptimal.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ffd9bfa84d86..160cf1b0f478 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4531,8 +4531,15 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
>  		} while (1);
>  	}
>  
> -	/* drop submission reference */
> -	io_put_req(req);
> +	/*
> +	 * Drop submission reference. In case the handler already dropped the
> +	 * completion reference, then it didn't pick up any potential link
> +	 * work. If 'nxt' isn't set, try and do that here.
> +	 */
> +	if (nxt)

It can't even get here, because of the submission ref, isn't it? would the
following do?

-	io_put_req(req);
+	io_put_req_find_next(req, &nxt);

BTW, as I mentioned before, it appears to me, we don't even need completion ref
as it always pinned by the submission ref. I'll resurrect the patches doing
that, but after your poll work will land.


> +		io_put_req(req);
> +	else
> +		io_put_req_find_next(req, &nxt);
>  
>  	if (ret) {
>  		req_set_fail_links(req);
> 

-- 
Pavel Begunkov
