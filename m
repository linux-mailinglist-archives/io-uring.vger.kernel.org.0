Return-Path: <io-uring+bounces-9316-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 738D2B38B96
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 23:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EEF53B0832
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 21:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 385B52F39BD;
	Wed, 27 Aug 2025 21:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CjmuBQxR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9822D94A6
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 21:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756331134; cv=none; b=O7xzn3/SGVZPrse85trwQKrrL7qh3ESIzyhTBpBtpLtqDZ05aApXjw7kWXuH1D2dt2pbTTuYRR4M6CDzb1lowOXPhYYXJyk1+473xmd0tJAqo7/nsfBZAJ/mEvXS8JHBiSjyEBDSLyg0I8fuGYZx7yeMC40lE/BI2mtxbcU0ONs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756331134; c=relaxed/simple;
	bh=moYggT99h1EG8/bE3TxVdXK2XRp9prtRhgIAEzXgWJw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=QLl9Ae75Sz8SpmyRsT2ubLqMQOZlOcAlSvyDPDOwJUGWWcsxSg4Gy+lLcqnmJs5Z+Htb5AvlXQ/mzmkC2qQZcyGNC6Uh/nHJMNV+F061YFhdipwpImZB1eTkiUJU/47gq0uYaqNFeu3j8Bs0Tmzv3kvtfKcITI0subPTT+FjIBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CjmuBQxR; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-88432e362bfso5494939f.2
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 14:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756331130; x=1756935930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pA+zU0ZC0y/SbU2udeBUP/+OQmH4g9eRHQrYtvBpENg=;
        b=CjmuBQxRtT/d4O97qAiVXF68nYoY3jmmdCdDhjZo1espl5xCSW7Jrs3czBOQaK+/1Y
         MBD2TFonX8VC2aX70Ha2RdI9NZUmk29UkX7VgiXKFNojGfNKLFb8vqGDU7z8mZpaOC03
         VxVY1mO71dYz9TrieVBLicqv3KIg9w172wAYFIdWOyy5bHioMj/9MWRZYr9Ms2MfIZ7F
         nmnklMNu9nPUaVP5q83wHwPuXZ0paH/X3i7n+CBASU21wHzzXS+r91Hj2ifTbZvLv+Ek
         F6BVXgdNAtm1kWmY6Kosirx/D5Ry+/4Gyy9EPPVKzMf5j6701ahxhl7zHLg5gcUsu8ws
         IgBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756331130; x=1756935930;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pA+zU0ZC0y/SbU2udeBUP/+OQmH4g9eRHQrYtvBpENg=;
        b=phOlecDJX/ew23D5kSZtiy93LQ2X4oQ6PrzuKkpO4NtCSMieZV0BhN6/9EtFR7126F
         gmKMrMELR3W3ThZzeBT7HBgvHANrmtibTfVjv1QrqM4H6HUc8UYG3n+uMeEnVA4X6Uof
         nsAeKduGBKlB1IULOji/X54NnALpNanso3Kre5o2QsRrg1K58Z4BOOrzPetneIkB2dO5
         anuR/ZyZ4iFerZbCNk0W7ERCG382ziltXmYCjNa4PmhaExLN3OL2dVCozIwIxlzEsCwA
         BV66kTRnZdTGzrM3Qob6j52VsZDFYQ4lXa/CYVrvlanxlKcPG5V8678rTyB6YFWhbMWb
         w1hA==
X-Gm-Message-State: AOJu0Yz//m5vUJLsL63dgSOF6cr6Et0VMpENpgu8ZN7JhHSFdA6EiqRD
	tmomPxivnvSls8Hhy0zw0TdTlrwetLG1towOh4fVJa4xaIkJefKJqMRDFuHl5+/Ai5A=
X-Gm-Gg: ASbGncs/N8XYD6yIzjkZBbNgks+RNYvKC0UT26jY8GMADCLaGZMBNLaICwrHYuAiHKu
	Y8Jbo37FDmwlsvM5Vm/EDsFVcrHzV5rPIix9Ne9cqpzhfuvZ+lOtVNPXh/OPBAzkJmGLIPQAJSe
	lmREt5gM6XpxO6t73yoKpSCHUU0O32qwXGyVdXpKtoB4DqyfMPKe7uG0W7Jah8sl4h6PgSobABm
	Wvt7GZ9L6IsvPsIPAXn5wK1HJ4qsYkmmAVTGq7yJURUWxZVIWLUenoj9uZnGA2RgpLUuImrfhrI
	oYRGJUr90Ppbjq2UKOoIYh7eH7uIUoMJIbF2QT5wiXqbWxXNmtL38S9eO+B4y1xCNX4JvVx8KVS
	CtSF6tQH4gNz0j2NKgTw=
X-Google-Smtp-Source: AGHT+IGy9ULcGdjoUvwyKJa7TjyN21QlUTRM/qFOEKNSy81yxzH/dzcresGtYnSny/HJAfCkpRGAXg==
X-Received: by 2002:a05:6602:1649:b0:881:962e:31a2 with SMTP id ca18e2360f4ac-886bd102341mr3078982939f.1.1756331129671;
        Wed, 27 Aug 2025 14:45:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886c8f09bbcsm929301839f.9.2025.08.27.14.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 14:45:28 -0700 (PDT)
Message-ID: <4b8eb795-239f-4f46-af4f-7a05056ab516@kernel.dk>
Date: Wed, 27 Aug 2025 15:45:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in
 io_kbuf_inc_commit()
From: Jens Axboe <axboe@kernel.dk>
To: Qingyue Zhang <chunzhennn@qq.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 Suoxing Zhang <aftern00n@qq.com>
References: <20250827114339.367080-1-chunzhennn@qq.com>
 <tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com>
 <fcfd5324-9918-4613-94b0-c27fb8398375@kernel.dk>
Content-Language: en-US
In-Reply-To: <fcfd5324-9918-4613-94b0-c27fb8398375@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/25 8:30 AM, Jens Axboe wrote:
> On 8/27/25 5:44 AM, Qingyue Zhang wrote:
>> In io_kbuf_inc_commit(), buf points to a user-mapped memory region,
>> which means buf->len might be changed between importing and committing.
>> Add a check to avoid infinite loop when sum of buf->len is less than
>> len.
>>
>> Co-developed-by: Suoxing Zhang <aftern00n@qq.com>
>> Signed-off-by: Suoxing Zhang <aftern00n@qq.com>
>> Signed-off-by: Qingyue Zhang <chunzhennn@qq.com>
>> ---
>>  io_uring/kbuf.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>> index 81a13338dfab..80ffe6755598 100644
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
>> @@ -34,11 +34,12 @@ struct io_provide_buf {
>>  
>>  static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>>  {
>> +	struct io_uring_buf *buf, *buf_start;
>> +
>> +	buf_start = buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
>>  	while (len) {
>> -		struct io_uring_buf *buf;
>>  		u32 this_len;
>>  
>> -		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
>>  		this_len = min_t(u32, len, buf->len);
>>  		buf->len -= this_len;
>>  		if (buf->len) {
>> @@ -47,6 +48,10 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>>  		}
>>  		bl->head++;
>>  		len -= this_len;
>> +
>> +		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
>> +		if (unlikely(buf == buf_start))
>> +			break;
>>  	}
>>  	return true;
>>  }
> 
> Maybe I'm dense, but I don't follow this one. 'len' is passed in, and
> the only thing that should cause things to loop more than it should
> would be if we do:
> 
> len -= this_len;
> 
> and this_len > len;
> 
> Yes, buf->len is user mapped, perhaps we just need to do:
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index f2d2cc319faa..569f4d957051 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -36,15 +36,18 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>  {
>  	while (len) {
>  		struct io_uring_buf *buf;
> -		u32 this_len;
> +		u32 buf_len, this_len;
>  
>  		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
> -		this_len = min_t(int, len, buf->len);
> -		buf->len -= this_len;
> -		if (buf->len) {
> +		buf_len = READ_ONCE(buf->len);
> +		this_len = min_t(int, len, buf_len);
> +		buf_len -= this_len;
> +		if (buf_len) {
>  			buf->addr += this_len;
> +			buf->len = buf_len;
>  			return false;
>  		}
> +		buf->len = 0;
>  		bl->head++;
>  		len -= this_len;
>  	}
> 
> so that we operate on a local variable, and just set buf->len
> appropriate for each buffer.

I took a closer look and there's another spot where we should be
using READ_ONCE() to get the buffer length. How about something like
the below rather than the loop work-around?


commit 7f472373b2855087ae2df9dc6a923f3016a1ed21
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Aug 27 15:27:30 2025 -0600

    io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths
    
    Since the buffers are mapped from userspace, it is prudent to use
    READ_ONCE() to read the value into a local variable, and use that for
    any other actions taken. Having a stable read of the buffer length
    avoids worrying about it changing after checking, or being read multiple
    times.
    
    Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
    Link: https://lore.kernel.org/io-uring/tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com/
    Reported-by: Qingyue Zhang <chunzhennn@qq.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 81a13338dfab..394037d3f2f6 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -36,15 +36,18 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 {
 	while (len) {
 		struct io_uring_buf *buf;
-		u32 this_len;
+		u32 buf_len, this_len;
 
 		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
-		this_len = min_t(u32, len, buf->len);
-		buf->len -= this_len;
-		if (buf->len) {
+		buf_len = READ_ONCE(buf->len);
+		this_len = min_t(u32, len, buf_len);
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
@@ -159,6 +162,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	__u16 tail, head = bl->head;
 	struct io_uring_buf *buf;
 	void __user *ret;
+	u32 buf_len;
 
 	tail = smp_load_acquire(&br->tail);
 	if (unlikely(tail == head))
@@ -168,8 +172,9 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		req->flags |= REQ_F_BL_EMPTY;
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);
-	if (*len == 0 || *len > buf->len)
-		*len = buf->len;
+	buf_len = READ_ONCE(buf->len);
+	if (*len == 0 || *len > buf_len)
+		*len = buf_len;
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
@@ -265,7 +270,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	req->buf_index = buf->bid;
 	do {
-		u32 len = buf->len;
+		u32 len = READ_ONCE(buf->len);
 
 		/* truncate end piece, if needed, for non partial buffers */
 		if (len > arg->max_len) {

-- 
Jens Axboe

