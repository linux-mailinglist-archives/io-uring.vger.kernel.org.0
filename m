Return-Path: <io-uring+bounces-7923-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E96DEAB11F2
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D88E9E507E
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 375CF22A4D6;
	Fri,  9 May 2025 11:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gmsp96hM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6508227AC2E
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789108; cv=none; b=J1t9U37l4OAZlNNr3jVoKYrrsH92pTdDLYGjbG6duF3xNnCCQLi9PCt33j8GzkxqumqskV6Kke7YDU+m6CbY0xBx9JvU1/rzze+y6mZ676g9KKDVzbaKxcxFN4EPJSKl1oC/j/zs6U+bsRjbj+pkoSuOfWUIQ+hMvxLdIHpBYa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789108; c=relaxed/simple;
	bh=ife2C3aOJCwdInzuT5Z++R4ak1y0Y6uS14cHt8wWvWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sX5FibSsKpmFDA7JPsDOyPKPbWAbYUHpf9RQg5ulT8cQiP5jV39KJYbQ9jGXjX/g9IxTX+5/p5cOZiGKJw0vq+7VZqukYZMP1faBvCFdBAV/6Cs5xHQbZCp5aAq7iI4fWbvMJf+u8StPdc53wYwSvhQlDn55xYOfJ/9lqCoG7pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gmsp96hM; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ad228552355so46288666b.3
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746789104; x=1747393904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5joS451W7q4yqaSYrWOlrFZSxoQ7omUHRNOfB/l9Tck=;
        b=gmsp96hMSB2xYoMMvVrcjv8APOSaIE4ZABvH01KcFprilI3rdU6eBX8yf3LRHj+mBu
         gj0tPwUIO6RZSpBGGoqN5QLLS9IcrawyJZuYvWMtHrAvDh4FXxGAHOgHFSBrzJ3fPFbC
         OB9I/iiHcWhmOGEUmwLYQjJaRQ5vKixXiSNOsKvGrHPUE1GfhDaGp/vev1HN8PVZZAAm
         s1pZpb1ShsItR2mgYmENOPobEKVvM7RTnwhCqjhT9ve7to8nHwDfhCsCOX51AR9l7qwz
         LNJQYGOrBdMxve8zP5FGRB4wckPqKCZDYm6Rj/kD0A5gIBUbou+YOHmbqywPQAExhuj3
         rUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789104; x=1747393904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5joS451W7q4yqaSYrWOlrFZSxoQ7omUHRNOfB/l9Tck=;
        b=QBO79C7ZDQ9WCUW4pkyTrHgQCDGMiRNH3m4zaRAE9+XDj+MMBr1Df6qolRo7/IdiKA
         R52ZGq13fw9adqi4dRLIHGC0T35kqH4pUxk1wut8uW+LoBxD8zw/doQDlrRKEqfc/b3g
         /vQwRscdVNOvQCkhlTzVGcDmAAcc8NRTXXKXN1AHKiAR69/jvU1XTPK8UaTv79V309gE
         BthgBMY0kyBY1q8hU3SjgzeCF6Gk3vbINNP2bIgZf2H7E8BS652NNEgA95T/xWH69pRE
         93osqghttIcC6g0zH19WJYZJf9LCHhp5cCF1cndu2EGuJYZMHfNc8ytG5yo4MRS1MIf4
         IRVw==
X-Gm-Message-State: AOJu0YwHtuADyiMRxC39IqBUbQPbsNoGnVfYRXoRiRBNrfNCYjGW7xK+
	mEHBvZzXT4mXHNua2e3cx7S5AJxpv8SGRg8nIn7HCp9t0Iw7dZ3oiXkvpA==
X-Gm-Gg: ASbGnctDgr2m539/p+CX9fAurc/wgl/BsHpbYvE+dUcEXcaHt0cYxhE40jcxHby/suh
	mED9V5v1VAIeJIP4LLRKty/FbTLRDgvgdV46yKtWvYxffOD52wV7TP/R06SY1XYeGSbMV79eCWK
	dXgz7nZ4et2XBbbhzHXijlPI2NhUkl/eGn7s28X3phpu5EmT4Z16u/lERfR5NvlfteZ/vguN0Bs
	DCiTUwuBYJFyX0Ow4i8lKAecni0jEtnBJoi8W8ifxdIU1xsCmt8qM81pVzqcW2ARhUQ5q818s9k
	sTZK//H377o0L0lRr4sQECeg
X-Google-Smtp-Source: AGHT+IHKzpso6JMG6Tb40e1OroAi38Xcg6VGsHsgulH3GBHHUG6f2leQAapozGdg9plpl11Llw8NGw==
X-Received: by 2002:a17:907:969f:b0:ace:bead:5ee1 with SMTP id a640c23a62f3a-ad219131246mr295428566b.42.1746789103937;
        Fri, 09 May 2025 04:11:43 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad219746dfasm132717066b.119.2025.05.09.04.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:11:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 0/8] allocated requests based drain and fixes
Date: Fri,  9 May 2025 12:12:46 +0100
Message-ID: <cover.1746788718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patches 1-7 are fixes and preparations. Patch 8 implements
draining based on the number of allocated requests, which
is simpler and remove cq_extra accounting overhead. 

v2: fix executing still drained reqs on spurious calls to
    io_queue_deferred() (Patch 2)

    Only clear ->drain_active after flushing, if a non drain
    request got flushed.

Pavel Begunkov (8):
  io_uring: account drain memory to cgroup
  io_uring: fix spurious drain flushing
  io_uring: simplify drain ret passing
  io_uring: remove drain prealloc checks
  io_uring: consolidate drain seq checking
  io_uring: open code io_account_cq_overflow()
  io_uring: count allocated requests
  io_uring: drain based on allocates reqs

 include/linux/io_uring_types.h |   3 +-
 io_uring/io_uring.c            | 137 ++++++++++++++-------------------
 io_uring/io_uring.h            |   3 +-
 3 files changed, 62 insertions(+), 81 deletions(-)

-- 
2.49.0


