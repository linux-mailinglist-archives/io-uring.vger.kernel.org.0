Return-Path: <io-uring+bounces-9307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D8DB384FD
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 16:31:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82AF6463DAD
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 14:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B46017DA93;
	Wed, 27 Aug 2025 14:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UZ3fJ4vY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748F630CDA8
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756305058; cv=none; b=g1/FN5s2V/ZBGNpAOhT6c0VMFPNnfsa8qyNXwxpp8Jg4u2CtEXOokTdLgcm+YePgSM5R6JO31+7032d4sGHWrTRnvYfsArFSBtozVcVqKOk8hIExg7udixT+sTM1G6nzMRAWG8mdroVWk+Hw44rlcZzXR/XE4yt2fKlAlI8LFJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756305058; c=relaxed/simple;
	bh=ekYO+g2DeAY7OpkpV3uLfFZhqmRFp4OHZb6J73pGdnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C1VFCAYCeRhfZgHIMwdizAIWWFaYVUrAwt9tKSBbgDQv/WYnC6qfzyjOph8YKqq6mw/tTD2HzBKGwNP6MWQefwYrfyNbaMVnLtsnne29/HOUm6LKONHSP/NapC68tl+pi+oY+7c/YJhPJuB4ck+4XRMJ3Dxt/96MSXTlxBMLHdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UZ3fJ4vY; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3ea779929b0so27574105ab.1
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 07:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756305054; x=1756909854; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BvhGwzAhrDpzRW76hw6st02Qx9plIVjdiLTJdLVN7ms=;
        b=UZ3fJ4vYtL89Hy7qitdjpODoWXsN16zgEzzSM78vC+alWIiNPT0puOC2EMx4UmOqGM
         aL6Odtu8Wr4amqGPBS/dYxOMd9JtmeULimUcyslAzGa9fn7o2YO7GiVabcP1mIdvvP1O
         7m++ePfxI8f70GF+PrVRXsaZ4LQF8uO2EyLUBhmlYQ5yE6AJc9E3AGdVA+KJaylD+auX
         vWl4/2mjJpUDmKIym0cvuVxEoaKsHG9QTHGaaJ1PxgNYZhryXna6w5OOz30cgS68TIRT
         ckMOfoesp6/0MSl8Yk+IUpRFIEW8jGZa9xd/no987ccuAw0FPsMTPSSj1Oa/wFSY0bYt
         dtdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756305054; x=1756909854;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BvhGwzAhrDpzRW76hw6st02Qx9plIVjdiLTJdLVN7ms=;
        b=Qkx0M+3YlRS9av4FBUM3rUaf2J5gWyVnkueKVVCQ8v+mb6mmyk6NbnQlcCvlJPjx0f
         cURsl3MzGboFcN+mx022MsMqr9ua+L0VENya3tQxEIvF4xT1BGq2fGanImV3iBjhGUng
         AifOvBLqhPadSD2FxOQysv76wq161RY5Fu4OiJlHuszMpn1vlI/Mb3/1wJ/1b1CbwzeK
         7I77XOoxTlQm0z1RMPWMBvVqsb2vupBmz9MNbbQIZ00qPPI7asNYiN9IoiXe7tiuTCaX
         u2OKXZYMpaB8aLRKUJCO67iWWismt1jujPjwkm107z1yIQ5u/NEJ97eZXTdDSQIByK/x
         GgjA==
X-Gm-Message-State: AOJu0Yx+5x6pWLqwDgZ3IKaGeEEE++6H8TEChR+EsioMLOLjM5pfEq/t
	s8jgA6GnVPW8YlYxFw+vbB1IHCBvRdeXf/mEFbgNSpyJ0wlVTzibkJgyHdx8ZvDayJE=
X-Gm-Gg: ASbGncu6KzhhUgFrbGNobpUDD42C8i/B+wjkges5LwLY6fzzWHTrUkeA31qxoAIMDzT
	EitX1mYbhfhg2zL4nx4DDA1GFzfXBE0ER/JXT4pK32Mey+y75wexGkMiS7nxTT7ZXa3PIQxfqk/
	x3tdQDe3hFLoUOyfgoaM4MnlqpFumMKWzn8elhbL/5sFeY/iRQTi7dF2Ern3CB/0em9s69f0Nz1
	0yf6k1Edh1eAx8sratekbvT9vVCBe8m8LSpMZrbVEaEQq2nZTMiOlGuVMhDYRdRW81AyM0IBcds
	pNcljPHA7cVqK6qYUA1FDtEkPVHgGIqi/WLi5BskKjKSzZJ3M+SJq9DjdlsjTmA0jJJa52CPLBr
	iMLr//QwGXpMQR5ULsPBchHofTWO7M0FlUUBuJPoq
X-Google-Smtp-Source: AGHT+IFnFm3nE5momCbmzhmqVeWBi4QobS9Cc/xr+4yGN08493B+GGco3c+Pt/f1l2wDN+e4gkkJEQ==
X-Received: by 2002:a05:6e02:2142:b0:3e5:5357:6dd4 with SMTP id e9e14a558f8ab-3e92231673fmr272052845ab.20.1756305054391;
        Wed, 27 Aug 2025 07:30:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3eaa5f05661sm78097235ab.52.2025.08.27.07.30.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 07:30:53 -0700 (PDT)
Message-ID: <fcfd5324-9918-4613-94b0-c27fb8398375@kernel.dk>
Date: Wed, 27 Aug 2025 08:30:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in
 io_kbuf_inc_commit()
To: Qingyue Zhang <chunzhennn@qq.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 Suoxing Zhang <aftern00n@qq.com>
References: <20250827114339.367080-1-chunzhennn@qq.com>
 <tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/25 5:44 AM, Qingyue Zhang wrote:
> In io_kbuf_inc_commit(), buf points to a user-mapped memory region,
> which means buf->len might be changed between importing and committing.
> Add a check to avoid infinite loop when sum of buf->len is less than
> len.
> 
> Co-developed-by: Suoxing Zhang <aftern00n@qq.com>
> Signed-off-by: Suoxing Zhang <aftern00n@qq.com>
> Signed-off-by: Qingyue Zhang <chunzhennn@qq.com>
> ---
>  io_uring/kbuf.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 81a13338dfab..80ffe6755598 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -34,11 +34,12 @@ struct io_provide_buf {
>  
>  static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>  {
> +	struct io_uring_buf *buf, *buf_start;
> +
> +	buf_start = buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
>  	while (len) {
> -		struct io_uring_buf *buf;
>  		u32 this_len;
>  
> -		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
>  		this_len = min_t(u32, len, buf->len);
>  		buf->len -= this_len;
>  		if (buf->len) {
> @@ -47,6 +48,10 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>  		}
>  		bl->head++;
>  		len -= this_len;
> +
> +		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
> +		if (unlikely(buf == buf_start))
> +			break;
>  	}
>  	return true;
>  }

Maybe I'm dense, but I don't follow this one. 'len' is passed in, and
the only thing that should cause things to loop more than it should
would be if we do:

len -= this_len;

and this_len > len;

Yes, buf->len is user mapped, perhaps we just need to do:

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index f2d2cc319faa..569f4d957051 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -36,15 +36,18 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 {
 	while (len) {
 		struct io_uring_buf *buf;
-		u32 this_len;
+		u32 buf_len, this_len;
 
 		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
-		this_len = min_t(int, len, buf->len);
-		buf->len -= this_len;
-		if (buf->len) {
+		buf_len = READ_ONCE(buf->len);
+		this_len = min_t(int, len, buf_len);
+		buf_len -= this_len;
+		if (buf_len) {
 			buf->addr += this_len;
+			buf->len = buf_len;
 			return false;
 		}
+		buf->len = 0;
 		bl->head++;
 		len -= this_len;
 	}

so that we operate on a local variable, and just set buf->len
appropriate for each buffer.

?

-- 
Jens Axboe

