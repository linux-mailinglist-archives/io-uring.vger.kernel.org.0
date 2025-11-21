Return-Path: <io-uring+bounces-10721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B29AC79FE4
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 15:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id D010137277
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 13:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39EBC34D93C;
	Fri, 21 Nov 2025 13:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBgxJisk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AC634F486
	for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 13:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732985; cv=none; b=DulxTGzA8w3Js9/lQj4q9KzOl2P5WxSGM/6jnjmTXZVT/DhbrpeZIc9aHRfVA9dJximBBzWfjMPFaeY49yXQ/KTFvWJanvcLX2bIkVN48BIXb+5SNsqtq/6TU9IIM6P3lxULSfdM7RoerGaHWo0oMqdE/LdpFlOAJknTqQO7kHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732985; c=relaxed/simple;
	bh=6sRa7VggFeA8T0uGV93BKpXvc/NYCQwYHGUdPf3ZIAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P2bPX/3U57RrP/0Xa1+yJ+syyA9XbDoNfBjR9OgLnNUbMVRrxtzGiGbqwKRah9OANDC2NeCwdoOWxMJLwW1LAjqLf4cUzmd016gqmYJoDCynIhicfFlGkqCPbwzm7wO4n9mO3h93aZklIevsRB0qUQZQIbu28dkr3ngnJZu1/wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cBgxJisk; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47775fb6cb4so14399105e9.0
        for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 05:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763732981; x=1764337781; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/uaEEYNAZfJo5DNZYfSYfwbbbOpcsvBMVWsay/jmxPE=;
        b=cBgxJiskmQOVZ5TqwJ+3IDUbqjZjq8TOl/y2jZuSa8gw4BFD2JH7f+Mh5uiZu3azIp
         7WrEjGlamt0qmxDg2eHXWyp4aUFF7EJ20sCl/gMT2JkuUBVW4SvYPPggH3e3MJ+D6OQY
         i2wvlzyazoqt5xVvMOMiZQkbjgFqxeyEXkoMUGi/uQTPBv/5lA8PS+q45DIkuz5cIK86
         5CYqxPdYqpfvPce+L/eTUAPo5ftWSOSn0xUneTqa+ih8g2WnXWSJ+TmgXSK4c8TSFQRP
         OoojzD9CuNXRcyqOyyT2UxkL958/oqIFvDF/eKZ0eygbD2yXny31ALa0Po6J7IxT3hC8
         5LTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763732981; x=1764337781;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/uaEEYNAZfJo5DNZYfSYfwbbbOpcsvBMVWsay/jmxPE=;
        b=CEVmFHLba5Uac4FC3RP/7otzEtOtscS5VX/qBZG18hWtpLRtMN3OyQXueylOqky7Ca
         7l8ra6o6mZYc+ru2yA7zg3uLumbBS3o3jq2EzIYmUZg8Ab2+c7QdrSWQKBmyJGocnlqo
         TY05O/+21UYs06QgelOGSrNKAUwDSliGEhjZxbllx62Khr2vPRhLRgVNPd+//d3xCil+
         Dqa2TKtGFBS2g9OT/SkjmlnYq4vbfbgDg5nMNBcfv9VvcJ/5sPjry3tMMeOBqMJqDAr6
         ZtkN9+wqish2D8Vc/L4wQE54pmrCxXCgL7EqYXDskKSH5esIJKw7FB57rIz8SL6B6hBw
         Btsg==
X-Forwarded-Encrypted: i=1; AJvYcCXrcTJXKlp8rxZH8fhh/pxd0SBha05sdRy5ncAcTHzX7n9NYeOrxXlwzvEgDij9naQb/FFuipsoBg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxStmfANjejykn+EycRhaJx8gIk6lAiFUfpnxDK20jJSVbl/5cj
	CZ6BkZHmoWdStydfIbjn/30I7YtACOL9j4uvvCFN2ta+ZtEmM+FcHqZ/
X-Gm-Gg: ASbGncsReiNiMquR+uWnnj7bBZQN6fKW7eK2NsD1fhpGm81kyQEFJF02aSVWCa7m6qV
	j+PGhAaLqwQudyMB2ejTT7YegFAHoXBUPvSLBZdixQwss2zw37lY8t41WTmyOZkVaSlWpCKnIug
	UG+dDwasClD3YPAKKRDPN4Tz2A1RFsaUeLOvAX0yWx5aAgrXWCKZjj6AAOsDT3OD/MeDHdxFzVu
	Q/g8QVjnIwqasci0amBymli2f5bFoU3feIF6IU1FVyXEUbr5Rc8OxG0hD4pIP3dJgkY8Fl+q4L3
	DJSR+QZdQjdfGi53gc65PM0otKITefdbYv4EmLLa3C2Kl14BxPhDX1kKdw5gB/RIHT0tEqAkR4n
	FX6TjqEh2dM3oHPoyJEIzk9Lh033lrx4Hd3t0UqRNBL+FDyuid1MIoUaNczhV42FkeD6Mzdb1nD
	s9gyn0Mqg/ovYF3SRRQak5uvjs96bk0IWgA/TMRxGnYDw=
X-Google-Smtp-Source: AGHT+IGpyXzn+GOP3c8ZJGjzVqIxPZ8wx7gMLxfBhsZssKivAUDi6/RPsu1LpaULN8JflTkLbCQPYg==
X-Received: by 2002:a05:600c:529a:b0:477:8a2a:123e with SMTP id 5b1f17b1804b1-477c1133932mr21944935e9.33.1763732981360;
        Fri, 21 Nov 2025 05:49:41 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:813d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fd8d97sm10715143f8f.42.2025.11.21.05.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 05:49:40 -0800 (PST)
Message-ID: <fa3ab544-e9fd-4746-993c-a4d446a4c19a@gmail.com>
Date: Fri, 21 Nov 2025 13:49:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/register: use correct location for
 io_rings_layout
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <64459921-de76-4e5c-8f2b-52e63461d3d4@kernel.dk>
 <7febd726-8744-4d3a-a282-86215d34892f@gmail.com>
 <335af53b-034e-4403-b5e9-5dab46064a1e@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <335af53b-034e-4403-b5e9-5dab46064a1e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/25 20:22, Jens Axboe wrote:
> On 11/19/25 10:18 AM, Pavel Begunkov wrote:
>> On 11/19/25 02:36, Jens Axboe wrote:
>>> A previous consolidated the ring size etc calculations into
>>> io_prepare_config(), but missed updating io_register_resize_rings()
>>> correctly to use the calculated values. As a result, it ended up using
>>> on-stack uninitialized values, and hence either failed validating the
>>> size correctly, or just failed resizing because the sizes were random.
>>>
>>> This caused failures in the liburing regression tests:
>>
>> That made me wonder how it could possibly pass tests for me. I even
>> made sure it was reaching the final return. Turns out the layout was
>> 0 initialised, region creation fails with -EINVAL, and then the
>> resizing test just silently skips sub-cases. It'd be great to have
>> a "not supported, skip" message.
> 
> Looks like the test runs into -EINVAL, then tries the DEFER case,
> and then doesn't check for SKIP for that. And then it returns
> success. I've added a commit for that now, so it'll return 77/SKIP
> if it does skip.
> 
> I try to avoid having tests be verbose, unless they fail. Otherwise
> it's easy to lose information you actually want in the noise. But
> it certainly should return T_EXIT_SKIP, when it skips!

Printing when tests are skipped was pretty useful because I
expect a latest kernel (+configured for testing setup) to be
to run all tests, and I'd find "test skipped" suspicious by
default. Certainly a test infra problem, but at least it
worked.

At some point it might be great to distinguish when it skips
because of unsupported io_uring features from when some
resources are not available.

On the topic, I've found this in the runner:

elif [ "${#SKIPPED[*]}" -ne 0 ] && [ -n "$TEST_GNU_EXITCODE" ]; then
	exit 77
else
	echo "All tests passed"
	exit 0
fi

But not sure who would even define TEST_GNU_EXITCODE. It should
be more helpful to always print skipped tests:

else
	echo "Tests: skipped $SKIPPED"
	echo "All tests passed"
	exit 0
fi

-- 
Pavel Begunkov


