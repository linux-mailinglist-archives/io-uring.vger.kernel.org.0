Return-Path: <io-uring+bounces-42-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E86537E2E48
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 21:39:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D6671F21029
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 20:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C6428DC6;
	Mon,  6 Nov 2023 20:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HPMrB31p"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06978FBEC
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 20:39:20 +0000 (UTC)
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CDDD47
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 12:39:18 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-507b96095abso6253035e87.3
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 12:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699303155; x=1699907955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8HkGA5AXefipYbrTeJ2JFYbv8bsxPAJpnK/SE+yscFk=;
        b=HPMrB31ps0FAADdND+sd5MWql0ul1ZWgAukj1urTL48zEz8ZDUzEBSdCF0uB3GoDuD
         iNKdWMx6+l3sYP52QG4jY/VV721Rot5coqZLBakqmcOdyEKIFKmRDCEs0iTrnxxcUhMq
         HylG2qQjC9U8IJBODhmEtumuzndXrMMDRIO9l2SaQBNbYFmru8Y02ciz2CXxJgmvSamF
         VVVMUGyvxUsUwfb5pIrx+b0iKDLTbrJGnntGUtwH0pKfxQryC1mH/NnaehChGomguOhx
         JqnCLbqpMzHsrq37uBU/KNY8IzCEbf7xOfavse35BPSD/0Ossd+voBkL2HwEXStHwkVg
         Heng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699303155; x=1699907955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8HkGA5AXefipYbrTeJ2JFYbv8bsxPAJpnK/SE+yscFk=;
        b=N68Wge420/AhatJfgJJLc3og8WJl6VeLjSrY1gsoO7tL6g+ymsxNnA6S7SfklbXh86
         w2bOB3jRyZf+sG5q7fgoEoLAdPuSgyz3aM0FIFEsTpzvma1r7IYN56Bg06RhEEQ6uZG9
         83x7RGPS3b0P+nE1X67BZENb+BxEAnlnhvl7Y3DQYOnEFP4BSgIi4BbdPFtHFXzWlKFD
         KF0MtmV5icvNLaMHkg5u25ewLUDlJks9zEiK99yfkkW4xxCr/Wi52nCgchISWGcgFa/a
         x1xCtpxLpfYpSzRHoOTNr0cbr+DEgpaMZpl+C12SFme1btisabqrwgJNhYD6Xz9btx5N
         vqIg==
X-Gm-Message-State: AOJu0YwKEmkGrdWVNlp/sD2MhccGCCxsUPtFeYdZ7KvxW7FdsWU41LDT
	KbMAdl+RjwPKBq1tra71OQ/UD7y2xW0=
X-Google-Smtp-Source: AGHT+IH+QIAQlPR9H9S+O0PeEbWaoJUjwkCbpg/zG1i9UJWS2WeBYM8LMgn0xLhJ4/oBNn8akJb4eQ==
X-Received: by 2002:a05:6512:33cf:b0:509:4c8a:525d with SMTP id d15-20020a05651233cf00b005094c8a525dmr11971337lfg.35.1699303155350;
        Mon, 06 Nov 2023 12:39:15 -0800 (PST)
Received: from puck.. (finc-22-b2-v4wan-160991-cust114.vm7.cable.virginm.net. [82.17.76.115])
        by smtp.gmail.com with ESMTPSA id s7-20020a05600c45c700b003fc16ee2864sm13349062wmo.48.2023.11.06.12.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 12:39:15 -0800 (PST)
From: Dylan Yudaken <dyudaken@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH v2 0/3] io_uring: mshot read fix for buffer size changes
Date: Mon,  6 Nov 2023 20:39:06 +0000
Message-ID: <20231106203909.197089-1-dyudaken@gmail.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes a bug (see [1] for liburing patch)
where the used buffer size is clamped to the minimum of all the
previous buffers selected.

It also as part of this forces the multishot read API to set addr &
len to 0.
len should probably have some accounting post-processing if it has
meaning to set it to non-zero, but I think for a new API it is simpler
to overly-constrain it upfront?

addr is useful to force to zero as it will allow some more bits to be
used in `struct io_rw`, which is otherwise full.

v2:
 - apply comments
 - add a patch for io_kbuf_recycle to show if it did anything

[1]: https://github.com/axboe/liburing/pull/981

Dylan Yudaken (3):
  io_uring: indicate if io_kbuf_recycle did recycle anything
  io_uring: do not allow multishot read to set addr or len
  io_uring: do not clamp read length for multishot read

 io_uring/kbuf.c |  6 +++---
 io_uring/kbuf.h | 13 ++++++++-----
 io_uring/rw.c   | 13 ++++++++++++-
 3 files changed, 23 insertions(+), 9 deletions(-)


base-commit: f688944cfb810986c626cb13d95bc666e5c8a36c
-- 
2.41.0


