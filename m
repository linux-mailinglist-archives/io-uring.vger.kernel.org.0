Return-Path: <io-uring+bounces-2606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B06941522
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 17:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5302B21411
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 15:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394861A0B15;
	Tue, 30 Jul 2024 15:08:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE53B1A2553
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722352119; cv=none; b=KteCvBU1LCatBW6/DS6RZIU+0NypY2sAUArde4tk6xfBecyEM8btaEeErIrJgD1KtNM31S73sOkZ/PeO9mtdp9ajYkOiMykV4Jjyb/yrcaAVgykbFKnz880XydYzejY604fO3JKbA5aJ3DuIUWN2GEnZ+3rLAYBAyAvwq13LD4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722352119; c=relaxed/simple;
	bh=Xpndg2e7TTKuc0w53O/3K3iO3zNZ2H/Z39N073Hl4R0=;
	h=From:Message-ID:To:Date:Subject; b=bk04H7G3efpv1/+wR8cKF7euu5dO8DkJY7vndgJyJ5g2095n9WqlFm24Ig5OdrB0iYjvw+N8ajF25By/Tciey+VKCSpzG05MuM441EHS6VBjsqnreO1NOqvg/zR+LUT8y6o67F1o2OGaxjFHrVR0iQ7TMwrkEnU5W56p39m4Qwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=38518 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sYoSo-0000Qj-2w;
	Tue, 30 Jul 2024 11:08:34 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <dad0b2787b8dce4fa99a1c5827cf06ad242a7e4a.1722351660.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Tue, 30 Jul 2024 10:57:23 -0400
Subject: [PATCH v2] io_uring: add napi busy settings to the fdinfo output
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

this info may be useful when attempting to debug a problem
involving a ring using the feature.

Here is an example of the output:
ip-172-31-39-89 /proc/772/fdinfo # cat 14
pos:	0
flags:	02000002
mnt_id:	16
ino:	10243
SqMask:	0xff
SqHead:	633
SqTail:	633
CachedSqHead:	633
CqMask:	0x3fff
CqHead:	430250
CqTail:	430250
CachedCqTail:	430250
SQEs:	0
CQEs:	0
SqThread:	885
SqThreadCpu:	0
SqTotalTime:	52793826
SqWorkTime:	3590465
UserFiles:	0
UserBufs:	0
PollList:
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=6, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=6, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
  op=10, task_works=0
CqOverflowList:
NAPI:	enabled
napi_busy_poll_to:	1
napi_prefer_busy_poll:	true

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/fdinfo.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index b1e0e0d85349..05f5c8572ba4 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -221,7 +221,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 			   cqe->user_data, cqe->res, cqe->flags);
 
 	}
-
 	spin_unlock(&ctx->completion_lock);
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	if (ctx->napi_enabled) {
+		seq_puts(m, "NAPI:\tenabled\n");
+		seq_printf(m, "napi_busy_poll_dt:\t%llu\n", ctx->napi_busy_poll_dt);
+		if (ctx->napi_prefer_busy_poll)
+			seq_puts(m, "napi_prefer_busy_poll:\ttrue\n");
+		else
+			seq_puts(m, "napi_prefer_busy_poll:\tfalse\n");
+	} else {
+		seq_puts(m, "NAPI:\tdisabled\n");
+	}
+#endif
 }
 #endif
-- 
2.45.2


