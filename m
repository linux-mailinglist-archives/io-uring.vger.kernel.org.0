Return-Path: <io-uring+bounces-824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B30DF871118
	for <lists+io-uring@lfdr.de>; Tue,  5 Mar 2024 00:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69C4B1F22065
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 23:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028571E86E;
	Mon,  4 Mar 2024 23:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LdN2/oST"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B43C1E4A2
	for <io-uring@vger.kernel.org>; Mon,  4 Mar 2024 23:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595412; cv=none; b=ewF1xabGF/bFe44WuxL+rKwdKNpjjqd3f8xJfMOk6AGE837tiM7Kr6yznp45qWc0RkVdrZP03t2o5xXyPdC1eeRsozptE0fQNL32K2lFHotuboVRTfcrjoV7UL+wL/eqKzJwhrfnBGnaouYhdcAqvZ/7L4osHFT8GxiVnO916VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595412; c=relaxed/simple;
	bh=fpJE2If+VDv1ZORwIotcPQkxoKW30DifI/wCXn6YjV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I9vqKlx1HgpIzfjciTMf8TTOALPhhhajWsAIiE87x8FuOPpHzopjIUX/b14HKwLx8w/RmdEnUHDmFdOmOOa0RbjGgCJVQ6Jm3Q6VpITJdn2R5prq92YEnEdwkp37q2vo+MhRuMA38Tqy6Zm1xVzFX2u4B0qu2PD/ewAq6aU4FlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LdN2/oST; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7c84125f416so28863239f.0
        for <io-uring@vger.kernel.org>; Mon, 04 Mar 2024 15:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709595408; x=1710200208; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O33nzKIr9jgT0BpLbu5qZGEVG5Rie/COmtUtSE8OPhE=;
        b=LdN2/oSTfI3d0BCCe2maPSlx0lPcfiK+HtdcCHPhd8RQmqmzqHO2RodXWr7YjZTA7s
         sek/BuZb9qc3EXjRpf+IL8p4F3MEmE9eM1qi9N77K6ePJYgYv8h0cC2PQLRWCw5nGI50
         kwKhFqYUwZ2C8kgVpxvcBvsaCuKChRZd4fbDhHp3V4jNhgK82995B6Nzqs0IfWelb1T2
         VsON0T6a06OquJ78EctS5lru6kRSQ4xWgnJPKIgXhlp7pp3s6QLMZ3cjNcZLKhS9Zedp
         TOGpF642IK5Q5+TGmwyz2iLG5XkFaaVAzi1tzUnHR3Uo3jqopcX67zyRMK9YBWFhCmlD
         XWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709595408; x=1710200208;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O33nzKIr9jgT0BpLbu5qZGEVG5Rie/COmtUtSE8OPhE=;
        b=iq8wo5+osh8eWKFFLCzTQbiEITjoQmbU6+yXm10aZ6ugqiH7F9NykrG0EqXGEngGEX
         6hcsyCrO04cxRe5e+ulAAXHpGAWLqk5kirfNZ0yKkPFdzclnMw9II28HRgqaRODNLC2t
         1Kd8DQVRSEHTualzP9nMJiuiwKxOid/RVtLVxWCCBg9cEm3ZKcCy6yxeU1tAXscC1HaG
         HAyl2NQWAAcGsnVMRKIJzrV1xS53ycyoNGG2svPhg3c9lNbU07IJqVWyKcwdZLFSuBhw
         cTQkOVhnUvydjBmY36MNYtymcxfKCX7dzHWQ3fj2V4HXOGYLlATd3YCJI+madWUIaLrx
         70kA==
X-Forwarded-Encrypted: i=1; AJvYcCUvwfBaXUBrt+L2IK7tLAqie1OfKOj1BcbnMt/v9c5LMKuMtMbIIblSAx86YCa5nqSYNGhnv1N5pcbdYXaFAYQCAGGsNMJZGFo=
X-Gm-Message-State: AOJu0YyIIUZB+hppAmYAn3P6B8spvQK+68uDPE0Ng8bDZhmIvPWd4SSO
	no+hkfWgccBFGadOOM1iZMqleW5Ta62Gz7ytUnbodZwikzA+MRgQZJimWsma27Y=
X-Google-Smtp-Source: AGHT+IF7QgjJMYnKNkc/Wuj8QtDN29ErcvU5TIFnRk3z4gRvIMJVJx2jV5qmycxwEvbyHcEMKvHUiQ==
X-Received: by 2002:a05:6e02:1bea:b0:365:2f19:e58e with SMTP id y10-20020a056e021bea00b003652f19e58emr10985461ilv.3.1709595408398;
        Mon, 04 Mar 2024 15:36:48 -0800 (PST)
Received: from [172.19.0.169] ([99.196.135.222])
        by smtp.gmail.com with ESMTPSA id p4-20020a92c104000000b00363da909ebcsm2820510ile.56.2024.03.04.15.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 15:36:47 -0800 (PST)
Message-ID: <7db9753d-b5f3-4f49-b741-02884805a03c@kernel.dk>
Date: Mon, 4 Mar 2024 16:36:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
 <1c21f708-ab56-4b5e-bca9-694b954906e5@kernel.dk>
 <27952c09-0a9c-4c74-a2dd-8899033c3873@gmail.com>
 <0c4e762f-8deb-4b71-bb55-308435d5f5ee@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0c4e762f-8deb-4b71-bb55-308435d5f5ee@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/4/24 3:18 PM, Pavel Begunkov wrote:
> On 3/4/24 22:07, Pavel Begunkov wrote:
>> On 3/1/24 03:45, Jens Axboe wrote:
>>> On 2/29/24 9:36 AM, Pavel Begunkov wrote:
>>>> With defer taskrun we store aux cqes into a cache array and then flush
>>>> into the CQ, and we also maintain the ordering so aux cqes are flushed
>>>> before request completions. Why do we need the cache instead of pushing
>>>> them directly? We acutally don't, so let's kill it.
>>>>
>>>> One nuance is synchronisation -- the path we touch here is only for
>>>> DEFER_TASKRUN and guaranteed to be executed in the task context, and
>>>> all cqe posting is serialised by that. We also don't need locks because
>>>> of that, see __io_cq_lock().
>>>
>>> Nicely spotted! Looks good to me.
>>
>> Apparently I'm wrong as "defer" in that function is not about
>> defer taskrun, but rather IO_URING_F_COMPLETE_DEFER. Jens, can
>> you drop it for now?

Dropped

> One way forward would be to limit the aux fast path to defer
> taskrun, I don't really care about other cases, and aux is
> mostly useful for multishots hence net, which should preferably
> be DEFER_TASKRUN.

I think that'd be fine.

> In any case the code is a bit unhandy if not smelly, can use
> some refactoring.

For sure.

-- 
Jens Axboe



