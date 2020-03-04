Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5211790E4
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 14:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387992AbgCDNH6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 08:07:58 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55797 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387776AbgCDNH6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 08:07:58 -0500
Received: by mail-wm1-f67.google.com with SMTP id 6so2008695wmi.5
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 05:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dw7yFnXVIwTUIwGPdh/QGpKt0AsNfveoCp5EcTASH+8=;
        b=oHbd8PFXg5Ln9LFJYIrcqNS0uq9+pQdrYPlFsCA1vpMKZUucg5iYNUVQPZEpsDizhk
         w3fR8MtnPCiwzhgJ6tKx0AOuP3wTHovuFBVP6NfMe76i7j0bV7J5+PnxNNx0HCt/Cy7I
         GsGchZtt9TLCqwmpXjCLkACKt41ln1fpN/MWcJ3Q2DEhpDMrWMf1v/pPyx/Fw3nGYt9s
         aijbnYynJK8vKp6SFZNf8Yof2O6D85ZKZJ6w5Q6xmaJRIs4xuLnyNRSICwrv04Al3qXn
         5QK3ZaWuIic846NEt881lhEcgc7jhe3dcnvEYDlUNPdUHUJVYyDAox7F5g+j1wf41Gve
         oqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Dw7yFnXVIwTUIwGPdh/QGpKt0AsNfveoCp5EcTASH+8=;
        b=PxC9kwc08dbyHXwmzGooH7OY1wk45uFZdTk4Fz+EO8tNnJGQmi6DQeBiyurz1qcxbI
         Iq3CWFwgrM+Eh6gKymPgZ/9yFbbOrZsFW3rpWWhXXxEN1K3CGZtVYlbZWnkZT4yDUY5R
         OhAAo5EaPAlyUzG20pJMjcNey2X/whCGnUfYJlBhuzaMtPrhJWhuWt3fFhaJLHvC4XrB
         809KfJZNRNggS93RT7ei3pfEg5SP8wFS2VvsDH42sCqwnRbkioCs1wjhG9FrvNdzHkOa
         INSWXatZ4Vcir+WwuRFqsjibYbDlrFJgyg/vSGPZ/b52/3uLJ72wxqWCcl0xOj1R4v0G
         LAHw==
X-Gm-Message-State: ANhLgQ0WAwRQKEjvC3QuKnjd2s5x71FpA/p2dlWa/Q1ClgvtfwS9G6JF
        5XbQL+GL2Oe7uQ8ESpFiV6c=
X-Google-Smtp-Source: ADFU+vtQRQn34R7dltpDqAVOJbmosG5SHZPVUxN9ypcqpX4elJZgmc8dXThO4fLDqd5LsoLILcTcVg==
X-Received: by 2002:a05:600c:2f10:: with SMTP id r16mr1204903wmn.46.1583327275652;
        Wed, 04 Mar 2020 05:07:55 -0800 (PST)
Received: from [192.168.43.187] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id a7sm40754952wrm.29.2020.03.04.05.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 05:07:55 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     jlayton@kernel.org
References: <20200303235053.16309-1-axboe@kernel.dk>
 <20200303235053.16309-3-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/4] io_uring: move CLOSE req->file checking into handler
Message-ID: <a90767a7-f930-8e0c-b816-b4eb90452c58@gmail.com>
Date:   Wed, 4 Mar 2020 16:07:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200303235053.16309-3-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/03/2020 02:50, Jens Axboe wrote:
> In preparation for not needing req->file in on the prep side at all.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0464efbeba25..9d5e49a39dba 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3367,10 +3367,6 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return -EBADF;
>  
>  	req->close.fd = READ_ONCE(sqe->fd);
> -	if (req->file->f_op == &io_uring_fops ||
> -	    req->close.fd == req->ctx->ring_fd)
> -		return -EBADF;
> -
>  	return 0;
>  }
>  
> @@ -3400,6 +3396,10 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
>  {
>  	int ret;
>  
> +	if (req->file->f_op == &io_uring_fops ||
> +	    req->close.fd == req->ctx->ring_fd)
> +		return -EBADF;
> +

@ring_fd's and @ring_file's lifetimes are bound by call to io_submit_sqes(), and
they're undefined outside. For the same reason both of them should be used with
ctx->uring_lock hold.


>  	req->close.put_file = NULL;
>  	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
>  	if (ret < 0)
> 

-- 
Pavel Begunkov
