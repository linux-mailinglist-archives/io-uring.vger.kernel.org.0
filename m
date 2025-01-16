Return-Path: <io-uring+bounces-5945-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE78A14559
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:19:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EA9018847F6
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F45D2475F4;
	Thu, 16 Jan 2025 23:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="n7rakZHI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CE32459DF
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069451; cv=none; b=SppnlgeG0UQo4Or5NrPoSm/LRxt+3kYGvgaaV+qXlShgmlVZ/Zy63GJmW1Zq3DwyNoIBbMI3rTxY50z8PTp4v6HSX1n7TZ+1T4uSaQnfdMfrj6Go603ok+QerNQQdOks7MeHQCesq0dXXUXaGRGpI1v4VCPD3x/o/5fZjOV5Jxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069451; c=relaxed/simple;
	bh=aPsgcI6sv2YIZcrbbnlWPzhKE0O2/vrVZpMxYf0vPWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObxSaPk7bsoArCD7kXoFVPWI8Hi/qV0ybVN8qn5ncmDHX/y9uylZOo+8nz64MsWn83n7mKcLWCY4L9B1ahkXh7sJHOgwn8AETIRciM6/yHRxYEUZuycRDTOfHZIrkls42ugdk7tiYyDD18i0vQwzcKYjbXKwOqg5mzvhRRvmDbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=n7rakZHI; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21669fd5c7cso26688925ad.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069449; x=1737674249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EFrx4dtkhpWaD6dvhicsjhhig5cONS03Ll2dOXxfwMI=;
        b=n7rakZHITxkr4P++NlkiVyKNz8+7y3YrB5WBlOnwjpCE2C6kZIcXdoj+SfRjpCEJu5
         33/wuFLBSRfh/vf5snhIdR+wvYK+e+HGrcMTJDbPsWz24xK7GxR6Q1isQoeaHs/FfKjY
         VYG31SY0EKCDkQn3hPz0V3w2HU6KfEIqvS9qeBjLQx/nCkcx5a12ydSReJuVgy3QEGYF
         s/524YBGVjsGnVgvabQ/lcjPPeeCjaazPR8fq8C6JVi1m7eUSKvX5PCRNsJ21xa9v43U
         0gVGHCVnM/LQ6uls0XLG7sumnL6ytn8pFX8Bb6ThVKdP8Kkzkd7kRw0Uq3A5jhBDQa6F
         miOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069449; x=1737674249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EFrx4dtkhpWaD6dvhicsjhhig5cONS03Ll2dOXxfwMI=;
        b=OzYONggNYEb/qfkyUfzw2yYfvTEdGGFyr1Zbkp+9f2pMlzqllg/3dLN8PkfsAo8/13
         MItQCQG2WVOTnYVDncSXLpzcmc/siZYAtnIGoSnrwsugQLo+5/BfcTQfB3TLH5wocPzU
         aIAF7fo2JNAxaDrHKWp4vOXNw2wMdyqR4yyFJ+AVqaRtE/9+rkW1LEYbL704kchwoFBg
         rqBhYOzPtMTlpn13DZoFP4lls6ykCE20UiPmK5iN2P9fte/aRlxxP93/mklq4i5QdBnQ
         fFZkZhNLapqSsYtmCZojlmfxaMrIs2oqFqkw0+DPPFg6+WoguV7iLRSba2doLo9ZSraC
         gf+A==
X-Gm-Message-State: AOJu0Yw/O6P/K/miX1JD0Kzvtr0biWFQmTMPUcvqvrw0U2GbEeCLv4l6
	gqEzQIyGTHnXTLdEk+X+Xu62PUJn2NUVYhEeGn0dihDydzU0inpJz6wTNYcjtwz4HDukm0eYtnA
	C
X-Gm-Gg: ASbGnctr4HRGJfwKWe2Fs/on7XvOHbyRdjOQKOl5PrDnz/qrZRIVEhsrEkCvlgBQnJ6
	isV8R8JH8thYY6Steghvx9XqYJVQwdamJfCMwPxWfr1JP4MW6MG7LRKwhVBwLn9KaGtYfB5gAfo
	htZXvDhC40Vv8xFuS/wbHDps5aNHgzAJ3K3LmLZyHBbCy5AJp+nTlgaxBS2RLJlIxfTfZ0KRwtp
	7trfH/vQ2/x3G2JSZzVZYMJu2kPIsP+dC8B+xo0Zg==
X-Google-Smtp-Source: AGHT+IEJ/gqghOJxd2TDDQDXM4bFQnd4Rz3G5xYAmJzRD5lljlGIKa3GdLohUK0dl0NVpi4ehbGUEA==
X-Received: by 2002:a05:6a20:3d89:b0:1e0:c6c0:1e1f with SMTP id adf61e73a8af0-1eb215e1995mr668470637.36.1737069449357;
        Thu, 16 Jan 2025 15:17:29 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1a::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab81754csm565197b3a.63.2025.01.16.15.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:29 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v11 20/21] net: add documentation for io_uring zcrx
Date: Thu, 16 Jan 2025 15:17:02 -0800
Message-ID: <20250116231704.2402455-21-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250116231704.2402455-1-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add documentation for io_uring zero copy Rx that explains requirements
and the user API.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 Documentation/networking/index.rst    |   1 +
 Documentation/networking/iou-zcrx.rst | 201 ++++++++++++++++++++++++++
 2 files changed, 202 insertions(+)
 create mode 100644 Documentation/networking/iou-zcrx.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 058193ed2eeb..c64133d309bf 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -63,6 +63,7 @@ Contents:
    gtp
    ila
    ioam6-sysctl
+   iou-zcrx
    ip_dynaddr
    ipsec
    ip-sysctl
diff --git a/Documentation/networking/iou-zcrx.rst b/Documentation/networking/iou-zcrx.rst
new file mode 100644
index 000000000000..7f6b7c072b59
--- /dev/null
+++ b/Documentation/networking/iou-zcrx.rst
@@ -0,0 +1,201 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+io_uring zero copy Rx
+=====================
+
+Introduction
+============
+
+io_uring zero copy Rx (ZC Rx) is a feature that removes kernel-to-user copy on
+the network receive path, allowing packet data to be received directly into
+userspace memory. This feature is different to TCP_ZEROCOPY_RECEIVE in that
+there are no strict alignment requirements and no need to mmap()/munmap().
+Compared to kernel bypass solutions such as e.g. DPDK, the packet headers are
+processed by the kernel TCP stack as normal.
+
+NIC HW Requirements
+===================
+
+Several NIC HW features are required for io_uring ZC Rx to work. For now the
+kernel API does not configure the NIC and it must be done by the user.
+
+Header/data split
+-----------------
+
+Required to split packets at the L4 boundary into a header and a payload.
+Headers are received into kernel memory as normal and processed by the TCP
+stack as normal. Payloads are received into userspace memory directly.
+
+Flow steering
+-------------
+
+Specific HW Rx queues are configured for this feature, but modern NICs
+typically distribute flows across all HW Rx queues. Flow steering is required
+to ensure that only desired flows are directed towards HW queues that are
+configured for io_uring ZC Rx.
+
+RSS
+---
+
+In addition to flow steering above, RSS is required to steer all other non-zero
+copy flows away from queues that are configured for io_uring ZC Rx.
+
+Usage
+=====
+
+Setup NIC
+---------
+
+Must be done out of band for now.
+
+Ensure there are at least two queues::
+
+  ethtool -L eth0 combined 2
+
+Enable header/data split::
+
+  ethtool -G eth0 tcp-data-split on
+
+Carve out half of the HW Rx queues for zero copy using RSS::
+
+  ethtool -X eth0 equal 1
+
+Set up flow steering, bearing in mind that queues are 0-indexed::
+
+  ethtool -N eth0 flow-type tcp6 ... action 1
+
+Setup io_uring
+--------------
+
+This section describes the low level io_uring kernel API. Please refer to
+liburing documentation for how to use the higher level API.
+
+Create an io_uring instance with the following required setup flags::
+
+  IORING_SETUP_SINGLE_ISSUER
+  IORING_SETUP_DEFER_TASKRUN
+  IORING_SETUP_CQE32
+
+Create memory area
+------------------
+
+Allocate userspace memory area for receiving zero copy data::
+
+  void *area_ptr = mmap(NULL, area_size,
+                        PROT_READ | PROT_WRITE,
+                        MAP_ANONYMOUS | MAP_PRIVATE,
+                        0, 0);
+
+Create refill ring
+------------------
+
+Allocate memory for a shared ringbuf used for returning consumed buffers::
+
+  void *ring_ptr = mmap(NULL, ring_size,
+                        PROT_READ | PROT_WRITE,
+                        MAP_ANONYMOUS | MAP_PRIVATE,
+                        0, 0);
+
+This refill ring consists of some space for the header, followed by an array of
+``struct io_uring_zcrx_rqe``::
+
+  size_t rq_entries = 4096;
+  size_t ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe) + PAGE_SIZE;
+  /* align to page size */
+  ring_size = (ring_size + (PAGE_SIZE - 1)) & ~(PAGE_SIZE - 1);
+
+Register ZC Rx
+--------------
+
+Fill in registration structs::
+
+  struct io_uring_zcrx_area_reg area_reg = {
+    .addr = (__u64)(unsigned long)area_ptr,
+    .len = area_size,
+    .flags = 0,
+  };
+
+  struct io_uring_region_desc region_reg = {
+    .user_addr = (__u64)(unsigned long)ring_ptr,
+    .size = ring_size,
+    .flags = IORING_MEM_REGION_TYPE_USER,
+  };
+
+  struct io_uring_zcrx_ifq_reg reg = {
+    .if_idx = if_nametoindex("eth0"),
+    /* this is the HW queue with desired flow steered into it */
+    .if_rxq = 1,
+    .rq_entries = rq_entries,
+    .area_ptr = (__u64)(unsigned long)&area_reg,
+    .region_ptr = (__u64)(unsigned long)&region_reg,
+  };
+
+Register with kernel::
+
+  io_uring_register_ifq(ring, &reg);
+
+Map refill ring
+---------------
+
+The kernel fills in fields for the refill ring in the registration ``struct
+io_uring_zcrx_ifq_reg``. Map it into userspace::
+
+  struct io_uring_zcrx_rq refill_ring;
+
+  refill_ring.khead = (unsigned *)((char *)ring_ptr + reg.offsets.head);
+  refill_ring.khead = (unsigned *)((char *)ring_ptr + reg.offsets.tail);
+  refill_ring.rqes =
+    (struct io_uring_zcrx_rqe *)((char *)ring_ptr + reg.offsets.rqes);
+  refill_ring.rq_tail = 0;
+  refill_ring.ring_ptr = ring_ptr;
+
+Receiving data
+--------------
+
+Prepare a zero copy recv request::
+
+  struct io_uring_sqe *sqe;
+
+  sqe = io_uring_get_sqe(ring);
+  io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, fd, NULL, 0, 0);
+  sqe->ioprio |= IORING_RECV_MULTISHOT;
+
+Now, submit and wait::
+
+  io_uring_submit_and_wait(ring, 1);
+
+Finally, process completions::
+
+  struct io_uring_cqe *cqe;
+  unsigned int count = 0;
+  unsigned int head;
+
+  io_uring_for_each_cqe(ring, head, cqe) {
+    struct io_uring_zcrx_cqe *rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
+
+    unsigned char *data = area_ptr + (rcqe->off & IORING_ZCRX_AREA_MASK);
+    /* do something with the data */
+
+    count++;
+  }
+  io_uring_cq_advance(ring, count);
+
+Recycling buffers
+-----------------
+
+Return buffers back to the kernel to be used again::
+
+  struct io_uring_zcrx_rqe *rqe;
+  unsigned mask = refill_ring.ring_entries - 1;
+  rqe = &refill_ring.rqes[refill_ring.rq_tail & mask];
+
+  area_offset = rcqe->off & IORING_ZCRX_AREA_MASK;
+  rqe->off = area_offset | area_reg.rq_area_token;
+  rqe->len = cqe->res;
+  IO_URING_WRITE_ONCE(*refill_ring.ktail, ++refill_ring.rq_tail);
+
+Testing
+=======
+
+See ``tools/testing/selftests/drivers/net/hw/iou-zcrx.c``
-- 
2.43.5


