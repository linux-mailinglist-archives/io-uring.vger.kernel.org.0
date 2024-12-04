Return-Path: <io-uring+bounces-5229-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD519E42A2
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:58:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 819C3169D45
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AC72163BA;
	Wed,  4 Dec 2024 17:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="G9fqGKmS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173C12163A5
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332984; cv=none; b=qI9gMmbu4Kkc3lAHptuOBIYzos/FPrUgMklAM6fYKB9rrbj8X83BX7mLFHjojSjo2QnKD5r+YbgaQ13FOBGznQ3o0jYJVbA3Ta+xOQfl8/Sx/tamTAhgRwTC27twQmJlWHUgxKlhva1eXmwA8AC/kimWiPn1Jsc6PbrSxFFZRPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332984; c=relaxed/simple;
	bh=G1zac/FrdM0gIe8YwspufTx9nda5a+tBvmguzkjovy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJoH66NDQPThFcIJE2m+g0EHJ9b9itxruJXdV9st9BiwJZpFbGPUSl1+WS1RCA1b3tzIkGNHHTagEs8Sy4aqb4M121yqGEV5HXpURcBEk1uTXtaMc050y7iX8yj5H6GHJxjAw2dPDd3K3dYSmi94wKRYnE3Cv/UxD1LK4eLCHLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=G9fqGKmS; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-723f37dd76cso74420b3a.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332982; x=1733937782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJekRoIcm/1Er4pwWyRsR39n7PkzzcOxVAQMEmkZaiA=;
        b=G9fqGKmSEdUww/e50vCqt1vPGgC0qh+uWMHEzoPsw7bA39RlQq/UYqW9zwRgsASOUX
         152RDH6haZ7ojGo6UW/4sLlN9R0kw8eOW8u+PC5ETDirPShoITu4YU2OQ2/ldzxHFpPN
         Li7FvREYAPIst+u25PUU17fM5DJ7t6CX8ss7x8NKCmCP63JwjGugiD4KQnnMmgPeYQg1
         qtBOiLFlaVUxm6LP4ZOg0prFTi/vg7dA4c0vfr/nGzNKeo+HEX379x/dYLK8UwACN2+2
         QRxloW08Guk4pzojRH8K1pzMEUjt6hU46uoQh8mYocMLgUHxRGKPoJLin6F0mrKfqT/d
         YyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332982; x=1733937782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJekRoIcm/1Er4pwWyRsR39n7PkzzcOxVAQMEmkZaiA=;
        b=ZuL4wByIH+cA+Zumc50JIDrCg5Z+7ssUQcd1xX+kdyoul0gW/fhw6Kf3Yj/EMPbtfK
         stZrr+VsLEA2Kc4mbtFNxgGD+3eXWhrT1GcAAPReNwUGa/7OEtjoQwvxJGA08itAOVa2
         zORb4EjXtX+HOgvdlZFgn3KcEAWiWqkQkGqM53DbG/MYq4l9ZeiMqyKoTXM16xgEaqcS
         HSnLM8YPBpRrQ+zXgcIO/NopBuSfZH8JB0NGKucw/GTPsQn1mbrzCcbTvNukUoaTW8Uk
         6gRiQW3bv/7XSm88JMgwU4vfOlM7TeC7yPSQoPPc5Q9Moyh9YmC6grq1YFuUuTGpYeR8
         9uhg==
X-Gm-Message-State: AOJu0YzSZWqBbis5eDUeXtPsEUxw2r1WuZwYvxF5InucGw+D7v658w4P
	O8fbUjCp9AH4+njeElwW9+ekgxiVZhVgcWpt7GsG6M+uYXifKQnWg2bV7NpxaZFZdCZrKsstbaf
	U
X-Gm-Gg: ASbGnctI03tVBuvX6H2TycZxPnCvzm8N5v4O0433m6Y0JYrk5QdTqppg+9YdZAGB29W
	ytwbqo/a7JKAd0tfnotTmooLlCtSMo4ldL7JUXgWLpVc4L3RY9iZ7MDxxbD9zwRwdTFvCkZKSTj
	S1vxtLrmrnmy5iLryB6H1PF0V7bOOr5NYlOkX493GfOeMTUjjrkxckVYyA9/fev0SpDZ7Gje85S
	6yhFrh0HEgR/37ZW+tztsNSwMJgoY3RuEo=
X-Google-Smtp-Source: AGHT+IH5V9UYcGCa4plFPp9ChGYwBiebQjLlpyqrYLZFl+FkJr9WuGVyaoVcY828FQ1WnBu5x7N2Lg==
X-Received: by 2002:a05:6a00:21c4:b0:724:e75b:22d1 with SMTP id d2e1a72fcca58-7257fcc62c5mr10668943b3a.16.1733332982501;
        Wed, 04 Dec 2024 09:23:02 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1d::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7254176fe28sm12617505b3a.72.2024.12.04.09.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:23:02 -0800 (PST)
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
Subject: [PATCH net-next v8 16/17] net: add documentation for io_uring zcrx
Date: Wed,  4 Dec 2024 09:21:55 -0800
Message-ID: <20241204172204.4180482-17-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
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
 Documentation/networking/iou-zcrx.rst | 201 ++++++++++++++++++++++++++
 1 file changed, 201 insertions(+)
 create mode 100644 Documentation/networking/iou-zcrx.rst

diff --git a/Documentation/networking/iou-zcrx.rst b/Documentation/networking/iou-zcrx.rst
new file mode 100644
index 000000000000..0a3af8c08c7e
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
+Ensure there are enough queues::
+
+  ethtool -L eth0 combined 32
+
+Enable header/data split::
+
+  ethtool -G eth0 tcp-data-split on
+
+Carve out half of the HW Rx queues for zero copy using RSS::
+
+  ethtool -X eth0 equal 16
+
+Set up flow steering::
+
+  ethtool -N eth0 flow-type tcp6 ... action 16
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
+    .if_rxq = 16,
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
+See ``tools/testing/selftests/net/iou-zcrx.c``
-- 
2.43.5


