Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035792A37AD
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 01:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgKCAU4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 19:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgKCAUz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 19:20:55 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D82C0617A6
        for <io-uring@vger.kernel.org>; Mon,  2 Nov 2020 16:20:55 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id n15so16620805wrq.2
        for <io-uring@vger.kernel.org>; Mon, 02 Nov 2020 16:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2f3QX+V7XhQojMznLFd5arWG2/XZCeIOHrjK0vl5ETU=;
        b=OKzww9xn0qQ0gJthl16g7MCRXv3ZZuCicsWqv4pQWkuioHUeubG6QLk6snNNO7lghF
         r/D64NmuG+yQbf353XxM6abSpF01dbBdAWT6toH9mi/KoFLySHYtbkreWVZm2Isu31M4
         JdiChj2NM53ZRFXqFFvhFI6XjM7MQ21ciEBXjJGY3Zt+/GcxW60CzUmK6z9M1i4260hr
         f7ynkyB+yyBi58oPQIUuwkIsrG71SqD1gCdsidBVYCOjxrbm6YwC7M0RNEMeX9Q8YmRV
         puqMcTDqrH3Rf+PNXiNHQXkD2oTOQ0GKUZG84WECxPK1omIfG9gocO8CBhwOJtwRSoWF
         McTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2f3QX+V7XhQojMznLFd5arWG2/XZCeIOHrjK0vl5ETU=;
        b=LAQaVeqDb+KW1v+iLSCeTniVsnji2BFxWH4dBKHaNwzJNfLi8akAC9XwwWYb30iCSe
         n5E+O16ogPk44SAY9LWwRN+N2+V5nKJrWExNVLYSt9xa5gAtOzVtk1xFtW6p1Sc+9sq+
         hb1vvKzO8KPiE4T+d8nR07S2AHT+8jMguwPaDrtMkmTeKRF2FnMhGT1eTnimARvWhTDw
         cZVd3lDAfDvpD6vUoFIceaw8ssxue0pZOSXcnJxlp8K4QFAWxkWONH1UwzLdPYOar3Ij
         yiv/SB9IOECMMOTPtM7AUO3zliApS7h7T+/ilf1TFJgU+JMw/BXTFt8NqdixivXHJLpj
         kb7Q==
X-Gm-Message-State: AOAM532BJQWeUDSTXBu7GQpxpVRvzM5uyMcfeS8bM5lf3A+hLSKAArsm
        atDNQ3CYPm7i2dYaCwQI1xnirEUjCgVEog==
X-Google-Smtp-Source: ABdhPJx9Lo2FBtb9LxWE5RTGxS6EMYURubfv1ZUYLf+KFLvmaxkt7mfPf1C36b1ssZfsp2y3w/K9OA==
X-Received: by 2002:adf:f381:: with SMTP id m1mr25307269wro.347.1604362854141;
        Mon, 02 Nov 2020 16:20:54 -0800 (PST)
Received: from [192.168.1.203] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id g17sm24445998wrw.37.2020.11.02.16.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 16:20:53 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Vito Caputo <vcaputo@pengaru.com>,
        io-uring@vger.kernel.org
References: <20201102205259.qsbp6yea3zfrqwuk@shells.gnugeneration.com>
 <d57e6cb2-9a2c-86a4-7d64-05816b3eab54@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: relative openat dirfd reference on submit
Message-ID: <0532ec03-1dd2-a6ce-2a58-9e45d66435b5@gmail.com>
Date:   Tue, 3 Nov 2020 00:17:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d57e6cb2-9a2c-86a4-7d64-05816b3eab54@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/11/2020 00:05, Jens Axboe wrote:
> On 11/2/20 1:52 PM, Vito Caputo wrote:
>> Hello list,
>>
>> I've been tinkering a bit with some async continuation passing style
>> IO-oriented code employing liburing.  This exposed a kind of awkward
>> behavior I suspect could be better from an ergonomics perspective.
>>
>> Imagine a bunch of OPENAT SQEs have been prepared, and they're all
>> relative to a common dirfd.  Once io_uring_submit() has consumed all
>> these SQEs across the syscall boundary, logically it seems the dirfd
>> should be safe to close, since these dirfd-dependent operations have
>> all been submitted to the kernel.
>>
>> But when I attempted this, the subsequent OPENAT CQE results were all
>> -EBADFD errors.  It appeared the submit didn't add any references to
>> the dependent dirfd.
>>
>> To work around this, I resorted to stowing the dirfd and maintaining a
>> shared refcount in the closures associated with these SQEs and
>> executed on their CQEs.  This effectively forced replicating the
>> batched relationship implicit in the shared parent dirfd, where I
>> otherwise had zero need to.  Just so I could defer closing the dirfd
>> until once all these closures had run on their respective CQE arrivals
>> and the refcount for the batch had reached zero.
>>
>> It doesn't seem right.  If I ensure sufficient queue depth and
>> explicitly flush all the dependent SQEs beforehand
>> w/io_uring_submit(), it seems like I should be able to immediately
>> close(dirfd) and have the close be automagically deferred until the
>> last dependent CQE removes its reference from the kernel side.
> 
> We pass the 'dfd' straight on, and only the async part acts on it.
> Which is why it needs to be kept open. But I wonder if we can get
> around it by just pinning the fd for the duration. Since you didn't
> include a test case, can you try with this patch applied? Totally
> untested...

afaik this doesn't pin an fd in a file table, so the app closes and
dfd right after submit and then do_filp_open() tries to look up
closed dfd. Doesn't seem to work, and we need to pass that struct
file to do_filp_open().

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 1f555e3c44cd..b3a647dd206b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3769,6 +3769,9 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>  		req->open.how.flags |= O_LARGEFILE;
>  
>  	req->open.dfd = READ_ONCE(sqe->fd);
> +	if (req->open.dfd != -1 && req->open.dfd != AT_FDCWD)
> +		req->file = fget(req->open.dfd);
> +
>  	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
>  	req->open.filename = getname(fname);
>  	if (IS_ERR(req->open.filename)) {o 
> @@ -3841,6 +3844,8 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
>  	}
>  err:
>  	putname(req->open.filename);
> +	if (req->file)
> +		fput(req->file);
>  	req->flags &= ~REQ_F_NEED_CLEANUP;
>  	if (ret < 0)
>  		req_set_fail_links(req);
> @@ -5876,6 +5881,8 @@ static void __io_clean_op(struct io_kiocb *req)
>  		case IORING_OP_OPENAT2:
>  			if (req->open.filename)
>  				putname(req->open.filename);
> +			if (req->file)
> +				fput(req->file);
>  			break;
>  		}
>  		req->flags &= ~REQ_F_NEED_CLEANUP;
> 

-- 
Pavel Begunkov
