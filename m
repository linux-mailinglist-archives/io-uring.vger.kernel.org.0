Return-Path: <io-uring+bounces-10925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 533F9C9D721
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8BE9D4E452D
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9615E26E175;
	Wed,  3 Dec 2025 00:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQ8GBVNR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA7B26CE17
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722242; cv=none; b=DPTzXLp7nj3uNuK1TMyNKG7oH23ZFqGRI9VZeOeAfhDBc8HVwCjozOwA5ziiV04+ybDHcrjYGULbj2bR9BrFsg8hfF3yodbSho2eMoxxizCzOoKisO99rQTHfLezzs3h8gAbNjxRS16RTMLmacU/M2wWTvfjZBG0QkocJMpJCBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722242; c=relaxed/simple;
	bh=RRRVmnuSlO2yAUlxwC0oPD9059AuiV98qY7YvSV4HJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXBaNuo8t0YrWmky2nP1hidnd/jN3YyL/qRQ+Q8DoTsbNNpoRgnACbCIJb+ziLN5yICrCVb/nqqPELO9Ejc4jmClRrb9dXBkO1xVYHXmU+ab/1uFCZhGF9fHvi3ajmk3djS/IxxSN14zy5kBoZ6MRwxcMAXnJ8vxG5QU2Ts1ZQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NQ8GBVNR; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so6716071b3a.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722240; x=1765327040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EG2G6U8pfCC1wTS9qAldfTiYW8GZ41ecBEhlt3Vx2u4=;
        b=NQ8GBVNRrkrZLE6POSgF7hyGm6OnJMecmdjPZt7XwDaj4ZngBf9MDAlSZ+jPe87Wfr
         A5/CBIQ6Xm1Qe+QhnNd+zvgRqXrSQgAMlculonHMR0UsTpgIhMDXv+DifCrBJEYC3jHw
         gXTfP4bm/qOqAIzr3dW9EJ7Yf/3kKKyklkUlSxI/ubxzbChVyVULzfpzpZljlIdWkic0
         lwT0UuKSxJJfjvdGDygvVp07x+jtHSBR+jxMFCMUULW3ARMfOu+mrCYO048RvEL4KAGk
         DeLdFe8Y14VpNYWxj/zSAyqrojHZJgfZytzbyDceohQYWHr9F1J5C3q2k2FnW6Pvq9i1
         ok2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722240; x=1765327040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EG2G6U8pfCC1wTS9qAldfTiYW8GZ41ecBEhlt3Vx2u4=;
        b=e2DxvqvFgf3BPPB1RuKpKx1hn+r1XyTazaXyiOG59npLTB6NYHBM2O3VME0Y+WVpE6
         0Y94uzNQ1eFT0ivREfQyL9IjncJdsyexrRaEguDdwYuWpv4LwpR7fNgVSUcAcVg2nSHF
         i02bO4ydpu2ubnSNM45NKYIQPE2K7iiXAuksIhqUfbVu41xwRu7CVv/Ne0FvDoHgv4oz
         artJGeAs3m/hhs4m4euRTkPVdDeLbhM0bF1fqJ7K7n0HaXYuB47dVHijs5akyRvKGH+U
         5e63aKAHltxziFEWWK/3pDmXk3Ff+35JGE+YZd87Q0mhxEiKay5dTgVtqdwpZATvZO7n
         rj4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXgcKafJfJLAnpdYGkRU5OkohBPlKDt8/aU2yH0pWhRZd/ZI/cO1KiRvw/6EMI/QtVt2/dKJeyLwg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxoOsBJyNJJ4hL6r339TN2fYU5f2iJq/5fD5Nco63xzz8S5aNr6
	TEhI3S10GDG6mU+CBWNhUp/6FV1y1+9tAjuYKmfEVLWPlgmeoZWYURj6
X-Gm-Gg: ASbGncvxrZ6oWwF4OzKmNovtYa5I3mHAloLGlrrcajNjDcSleqjoGuF6U2oJjR9wm9V
	HhOr1LGR+++jNkFJMc31WSHD4usjpG9KEdSVU0LNYGKS9MV5Z7nG1YvKS/mQ7+7fHMbxbOMPlnq
	OoigbHM8/l/O8DjVlL14YZ6l8FFhyY1VfRy9zAl8tP1PIWwZVJ0gHjCBeOblfw85f/hyPH7Zhjj
	71HVgt8ISyNU9im1kjH052VJizsVsebYW1yIdK/FonZE8X4YxN73YgPO9Ma3Hz6RBHxX7zHHoy2
	yxffg5lmRjABhOtlOysFZ1oEgIFyldm08fpDucFhWTWB7n0SV+3NiMEOY6afFJPUvQ+0lwYNPJR
	4AgkIe43UAD6qkSwJQ0Fw6i7Mti8z0owHK4fBeO/qMJgk00Mn9oTkV/NoElRdn+3C3Lrb+MwzbV
	sZuaOQacToU/KS9hOFHgmtfIITs5P3
X-Google-Smtp-Source: AGHT+IEflUnue+4P0QQ0xgarlCKeNigyt2dqEt8BoputBM87r7zg+mnVlp/6Yl4h+pAEW2HDBx11mA==
X-Received: by 2002:a05:6a00:3e04:b0:7aa:2d04:ccf6 with SMTP id d2e1a72fcca58-7e00453e088mr447884b3a.0.1764722240346;
        Tue, 02 Dec 2025 16:37:20 -0800 (PST)
Received: from localhost ([2a03:2880:ff:48::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15f457c38sm18031924b3a.54.2025.12.02.16.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:20 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 30/30] docs: fuse: add io-uring bufring and zero-copy documentation
Date: Tue,  2 Dec 2025 16:35:25 -0800
Message-ID: <20251203003526.2889477-31-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
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
 .../filesystems/fuse/fuse-io-uring.rst        | 55 ++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/fuse/fuse-io-uring.rst b/Documentation/filesystems/fuse/fuse-io-uring.rst
index d73dd0dbd238..9f98289b0734 100644
--- a/Documentation/filesystems/fuse/fuse-io-uring.rst
+++ b/Documentation/filesystems/fuse/fuse-io-uring.rst
@@ -95,5 +95,58 @@ Sending requests with CQEs
  |    <fuse_unlink()                         |
  |  <sys_unlink()                            |
 
+Kernel-managed buffer rings
+===========================
 
-
+Kernel-managed buffer rings have two main advantages:
+* eliminates the overhead of pinning/unpinning user pages and translating
+  virtual addresses for evey server-kernel interaction
+* reduces buffer memory allocation requirements
+
+In order to use buffer rings, the server must preregister the following:
+* a fixed buffer at index 0. This is where the headers will reside
+* a kernel-managed buffer ring. This is where the payload will reside
+
+At a high-level, this is how fuse uses buffer rings:
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


