Return-Path: <io-uring+bounces-9794-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3EBB584CD
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 20:41:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE9BD1A27E05
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 18:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EAB27A92A;
	Mon, 15 Sep 2025 18:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="USAGgIRa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D64E573
	for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757961690; cv=none; b=bpLlsJbzxaBoQMYA+2N9ZEMea/sNJMHnmi3hN5gqIyhI60oPLd/pyMftzMqOEPGeYHxKy6B7D5WwAWhP3OWsusr8r9x9g9mYinRfV96zKd3rWNshzv8sg9Pr2xFCBP5SvtQoONBb1z3UZcTiWE12/iy0L0lKSOceUBj8ccl3/3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757961690; c=relaxed/simple;
	bh=m+gQ3dajKNM4kPuUVbi2LpaZ7KdqYsad9CRgy6wYe28=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UUSZfMZ1z27okc/PzpaIGD/8ZIByZKa0iMHN1hagsVfFFR+nqi4iHNgyXWilTu+hX6xD7Gcku3zXayaJhVHz/I/aD71ifUy6ZvbH8x/apevO594H5Wh/qQXIWqzHXr87zx5+8BoYQbZjn/jXIZNvBym3VWxbtbJd25Xnhl7DjKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=USAGgIRa; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-40809f7ffc7so21906345ab.3
        for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 11:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757961684; x=1758566484; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=73BHzxlGQ2oAWsvNFV/kvYu1Qi+79ancLpPmgGlkXOA=;
        b=USAGgIRaUeXI9Tff4sx0KZLb830Tl/DUsFNhnrocKbhbfeXxZ71FEIS5ZA5/2Rk+FU
         gHOCW6pnJSZ0qSrSviu25vTi+fMIDyGoL+fGSopLevrtlusII9jVAw1sewjubWhWV3jf
         v0jEbmMGLUPDuFNts/ucO1UyceG6rb0MTm+HyGfK/JDHv9DelzyFu3YDyLoiEAgvUmLy
         clSBDht+GXOiV1bhTrmb1g/96E/sf5u88M2FLsiHhXZyjqhHmQU1kIpQERGlzHydrwCy
         6w0PMY8LxnAO2xiEsGmYOKuWgf6EybJzbyywkqbCSIGQNW65vN3aP84TfdPXadpp1dKM
         6s0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757961684; x=1758566484;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73BHzxlGQ2oAWsvNFV/kvYu1Qi+79ancLpPmgGlkXOA=;
        b=r8AvDDZp5+afSNlc1H2ENS6I9eyjzAUzJfayVzC95SBoAH1RCDQ4V9Jm0vmsDok38J
         bqxMFR0AMWq8O0hwJtsaYeKxVEB8CG0iR1Ldfn9aW2euk/sc8+q/p4Ac3gBz4qJuWFEl
         xWzGcBJFqpg8b6jGi4oAd2dutf9L1Is4nefqTP6qPiv587ZrzvycXUXDltQse497dg/4
         f8k/y+JPtZYsoNKO9jdJE4UkhWvlivu6CReWEYm3J+5g81UzZK5qDUqE3kLQpRkP116x
         FxHDU5dB0oRUFYYp1q6fVYXauzOGlzsqiDV0Q4phDlwO0rbAKmcNJJXqTgexrwEO1sFx
         lYJw==
X-Forwarded-Encrypted: i=1; AJvYcCUnYTyryTk6ll0BFlMGPyrxFm4I7TZ3EKUVQ4TRlXX9E9yIewZ3f8HfEuENM9qSiJCkUkG3pA8cxA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxX+fy3dcvzXeiefSmjaFLiI9eGiP1D+Ii6kWgopBu0HZWKDZ3v
	IiLpNXKVH22Ft4I4wbHyPy5ld4KNVY3xNLHfB5bflNElYNRE52id5BUT8Lt1kFHFdb3zxO0XfQD
	EsoQc
X-Gm-Gg: ASbGncs7K/GQ/24KALB5Hg06tOGn7ipo/YRXXA4YcGXhDjD2+iTKSnOm2CLVXgHt9xr
	+/sEOxS09+e+pbmvnCPguG45QYqfpp8oys1miy2zvAT2/oUDtvV2tLfcymSkP1pG9TeTq+ANdgG
	YnDKwZ7oM2ZtsPXD8P6hpSF4wuZcjWi9f6Y7pmp2aqOGlvECESIhuslp2KJpIvGjDPkPLYTBPpm
	/tXokswunNpNRD1iSH5pzI2sYMsRJgRRmX/nbH1SYwtV5n+TvPOs2ECrm4tmor4qbueI4UN204w
	WZ21pT8wCV4WWxX4lVBHCX2BTZHDQyMiHF2LYANHxp785VRlGe/wg3imwT6pPxdAFHXhASEtxQD
	plrl3DazlaJNDhwkePx4e862R3E7dONmExyeN1zId
X-Google-Smtp-Source: AGHT+IEyELtb67xaPJYzhM17YEB6GjuJOfuSmifYaXXyrwqPBJ8BsUyKD1Xkew1fNZP1UXyVXL41HQ==
X-Received: by 2002:a05:6e02:1909:b0:415:2b3d:651a with SMTP id e9e14a558f8ab-4209d40fef6mr128107275ab.7.1757961684519;
        Mon, 15 Sep 2025 11:41:24 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-423fdd050f3sm27283825ab.38.2025.09.15.11.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 11:41:24 -0700 (PDT)
Message-ID: <3acf3cdc-8ace-42e6-a8a8-974442d98092@kernel.dk>
Date: Mon, 15 Sep 2025 12:41:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring/query: check for loops in in_query()
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <2a4811de-1e35-428d-8784-a162c0e4ea8f@kernel.dk>
 <a686490e-03f0-4f21-a8d6-47451562682a@gmail.com>
 <6e347e14-9549-4025-bc99-d184f8244446@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6e347e14-9549-4025-bc99-d184f8244446@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/25 5:40 AM, Pavel Begunkov wrote:
> On 9/11/25 10:02, Pavel Begunkov wrote:
>> On 9/11/25 01:13, Jens Axboe wrote:
>>> io_query() loops over query items that the application or liburing
>>> passes in. But it has no checking for a max number of items, or if a
>>> loop could be present. If someone were to do:
>>>
>>>          struct io_uring_query_hdr hdr1, hdr2, hdr3;
>>>
>>>          hdr3.next_entry = &hdr1;
>>>          hdr2.next_entry = &hdr3;
>>>          hdr1.next_entry = &hdr2;
>>>
>>>          io_uring_register(fd, IORING_REGISTER_QUERY, &hdr1, 0);
>>>
>>> then it'll happily loop forever and process hdr1 -> hdr2 -> hdr3 and
>>> then loop back to hdr1.
>>>
>>> Add a max cap for these kinds of cases, which is arbitrarily set to
>>> 1024 as well. Since there's now a cap, it seems that it would be saner
>>> to have this interface return the number of items processed. Eg 0..N
>>> for success, and < 0 for an error. Then if someone does need to query
>>> more than the supported number of items, they can do so iteratively.
>>
>> That worsens usability. The user would have to know / count how
>> many entries there was in the first place, retry, and do all
>> handling. It'll be better to:
>>
>> if (nr > (1U << 20))
>>      return -ERANGE;
>> if (fatal_signal_pending())
>>      return -EINTR;
>> ...
>> return 0;
>>
>>
>> 1M should be high enough for future proofing and to protect from
>> mildly insane users (and would still be fast enough). I also had
>> cond_resched() in some version, but apparently it got lost as
>> well.
> 
> Tested the diff below, works well enough. 1M breaks out after a
> second even in a very underpowered VM.

Honestly I'm not sure which of the two I dislike more, I think both are
not great in terms of API. In practice, nobody is going to ask for 1000
entries. In practice, people will do one at the time. At the same time,
I do like having the ability to process multiple in one syscall, even if
it doesn't _really_ matter. Normally for interfaces like that, returning
number of processed is the right approach. Eg when you get a signal or
run into an error, you know where that happened. At the same time, it's
also a pain in the butt to use for an application if it did to hundreds
of then. But let's be real, it will not. It'll do a a handful at most,
and then it's pretty clear where to continue. The only real error here
would be -EINTR, as anything would be the applications fault because
it's dumb or malicious, hence the only thing it'd do is submit the whole
thing again. It's not like it's going to say "oh I got 2, which is less
than the 5, let me restart at 3". But it now might have to, because it
doesn't know what the error is.

Anyway, that's a long winded way of saying I kind of hate needing any
kind of limit, but at least with returning the number of entries
processed, we can make the limit low and meaningful rather than some
random high number "which is surely enough for everyone" with the sole
idea behind that being that we need to be able to detect loops. And even
if the interface is idempotent, it's still kind of silly to need to redo
everything in case of a potentially valid error like an -EINVAL.

Are we perhaps better off just killing this linking and just doing
single items at the time? That nicely avoids any issues related to this,
makes the 0/-ERROR interface sane, and makes the app interface simpler
too. The only downside is needing a few more syscalls at probe time,
which is not something worth optimizing for imho.

-- 
Jens Axboe

