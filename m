Return-Path: <io-uring+bounces-7325-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F397BA76D49
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 21:07:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03DF018851C4
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 19:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9F2218AD1;
	Mon, 31 Mar 2025 19:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zDly0QeN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6943F7080D
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 19:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743448057; cv=none; b=heitnI0ThMJMaQAxHqlF4B4OExwgD/Xw7zGWQ+leUM00CaZZldQ9k6tapdG83VZWc/aFJ4cSaltUSFjDDOcrAJ1N6zuZ2SChpvkM4QGSNODrhl8uCseEUVkOya4UsWhABZhvaXuPMs1tWSCyO5TOmWTJq9Pq+hfa7hpMxDPurCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743448057; c=relaxed/simple;
	bh=EmztB+sFuSyodnqBb/kC60Sa1nznCQF0QM9aM9uBG4E=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=tQZROpxDm8py2EbJLmVqeUjudOIfmWw1dhxfHVICCPwuLYFiVXMcGYwsMoWHAbbX8PvBD18X460GIpp5hRM3xEbYOjKxg5fMyrR+BEtJRnZm8LelGsba5w48bhpa/daj2pN+8NNuftIGmeujMtLGNV+K5gRrzv3O/8jaiEywkck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zDly0QeN; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3cfce97a3d9so17874035ab.2
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 12:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743448053; x=1744052853; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyRXxeUBsO6X3Zs2fbFKLJAxOiemT0SOJ/Dgnglo5ic=;
        b=zDly0QeNDw6TxvgFYSIpTLPjfseFu+NhMWuFWpiEf2mf+SM5wx7HXk1eCqX7xicrOi
         XCFq3Pe6wDVnuIxtNO1a/fp6fr8HQslDlJWoScSwLc3FUivXhyJ96Bh2GqnA0OnZpTPc
         lFZWRHK55pQvePcVYAdlUx7OPrVW6wHks55w8BVjAGTg+zTd3DVLl60F0C3Rv9XlSrvs
         S1MJY5Vehsextc4EI0ugyPluHkb6OCnLgQu/M55nzw51idj7IfWEcblyWZwcvraJ9IjM
         N9dZgbsiKlKnKS3fYks4QfKb1TmjRWxj9amfxisA37gcNp5Oz4H/GQvdB4LZXLkJsTzF
         G+LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743448053; x=1744052853;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RyRXxeUBsO6X3Zs2fbFKLJAxOiemT0SOJ/Dgnglo5ic=;
        b=Z8rdX6iedn/RiIGiCgFHUbhEq9fzZLuQGOYrVeYh2USreG9a5hrMH7ukHkuEtlmqQt
         5ywAedd3AkqvG6iLJB1gP0rPZYKiv7oQt3DCeLAWehg203UrCN9pZGd65kgPtuEAmJeg
         bnxIf0ZzBTmYov8NtFWl+n+bHw9CxesQOosMj/0tvEyzYQwLpKtcb/mek3vfblP8vEbW
         Mohjr9+79hlpxRYzWB6MweKRBrpqTD8gfgc4nPFFkwQvTTQSkDsbi6UgVqvsJ1k5shHg
         W1OD7sYsC1R58M1kGDEMa5wCJsYNQSgfKFQd1oW2YiFqPz4SqoJLNT25I89KPmf/Sfb+
         4bnA==
X-Gm-Message-State: AOJu0YzDR3xif7RVpv8q7sMmGHGX5jh36VrqQbG//bzsVWQWDyBzVWwz
	JjgRANBufbUJEqwwkj8q5yXD+p1E4u29RiYd5ZRV6FcaeD7gtr4+kEt320XCoFJjYwgdchTgEMW
	h
X-Gm-Gg: ASbGnctsGo09pZPF1w02hgAQHjb2kTYew46waKHF7cEI82CPeJZ/mf2RL3de2rAsrPr
	sN97sD0PcVrMqbj7qiQxuYrZ+WyLMVIvXwRZtWqThcdfgi7o2xX8aRE2NE6aZOjsAn4nRfCiY3q
	BIb3PzQNJbUAs/J3uj1I4/BaJ/TLa/8I7eBm/RTosQxhVi6e+e0wgxZXGHabJcF6UCxQrC7waiz
	3TDFVuqr4ZASefhmrezeVmFl+/+rkDwivkIuCjjlVVWd3Dgmy261c9VBoUcdRDE1ur8fOgiadZp
	oNHL0Iq5hFcyPYm8rFbZgip6xLPiE/hkFBeeKt8cfw==
X-Google-Smtp-Source: AGHT+IH4iWk2ChkD/U/cpqFvuYu4SqFqB/PPG5hHSFnMekcTXkSDaBS6Ipgq2rirHDOpUw3M4txHGQ==
X-Received: by 2002:a05:6e02:164b:b0:3d4:3a45:d889 with SMTP id e9e14a558f8ab-3d5e09cdb6amr87313545ab.14.1743448052757;
        Mon, 31 Mar 2025 12:07:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d5d5a6ca40sm22448845ab.20.2025.03.31.12.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Mar 2025 12:07:31 -0700 (PDT)
Message-ID: <49c7dc85-54f9-4c73-bb85-a08d0e9b7015@kernel.dk>
Date: Mon, 31 Mar 2025 13:07:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] various net improvements
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1743437358.git.asml.silence@gmail.com>
 <174344799536.1769197.1301233276570112487.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <174344799536.1769197.1301233276570112487.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/31/25 1:06 PM, Jens Axboe wrote:
> 
> On Mon, 31 Mar 2025 17:17:57 +0100, Pavel Begunkov wrote:
>> Patch 1 prevents checking registered buffers against access_ok().
>> Patches 4-5 simplify the use of req->buf_index, which now will
>> store only selected buffer bid and not bounce back and forth
>> between bgid and bid.
>>
>> Pavel Begunkov (5):
>>   io_uring/net: avoid import_ubuf for regvec send
>>   io_uring/net: don't use io_do_buffer_select at prep
>>   io_uring: set IMPORT_BUFFER in generic send setup
>>   io_uring/kbuf: pass bgid to io_buffer_select()
>>   io_uring: don't store bgid in req->buf_index
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/5] io_uring/net: avoid import_ubuf for regvec send
>       commit: 81ed18015d65f111ddbc88599c48338a5e1927d0
> [2/5] io_uring/net: don't use io_do_buffer_select at prep
>       commit: 98920400c6417e7adfb4843d5799aa1262f81471
> [3/5] io_uring: set IMPORT_BUFFER in generic send setup
>       commit: 1e90d2ed901868924b04a1bf2621878ad8cbe172
> [4/5] io_uring/kbuf: pass bgid to io_buffer_select()
>       commit: bd0bb84751f2d4b119a689e5b46c733d9c72aa75
> [5/5] io_uring: don't store bgid in req->buf_index
>       commit: 0576f51ba44c65b072b6c216d250864beea2eb9b

Since the tool doesn't distinguish - queued 1/5 for 6.15, and the
rest for 6.16.

-- 
Jens Axboe

