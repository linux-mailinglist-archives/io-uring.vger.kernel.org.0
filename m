Return-Path: <io-uring+bounces-3770-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C7899A2169
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 13:51:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD8551C218B1
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 11:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685F51D90BD;
	Thu, 17 Oct 2024 11:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="OlYBCXM/"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-226.siemens.flowmailer.net (mta-65-226.siemens.flowmailer.net [185.136.65.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347E51D417F
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729165872; cv=none; b=u6wyGIoYMiLjbbeDqfndSheDxDQWieP90eoeQ7AfagUXlraHPNpbDAYUFZKKodUgiIOOeOoOq22JATziHP5x/Q/tvqbN9aO8TvBLQJCiOt18g+bRxFWthW8OfER4kn0kn7vm12Y86GT5Kkg098q+qWYGbX7lRhRt7JB9oKbL+d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729165872; c=relaxed/simple;
	bh=WkTucsPtpB2u5Lhgo5d9EThyRakdAX/+uyxryEnnG/A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C9EaYGqy+9DMtWId4URDmZWYBiFUulu2uJ2DhLtdqiuW01h8hR8EyscTl1PnBieutGGmrwxbj43asCkQ57GERIDvhf0pkyjnew7leg2UVKbfQ0IpYquEZ6Gi3CjGec9s6dou0adHn0uOVaw83tcYIiiOqNvZWnsE0bLY81gvr4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=OlYBCXM/; arc=none smtp.client-ip=185.136.65.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-226.siemens.flowmailer.net with ESMTPSA id 20241017115100a15f9d22f32a51d41f
        for <io-uring@vger.kernel.org>;
        Thu, 17 Oct 2024 13:51:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=7PXXG4fjS2p9UsaMGAkkgbvABbs+YqYWRGGj04qfp3c=;
 b=OlYBCXM/QVaecg6cKt2Y/a5na4S6VlGOa1HXXUknEQxG3UitsRuMEYnPxt7GxXw0jTAvx6
 g8rf2WtqoLzBATXMkAGmln85PaSGnwc5XLN/7hgHDfuJxkWaCa09ZtG0IF/nyE3hhVa/BDXm
 VdZ+3l1ykwtSrKLdkQxHdyax+WzUn6eWM4SEPh8rBBXNouR4YT0UWSi03ebGFM/Rjg7ROkwW
 cNOt7PpC1RWObNvcxDF1tPTTZ/HC5it9clTKRbWJP2lkXqYiShFUHHTL388V7aawZLbnu3gk
 xUYSuAi6UoGhpUVviSfZpuXbEsG6W0wX3DJ4mEqHr3XLAeE4n8xSLUuA==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: stable@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	gregkh@linuxfoundation.org,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 5.10 5.15 1/3] io_uring/sqpoll: do not allow pinning outside of cpuset
Date: Thu, 17 Oct 2024 13:50:27 +0200
Message-Id: <20241017115029.178246-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

commit f011c9cf04c06f16b24f583d313d3c012e589e50 upstream.

The submit queue polling threads are userland threads that just never
exit to the userland. When creating the thread with IORING_SETUP_SQ_AFF,
the affinity of the poller thread is set to the cpu specified in
sq_thread_cpu. However, this CPU can be outside of the cpuset defined
by the cgroup cpuset controller. This violates the rules defined by the
cpuset controller and is a potential issue for realtime applications.

In b7ed6d8ffd6 we fixed the default affinity of the poller thread, in
case no explicit pinning is required by inheriting the one of the
creating task. In case of explicit pinning, the check is more
complicated, as also a cpu outside of the parent cpumask is allowed.
We implemented this by using cpuset_cpus_allowed (that has support for
cgroup cpusets) and testing if the requested cpu is in the set.

Fixes: 37d1e2e3642e ("io_uring: move SQPOLL thread io-wq forked worker")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Link: https://lore.kernel.org/r/20240909150036.55921-1-felix.moessbauer@siemens.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8ed2c65529714..6b6fd244233f8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -56,6 +56,7 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/percpu.h>
+#include <linux/cpuset.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/bvec.h>
@@ -8746,10 +8747,12 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			return 0;
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
+			struct cpumask allowed_mask;
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
-			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+			cpuset_cpus_allowed(current, &allowed_mask);
+			if (!cpumask_test_cpu(cpu, &allowed_mask))
 				goto err_sqpoll;
 			sqd->sq_cpu = cpu;
 		} else {
-- 
2.39.5


