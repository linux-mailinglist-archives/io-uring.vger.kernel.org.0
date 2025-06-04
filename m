Return-Path: <io-uring+bounces-8219-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69634ACE2A1
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 18:59:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35B4D189C704
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 16:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49CDC1E1C36;
	Wed,  4 Jun 2025 16:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rzmJLHEO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EAF18E1F
	for <io-uring@vger.kernel.org>; Wed,  4 Jun 2025 16:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749056215; cv=none; b=na2OjFPEX7xILIj8pbM6OFc6WnDSh9ZWNzF2zBZyhkO7gCoPp7EfpOUfC9K+/IqgMSrrjArwffMxHQLCH45ZNJGtV1+2j+MlTe6ZfKpOSgdMaEKwnoSZj4RLFCtBHJSxoG86s4pNbcsPFyqfykeoyfCyfDIGqwVvJBtLs6YXORc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749056215; c=relaxed/simple;
	bh=+LwhPN+64+kQ+PQ3GHI55Wi8GS2yMJFMiuqOu05BpO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z0AJPnQgt4Ghq+QkwnWy0X6EjxVB7Fq3ApfUuvI99rd5+RCzRhZGWkHPMLwNkF3eUMNDdsScxoaubUPA3202vsm8AzjzS3heveRIvPj3C94i+mLKcH0SxeWQQv3ZsoeTJrE+gsUcjHssSN3xONCea2LDBMzgdXStePzRBBLbQcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rzmJLHEO; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86cef0b4d96so258339f.0
        for <io-uring@vger.kernel.org>; Wed, 04 Jun 2025 09:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749056211; x=1749661011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=71Lzis6DOHTvS+XSE2VEmFRRvtGIhjKlEZrYkLsNct4=;
        b=rzmJLHEOPeyPOnavmq+vz7xyNkR9/OJxa8vPiVgryqMukDir8VHkKjbJ+tMam/rPIT
         UcLHTELJgOgWZmOlw/xUPJd+NudrFlPxgPKvZ3qHeHtGr6MA80TAq2VQUNCLWFXD/K4M
         IQne5i/xSVDBh7kxRL9Ivh085YXIhXvFuc7nCQmONvEwxvBMqwF1lA7FM/01lJ2JNeBZ
         WWWR9u140vvQC1s0l/L7VZv208YY1jN2n5OC5O8XKOUU9RuO1I/8rQS50Di99d6odm65
         ucQFiAtH/IIfgI8TlTrGTsYDLOS+BVZh8um+HCmRHT9VClNNpKw2TNvN5Y51x1gmMl/H
         sBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749056211; x=1749661011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=71Lzis6DOHTvS+XSE2VEmFRRvtGIhjKlEZrYkLsNct4=;
        b=pPij8BgsIsZJ82L1mHusTALoQWB1LwJ8RtdzmPLEPwn4/K0GmGvquRJ6nCVJZWtko6
         YyQv3eKIGpcKtVSbI+x9L0VJKyS6TqykxdRLGHMgksxGR5mGMNgKgb/ueBqiR1eAVqos
         tsMFitK1KE9Ly8/ifNQix/sCikElBH/cJu1BRJpOmF1QzBiBKIe98I4/LqNxA+3nC2v7
         v24NtjiVZgZVCou5+WiAP2fVQlMbsXhPx7cJQE6Q05CfFX+JsYvfjPsBMjyQxu3B/YCw
         TBoyS7cRn9MrPFIIePcdCrOGKanoj0a5fBa+3xIT+mUGJeQiKcj/tABVs1cQK+L58y04
         IZZQ==
X-Gm-Message-State: AOJu0Yy+Mlhq+87u0YsIwgyEJeU6g4uFh6dHoWVOhYPsPf37mPyEUd2h
	GhfvKbFLhUnBdOls7f8KuhC1QjzbVckyExznwKcf738Ex/jP3tURwzvb+pda87mCqGQhhEuIbWv
	gYNlY
X-Gm-Gg: ASbGncvdeO8ob/ZJna8V1WvsUG8kljOqzNU+R7p/WMx9BBCAg8qgZIUIeirucBKVLVp
	krvxE8EMQ8wOP3xQCErZnyZyjhvf9YcKk34SaposxENBLLWGxkPAv7NVUp5pv3dnzhzevyLJLIc
	TUaqoq4P3HRZPx5503gyZRE3qs9WO5H6K4uQEKKkNVnYgUYVtqJl0r2k3SYmNL7pjuCN1JyQLou
	K7n6J3B3lTpUeFQw5CtFURt4/eOOxAIoLNmBmOPe8a8KTy4X6ioyFsyp+EKLbaO4eV88OgRy23o
	ba7iyT66gQGOoSzgvZCWNs/ptAmy7qpWpTESBKkHv+sCa208vfz2N6U=
X-Google-Smtp-Source: AGHT+IFVafbnmxIghI23Eql69NiNRPFtDZDM6vD7fG7peWEAw7kifyfqHMKv0CSFOqnOLp61KE9V/Q==
X-Received: by 2002:a05:6602:c8b:b0:873:1ad3:e353 with SMTP id ca18e2360f4ac-8731c5d244bmr428821839f.9.1749056210863;
        Wed, 04 Jun 2025 09:56:50 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7e3c18dsm2751391173.69.2025.06.04.09.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 09:56:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: rtm@csail.mit.edu,
	asml.silence@gmail.com
Subject: [PATCHSET 0/2] io_uring futex cleanup and fix
Date: Wed,  4 Jun 2025 10:53:33 -0600
Message-ID: <20250604165647.293646-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Patch 1 is just a cleanup that I came across while looking into an issue
and patch 2 fixes and issue introduced in this merge window with io_uring
futex handling. Patch 2 works around the fact that since:

commit 80367ad01d93ac781b0e1df246edaf006928002f
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Wed Apr 16 18:29:12 2025 +0200

    futex: Add basic infrastructure for local task local hash

futex is reliant on ->mm staying alive for the duration of the futex
or futexv wait requests, if those requests are using FUTEX2_PRIVATE.
These types of futex requests use a per-task private hash queue, and
will actively remove those at __mmput() time.

 io_uring/futex.c    | 11 ++++++-----
 io_uring/io_uring.c |  7 ++++++-
 io_uring/io_uring.h |  1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

-- 
Jens Axboe


