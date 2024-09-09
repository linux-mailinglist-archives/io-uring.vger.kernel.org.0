Return-Path: <io-uring+bounces-3093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF2BF971D62
	for <lists+io-uring@lfdr.de>; Mon,  9 Sep 2024 17:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54009B22DFC
	for <lists+io-uring@lfdr.de>; Mon,  9 Sep 2024 15:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C19134A8;
	Mon,  9 Sep 2024 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="UEYY5X7T"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-64-227.siemens.flowmailer.net (mta-64-227.siemens.flowmailer.net [185.136.64.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0814A82
	for <io-uring@vger.kernel.org>; Mon,  9 Sep 2024 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.64.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725894060; cv=none; b=ovMJ42By3PuhLXzwrCDyRJ4J1jUz6LJJgkn2EXEplo+X1b6xXbdTeK5apdrwoi/vWACBJ6HASvVCBZK97+eIHEJ27M3AlUsuwJls3BPSmVpEPdDs0OJoEoI+aEHB2sklObN+Qa+imM6FQQyh41fzWVQq+DJqzIMTyzu9mqvkSrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725894060; c=relaxed/simple;
	bh=RzOo4nswEo3jSmFZkHprYDJX4YMV6YOVmHsXRuguc3I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UciVKAX6AsDCEN+pjDkoI07FChQKpIbjPL2rp22a2zVWlK9Ffsj8embnHszyD9Q7mFbYfIFaqazjGRvh/iL+tOS8fZoMvRz0M9mgCdurGRs1L8PbTXzIlYGX2T/DN+J8BN6cb6vaImV/q7kUl4+10i+O0Nzt+YvWu0JaZTQHHH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=UEYY5X7T; arc=none smtp.client-ip=185.136.64.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-64-227.siemens.flowmailer.net with ESMTPSA id 2024090915005217f775c7e358e65035
        for <io-uring@vger.kernel.org>;
        Mon, 09 Sep 2024 17:00:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=X8ddSxPwoRliEpQfz+Jf+VCcHRWUMvdaMj1Nlh/9NU8=;
 b=UEYY5X7TmjROFRyYtCHlEzx4t24DMp5YL4hySPe6h9WTnpz0lWSLABoy7dAvKjnNF4b2s8
 miG+PXci6F0GzQyXFt2C1WEkjpYWd8ybyLc3vzvpsIm2AHdaQ0nq33CQFK/hbU2zcnknNez7
 ZJ/AMH5sWfu0/KgJqTCGoPF+J+zqjnUfjI5oWO4dNi/rIxz/lm5cyqne6k/Cbz9RKxASI8P5
 59eeZXbsQW/5kCh1kRKGvr8WUrl5pb8ptwj6dvQcuCNC1gyTGDF7ZrLwUhKqau0otFK+5tXj
 hMa7SxWede2zJX1NGLh8ZTVb8s0bDuygmUzy3P1jK0d022gRhWUVDglw==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	cgroups@vger.kernel.org,
	dqminh@cloudflare.com,
	longman@redhat.com,
	adriaan.schmidt@siemens.com,
	florian.bezdeka@siemens.com,
	stable@vger.kernel.org,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 1/1] io_uring/sqpoll: do not allow pinning outside of cpuset
Date: Mon,  9 Sep 2024 17:00:36 +0200
Message-Id: <20240909150036.55921-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

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
Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
Hi,

that's hopefully the last fix of cpu pinnings of the sq poller threads.
However, there is more to come on the io-wq side. E.g the syscalls for
IORING_REGISTER_IOWQ_AFF that can be used to change the affinites are
not yet protected. I'm currently just lacking good reproducers for that.
I also have to admit that I don't feel too comfortable making changes to
the wq part, given that I don't have good tests.

While fixing this, I'm wondering if it makes sense to add tests for the
combination of pinning and cpuset. If yes, where should these tests be
added?

Best regards,
Felix Moessbauer
Siemens AG

 io_uring/sqpoll.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 713be7c29388..b8ec8fec99b8 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <linux/cpuset.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -459,10 +460,12 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
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
2.39.2


