Return-Path: <io-uring+bounces-1489-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8E789E83F
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 04:39:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EBA01C2417C
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 02:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B2E8472;
	Wed, 10 Apr 2024 02:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1u3bKuhL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99163443D
	for <io-uring@vger.kernel.org>; Wed, 10 Apr 2024 02:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712716757; cv=none; b=ATaPuz8FrDUezO41kQ8V72Lkcj2cIg7kVJh/YR3vHsbyZApBNFVhyX62PBTUPJn600P24zJL4KfBhcu2BhdqIX81kyPSdbi59nN07pefR4LCrhhWMSqFAR78YRjykAHkAediT2u8FeaDU3Dz0yPF0uuo6+TMJO2AUfQaOLTL4vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712716757; c=relaxed/simple;
	bh=KWlSQwNSdOxwNYIfM/NQiOv3GHTg6tX6HUeMJPYmIUM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eTxf3MgnI2cHNYg6Vfg2DgaGP9/eA2PtXEnyRuN+56xbeeVMYEFkI4UYU5EitZXZInnBKed5/nsxMS2gW+Cxiij49v07CcUMaQJfM0CZRfJ1CSmxcZ7U2sftGIhsbTcsv995oX9a09xZIWLUTvPRyZmlqtZwaNJzZP/o7rZHLa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1u3bKuhL; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2a52b2ed8c9so607165a91.1
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 19:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712716755; x=1713321555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZHDE50l+SVQVqIRljTiZhStbipxRaFrsZXrg+fbim4=;
        b=1u3bKuhLkJ4wT8d62kN4aJMojaI4+pjoczxgFTU2bvf4o85nxp/Jxft7EeY7Y1tZkT
         ++3rlbYNrMSXBg3yO+HQ9GStaobPxJ/LN6Q78Gi0/1qIe6CP5W5yabCxZcqRkCeVXgJY
         gmjfxaj+XGFTx0n1mE5OfKi5gpN4g8DAuk4h8/OACF6Vb6K7eq6XKeNXTw9BQTNbJ+si
         KQtP5sQyjbzx56vdXCCZPKuViasqsPnuclPaahBc5mwOyM0Oa3F4ai96PKbl+zYBgOFF
         HfX1xr7DoA5RYOGXNfk2vuFB7VN1qDM7ty11FyqoOTfrBUMxSTkBOVjIWsNEvsOpsCOv
         uApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712716755; x=1713321555;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZHDE50l+SVQVqIRljTiZhStbipxRaFrsZXrg+fbim4=;
        b=dU1Q8MwCQ7qZzHotVB/2NoglF4ZT1Y+t/9wAog98oo4sYsXejuf5dOA62r0K1Wj2Yz
         YZPAJz3ZjpIF8lYchliMK4Fn0A2itpxPamDPF+5yM98xAe8Mc2IJw5CuhdMlcrL8cEYm
         wGhK+2IhxxWJR+z3zZivYc2lof2grIVv6IX/kwXW1hYUEbKToPrr9XbIz586wRfU9ARE
         AAmeki+0aizgNeIUVwDwvfxR4+9oH0ZvwVcuKiizzInhzIVyiMas35jls2MppKg4lW6I
         CDrF4iQIUzo9+7IttBcicLI1MnmgZSYUTcOCpYhlnIx108z2Zbdv4Gf/Y6bQNCL4R4NX
         h53Q==
X-Gm-Message-State: AOJu0Yy6WELSGG88sraUH2Ytstk9cYUtv9IDHZkGUr9T/sISV9UHrA1r
	kN0Dd2d7p+KC3S6qsF1NwgvmKhZSuabWg9GFOSMbC1zhwgsEHEpm4SJWExfhkQI=
X-Google-Smtp-Source: AGHT+IFSVYSiRT2UByqfHLBKx85LPqv7jmOysrQhLSLPe9IJ3LzD7yayCeqiemgB2oHdVeA+1NRD0A==
X-Received: by 2002:a17:902:d510:b0:1e2:c544:9bb0 with SMTP id b16-20020a170902d51000b001e2c5449bb0mr1661253plg.0.1712716754709;
        Tue, 09 Apr 2024 19:39:14 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902f28c00b001dcc2951c02sm9658372plc.286.2024.04.09.19.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 19:39:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240409210554.1878789-1-dw@davidwei.uk>
References: <20240409210554.1878789-1-dw@davidwei.uk>
Subject: Re: [PATCH for-next] io_uring: separate header for exported net
 bits
Message-Id: <171271675383.91809.1941555904322690627.b4-ty@kernel.dk>
Date: Tue, 09 Apr 2024 20:39:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Tue, 09 Apr 2024 14:05:53 -0700, David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> We're exporting some io_uring bits to networking, e.g. for implementing
> a net callback for io_uring cmds, but we don't want to expose more than
> needed. Add a separate header for networking.
> 
> (cherry picked from commit 9218ba39c2bf0e7bb44e88968801cdc4e6e9fb3e)
> 
> [...]

Applied, thanks!

[1/1] io_uring: separate header for exported net bits
      commit: fb34c62057a7d040dedb3169f5fab9b9d341a561

Best regards,
-- 
Jens Axboe




