Return-Path: <io-uring+bounces-6445-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB3DBA364A9
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 18:35:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 940E2188F47B
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 17:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208BA86328;
	Fri, 14 Feb 2025 17:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iGfxIr57"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1318264FA7
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 17:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739554496; cv=none; b=KFRCyo8xN/iC7XS3Z62bNxiuc5lxhuOyB9i+xuWTekoC0dIdLRqLj1wJAQtvV11prz5VSrUF+inFginPuSGXu+x9eHT3JzrPH/Nq3tYJr/hTECOYKejR8H+vwuPv5H5+f5285vLygU1PsS2YfupJaCPT5iPfNlgkacx1pvZR2BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739554496; c=relaxed/simple;
	bh=TM7DHSQJLRWtlmmkySl8PM31ys8eZ093xIkinbYk2Gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S1+leYRx6Tzh4ka2czL15g916sAZrkeujMlQ6ZXdMihlvNrjuGDlU+YV/vXaNCyVb2mDpoFu+gOdqYps28CGcUFgrWXgfRAOPcvUvWcMFQzZ4XlsR0pbC6LyjeiZEdcZuEkalVMd0G0ZcYVLdilY7kOQdeSMa0Pkn0M1Y3Ffg6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iGfxIr57; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-854a68f5a9cso179069039f.0
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 09:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739554493; x=1740159293; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=npntsKsDC5GjqqYANStP1hTs06gZC9RHKxVwl9giDBM=;
        b=iGfxIr57d685qFmMcY3y/pfrgHMBDWg+49JEtyz0g5Yq6V7CUrY2BsJiTrk59M5nZv
         dAmfeAesfmTHkxj1xj9vPAIydvYtVO9LIfERPV5xTqPZgQ7rAUYskHCwH4YMWIWVR+89
         jxZHpyFoUh3w9GJDnSZK3x8OgCOdzoRCx6gZuLJFDmMynuae3u1S9ujE0A1ojsJjdpH8
         FHEvzmsdn8TbU3c4ZZSn/wiQPz2iCiy7+lhzHo2cKfwgyxaDPm6TK3/TK8qf2oGUujs4
         tOK6Qm7W2WeI9vsdoBy1uXEU28SZRiVLudTOEGov7p5wo4rMNWH7ObK4GllRcwm2f0e1
         hSnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739554493; x=1740159293;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=npntsKsDC5GjqqYANStP1hTs06gZC9RHKxVwl9giDBM=;
        b=L4WcUFf8l6owwrYbVU0Nn/db+W+sZR1eD3tW0qAcs+zl0PSsOm+C2FnnluxRCvg2jR
         cLrqY1A57JTzluCI7nSSohyfsPMHA8wb7pt31Zv2+23juNsMJltGAVEmTVWsE8hPK2L1
         sZj8hPvQPd/o6Jtzyh+9iz7zUREibCxQsV+g3PejIDIh6PtU0TXljqnpUGNRriYqFg2b
         TirU/P7nC7UKFeUVp1d/uTlaGO49nGu2Ge+sJY2ASH3Yu+0rne/C2WxtxstV5KrE7YyY
         OnUw+gXTFtg/LRgeioEwKbFYdkO/aRcDcbashm88/Q2kc5fP+7dRQJt/OE1rBtmbIt1p
         dyFA==
X-Forwarded-Encrypted: i=1; AJvYcCXJoOllYtH5iFd1ZALvO9y/S+hxGg1XyRQ/+lJ4H3T+zC10isGhkxTX7VkQkmMsc+Ht6BHSM+Ws6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwifvTIYHzK8o+aswCx0fpd8axMJgRhxhmOksgLPmlz1aIKaRf7
	WIX8VWEXkFDEJbZtfLVLGPUY34fdeQslCfrCwruMT0oWNmltp3SxPvoVTGH6L60=
X-Gm-Gg: ASbGncuMlcajLvUe5JwZL9klIcWNqE2TGHu+whwLp8obPYUT2IP4EPW0Szb4xIFzTvO
	1ioT3YXBa46MJ1W7SPWt4WB+vkkx24FIMXE4LKvrBZCrJFAD3DaKc+LLcEmAnpQL2jVSw06zg98
	SmxlgaqO0T5pfq+8CP2ijOJ19Fj6klUGtv8Nw/Kqgv0PE0lMgL+yVT1LK5zDwrlocpNNdBBw6kk
	w1My3VnpRgnAkg+09Kq62tQyqS/T2KhALPkldA79iU9sU3G30oWqzYCOjo9b9eL1lOuc7Pir3We
	lieEYNCDhLVH
X-Google-Smtp-Source: AGHT+IFkLxsLfJ0ToZHb6of7v/wFlEdjlDrOt7iWxeXCVI0Ppx8SPqj7+FKMt1eQB6TFZyywZfHkBA==
X-Received: by 2002:a05:6602:1606:b0:855:7643:5ac7 with SMTP id ca18e2360f4ac-8557a0b0b22mr52627439f.3.1739554492605;
        Fri, 14 Feb 2025 09:34:52 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed282dd03csm908171173.124.2025.02.14.09.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 09:34:52 -0800 (PST)
Message-ID: <a3daa76d-3b1e-4dfb-a47a-1af282a5c7bc@kernel.dk>
Date: Fri, 14 Feb 2025 10:34:51 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: avoid implicit conversion to ktime_t
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Jeff Moyer <jmoyer@redhat.com>, io-uring@vger.kernel.org
References: <20250214073954.3641025-1-dmantipov@yandex.ru>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250214073954.3641025-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/25 12:39 AM, Dmitry Antipov wrote:
> In 'io_get_ext_arg()', do not assume that 'min_wait_usec' of 'struct
> io_uring_getevents_arg' (which is '__u32') multiplied by NSEC_PER_USEC
> may be implicitly converted to 'ktime_t' but use the convenient
> 'us_to_ktime()' helper instead. Compile tested only.
> 
> Suggested-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
> I didn't add Fixes: as per Jeff's remark at
> https://lore.kernel.org/io-uring/x49ed01lkso.fsf@segfault.usersys.redhat.com/T/#t;
> if you think that it should be, most likely they are:
> 
> aa00f67adc2c ("io_uring: add support for fixed wait regions")
> 7ed9e09e2d13 ("io_uring: wire up min batch wake timeout")

I don't think that's needed, as it's not really fixing anything.
Using us_to_ktime() is identical to the code that's already there.

-- 
Jens Axboe


