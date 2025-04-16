Return-Path: <io-uring+bounces-7502-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67242A90D2A
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 22:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CFC3460B97
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 20:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D96322A7EF;
	Wed, 16 Apr 2025 20:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xlKsNpc+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFBE1F941
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 20:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744835457; cv=none; b=aY6FlDU7a5bHPyNqyvK6Ltq+i7cITwbfJ1vX6CsNAJEFqBssiubb7yIPMvwRye167iGC8JvHeY/VDtyJFX2gvt0I/ayzxpQX/p6ixKQtHxUVFflApZYe4qF1+dX8mnsauJudieNe8BkERAbGezvE+jjswKwalLXBmGmwW9ySsgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744835457; c=relaxed/simple;
	bh=fwEXLVF3NjvbkVQNZLm1W1TGuZQo5WekFBzeeafE/YA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Aj8tgptSuIcxGSGaCXS+aD+NrNcVs9DPYuF8KbXJEi0ss1irMWvoeoaPPd+tpmJHDhOZJwcNnlCIDsu3cn9twbz28SMiP0GpyutEqpQaInOU5QW8J5aLAy3ihOWz12B9WwQRQBAm5+shRO9e8A7GpLF3PX4Wm1J6theh9x8k7/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xlKsNpc+; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d8020ba858so1037995ab.0
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 13:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744835453; x=1745440253; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dGUTT/lWSpORtrlToc6IyMlIPu8KSjeLNYbuYnB9eYA=;
        b=xlKsNpc+FMipqp7+9EPHmSALPd9CnGUexhV4U3tzn6MCSr1yCU103XJAQQYF5Q312b
         8MkralVGUd4rFcAOzypre3GxFicNyXefu39mWO2bd0gBCJHlXSzJx6EQMqOTmhhpqwH/
         gorto5JKY0z9m8DKjDNpQzSz6+fKufAhECWazVakJDJjPOTkZmowDqQ3tbnbNJvc97RC
         clks99XQl/v3UiaSSX5Qg2OW0aY5pb7+6p5f0b+mNolUwHdkvrcdiMdVxsPAGjIXLUCr
         L0AdDP/Cw4bkrmSqqvPbQJzzDRY3S8lTOhGVsGmFVWGRSzZx5Fx1kTr7FuE8iYAlRENf
         VLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744835453; x=1745440253;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dGUTT/lWSpORtrlToc6IyMlIPu8KSjeLNYbuYnB9eYA=;
        b=qp9kk7nNxDc8/JFYIMfUnQaItwJBwfOT/KaLRVFfKvKoiZu2ogFMp13R4ChsNG9RDJ
         r175MW8Rr2NejrdtBKwf83LFa9Mqd02Di6w6CMLOoXvL2v0qfs8kuxWXweYh0uNxfgVj
         9HCq0vlqiBwqGeIzNdtIpte0E/lzW9c1PwDT1x7a4i2VIKU3uV8AmpPi0NqrrjCRdIjQ
         NKgeiO0/ClGFtCkwDF0IdQvFFggWszMvFaF75qozraCxWEGatUXk85o9yoL9ygGIaCGG
         8iwrducWW10VztxMBh3Ol3ap8ZI5sFPnabaZebrJl08TN0TxhVoWwN8GXL4wLtqD1RJR
         Rt8A==
X-Forwarded-Encrypted: i=1; AJvYcCUfsqUFkE2ZbIuS3TNa1Gu1hWblzpFbqxV8hsaWfi0V7QmnmA6Ex+yA9we6/RTpeJp1vXO9hcf42g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfhFHojl/6qAzy/X7ppLrtfJnm9FagUFeyb6CdTQ0gQgDd+AOS
	Ws0OLgHGyaYPe7GBqgx7jiIV66fccG6uZmUmeRwRSNIb8Ni9shPfNDDs25iLriM=
X-Gm-Gg: ASbGncuzVAK35m5xzS5xHtmLsfrRYwBR1dpcXl6iXJibAollpFdmVihY09NKnWXZ/eb
	6XOBs0DwTL9Ooa+MDUnPlKPfNrYkU/s5/tmWwx+AsJqw50mZYM8qc11y+CYSW6odCgv/6DmkI2P
	XO4Qf/3Mp9NpvnzXx21LwdYpXifs5LDWK/H5r4wFJViKVu0PzdtjP0QjfMjkF5QFOoy2i2DlAiX
	0mNsuhNzRIMZiCpwgiICIT7tC6khScybJIrTiyGFtDXWLUJ6n2A6GEeGhnFvh8Q06sBuvA5XXHE
	a1kbIKlxebP2u6y95c1ZVTOy3xGpwD9j3Skk
X-Google-Smtp-Source: AGHT+IFDDD/8plEBM4AJMOO5gtDj+LAJA2MRyJcLsq++oUu7HoSM6ArqnJJxil2pQmcbmIzlEZbGbA==
X-Received: by 2002:a05:6e02:1fe4:b0:3d4:3ef4:d4d9 with SMTP id e9e14a558f8ab-3d815b5e71bmr30969255ab.14.1744835452932;
        Wed, 16 Apr 2025 13:30:52 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505d3c323sm3775705173.74.2025.04.16.13.30.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 13:30:52 -0700 (PDT)
Message-ID: <a263d544-f153-4918-acea-5ce9db6d0d60@kernel.dk>
Date: Wed, 16 Apr 2025 14:30:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Pavel Begunkov <asml.silence@gmail.com>,
 Nitesh Shetty <nitheshshetty@gmail.com>
Cc: Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
 <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
 <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk>
 <40a0bbd6-10c7-45bd-9129-51c1ea99a063@kernel.dk>
 <CAOSviJ3MNDOYJzJFjQDCjc04pGsktQ5vjQvDotqYoRwC2Wf=HQ@mail.gmail.com>
 <c9838a68-7443-40d8-a1b7-492a12e6f9dc@kernel.dk>
 <a2e8ba49-7d6f-4619-81a8-5a00b9352e9a@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a2e8ba49-7d6f-4619-81a8-5a00b9352e9a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/25 2:29 PM, Pavel Begunkov wrote:
> On 4/16/25 21:01, Jens Axboe wrote:
>> On 4/16/25 1:57 PM, Nitesh Shetty wrote:
> ...
>>>>                  /*
>>>> @@ -1073,7 +1075,6 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>                   * since we can just skip the first segment, which may not
>>>>                   * be folio_size aligned.
>>>>                   */
>>>> -               const struct bio_vec *bvec = imu->bvec;
>>>>
>>>>                  /*
>>>>                   * Kernel buffer bvecs, on the other hand, don't necessarily
>>>> @@ -1099,6 +1100,27 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>                  }
>>>>          }
>>>>
>>>> +       /*
>>>> +        * Offset trimmed front segments too, if any, now trim the tail.
>>>> +        * For is_kbuf we'll iterate them as they may be different sizes,
>>>> +        * otherwise we can just do straight up math.
>>>> +        */
>>>> +       if (len + offset < imu->len) {
>>>> +               bvec = iter->bvec;
>>>> +               if (imu->is_kbuf) {
>>>> +                       while (len > bvec->bv_len) {
>>>> +                               len -= bvec->bv_len;
>>>> +                               bvec++;
>>>> +                       }
>>>> +                       iter->nr_segs = bvec - iter->bvec;
>>>> +               } else {
>>>> +                       size_t vec_len;
>>>> +
>>>> +                       vec_len = bvec->bv_offset + iter->iov_offset +
>>>> +                                       iter->count + ((1UL << folio_shift) - 1);
>>>> +                       iter->nr_segs = vec_len >> folio_shift;
>>>> +               }
>>>> +       }
>>>>          return 0;
>>>>   }
>>> This might not be needed for is_kbuf , as they already update nr_seg
>>> inside iov_iter_advance.
>>
>> How so? If 'offset' is true, then yes it'd skip the front, but it
>> doesn't skip the end part. And if 'offset' is 0, then no advancing is
>> done in the first place - which does make sense, as it's just advancing
>> from the front.
>>
>>> How about changing something like this ?
>>
>> You can't hide this in the if (offset) section...
> 
> Should we just make it saner first? Sth like these 3 completely
> untested commits
> 
> https://github.com/isilence/linux/commits/rsrc-import-cleanup/
> 
> And then it'll become
> 
> nr_segs = ALIGN(offset + len, 1UL << folio_shift);

Let's please do that, certainly an improvement. Care to send this out? I
can toss them at the testing. And we'd still need that last patch to
ensure the segment count is correct. Honestly somewhat surprised that
the only odd fallout of that is (needlessly) hitting the bio split path.

-- 
Jens Axboe

