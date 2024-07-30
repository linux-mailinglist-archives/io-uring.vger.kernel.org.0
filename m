Return-Path: <io-uring+bounces-2617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A79EC9422B6
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 00:23:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C332D1C20C50
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 22:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D7CE18DF91;
	Tue, 30 Jul 2024 22:23:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232CF157466
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 22:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378187; cv=none; b=mr0YbORLR3Ji5YPc0jvvhqNJ1/ydogdQxnTIOINILXijTXLS3fzY6CO72rhOl5Kh0k9nA/OeQPvquPny69Be9PjRAUT03Dyld+6ivQuIlJK1ScXDQ9X7B6Xx86gakHygp6GRHUJWELWG3LQvpehhMCoLz7zEDO1Y28X8a7QNbTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378187; c=relaxed/simple;
	bh=VmjmRux400huloOvaT0c5eti6+nwiMN9lO0oj+w6oNc=;
	h=From:Message-ID:In-Reply-To:References:To:Date:Subject; b=UMCnBZLqZTUSCgW/fbg6AZ4F7cZLJP7zoTj/HwFl0dkCiJOrGiUENhajbYuBARO1I2o+yNnlNsys3ws/fu0YlexCZ3JbZ1KJN73A4/4UeMQ0NBHPkA/XByAUqYDElK3Cd4t7cQK3aidxWI10sApMJItT/r/+cWuO652bgPzSHxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=48302 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sYvFH-0000qv-2s;
	Tue, 30 Jul 2024 18:23:03 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <052ca60b5c49e7439e4b8bd33bfab4a09d36d3d6.1722374371.git.olivier@trillion01.com>
In-Reply-To: <cover.1722374370.git.olivier@trillion01.com>
References: <cover.1722374370.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Tue, 30 Jul 2024 16:56:06 -0400
Subject: [PATCH 1/2] io_uring: micro optimization of __io_sq_thread()
 condition
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

reverse the order of the element evaluation in an if statement.

for many users that are not using iopoll, the iopoll_list will always
evaluate to false after having made a memory access whereas to_submit is
very likely already loaded in a register.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/sqpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index b3722e5275e7..cc4a25136030 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -176,7 +176,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
 		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
 
-	if (!wq_list_empty(&ctx->iopoll_list) || to_submit) {
+	if (to_submit || !wq_list_empty(&ctx->iopoll_list)) {
 		const struct cred *creds = NULL;
 
 		if (ctx->sq_creds != current_cred())
-- 
2.45.2


