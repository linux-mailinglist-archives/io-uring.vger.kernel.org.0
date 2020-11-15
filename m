Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8B42B3506
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 14:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgKONLI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 08:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgKONLH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 08:11:07 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EC6C0613D1
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 05:11:06 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id b6so15744899wrt.4
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 05:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mMywW46urYuWGkWlimdeeNtWZNKoSPUrMvsoXCCyDGw=;
        b=SNKj2lF5C27D5Vsi43OSJ9dar8y+5W+4iY9mgeNPAwlUPx/j6W2eeGmplO1AGF/L+7
         7qxeC2yVE+5trg8EgSgO20LTHxrK8sCQg3GZImdAGSgc5bRN/GdGtV4RX/GhTk1aJXlA
         N/j5cTukjIoEQIYngLA4gIy8sv5Mb6VMip51m6CwjAl7OZ4De3PRTA1loFNdevWyYkno
         uFsqQYT5GBJcJOgyA6p2EViwjZr6kfMkdRAQHk4hvhnDyFW4N6ZZOGJ4kv4hKlmvt3v0
         5byLIshqhrOYd3RfnJUidK2FXgmqAijlbXd6d9BUIbVQYZ0wc6mC2OwhM+Fsjm8X7lOh
         RMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mMywW46urYuWGkWlimdeeNtWZNKoSPUrMvsoXCCyDGw=;
        b=PlQycU8sJQCVFHhdiVu5W3rQtTCyD54vqcgAJeIIkz4M1/E2Q4u9WfRyvi5QUJ0QmN
         M0hj/XCKR9XCjOAhVFZJ9aDNifk+n8EaRB7A1olpoizVPXf/QrDeT+Ob+pGsWY2mzD3J
         GmS5ash2BkIt1QsCv5x9Z+CBkpZSpqPazLksPRbaVqYI+T8sucWJu15HjGIUFUewiySq
         PI8wA67x1XF+T+aC1UZVDFyTsWjS23qJWapnhJ+o69NOu1Q6NyWXzL/ZhatFH+VuOItJ
         lr9dgbkLGi96iU5Nyl+y1RkvUtpknmXbjlaJV5p3IXKuZuHavlKYiSWOVCtdvMMJEX/+
         0RtQ==
X-Gm-Message-State: AOAM533bq7JpJjQM9qlHR3NvLMuNzWK9/4lybFmRatofd1n0ALXd/InM
        1dxCuizwFaiaZL2TbZ9HxwYq93bXsrGyIQ==
X-Google-Smtp-Source: ABdhPJylpIh9vhY3HU2qOxGPitJlfw/EXsQo7hpzsU0vrkb7htyl9CIJZy+a4AAHKuSM6oVivDJ0pA==
X-Received: by 2002:a5d:548b:: with SMTP id h11mr14511125wrv.306.1605445865311;
        Sun, 15 Nov 2020 05:11:05 -0800 (PST)
Received: from [192.168.1.33] (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id r9sm19871071wrg.59.2020.11.15.05.11.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2020 05:11:04 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: don't take fs for recvmsg/sendmsg
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <a09e69abbe0382f5842cd0a69e51fab100aa988c.1604754488.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <8917ccd6-7ce8-1082-aa70-f421ff1a433b@gmail.com>
Date:   Sun, 15 Nov 2020 13:07:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a09e69abbe0382f5842cd0a69e51fab100aa988c.1604754488.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/11/2020 13:20, Pavel Begunkov wrote:
> We don't even allow not plain data msg_control, which is disallowed in
> __sys_{send,revb}msg_sock(). So no need in fs for IORING_OP_SENDMSG and
> IORING_OP_RECVMSG. fs->lock is less contanged not as much as before, but
> there are cases that can be, e.g. IOSQE_ASYNC.

This one is still good to go. If anyone needs fs, etc. for msg_control,
IMHO it should be done in a different way not penalising others. 
i.e. grabbing it in io_prep_async_work().

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2e435b336927..8d721a652d61 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -849,8 +849,7 @@ static const struct io_op_def io_op_defs[] = {
>  		.pollout		= 1,
>  		.needs_async_data	= 1,
>  		.async_size		= sizeof(struct io_async_msghdr),
> -		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
> -						IO_WQ_WORK_FS,
> +		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
>  	},
>  	[IORING_OP_RECVMSG] = {
>  		.needs_file		= 1,
> @@ -859,8 +858,7 @@ static const struct io_op_def io_op_defs[] = {
>  		.buffer_select		= 1,
>  		.needs_async_data	= 1,
>  		.async_size		= sizeof(struct io_async_msghdr),
> -		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
> -						IO_WQ_WORK_FS,
> +		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
>  	},
>  	[IORING_OP_TIMEOUT] = {
>  		.needs_async_data	= 1,
> 

-- 
Pavel Begunkov
