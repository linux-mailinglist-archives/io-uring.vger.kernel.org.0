Return-Path: <io-uring+bounces-5636-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB9689FE934
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 17:58:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65436162431
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 16:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A7F1A0714;
	Mon, 30 Dec 2024 16:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Un2y/ehD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A4D18C31
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 16:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735577906; cv=none; b=Fn2t+5FDnsXQBGVa0Pv84zIF/gUEY9GaSTdfxxVVPEOcdRUiq33moSVQVMwM3N6kOZEqNQFMuCyM958Z0oZy/cn/80ReHKJ7gow2Qe9QlsYQF6Zs6M6Cp10bf2IvMILdexQ4CYjiVyP+AoVzS5lttt/nhRn7Qf0IH2WZ3UY/dsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735577906; c=relaxed/simple;
	bh=v2udJOwzNAwnhaREUWPAi8FEpzo47XHjwiPIZlYssNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PsdbhGJWMLoOINGsxMxsobvryqsr+ZByrNcTg1ErCbndDDeErZR6A+FYTsZEnf8RU+iM4aOAEm97G2gtTouUszOcL4NBABXcNQy34SyA6aWq4Ho7cw1ZagofOO0/t05A7LX8Fvox9lKcTTKFvIyTFR0b7o2JzoanCePpLK/IGvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Un2y/ehD; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2eec9b3a1bbso9613563a91.3
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 08:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735577900; x=1736182700; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gCzC/YsSNvXce/myk7bclAV3bpHfHq/zOWTCwY+5dWE=;
        b=Un2y/ehDSOtsv0MPnxDbHJ8kMSpv6x33x+xvSwYMk5dVW3xub1GyINCFFjKlhX1pHa
         VhbxFf8eB8GHVzD4kDtzF0LPLNE1Z9VTmaAeIpjpxKwZPOspJn86MRAlpsEj7OpswfEQ
         05IuQSQEMXajn0P4ZkLiGBsECumeQlsGuEp3OKGwhmijLI3hVpihk66nrLeYi3jhTO72
         2oFvuZnpUXHbDFFjqAN2G71KWQFLg4U1Eky9RAEJQeVF1MwyCPKpM9+5aXP86QJIRKm4
         FV1A3GahzL8dQ21x4QgcYYAR1Bryxnsgf8A8eYpkYAUsCs8JTbyH9Y8qaEsNwF4apT67
         q9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735577900; x=1736182700;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gCzC/YsSNvXce/myk7bclAV3bpHfHq/zOWTCwY+5dWE=;
        b=dYHVO5zjTwxU5kAVCCO0rj5pHPnWrhn0u8Port+TWsEzfB5+WIxLaAwuvO5yfLWW8l
         xCFN6gitoh33KLHm0FcsbRv4CPkxKmaiyMqWoGXyFVxkfaXr1A5HqZZdYlN/+EJmHbd+
         nSCGljuwmSW8jIifzI5smytuJ8u3ZIfRWLwIiXC7urXqXQJOqJCvM3UwtoY7I0oFRhTr
         3A0j3399B3ivv9yGnU5YpTGmptWCmDUlyDLimeQI1+24bn7j7PhfIxIKDWR+ixnzuTUR
         nvCU91MQWNHIYKw8EH5qNaZzUXtTSRt3lnFo4uEMFKA4lrnWe083gfgZyImuCvPoevYZ
         btuw==
X-Gm-Message-State: AOJu0Yy5noTwln6e8busfyCi2z+kN1SJrXWdGGuo9zykHtRh0eUiIayQ
	z7S4pYjMP/91zSS2B9WCoXfnee5zky+1YPNUSnNAYfBJ7+djxBAXzqIXtOSPkTfyfmspSrRZKat
	3
X-Gm-Gg: ASbGncvEy8YE5T0LxEi5Jk6d1w7f+UvSCjsfnljbwiOgtbSfPb/lcN38AgP3+Nlqx84
	kPJmOgno9iKtIkf3GDEVPZFlyRL18DPK+vjWPzmkMST6OoQQBOGysDEWXy62mKwNf5MVrnk/Nwc
	DQjR5E1VlXajue6Gf0HGso57fOXnRi3FoKCG3H+bolY2tjcR06RKPKE0n+mluoNsFM+XHwPMQJ2
	LIBS857CR3cFRU0o1A30MuAZ6d9FnepXrxi33qE9olkkkfMJpvdoA==
X-Google-Smtp-Source: AGHT+IGeyN+7ZHdjUH6AD9wrWpSZhN7BRgz0FxhH59G0Jy7Q8lrR5o9UCqe9UG3xBRZFMvOsI7c05A==
X-Received: by 2002:a17:90b:4c0a:b0:2ee:f22a:61dd with SMTP id 98e67ed59e1d1-2f452ee08e5mr50314104a91.32.1735577900466;
        Mon, 30 Dec 2024 08:58:20 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f4633df7c0sm17109125a91.18.2024.12.30.08.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 08:58:19 -0800 (PST)
Message-ID: <394c611c-4089-4137-b690-939bf544e6a8@kernel.dk>
Date: Mon, 30 Dec 2024 09:58:18 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: always clear ->bytes_done on io_async_rw
 setup
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring <io-uring@vger.kernel.org>
References: <1e3d150c-8d0c-42b9-b479-0aa55f0ab86f@kernel.dk>
 <87wmfh6tlz.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <87wmfh6tlz.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/30/24 9:08 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> A previous commit mistakenly moved the clearing of the in-progress byte
>> count into the section that's dependent on having a cached iovec or not,
>> but it should be cleared for any IO. If not, then extra bytes may be
>> added at IO completion time, causing potentially weird behavior like
>> over-reporting the amount of IO done.
> 
> Hi Jens,
> 
> Sorry for the delay.  I went completely offline during the christmas
> week.

No worries, sounds like a good plan!

> Did this solve the sysbot report?  I'm failing to understand how it can
> happen.  This could only be hit if the allocation returned a cached
> object that doesn't have a free_iov, since any newly kmalloc'ed object
> will have this field cleaned inside the io_rw_async_data_init callback.
> But I don't understand where we can cache the rw object without having a
> valid free_iov - it didn't seem possible to me before or now.

Not sure I follow - you may never have a valid free_iov, it completely
depends on whether or not the existing rw user needed to allocate an iov
or not. Hence it's indeed possible that there's a free_iov and the user
doesn't need or use it, or the opposite of there not being one and the
user then allocating one that persists.

In any case, it's of course orthogonal to the issue here, which is that
->bytes_done must _always_ be initialized, it has no dependency on a
free_iovec or not. Whenever someone gets an 'rw', it should be pristine
in that sense.

-- 
Jens Axboe

