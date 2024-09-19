Return-Path: <io-uring+bounces-3230-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5701A97C2DA
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 04:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 009151F22390
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 02:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F53E574;
	Thu, 19 Sep 2024 02:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B/xie8Xo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE5733D8
	for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 02:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726713415; cv=none; b=Y/Bwt1FhP+nYeYbc+xD2Mb828pR3pPhF52IdCVUbl4+YjxTUNzrLY4xxbakkFe+cpwOLYaZGIeVPyDHpUfpLog0WkBcpDGqAhsBXalYNQcDcokAc1ut1RmhazROKeSV4aYc7BZzEYElJrMbSgFA2RiNniD82H9omL0V9x7eET4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726713415; c=relaxed/simple;
	bh=cqGiXKOCRCzwQLtvac7uxugKp2j4gBfFNJd4P9+DraA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iWTIvqChyCnj+8IKtQHDFhOrvnIOeKsMDoiH3obl4OmjXpQ7Uq6JJGdaGQdNJ7UHlmnJwsMJVjRvI4RFTj00Lgr2BuW2bEEg8dTnI/A7PlyKwovStk10VYbNuwDZ5+KFvdUfrwGL5KyLrz+LQHR29+Y2iVqKH3zVZTUtB/7JezU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B/xie8Xo; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-374c5bab490so949808f8f.1
        for <io-uring@vger.kernel.org>; Wed, 18 Sep 2024 19:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726713409; x=1727318209; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yG+/jC0vCpn1jWuPycDfRyMz8XeMZGK/QmGf6EDM3pc=;
        b=B/xie8XoXLoDAXHs1YMPvMMj8oFNBEfpj/dyrkFMFjI2+RHXyodJu2BBX4qrlw9shb
         ibxr3TqTyU2yK/9xFAmtDqlcjs9uoGTgCFihSAHTarlBixUd8K8sBlOsWXVf8DcoHj/f
         eTn2tm2CJf47NHDh52CeI3sHzMSXm9oBpl0UpsEY35uTaqMH4cqAkq/a34E/B5oFyD3B
         J8d+a4Mbi/syNC9qM3NF2PthvAIzOpfhlh63XSUnwoRC57LPw3zTek7/s7OLgEr3melN
         DTQVQFcICQO+v6a5RLoEGDKHF4dg++hCNwwYkTUGnVi0faLGKGHSVTCALY1jQNkuFevy
         ynpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726713409; x=1727318209;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yG+/jC0vCpn1jWuPycDfRyMz8XeMZGK/QmGf6EDM3pc=;
        b=DCJ4OKSixN/lQQfJfk5DG3ULPm6ZscpHLGM9iyCHc7lCYsSHbNJPOd4ge+X7a6qTgE
         ml6D1Ukzx7DOYSIHmhEYnlNPXTX2Lm50Kb9TIks+IoT+aib8eI47+FoBjnVBhWv75Unm
         e2GRNqql9se9kKpQUVCD2rB25YKtnYsX+9G7Wn2fcOwOOUncwus/ss4lDVu0rW2Zl4Fg
         CT27yv60IfCbAM+j5WE0Oulj+ZAMbC7pxtcnsxsOQoU3I7pjyyim14B5dMko9NjpfpJu
         TtU+9V2OVIZWgZRPrbFXnvgWdqHwME9AB5UIKwbQ9f2HvrAkLxn8K5cKUCI5EMIx4G48
         CDHg==
X-Forwarded-Encrypted: i=1; AJvYcCVYN+m26ikqAYIRq8Z0AeADLqo4LYpOCboK6Ckt6em8Ac2VntbcMZv1//KLj9c/M0gQ08VDW5S4TA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsRYsSXzKyMHqqzNtTsae0iONuMd4n/FNahhQJv06mBtvuoZV3
	OYZtLfsU97gzs6fQ9Eb7QmbIyDJWmUCpvew3Ujk+zj4uVBM14Qx4IN6O31exo+EvYo7X0DRynzc
	U8R4+hQ==
X-Google-Smtp-Source: AGHT+IFxCD/w/khqyUy63ttxhbg8MTF/oNbEWUpbb/dCzoiKzOf97E28/LWghuFIBfUquq1a6gDhlQ==
X-Received: by 2002:a05:6000:18ae:b0:374:d006:ffae with SMTP id ffacd0b85a97d-379a85f3d4amr982082f8f.6.1726713408807;
        Wed, 18 Sep 2024 19:36:48 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e72e4b52sm13819772f8f.19.2024.09.18.19.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 19:36:46 -0700 (PDT)
Message-ID: <ea764e4c-0255-480f-949f-c67e7fe79e29@kernel.dk>
Date: Wed, 18 Sep 2024 20:36:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] napi tracking strategy
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1726589775.git.olivier@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1726589775.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/18/24 6:59 AM, Olivier Langlois wrote:
> the actual napi tracking strategy is inducing a non-negligeable overhead.
> Everytime a multishot poll is triggered or any poll armed, if the napi is
> enabled on the ring a lookup is performed to either add a new napi id into
> the napi_list or its timeout value is updated.
> 
> For many scenarios, this is overkill as the napi id list will be pretty
> much static most of the time. To address this common scenario, a new
> abstraction has been created following the common Linux kernel idiom of
> creating an abstract interface with a struct filled with function pointers.

This paragraph seems to be a remnant of the v1 implementation?

-- 
Jens Axboe

