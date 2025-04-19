Return-Path: <io-uring+bounces-7558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34402A94378
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 14:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 528D317AF89
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 12:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90541A7264;
	Sat, 19 Apr 2025 12:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zzZwxBJ4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562853FE4
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 12:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745067125; cv=none; b=GVF3Va8agtX0jofxKpZanNCk2+jTl+URP0J5shI+hFflOsGJBKAq/BPoMfQePp6GADApMuHhnQqDhxpc64Bo78gFQq6sTsDHpHgpcDYI9t3UKbpSF9Hod9md9tFs7s2Hnc8d5T2yhlSC5crKKHBgnUUPs3MVzw/PDmuZtMWVWG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745067125; c=relaxed/simple;
	bh=VDKi4Qb0bqE0aA5Sl+EH5jYoQvDRcSBpYkj8a1DRlE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QM5go6dYE7Qa1Ef6AguKl+YcYW7SuRGGk+1gv1FLo/I7BLuNLle6CwIL6mT96NoA+Cr3RfeToazHI9TKaNEPZnBvC3yfBXRRdmKOgpivhs7fDgeMOuUj5/RCFZINOhK9BtaYX0IXAkXYZYI6PrBsE3OT2pVxBNbljpUXaddUHpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zzZwxBJ4; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3cf82bd380bso27984995ab.0
        for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 05:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745067121; x=1745671921; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i5h9CNkmvBbhMwsB4EXQgDcCOQ3BJEWPyDa6LqBkneE=;
        b=zzZwxBJ4GHtGq54VYF/g9jmsUCR4+lrwRMUpIjizRcE+llmWsrJxB1iCPwKGB23Hez
         2glDkfwNGmYmv9/qKnyd1M6i9ER7lqW7zirej8RbQ7/ei/Xm/M6qPPWvaGD52dnMGBal
         LN99Z9h8jIdy2oP4CvJpvEAIO2JqmvRwsOrRG225Pw+dFKjTsVOrLPGsoEt7wcD48c4q
         sfQYykwx/DsK0jRBdk70dpRrdJkWIXufSydryVhXo3wVwkXcAiaLByhDKRsQhM1JfQfp
         NQAVrK7jbmjshCaeJfYBSD08H92kL/KomwOopbSlQxpKMs4xrVmeQAxjdOBxJymaSZs6
         0AHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745067121; x=1745671921;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i5h9CNkmvBbhMwsB4EXQgDcCOQ3BJEWPyDa6LqBkneE=;
        b=XyBJfmV/neSqOr75F980vJ6T1pk6f4BYUPs6dJGTzFoAYJCVWMB6cWXl5iFnQdRio6
         Cj/EAN7KirtX3AidPwPbVvdpIBli7/jGU+/Fi9VFJ94d8a0d7Zuw7zzoGwLMqwoQrF64
         pz7WZKTvrgH4WyojW0B29awQvlMS4p1zzcIgYp27mEWHKC466TEEpeGK8fcddC2vUsyd
         NJxlSXbyfOCUHsMjpojRefH6dNyYsT/STOvT0fHAEK9BTfERIngyuO7f4uHAFkHf5B6x
         chtKkuIiQdv81yXdmTKBinMfs2nopvrCAOd0THDuGiZ0s30KV+4r+46+ICsDGcvjvT68
         fTIg==
X-Forwarded-Encrypted: i=1; AJvYcCU/uAhRi/z8sRAYHE9y1F/qhbvNBu8gwwEo3r1Yid4g61+xfKfAtrceViobcsDFRyIWaDusrmm/EA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ2xmhKIn4m1tQA7KuO08nEi+dZ38yqOBl/tyAhqJuB1ApoyHY
	LkO2MTUzcwuDNlK12H01YQbRmz3j3J2+G7JXt8dd6s/KVUVj9iBKO3KbPvGUYGzP2p28IwxrQDl
	y
X-Gm-Gg: ASbGncu0wiAY2kabocgVyOMnK1mGsoKcsHqIqkJRDytbRb72on6TZZEayi002Hx06Gj
	O17Q5KI0Z3NmQy2M3mBeH4HUyLOEqwRxEOvkKDanQ9SHbJ7UlsrJM7BUI7lSFMyU9I6ygbnmhYa
	PUocVior3CB1LWsQW/3qSKxkQ/Umu/gKaaGL2nF4F0Q589cBVJLGylAu6eZdP0199Clveaf98KM
	cNPGdEWzDGJvbAtsGGG5GL6bI6pX1lOqsF/S4k2ymZ9xAPilnriUm3Nm5xGntwVURp89Ms8tCwV
	RYt01zlOO8esY68Pi8gLG4xy0GdJuYc2ed4OFw==
X-Google-Smtp-Source: AGHT+IHqwhyiCqS/0ZY9dwcwKn+hroE5jBCWI2Ap03Sit5OP5Z0ipKgR9RCqzbZv5DcYxO/BJ779pw==
X-Received: by 2002:a05:6e02:1848:b0:3d4:6ef6:7c70 with SMTP id e9e14a558f8ab-3d893bbe7f5mr67325395ab.21.1745067121124;
        Sat, 19 Apr 2025 05:52:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a3835f88sm870549173.60.2025.04.19.05.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Apr 2025 05:52:00 -0700 (PDT)
Message-ID: <af78093c-9cf9-4e71-8d89-029ab460fab9@kernel.dk>
Date: Sat, 19 Apr 2025 06:51:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1 1/2] examples/zcrx: Use PAGE_SIZE for ring
 refill alignment
To: Haiyue Wang <haiyuewa@163.com>, io-uring@vger.kernel.org
References: <20250419095732.4076-1-haiyuewa@163.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250419095732.4076-1-haiyuewa@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/19/25 3:57 AM, Haiyue Wang wrote:
> According to the 'Create refill ring' section in [1], use the macro
> PAGE_SIZE instead of 4096 hard code number.
> 
> [1]: https://www.kernel.org/doc/html/latest/networking/iou-zcrx.html
> 
> Signed-off-by: Haiyue Wang <haiyuewa@163.com>
> ---
>  examples/zcrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/examples/zcrx.c b/examples/zcrx.c
> index 8393cfe..c96bbfe 100644
> --- a/examples/zcrx.c
> +++ b/examples/zcrx.c
> @@ -66,7 +66,7 @@ static inline size_t get_refill_ring_size(unsigned int rq_entries)
>  	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
>  	/* add space for the header (head/tail/etc.) */
>  	ring_size += PAGE_SIZE;
> -	return T_ALIGN_UP(ring_size, 4096);
> +	return T_ALIGN_UP(ring_size, PAGE_SIZE);
>  }
>  
>  static void setup_zcrx(struct io_uring *ring)

Well, in that same file:

#define PAGE_SIZE (4096)         

so this won't really fix anything. Examples or test code
should use:

sysconf(_SC_PAGESIZE)

to get the page size at runtime.

-- 
Jens Axboe

