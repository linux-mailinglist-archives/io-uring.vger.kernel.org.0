Return-Path: <io-uring+bounces-3200-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A73AC979F2B
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 12:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D630D1C20B42
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 10:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C1AA935;
	Mon, 16 Sep 2024 10:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="gSi1StDn"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-226.siemens.flowmailer.net (mta-65-226.siemens.flowmailer.net [185.136.65.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADE113DB9F
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 10:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726482057; cv=none; b=d4TNEVDAoS+8bfYdCW+eSTF7fAfsrU4wgXRBSoRqIefvQzCJT7HpgDHu8PUUyviXgFLWgKWPYazwPFpvQz+6E9SKrjB782hCu5ZCoaGfoxR/Itum1vhmuYqB+eYnb4Ie7kiWXPZ79LxiIFtYLDKAjPNvuhTaBP0ybJugAkUhZ0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726482057; c=relaxed/simple;
	bh=jyWTd70aUid0L/ibBCDPUmK2+OdlUOj4lVkRmGycrNE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=L8ntEVqy5i8+A5w8qe9/J6tLBMNHIFIoW2WQAktDBjv3hu9tn9f+7xxSvRKozPg9GarMip6/1i9CfoYPGW0YClkBHPfw1VMk5ajEGo33GYaQqskVAr7C9yqgoJxQ4fAQYj5+k7EezCKMrmN9DHFfXgoAY/D28Tz9QX+0fNpLtlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=gSi1StDn; arc=none smtp.client-ip=185.136.65.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-226.siemens.flowmailer.net with ESMTPSA id 202409161020417312f194f29a91ddbc
        for <io-uring@vger.kernel.org>;
        Mon, 16 Sep 2024 12:20:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm2;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=BSl0/QvxZoEgIZ9APQNn+s5fdp/vuFsHN6mIfZo5dHE=;
 b=gSi1StDnDWGSjE1H9MahJHKtJpO3aYGP15MwSFkFR12tJR5VtC10xNtbniU79EniSWpIzz
 z7sxDk8UmjNe393gsKroOqg77o3XoLAHBgqlGLMxokO+S//LAuMYjAvMDkQsF0sn+mwNDqkg
 OaAgQrWSx7votf7pTK8P+exlgT45qFiPTHQIb9tU5G7+rWmuoJDV0iRk6BlCe7OEpt5pMFqU
 X862jzW5mKtc1jt3gujPiJijOJd8pvAHRP7ohjaX1JVvLWJkETuQ31+B901Y4kDEBNcsLy2Z
 Edx46HlyRxdW4ekMECC4ipB4ien/2d3vvtCY8dFkOMuZ3F4HtndFxXEQ==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 1/1] io_uring/sqpoll: do not put cpumask on stack
Date: Mon, 16 Sep 2024 12:20:29 +0200
Message-Id: <20240916102029.1252958-1-felix.moessbauer@siemens.com>
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
2d3854a37e8), as the masks can be big. Given that, we port-over the
stack allocated mask to the cpumask allocation api.

Fixes: f011c9cf04c0 ("io_uring/sqpoll: do not allow pinning outside of cpuset")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
 io_uring/sqpoll.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 7adfcf6818ff..004740d6577e 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -461,15 +461,22 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 			return 0;
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
-			struct cpumask allowed_mask;
+			cpumask_var_t allowed_mask;
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
+			if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL)) {
+				ret = -ENOMEM;
+				goto err_sqpoll;
+			}
 			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 				goto err_sqpoll;
-			cpuset_cpus_allowed(current, &allowed_mask);
-			if (!cpumask_test_cpu(cpu, &allowed_mask))
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
2.39.2


