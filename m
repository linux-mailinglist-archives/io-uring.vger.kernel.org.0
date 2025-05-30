Return-Path: <io-uring+bounces-8159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E64EAC91AE
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 16:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EB0D3A3A37
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14425165F13;
	Fri, 30 May 2025 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hm4MuZGk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED25022B8A8
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748615806; cv=none; b=HnxBzzM1DOF66jTwOGWwcaVJGNdPta6wQle26JApQ5mj0grFNSzZOfSELHmLDh10+X6Ovtr4Od17uodbUMQi+GK51nFuOLH9KF+f5TCEDASIBiOQwLbQYUKxQBZjooKzzQWJfuot5vpzrRAx+LrxjZarbswJdDF21HLgT7HB8dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748615806; c=relaxed/simple;
	bh=t0uv+Nr25ucs0xsdLedV/CQ5k/srXPwksOu7dBx6ynA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tU01+9XFPNl9EFOHXq+Zx0ibgdiLtU4oZyVsU+FyIljWYzCdsrnNbKDNRjMT6JZH+6sCYRfCjKFHyFNEpWwg7eYfZncOcHdNE9QyBVEn1Q0gbfkrRmIPZ/oieop4hYHn8azCr//zcyrYo9trm1u9LtnXZXbT1R8vnD3Ssrw7lxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hm4MuZGk; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-86a464849faso152105639f.2
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 07:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748615802; x=1749220602; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vzhrZVTJkuvfKI4+vV73uYTCVt3PY2kX/jPIAGmXgvo=;
        b=hm4MuZGkL36qw0EckWYsSMVz12x6d++Osai7HkggcxPvd+TusuobTtCqZei9amwr1I
         MFx8fZ03ciHuMJih8xNVO9+25dFcgofZ8U8ZIlkx+SG8ue0i7Qxx5hEtdK33JJCjuKdh
         x4W88zB4sQPHI1R+9P2xBaGGkxrzrMFZhP99tcYlnH36NUx4Nh7eiSaEARPDNxEPvOgB
         mCemDLKvFP9SFwF1Yfm/7DX8Ep/mDJHn2ua6yTItc6AA5Emo7fL8xlD0oOOHh1ITkyUu
         ckfmO3El2YejXwscNYQ49+adgzByuS6ZlejFaebl0zJXMkc/nebBBnSreD9IENJ0zI6b
         egsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748615802; x=1749220602;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vzhrZVTJkuvfKI4+vV73uYTCVt3PY2kX/jPIAGmXgvo=;
        b=p/YKeAdUE61YXKdDgizpSn9nGmvHKpUfbgu4Lk/oF4DY1Z5Lp0nqsyuEqwOHmcIV4f
         B0Cp/gxEqaIxvoFLH5Mg1ZRKLDs3s078iAD/TAINomuuv4X0Op0BN9X5o1rICxBqrMiD
         SqO4pVTQh/7T2oHvnESd3jBongsB/fiND/7IxSVxfscanr+UBpvYqv0Kqy9lRAOdoL0z
         OlMuLG46Zb+oM903nI8EqIxXBmBtSw+Vw8lbWAvVDF8W/XIEwQevnTWxfkQtGvHPmE5L
         ByoDvz8Ife4suCRtbpS9QNQXmGcz0QAH1Q/vOet6HyJ9Vky+DiKFjOdtjzoueJGFIUsN
         zyzw==
X-Forwarded-Encrypted: i=1; AJvYcCUNNzva/ur5QCQGCC4M+KWs9gFcfBqF8hWiRBRMhFaS89uS0aM28+kIHEaK5/mDV9Gcy5wGHRc3sg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvnYQNlek6zBayzCCD4uuqxI9HKQUuw5saYXcNQ4GautY3ovTK
	ojFiSCzvAJv4noxr5tmcDS/ggGKMt0kDlpifWoZlKQ+lzBe6ZKbrhg3SbsLlNSQ6BW4=
X-Gm-Gg: ASbGncv7yXfdvk8tgpRSOPCfGyQJS+B3SqLMD1PEjEvJBQq1p/DInXNwRBKfaLegiy2
	OXv+NZDTL0tbpqWy1J0eOp5BynRfgTixNGN2sm96/8VdIrW5jLp4C87FpZk26iaw+Cbfe1n9Z6U
	Lpi7ZVjVBgDEPtfZH6uJKLck4mR3PPdJnx4CnERNmGnANV9hUearTjJSdM5QoiN2YX7EUfeSoWo
	AvIdeM+jgjd0e49181At3hiR2U3SdwTCKuwq8TrCX78X+ncr29jMNQCxbwF0EDtmkbZUkKNAu+I
	tKcUEgV8jPki/AmODbwRJHZMN5B0xVHrLIO8GQgwb5Qm0zQ3paJqEchinQ==
X-Google-Smtp-Source: AGHT+IFD9mO22FIxE1tXltAc4c9g6zgcZ1Dbxj6aDIxnPpIqr7Jy7aSTd6GaliP1DB650T/2VP8fPg==
X-Received: by 2002:a05:6602:2769:b0:85c:96a5:dc2c with SMTP id ca18e2360f4ac-86d05247c82mr215383539f.14.1748615801884;
        Fri, 30 May 2025 07:36:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7e28257sm476678173.42.2025.05.30.07.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 07:36:41 -0700 (PDT)
Message-ID: <44e621ff-f7c4-4cb9-8800-799391fbbcba@kernel.dk>
Date: Fri, 30 May 2025 08:36:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
 <cf2e4b4b-c229-408d-ac86-ab259a87e90e@kernel.dk>
 <29438fa9-8228-462a-869d-9e2b82096790@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <29438fa9-8228-462a-869d-9e2b82096790@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/30/25 7:57 AM, Pavel Begunkov wrote:
> On 5/30/25 14:28, Jens Axboe wrote:
>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>> diff --git a/init/Kconfig b/init/Kconfig
>>> index 63f5974b9fa6..9e8a5b810804 100644
>>> --- a/init/Kconfig
>>> +++ b/init/Kconfig
>>> @@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
>>>         the io_uring subsystem, hence this should only be enabled for
>>>         specific test purposes.
>>>   +config IO_URING_MOCK_FILE
>>> +    tristate "Enable io_uring mock files (Experimental)" if EXPERT
>>> +    default n
>>> +    depends on IO_URING && KASAN
>>> +    help
>>> +      Enable mock files for io_uring subststem testing. The ABI might
>>> +      still change, so it's still experimental and should only be enabled
>>> +      for specific test purposes.
>>> +
>>> +      If unsure, say N.
>>
>> As mentioned in the other email, I don't think we should include KASAN
>> here.
>>
>>> +struct io_uring_mock_create {
>>> +    __u32        out_fd;
>>> +    __u32        flags;
>>> +    __u64        __resv[15];
>>> +};
>>
>> Do we want to have a type here for this? Eg regular file, pipe, socket,
>> etc?
> 
> That can be added when/if they're mocked. This set tries to atomize
> file rw execution characteristics, pipes should be just a particular
> set of those (e.g. +option stream vs offset based file). There might
> be some interest to test some interactions like with page cache, but
> that's beyond the scope, at least for now.

That's fine, guess it's easy to add a type when everything is checked
for zeroes upfront.

-- 
Jens Axboe


