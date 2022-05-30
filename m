Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D14537AD1
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 14:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbiE3MxZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 08:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiE3MxY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 08:53:24 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AFF814AC
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 05:53:23 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pq9-20020a17090b3d8900b001df622bf81dso10655756pjb.3
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 05:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0u8XMK7DXWnPZ+iZhhH9I35wjtyMi4yFCwMhO1qP+1c=;
        b=WaVx9XBv0kkw06CfRxCjGIQg9ftcUKeTNGwIlBx6SURJufxOBk6AdGceowJyZPewBy
         yaJeY53mosw2qu5wds7bH8EdbV/6JeZBNKONgjt9rkDmOIvfhxUGH4rR61t//z61Mwq+
         ktFlb9zZYHI+oJB+aaB6FOQjWOB83SGkuolTK+f1cX0ZNYJjNuqT3yyARd3/tidyGIvL
         UXJhJEYYEtYcKSzDZKdS7OE7ygDS1az/uJ7wYdE7aPjkPY2/t0rrlNOuCN4fZPIA2ZrH
         OjHyFAKrkbJwXMEODSC2qKrKnTLbJ8JKPqOdHPOf0HnFVA/cvoGosap1AogsswjR1WMF
         XOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0u8XMK7DXWnPZ+iZhhH9I35wjtyMi4yFCwMhO1qP+1c=;
        b=A8JRSDWnEdXLWpI445E6QFRgRYdNAsuhaBUMHsxRgKSPObBe7Ot9gEhZC0ISTyspq1
         ioxUVls+XOw2q2Hwn+ywnElbB4U7lEVRSrj7tnV7HdWuNiWTXJD6z8VK3cEjfR8J+DUv
         lkmZdGetIg5quUBlakNoZUyVO6NrO7aDX37cIEtNPuOeIGefrR8CYDI49FTLbVLBjOqN
         3wCiF8tj+ADBMBazOOK2Cy2dinf3jmI0zmBcsenj+P43cZQn6vAYwownnsVpr+vGZDcp
         8gqQClNO1TYVq/rjY7QeyXb4dZzn4fLhSaCJANorcx1oWZpBk2/QteQTO4tlqJFadSR5
         WW5A==
X-Gm-Message-State: AOAM532mtMr+r3FUsjjl7iV0vpTuvK+IWtrQT2JnzhHHofh4BpV1Hddm
        jmfga32n1p34mYNVagZfWaNW1g==
X-Google-Smtp-Source: ABdhPJzNGkJ/lMz4GgbYVwBr2ttejXH16zgsNjLibG9xjRYant3FxpOBxJUlJK5aQFz9i+0hACYPUA==
X-Received: by 2002:a17:902:ef47:b0:156:646b:58e7 with SMTP id e7-20020a170902ef4700b00156646b58e7mr55549426plx.57.1653915202572;
        Mon, 30 May 2022 05:53:22 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n1-20020a17090aab8100b001e0d197898dsm11591169pjq.3.2022.05.30.05.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 05:53:22 -0700 (PDT)
Message-ID: <84974aeb-7354-6473-4c80-a1a190f80e91@kernel.dk>
Date:   Mon, 30 May 2022 06:53:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220530124654.22349-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220530124654.22349-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 6:46 AM, Xiaoguang Wang wrote:
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6d91148e9679..58514b8048da 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5945,16 +5948,20 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
>  	return 0;
>  }
>  
> +#define IORING_CLOSE_FD_AND_FILE_SLOT 1
> +
>  static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
> -	if (sqe->off || sqe->addr || sqe->len || sqe->rw_flags || sqe->buf_index)
> +	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index)
>  		return -EINVAL;
>  	if (req->flags & REQ_F_FIXED_FILE)
>  		return -EBADF;
>  
>  	req->close.fd = READ_ONCE(sqe->fd);
>  	req->close.file_slot = READ_ONCE(sqe->file_index);
> -	if (req->close.file_slot && req->close.fd)
> +	req->close.flags = READ_ONCE(sqe->close_flags);

This needs a:

	if (req->closeflags & ~IORING_CLOSE_FD_AND_FILE_SLOT)
		return -EINVAL;

to be future proof in terms of new flags.

> +	if (!(req->close.flags & IORING_CLOSE_FD_AND_FILE_SLOT) &&
> +	    req->close.file_slot && req->close.fd)
>  		return -EINVAL;
>  
>  	return 0;
> @@ -5970,7 +5977,8 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
>  
>  	if (req->close.file_slot) {
>  		ret = io_close_fixed(req, issue_flags);
> -		goto err;
> +		if (ret || !(req->close.flags & IORING_CLOSE_FD_AND_FILE_SLOT))
> +			goto err;
>  	}
>  
>  	spin_lock(&files->file_lock);
> @@ -8003,23 +8011,63 @@ static int io_files_update_prep(struct io_kiocb *req,
>  	return 0;
>  }
>  
> +static int io_files_update_with_index_alloc(struct io_kiocb *req,
> +					    unsigned int issue_flags)
> +{
> +	__s32 __user *fds = u64_to_user_ptr(req->rsrc_update.arg);
> +	struct file *file;
> +	unsigned int done, nr_fds = req->rsrc_update.nr_args;
> +	int ret, fd;
> +
> +	for (done = 0; done < nr_fds; done++) {
> +		if (copy_from_user(&fd, &fds[done], sizeof(fd))) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		file = fget(fd);
> +		if (!file) {
> +			ret = -EBADF;
> +			goto out;
> +		}
> +		ret = io_fixed_fd_install(req, issue_flags, file,
> +					  IORING_FILE_INDEX_ALLOC);
> +		if (ret < 0)
> +			goto out;
> +		if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
> +			ret = -EFAULT;
> +			__io_close_fixed(req, issue_flags, ret);
> +			break;
> +		}
> +	}
> +
> +out:
> +	if (done)
> +		return done;
> +	return ret;
> +}
> +
>  static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct io_uring_rsrc_update2 up;
>  	int ret;
>  
> -	up.offset = req->rsrc_update.offset;
> -	up.data = req->rsrc_update.arg;
> -	up.nr = 0;
> -	up.tags = 0;
> -	up.resv = 0;
> -	up.resv2 = 0;
> +	if (req->rsrc_update.offset == IORING_FILE_INDEX_ALLOC) {
> +		ret = io_files_update_with_index_alloc(req, issue_flags);
> +	} else {
> +		up.offset = req->rsrc_update.offset;
> +		up.data = req->rsrc_update.arg;
> +		up.nr = 0;
> +		up.tags = 0;
> +		up.resv = 0;
> +		up.resv2 = 0;

Move 'up' into this branch?

Do you have a liburing test case for this as well?

-- 
Jens Axboe

