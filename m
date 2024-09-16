Return-Path: <io-uring+bounces-3202-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F6A8979FCC
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 12:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81B231C21228
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 10:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA80155303;
	Mon, 16 Sep 2024 10:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="WlHJvKZ3"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-227.siemens.flowmailer.net (mta-65-227.siemens.flowmailer.net [185.136.65.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39DC14AA9
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 10:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726484133; cv=none; b=Ec2F2ROpblk2rJ/H5VRYi3tXd0mUGyZMOSNH2WuTjP6qPCAa6ESGpG+RP+nmV5tmU5TuennNssldfA4FmyNKhO/3k+AmZHiftEi6uese3oXsfgxd0ARCdGPpjYRncob4ywqcZEV8GILz2P9sErvz6cEX8sT91KoxiP33ziHL//w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726484133; c=relaxed/simple;
	bh=CCYg0/Uk4gW56XH7U1TdvhS/BJpcfK4bOlOpozm22ZI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q+ry1tHb3nlYOjFWJcADUDq1OmcB+3LzqflJyFWLXjFCMtx/zahLiDyFFNoD5YYjWJYRQ6PXAgVPxcqme2t0inWU9F6egcl67WydUWfudpGRnnkkHwz3zXzIDDRP1zag1XA45N8R4AH+O5Ss4yIBUwg7o6cHvxPogRu+/4wlUVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=WlHJvKZ3; arc=none smtp.client-ip=185.136.65.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-227.siemens.flowmailer.net with ESMTPSA id 2024091610552228d4b0bf5ef7a78d68
        for <io-uring@vger.kernel.org>;
        Mon, 16 Sep 2024 12:55:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm2;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=R/SUc/IHdBroo59dmHywFnBZXxDwf6HMJYKLu7JQhuQ=;
 b=WlHJvKZ3en1MpP8tPshYCSXTIfePFwvHa6MUzxnv5BaleLJMQF8Bs7EKYCrgadTh9vIXBX
 s+4TOPoreeWITYJYK448BdlQEcM0u1NTJIEtmklGDBBvKdOuS4z8v8dkPDxxh35PYEaW20yw
 7ZCB2LADATZzPHNnGc7Pf/SutuvY8VgdSIo4UEjjrHeSeDsp44a7WSPX9eqRMxQcyrlnmU6b
 ZWIwsEdaNb7nP3hvLPETBqQR0B2UmezxJb4WjlbjwxFe0soSih11zkOrJu2QpqL++16HDdh3
 HqBSbZsXk+mLMVNgw9hNlwlu+f9Y4abrLCc1XRphbFRU0lTFiiYA8sVg==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH v2 1/1] io_uring/sqpoll: do not put cpumasks on stack
Date: Mon, 16 Sep 2024 12:55:14 +0200
Message-Id: <20240916105514.1260506-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

Putting the cpumask on the stack is deprecated for a long time (since
2d3854a37e8), as these can be big. Given that, we port-over the stack
allocated mask to the cpumask allocation api.

Fixes: f011c9cf04c0 ("io_uring/sqpoll: do not allow pinning outside of cpuset")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
Changes since v1:

- don't leak mask in case CPU is not online or too big

Best regards,
Felix

 io_uring/sqpoll.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 7adfcf6818ff..44b9f58e11b6 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -461,15 +461,22 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
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
+			if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL)) {
+				ret = -ENOMEM;
 				goto err_sqpoll;
+			}
+			cpuset_cpus_allowed(current, allowed_mask);
+			if (!cpumask_test_cpu(cpu, allowed_mask)) {
+				free_cpumask_var(allowed_mask);
+				goto err_sqpoll;
+			}
+			free_cpumask_var(allowed_mask);
 			sqd->sq_cpu = cpu;
 		} else {
 			sqd->sq_cpu = -1;
-- 
2.39.2


