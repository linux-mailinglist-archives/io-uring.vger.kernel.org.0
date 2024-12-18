Return-Path: <io-uring+bounces-5557-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 652299F5BD7
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:42:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E66C189520B
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C02635959;
	Wed, 18 Dec 2024 00:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="qWMQZMCe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8B735954
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482301; cv=none; b=QDrUbmONQMhCsGlNpPuFjShhqCEV80Zm8+FLMR9U8r11JvEk2GTK+mFbqPPzthgL2ihzw4PVfBXWvWR99fUskPvLgcDEr5ldkqm5YW2mTabZJm9uDJ7ftIjE9gvG2B8+WE01MTE5GDjlYnhGDSaPJQk+PwhwgSubgJkz5JhIUWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482301; c=relaxed/simple;
	bh=Fti+Fru2O/FtINq8EuHguEm2wBZezE166gy2vOhc4kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqOX23c1zxdU1ET23OZ8qcz327sFJ79aIt7L3HvEykbIxa3jiop4ln+ZqBRdd9U8Os6y1O1fFD+/QBhfEv1vqbGfY2A5CMb+LvaWYYdq7RTTliOlRP/xRUBpLemYEoDVl1J7CENZdvX35rCTwh+iNr2o1uXVv1XYvi1I+bN+sVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=qWMQZMCe; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-725e71a11f7so179180b3a.1
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482299; x=1735087099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eCciZZc3yq3EVqcC94j9luI0Vp+16mZd5MSngMUL+ao=;
        b=qWMQZMCeCFZp+tnzEePTxEFyI8kaFjsUjB2ND+acwmZIn5WJNWQbMvjtv2n1ufkMgy
         sr1/abzkccIUi1dnWEVpgOy96uW130CN1lyb8SP5YdBWBAy0R96C4SsNHrwiF9f8Hyf0
         Xz/0SFQuq+anMG3SIxn0K0SX7SXX5nW1gZX7FyfPuKRLnQG5G/Qmvo33odPoda5THiXM
         DnB9sQnyD4ryyh4p8xJj3IcYtqT7Syc+dSoXxcXB7kmgiMsxZbMRqY56jSRUKYfJHZCb
         QKXAWjA5PQGIfwDYx6Mx3+c6gNEY0E2/hgZXGCUVj9SCICw0ZOZ2XuIwytgenIp9DSur
         oU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482299; x=1735087099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eCciZZc3yq3EVqcC94j9luI0Vp+16mZd5MSngMUL+ao=;
        b=dr9rHzMX/Uk8SVlGWKsIb08p3VmFY+ccvwpE7qFXsKSY7yudRnOyjvgEQeiz8G1/o0
         BopSaX9r+EL5CUx3ruk2ldB3R5exRUld1kf/9XFvxfSdCDBpVkSptBbd16NRGY8WTOBv
         r42LDAfaOyc+tyi9MzQQSDEEnsoxKKuxpmJ56drh013rT7PbLJ7FRufWUpkXyVY2ET2v
         Fv+dES171ak/rEcMqnpIo+LbyWKth86x5qna2YoMklD3FJGAoRLnLrsczhg/AjSiAELk
         QrGOr72kM4JF4OBnrkWH4JcLgLVg+LRb8G4SHj6Zrs4GYDq++pspPiXTpx9csPmJ5sgo
         MF/Q==
X-Gm-Message-State: AOJu0YyNeybweAha+HNGwJmMZGmV3fnOcGQw29s1DVJF97jmgVS66N0A
	PsVdsHzGNeJA1MjCY43fKcujE+rjpAqeYdiEMVaiqq1mJhF+3LhzNHtMynqiKHQtYFtsETiRpos
	C
X-Gm-Gg: ASbGnctFNM1iUHgPSpCYYeOOqsuKfhiZHdO71j63Hf5/ZluIwnNbWcFZuIJv7vTl5pc
	bUO2RpL5z0I8sghAm996/hrGDigJZ7CRBbioy/3rDbcFhJyMoFk6kV0yr1/qkl9FRp23c9K1mPI
	KDUvA1wjkYC45hqbr0yq+xulu9KggjjC6vJGPkG5a2By2yNtWuPH6G2+Favcd1yDlHlu2oagPPL
	jBwejKvG0BbFG/oATf6fmQtpF9LiNNfPxVy7GS5Fw==
X-Google-Smtp-Source: AGHT+IE/aF0H+vfJ03/915bxOxU5FrppyJM5Zop0EY0U+bzqWnbOjPe7+5sXEtJSGHhhJjkk34drdQ==
X-Received: by 2002:a05:6a20:6a0b:b0:1d8:c74d:1ca0 with SMTP id adf61e73a8af0-1e4e7782a9fmr7641838637.11.1734482298849;
        Tue, 17 Dec 2024 16:38:18 -0800 (PST)
Received: from localhost ([2a03:2880:ff:21::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-801d5aaf567sm6416992a12.18.2024.12.17.16.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:18 -0800 (PST)
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
Subject: [PATCH net-next v9 19/20] net: add documentation for io_uring zcrx
Date: Tue, 17 Dec 2024 16:37:45 -0800
Message-ID: <20241218003748.796939-20-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
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
index 46c178e564b3..d6ce9c5f179c 100644
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


