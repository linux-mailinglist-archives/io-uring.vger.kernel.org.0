Return-Path: <io-uring+bounces-1641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D4938B2EED
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 05:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 218001F23013
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 03:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1EA763E2;
	Fri, 26 Apr 2024 03:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="kOeL5vCb"
X-Original-To: io-uring@vger.kernel.org
Received: from out203-205-221-236.mail.qq.com (out203-205-221-236.mail.qq.com [203.205.221.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D2617FF;
	Fri, 26 Apr 2024 03:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102192; cv=none; b=TXEmLPjCulBv6x8UcphmKbodjSZfwhCFNtZjIEuTCuGrJQfJWtrkTh+SQ2Vtdi3qsaAVxPZX+tHdBClbcMOgUoYcxuNdFZHH5ZC52k3woqhRBXaF/4esJkex1RbkQMCsbc1pQq76iyYpD4f547tpioO+f3Qm0Mcn/tEg5mjS/Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102192; c=relaxed/simple;
	bh=OvfqhcQfXKS6rGycDA26/7o4eZJGT3gbJHvgOxtGbj4=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=po9NqVHqwx6RrEgj93FanIbBj5RHXquej7ZyHp27BAZd4bzWqIyQwfFsLPwsLLn+613qdJRdAvc4gubMiyBuy2bqDOISTpTT0KVcZQicCB4K4xFYZ+QdxrqRuHTMNw4y1nFBtGoRVLfeoOl8UEuqUjGWcyVOR0P/xwSgSpW4dcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=kOeL5vCb; arc=none smtp.client-ip=203.205.221.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1714101882; bh=YbWm0yuE8+IGfwGx/G8xrzovevOvaafkCSPh5TsqX8s=;
	h=From:To:Cc:Subject:Date;
	b=kOeL5vCbgidmz6Em6RjSrcYx3TCzx/qzhcQozpJt6OCDpmFXLHUOloAmlcop6Sey6
	 0ncTE4GlDGse4t3CUJODjbk2xEVMMn+ZMV4YU7rZ1SeDrloyVzMoR2Oe9/xCDPBEDl
	 knZPTvGed2ySMbbcfRWEUAI1rvYGCZ+UYgickNVU=
Received: from localhost.localdomain ([58.213.8.145])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id 627802A8; Fri, 26 Apr 2024 11:24:39 +0800
X-QQ-mid: xmsmtpt1714101879tocg2lgcy
Message-ID: <tencent_F9B2296C93928D6F68FF0C95C33475C68209@qq.com>
X-QQ-XMAILINFO: MtZ6QPwsmM9Xvp8tJWGGOOumDXDeOWCX4xyOG3f81mbjIoVYvvGJLO4etvNtaL
	 QpfxbOGwyQHutU9GnvR+xL5foYawQOSq1RnD5wFXADm8ajm2Ki8lLw7grr42T1P1cqu+QFSA/Zty
	 mjUm845QLvulRTqkpe7XnjjWP9aWyO5cccJ2Ddg9x0x/v/Zhsv5BLHxKFKItwsDGOeSk8x33F22k
	 xO1pT7EzPAVBcFlPakl9sNJZItErLKhHynJ0HaIXc7mKNXByHHsx3OJHB8ZpmdSSF18bERehKCc+
	 vPkJDqk7Q68fuW16gXDozBUh2UHPOxMAS7QM7te9IyeyW2h7SCsYiYzQFNwv4+wbPXuKD6UzUKZe
	 ItqUqoG0ME6p6yP8OSbYngJpVrTaWJdHBB21tc5PuQkxl3sLFd6M6Qf7X3z637YgfUPjGmNckU3T
	 lnAAR9J5NFnrgva/1Ue5jbv2Gu12dDUl2MVQQx4y8jkdSyJDDdIxneuk8oUxGe9O4ZHKxycv1Sq4
	 vtbI9GvHyD0jYqA66LIE+uRsOTniz6ZqBIusI72G3HWEN2zrLW8qF6OgOjuwaVAKRxVGjh1RsSkm
	 2F51rlWoYLdECwMlrO2vduA7gBrAZQgRVIhDEuXMrBX+yRf14ogb5+wUmcxtGXc7L19KYI6PsfDh
	 UQEqBSulWLD2kX7ttDB9WybeNdywnxnwnzaEhkd4+Ie+ziYTw84/dKUODDSM3oiM/JJxj3zUJJ7A
	 9HN61OLdBg3YlyveEe32oVjzPrr08iJd6W2dmxes4BA4R44sHHSEFtzfmoHH8t4Ol5sP7Q3fo1Eg
	 Ra4/674WGrccJb2uzNmlxoDODiEP9LKmkr19Z2px3v7eemPyKf51kRh7/m1EFiMv78fwoSTp7MP8
	 dJok/9esQukjkWspA1DqtP5lUbihQnTr8qvylrNGDyIj8Lk2zhtIF6PuK8AuwYfU8Xk+PTEYwR+K
	 zgWQyOnGgTCir+PPHQIs84PE7JAjX7LkbUhOomQ88y6BmYL02uavHUyld30P2hP7zxnRoBBTfKf1
	 nivAkd6g==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: linke li <lilinke99@qq.com>
To: 
Cc: xujianhao01@gmail.com,
	linke li <lilinke99@qq.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/msg_ring: reuse ctx->submitter_task read using READ_ONCE instead of re-reading it
Date: Fri, 26 Apr 2024 11:24:37 +0800
X-OQ-MSGID: <20240426032438.11830-1-lilinke99@qq.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In io_msg_exec_remote(), ctx->submitter_task is read using READ_ONCE at
the beginning of the function, checked, and then re-read from
ctx->submitter_task, voiding all guarantees of the checks. Reuse the value
that was read by READ_ONCE to ensure the consistency of the task struct
throughout the function.

Signed-off-by: linke li <lilinke99@qq.com>
---
 io_uring/msg_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index cd6dcf634ba3..d74670b39ed6 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -83,7 +83,7 @@ static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
 		return -EOWNERDEAD;
 
 	init_task_work(&msg->tw, func);
-	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
+	if (task_work_add(task, &msg->tw, TWA_SIGNAL))
 		return -EOWNERDEAD;
 
 	return IOU_ISSUE_SKIP_COMPLETE;
-- 
2.39.3 (Apple Git-146)


