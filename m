Return-Path: <io-uring+bounces-3147-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C13975B55
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 22:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 488A91C22348
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 20:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453F71BAEF9;
	Wed, 11 Sep 2024 20:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FkmGRPSF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2F21B7917
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 20:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085236; cv=none; b=apBFzY1dkLxnxNrAAHXvwMOelf0t/FtE2PD/yd9OwNy9/A7tmSx9E4fKVxrACuX2SMopN9FbRYNwsswXzga+fV1ToTOucejQkl/LBaguSyg7o3/OVwFCevhd1r6tp2W4qJiA/pJe3EYHA8VTumsQA0t1SHKIVUEoR/t5f6ZzKWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085236; c=relaxed/simple;
	bh=eRiw7bSewnDCoKgkFsSjxYolaNSU423dH8dhpJ5LM98=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=sYvaEOLQbKWNhRXoE1bBfNsNKAYQ2IS3Vwycvx2qlwG9R9gvW/s/mKNm+G0LzTrOJw8nJ9Lt0BeMHgkORVQLv7CxJVy1U4b0E4iSdJqo4zHodg1QSeO7mKBwHQbqRdZRPMs3l4zdu+FBKaN727YThbdDy3w0wbm2wM9nFthylJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FkmGRPSF; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-82ceab75c05so9773839f.0
        for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 13:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726085231; x=1726690031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=XCetFP/BgCOp+/QcEsMHLlGtRT8rBm7Ad7CpUiUqmBo=;
        b=FkmGRPSFB0oQ6IEoWVQD6STlKsVL6WB1vIZeiYPHuy5w+jB+SPcAF6sy5YUe5F+lIA
         Gu7pY+o9QAVLaWMPXn2wKYLexRb3Z8FZ5gen7GC4CHJyvXCoNhuHlmJGOhNLo9ugCSir
         NNXYDajNHBnq5q55vU9gQA3IYXwvoUew9dAzKGrqCETJyQdpzeSqOubcFdxF2IOvX+xe
         lRfTKZAidGR07IQ3LARIZkdU+Axxjc8VcNkvKk/7Ue2vzQ2wxUq5u7LD9ZXQQly5hD/K
         jrnTbRi47d5f436fwwQ8+qEv+gxwO3fQVJcbme9YQsLv5v07BbSwrckOy5Y3ztjMh6HL
         jQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726085231; x=1726690031;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCetFP/BgCOp+/QcEsMHLlGtRT8rBm7Ad7CpUiUqmBo=;
        b=VLyKi9KAAY7uBrJvBhh0TvmjYmTRKOlAiX4s9mnd3wW5CfbgJRaQNsED5EZj5LHV5X
         dlSb3+k6TTzLYhM0hecmFOzgRX0Zw42dlSpya6oCphrgTT0TD6sgxRBMKAgmGQuJQa3s
         C+5taJA0pnXHM8hVfa+2cFn1qtaZiRZiWgfm8h6aAWbDwvjx9EaMF8l+iW/ZrtggUVB5
         QfTGJg/XsOQOkzLRg2O/Chve3bV9klv1qniSQQ+3sFdsNtuiNuVWf20V7LOx5oDA83kB
         PBKVU57yRzs+zB1SgHk2WWpwUTruU0Q1LIYZ5I6ubLWlBtLb8A/exGa4/WmCVCVrz8Pw
         z4gg==
X-Gm-Message-State: AOJu0YxDlTQYCx1/Xlh6eZlox2okI1MMuCvNxdQZXM5N3XE+NvAs9V8i
	XfQJHtTPP+FCi1odSMXwJlYdcurk2ErlPJQzElrVrcj0/9fv1IhD1iOKPZoEqtUvE38XOHyqMDi
	Xvc8=
X-Google-Smtp-Source: AGHT+IEtaIELQz0muUPSLJWYumBiVWemz4+5DAmX+JbnhxUqxBQtSgTFxzQFrgqoturw8TXXMGCF+A==
X-Received: by 2002:a05:6602:13d0:b0:82a:a454:6306 with SMTP id ca18e2360f4ac-82d1f8c7252mr97286539f.1.1726085230862;
        Wed, 11 Sep 2024 13:07:10 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82aa733a1d6sm289860239f.1.2024.09.11.13.07.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 13:07:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Provide more efficient buffer registration
Date: Wed, 11 Sep 2024 14:03:51 -0600
Message-ID: <20240911200705.392343-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Pretty much what the subject line says, it's about 25k to 40k times
faster to provide a way to duplicate an existing rings buffer
registration than it is manually map/pin/register the buffers again
with a new ring.

Patch 1 is just a prep patch, patch 2 adds refs to struct
io_mapped_ubuf, and patch 3 finally adds the register opcode to allow
a ring to duplicate the registered mappings from one ring to another.

This came about from discussing overhead from the varnish cache
project for cases with more dynamic ring/thread creation.

 include/uapi/linux/io_uring.h |  8 ++++
 io_uring/register.c           |  6 +++
 io_uring/rsrc.c               | 89 ++++++++++++++++++++++++++++++++++-
 io_uring/rsrc.h               |  2 +
 4 files changed, 104 insertions(+), 1 deletion(-)

-- 
Jens Axboe


