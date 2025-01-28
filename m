Return-Path: <io-uring+bounces-6161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C27D0A2134A
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 21:56:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB4EA18846B9
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 20:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90BA1DB34E;
	Tue, 28 Jan 2025 20:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mJJBpN5s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27BF1A841A
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 20:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097762; cv=none; b=trWYg4slFr7XNFd09q3oYm4v90yKgSu1rntut2DCmD0eCxtj6S5SO4MYH617NKfHvNmmFxkw5q90MD62TWCf/V3DBOTtzSTEbQPBd/WHCnhNLS9SSkySYM5EMsVEvRy8+7LiQ1ZRvMoPrlWYQDTLdWmmqjINeV6tiE4lC4tHNG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097762; c=relaxed/simple;
	bh=EI5qQSpUar51Kx9s9p7/6dcKRW1+iGPyeyB34BKJOGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bIGEMENewhIL/xyMBWZDuqjXOKE138I+Ah7hPAj7kVacz4YXuMccptn1QUn72mxh10QwkQOFVMzMgxAyrP5zahu2ME9lgdCdaQESWFbsZEIsR2DZ3a4PPYzH+6skadrbm/wy/F5F0fu9VdtQ0IJJiqazOeFsySMQfQVVaOBuUr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mJJBpN5s; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d3d143376dso8565781a12.3
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 12:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738097759; x=1738702559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=65MgcmOUTV3AmuOBh4UmGRRWGh7sI3Pn3n/kSQSsBwE=;
        b=mJJBpN5sQjTV3fzH10CklOquJc2569MsB5gY//mLgMVnjpAZ9r2wks5xR0tn3w/fPs
         xYu9aoBurJJ92iFpt9SrzZeUcRHzUGW3pVQXI4PoznP+xFlnODKv4DR8u34D/puayNO7
         17458/esSkpFeZUjzu36IGElakGQMkf0bfgTNw9Qg3DGzvSzS8wrx/Ev0kwlKTL0SQiv
         9Iwt5JKdR0DQ5xQnV0uU9Vx2cb4L7L8yHrn5YUT2DDMFRpIJ9ie6QvCfaXG3Gc1p+A7j
         YYjJGt9CwcRDWawgWGqBtbYFdJAhb4BoLJ7vtO7vtPj6WwP+qrY48AUU/cUveg3oPAiP
         6WYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097759; x=1738702559;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=65MgcmOUTV3AmuOBh4UmGRRWGh7sI3Pn3n/kSQSsBwE=;
        b=j3ddKRAc65/Y0o3K+QAWKqeTNVcWt+CAkCP5+0h07PIqXFkFb02LywJTuPkUCGmHMf
         4ySrNvQ+YaVTRtQQaU5P/fNZLRT5RdECdLD2naOsCFypEPJXqgf7BXnpdezI1CGXrehE
         q7xYy2A6+LCPvj+aXdLFcdmErq7qum5VBDf2iVxKP5D00Y7pmlw+gFvQqSdB0kfXk/nW
         MWehb6jgb3mgGIxvSpM4QZyZwBrQrfDh2QTG/62eajFBZTdQ3RZWYt+2XRbu5+IaSlob
         0G9z6RJsO5Ko0Fc3I28fL9wgg7RUnzS91uzQSCa0azWKrojraKkMVhIB8MT/ml6nxvw3
         HCUw==
X-Gm-Message-State: AOJu0Yz9SeeTkbhPY0ok2mgtplQGh20GCt+5JlzubTtz1PmZHkTQpwAK
	hnUO97BdJvZtpIgqRFvwqDHni9OYepeIXMiO4HdRWnOyC6nx5Q+QFOksCQ==
X-Gm-Gg: ASbGncvdYZ/RVZ5H4AWCZErZm4kANZwpWbDt8h19fDQ+1MJlvH7Q9qBMGr2hgevvavt
	6tkGgeJEJ/DDIJEn+vy1OqPUOqVBDd4ztyXVOEkKpt3eAVDmotUMY7A1gDvtJq9RdUykV3bA6z4
	g8li1j9j8jwT7hDBs9Lx2/FDpSlfB5yqCYXrHx9YCOKLKL1RgNK7XpvQkLrYFHOYuqPempuyGPR
	EbXRFMQFLI/NdNL+iI98corLiAUtGsqC6W5951HHU/nCrMyM8a2OgW/C2fXyWcE54Wc3VTHlhb4
	0vFNeHNaE3+ibGJ4yfENQjY8VnSY
X-Google-Smtp-Source: AGHT+IFu+bHZPn/qfDP/CJn3T+xwsQthWp9NFFAcny5u5WlBbd2nE+bUtZH5ZECVrjhgE45TlF1IAQ==
X-Received: by 2002:a05:6402:274a:b0:5d0:e9de:5415 with SMTP id 4fb4d7f45d1cf-5dc5efbf631mr286123a12.14.1738097758379;
        Tue, 28 Jan 2025 12:55:58 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18619351sm7736949a12.5.2025.01.28.12.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 12:55:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/8] alloc cache and iovec assorted cleanups
Date: Tue, 28 Jan 2025 20:56:08 +0000
Message-ID: <cover.1738087204.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A bunch of patches cleaning allocation caches and various bits
related to io vectors.

Pavel Begunkov (8):
  io_uring: include all deps for alloc_cache.h
  io_uring: dont ifdef io_alloc_cache_kasan()
  io_uring: add alloc_cache.c
  io_uring/net: make io_net_vec_assign() return void
  io_uring/net: clean io_msg_copy_hdr()
  io_uring/net: extract io_send_select_buffer()
  io_uring: remove !KASAN guards from cache free
  io_uring/rw: simplify io_rw_recycle()

 io_uring/Makefile      |   2 +-
 io_uring/alloc_cache.c |  44 +++++++++++++++++
 io_uring/alloc_cache.h |  60 +++++++----------------
 io_uring/net.c         | 105 +++++++++++++++++++++++------------------
 io_uring/rw.c          |  18 ++-----
 5 files changed, 123 insertions(+), 106 deletions(-)
 create mode 100644 io_uring/alloc_cache.c

-- 
2.47.1


