Return-Path: <io-uring+bounces-8791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5889FB123AF
	for <lists+io-uring@lfdr.de>; Fri, 25 Jul 2025 20:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DC671CC7461
	for <lists+io-uring@lfdr.de>; Fri, 25 Jul 2025 18:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E8023F422;
	Fri, 25 Jul 2025 18:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tctxKcUN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A7E8F6E
	for <io-uring@vger.kernel.org>; Fri, 25 Jul 2025 18:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753467693; cv=none; b=Pkfw26zw96bBqTrpHn4UrEGR9aW5lN+FHaLOYcMzpurmppe+AlguxYvjkaf6VCq8x5QRZbSz2HOjC5zAEGh/wXpJ2xDvpmDJ+Cles27fl+c8fsAdmPI5nh7DeZdNuZHoZ/QPTSRr+bmeYdfrXkAE/00OSlhFEmV2cKR9fXmCCTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753467693; c=relaxed/simple;
	bh=GIr52zleFwu2eEPwKn3CzW/cCTYb+FEUP4KL2XLJQzI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HKo/ICE4MFz1KdGOUvirPMtKpgOhMkXog3bUk0h2SNgRLxKK1AzEIfikpN+PUQAZ9STcW82Bo0rxpZLHyu0zZ6LDSpLgJdDGG4KnhggzzhvkyDs9e3RbWB9lIKvEp2K20SvtJYuaJX69ohhv2z21vuGuLnwTBn3mPjKICRUQ/6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tctxKcUN; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3e2c683524fso9797055ab.0
        for <io-uring@vger.kernel.org>; Fri, 25 Jul 2025 11:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753467690; x=1754072490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXcKol1McKvTjcvK+Gvpwmco8x2EGt21oUQ32BuDOlQ=;
        b=tctxKcUN54M2hrNeVizfhoEWlfGbEvYeT3gcQTO0gyk3j/D9hHULNnBoxez4u1rFie
         ci3qYqRXOUMyMcIDFC1AoL35vJ9VSdSFptuPrX0/g2Uw7C+ORjwlsdYOmCWDvPJc05FW
         JHkp8VtRfOWpgIbQMXxb+mBZotCeGNsaoA6acO0k9zpb3NZAMkJHDJvyCTkGiTEQkIpK
         La3JIdkD4fpjK7FuIn1M6gdmMvx6Uoe3EFI2FyCnpW+tavPCSEmh5lQ8Lc9/MjwMSnsX
         FyUHq1iI1Fvq9k+G41zC1vIa7BAS+T8eoDQ+SuF7O+PHs625L1kAwx3H9cNLE0OsdrZ4
         KEbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753467690; x=1754072490;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXcKol1McKvTjcvK+Gvpwmco8x2EGt21oUQ32BuDOlQ=;
        b=mr0YtVfaTPHd1aRnZIeDAhdZG6ZJT3/QdRZVHJfj8UDKPaOOffsSdZsw1AXuHQUyAw
         dgS+2bf0JIx+9EcrQJzpbyTgH7IivVLHrcjFPMkr6XBrDgMIFYAYd9N5w7QseW3+lfyO
         YC36BiRGmswP9o1e/zp5R1t+Z2+mr7LfCR+hglwDYczIpxUTQD+YG9DAfEmvZ1Wm5TMv
         J+uBHmcGzk30HpgfOr6GsUjlIgBXBNkp79L3gB1oDLR3GRb8ZGUi0xNrCfwkIm0Tt7vn
         lohVC8ixfa5CQc8Qe8uB85Odz+cLgaaDM9X3zmnIYQvBIoGdpYn4gmvKTsoF8U5IjGth
         zqJg==
X-Forwarded-Encrypted: i=1; AJvYcCVSR1M7wX9UtqEPNCLVY76Hh58h9aHw9JbGLfjiQuVV0xTvzOMXPyLYwTOeW8G2/3p2C/mEtQkvVw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg1g9oJkMBSoTOvPR5/LnvQ9P80c0O0a0BQsPkKVC4JPf7sKg3
	aGyvFEGObkfp6dGBAwISyGtmK7VoTaytxbcDxw9q7OPD1pHLZBumQthKPlH4Kfbud0S790nyXwQ
	iVNJ8
X-Gm-Gg: ASbGncsX3ud6PMjeK+3fktFae8jvGj6Q32Uwd1anQ+mQ4ekWsCuSYkinkk/WAY2CxRS
	9PpXbyDqmAe5p3wB6ub1XW3PnR68pu3hX28kHEIWBTQvfcTfw1+bPpJG7JfU5aSg2c22ZXtBIFy
	Pm5xmsEexqJ/F0x9k/gbsSkbwRrehDEMSLFEo+rwlOHTnSivxZ4dA0kEM5qlqP9ulgNPmP7QW/x
	YSimACUXPuDzQW4x7EJRIbqJQRDNXy6YW8AOTg4wHohFED5ojhjT5/ycwUfkfBW2bTxnItRUY0I
	LtGHdKOGATGNoVRk6ilNIdBzwjvrDWv0+wPD04iU7O8DNNozskoT88HeOX93h7rUbWO6z151mjh
	AnKRkpCo0PIlB
X-Google-Smtp-Source: AGHT+IFLXYQ0jDVk1FSpHmh6JYPHrFtRg8noGavUKgAIqDPFowo9HqHWonzGQTsKS5YLFfnYaszn7g==
X-Received: by 2002:a05:6e02:2490:b0:3df:154d:aa60 with SMTP id e9e14a558f8ab-3e3c5322bdemr54633665ab.22.1753467689699;
        Fri, 25 Jul 2025 11:21:29 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-508c91c9687sm107313173.21.2025.07.25.11.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 11:21:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>, 
 Christian Mazakas <christian.mazakas@gmail.com>, 
 Michael de Lang <michael@volt-software.nl>, 
 io-uring Mailing List <io-uring@vger.kernel.org>, 
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>, 
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20250725175913.2598891-1-ammarfaizi2@gnuweeb.org>
References: <20250725175913.2598891-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing 0/2] liburing fixes
Message-Id: <175346768877.681403.14218875042208173659.b4-ty@kernel.dk>
Date: Fri, 25 Jul 2025 12:21:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Sat, 26 Jul 2025 00:59:11 +0700, Ammar Faizi wrote:
> Hopefully, not too late for 2.12. Two small final fixes here:
> 
>   - Fix build error when using address sanitizer due to missing
>     `IORING_OP_PIPE` in `sanitize.c`.
> 
>   - Don't use `IOURINGINLINE` on `__io_uring_prep_poll_mask` as it
>     is not a function that should be exported in the FFI API.
> 
> [...]

Applied, thanks!

[1/2] sanitize: Fix missing `IORING_OP_PIPE`
      commit: ed54d3b7e324220f70dac48b83df4e61763bf844
[2/2] liburing: Don't use `IOURINGINLINE` on `__io_uring_prep_poll_mask`
      commit: 6d3d27bc42733f5a407424c76aadcc84bd4b0cf0

Best regards,
-- 
Jens Axboe




