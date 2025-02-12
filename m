Return-Path: <io-uring+bounces-6380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9089AA32F21
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 20:00:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 240623A6E2D
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 19:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707D3263F2E;
	Wed, 12 Feb 2025 18:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="EmbZ8TjM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B87C262817
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 18:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386760; cv=none; b=hs8lwOsKb+vwOPG+ZXXARGYCnG709JkcVa9dnAn5Jxxsi+5nx66hMQbMOhxjp9blJaG33MPUlZF31dkCQH8fLzCRKHHymZRWaWsxfSgSEaZiOaiTHRbewNBD4H3CuJKNCYwplZLHL+CKEjq/D35JIozz/PtWxImieYWOZv9bRtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386760; c=relaxed/simple;
	bh=9pTdmByBVpWL3oRo72V1P/Qnfm3p1w1EAQ8TvZwzW4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pesTNugIFGUoxuK9MbdjpIYjaOO4UIEdJImTVm0DyrDjbe7LYNwwfKH7P4j7WkC3MTuG4Rt7NcOjgEgqt9rL9CnhWsoKYLsrWJtKWhC7DAgLAs9ORBxHBaQQE3UpHYU0kiA5H7FB6JEX0RLnFJ0jYA2PX52TCIp6AT+a9b6h2E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=EmbZ8TjM; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-220c8f38febso14439925ad.2
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 10:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739386756; x=1739991556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NHWoGsRhiFc/ooKo3TvF3R3d8ADOTW+DffRpnDLhJ48=;
        b=EmbZ8TjMTdDrfcM+n2gNijV42NI28HDG6dgezndFymBVQOffsQgEGvR/VobYIOtV/z
         0fPdqzePGwTnA5hav5gIwAcU2gbDgXbuQ8jjoMggRFzDJnKbpTJ1XOeU1WjwidZhSlvu
         /YT7yHqaEeh3e2hLq4RQirH4D/1xZEXgjO140KDdsKP/xQh7SLm/uFrTjsUH6FibYPec
         YogppvISJX1K+Ipt7BTtn21yVnc7EIcz16OtzeZc5jlQLsvLhIv2k6gS1YByp+CEnnXX
         SX/76WjQ8VR3nv0B6EuYlKX9VmEoJkcRX2H+w0X7SBkUsvvH9Om6MPbQaB7Zq6lJKqGT
         2swg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739386756; x=1739991556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NHWoGsRhiFc/ooKo3TvF3R3d8ADOTW+DffRpnDLhJ48=;
        b=K2hPrMgxfoW6dSMHZzrILq60zOZkABv6UxG6rMGaBUGKPuTQXIgBAKa4JGXyQ7Kq7K
         Jrygz1Q4BvgDcDy8X/18tQGed1njqjl1AsayuVZ42gFRyWKOKgmm4lNNxG/A9TPaBXzk
         lW+sjkaMhRNkxwsBsgxfrKB5/Ijfzivsl2Na8+88ZFnt55eGEEsbYPM6dOZf9NDLqfoq
         rXN/dJZQ4QuiHHF1fYnXSjopVbvLAJxKoM4GrfP62FLs+YY1t392SiYKLeGlWWdIRvfT
         E8mVXxzJykWoxCkgFlFrjz8KsnnrL4YnG1LA1HCG0fojz21Zn70zmOSSyWCnuYCQdx2I
         IT4w==
X-Gm-Message-State: AOJu0YwtEfjN2QPPmbjpiXkb38p8mvT7E/w0Q6Zb5ZcR8da3zqHZtVfU
	gbdH2R79jFb4qj/mFtjbioC4A744P4YoLntiAifnxrsuUPNbITDfj6XJMLuxvkMJA5f5gB8yc7b
	V
X-Gm-Gg: ASbGncvthEd+04Viq1rhjpGYthJfI11sE0A9sLdoQ3frONJ1XU2TBkdNiSollA94nVK
	bkRX74Ug23uszEfCNW40K2cv3Fd00wHAsCBZ8nvFbt7s5/xUH7xYva0baknXjprJ/uH39I4khIf
	SO1dXlTWc00Nu0PMKVZ+X6zYKpHdXPTxBPKH7Cf98PL4ILaGyPm5yYCa85QHzhG3Qzq8aK57J0Y
	UMhE8myFAhxpi5C5CalWBDkNZ5VoFL463B0E7PKKQfWBUU1tfH+Iy59hIaRVRjyfeo5x8toUpwB
X-Google-Smtp-Source: AGHT+IHCFlfixa6KjP6YmcpUGIN/NNsejdfcLQhFihNNDU8POVbfi8RxA+ESXd2uIhuEC5K8YngjiQ==
X-Received: by 2002:a05:6a21:6da8:b0:1e1:cbbf:be0 with SMTP id adf61e73a8af0-1ee5e5bbea4mr7406758637.22.1739386755760;
        Wed, 12 Feb 2025 10:59:15 -0800 (PST)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7307a29ecdesm8003949b3a.173.2025.02.12.10.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:59:15 -0800 (PST)
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
Subject: [PATCH net-next v13 10/11] net: add documentation for io_uring zcrx
Date: Wed, 12 Feb 2025 10:58:00 -0800
Message-ID: <20250212185859.3509616-11-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250212185859.3509616-1-dw@davidwei.uk>
References: <20250212185859.3509616-1-dw@davidwei.uk>
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
 Documentation/networking/iou-zcrx.rst | 202 ++++++++++++++++++++++++++
 2 files changed, 203 insertions(+)
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
index 000000000000..0127319b30bb
--- /dev/null
+++ b/Documentation/networking/iou-zcrx.rst
@@ -0,0 +1,202 @@
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
+    unsigned long mask = (1ULL << IORING_ZCRX_AREA_SHIFT) - 1;
+    unsigned char *data = area_ptr + (rcqe->off & mask);
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
+  unsigned long area_offset = rcqe->off & ~IORING_ZCRX_AREA_MASK;
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


