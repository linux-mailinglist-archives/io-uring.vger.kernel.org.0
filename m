Return-Path: <io-uring+bounces-3979-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 571429AEAF4
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D34E284EEC
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3951F5832;
	Thu, 24 Oct 2024 15:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RKamBn3F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2363F158A31
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784658; cv=none; b=TiIq8ntWvmLV6zHcGf7GCGhZqeuKYax0XZK9pdvJ5FuhGO4UiwB9bSMf9pEUSphmS960x/qh7VMS88Age3xqp7ERw64QYeIJUKo9p3kvAGECexNUtnpe4CzC2/WPpLNI4WeDZ3C9ONB2tqw3Kx5a1kcZWsrbQFFMktqgimFkiIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784658; c=relaxed/simple;
	bh=Pu6DitSj/BOWfyyM6YYhhs+Eca/3wQXug7lBnoKJcqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lCEuJ9+ndzUGrlNYZDVef18032HUzQNYCTb+RB+WbLUNgSlUemlah6KltuYnpKSHb3IWPbspsZvCaXQdWedWvrS7s2rd5wEEFdVevi1DnEy2XBI5mXE9pgT7UjHoC9gSYjNa0jpowQMrx7S7EK6qUwFpjALF9W+Fq1YFa0CjftQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RKamBn3F; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539e63c8678so1198913e87.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729784654; x=1730389454; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qvqq7euG62NjAU/OD0gvCAI//TY02gjiJKelE8IKkHw=;
        b=RKamBn3FU/9wqhXQY9zE/hZ2vdYEywF9+8uaPzMuGGti43WkqUnX86qBfVilCfJkms
         NI/uxVcZhJwICNOYYmLtbswa1YdohtkU8iE7RYhNS+iOXSn2vdp2FR1AyVGCfcny4iXO
         rLPsJEyDPa0kKA19HZGeQFng3ySRYHY+GFrlXd7MiuRuhLu+HGoL4a913K5LEo431UEK
         gQhGljpT9tS3xSTPPljR+GhikyLX5/st01FZsN6uLV9Eymmf7/01KrNc0nLW6EacooPH
         SM1yL1fYJdlg0YUSRflt42Kqzq5Iy5r40wKnmikzlNyOnZvA9XP6zEDdjhl8onRDWFvS
         JH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729784654; x=1730389454;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvqq7euG62NjAU/OD0gvCAI//TY02gjiJKelE8IKkHw=;
        b=E3iTJdnOgxZVWCrR3WUp6wn4Y+kDuM7h1QivruFFJataWKtZhu247zKk63pq/0azUk
         wVr0d80ObEMDUNRmYMaZW47dYcD2njTxmyUq3zpOm+kXT777isA/CO1MlSd8+IW8uPJn
         zUvE8dRsBMUgrMVpQ7yhp2Z7jqBHwtm0ik7d6Dbk++wFKAmSVHoxJlvhfaYAHsEDY/eA
         Dg3HwzVEDnqPlgzMIqoVinWQad4pd4pHJioUkaMwndyY7xx1AHUY8LwzYyZWpg/eRkR1
         6sFC1z/5sLbZEtYvHLj2bHkBNjEl+yIbla7PW47Y7q0/dQHV0CSJcysOmK3i/hidrY+N
         6+hQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWzb6clvtl8d9x9FqbOa0UJBQE9K46pDZTEZOc7dlgWR0SbGOj3CTRee6MZ9B1p1gtzB8W/v4I9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYVdYygPYMQogA+dLeoV3k+NW2AyjpRHBuU68Ms5X8V0sbuAC3
	JSg7ULfsPIMzRkIvo2ogJp3MaL0cYAd/HFJGJIk8ooNeqLAjZOPWzzF4ew==
X-Google-Smtp-Source: AGHT+IFZGYLLyNeuuvrHk2+y1yxO3J4jyAHJPLPWwkwlvCfiULpreqLxEhxrSIw3Fk1cV9xQPEN/0w==
X-Received: by 2002:a05:6512:3d27:b0:539:d870:9a51 with SMTP id 2adb3069b0e04-53b1a36b818mr4159928e87.48.1729784653781;
        Thu, 24 Oct 2024 08:44:13 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66c737c4sm5788895a12.96.2024.10.24.08.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 08:44:13 -0700 (PDT)
Message-ID: <34d4cfb3-e605-4d37-b104-03b8b1a892f1@gmail.com>
Date: Thu, 24 Oct 2024 16:44:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] io_uring: add ability for provided buffer to index
 registered buffers
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-6-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241023161522.1126423-6-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/24 17:07, Jens Axboe wrote:
> This just adds the necessary shifts that define what a provided buffer
> that is merely an index into a registered buffer looks like. A provided
> buffer looks like the following:
> 
> struct io_uring_buf {
> 	__u64	addr;
> 	__u32	len;
> 	__u16	bid;
> 	__u16	resv;
> };
> 
> where 'addr' holds a userspace address, 'len' is the length of the
> buffer, and 'bid' is the buffer ID identifying the buffer. This works
> fine for a virtual address, but it cannot be used efficiently denote
> a registered buffer. Registered buffers are pre-mapped into the kernel
> for more efficient IO, avoiding a get_user_pages() and page(s) inc+dec,
> and are used for things like O_DIRECT on storage and zero copy send.
> 
> Particularly for the send case, it'd be useful to support a mix of
> provided and registered buffers. This enables the use of using a
> provided ring buffer to serialize sends, and also enables the use of
> send bundles, where a send can pick multiple buffers and send them all
> at once.
> 
> If provided buffers are used as an index into registered buffers, the
> meaning of buf->addr changes. If registered buffer index 'regbuf_index'
> is desired, with a length of 'len' and the offset 'regbuf_offset' from
> the start of the buffer, then the application would fill out the entry
> as follows:
> 
> buf->addr = ((__u64) regbuf_offset << IOU_BUF_OFFSET_BITS) | regbuf_index;
> buf->len = len;
> 
> and otherwise add it to the buffer ring as usual. The kernel will then
> first pick a buffer from the desired buffer group ID, and then decode
> which registered buffer to use for the transfer.
> 
> This provides a way to use both registered and provided buffers at the
> same time.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/uapi/linux/io_uring.h | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 86cb385fe0b5..eef88d570cb4 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -733,6 +733,14 @@ struct io_uring_buf_ring {
>   	};
>   };
>   
> +/*
> + * When provided buffers are used as indices into registered buffers, the
> + * lower IOU_BUF_REGBUF_BITS indicate the index into the registered buffers,
> + * and the upper IOU_BUF_OFFSET_BITS indicate the offset into that buffer.
> + */
> +#define IOU_BUF_REGBUF_BITS	(32ULL)
> +#define IOU_BUF_OFFSET_BITS	(32ULL)

32 bit is fine for IO size but not enough to store offsets, it
can only address under 4GB registered buffers.


-- 
Pavel Begunkov

