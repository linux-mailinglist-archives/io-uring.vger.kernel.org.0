Return-Path: <io-uring+bounces-3065-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3523696F5F7
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 15:55:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D45521F245F8
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 13:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5C51CF5ED;
	Fri,  6 Sep 2024 13:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="Ijr6whoC"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-228.siemens.flowmailer.net (mta-65-228.siemens.flowmailer.net [185.136.65.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B311C86F2
	for <io-uring@vger.kernel.org>; Fri,  6 Sep 2024 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630902; cv=none; b=K+mRQEJpeVo2W1zW8cnf9rqNaPihmbuejgciXP9dGvBTOW4UpnPiyH8/8tohcPEJBLIj2htaIMlAEw/5g4qHzM10USrzOVx3Lx8eqo5zMAf/nWLBc1QtAAUgcY1/NUX6xILUB1tFC2ioyraLJol2g1x78eqKU8nH3MO9GeaE0jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630902; c=relaxed/simple;
	bh=xs4PM9vkPSMYbTYGO+9bC9fPgWgnXTJnnUe/1utVaUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XhWhtALPRMDcE83m7udhJHe+Ja5Tz6vsLs/ARds9z5FxKzIHYPOzArX/UzYaZvntJkL0Nvd+v9AXpW1Rcpp1msmS9FSTTNzCwMmRLECz7G367Vu3HnRMRgqceMs88ZELxBtKvUtjvu/xnCgcr07VDcJB0XGMaK6r4Ml3paAV2Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=Ijr6whoC; arc=none smtp.client-ip=185.136.65.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-228.siemens.flowmailer.net with ESMTPSA id 2024090613444582c1367185f93f261c
        for <io-uring@vger.kernel.org>;
        Fri, 06 Sep 2024 15:44:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=BbquwJ4rJZoL/N4IYBuwdhGe1dp/yVc4+3fJ/LgtoaI=;
 b=Ijr6whoC0shvNVFPpfYZ9jo71J6ULVMe6KHeqU8dW0ZTVJ2taRQ+YF4Uj2z5fwjBBAw6td
 PL3iu1kvl+hWj5tbRaDwHMsW+pZWy4H6E394AiPM3kQb5WEIAyqZX6WMQ9MfxpWPCuiZARwN
 tlYphoMrr2bsHV/tjZt2HhwFfT3H2qSamjg+GZ+V3FpaOiQ7OYKdCO2LusidLU6mO/kbKHsF
 cHi3oAQScvL7acoQEh4RjCO34D2kzyC+rBn03vAKiP+O03SuOfT6zRk4A0AEbKjM9DpwureI
 UZdNsYVb82ZlhPi7tXNLIgPtOlk8wxBsQ4TqzoWHaSA3oPzTzIUlvZ3w==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	cgroups@vger.kernel.org,
	dqminh@cloudflare.com,
	longman@redhat.com,
	adriaan.schmidt@siemens.com,
	florian.bezdeka@siemens.com,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/1] io_uring/sqpoll: inherit cpumask of creating process
Date: Fri,  6 Sep 2024 15:44:33 +0200
Message-Id: <20240906134433.433083-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

The submit queue polling threads are "kernel" threads that are started
from the userland. In case the userland task is part of a cgroup with
the cpuset controller enabled, the poller should also stay within that
cpuset. This also holds, as the poller belongs to the same cgroup as
the task that started it.

With the current implementation, a process can "break out" of the
defined cpuset by creating sq pollers consuming CPU time on other CPUs,
which is especially problematic for realtime applications.

Part of this problem was fixed in a5fc1441 by dropping the
PF_NO_SETAFFINITY flag, but this only becomes effective after the first
modification of the cpuset (i.e. the pollers cpuset is correct after the
first update of the enclosing cgroups cpuset).

By inheriting the cpuset of the creating tasks, we ensure that the
poller is created with a cpumask that is a subset of the cgroups mask.
Inheriting the creators cpumask is reasonable, as other userland tasks
also inherit the mask.

Fixes: 37d1e2e3642e ("io_uring: move SQPOLL thread io-wq forked worker")
Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
 io_uring/sqpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 3b50dc9586d1..4681b2c41a96 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -289,7 +289,7 @@ static int io_sq_thread(void *data)
 	if (sqd->sq_cpu != -1) {
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
 	} else {
-		set_cpus_allowed_ptr(current, cpu_online_mask);
+		set_cpus_allowed_ptr(current, sqd->thread->cpus_ptr);
 		sqd->sq_cpu = raw_smp_processor_id();
 	}
 
-- 
2.39.2


