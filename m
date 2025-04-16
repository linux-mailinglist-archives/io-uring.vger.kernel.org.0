Return-Path: <io-uring+bounces-7501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB4BA90D23
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 22:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 680064483DC
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 20:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7DA21B9C6;
	Wed, 16 Apr 2025 20:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dlCst096"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57761FF1B0;
	Wed, 16 Apr 2025 20:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744835292; cv=none; b=lOKd+tmg4juKoT+xiD7qKq6QZ4Zd67JPhDBHTB2+LrKH95OjzFuwuvW2eZiMASscc6QVnzsVqKsFyiP1LmMI1h1G1zleFQNwhn4uCPnT4uIRCHibe/iUVIm3Y41x3USE/fvbFgYEwOelXx8LCb4d3va28nUJ/mWh5ULcqAktIB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744835292; c=relaxed/simple;
	bh=oGv60f88wFOMZ8nbxRh++k35avlKCZ2ONgVPHUl3THw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kqq4nXjhlUdMkHkegLyiMKXUJtrfrRq8hjcFbWLcW74l5xYhN5DSOA0ef10NHn6Tup6f73Sy0yYcAairAtVo/GClZhtIoy1wSkRcDozqBMhC26s+3Let9IeeJizz+5v3tgK2l7+sPjdc7QgkO9b02loWWo51Im5XSt5bXBdAJ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dlCst096; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso4518966b.1;
        Wed, 16 Apr 2025 13:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744835289; x=1745440089; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AaXprle6cDrXGsY2dHuqdD9XHEmXdd8E5y6ZiFhnbm0=;
        b=dlCst096+aRON8AIMvt1+TmsCxwFs+Pza71VhK1ubuH8IKuIu9zvqskJc8w38aUuar
         TaOwjgybpF+1L1CzXqcc1zEpMCfT8Awsj4pwdjvbmPxB62jZEH+l532AGV5AMW8HnFe2
         ZBA1tajMAeVX6rRwocwtCzJSoZ7PIvfZgQBKphnmp7lwhdc0XNNBcqIRQbPwHcP1qVDD
         VmQCYuwtVaHmPPnM4ry3OLjDfWKz4cHEM58LbJiALF4ppPbz/xbcQHH4Dx0Beq6kW+c8
         b4XbsOE4t88/SZkPebXDFlQrwT9JEokrQS6uDJf0WyVqLg6fTUMrjsQcKgzTXUW6MmjW
         lTUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744835289; x=1745440089;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AaXprle6cDrXGsY2dHuqdD9XHEmXdd8E5y6ZiFhnbm0=;
        b=Xd9Cgt8/YoPXTDyvpP2mDnhyHf57sa3pSGo2Ey+lmyeN82yKnbUmaZLJIOie8/d6PT
         nRqtRk8wC/gqbOBKNuCvqljDuSmjo7GyY1ZhmUe/Y7eAxZIGEy4vFWRD1VaoTnuIPqJH
         VFCugjyYKhRohaNPe/Eamsl8eLu24DDZv1mph3vWdOq+mnfUfHd0x8QCr6/EHHDIzEN2
         Us9s9as/d5VXnZGRbFl8uKuyb+eqZo6ue99zzXrJ6ctI85wPr3Zp02U+zazznxAu5aVI
         rNfV7a2AmXr//CFwjhTUbHESs6nh8mBkPOUbZNAwcSHQErLQBTv3y+QM2YkU5UKUl5i/
         00Ag==
X-Forwarded-Encrypted: i=1; AJvYcCW2u1RwtYeTdrzPprwZ0RKM2+46rO62XIz8d7dX7rD6ggibcdyBfzzngyz3SshsQ308oLXbqxZNmjLZ2yOa@vger.kernel.org, AJvYcCWbt3jrYvQC2m/XXk6ePGiJItNadjbJwAZtJIkLf3uLcjc4Nt1ucRw47GIhV47oCMtPdafCFr8BiA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg4PDmSVhibOwiSiAt4GTdlKkexEtflEJMMXd6ke+j1M+yh1WS
	TTBDylF8Qn7u5vRTCqp0OXMNz3Cz16vpsQLLUMaLlbZ6vZCYu106AS7Ej14d
X-Gm-Gg: ASbGnctn7qqFg0mCrdF6hbODiWgg0lpxJFVRuXt/ziz80dPc/Ud3BJRIMHU0ZIcreiH
	pUO9gs6kq/axdIaCH1tNmqdzpjpC0AOb/fKdTSMYx+WUXRyXYujEDz56E4IrO82CRPIbthFqUeV
	xsejpopaoXN9FdsSrGynOTkAfoJKW5uVhx6szt8uYlxEnfYRKFfCkxhdNYUW8eYYzc5Nql4pPL0
	W9fOeWQqB2hHBYucupSWKXeUoWce6MPZifIvVU9cwWRSHghrNtEle/jaM2ITp3z2xOnDGRdm+1w
	s/wezOlwJB8PHqGD5OKK8SQFDvmn1amjo7mYmRiJ3xk2UavceA==
X-Google-Smtp-Source: AGHT+IENzUuPLYa3T4jTgKGONr2A15tgd31IupZrgfyaBSFxIJd6iJ6DrWOYR25eddvvykjtjq/H6A==
X-Received: by 2002:a17:907:7fa7:b0:ac7:95b3:fbe2 with SMTP id a640c23a62f3a-acb42c5a12fmr244345566b.56.1744835288836;
        Wed, 16 Apr 2025 13:28:08 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.144.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3d34a20csm180355366b.181.2025.04.16.13.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 13:28:08 -0700 (PDT)
Message-ID: <a2e8ba49-7d6f-4619-81a8-5a00b9352e9a@gmail.com>
Date: Wed, 16 Apr 2025 21:29:24 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Jens Axboe <axboe@kernel.dk>, Nitesh Shetty <nitheshshetty@gmail.com>
Cc: Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
 <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
 <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk>
 <40a0bbd6-10c7-45bd-9129-51c1ea99a063@kernel.dk>
 <CAOSviJ3MNDOYJzJFjQDCjc04pGsktQ5vjQvDotqYoRwC2Wf=HQ@mail.gmail.com>
 <c9838a68-7443-40d8-a1b7-492a12e6f9dc@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c9838a68-7443-40d8-a1b7-492a12e6f9dc@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 21:01, Jens Axboe wrote:
> On 4/16/25 1:57 PM, Nitesh Shetty wrote:
...
>>>                  /*
>>> @@ -1073,7 +1075,6 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>                   * since we can just skip the first segment, which may not
>>>                   * be folio_size aligned.
>>>                   */
>>> -               const struct bio_vec *bvec = imu->bvec;
>>>
>>>                  /*
>>>                   * Kernel buffer bvecs, on the other hand, don't necessarily
>>> @@ -1099,6 +1100,27 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>                  }
>>>          }
>>>
>>> +       /*
>>> +        * Offset trimmed front segments too, if any, now trim the tail.
>>> +        * For is_kbuf we'll iterate them as they may be different sizes,
>>> +        * otherwise we can just do straight up math.
>>> +        */
>>> +       if (len + offset < imu->len) {
>>> +               bvec = iter->bvec;
>>> +               if (imu->is_kbuf) {
>>> +                       while (len > bvec->bv_len) {
>>> +                               len -= bvec->bv_len;
>>> +                               bvec++;
>>> +                       }
>>> +                       iter->nr_segs = bvec - iter->bvec;
>>> +               } else {
>>> +                       size_t vec_len;
>>> +
>>> +                       vec_len = bvec->bv_offset + iter->iov_offset +
>>> +                                       iter->count + ((1UL << folio_shift) - 1);
>>> +                       iter->nr_segs = vec_len >> folio_shift;
>>> +               }
>>> +       }
>>>          return 0;
>>>   }
>> This might not be needed for is_kbuf , as they already update nr_seg
>> inside iov_iter_advance.
> 
> How so? If 'offset' is true, then yes it'd skip the front, but it
> doesn't skip the end part. And if 'offset' is 0, then no advancing is
> done in the first place - which does make sense, as it's just advancing
> from the front.
> 
>> How about changing something like this ?
> 
> You can't hide this in the if (offset) section...

Should we just make it saner first? Sth like these 3 completely
untested commits

https://github.com/isilence/linux/commits/rsrc-import-cleanup/

And then it'll become

nr_segs = ALIGN(offset + len, 1UL << folio_shift);

-- 
Pavel Begunkov


