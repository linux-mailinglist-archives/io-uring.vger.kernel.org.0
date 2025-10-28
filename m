Return-Path: <io-uring+bounces-10264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A89AFC1562C
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 16:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8029C1B231E0
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 15:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79AD633DED3;
	Tue, 28 Oct 2025 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UkTT+cT5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C2633DEDB
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761664785; cv=none; b=lUtZBwRNvMJTwm50IlP9XHzy7TlGPW7w+wIlxN3LKtzHIGzdIZMJ6yMUhOqq2X3usyBgbl59dIy6z+H/9w/Pq1uGqbshXYNiGELhvYVjr2qhDIhWsad4uuUasJcYcdejcUvl6rZjBE08KVtWL2/Td2j1ONNKvZxpOGnxi2bqX2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761664785; c=relaxed/simple;
	bh=BjbzetwQv6Bsilu89J5EpXRhOw8Ysn7y7vFao6Ssjy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ffTPrGKqgbsG2g+D/MvKOd1r/7m/Jepz/s+/7pfjlVGxHbIhT1ib1m6T1DPls4kByYj9Oa2Dq0Ej0OZJM+zyy8bHLovSkHAhLuVEzG2T74+dPrUAjt6fFnmmcD6mbFSUhmxeZiyrg8gsYuyjDVmBpJ8gZvq6xDc2g8YWpd/BpaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UkTT+cT5; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4285169c005so2880288f8f.0
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 08:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761664782; x=1762269582; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BioniqG27FeE1CBYn4tPxLiuT1Y01dzhZXQilAmS4sI=;
        b=UkTT+cT5gtxms1WsgTuhokxlwr0zBer/lJmuxCmnzz9UVClWmjqXOKH+26QxuT3+qv
         h+qp0kmh1VTFTWAf88YH5nLuhQHcs6U9SH/QhO2oN5N+DLo/hLCJF0a+Wde6kzJp/VLE
         rOSmK1jA7IPjqadtJNmvT20v4eNZ5LJ8OZPGWZK4s4g0e5zcYX9V5d45jS/lX1l4TXyu
         gGlw0wZ9s8KuajdgecH113ObPFmXMztnesON/I2OBJZP4wVMFoYDQ0GTQ6K2N67gCbi4
         8u51+sEhPJtPp2uQqH1D34s2/UoQKdum4Bcc0tNOlbY9x0TzML31Iv5WoCxcBf08UJSv
         k6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761664782; x=1762269582;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BioniqG27FeE1CBYn4tPxLiuT1Y01dzhZXQilAmS4sI=;
        b=JBfaBSj9SvVG81aGvHOcheu4A2u8gts1q5VINLiIhIVLxr2pbdC+DSu+shjl9g8DRK
         I7b8JOhzpucfd9CDHJSYV53Ab9H4PAzB7cmjZp/N+veKaAjmKoxGM01qq5QMCdw1awTc
         EN1V94d4YkurQ1lCOGwUdUqHyBxHZwTwKFJLN+IeNS9iQ9nbVsO1fh5QlVYSoON6oUZM
         qV/D2yd7e1jHNBxhkOptuWBg3ld1Jxol+E8H54I8xYRO5IYxTNTUoCSig3Rdr++h6Hec
         5frFm0AoT5V5drsV0O0GOaxRT9pKJTDUvKNdmoMlQLRf8sJSnvQwypCDtwrj5J8NErHf
         bsJw==
X-Forwarded-Encrypted: i=1; AJvYcCUUW6PCAOOfBtrMOt6e1qo2tpgLblsxJGWC/XrPrysXxR+kwS6AlL/GdjDfn59qmQQnaViX+Xe6/g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz68qUCutVrtknQ7wsvYiVGyJ9HRYhk7stbjiUxV92d45T/q898
	SdTONJ/hQoBu2+WeZaDdsb3uoeCEHWtWYaND0SGTFhQs6E5q9Wcens0m
X-Gm-Gg: ASbGncsQrrSrwigfTHQbVvqFshEf6+IS7oC/m7CK4ZFFcPSyOMQcrkJLh8EBXFhdYkP
	WrNINTlEzr/pXKZaayDnAauEYDk2YadsHTwLvsm4e36zMw551Jl+j73IbGxgWQY6o49yiendy3t
	LObT/cL9kap9eCihUEjiU+pon3HQiHxAlpg68y/gOdHXl5CbfqcoM7q9hRmI54N7SJdX/q49xam
	PklNlUgILhSFk84UolklBAthVp3EAl0SZ1HYjrWdtikoL8S+ZVQdNeR1rRCJx+5yYM662XEQiQC
	KU5o1K6LfHposH6Kuh9pMPdSVSCCm24V1NzdGvV6Wdwn+aKP/6grdSJKxyMoTaezu3R0sdlogG/
	Al2OvnDdZ0opCt3HeH3r2QlYkgWNdcyR7BiCwGb42aTfJ308mJzkTRb90bUmWgxw8xmlBCdVqNx
	J3/z6YdLmq+bygJ3mnmK1mAB2Ve2CkjcoxMYgdnNpOd8UKXrb4XRc=
X-Google-Smtp-Source: AGHT+IGYRyw4Duw/YLIGUsBx6zkDmCTv/uBD5BMN2eCudueFMvGTUNv+wFlSzZU8uJW0IDaVSzTanw==
X-Received: by 2002:a05:6000:3107:b0:427:690:1d84 with SMTP id ffacd0b85a97d-429a7e7c43cmr3158305f8f.32.1761664781689;
        Tue, 28 Oct 2025 08:19:41 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952cb7d1sm21214094f8f.16.2025.10.28.08.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 08:19:40 -0700 (PDT)
Message-ID: <64101298-06d3-4db6-9156-42343dcbdfff@gmail.com>
Date: Tue, 28 Oct 2025 15:19:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] io_uring/rsrc: rename and export
 io_lock_two_rings()
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251026173434.3669748-1-dw@davidwei.uk>
 <20251026173434.3669748-2-dw@davidwei.uk>
 <c3a45eaa-0936-41a7-92cd-3332fd621f6a@gmail.com>
 <74cac804-27b5-4d25-9055-5e4b85be20d6@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <74cac804-27b5-4d25-9055-5e4b85be20d6@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/25 14:54, David Wei wrote:
> On 2025-10-27 03:04, Pavel Begunkov wrote:
>> On 10/26/25 17:34, David Wei wrote:
>>> Rename lock_two_rings() to io_lock_two_rings() and export. This will be
>>> used when sharing a src ifq owned by one ring with another ring. During
>>> this process both rings need to be locked in a deterministic order,
>>> similar to the current user io_clone_buffers().
>>
>> unlock();
>> double_lock();
>>
>> It's quite a bad pattern just like any temporary unlocks in the
>> registration path, it gives a lot of space for exploitation.
>>
>> Ideally, it'd be
>>
>> lock(ctx1);
>> zcrx = grab_zcrx(ctx1, id); // with some refcounting inside
>> unlock(ctx1);
>>
>> lock(ctx2);
>> install(ctx2, zcrx);
>> unlock(ctx2);
> 
> Thanks, I've refactored this to lock rings in sequence instead of both
> rings.
> 
>>
>> And as discussed, we need to think about turning it into a temp
>> file, bc of sync, and it's also hard to send an io_uring fd.
>> Though, that'd need moving bits around to avoid refcounting
>> cycles.
>>
> 
> My next version of this adds a refcount to ifq and decouple its lifetime
> from ring ctx as a first step. Could we defer turning ifq into a file as
> a follow up?

The mentioned sync problems is about using a ring bound to another
task. Decoupling of the zcrx object from io_uring instance should
do here as well. Please send out the next version since it sounds
you already have it prepared and we'll take it from there.

-- 
Pavel Begunkov


