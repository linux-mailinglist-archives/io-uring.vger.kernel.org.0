Return-Path: <io-uring+bounces-2555-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC7393AA2D
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 02:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09C031F23667
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 00:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CF6256D;
	Wed, 24 Jul 2024 00:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="D4FWg70o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3857223A9
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 00:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721780564; cv=none; b=Vr9vie6YeUBGHsZmWF88V72jKchxXdLBst9zOBELPa5a/aoN06uB72UqWAUo3cYE8TwUqzvXmWygOvJYie6+uwB6sbN/btd+bcZuEM9wHjf2WHE1IdEfW9JtJNfuusICtF/lPUvufwIjn4K7R2OJBwmTtYo6WRzFknYGPDwzzSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721780564; c=relaxed/simple;
	bh=eP3b4i1WV0j1Blf2F7YTyRrbdrFR4dbmreioZbacTm0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cdWGI2uwerrEbPJigLFjcTA7i38i6qKMkaWnv2RcVz22odY0hpO9mDw8odMUqpCdWmnFCGrDC2wNy9NVCKRMYxj2WvFaSztnHCSMMq4WSvsRrOe83gmGZS//h7vh2txIC5KwYEWWr7GPg5vyukofsuqt2DlZu0w7yMImNFR+drA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=D4FWg70o; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2cd46049d2bso338250a91.3
        for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 17:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721780560; x=1722385360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izQ7qTv90iE5ZqaT89sNcMyt9uj6MVTF0yOJV0dANbo=;
        b=D4FWg70oETEKlBh6Xn9GwQgO8Jw7DW76Jl19dhA+IjifpBM3ElmxH7gc0OfNofCsBr
         cACzOpK0J0urtAp454qD/Z516cPLFJVvWkPv3tVCv26jCKn/Hu1v/4o8U+QHFuAHTt6h
         LazU9/MWyZDCQwPhryILajXGXnJOfAAb/mqtndSUMcJGVxa8CGIzKXnGfmM0Ye+R4otm
         +eNSQkRHImOscKr4Fy+74+LIVtWZjM0XO7mc8kElX9ygGC8vEDr8cXkVNevdOmiYa5G1
         phhn8XfJtxPl0nGbMZLpni10MeAHa4BOx0zhGo6G11Nop7CwjqLYQL2A6DamQ6XeyXdO
         yGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721780560; x=1722385360;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=izQ7qTv90iE5ZqaT89sNcMyt9uj6MVTF0yOJV0dANbo=;
        b=wZbv5ebn0EwG+467xortEuH5Vtj0XRFJGNqgtP+Un1NEpahs4A9+UiGcUVun33pHi+
         1YSSf1fBRolTfQ3kr6sONLCNUFxLtWweyLfp5XqkVXaSWn8O5lJi8KdI5Xt4CQJmHEij
         XLbXNk4AUsYEhmWh2Rwrpk8Xq8U8nV0thkamsR1mFVsb9TWrpHTTToGn29f1uN2ER+jJ
         e+FZwnjYXiU6bzLglgcvlCcqDynhO2F1KyDozbnwLU+axuJ5Hx/xKXG66IeUoeEo/YE+
         3lCBGfyr7B02+OCJYduqPStEG1hxKERnVgAzrO40D4IkSkNzJFc6tQYe4Pm0jSPN0VTD
         Lvow==
X-Gm-Message-State: AOJu0YzHZ/z4CRj1aY2c85UBimBJiIWdljhbljpZISVR6iTSc4SuWjKg
	CyyMcTZQyEhQQ6zr6yIq7xyHswFXaObYW7+qkAJC/1tOYiWN4/KL373ASj7QdelOoKfBwEYFhim
	Fko8=
X-Google-Smtp-Source: AGHT+IHw1bqhWCOfEC8tNN6Y3zOzPOQbtk3cFqjVN5kMFlyKHudtK3NmPx/jyDLI2/ccFLVHMfVO1w==
X-Received: by 2002:a17:903:2341:b0:1fc:52f4:d7c9 with SMTP id d9443c01a7336-1fd746661f6mr96250865ad.11.1721780560187;
        Tue, 23 Jul 2024 17:22:40 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f470686sm81320785ad.264.2024.07.23.17.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 17:22:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <20240723231733.31884-1-krisman@suse.de>
References: <20240723231733.31884-1-krisman@suse.de>
Subject: Re: [PATCH liburing v2 0/5] IORING_OP_BIND/LISTEN support
Message-Id: <172178055915.217902.17466826008166195385.b4-ty@kernel.dk>
Date: Tue, 23 Jul 2024 18:22:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Tue, 23 Jul 2024 19:17:28 -0400, Gabriel Krisman Bertazi wrote:
> This is the v2 of userspace support for OP_BIND/OP_LISTEN with wrappers,
> manpages and tests.
> 
> Beyond the requested fixes in v1, I completely rewrote the testcase to
> avoid pthreads and introduced more test cases.  It also ensures the
> testcase is properly skipped for older kernels.
> 
> [...]

Applied, thanks!

[1/5] liburing: Add helper to prepare IORING_OP_BIND command
      commit: bf7c4f6b817c040bcc0215b43c64f95f1f50172a
[2/5] liburing: Add helper to prepare IORING_OP_LISTEN command
      commit: 7d515bb6a639efc64849223e179ea5d54ceaad0b
[3/5] tests: Add test for bind/listen commands
      commit: 3815f772333c81409b95903ea7382ec8c687c0f9
[4/5] man/io_uring_prep_bind.3: Document the IORING_OP_BIND operation
      commit: 7e9707fc3432b7c94fd2d59ad21bf105071660d8
[5/5] man/io_uring_prep_listen.3: Document IORING_OP_LISTEN operation
      commit: a877fb11036d7fd025f6129f54848363dc3b5b31

Best regards,
-- 
Jens Axboe




