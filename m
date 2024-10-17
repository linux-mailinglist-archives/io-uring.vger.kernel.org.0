Return-Path: <io-uring+bounces-3771-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF729A216B
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 13:51:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2626A1C21EB4
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 11:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A561DB956;
	Thu, 17 Oct 2024 11:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="JcJ6vBvc"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-225.siemens.flowmailer.net (mta-65-225.siemens.flowmailer.net [185.136.65.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C1C1D90AD
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729165872; cv=none; b=SiIO+JUgne8gpSwWKW221sSUbfNO5tyPlWu/Svh7YaNCGHJRmNgUiwL3DSWZ5DSX78n1olL35eoMNl0dSN/aSvO0abXve48lSKGGqpfUCIka1vD9ksep59x4hHYlW2he1s9g5iQKD7LRiOw/moZWatSiq6K52ckddAdXKnayN0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729165872; c=relaxed/simple;
	bh=8N3OEu5OoqKc7PPo9W/J+iXedXuNXE+FSfbf5A8TwvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D9V5+0WL5oZv7lVo8W8mXXK9NIaLSFr58hvMvR5PFIcL+OOCijEjhLspNecUFB8HtjIWEPQQwM7pf2L6M2mG6oNveiBhsE4Hi/8vR1R0WpivO5NpZn46B3xxm3PAujJ1YhrR8oWmMRuygahQ5vpEIPecPLYd9kFRm5Jpt5DGfD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=JcJ6vBvc; arc=none smtp.client-ip=185.136.65.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-225.siemens.flowmailer.net with ESMTPSA id 202410171151019825bf7196b33993c4
        for <io-uring@vger.kernel.org>;
        Thu, 17 Oct 2024 13:51:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc:References:In-Reply-To;
 bh=OdKYBXRZ9q61qLOIwiokUTQ4LNVDE3ItPS4tRRh0Knw=;
 b=JcJ6vBvcrtDTL+mqxTm7s7pSe+WScQ5gLFgkqux55va0lcwIII9kV/Bh5+JnnVg0ux76br
 I8mwVMTVOeDLXtopcsdAiMd49KtAumlsZGk/hgfNhJYTx8k7nw8GFuGDzfSKyQPyDZY46WkC
 hHF11Cv9/rl0r1RL//xZEEgwhFpJTy1TqMLtayn/7SuJrjvpwbIzfi6MC+Xni+0F5wi7d6Zn
 x4ySykXGIpCsxvpipTVCGEy1+ctWwe0LVed7+PmlP8Bu7sOBQCeddX9s5TGu2FAFsEZjqDvJ
 JmGxfywmX/PsWs29K/mYOjzDwBQyHvNIsgcyil71evxnib4Y/C3IGixQ==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: stable@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	gregkh@linuxfoundation.org,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 5.10 5.15 3/3] io_uring/sqpoll: do not put cpumask on stack
Date: Thu, 17 Oct 2024 13:50:29 +0200
Message-Id: <20241017115029.178246-3-felix.moessbauer@siemens.com>
In-Reply-To: <20241017115029.178246-1-felix.moessbauer@siemens.com>
References: <20241017115029.178246-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

commit 7f44beadcc11adb98220556d2ddbe9c97aa6d42d upstream.

Putting the cpumask on the stack is deprecated for a long time (since
2d3854a37e8), as these can be big. Given that, change the on-stack
allocation of allowed_mask to be dynamically allocated.

Fixes: f011c9cf04c0 ("io_uring/sqpoll: do not allow pinning outside of cpuset")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Link: https://lore.kernel.org/r/20240916111150.1266191-1-felix.moessbauer@siemens.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a260852a0490c..12aade2ac68ea 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -8747,15 +8747,22 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			return 0;
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
-			struct cpumask allowed_mask;
+			cpumask_var_t allowed_mask;
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
 			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 				goto err_sqpoll;
-			cpuset_cpus_allowed(current, &allowed_mask);
-			if (!cpumask_test_cpu(cpu, &allowed_mask))
+			ret = -ENOMEM;
+			if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
+				goto err_sqpoll;
+			ret = -EINVAL;
+			cpuset_cpus_allowed(current, allowed_mask);
+			if (!cpumask_test_cpu(cpu, allowed_mask)) {
+				free_cpumask_var(allowed_mask);
 				goto err_sqpoll;
+			}
+			free_cpumask_var(allowed_mask);
 			sqd->sq_cpu = cpu;
 		} else {
 			sqd->sq_cpu = -1;
-- 
2.39.5


