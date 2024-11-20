Return-Path: <io-uring+bounces-4866-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 693679D3F1D
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E4B4B38201
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 15:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB33A939;
	Wed, 20 Nov 2024 15:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1gej4nmU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3A7149C42
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732114909; cv=none; b=gkec7IPN9j0VS6ktt8VA0qUS5mBocT1x/JmX7oo5yIphaBtruV+kIOjwAXaIZas5hJX5gBIVthjxTUbavPu4UxnII4yOJQy4Obfx8ChS8sqBj6NMfQI+bYztodXzTLd2DkHcW5cq3TAU+9KsOou+fHoSfFadluYCcdJw7nzK4Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732114909; c=relaxed/simple;
	bh=psA/yx29BkrqBjVz6CY+5ew1vTfWB696Gi4MuZ45UTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W75BfdTZvv9UCmfBe6lt50bLg1Il1kEyTRqxPFYE4p45ZadNuFHeIty0H2cnnSWeyJtrkNDT6TDRxz8nuQr/7PKGuUf+HEYXpDMLZGpgx/z+XMs3KRTNsMJWXFmE2I2QwuERLXo8QnwBJzimmEYdmm6MwSpUB6D26fiMSeI4RWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1gej4nmU; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-71822fabf4fso1177450a34.2
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 07:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732114906; x=1732719706; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fjeGjNQC2qd8d6ObuWGHMSnUI8c2BdH57TDRpy3EvpI=;
        b=1gej4nmUSoF8V14n3Wrvxs8AA9TMkhyz46QxBcHkpT19YVp26Ki9nSzP6IwvHipM7E
         dotbsRmCQdmHEPYzGZxqzwZi/s1+UczrO5NqZ4E8qYORZKVm4VJpBBUhM9McCEpI/tAw
         o5/p4I5saL0FJCGe1Heio57K1bMdiThFN61FL94K/P0FaPrhMjzwejUfU47mijNS7F24
         JrlfHaRj0btLS/tphjC/yBAOvR33dO5PvjOK/4/7BF5Hxf7j+DTGJkQRxfiFtOoy8i5G
         sIA0PVxGc+R+PdHKauIzKo4lrlavFBxDCoaf5WlQE6Ucj5IGQX1ntBao8m2O3KEUkpU/
         m2tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732114906; x=1732719706;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjeGjNQC2qd8d6ObuWGHMSnUI8c2BdH57TDRpy3EvpI=;
        b=jXDOg2TbDto/BQ7Gm1JQ67Jlj+sMVT84psXY9j1AJAw+qg61WAS5iqpjMIbF/nFmSl
         6Yfe3qdVvRiGSqVGPksCABtJ1nCLxptF5Za7v4iYOYm3MxzEbz5uWeCDvTlCQfP0ATbE
         4EyRjNvQMJaRp0pO7Xcq4FbGTpT3VQ35Fo12LgRf2jPzR9FRW/T2VP/W39cXl6GZH5rq
         PN9WCMkKIA4o8PBZhj/4CLPRys7QTkGkBLrb046gfP+DA7WcLkjaPzQv7lLaE2vFrGMP
         IQGZr5WOr5FJSB23f8v4SLcw/l3C2C4Fqog8iDUoRv3KRp76hEhgwcoNM98Fs7AOhlxb
         xQBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVO10nmIHdbUcXQeymM4o8jivOdvlzQzp/iD37g/ifDGEgx/ECxOKgdWudgI5EQQoteonlzfGRg+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ8Vm267BK52/EdFrovdsKUzibXkWDMF4Ukdcd/Tw3eDSYPHNN
	HpRTgrfogrP47ZDpsNvuUhdDIinChR2+t1g6on95dyLAIIKTlyJu8ehTo8vFnmQ=
X-Google-Smtp-Source: AGHT+IGQSK+2IQshD7ZaHoNgSTljD0BMUROfHrfP8qhqEluFOIRh7AnMrDmor+21VIn6g7IrmClwsw==
X-Received: by 2002:a05:6830:61c1:b0:718:c0d:6c02 with SMTP id 46e09a7af769-71ab30f789dmr3993968a34.2.1732114905882;
        Wed, 20 Nov 2024 07:01:45 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71a78212bdfsm3984668a34.61.2024.11.20.07.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 07:01:43 -0800 (PST)
Message-ID: <7e895fd8-35c5-4cf0-bd9b-239de5153999@kernel.dk>
Date: Wed, 20 Nov 2024 08:01:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
To: Geert Uytterhoeven <geert@linux-m68k.org>,
 Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Pavel Begunkov
 <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
 Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>
Cc: linux-mm@kvack.org, io-uring@vger.kernel.org, linux-m68k@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/24 5:49 AM, Geert Uytterhoeven wrote:
> On m68k, where the minimum alignment of unsigned long is 2 bytes:
> 
>     Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>     CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-atari-03776-g7eaa1f99261a #1783
>     Stack from 0102fe5c:
> 	    0102fe5c 00514a2b 00514a2b ffffff00 00000001 0051f5ed 00425e78 00514a2b
> 	    0041eb74 ffffffea 00000310 0051f5ed ffffffea ffffffea 00601f60 00000044
> 	    0102ff20 000e7a68 0051ab8e 004383b8 0051f5ed ffffffea 000000b8 00000007
> 	    01020c00 00000000 000e77f0 0041e5f0 005f67c0 0051f5ed 000000b6 0102fef4
> 	    00000310 0102fef4 00000000 00000016 005f676c 0060a34c 00000010 00000004
> 	    00000038 0000009a 01000000 000000b8 005f668e 0102e000 00001372 0102ff88
>     Call Trace: [<00425e78>] dump_stack+0xc/0x10
>      [<0041eb74>] panic+0xd8/0x26c
>      [<000e7a68>] __kmem_cache_create_args+0x278/0x2e8
>      [<000e77f0>] __kmem_cache_create_args+0x0/0x2e8
>      [<0041e5f0>] memset+0x0/0x8c
>      [<005f67c0>] io_uring_init+0x54/0xd2
> 
> The minimal alignment of an integral type may differ from its size,
> hence is not safe to assume that an arbitrary freeptr_t (which is
> basically an unsigned long) is always aligned to 4 or 8 bytes.
> 
> As nothing seems to require the additional alignment, it is safe to fix
> this by relaxing the check to the actual minimum alignment of freeptr_t.
> 
> Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache")
> Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  mm/slab_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 893d320599151845..f2f201d865c108bd 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -230,7 +230,7 @@ static struct kmem_cache *create_cache(const char *name,
>  	if (args->use_freeptr_offset &&
>  	    (args->freeptr_offset >= object_size ||
>  	     !(flags & SLAB_TYPESAFE_BY_RCU) ||
> -	     !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
> +	     !IS_ALIGNED(args->freeptr_offset, __alignof(freeptr_t))))
>  		goto out;
>  
>  	err = -ENOMEM;

This looks much better, thanks.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

