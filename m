Return-Path: <io-uring+bounces-6060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E64A1A520
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEAD37A1923
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 13:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF8C320B;
	Thu, 23 Jan 2025 13:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="y3hbSvHC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D11020F06E
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 13:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737639370; cv=none; b=QfEzoFCoZykM5nK3MaVqtPSn2RvWBERoSRaNeMQnT50+NYK+E6wrEn6GKbWKP2bpfNIBSMcxaiiThKDDAzhdetsG0tcvxMV1Slr7GbF120u1k2RwFOPn2AMnNoH8uio5JzNbugZGPWRJN2DeaKAcqhM6GyvNNOjX2G1XLuURUSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737639370; c=relaxed/simple;
	bh=28BYQLrjJltLMS0MlHHwSEcjF2zZR5eo0cWcW9lf2qg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ePgsTrr5V1mM/2PEPL0JDD1Xn030X5hR2cSsy1+oPrY6LRQ7nZSxzquoaVZEOVBEVJ5QtPqL0gMJNLf3BZX7AjeIwBybBO0ZiaW0EtRiDgIf/9yK3eYCG/+EtvccWt0efPDTx6ah2Z1+d5X1tc7MxzAg4TGVJpaOpsOinTaxwX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=y3hbSvHC; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3cfc154874eso2840345ab.3
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 05:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737639367; x=1738244167; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7CWptKkbwVcY+rTYI8ePZmAbBYE+/UMSND0QozK1acs=;
        b=y3hbSvHCrtugpgLko3rK/vxkx1hjNtrrUTCad3JJ0oFdYahdeiWHcemC8f+qeFwfy4
         t82ldHSjtWkCXJPo6AGl9Jt6T3PlFBgNWvVZsjQPq7LWZ7GY9M0cQdZuoBTZp/l/W9Tz
         QkMZiJMmXgPaPN6wRF1ZhBIrXkzZ9SrpqnbPYyBijXtMjfD/oVBeB3kx7liVimIoPEBY
         x/h6AJjLuzyviczsvHaY7KiERUYM5WWN0d7H88zxEeeSOlbeLVYc8ld6czxi8OkPqDVH
         GMtF/5dSgL1xv24agz5XKLYTr/pW0FMsPOJCqWb9yVMMruRSaviy6M66EevO8qiBTDFm
         eyow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737639367; x=1738244167;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7CWptKkbwVcY+rTYI8ePZmAbBYE+/UMSND0QozK1acs=;
        b=GFf3vWBffp+bLpStqS8bzBQBI2Xi4IsWzH5mBV3ZukD9u0Q2u1uV5J/4YyHkA8lHcQ
         Bi1sx32a2+1BWOBst1LOM2hT4qWXLKGu7UD/INOA0fqJEBlMzqCJjMK3aAb/Pa0Pbo7S
         inAGyjPAeXm1sF7Js08fO3SbbTWCf+fi9NWUo6ZavLL578NajWUtMlTrBDbYXIkVVO8h
         b7qIFEWsphUiBOg31OHIFXfIhoWBSrLAqZdW4YPZLvVIubbf/PHtHqfAh9a1oIUW9OTn
         mxLShhV5vPu6lLsB0ZVwotrvyDyUbggQ2Z8VpQPQCGfMt0AXvMox21HY0kz7ggP4GA7B
         oXlg==
X-Forwarded-Encrypted: i=1; AJvYcCV5bhSMKPZjSuXAVMiQXFsgpgHcUPB5G697nwXJIBkh1uip/2ehcePSEJSHmhGQbfsN3B/ial4/xQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8OPaSzVcBDmMKWe4zDX/4IVLveCsgBWakz7vF2AQhclR87NUM
	toEGXSxL2851T6qdq1tw1G+jaancb6ZtbANZ1EzUCW1hZNjTOxyPmwkzoa525ACjPAe814ggwrc
	z
X-Gm-Gg: ASbGncvhrtigfHpU9zj7d/D4SVXnR2K2OjgKLVQH4p5HDlcGknCB1wttb/1jiIM6Aqv
	hxfbjRf5irbd8rYuuTq2ANBgKDOKKHEdF8uV2Bw8+PVaBG6Mv3YYr7/e+Rb7voFAKnx3sB35ILl
	Sc/G6uWfJpJIyHknCw8NR6b/+GfZiJDubFn4y9UofbKWD4XSYMEO8GDIAW35vCYM1WhGzf21GOb
	5lVzT8I/+2wcrzow5nuwqjIxDMsskWC57ushqsar75iuWP3fyvWmYDOUMXbsz6hZCjSJlj/l8gv
	WQ==
X-Google-Smtp-Source: AGHT+IG/beYc/YQ6/r8JzmRX/Yc1GiwL6K3my6HmNtfGNio5TPatzN/eQ8TDPk2P4SoAB0dwc8R9gw==
X-Received: by 2002:a05:6e02:450f:b0:3cf:c5a8:3b0c with SMTP id e9e14a558f8ab-3cfc5a83c34mr2235255ab.20.1737639367435;
        Thu, 23 Jan 2025 05:36:07 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea7568067csm4870690173.129.2025.01.23.05.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 05:36:06 -0800 (PST)
Message-ID: <a366bb4b-dd8c-486e-91b5-46dad940e603@kernel.dk>
Date: Thu, 23 Jan 2025 06:36:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io-uring: futex: cache io_futex_data than kfree
To: Sidong Yang <sidong.yang@furiosa.ai>, io-uring <io-uring@vger.kernel.org>
References: <20250123105008.212752-1-sidong.yang@furiosa.ai>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250123105008.212752-1-sidong.yang@furiosa.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/25 3:50 AM, Sidong Yang wrote:
> If futex_wait_setup() fails in io_futex_wait(), Old code just releases
> io_futex_data. This patch tries to cache io_futex_data before kfree.

It's not that the patch is incorrect, but:

1) This is an error path, surely we do not care about caching in
   that case. If it's often hit, then the application would be buggy.

2) If you're going to add an io_free_ifd() helper, then at least use it
   for the normal case too that still open-codes it.

-- 
Jens Axboe


