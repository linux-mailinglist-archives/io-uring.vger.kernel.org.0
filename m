Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F6125B0E4
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 18:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgIBQMR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 12:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgIBQMN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 12:12:13 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D54C061245
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 09:12:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z9so5139014wmk.1
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 09:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YkEoFDjfpJHW5vRkHs9+voRNlDythQIvwuk5GF2OQ08=;
        b=gr+f5lf3JyWJNoz9vrXHjluwOj8+tvnWAEqhGc0wJS70XLcPHvKtkqZ2Z4x0HNARLP
         Fs3bHcqRzKQccB9Iqt6f0NOfRPiIWFbqmnpmpyYb6TlYnHryTFgkKGnIDOzvCYqKms1C
         AgsnKofbLkeJVynUCumwaJw/NmQ9d+h+luHbh/Tp0QpwzlVaR7N4s4efJCB/N1c78enA
         YGOf9ttSHRW1/fpoXJCwEOwPOZWg8J6sQ1oRO7MEqH/8HNqV7caxMh/3Z9VsSmquBXQ3
         f7wtVqXlSppmGZIvQC3nvqt4a7X3owTqdyrRNtpGRQbIxbgTKUS0YLb5jUTZwVequMxs
         Jfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=YkEoFDjfpJHW5vRkHs9+voRNlDythQIvwuk5GF2OQ08=;
        b=NDdCowtJhxTK5OIVlXVrrjNzjp5QMehVvIWEhZyVACYt+FG6SNgSBNr62WcbCHf8O/
         mYAKhGylE0MX4TEnzSbeqoBGKt6RIsYQz1qmLddl2lCtpKyU5w4RUH1vWonToSzzBHwm
         wtC9xnANxir/WPmkZZlTOfuRK97NCbreFzf5l4l7rBnc/GwG8XYVCXpngYVM/hULooS9
         2LPiMBNqVybemhvTywKOnvdCEo/8hEuS4KEwoumg9J7gWNPTjZsqgOWbd7QKJaP9qRjV
         4arl0ouVeaNK9WwB4vkVnjmigbA3bdbN33sXRzLJmFux6jMmmNnbnnulc4R5cBjhb/wl
         MEjg==
X-Gm-Message-State: AOAM533bW/NO4dmekrUELp9P8OIa01xQaZO3uJ42PCzh+ujBl2BofuYN
        aoYuoitiZrOj9t7QXnlIXg8=
X-Google-Smtp-Source: ABdhPJxvykuMa6P+9FJ4+Mjtw002dPupsjzuhv3Ix3P5EFOcxv0QVpzaAdpSCUItcvDsbpUddvDxzQ==
X-Received: by 2002:a7b:c255:: with SMTP id b21mr1362746wmj.17.1599063132247;
        Wed, 02 Sep 2020 09:12:12 -0700 (PDT)
Received: from [192.168.43.65] ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id v24sm317170wrd.6.2020.09.02.09.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 09:12:11 -0700 (PDT)
Subject: Re: [PATCH] io_uring: no read-retry on -EAGAIN error and O_NONBLOCK
 marked file
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Norman Maurer <norman.maurer@googlemail.com>
References: <5d91a8ea-5748-803a-d2dc-ef21fe27e39e@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <cdc949ce-059b-2f4f-bb16-f4e9554eb975@gmail.com>
Date:   Wed, 2 Sep 2020 19:09:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5d91a8ea-5748-803a-d2dc-ef21fe27e39e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/09/2020 19:00, Jens Axboe wrote:
>     Actually two things that need fixing up here:
>     
>     - The io_rw_reissue() -EAGAIN retry is explicit to block devices and
>       regular files, so don't ever attempt to do that on other types of
>       files.
>     
>     - If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
>       it. It should just complete with -EAGAIN.
>     
>     Cc: stable@vger.kernel.org
>     Reported-by: Norman Maurer <norman.maurer@googlemail.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b1ccd7072d93..65656102bbeb 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2300,8 +2300,11 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
>  static bool io_rw_reissue(struct io_kiocb *req, long res)
>  {
>  #ifdef CONFIG_BLOCK
> +	umode_t mode = file_inode(req->file)->i_mode;
>  	int ret;
>  
> +	if (!S_ISBLK(mode) && !S_ISREG(mode))
> +		return false;
>  	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
>  		return false;
>  
> @@ -3146,6 +3149,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>  		/* IOPOLL retry should happen for io-wq threads */
>  		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
>  			goto done;
> +		/* no retry on NONBLOCK marked file */
> +		if (req->file->f_flags & O_NONBLOCK)
> +			goto done;

Looks like it works with open(O_NONBLOCK) but not with IOCB_NOWAIT in the
request's flags. Is that so?


>  		/* some cases will consume bytes even on error returns */
>  		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
>  		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
> @@ -3291,8 +3297,12 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>  		/* IOPOLL retry should happen for io-wq threads */
>  		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
>  			goto copy_iov;
> +done:
>  		kiocb_done(kiocb, ret2, cs);
>  	} else {
> +		/* no retry on NONBLOCK marked file */
> +		if (req->file->f_flags & O_NONBLOCK)
> +			goto done;
>  copy_iov:
>  		/* some cases will consume bytes even on error returns */
>  		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
> 

-- 
Pavel Begunkov
