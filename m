Return-Path: <io-uring+bounces-8064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A12ABF7CB
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 16:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66D677B05F7
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 14:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB5091A3148;
	Wed, 21 May 2025 14:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zKEJ9tPZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACEF189513
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747837470; cv=none; b=VhFQo2ynVSUQFkfKabvukV/2GsAYSiznbuxK9lydaXiNVNnIPVmmaFJy7CZtVODxumLu4lNkFlcrnRQ1g6LGGFV9UNq/Jzr6s2614JNiu4pm56Ke0mwxb5iWYf4+866DCy/7hxFaTPG7PZMFafp4kh3TtdANvkJCJuCSdYVKMU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747837470; c=relaxed/simple;
	bh=ilGFx3KxCj6PFqDmDvwxdX7lg7vgpddjSgkpln/KMYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=boo61zSdXTJrokU57Js3vj+cxjXkvIWsXSXMA7iCJXRZC/NN8VGgYOhmOgrSuro5OeLdsqdI35BfzorQTWaWJbVlGn24cjfD9qWkmY/nLACIMh/mHWmWdPKpkrHOd4ii+Yl2Jjyturd7HoQtctRfLTk2sKKv+F1Tp7Zl66eQvi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zKEJ9tPZ; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d812103686so20963475ab.0
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 07:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747837467; x=1748442267; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MF6Zx4HTEuY0nyB3HKl0XktqO68/jjMYEu3ktmIux80=;
        b=zKEJ9tPZXgP1fbEaJv0ISwRiZG/9KY+T3bSI1kazmzAbhriD6alE3QB9lEmySSCG6U
         uKsqNhMRUIOk8DiIKBFrQ64ngUF+Q/EYEzAoMiT2lvwkd11giw6B7I9QYM1jDf8ytMXD
         +U/ean9xEA8mJs+9+kznbrMM7GP7IWhICLKK1lp6ioLll3FeurZ9ahW6Y892ma8F4e73
         MRh2DDCaEVJdAb5f4Dw1n9ZMXw9wsRidnJzSdJ8Nc5K/JC742vjYiH4HBtkJBTJTRV9i
         Jm6tCkWa3q9VaiLD2C52ZW6fskvRr4zNzzEP48eZHkbYfjx1LBZ8K/of22BnGk2hORnq
         r7Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747837467; x=1748442267;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MF6Zx4HTEuY0nyB3HKl0XktqO68/jjMYEu3ktmIux80=;
        b=sIa+dS/X1FZhyT+VBlM41hEx+AGOyQDO0G83MJSQlx88wOyDMMYOcln1asSJLhO5Lv
         mdA96loHCWTBu0Tir6bQQuNgOLLIswRj+RTzZaEw44veg5QFCcK9MvskG0V8P9zjkIhN
         AhIrdWkZXVp7Ab8m1Njmr78yMJgkt6KbJP0J8JATRlrZotkzJyhzkk7OUpF6KqZxjK2n
         NxADMs8dt3bfcAX2y1Lp/IcGcIaAMnGbOYelnTTzG7V8T7hCPWKVzNNhE1hpfe57hi/J
         xBW3ttI5RenMIdogCvQ71tqyURYhMwhupMbqiUTTE0JRPAnsz5krXxIKTrWylAd3JazC
         aAqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtSCV8egKCyKmzNct24cbMnS+ltvXHLXGArqew0cxDi+AA/Siu+H0iMIztz0mpm1EUxuEyiT5rLg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoAt2D3LO+91LxlBMnuzcdP7COUz4eKbnFW55X1ypCKd/2D1kD
	MHCH8UR6RyB9e4wwEPJnmTP4npfg3Eqi1aOXpKyEhaZFasf5EfAZHDZzons3xxklAeA=
X-Gm-Gg: ASbGncuW7+v7ktWFRA5gal6EAp53HjkTUlHt8jBquRuN/bEKUMbOQwsgZ7O78qxVg7K
	QvJGa4Y8lLGHhXvMhJDFDYX9+HnjQKZSIic5PjqlfS8NsZLE3JjG6n6KNgbWcJpOI8eFI2jmJDI
	wqpk3GqAXP5FiXlbMTopCmdUgBSzQyBw5AyA4fRU7CoCCKTtsQSw3TPdZSO9fW0kaa2TheD7Uf8
	dr2TEOiUSsenA33vgaaAWBnYyOAOXQfygPqTAHpU4vVDQ/g1F4OqJwbAvKle4KqlAHZ6Uyfo/+c
	ssnIecWU/4AJbPVdaoofZ532HVs/mmCRjFPtzrMiu8CZ8sY=
X-Google-Smtp-Source: AGHT+IEq34qPPZzixdVG5S5gRXE+LK2g0btzJJgafQPkzK9N7z4L4D/6MERBC7dc/kuypXFP9JxjNg==
X-Received: by 2002:a05:6e02:b43:b0:3dc:7c44:cfae with SMTP id e9e14a558f8ab-3dc7c44d941mr56008185ab.3.1747837466731;
        Wed, 21 May 2025 07:24:26 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc84ceeca7sm3149895ab.57.2025.05.21.07.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 07:24:26 -0700 (PDT)
Message-ID: <5baf3782-f9f5-4da0-961b-ebff7579ff2c@kernel.dk>
Date: Wed, 21 May 2025 08:24:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test for vectored
 fixed-buffers
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Anuj Gupta
 <anuj20.g@samsung.com>, io-uring@vger.kernel.org, joshi.k@samsung.com
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>
 <20250521081949.10497-1-anuj20.g@samsung.com>
 <7e846c8a-3506-4581-bbc5-fdf9e084a5bf@gmail.com>
 <CACzX3Av3G1K0aoZXDOHjfT=Su6G9D-_RyKWjdMwsNpba8T7CFA@mail.gmail.com>
 <5b728d70-d698-4997-a5a3-5e90ae93daf8@kernel.dk>
 <CACzX3AsdtuTuxXU+GUdh_GWPJUhuEM4uiTSHJFtHMqMogvxOtg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACzX3AsdtuTuxXU+GUdh_GWPJUhuEM4uiTSHJFtHMqMogvxOtg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/21/25 8:20 AM, Anuj gupta wrote:
>>> Regarding the vectored I/O being limited to 1 iovec ? yeah, I kept it
>>> simple initially because the plumbing was easier that way. It?s the same
>>> in test/read-write.c, where vectored calls also use just one iovec. But
>>> I agree, for better coverage, it makes sense to test with multiple
>>> iovecs. I?ll prepare and post a follow-up patch that adds that.
>>
>> We really should ensure it exercises at least the three common types
>> for iovec imports:
>>
>> 1) Single segment
>> 2) Multi segment, but below dynamic alloc range
>> 3) Multi segment, above (or equal) to dynamic alloc range
>>
>> These days 2+3 are the same thing, so makes it a bit easier, as we
>> just embed a single vec.
>>
>> Bonus points if you want to send followup patches for both the
>> passthrough and read-write case using eg 4 segments or something
>> like that.
>>
> 
> Thanks, Jens. Makes sense.
> I’ll follow up with patches to cover all those vectored I/O cases.

Great, thanks!

-- 
Jens Axboe


