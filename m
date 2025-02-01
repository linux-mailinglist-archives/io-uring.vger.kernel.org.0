Return-Path: <io-uring+bounces-6214-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB4AA249FD
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2025 16:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7712718850E4
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2025 15:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFD81C2324;
	Sat,  1 Feb 2025 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xgNGAxWs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CC51C3021
	for <io-uring@vger.kernel.org>; Sat,  1 Feb 2025 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738424328; cv=none; b=kdElTJ1mu2Y2/rO3PIFzIBZ18hfD7LBDdDFXzH3yATuKt6p4NQIz44jJWXt78L/LtWTof9awyzzwytAow3aZpca2rt/pudjN994j8SPZB24p37fpCkby5c0S1B1TmQ03x6gsQKxtMOdYJIHJn0aAmtqGikCJQspD24gFBsexfEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738424328; c=relaxed/simple;
	bh=T3UX4pDwFWwTzgKYV6IhqbmgRXz2grhQM2xawuLAF+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xf5EX0QANpspEq5G8gHcyoIt1lCFK50cSzhhHILCO663jL73bURQytL243EGktH12SUzOXqW/6fC1X795lfJGzpBKCaH4taBztstJNMOlJrjMyhr9NJt6AP4Xh4aGiAdc2H1H/J2JIkigmnxKb7aNPUslkbStGs0EBcrzCCV0FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xgNGAxWs; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-844ef6275c5so74847039f.0
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2025 07:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738424324; x=1739029124; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sK19sGcb61Rq3NH5lzGx01VpDfttDHo//maIlQCUBJ8=;
        b=xgNGAxWs0dL0AFOiFvvsW8UDPMame7st3NJMkAqc8DYthClQvu2NG/HP1jHOqptcYE
         5loMVVCxHheX70RpdQrhpmKKw2Fqadw+tTp5VgTSD4tcX26FqmACJvWchaCBHySDV2ZN
         gfTIGtWRyEjMVWHau6w5iAqn3ASmkg+1Av7asfjFd1sghn6BeTE79lNrDgkE7vi/FhDM
         mAQ9O3hphEzXFaM+iJ3B8IVRGkUi2//PHfr+73ZB701ckQK/anUxSRh1GdnG/qBPTBi0
         Usb1yNxApWLS0NgKMp5Ushm3tbg+tLnoe+3E1nnlXkd2K/Dz2jEFqeohNzW64IIzE8qX
         5aqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738424324; x=1739029124;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sK19sGcb61Rq3NH5lzGx01VpDfttDHo//maIlQCUBJ8=;
        b=jWbcuBNCKGKjy/+CFTForOS5a9ZvwiroJA5gRsuNheR/1hpEHFyCk7bqLOrDE41IOg
         4rI2cjxPy4T5yXsb8imyr2lax42frUfDSrKirXqqRYXmov4lwFU27f4s9WfQjEvEA23G
         yjIc0y+sz8R0Em1CVOpli7WV629xdQYQx6P3E4/nTc2WtdQ2LErPh2muz6fKnRUOBW7N
         GVVa+RmIN9SJYUO5fQ+TKNKHU1Ttbbuz8Zq6Mi+80b3k0HNlQQwrQIHdbPo44I6h/R5L
         Vkn7JEimUzLtPuuon9fJedr1pVTpujaWisum1qeEmYiUbBAL8D5iDFfIDLJX2c1/a7cz
         g/lA==
X-Forwarded-Encrypted: i=1; AJvYcCX3YcGcumKVHGI2v3EfBXyhdFB7C7LCZKoCmxfoTxKnEExQcESDPlwze8I86FpqaF2B0APSvwFSdw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxTCS2pQotX57Xh+OfkkjPUzcomaKABZ/OvtAxrF0e8G+zfZIA
	8j1kehUlkVZr6b2x5GjrfGWeJxdmlPeYXPY/c2dlk8/i+wK+3iTJADvZw2D6RoA=
X-Gm-Gg: ASbGnctWusVP84QLik9RQPiV6pXyz5dva+AjM50Tx/x+5bo7HbATmMgf1nKbvNRYJ1C
	HqtbwiOWxHrQ8ols0JU5U5iI66e4QJ/rc4UTtZit5F/88JVMxVKRfYFi+qi4HRCT2pomxnA6Ub+
	Dj5Ln3HKIeNLelve74LzaIzsurUPws+5acG1x5/W9sMw4zpx8YuuHxHHaLAh9vNW4ao/a7jDHI9
	3RmM9KCcEuU0KiW5Dl1OmCHMC4zRUTDLN/Gvoiw+nH0DhXCYNZ2Wzz+JfgPDO2ncBQXckT38wj7
	qkYC3lMh40Pb
X-Google-Smtp-Source: AGHT+IHHxywtrROfFyXITU+1sqWmIGLfAgdKi8CY5Q4qEEsfN5PaFnwCiujdXUybGoWxyWGqiHuFmg==
X-Received: by 2002:a05:6602:6d02:b0:832:480d:6fe1 with SMTP id ca18e2360f4ac-854006e200bmr1391491639f.0.1738424324228;
        Sat, 01 Feb 2025 07:38:44 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854a1619d8esm147577839f.28.2025.02.01.07.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 07:38:43 -0800 (PST)
Message-ID: <7c33ba12-2ec4-4692-b388-58950d42a0a2@kernel.dk>
Date: Sat, 1 Feb 2025 08:38:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Various io_uring micro-optimizations (reducing lock
 contention)
To: Max Kellermann <max.kellermann@ionos.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <7f046e6e-bb9d-4e72-9683-2cdfeabf51bc@kernel.dk>
 <CAKPOu+90YT8KSbadN8jsag+3OnwPKWUDABv+RUFdBgj73yzgWQ@mail.gmail.com>
 <f76158fc-7dc2-4701-9a61-246656aa4a61@kernel.dk>
 <CAKPOu+-GgXRj-O9K1vdGezTUGZS64w5vpkZg2MM-96vmwqGEnA@mail.gmail.com>
 <daaed11f-02c4-4580-9594-fcaef35a35fd@kernel.dk>
 <a6fa1317-f1bf-4179-9da4-a77f86b7523f@kernel.dk>
 <CAKPOu+8Xi3oBz3zwr1bJx+LN=6cZN5eiBsrvRLZ_vOMJuOpZ9Q@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAKPOu+8Xi3oBz3zwr1bJx+LN=6cZN5eiBsrvRLZ_vOMJuOpZ9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/1/25 8:30 AM, Max Kellermann wrote:
> On Sat, Feb 1, 2025 at 4:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> Not a huge fan of adding more epoll logic to io_uring, but you are right
>>> this case may indeed make sense as it allows you to integrate better
>>> that way in existing event loops. I'll take a look.
>>
>> Here's a series doing that:
>>
>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-epoll-wait
>>
>> Could actually work pretty well - the last patch adds multishot support
>> as well, which means we can avoid the write lock dance for repeated
>> triggers of this epoll event. That should actually end up being more
>> efficient than regular epoll_wait(2).
> 
> Nice, thanks Jens! I will integrate this in our I/O event loop and
> test it next week. This will eliminate the io_uring poll wakeup
> overhead completely.

That'd be great, let us know how it goes!

-- 
Jens Axboe


