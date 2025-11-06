Return-Path: <io-uring+bounces-10406-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E3ACC3C545
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 17:17:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AB0915003CE
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 16:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B3F34B661;
	Thu,  6 Nov 2025 16:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jttP62vr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E102434676C
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 16:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445438; cv=none; b=ilIKKhbXjFf0N5yefwE76U8d0auQ/afbCF3fQv0Qj57BF2lktEfVE3KQUgb6eNb5hI3OH4VIBb1K0hUyn1z4YYoCI87e69SEXdv+nRS4fq/QjXRi6WtQ8UQdWimGJvajG3S42Us86XAEO2X2b9bXAAEbkmM4mFE+4JWHt99DdJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445438; c=relaxed/simple;
	bh=QZSW/BJ/RJydAx+Ol7lrobWrMwqz1A1hUfVzW6JIwh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tMmNNA9qnIKdXwS4kaLZztyrxfTvk65dnNC+PEDc28TDE6b6A7seB1SfF/OIRYKY4I+Hb510QzIOplr/BKjnnJOA3OxyvBV/d0zsxA+raUb+SyRreYM70Y99gITi7clyIslcRjah0xt1ZZnsJ+gSoFvAfPsjzUkOgK3S5jtnvZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jttP62vr; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47118259fd8so9040705e9.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 08:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762445435; x=1763050235; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OpSDFcQNgt2zxWM7xhHt9aq3d7KBybR0vmck3/ABSyY=;
        b=jttP62vrzjVqv2PyHxXR9clfxua9zlH4WlRgPb6DSRhQxir0RK4S7bQNio0axhFB4v
         BPad0ywPNXIlS6L4JLBrxjBlhfRd97gyIYyMWLm2zQvHkPZNgTYhmZWyLNe6DMTL51Mn
         PD196a8Dw4A9wMSyAhYAJeKBXY+fLz5Mia3tcivdgyJVv6u1763LZ2srnGUN5KtxUBlA
         Oc6ZaXofTE+x5uWzkoHS9tanooxfHOZRbSIGYJH8kYZKN5jNG/tyOWpYwzSkBt/2xin2
         d+FWCyrlKFny/QDVY+0gmdEpmSXun5tuh+wPaA89ITpEqEwNN40Fqoi97Mbsm9SljzC9
         We7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762445435; x=1763050235;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OpSDFcQNgt2zxWM7xhHt9aq3d7KBybR0vmck3/ABSyY=;
        b=OFUIeV01WtygmuNAtZrJ2C0UNWCg22pmKmiY6W0qR7IyIEUXYpxNGIaMaq/tBh0lk2
         JjyPIKYGAgyfbhpe5YDq3LRjoYV/enmCIV3ZRJrf8rV7d2zvIFO1qDXhxqDJrJo6Y71t
         0/IRd7PaIGyGJMy7uG6nwIN5gcbw1oTgUSNDa3mW4dekMtPELb7qBqHiYJXiZDDtltK+
         06fdn3P+OtEj0SPSFmiNqrMwCNEWvNV0AEhI4/YbLVQ/t/zVzSO77VhKRDxfjvkXL6WC
         lJWkdMH9AUgYtKn/H8J4/4c9OJRn4Pr6LcBbZ5yS4Z68Fn3CI1Js6a1e2Gtikk4zIQDU
         ROnA==
X-Forwarded-Encrypted: i=1; AJvYcCVHcMStfoT5BAjjAJvcZiegkFgjRSZkzQ/t6rP5uOPBYMeWggGpcjRAtSftmdha5eaZ+o3Wtt/epg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8IL4O0/zC4+YsbCGBKbXNV1p5YOESrMxJ03bdayEZ+879Wcf7
	YY9cMW+3Dw2gwuw8QIdLJ18FXKt2gYzwboWVHQjMF48lpLkKkPa7LUR7Ok5W7Q==
X-Gm-Gg: ASbGncvHlyw0Em/b1WTj5xR8dPvO/9JNNFATUh6k9Qh7Gh0WbvO05IM/hU1/vE0psDO
	rkU8eP7cd2zphARsXXUSP4CAxF1bs+ArZvP8YuO/Q9/rtTADzMQnVLnnS7gn3/cnEMWqjBBgjyR
	0IMLLcYJCK3IauGxjNxMQblh6KGFEYmRhQeEUjatj2Qp0gbXBRXtG3QslfFE7bIla+jL6O34QD1
	YyAX437K87UZbJ3+HwI8WPYrxqYkoY35T696lKDX8TNmv0xS2ynZDgD/XggK99/psm5/hka8yaO
	VUehf6EoKV6z39Yr9Vip3CWctiC3GTidPH5itawOfFrKiZ/DjAD/L6RrFHterKyrJfDcr/LJyH4
	YZXSx5I9yZVOJlXnWJ+Va3NqRAXVgoFQoh29QCOCaNiOPtFewhRVWdU0UxKI0NQeLpThqIdb9Ka
	lHv9g0qviwLbCj11aDjtF9m5BGsv+K+fEyKfDeWQ1jGzfCia/GXjU=
X-Google-Smtp-Source: AGHT+IFgbjeBxecVoVp+6vBDH7heaujGg1di/ulHuvm9TQYuO13H0aP+SVDN1qD40wa9yHHuu4qK9w==
X-Received: by 2002:a05:600c:1d07:b0:471:803:6a26 with SMTP id 5b1f17b1804b1-4775ce265d1mr61987175e9.37.1762445434949;
        Thu, 06 Nov 2025 08:10:34 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775ce329afsm110752595e9.16.2025.11.06.08.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 08:10:34 -0800 (PST)
Message-ID: <358f1bb5-d0c2-491e-ad56-4c2f512debfa@gmail.com>
Date: Thu, 6 Nov 2025 16:10:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/7] reverse ifq refcount
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251104224458.1683606-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 22:44, David Wei wrote:
> Reverse the refcount relationship between ifq and rings i.e. ring ctxs
> and page pool memory providers hold refs on an ifq instead of the other
> way around. This makes ifqs an independently refcounted object separate
> to rings.
> 
> This is split out from a larger patchset [1] that adds ifq sharing. It
> will be needed for both ifq export and import/sharing later. Split it
> out as to make dependency management easier.
> 
> [1]: https://lore.kernel.org/io-uring/20251103234110.127790-1-dw@davidwei.uk/

FWIW, if 1-3 are merged I can take the rest to the mix with
dependencies for David's work, but it should also be fine if
all 7 go into io_uring-6.19 there shouldn't be any conflicts.

-- 
Pavel Begunkov


