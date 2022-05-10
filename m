Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71806520BE8
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 05:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiEJDYw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 23:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbiEJDX7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 23:23:59 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A932F28C9D0
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 20:20:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so930777pjv.4
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 20:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zPJNAY15aq71R4BfJKDtEcYmjmLOs5pWTXebn5mFuvc=;
        b=2a3G1WWKdmQDVuS+1Wk+h7rfs45/DLhtjZkoYl/cHotM3GtKSkHvZZRZ1GuqdmDOcZ
         U+eUJHLZ4QzppmBagWd2jfJsRsy4A08iMDFRlPlmDnIvDfa1NKA7nN2TqmUPEp0Qfnwj
         jsiTJVRZhFNPoRYbeOaAyXByZEA6dOoazRGYPyTZabHQSIUifhx5+TOFuFsryvPvas9O
         sbt8+mO8IbhKPoq+iEsC7RwRFbcSnXwvGxeqkmkKCoaV60w7tvCOH+JSmtjWNS1D3eRY
         CPyGg5x56Q3d0BKbgWWF9a2UIuaLTtSWUOiYZ98n7fC2doM8RXBUTNLErK3UiFgcqUOg
         7fEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zPJNAY15aq71R4BfJKDtEcYmjmLOs5pWTXebn5mFuvc=;
        b=KPSGws5rL/MJTPuEkVbtahjyp+uT9b+WPxTA8aI41R3zOtJl+OyoVVJVTTmovLMG+S
         munU4GjwdgeCn9oZtZz9590pkZco76zJkfFovKDxXRFGgHKYNeiaxGoNa67Ets9UHv6B
         bLdvJX/UvEjRvkbAkF0CNpPoCsmdtc+RFngqlshVFGbgvf5uBGAMMb4wyisyUlxX89Ct
         Bs72TUH2Pf8Qdqq/ckYedz6DqFmTdiUr9hQcZv5laxjZaY3gA5Nwr/FeIJSgWvwGVKv4
         GhuSBGXw+pb5E3sldJ9oIZJvv+PZufBD9Zr3lOWAjJ8mUmj24JGWwc07VmDi1LREIHPx
         5Qdw==
X-Gm-Message-State: AOAM5308bV2XPRMICnOdNr+s1eQlJYQa9/MQjz3vPbrhZiInNn4322QE
        Q6LcWsZYVDB8/8mFmKURK11wJHLx+Rx9YXhc
X-Google-Smtp-Source: ABdhPJwILFmHEmQMx42iE+CPR/n6cr77xtVVYBesOVQRiwv15QBf3Z7VbFTqPzZKfwppwJixE7JbVw==
X-Received: by 2002:a17:90b:2249:b0:1dc:7905:c4bf with SMTP id hk9-20020a17090b224900b001dc7905c4bfmr21255633pjb.62.1652152803068;
        Mon, 09 May 2022 20:20:03 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902760400b0015ea9aabd19sm634142pll.241.2022.05.09.20.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 20:20:02 -0700 (PDT)
Message-ID: <61a2f9db-d150-a8e9-9d73-b01b34bf0989@kernel.dk>
Date:   Mon, 9 May 2022 21:20:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4/4] io_uring: implement multishot mode for accept
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220508153203.5544-1-haoxu.linux@gmail.com>
 <SG2PR01MB241129D7CDF5AFA14DB98946FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <SG2PR01MB241129D7CDF5AFA14DB98946FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/8/22 9:32 AM, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Refactor io_accept() to support multishot mode.
> 
> theoretical analysis:
>   1) when connections come in fast
>     - singleshot:
>               add accept sqe(userpsace) --> accept inline

userspace here too, like in the cover letter.

> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e0d12af04cd1..f21172913336 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1146,6 +1146,7 @@ static const struct io_op_def io_op_defs[] = {
>  		.unbound_nonreg_file	= 1,
>  		.pollin			= 1,
>  		.poll_exclusive		= 1,
> +		.ioprio			= 1,	/* used for flags */
>  	},
>  	[IORING_OP_ASYNC_CANCEL] = {
>  		.audit_skip		= 1,
> @@ -5706,6 +5707,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_accept *accept = &req->accept;
> +	unsigned flags;
>  
>  	if (sqe->len || sqe->buf_index)
>  		return -EINVAL;
> @@ -5714,19 +5716,26 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>  	accept->flags = READ_ONCE(sqe->accept_flags);
>  	accept->nofile = rlimit(RLIMIT_NOFILE);
> +	flags = READ_ONCE(sqe->ioprio);
> +	if (flags & ~IORING_ACCEPT_MULTISHOT)
> +		return -EINVAL;
>  
>  	accept->file_slot = READ_ONCE(sqe->file_index);
> -	if (accept->file_slot && (accept->flags & SOCK_CLOEXEC))
> +	if (accept->file_slot && ((accept->flags & SOCK_CLOEXEC) ||
> +	   flags & IORING_ACCEPT_MULTISHOT))
>  		return -EINVAL;

So something ala:

	if (accept_>file_slot) {
		if (accept->flags & SOCK_CLOEXEC)
			return -EINVAL;
		if (flags & IORING_ACCEPT_MULTISHOT &&
		    accept->file_slot != IORING_FILE_INDEX_ALLOC)
			return -EINVAL;
	}

when rebased as mentioned in the cover reply.


	if (accept->file_slot && (accept->flags & SOCK_CLOEXEC))

>  static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>  {
> +	struct io_ring_ctx *ctx = req->ctx;
>  	struct io_accept *accept = &req->accept;
>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>  	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
> @@ -5734,6 +5743,7 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>  	struct file *file;
>  	int ret, fd;
>  
> +retry:
>  	if (!fixed) {
>  		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
>  		if (unlikely(fd < 0))
> @@ -5745,8 +5755,12 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>  		if (!fixed)
>  			put_unused_fd(fd);
>  		ret = PTR_ERR(file);
> -		if (ret == -EAGAIN && force_nonblock)
> -			return -EAGAIN;
> +		if (ret == -EAGAIN && force_nonblock) {
> +			if ((req->flags & IO_APOLL_MULTI_POLLED) ==
> +			    IO_APOLL_MULTI_POLLED)
> +				ret = 0;
> +			return ret;
> +		}

Could probably do with a comment here for this check, it's not
immediately obvious unless you've already been deep in this part.

> @@ -5757,8 +5771,26 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>  		ret = io_install_fixed_file(req, file, issue_flags,
>  					    accept->file_slot - 1);
>  	}
> -	__io_req_complete(req, issue_flags, ret, 0);
> -	return 0;
> +
> +	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
> +		__io_req_complete(req, issue_flags, ret, 0);
> +		return 0;
> +	}
> +	if (ret >= 0) {
> +		bool filled;
> +
> +		spin_lock(&ctx->completion_lock);
> +		filled = io_fill_cqe_aux(ctx, req->cqe.user_data, ret,
> +					 IORING_CQE_F_MORE);
> +		io_commit_cqring(ctx);
> +		spin_unlock(&ctx->completion_lock);
> +		if (!filled)
> +			return -ECANCELED;
> +		io_cqring_ev_posted(ctx);
> +		goto retry;
> +	}
> +
> +	return ret;
>  }

As mentioned, I still think this should be:

		...
		if (filled) {
			io_cqring_ev_posted(ctx);
			goto retry;
		}
		ret = -ECANCELED;
	}

	return ret;

-- 
Jens Axboe

