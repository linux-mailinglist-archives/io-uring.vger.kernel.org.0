Return-Path: <io-uring+bounces-8858-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE20B14D83
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 14:15:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAF413B39C3
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 12:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479DA230BC9;
	Tue, 29 Jul 2025 12:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZpP0CxV+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC466235072
	for <io-uring@vger.kernel.org>; Tue, 29 Jul 2025 12:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753791319; cv=none; b=EgwNKReU1eCApUBf5IQsTcXXcKOwj9Ep3/pSyEFzPcpeS5dcZglmwY89yIsQ+xRqCErpztelNFaVWN+LQw/mngbZrC4ulKcQ1so/zG4QNhY4OhIS1BFHr+6QTfYwB/5imCUxrwLyA6I/svfOFhOag+A/aATJW54exLn+nXMWGHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753791319; c=relaxed/simple;
	bh=qUe1nP07QAnJXP2W194lIqmfn5sMRNcwDDExqvMHfjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lwUubF2SqlSQsh2/XNZWrfx9GIrr2iCs3vbbIITLkVmNHn5Wey+OpBwRWZ5psdhvCSc48jCWDIaVgyhiDe4C1g5km0BuVaFjELtNREnJ4DwQ8jqW4QwqDL/8XB17bLnh41ga6fn3G7nkc7sPWJDzt03f/qpt6iBPf05p4zo1Us4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZpP0CxV+; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3e3d7b135c2so31115895ab.1
        for <io-uring@vger.kernel.org>; Tue, 29 Jul 2025 05:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753791313; x=1754396113; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1SBitK0lhlziYTRjGVZlB+fKIZph6JogLvzE59RhPHM=;
        b=ZpP0CxV+W89Cl3sAYAb/0mCaRewFfMJPHLU+3KsPpjVS4idFcdgdndLQYEN4TQg2IB
         ZFMNjc1vr4xgNwC87z4mMhEjuv9/o31/xq2ImD0umXTq0XSwgRYHkvPsrv5fsoyKU2LX
         Tq2oI4bdnsMMyu77Y7Vqm1PAe/RjoChHsvQmslKeNhPTpX21Ly2e0VbPPWF2u3bc3vwg
         vGInPX3xY3Ny3blRvF9u7MrRThXvP35+FfNpH7ufoAB41S41DcEB08ShI5iUE3L1bLVk
         vDXA1ZzO0VGRGArkOnOUOHb9PgkXD6ZeXrh910bpehSHLBpvU8XOVcVV3I/I1nHyOsiS
         bXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753791313; x=1754396113;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1SBitK0lhlziYTRjGVZlB+fKIZph6JogLvzE59RhPHM=;
        b=YcXKeo+dwSnhpzBTOnJPWB6komSGRcBy/PsfZvQe97itGl2hYB26B+WVYcxFkvpB5E
         LbC3W1G/We/UqJFWfiElHKJUgA9WKiq6h7ZpzPVnj//aBl5oHyl2qefDLSA4BLLzE511
         CT7b0LPWR3j209KqextQR5o+1r0wosQbt+FA0iNSi/FK6S9O2p0rmd5c6Cw/p8n3xB0o
         40u/lwH0c58B0TQZQV67bVAoyTCdKM7BmOnVggGAKyR0BnmuxYcoz/gYeyeXr7YRrqxU
         FagMdm0cWsZG6H0GQhQ8abUPHQqH0eEPehYnIggSGlCVhR7QnFMUE2IkHdcWt1n+61/J
         HjRg==
X-Forwarded-Encrypted: i=1; AJvYcCWJF7m/Zl0SvzKqI1AkjbZl8rA9Gm3Wu+q0hK6l9qpsHvaySGTdUVgANA5t+MpaQQbOVDI2U5f74g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJAErKzkFxhjldmJJZlXG9YTqk+NRIsVIFGPXak2ccW6wONhOx
	l7ojNXA7bkEIDS+B9ZrlI0OgNnlJfYin8uRv3ofR568mfKa5uxeFZAxhWkR8dYI1+Mw=
X-Gm-Gg: ASbGncsIR3phxnY1r9I0JZaoKDarELh9PLUb1+gD8fBfkigWVtw5i0oYtFAXuRABkmo
	9adNyYhR9RAtJQpF6BySo1oFnWVUvjvCncdE4alokv1/ueg98QmSmi/BylYlHHZ9S+u8awqBGWz
	4D37FnMSjCidUD9UP7XKyRUFKbpKJ0XvwealJ6kL4cry6ascfXjiKWpV3TvmkQYys828fpF1lQC
	BrFnX+TxU287ct+FLTTWxbIFPUjosq8/lYrptCBiLrweCeI6taH4S3YucIlETr707/uobplttu4
	SZTNapo8Rg4GfVHaxzKsDIcWV/g+d/F5ziCnOxhhW77qAjn1rAUmwn8+SP5cbvAVgtMp4yFbJX4
	MbAXXbfW2au1k3KFsB74=
X-Google-Smtp-Source: AGHT+IEFv+N+ILhYg+pigrhTbKfJv2E1iOPsNggOj/o8m2lYsMFfjPPBNV4KG2/fkmlPyQV0FtwKJg==
X-Received: by 2002:a05:6e02:1c08:b0:3e2:988a:101d with SMTP id e9e14a558f8ab-3e3c525a31bmr236773045ab.6.1753791313371;
        Tue, 29 Jul 2025 05:15:13 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e3caaf2c28sm34514625ab.4.2025.07.29.05.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 05:15:12 -0700 (PDT)
Message-ID: <9cb63fda-89b8-46f6-b316-24550150cf7e@kernel.dk>
Date: Tue, 29 Jul 2025 06:15:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring/net: Allow to do vectorized send
To: norman.maurer@googlemail.com, io-uring@vger.kernel.org
Cc: Norman Maurer <norman_maurer@apple.com>
References: <20250729065952.26646-1-norman_maurer@apple.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250729065952.26646-1-norman_maurer@apple.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/29/25 12:59 AM, norman.maurer@googlemail.com wrote:
> From: Norman Maurer <norman_maurer@apple.com>
> 
> At the moment you have to use sendmsg for vectorized send.
> While this works it's suboptimal as it also means you need to
> allocate a struct msghdr that needs to be kept alive until a
> submission happens. We can remove this limitation by just
> allowing to use send directly.
> 
> Signed-off-by: Norman Maurer <norman_maurer@apple.com>
> ---
> Changes since v1: Simplify flag check and fix line length of commit message
> Changes since v2: Adjust SENDMSG_FLAGS  
> 
> ---
>  include/uapi/linux/io_uring.h | 4 ++++
>  io_uring/net.c                | 9 ++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index b8a0e70ee2fd..6957dc539d83 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -392,12 +392,16 @@ enum io_uring_op {
>   *				the starting buffer ID in cqe->flags as per
>   *				usual for provided buffer usage. The buffers
>   *				will be	contiguous from the starting buffer ID.
> + *
> + * IORING_SEND_VECTORIZED	If set, SEND[_ZC] will take a pointer to a io_vec
> + * 				to allow vectorized send operations.
>   */
>  #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
>  #define IORING_RECV_MULTISHOT		(1U << 1)
>  #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
>  #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
>  #define IORING_RECVSEND_BUNDLE		(1U << 4)
> +#define IORING_SEND_VECTORIZED		(1U << 5)
>  
>  /*
>   * cqe.res for IORING_CQE_F_NOTIF if
> diff --git a/io_uring/net.c b/io_uring/net.c
> index ba2d0abea349..3ce5478438f0 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -382,6 +382,10 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	}
>  	if (req->flags & REQ_F_BUFFER_SELECT)
>  		return 0;
> +
> +	if (sr->flags & IORING_SEND_VECTORIZED)
> +               return io_net_import_vec(req, kmsg, sr->buf, sr->len, ITER_SOURCE);
> +
>  	return import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
>  }
>  
> @@ -409,7 +413,7 @@ static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe
>  	return io_net_import_vec(req, kmsg, msg.msg_iov, msg.msg_iovlen, ITER_SOURCE);
>  }
>  
> -#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE)
> +#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE | IORING_SEND_VECTORIZED)
>  
>  int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
> @@ -420,6 +424,9 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	sr->flags = READ_ONCE(sqe->ioprio);
>  	if (sr->flags & ~SENDMSG_FLAGS)
>  		return -EINVAL;
> +	if (req->opcode == IORING_OP_SENDMSG && sr->flags & IORING_SEND_VECTORIZED)
> +		return -EINVAL;
> +
>  	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
>  	if (sr->msg_flags & MSG_DONTWAIT)
>  		req->flags |= REQ_F_NOWAIT;

I think this looks simple enough, but after pondering this a bit, I also
think we can just skip the check right above here. OP_SENDMSG is, by
definition, working on IORING_SEND_VECTORIZED data. Hence returning
-EINVAL from that seems a bit redundant. Maybe just delete this hunk?
What do you think?

No need for v3 for that, I can just edit out that hunk with a note. I'll
run some testing today.

-- 
Jens Axboe

