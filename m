Return-Path: <io-uring+bounces-3125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E8462973E4F
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 19:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82199B28708
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 17:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6041A08C4;
	Tue, 10 Sep 2024 17:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="er0O3DvQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-226.siemens.flowmailer.net (mta-65-226.siemens.flowmailer.net [185.136.65.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52D81A2561
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 17:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725988337; cv=none; b=Rc+XlrgkaJp1A7fmFR7M6b/r56c0Mx+kQ2ScOE44pv9sRwCMUEObje7lxr9kKSXxXPKZTpycJdcU2Vwx2aDER0Z8Fb1MgVt+Zs6hFO6oPc+X+dq4/3r+v7kpadQx1e9OxZKYOMm3eJYFqcL8mxRs2gbb3k40KKnGFvrnPjEeUIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725988337; c=relaxed/simple;
	bh=XfiVCwa2jWEk1M2MkT7rHET2smIjIcH+WkT+Wy9VZlY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JK/6v0bk11JUnQK9jsFI4zHNd4FNSYrnXLjNrR6NkilZzdpsJu9Em0st0TkLpPE7DcV2Z1WfxHpwOYA68RB9LrpaLGgF0O8YwYj4jBVjaaencEyT3vYMxqtdIB+zXsIiZi1jGk4WLxWZGlala8FGchyFHN8ysM3zxQc3Q4UqGzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=er0O3DvQ; arc=none smtp.client-ip=185.136.65.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-226.siemens.flowmailer.net with ESMTPSA id 202409101712124eea10c79bf4bb98f6
        for <io-uring@vger.kernel.org>;
        Tue, 10 Sep 2024 19:12:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc:References:In-Reply-To;
 bh=Pv5z/hfaIXxpRwvFKBnqkGUSEgP+MIm2v5ejiY+wuV0=;
 b=er0O3DvQoehyWvkqyQ1xbrVevAtDnVoznkYDFYvhl29uXMiAJfGdgNeZYuYQgiBB88y9vQ
 jjp1UxfnFoCEf7qy1NMwaMJXoBI+HfIgRbWyikNuXQUH9jxS7irXL2VTuDYOsxidD1C3XSjp
 PkZEOHNxgqw36VqxNOjfj1iexLt8cnjSsTufBsLv3mRIc8On16m59DYGJ+GqCrlU55OPXydZ
 clKLEq+FH+0VOOmLK7BZ1jggR0ob0PQEkTe10Fhs3tZwde4F6nPoFZRraF36JBavnrszB+wQ
 ajpmsI0lusOFko7dKPk5L/cn7+tJxRmlVE2GnsRHyxL8+qm5KtBIIrvA==;
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
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH v3 2/2] io_uring/io-wq: inherit cpuset of cgroup in io worker
Date: Tue, 10 Sep 2024 19:11:57 +0200
Message-Id: <20240910171157.166423-3-felix.moessbauer@siemens.com>
In-Reply-To: <20240910171157.166423-1-felix.moessbauer@siemens.com>
References: <20240910171157.166423-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

The io worker threads are userland threads that just never exit to the
userland. By that, they are also assigned to a cgroup (the group of the
creating task).

When creating a new io worker, this worker should inherit the cpuset
of the cgroup.

Fixes: da64d6db3bd3 ("io_uring: One wqe per wq")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
 io_uring/io-wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index c7055a8895d7..a38f36b68060 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1168,7 +1168,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	if (!alloc_cpumask_var(&wq->cpu_mask, GFP_KERNEL))
 		goto err;
-	cpumask_copy(wq->cpu_mask, cpu_possible_mask);
+	cpuset_cpus_allowed(data->task, wq->cpu_mask);
 	wq->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 	wq->acct[IO_WQ_ACCT_UNBOUND].max_workers =
 				task_rlimit(current, RLIMIT_NPROC);
-- 
2.39.2


