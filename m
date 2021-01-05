Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED462EA370
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 03:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbhAECrh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 21:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbhAECrh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 21:47:37 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01127C061574
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 18:46:57 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id e25so1121693wme.0
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 18:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VCzrW2jUgY2eocXCgtV9txhYJmBSJkK+cR8QfamQoy4=;
        b=tgj5RkpwBxgRX0h8dqfFyEMqauw0X6vkc4+9OksSsavazAfBt3Tz5AA5Wq5/5e16mF
         2TDyRRX7KzAhOR6bJQFIpzzEjJDwed9+xrBmH40RyLcbB/N6d2fqpmniPCBS8fLUJO0w
         qRfh6r0Q/HvxOF2BCiGcMkwYsqTHeKa6jhBaFpf2LwvP3CYdhQoZJCrtjGY++c1fOiI6
         6XDcs58wp6c/vGARQKo1A3BKpnZ82uqAsNZqUZQPIeZNVsXWwFozOA+G/4I+yH0dmIzJ
         hE1l3ITok/OVUqHlaM3SgZrmy7S9kMQYMRA7CXSK6oEJqTi/LL01kiAeKE1F4bDluSI5
         5dSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VCzrW2jUgY2eocXCgtV9txhYJmBSJkK+cR8QfamQoy4=;
        b=e+Htys1V4oB/AYYH5a1PnW7bXzE2qbsetcMLYj8PHgOPofpyNW9uCc5CK+h4KbgvbT
         9cBwyiAGOBzZxCHHnI6HYRRs+oYcd49+65qfUXlsHkQs4GTOHqP/fzvASrababv5NTSO
         X+Io2PGM7pAPLmADga+vE/oXbbLkNwmC14HnYDPX+CqDm2/WyXiV7fEogxAk+3p7/VRF
         OZBmPpeFzgKVQyDtKMzTuU/zAJRZhQfXK6zJTymUXk7UuphS9wgBwQTVCSS3E5oo+4b5
         sk6Mo2SCnouFbNSs4CMA8/KAnOsnf/QfflK6rCibRNmc2vAJ8klfNQAnUYyjJuXDyICw
         E6fQ==
X-Gm-Message-State: AOAM531ylgPJjkER5iEoZBz4jUFtGaWkY8wVe0WQDVL/ldY54gRWwwyU
        kowCeOra9BL24oWrmNUyhbTqsrHsGoLe2w==
X-Google-Smtp-Source: ABdhPJzfHJRGV8F1giU8/70DXqaNfvbl8VuKt5vUaHRptHaPRXing0OQ6XMU6JUJMvV2tPa1JyBiLA==
X-Received: by 2002:a1c:2091:: with SMTP id g139mr1433729wmg.133.1609814815553;
        Mon, 04 Jan 2021 18:46:55 -0800 (PST)
Received: from [192.168.8.195] ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id 125sm2003075wmc.27.2021.01.04.18.46.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 18:46:54 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-9-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
Message-ID: <f0bff3b0-f27e-80fe-9a58-dfeb347a7e61@gmail.com>
Date:   Tue, 5 Jan 2021 02:43:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1608314848-67329-9-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/12/2020 18:07, Bijan Mottahedeh wrote:
> Apply fixed_rsrc functionality for fixed buffers support.

git generated a pretty messy diff...

Because it's do quiesce, fixed read/write access buffers from asynchronous
contexts without synchronisation. That won't work anymore, so

1. either we save it in advance, that would require extra req_async
allocation for linked fixed rw

2. or synchronise whenever async. But that would mean that a request
may get and do IO on two different buffers, that's rotten.

3. do mixed -- lazy, but if do IO then alloc.

3.5 also "synchronise" there would mean uring_lock, that's not welcome,
but we can probably do rcu.

Let me think of a patch...

[...]
> @@ -8373,7 +8433,13 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
>  
>  	/* check previously registered pages */
>  	for (i = 0; i < ctx->nr_user_bufs; i++) {
> -		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
> +		struct fixed_rsrc_table *table;
> +		struct io_mapped_ubuf *imu;
> +		unsigned int index;
> +
> +		table = &ctx->buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
> +		index = i & IORING_BUF_TABLE_MASK;
> +		imu = &table->bufs[index];

io_buf_from_index() may tak buf_data, so can be reused.

>  
>  		for (j = 0; j < imu->nr_bvecs; j++) {
>  			if (!PageCompound(imu->bvec[j].bv_page))
> @@ -8508,19 +8574,79 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>  	return ret;
>  }
>  
> -static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
> +static void io_free_buf_tables(struct fixed_rsrc_data *buf_data,
> +			       unsigned int nr_tables)
>  {
> -	if (ctx->user_bufs)
> -		return -EBUSY;
> -	if (!nr_args || nr_args > UIO_MAXIOV)
> -		return -EINVAL;
> +	int i;
>  
> -	ctx->user_bufs = kcalloc(nr_args, sizeof(struct io_mapped_ubuf),
> -					GFP_KERNEL);
> -	if (!ctx->user_bufs)
> -		return -ENOMEM;
> +	for (i = 0; i < nr_tables; i++) {
> +		struct fixed_rsrc_table *table = &buf_data->table[i];
>  
> -	return 0;
> +		kfree(table->bufs);
> +	}
> +}
> +
> +static int io_alloc_buf_tables(struct fixed_rsrc_data *buf_data,
> +			       unsigned int nr_tables, unsigned int nr_bufs)
> +{
> +	int i;
> +		

trailing tabs

> +	for (i = 0; i < nr_tables; i++) {
> +		struct fixed_rsrc_table *table = &buf_data->table[i];
> +		unsigned int this_bufs;
> +
> +		this_bufs = min(nr_bufs, IORING_MAX_BUFS_TABLE);
> +		table->bufs = kcalloc(this_bufs, sizeof(struct io_mapped_ubuf),
> +				      GFP_KERNEL);
> +		if (!table->bufs)
> +			break;
> +		nr_bufs -= this_bufs;
> +	}
> +
> +	if (i == nr_tables)
> +		return 0;
> +
> +	io_free_buf_tables(buf_data, nr_tables);

Would work because kcalloc() zeroed buf_data->table, but

io_free_buf_tables(buf_data, __i__);

> +	return 1;
> +}
> +
[...]
>  static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  				   unsigned int nr_args)
>  {
>  	int i, ret;
>  	struct iovec iov;
>  	struct page *last_hpage = NULL;
> +	struct fixed_rsrc_ref_node *ref_node;
> +	struct fixed_rsrc_data *buf_data;
>  
> -	ret = io_buffers_map_alloc(ctx, nr_args);
> -	if (ret)
> -		return ret;
> +	if (ctx->nr_user_bufs)
> +		return -EBUSY;
>  
> -	for (i = 0; i < nr_args; i++) {
> -		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
> +	buf_data = io_buffers_map_alloc(ctx, nr_args);
> +	if (IS_ERR(buf_data))
> +		return PTR_ERR(buf_data);
> +
> +	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
> +		struct fixed_rsrc_table *table;
> +		struct io_mapped_ubuf *imu;
> +		unsigned int index;
>  
>  		ret = io_copy_iov(ctx, &iov, arg, i);
>  		if (ret)
>  			break;
>  
> +		/* allow sparse sets */
> +		if (!iov.iov_base && !iov.iov_len)
> +			continue;
> +
>  		ret = io_buffer_validate(&iov);
>  		if (ret)
>  			break;
>  
> +		table = &buf_data->table[i >> IORING_BUF_TABLE_SHIFT];

same, io_buf_from_index() can be reused

> +		index = i & IORING_BUF_TABLE_MASK;
> +		imu = &table->bufs[index];
> +
>  		ret = io_sqe_buffer_register(ctx, &iov, imu, &last_hpage);
>  		if (ret)
>  			break;
> +	}
>  
[...]
> @@ -9854,6 +10023,7 @@ static bool io_register_op_must_quiesce(int op)
>  	switch (op) {
>  	case IORING_UNREGISTER_FILES:
>  	case IORING_REGISTER_FILES_UPDATE:
> +	case IORING_UNREGISTER_BUFFERS:

what about REGISTER_BUFFERS? 

>  	case IORING_REGISTER_PROBE:
>  	case IORING_REGISTER_PERSONALITY:
>  	case IORING_UNREGISTER_PERSONALITY:
> 

-- 
Pavel Begunkov
