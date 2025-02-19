Return-Path: <io-uring+bounces-6571-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85527A3CA81
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 21:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3262E7A78A4
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 20:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F8524E4AC;
	Wed, 19 Feb 2025 20:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Mux0mXRk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC41247DE1
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 20:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739998567; cv=none; b=IoKJt9B2iOml3nGGRanwwDOf72MRNRAeFb6QTkz4xmBYZGVA97d2z+gZ4xDyES63n7zI0CHuG4IO+5OtmTcEBM81q3vl+UeC+lQnN0rYIuXDDGtbsLxIzkkqkvVtiElG23SavaHChpmAI3IiV599zok3bEfbtiFw08Ew0EH8AkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739998567; c=relaxed/simple;
	bh=KWD6OD2n1o2ros7LTUEWgm/ubHlzSResbAdfOLBw3hI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=D2f3n6hVF/2Nj/jdPszKIeus6Q/2MknSlyzSAMP/SoS/BG4R3fDSH9jew6CthOmAnqOFYpY7IEnh5B994ve9yAIk7JWP3azWKcuTMhjMW8WeNtbI3d+jt5sTSe3MJqoZblpQT6OVaUVR72sXFVmJIaPZsoH70AdK1cxkIZW6glw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Mux0mXRk; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3ce85545983so905595ab.0
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 12:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739998562; x=1740603362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dVJKL2/YFN7RKaOsWIhuPViPj91EWujZm4pXUbaXRn0=;
        b=Mux0mXRkbmZiEB6FP6pQ2hH4iNb2eyHIxW59oPqsnZMwwQiAEu1NsMMMFo+dJ/qvNH
         GY/dlzN1Og6UapgaGT7IgBxXVa8AHOxb1qeldIXNv5woakE/ZtbkrTl/vXpEUEea6DBJ
         mpb8lJ+SKl6nUvCeWLUFOi7nn46GVpmyZQPki3S7vws1+ZAPr2As0b5DC62N/OY3XBco
         kUjOF1n1hI4mo0Hgl/0SeqhOnkXgUgTZ9PTHS5S+UUWmLIpfGwimWAl8kh5ZU620PLde
         A5vd3bbwNUch7K8194v4LdmTUCmiNVj9tUM5xb3HbNXOrHht6+Ubg13qQk1nfYBbi+9w
         WwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739998562; x=1740603362;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dVJKL2/YFN7RKaOsWIhuPViPj91EWujZm4pXUbaXRn0=;
        b=bbycEeUwlk3V1pKOLLKGVihHqq2QvNyo3N+pYVHDbYus160T0yZJ/lNW4vVxpE8NvD
         N+z2ayMlp8+uHccETpDzxGQdIAXmosa7jDOUxv2nSKwViXm/nEtvBZ8dJ10yoNRvizVp
         FmvSMNYeyt2BPcLY8mhOF+XVFg6NDag9Uv1m2TpzstZgpakQ1pvWuCJTOMLJfy0HOQa9
         8TyWx9ITcZSCEGGLqgidJj1jhT5QtMzAnYUDvpgBOpd08BJpNCrZx5EeFpuwv9tBkCF6
         5hD2W4tSARKwQ/wt64V+FcmkqSgPXY+lRcCxxbHvwR0sCcOMZh3zG7CCiIPT7S/EFBDS
         x4Bg==
X-Gm-Message-State: AOJu0Yw/zzS7PYfXo7Dsj+cO9GyZa0A+w91AccXKg3SDSeEjp4pHb+XL
	mzYomyrlwaezXHyOuEfnQZAgWSEtcOwstsLD8+Xn9pHmg7bWWyCeZUbRUbkFeR0csjKTRoqlwQi
	c
X-Gm-Gg: ASbGncsfVGpeRNlystO2nZ0Th0XMVgcd2AEHMAkilC3fnrmGxACrK87914UdKG5ryhY
	d+SpJxqotZgZI94EBeQoZBR0e8hq/rCeeh0otECD80PTRCtjDtI73Z7kvS+gbeuGvCamUlKx7Mm
	Y0s9oXzZ94ck6yXSN/0yOK7F67lw/ju2UEmloHO5Gy/w31SMHwWE0u88oxkDzJxS8fEK2UkHZ8S
	nApBtl4PlOLx9SgBmHaawx28qaMIxbnvnZ0qkZgO3uAss5cmkAJw3jWkKoDAcDYRisUJARUq4qT
	W4DXvA==
X-Google-Smtp-Source: AGHT+IGlwYVNWMWQ1OUZDuSRuMuk/k+uCWS0BbFpQH2+SuOHg/PLYKlqWw9jhySo5k8jYabRJ206hw==
X-Received: by 2002:a92:6412:0:b0:3d1:5037:c97a with SMTP id e9e14a558f8ab-3d2c00bca61mr9582595ab.3.1739998562367;
        Wed, 19 Feb 2025 12:56:02 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee82c8d5b0sm2412858173.120.2025.02.19.12.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 12:56:01 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1739919038.git.asml.silence@gmail.com>
References: <cover.1739919038.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/4] forced sync mshot read + cleanups
Message-Id: <173999856140.1624493.2433795023250819728.b4-ty@kernel.dk>
Date: Wed, 19 Feb 2025 13:56:01 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Wed, 19 Feb 2025 01:33:36 +0000, Pavel Begunkov wrote:
> A respin of the patch forcing mshot reads to be executed synchornously
> with cleanups on top. Let me know if you want me to separate the set,
> as ideally patches should target different versions.
> 
> v2: clarified commit message
>     + patches 2-4
> 
> [...]

Applied, thanks!

[1/4] io_uring/rw: forbid multishot async reads
      commit: 67b0025d19f99fb9fbb8b62e6975553c183f3a16
[2/4] io_uring/rw: don't directly use ki_complete
      commit: 4e43133c6f2319d3e205ea986c507b25d9b41e64
[3/4] io_uring/rw: move ki_complete init into prep
      commit: 74f3e875268f1ce2dd01029c29560263212077df
[4/4] io_uring/rw: clean up mshot forced sync mode
      commit: 4614de748e78a295ee9b1f54ca87280b101fbdf0

Best regards,
-- 
Jens Axboe




