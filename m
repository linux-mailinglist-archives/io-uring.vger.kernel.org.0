Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CC22CDAD6
	for <lists+io-uring@lfdr.de>; Thu,  3 Dec 2020 17:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbgLCQIM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Dec 2020 11:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgLCQIL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Dec 2020 11:08:11 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737F0C061A4E
        for <io-uring@vger.kernel.org>; Thu,  3 Dec 2020 08:07:25 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id l7so1678213qtp.8
        for <io-uring@vger.kernel.org>; Thu, 03 Dec 2020 08:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tJw7/E0VTnK1zaCjwCyjq8Pp3tfknLt1cpPvyuMD/xc=;
        b=eMg69kVzn5GJOq6lGSZBMvlvxR/SS5LkjfYW3F4lxTn6uc8VpR1CJE968HM+kxDNsf
         M9ZrmZHBOoB6wrMp1KIs64vSSNIM3lcLSwFxsOyQ9jKRUCBsTL4+gxiY4qcgNVHNlgVv
         oMo5VLYpAO0I7GQgwHJa5atep3Nfzu31BU7rYsk9ygihXLcMiKvaDKY/tuqcb366bfcp
         j0qngtDcuz3mA+45B75pR/6dPmktdcKovXOk2jUI9PfqLVP8V/yv5B6rbVKbFCLHcxpV
         oBroMBsvMNmxRwlUMrdRuxEv11PZXAkwkPOM+O0NiHMi6bV+7IVEA/Q+2T3AmOkBnKL0
         9VHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tJw7/E0VTnK1zaCjwCyjq8Pp3tfknLt1cpPvyuMD/xc=;
        b=cgH9f5L/8PAGC41mh5JStAruAod1vRvsj85Zy+we/KGntuygyfoU+RSc+R/Use++kY
         SUDUg4aegCToXbWuEDJk0Atd0IZmve3RE8iTiauENHOdqgc258Ip6sAp2BBdYlWW9I+O
         smRv7xIqXiF+RVcB+zsJRqesrvwrpYKCMcBrnYNAp+R3kLu4mnJUCBcHbL4sUpcEUqtH
         i7m2YLWa2W7zfY5JHyqjhGSTEnha30h0jtqDHuEqsO6261Cf72drjpKnChCxLxzAvv/c
         N8B1SUDKLb8mjt4RlwJ0KVi+/oLr8FhVkk+Q4tZ8se3lKZfVWR6eAYS2seHZKHUcf/qg
         nlHg==
X-Gm-Message-State: AOAM531gO7PdgoSy7NYtywptAcRfbdX3gZa/iQwctJMHxcGSsVUKq3de
        L1yVxisQ9GfFUjv6/HoO2oOKtS7EprkKuA==
X-Google-Smtp-Source: ABdhPJy2AYgLNAa5vYlifaC1CrVXjqtxRCx2Omj4WH3BbXgn5MqpT3xI2MXwGeaRrY9oGLKYzd9plg==
X-Received: by 2002:ac8:7651:: with SMTP id i17mr4037153qtr.248.1607011644729;
        Thu, 03 Dec 2020 08:07:24 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id l46sm1732538qta.44.2020.12.03.08.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 08:07:23 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH liburing] Don't enter the kernel to wait on cqes if they are already available.
Date:   Thu,  3 Dec 2020 11:07:06 -0500
Message-Id: <20201203160706.4841-1-marcelo827@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In _io_uring_get_cqe(), if we can see from userspace that there are
already wait_nr cqes available, then there is no need to call
__sys_io_uring_enter2 (unless we have to submit IO or flush overflow),
since the kernel will just end up returning immediately after
performing the same check, anyway.

Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
---
 src/queue.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index 53ca588..df388f6 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -39,29 +39,38 @@ static inline bool cq_ring_needs_flush(struct io_uring *ring)
 }
 
 static int __io_uring_peek_cqe(struct io_uring *ring,
-			       struct io_uring_cqe **cqe_ptr)
+			       struct io_uring_cqe **cqe_ptr,
+			       unsigned *nr_available)
 {
 	struct io_uring_cqe *cqe;
-	unsigned head;
 	int err = 0;
+	unsigned available;
+	unsigned mask = *ring->cq.kring_mask;
 
 	do {
-		io_uring_for_each_cqe(ring, head, cqe)
+		unsigned tail = io_uring_smp_load_acquire(ring->cq.ktail);
+		unsigned head = *ring->cq.khead;
+
+		cqe = NULL;
+		available = tail - head;
+		if (!available)
 			break;
-		if (cqe) {
-			if (cqe->user_data == LIBURING_UDATA_TIMEOUT) {
-				if (cqe->res < 0)
-					err = cqe->res;
-				io_uring_cq_advance(ring, 1);
-				if (!err)
-					continue;
-				cqe = NULL;
-			}
+
+		cqe = &ring->cq.cqes[head & mask];
+		if (cqe->user_data == LIBURING_UDATA_TIMEOUT) {
+			if (cqe->res < 0)
+				err = cqe->res;
+			io_uring_cq_advance(ring, 1);
+			if (!err)
+				continue;
+			cqe = NULL;
 		}
+
 		break;
 	} while (1);
 
 	*cqe_ptr = cqe;
+	*nr_available = available;
 	return err;
 }
 
@@ -83,8 +92,9 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 	do {
 		bool cq_overflow_flush = false;
 		unsigned flags = 0;
+		unsigned nr_available;
 
-		err = __io_uring_peek_cqe(ring, &cqe);
+		err = __io_uring_peek_cqe(ring, &cqe, &nr_available);
 		if (err)
 			break;
 		if (!cqe && !to_wait && !data->submit) {
@@ -100,7 +110,8 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 			flags = IORING_ENTER_GETEVENTS | data->get_flags;
 		if (data->submit)
 			sq_ring_needs_enter(ring, &flags);
-		if (data->wait_nr || data->submit || cq_overflow_flush)
+		if (data->wait_nr > nr_available || data->submit ||
+		    cq_overflow_flush)
 			ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
 					data->wait_nr, flags, data->arg,
 					data->sz);
-- 
2.20.1

