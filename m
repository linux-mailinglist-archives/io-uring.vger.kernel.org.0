Return-Path: <io-uring+bounces-5655-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B7BA001D5
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 00:39:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 105AA18815F1
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 23:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F691B4F04;
	Thu,  2 Jan 2025 23:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EvXRk7Wh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D650C1A724C
	for <io-uring@vger.kernel.org>; Thu,  2 Jan 2025 23:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735861183; cv=none; b=aKhELzeJ+wiPQdCZNFxJwcWsOfq1vxBk0Gk657moyQyJjX1oqIPIOAYcXNNByEicsO6iby6u2zo4RpVVPYGIm/X2pPgBkFYpDhfKNO050Yf7mtywrxy6oYCPnbm2meGbwzcra8jsnOdefCNxqaW4ZpHyuTBZHVzZxj3TzbBfPeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735861183; c=relaxed/simple;
	bh=IKUk5GMva9SI+AmZ1VeJVlDhdVhCpEm0nHZ1ymRztfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=McIH08zonC20aa1lkA2c5wyQvYX2HhB82hbt31TEvYJpLMdqYGHIosiRl9N5SjFoMQrIQlBt0IAqK99Jgm/aUFmjIq6YLH3evrIN3/zKC0pwfbt5InCgoVJKAHWxx6hRxNZaewZVmDwOlGWeloejwEHXTIEfnrX3Gz1Spy1cJ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EvXRk7Wh; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-844e7bc6d84so462802239f.0
        for <io-uring@vger.kernel.org>; Thu, 02 Jan 2025 15:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735861180; x=1736465980; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vcX+YXDytrGRF9YzJV+s20xpxIacjbMxKCE/qgl/o3g=;
        b=EvXRk7WhPB6Q9u83guN6LuBtyHq7TBNZiT6P1DX6ohNTu2Qg//tw9bvQVM+Jn81deL
         Ab6O7KDD8G/JuKCZGdnDyzYAhWRuYBAUgueLJvwg/OTI9yMU/wzOcZygl0Di/1y/1Gym
         QMQsMQRGn8Hfp3AOWkrIku5Bg4CDq1kIXl0HjnfPNx6HKnjUISWQtOvQVjXmD9EcSn1L
         kzPGNrpxdDQ8Snp8riPbbu/C0gZ2XHow2QCMpRacejckJcilLMcDOsTC93Ir6K0cldpB
         dPSglmNVNw2kZBDGAHh4CoZE+0b5f87sn8jTFyyIV3abBUrunzQZYmybghapsE6wtWNj
         u3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735861180; x=1736465980;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vcX+YXDytrGRF9YzJV+s20xpxIacjbMxKCE/qgl/o3g=;
        b=bJQHiSZTNH+QoEKr678bH+3UKgRBE04mRpv3TSrJAYs4NmGaKkKQThjHbyxCdXBQNg
         l7nlI7cHdj4e+NO55SPA1wKwADQaQ0YLxetq4Tu+Tapyo49YZnaDJ0N7OyvKRsZCQ6fb
         Jgu9bXXt70R2aRUVEcyK0NVSwR8vG/KxAB6KorY7AyPXwZrklhSXv89V0xJKigntcoGU
         iV8rUYFN+KsJQQoeNtmopP6wy8z2mfnHekh39L+FFlA7HIxNub8h42i/lkft76YGWbYg
         6y9tEHxuzl9R8rLsdvxXsIAMeWHeh08458kea5V7le82K0UIW4j29b7OS3zTmYYVffH0
         HmrA==
X-Forwarded-Encrypted: i=1; AJvYcCUNpNk1zIGXeBj5G93qoEIryJBt+RPyPidbBl5CooL9KjAjVDACt6WBQI1dAtS06hjlx3uazb7ufg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKG8IJoO+Xx/XmrvKe8FzqgSvU2KcfAPS67opMAQVT2nKxtr6s
	JYhftriUEhUMfKkHtQTmUpqj500luEo2Czai+1IYhVwF7jxdmKBuoXkWdHUZBag=
X-Gm-Gg: ASbGncuWBv/1pk/MiUvt/GTCf7kO7vwz0/KHDSxjCUMlFf2XrK5Uz+3RPMGVEY92IeZ
	2cB7zr7PXCRfib4jjcTapAOYQTIiKcEfS3kUJbp3qLXzrVdaYCtL0uCBG53qTaYURbrVy46oHeF
	ciOAufijgo9UimMOkk9gzULNBOwFS+lFRGDjNWE1bNrLawut4thdj9Pbff0TPaRc7fBMvGRNt8Y
	+ga1bMGbZnnDO/OanaSb/7+8oHM6nHVtjWHFRAeyvPcym3zgprWgg==
X-Google-Smtp-Source: AGHT+IER+k58C3qu7tqBFQSLlibj0g3VbiwvFU8tSPJqslOPrgKdOnVBljYR0diOrCaiPlo2aPafdA==
X-Received: by 2002:a05:6e02:16c5:b0:3a7:e1c3:11f5 with SMTP id e9e14a558f8ab-3c2ff00f349mr404986145ab.6.1735861179958;
        Thu, 02 Jan 2025 15:39:39 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0e47d6d6fsm76997695ab.69.2025.01.02.15.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2025 15:39:39 -0800 (PST)
Message-ID: <a6602071-9c8d-4a53-8cb2-29ec75ca73ee@kernel.dk>
Date: Thu, 2 Jan 2025 16:39:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_recv
To: syzbot <syzbot+068ff190354d2f74892f@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6776fe2c.050a0220.3a8527.0054.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6776fe2c.050a0220.3a8527.0054.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/2/25 1:59 PM, syzbot wrote:

#syz test: git://git.kernel.dk/linux io_uring-6.13

-- 
Jens Axboe


