Return-Path: <io-uring+bounces-3204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE02997A011
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 13:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C0D31C21B97
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 11:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A4F14B94C;
	Mon, 16 Sep 2024 11:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="Rwmv12XB"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-226.siemens.flowmailer.net (mta-65-226.siemens.flowmailer.net [185.136.65.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03F01547E8
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 11:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726485126; cv=none; b=FNa+g0VS7mYwKHekRKCzmgVHaWdPqjEkaIwWuKL3Ynarhx/jT3G24pep1pHHiKG0480yo7grYVDctYGn9lueXjMp+on0/zshfUidMHo3lQnqO4ySK81NoN4RL6VzfDcKTsZS7CSIpFZpmDUrIq4ZbkR5/uyGhmAqSZTtPH23J0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726485126; c=relaxed/simple;
	bh=WJW8cWljL5SXL9NmSJQZs7RIFxzYv7xtsUltQ4PLqgw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=to/85di3KmH4MpwLqQK1hIiBEga8ou8djk6fTAuSTJKWR3SBGK3RgYRZOrDKUdCM+alIy6AJyk3mk0Q97u6v/dYara41QmeDB8Xdj/x5u002HCSAnvI01AYnK5ZJqzGujf18/wsVV45BtdYgXFVvvulxMumRNqW2ho9AUVJxtGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=Rwmv12XB; arc=none smtp.client-ip=185.136.65.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-226.siemens.flowmailer.net with ESMTPSA id 202409161111566c59251840fe503267
        for <io-uring@vger.kernel.org>;
        Mon, 16 Sep 2024 13:11:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm2;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=GSkjVtv5de9VGr/iaxLd2IImKJowVOPc3pN/8Mu1drg=;
 b=Rwmv12XByRQYZ+3owmWNe20BPLtVH4E2xzs6zlogbdTxL8Z1X9coRBTaaOjZXSc7mfb8iI
 mpBLNDAE9k80WDuvrf84PsMMqKDU4WJE0h7LOMKTVaY+FmmAF7KWK6B7EFG3CxokGTdu0R1q
 SGLu+gjpTLJlkj+UbyVjYigGgpNFBoBvRnb/f9pTZtPzmtvKqxMn/y7if/B+KmWAt7tMpBOR
 CrHrvfBELrw8Ei6Nhp5mebUjWWw4m7kyDEQAI8Qs84NahRk6RhSe9bC2yiHMS8OR5cjLo/or
 fawZeEZaO8wcMXqOHT6oLjCC20Ze44VhrWqJTxuLoKrVkK4yaA916A4Q==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH v3 1/1] io_uring/sqpoll: do not put cpumask on stack
Date: Mon, 16 Sep 2024 13:11:50 +0200
Message-Id: <20240916111150.1266191-1-felix.moessbauer@siemens.com>
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
2d3854a37e8), as these can be big. Given that, change the on-stack
allocation of allowed_mask to be dynamically allocated.

Fixes: f011c9cf04c0 ("io_uring/sqpoll: do not allow pinning outside of cpuset")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
Changes since v2:

- reworded commit message
- make error checking consisten with pattern used in kernel
  @Jens: Thanks for guiding me and helping me to get this right.
  Much appreciated.

Changes since v1:

- don't leak mask in case CPU is not online or too big

Best regards,
Felix

 io_uring/sqpoll.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 7adfcf6818ff..7c79685baeb1 100644
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
+			ret = -ENOMEM;
+			if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
 				goto err_sqpoll;
+			ret = -EINVAL;
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


