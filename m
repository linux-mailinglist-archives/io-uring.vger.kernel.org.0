Return-Path: <io-uring+bounces-3837-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F26089A5104
	for <lists+io-uring@lfdr.de>; Sat, 19 Oct 2024 23:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08A3BB25076
	for <lists+io-uring@lfdr.de>; Sat, 19 Oct 2024 21:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080DE155398;
	Sat, 19 Oct 2024 21:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S7qZ9uIy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D151922DB
	for <io-uring@vger.kernel.org>; Sat, 19 Oct 2024 21:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729374990; cv=none; b=DW+7EwDdiEa+bid/QvXdMP+hmpOuUdSwZlNpWSq4aoErLYjwmiSFwLahg6OSH6PeDrmThYlM6+X1GywsrBl6NpStUqO9Aarv0CoW4q+q0gHf3J5ZS5PWn1nfcFyLNlfRAuvFMlSyzKRnq/qm/AmmKlIhZIV9YCP+SEN8uq6kyLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729374990; c=relaxed/simple;
	bh=PGH0V0Pzye7JhPmO6HuEg9V8jgqeqL7la9QMG4rAkz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iMq+Bb/seDwYcRUFZ2FS0jmRF1cETgsEsV0TOizboSW1S8gBNnLaGqbWiWJ4S8xLrQ5ix3Hb0rQmvtVdPSQ3EXu+jpNA5kEO6Evtkn4H+Yc0yy6/kvyhwVkmdQUO/FQj6gt9uSJOPplTlTxdNldoajNrf+dBEqM7tEkx+gpn4uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S7qZ9uIy; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20c805a0753so28138945ad.0
        for <io-uring@vger.kernel.org>; Sat, 19 Oct 2024 14:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729374987; x=1729979787; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=srxaenqNAv5cNSFLbHPPUNR9xPm9gHiIdJNSg+PCr54=;
        b=S7qZ9uIyq/NBAXZKgROyDJytTEMKqYMhvXJmFrd5XecBOI8vgDQ5VHRftIzPk7zuSQ
         vhiHD8FM95v0KnVaT8zKYTmsMoVTOCHtJONUVk4JcRT1UQf21uvY7U1jR1ti2xOI+VIQ
         mnoKiDVV45afyHAJrdV59R/JjM2OBW4zbzDQiXHdILB0LEA34fiwCmtQktKgzYuE2w4t
         SuOYom2F+2cWW8zoZk3bgRTPAkn1MMFg3KQTYO9jR+m091tSZWLWuwyTV6ENnwZmo8zP
         NZZV1rNL1ZPKjtWiJDpBUvnna0N+QgkuORP0wIOrHa8HBV4i489PsGQursbt+ku1ko/N
         0r+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729374987; x=1729979787;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=srxaenqNAv5cNSFLbHPPUNR9xPm9gHiIdJNSg+PCr54=;
        b=MwbeRQr2pc8K+GKxJ6HGSbMf0iERnMa1Az+DhWRluZ+gAxMLz26pQwvFoGZ1BKENDQ
         32RrxGu9Eb59lNisOETcQoBjMS3r+1Snh30tjwFpqnrBAQLzKnRbCDsYEKBgv++GmmEX
         3bulbwsQ1EWoftIQgmpSgElVyKZAAwFuqRZjgxSw52mFGgr7qQMt+APLKKtWTuRgBdhA
         lh8wXOJagGGie2tA1GsuFeULFw/4Rmi8O/UFI5ae+5FJ9XaQYTbX2p85tQ9eApK0oeKh
         3/XNcXrRMb13BnJjcLwtq8qLyurw/BwPAJAn3yvQtr7iPpr92c1sKXMW1TpI6B5IxKu1
         dWYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm1oE5ki25MgzIp01NScXhXgE5NYa2buDdM/e/O9OCExImIni4cvovShySC9mB7uNlmKyRE5Odcg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxRMF33DtqJtC+KurTiq2zoPOwVAvPLJicfhZjILMMQjdhPBAcB
	bluiyEUjma5ETfxF5AYBelbnSnpmbnX4MqGv6Ja0hhEtGMMG4yEyB7+G3110MyCUA9RsM8onPb5
	8
X-Google-Smtp-Source: AGHT+IGyi8Pz5Y3KyoZA1Zp0KGQXluSBYGEJmyuoDXIf+o+bNXPvOY+OfqkT1qlV3OG1vOPs7rfzIg==
X-Received: by 2002:a17:902:e852:b0:20c:9e9b:9614 with SMTP id d9443c01a7336-20e5a7597f6mr101973835ad.15.1729374987651;
        Sat, 19 Oct 2024 14:56:27 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0d9a29sm1711955ad.183.2024.10.19.14.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Oct 2024 14:56:27 -0700 (PDT)
Message-ID: <c463cfa3-1182-43f3-af80-dcb7dea40ca8@kernel.dk>
Date: Sat, 19 Oct 2024 15:56:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] io_uring/uring_cmd: get rid of using req->imu
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241018183948.464779-1-axboe@kernel.dk>
 <20241018183948.464779-2-axboe@kernel.dk>
 <19d5a8bd-60cd-496f-a7ba-ffde5dd2e906@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <19d5a8bd-60cd-496f-a7ba-ffde5dd2e906@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/18/24 1:34 PM, Pavel Begunkov wrote:
> On 10/18/24 19:38, Jens Axboe wrote:
>> It's pretty pointless to use io_kiocb as intermediate storage for this,
>> so split the validity check and the actual usage.
> 
> The table is uring_lock protected, if we don't resolve in advance
> we should take care of locking when importing.
> 
> Another concern is adding a gap b/w setting a rsrc node and looking
> up a buffer. That should be fine, but worth mentioning that when
> you grab a rsrc node it also prevent destruction of all objects that
> are created after this point.

Yeah the last part should be fine, the first one surely not! I also
notice that the check for too large an index now happens after
the array_index_nospec(), that's also an issue.

I'll spin a v2. We should just put it all in one place.

-- 
Jens Axboe


