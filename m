Return-Path: <io-uring+bounces-11793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0866D38A42
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 251BD30C1463
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C891326D4F;
	Fri, 16 Jan 2026 23:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d4kpSA3o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7CF3271E0
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606311; cv=none; b=gJ7AC+w6fRYmUH4DMXHTKFmgAOE66EJcVjiwsdCF+5xeGaIRUtw0cuaXVeqZ+cHxQcvrYGz6s4wsOpM4PFZcR14vJmNxc/Ah0uWWU0dRnZoIAihgr9Qtk6NbADWflb5iMDuZeCfRLfEfclZ9Wi4ZhhotPsgsVgaSvICbFnc7e2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606311; c=relaxed/simple;
	bh=V9juZQv6dZ0gT/KwWlkT+L4ounPrVhIWYnGjGMKnfLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CztzAvNeTQhJ83Vy92a604EG/6azYFDg+jiiv48+Gn/HAekPwc/IZsxUWv78VLdU+jKfzU2lqw8H1baSj5fIxRqdPIFPm9uNrfipwQMsJ9UGlOvbTWvbnNGViDVHA4t2T26/9IpJ5b6u+MyO/iBXgHotH815iJ43feW+rkj5hUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d4kpSA3o; arc=none smtp.client-ip=209.85.215.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so876658a12.0
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606309; x=1769211109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rCUvZ2hYYQ5gvK1i3te6jPtSCGz2KbW6xvKvu1HTms0=;
        b=d4kpSA3o9Yrdo4ohji9aCTvxuT7CnPC95GctmXCAWUwdBbb43Bz74AIOkmG+fywXfj
         FjnVKUm26tCfWvVZc9VOcJKHOuN9GcT3dKUiAxpnXnFb00EyHyGy52ucHYM1ru2c4tiE
         80DOymDKATv1uSkZwQmjsPRETmGMx/ZQHdl9Y9K1M37Zf/X4mE8vLbthZGgvo1HzW/9d
         B9TT4+oWeZpMa2DuA2Gb9LpbYlgIfSfUXGMPm/+NdszNplKVzzA6r2+4TeHH2sS3B/Jj
         h2Ko3wefVREnPcM6slj/CX6TDf5ev6Z6YokkXYgObHmohFPFmG+kHzxRtVTHa0TQ8eoN
         Ilyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606309; x=1769211109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rCUvZ2hYYQ5gvK1i3te6jPtSCGz2KbW6xvKvu1HTms0=;
        b=ugM7wOsluu8PHzuMealg9LXhxSLFe1Xf88QSy2q+h3fiP1x5DYqm4Bdm394Z0xytlP
         bohnVvc9qPAbSd8P8KnNhkjvydJ2/vOprB8kX6cwqtN+cA012HkYKIuXnvyIGQyRFOHj
         MPDteLTttVyP4+DP15vz0gv30STj1zXiz16bJG0HZo00W4QjAL2yM3L92hM+cSPXwFYj
         wdY6bmKco6PL3x9mWpoGcQnCJC6soEOERwStWz+xKz987ujuPDkGxevsIie7dbaBCVDo
         dD4qanouzevh0r3o7No8Z6yTPcbVJ0WdNTWHUkAnje1LMt29rroIJTUunO2uslGp2DtO
         le8g==
X-Forwarded-Encrypted: i=1; AJvYcCUdjrzv/5tE4eYEhS7dVBUqJHgdINNXHypa/DoSZIhxCpHl5bOnz+wrrDWDbc2MSpMKq+arFEiQKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz0dqLJ70tm62EGYofYdm5k/drYeVuRxRpLev/8wBIu2/xzyX6
	NQZYuswYRuicnLoqMaZXmBtvxL+RvZIsgMZCMKh/1Q6dMo7/rovIjUy9
X-Gm-Gg: AY/fxX5XyYH8MYD4ySSxEYjs3xyj3LqwEZsWwYQB17u1c91L72Tkd0lPb9vm0atbyzt
	06jqBMzHLZQmsqHLOmUSHAlLE1PWvGDcyX8zk8Gq0+cOWF+3H/0UM1/lXkfzraa/POp9HxiY0RS
	AcQXtsrOr9Pv3XlOTCoZ9zl2UnYDwt39IsFDknqd2ITMXtgZ0Sbwh8lmv8DJgf820ffsbvXuOpC
	kTTIekemJjNzEVCtyRBgwzM4qizSv9KoQiL94n6vHbWUAKXAC0RtO8cCAY2TX+s0LiAjyWqWIkF
	dg3hT0qyA20R/bQZIkApe60voP3ao0T30ecpRIULNySum/my74sBSb/LlrnIl6fNgif50G0a71K
	aNNM/5zy02HVQXBoXrSch6F7sDFbN5/JrLR02FHnQ5RObh56VNOawrz8SaEmN0Ogyi4YX7ubAcz
	fghj2S8lVCnjVgUgbc
X-Received: by 2002:a17:90b:5603:b0:340:2a16:94be with SMTP id 98e67ed59e1d1-35272ef6716mr3512884a91.4.1768606309107;
        Fri, 16 Jan 2026 15:31:49 -0800 (PST)
Received: from localhost ([2a03:2880:ff:52::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35272f4a9a1sm2947963a91.0.2026.01.16.15.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:48 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 25/25] docs: fuse: add io-uring bufring and zero-copy documentation
Date: Fri, 16 Jan 2026 15:30:44 -0800
Message-ID: <20260116233044.1532965-26-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add documentation for fuse over io-uring usage of kernel-managed
bufrings and zero-copy.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 .../filesystems/fuse/fuse-io-uring.rst        | 59 ++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/fuse/fuse-io-uring.rst b/Documentation/filesystems/fuse/fuse-io-uring.rst
index d73dd0dbd238..11c244b63d25 100644
--- a/Documentation/filesystems/fuse/fuse-io-uring.rst
+++ b/Documentation/filesystems/fuse/fuse-io-uring.rst
@@ -95,5 +95,62 @@ Sending requests with CQEs
  |    <fuse_unlink()                         |
  |  <sys_unlink()                            |
 
+Kernel-managed buffer rings
+===========================
 
-
+Kernel-managed buffer rings have two main advantages:
+
+* eliminates the overhead of pinning/unpinning user pages and translating
+  virtual addresses for every server-kernel interaction
+* reduces buffer memory allocation requirements
+
+In order to use buffer rings, the server must preregister the following:
+
+* a fixed buffer at index 0. This is where the headers will reside
+* a kernel-managed buffer ring. This is where the payload will reside
+
+At a high-level, this is how fuse uses buffer rings:
+
+* The server registers a kernel-managed buffer ring. In the kernel this
+  allocates the pages needed for the buffers and vmaps them. The server
+  obtains the virtual address for the buffers through an mmap call on the ring
+  fd.
+* When there is a request from a client, fuse will select a buffer from the
+  ring if there is any payload that needs to be copied, copy over the payload
+  to the selected buffer, and copy over the headers to the fixed buffer at
+  index 0, at the buffer id that corresponds to the server (which the server
+  needs to specify through sqe->buf_index).
+* The server obtains a cqe representing the request. The cqe flag will have
+  IORING_CQE_F_BUFFER set if a selected buffer was used for the payload. The
+  buffer id is stashed in cqe->flags (through IORING_CQE_BUFFER_SHIFT). The
+  server can directly access the payload by using that buffer id to calculate
+  the offset into the virtual address obtained for the buffers.
+* The server processes the request and then sends a
+  FUSE_URING_CMD_COMMIT_AND_FETCH sqe with the reply.
+* When the kernel handles the sqe, it will process the reply and if there is a
+  next request, it will reuse the same selected buffer for the request. If
+  there is no next request, it will recycle the buffer back to the ring.
+
+Zero-copy
+=========
+
+Fuse io-uring zero-copy allows the server to directly read from / write to the
+client's pages and bypass any intermediary buffer copies. This is only allowed
+on privileged servers.
+
+In order to use zero-copy, the server must pregister the following:
+
+* a sparse buffer for every entry in the queue. This is where the client's
+  pages will reside
+* a fixed buffer at index queue_depth (tailing the sparse buffer).
+  This is where the headers will reside
+* a kernel-managed buffer ring. This is where any non-zero-copied payload (eg
+  out headers) will reside
+
+When the client issues a read/write, fuse stores the client's underlying pages
+in the sparse buffer entry corresponding to the ent in the queue. The server
+can then issue reads/writes on these pages through io_uring rw operations.
+Please note that the server is not able to directly access these pages, it
+must go through the io-uring interface to read/write to them. The pages are
+unregistered once the server replies to the request. Non-zero-copyable
+payload (if needed) is placed in a buffer from the kernel-managed buffer ring.
-- 
2.47.3


