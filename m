Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275BB1C3EC5
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 17:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgEDPlu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 11:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727929AbgEDPlu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 11:41:50 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A329AC061A0E
        for <io-uring@vger.kernel.org>; Mon,  4 May 2020 08:41:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g13so21498021wrb.8
        for <io-uring@vger.kernel.org>; Mon, 04 May 2020 08:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VQFXtdSwJ7RhGd1ztUmTk4uyHhdYKWU1eeOviR/n0cc=;
        b=bHBq6pOtF3ujHiT8JZVqD2PJkBJuznCYaIs7ag0xHOjBu4nGaIzpUegyOcPxz4exVC
         8LnmCWc7IcckhEvb+UXSnuA5t5STZriZFtHt3jo5KEp5qZzlyzFuPoG7wnJoEQrZi348
         kc/6jJNJ1PSII86oL/qizNvrdQuaysPCyQ3KVD3ds9BFImko6vvSoVZ95z8m9hCb0N3q
         7Rd9LLVEmMMwmoortYTLXatM+LpjN1M1HByJTDpEFBMHtyQDku29dv4g70DTUVjp2Pz8
         kejuhz7qavO/hbU+ry30Nl0Bs2eWrcYwncg8CVm2hpWZJvORdNVj582cJxixoGIEW7oF
         gqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VQFXtdSwJ7RhGd1ztUmTk4uyHhdYKWU1eeOviR/n0cc=;
        b=NPrKtLe9ZZt5jmINLKby3gkZyHmzVd0kfttfm9Xz3ATFj7se2m9LXa5Hb8zRqWsOyH
         2T2VeLE4FK9OYxTrU7lanrf8bV/hnjZrJd8fH2v+OG7Idk+tuFi7MwmEocSEuEAQcH9z
         PEyMnvG6xHAtcMCT4Ts64fTu5m4ASCLQf6mX5mj7T84PHFmZb0zvdKi9AXDIV8wHxihD
         uQgL9SRGL2qVcnMn00Izoiroqnmuv7XZhvlrR8X0aHbMS56AOW96gwHzDIpFZu8w6cDm
         s6m2w22Y8Sp50+qS4lvzDFHzt4ITMKeUsvwqXcMw5y80QGjRyJ7vLofN85mQzLOFjxd/
         Ofpw==
X-Gm-Message-State: AGi0PuZuJWgWAC9tVjFeTfEr3GxQCV7F6c/QQJUzg3bhAjQIsNjIOrhA
        iC9Q2rkZrqK4v0ITpsZJiX07EOja
X-Google-Smtp-Source: APiQypLD+lx6sBQCu1T/IBS/nEm9PtMkpkY10/Nrvnor1KJvBhrlQvpcmgem4+/5X+yyxd57hbc1sA==
X-Received: by 2002:adf:f8c1:: with SMTP id f1mr8262166wrq.171.1588606908178;
        Mon, 04 May 2020 08:41:48 -0700 (PDT)
Received: from [192.168.43.158] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id d18sm16126996wrv.14.2020.05.04.08.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 08:41:47 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200504135328.29396-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: handle -EFAULT properly in io_uring_setup()
Message-ID: <8f6b82d4-7e52-e25a-4f05-f16e51854df1@gmail.com>
Date:   Mon, 4 May 2020 18:40:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200504135328.29396-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/05/2020 16:53, Xiaoguang Wang wrote:
> If copy_to_user() in io_uring_setup() failed, we'll leak many kernel
> resources, which could be reproduced by using mprotect to set params

At least it recycles everything upon killing the process, so that's rather not
notifying a user about a successfully installed fd. Good catch


> to PROT_READ. To fix this issue, refactor io_uring_create() a bit to
> let it return 'struct io_ring_ctx *', then when copy_to_user() failed,
> we can free kernel resource properly.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 45 ++++++++++++++++++++++++---------------------
>  1 file changed, 24 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0b91b0631173..a19885dee621 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7761,7 +7761,8 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
>  	return ret;
>  }
>  
> -static int io_uring_create(unsigned entries, struct io_uring_params *p)
> +static struct io_ring_ctx *io_uring_create(unsigned entries,
> +				struct io_uring_params *p)
>  {
>  	struct user_struct *user = NULL;
>  	struct io_ring_ctx *ctx;
> @@ -7769,10 +7770,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
>  	int ret;
>  
>  	if (!entries)
> -		return -EINVAL;
> +		return ERR_PTR(-EINVAL);
>  	if (entries > IORING_MAX_ENTRIES) {
>  		if (!(p->flags & IORING_SETUP_CLAMP))
> -			return -EINVAL;
> +			return ERR_PTR(-EINVAL);
>  		entries = IORING_MAX_ENTRIES;
>  	}
>  
> @@ -7792,10 +7793,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
>  		 * any cq vs sq ring sizing.
>  		 */
>  		if (p->cq_entries < p->sq_entries)
> -			return -EINVAL;
> +			return ERR_PTR(-EINVAL);
>  		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
>  			if (!(p->flags & IORING_SETUP_CLAMP))
> -				return -EINVAL;
> +				return ERR_PTR(-EINVAL);
>  			p->cq_entries = IORING_MAX_CQ_ENTRIES;
>  		}
>  		p->cq_entries = roundup_pow_of_two(p->cq_entries);
> @@ -7811,7 +7812,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
>  				ring_pages(p->sq_entries, p->cq_entries));
>  		if (ret) {
>  			free_uid(user);
> -			return ret;
> +			return ERR_PTR(ret);
>  		}
>  	}
>  
> @@ -7821,7 +7822,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
>  			io_unaccount_mem(user, ring_pages(p->sq_entries,
>  								p->cq_entries));
>  		free_uid(user);
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  	ctx->compat = in_compat_syscall();
>  	ctx->account_mem = account_mem;
> @@ -7853,22 +7854,14 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
>  	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
>  	p->cq_off.cqes = offsetof(struct io_rings, cqes);
>  
> -	/*
> -	 * Install ring fd as the very last thing, so we don't risk someone
> -	 * having closed it before we finish setup
> -	 */
> -	ret = io_uring_get_fd(ctx);
> -	if (ret < 0)
> -		goto err;
> -
>  	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
>  			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
>  			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
>  	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
> -	return ret;
> +	return ctx;
>  err:
>  	io_ring_ctx_wait_and_kill(ctx);
> -	return ret;
> +	return ERR_PTR(ret);
>  }
>  
>  /*
> @@ -7878,6 +7871,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
>   */
>  static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>  {
> +	struct io_ring_ctx *ctx;
>  	struct io_uring_params p;
>  	long ret;
>  	int i;
> @@ -7894,12 +7888,21 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>  			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
>  		return -EINVAL;
>  
> -	ret = io_uring_create(entries, &p);
> -	if (ret < 0)
> -		return ret;
> +	ctx = io_uring_create(entries, &p);
> +	if (IS_ERR(ctx))
> +		return PTR_ERR(ctx);
>  
> -	if (copy_to_user(params, &p, sizeof(p)))
> +	if (copy_to_user(params, &p, sizeof(p))) {
> +		io_ring_ctx_wait_and_kill(ctx);
>  		return -EFAULT;
> +	}
> +	/*
> +	 * Install ring fd as the very last thing, so we don't risk someone
> +	 * having closed it before we finish setup
> +	 */
> +	ret = io_uring_get_fd(ctx);
> +	if (ret < 0)
> +		io_ring_ctx_wait_and_kill(ctx);
>  
>  	return ret;
>  }
> 

-- 
Pavel Begunkov
