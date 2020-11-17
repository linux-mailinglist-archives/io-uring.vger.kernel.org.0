Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2412B5DF6
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 12:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgKQLH2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 06:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgKQLH1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 06:07:27 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C17BC0613CF
        for <io-uring@vger.kernel.org>; Tue, 17 Nov 2020 03:07:27 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id k2so22785546wrx.2
        for <io-uring@vger.kernel.org>; Tue, 17 Nov 2020 03:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JsxD5uhV2OKeSNuBNZxBfsm01f3L2AokvhAL+VHFtgk=;
        b=eRP8cswL8lQYOcgwqt7e87DHG7YmwePfcaMetV8N7clu3zNPGjVDPUNvhr5XUo2UZl
         Lj3Ik99mCY1P2i7YFBHK2cPhS7wrRDgcugbRlw49YEWPTdpZUjDSz4rK/ZkoNSMOSvKd
         ICMSgqVGKre60jpVZvbtNHvmd5zVeTP0XDvkljyP/Lb0BzGKy9qYPtvAlVJhCHUuMKTV
         ciBF3dndhZNQ/QKrGC8rT+UxisrlSQBnqB2Uw31zxxrm7JnVLIGJ58m8BppzCIzEQ2Rh
         qWKNNB0c3gioU0A33tDNH0Q1yIiqY9dXcwazil4U5MtQctTQHBZ/f6ePBVHcQ5f2LP/D
         bUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JsxD5uhV2OKeSNuBNZxBfsm01f3L2AokvhAL+VHFtgk=;
        b=eODZkK1eIuY//7hLNqrXQqwL3rKeVWThCGYxPuXlY+W6/xccTm7T8cmTNV772G8i4x
         UmnR2+iE23pCmdoDieyf8uzgCs6XAYAYayME/yO2d8N9orf6Ezrf+Ee08wb818Y8ZTe0
         G4syGrzBDfD0L0O5CtseNmmfWEAPtIG96UllJvoPDSN1J+ggWIT7Lv48DlEijlonFT7L
         EmKig0D6kkpjHHVRnlYmchLzq5eXEQiV0XAVpzcMl29N+bx6Ju2Tg9jTKvgjxn7H88By
         PNfdqYAEXPDRScI/7fEsiiuXwNwpDkqLX+tK4d9Iu0d3f++AT6kzh3KcixPMtabLpIl4
         BGwg==
X-Gm-Message-State: AOAM533byumcWtrRvhVozjFp+t7OhAk8kw6CieKePu5f/UirQQ8ra8iT
        T5E07ynAnSz6/kcbltdZKE+lox1ACtryPg==
X-Google-Smtp-Source: ABdhPJwt3na7PHJX9IxV8yshREJAtXks2yD9TgWDe2hZvgxsF6H6AAowTrlssXYZzMEdu+P6jO5DAw==
X-Received: by 2002:adf:9e4c:: with SMTP id v12mr23621023wre.22.1605611245521;
        Tue, 17 Nov 2020 03:07:25 -0800 (PST)
Received: from [192.168.1.33] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id i16sm27599615wru.92.2020.11.17.03.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 03:07:25 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1605222042-44558-8-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 7/8] io_uring: support readv/writev with fixed buffers
Message-ID: <d8c1c348-7806-ce54-c683-0c08e44d4590@gmail.com>
Date:   Tue, 17 Nov 2020 11:04:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1605222042-44558-8-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/11/2020 23:00, Bijan Mottahedeh wrote:
> Support readv/writev with fixed buffers, and introduce IOSQE_FIXED_BUFFER,
> consistent with fixed files.

I don't like it at all, see issues below. The actual implementation would
be much uglier.

I propose you to split the series and push separately. Your first 6 patches
first, I don't have conceptual objections to them. Then registration sharing
(I still need to look it up). And then we can return to this, if you're not
yet convinced.

> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  fs/io_uring.c                 | 59 ++++++++++++++++++++++++++++++++++++++++---
>  include/uapi/linux/io_uring.h |  3 +++
>  2 files changed, 58 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6020fd2..12c4144 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -625,6 +625,7 @@ enum {
>  	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
>  	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
>  	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
> +	REQ_F_FIXED_BUFFER_BIT	= IOSQE_FIXED_BUFFER_BIT,
>  
>  	REQ_F_FAIL_LINK_BIT,
>  	REQ_F_INFLIGHT_BIT,
> @@ -681,8 +682,12 @@ enum {
>  	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
>  	/* linked timeout is active, i.e. prepared by link's head */
>  	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
> +	/* ctx owns buffer */
> +	REQ_F_FIXED_BUFFER	= BIT(REQ_F_FIXED_BUFFER_BIT),
>  };
>  
> +#define REQ_F_FIXED_RSRC	(REQ_F_FIXED_FILE | REQ_F_FIXED_BUFFER)
> +
>  struct async_poll {
>  	struct io_poll_iocb	poll;
>  	struct io_poll_iocb	*double_poll;
> @@ -3191,6 +3196,46 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
>  	return __io_iov_buffer_select(req, iov, needs_lock);
>  }
>  
> +static ssize_t io_import_iovec_fixed(int rw, struct io_kiocb *req, void *buf,
> +				     unsigned segs, unsigned fast_segs,
> +				     struct iovec **iovec,
> +				     struct iov_iter *iter)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_mapped_ubuf *imu;
> +	struct iovec *iov;
> +	u16 index, buf_index;
> +	ssize_t ret;
> +	unsigned long seg;
> +
> +	if (unlikely(!ctx->buf_data))
> +		return -EFAULT;
> +
> +	ret = import_iovec(rw, buf, segs, fast_segs, iovec, iter);

Did you test it? import_iovec() does access_ok() against each iov_base,
which in your case are an index.

> +	if (ret < 0)
> +		return ret;
> +
> +	iov = (struct iovec *)iter->iov;
> +
> +	for (seg = 0; seg < iter->nr_segs; seg++) {
> +		buf_index = *(u16 *)(&iov[seg].iov_base);

That's ugly, and also not consistent with rw_fixed, because iov_base is
used to calculate offset.

> +		if (unlikely(buf_index < 0 || buf_index >= ctx->nr_user_bufs))
> +			return -EFAULT;
> +
> +		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
> +		imu = io_buf_from_index(ctx, index);
> +		if (!imu->ubuf || !imu->len)
> +			return -EFAULT;
> +		if (iov[seg].iov_len > imu->len)
> +			return -EFAULT;
> +
> +		iov[seg].iov_base = (void *)imu->ubuf;

Nope, that's not different from non registered version.
What import_fixed actually do is setting up the iter argument to point
to a bvec (a vector of struct page *).

So it either would need to keep a vector of bvecs, that's a vector of vectors,
that's not supported by iter, etc., so you'll also need to iterate over them
in io_read/write and so on. Or flat 2D structure into 1D, but that's still ugly.



> +		ret += iov[seg].iov_len;
> +	}
> +
> +	return ret;
> +}
> +
>  static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>  				 struct iovec **iovec, struct iov_iter *iter,
>  				 bool needs_lock)
> @@ -3201,6 +3246,12 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>  	u8 opcode;
>  
>  	opcode = req->opcode;
> +
> +	if ((opcode == IORING_OP_READV || opcode == IORING_OP_WRITEV) &&
> +	    req->flags & REQ_F_FIXED_BUFFER)
> +		return (io_import_iovec_fixed(rw, req, buf, sqe_len,
> +					      UIO_FASTIOV, iovec, iter));
> +
>  	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
>  		*iovec = NULL;
>  		return io_import_fixed(req, rw, iter);
> @@ -5692,7 +5743,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
>  {
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> -	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
> +	if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))

Why it's here? 

#define REQ_F_FIXED_RSRC	(REQ_F_FIXED_FILE | REQ_F_FIXED_BUFFER)
So, why do you | with REQ_F_BUFFER_SELECT again here?


>  		return -EINVAL;
>  	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags)
>  		return -EINVAL;
> @@ -5867,7 +5918,7 @@ static int io_async_cancel_prep(struct io_kiocb *req,
>  {
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> -	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
> +	if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))
>  		return -EINVAL;
>  	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
>  		return -EINVAL;
> @@ -5889,7 +5940,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
>  {
>  	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
>  		return -EINVAL;
> -	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
> +	if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))
>  		return -EINVAL;
>  	if (sqe->ioprio || sqe->rw_flags)
>  		return -EINVAL;
> @@ -6740,7 +6791,7 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
>  
>  #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
>  				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
> -				IOSQE_BUFFER_SELECT)
> +				IOSQE_BUFFER_SELECT | IOSQE_FIXED_BUFFER)
>  
>  static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  		       const struct io_uring_sqe *sqe,
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 17682b5..41da59c 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -70,6 +70,7 @@ enum {
>  	IOSQE_IO_HARDLINK_BIT,
>  	IOSQE_ASYNC_BIT,
>  	IOSQE_BUFFER_SELECT_BIT,
> +	IOSQE_FIXED_BUFFER_BIT,
>  };
>  
>  /*
> @@ -87,6 +88,8 @@ enum {
>  #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
>  /* select buffer from sqe->buf_group */
>  #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
> +/* use fixed buffer set */
> +#define IOSQE_FIXED_BUFFER	(1U << IOSQE_FIXED_BUFFER_BIT)

Unfortenatuly, we're almost out of flags bits -- it's a 1 byte
field and 6 bits are already taken. Let's not use it.

-- 
Pavel Begunkov
