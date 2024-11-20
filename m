Return-Path: <io-uring+bounces-4869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7BB9D3EDA
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:18:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10C471F24A88
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 15:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B971AB515;
	Wed, 20 Nov 2024 15:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lkXFCHbm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22071AD5DE;
	Wed, 20 Nov 2024 15:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732115691; cv=none; b=UeTJnLzM5RaMli8gzSBnFaU5stDBFofpHFRDGtBX+SIb3Y1TmcA6/i0ruGTk/vPhCCFtA4DSmx5wZu6uWh9tLPCRilvPXksNFopjLwo8TSmMdgUTAdxYr8M1Gm1Jp89SCHQ1h7PgyYXnXEfurMXsUG1Cw7H2uDwpLkTyRbDgyQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732115691; c=relaxed/simple;
	bh=ZyDgH3KaOCYGBcYWBFrDme86ufdv2bM6q4RHCtRdDq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QeeR0zVC2Z1OrAXGh5HD3MeXxg9azwkIjSA4ke6dfbalOYlPiHrGSVQVgE+OkQfWrVwyzB93i0xTZMD5JH4b34sE9+W9kt4JII9K1wzFmS5/5Cn42Ip7U/t+xa+Wa0LZXGjgpSGoXhN/DZAq48duvVSlWDnSk8D1NdGkMsJASaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lkXFCHbm; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20cdbe608b3so68463015ad.1;
        Wed, 20 Nov 2024 07:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732115689; x=1732720489; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Ku1MZJAz5Bzs7SE3oqIhwzzExWney3ixxSDkR7dCYa0=;
        b=lkXFCHbm0zeU050ZkHpVWQw5jrIcibol4CBlstekJVPpU0n2noX3iI46RMZIkYAYIj
         5lvoW9IQ7Ftug4dmw5Te+w77iJ1a7fMcnD4/7MdWClCpiONvi2LgNKkA4Cra/HZBJhf7
         DswtM9BxlHm46CjNpqqkepVlS2AZ5rByLPmjobtZOWMzOkPY9augK2aMB+Csfr9KX69B
         8lizNT1QOE61yckPTeHh00XQr+Pc1UjoOod9YjDAgko42pioN6TYz4C2Hod1euFs35jE
         DbV3veF82hJt66cLKpPv/rk4LbmtwFCqlzqMhKtemLcZra9/xK8to+T4ri0PXZg0Sq2P
         o/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732115689; x=1732720489;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ku1MZJAz5Bzs7SE3oqIhwzzExWney3ixxSDkR7dCYa0=;
        b=aaT7VoXkPv+5wh1DRLcEynBGO7plFx+GJmvMTcWnrcamoZmKlCaWxcT9M4vccnGkxJ
         IT8n5XFjZEq29iBPaEo9xXKF7fSpt88ieW0032co6RuCizzBSEQUUSjdQQ0XhE7X9ydT
         7cEtwTALRiAZZ34jv5THG+h0VZjYcTSHdBUMYvlMDC0tbQ7n9IGXPhCxtz2i8NOYoQLo
         sMNxr64V4ROmPOhel/2bySkjRZ3UCNat9G0eMRwanD+BcT8pOhsFL6eF+nZ3W/CmpZeT
         Nn+Gfd9cFCUNjTayRHshy4Gct3J9TK+OokJTAQpWUrxA38tyO6IOEq7sS1xgRh8FA8tH
         zwZg==
X-Forwarded-Encrypted: i=1; AJvYcCUh8VvaN9mT3L5I6iZeehNIFqRQtTFsw25O+4vB5oZ9zPZz2Noqw5epTQNoAsQ8mfuA3O6SPOq4Hw==@vger.kernel.org, AJvYcCWT4Vrhc3e4xsQfGHT50MyAiRasshqgoCkQ8mFbHNlLxnrxWIbE8dkByhDyGqnqUD9KpSFB+pMwFcYC4Q==@vger.kernel.org, AJvYcCWTlW9Zu6madD6n+ysnMTgKWi75pyd/Nbi0qifgnyC1pBeTGRIX+zj4xkj3ei2DAV179QupMK/NHA6mtDrB@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2aNYKhgQVloqLnr/kbspD990xEWHwreCYHDBa9fQfnasExGBq
	qdmwkssBEjZDrzgYxeRu7OgxrD+xe9NckXEDNK1N0XCOgTtND5OD
X-Google-Smtp-Source: AGHT+IFCGRfMUgd6ZOZpLObIzKajPBEboqB3VgqgN5jgyWp1xQuRbA4Qz6jd8S5Y+FZY7HoEPC/l7Q==
X-Received: by 2002:a17:902:f64e:b0:20c:a19b:8ddd with SMTP id d9443c01a7336-2126cb3c32emr29237725ad.51.1732115688826;
        Wed, 20 Nov 2024 07:14:48 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2125bb02b50sm27753165ad.69.2024.11.20.07.14.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 07:14:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <f6a16e3c-98de-4a56-8dd1-ea2cbac1874a@roeck-us.net>
Date: Wed, 20 Nov 2024 07:14:46 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
To: Vlastimil Babka <vbabka@suse.cz>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>,
 Jann Horn <jannh@google.com>
Cc: linux-mm@kvack.org, io-uring@vger.kernel.org, linux-m68k@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 07:03, Vlastimil Babka wrote:
> On 11/20/24 13:49, Geert Uytterhoeven wrote:
>> On m68k, where the minimum alignment of unsigned long is 2 bytes:
>>
>>      Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>>      CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-atari-03776-g7eaa1f99261a #1783
>>      Stack from 0102fe5c:
>> 	    0102fe5c 00514a2b 00514a2b ffffff00 00000001 0051f5ed 00425e78 00514a2b
>> 	    0041eb74 ffffffea 00000310 0051f5ed ffffffea ffffffea 00601f60 00000044
>> 	    0102ff20 000e7a68 0051ab8e 004383b8 0051f5ed ffffffea 000000b8 00000007
>> 	    01020c00 00000000 000e77f0 0041e5f0 005f67c0 0051f5ed 000000b6 0102fef4
>> 	    00000310 0102fef4 00000000 00000016 005f676c 0060a34c 00000010 00000004
>> 	    00000038 0000009a 01000000 000000b8 005f668e 0102e000 00001372 0102ff88
>>      Call Trace: [<00425e78>] dump_stack+0xc/0x10
>>       [<0041eb74>] panic+0xd8/0x26c
>>       [<000e7a68>] __kmem_cache_create_args+0x278/0x2e8
>>       [<000e77f0>] __kmem_cache_create_args+0x0/0x2e8
>>       [<0041e5f0>] memset+0x0/0x8c
>>       [<005f67c0>] io_uring_init+0x54/0xd2
>>
>> The minimal alignment of an integral type may differ from its size,
>> hence is not safe to assume that an arbitrary freeptr_t (which is
>> basically an unsigned long) is always aligned to 4 or 8 bytes.
>>
>> As nothing seems to require the additional alignment, it is safe to fix
>> this by relaxing the check to the actual minimum alignment of freeptr_t.
>>
>> Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache")
>> Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
>> Reported-by: Guenter Roeck <linux@roeck-us.net>
>> Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Thanks, will add it to slab pull for 6.13.
> 
>> ---
>>   mm/slab_common.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 893d320599151845..f2f201d865c108bd 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -230,7 +230,7 @@ static struct kmem_cache *create_cache(const char *name,
>>   	if (args->use_freeptr_offset &&
>>   	    (args->freeptr_offset >= object_size ||
>>   	     !(flags & SLAB_TYPESAFE_BY_RCU) ||
>> -	     !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
>> +	     !IS_ALIGNED(args->freeptr_offset, __alignof(freeptr_t))))
> 
> Seems only bunch of places uses __alignof but many use __alignoff__ and this
> also is what seems to be documented?

__alignoff__ -> __alignof__

Guenter


