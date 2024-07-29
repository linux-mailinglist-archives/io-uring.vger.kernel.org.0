Return-Path: <io-uring+bounces-2593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 088A09403F8
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 03:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39A921C21F9C
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 01:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 035444683;
	Tue, 30 Jul 2024 01:45:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B93129AF
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 01:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303954; cv=none; b=fz5HpwtA0fV2Jix3gejueAo81VYbDUVPO3bq6z4LnFJ5W2+73soMWmMq1agZk14KRMjJ6t9nwgtSHzXyPSmxg8zH03HFklnsCRRLW3xy9N2egWwd57oJkMoO+LO5W67m6n89pz70hR7v4IVjKERW8eWzkU0nDQXBJVXJAMsmfDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303954; c=relaxed/simple;
	bh=qWJaIHxsU0PUq+AWsEzcutdlGs5V41DzgPJMSbfq9uY=;
	h=From:Message-ID:To:Date:Subject; b=CR6aQv/nhT5OXpnYu4mT30N+UstqiTC1bFZdB9rru3WjAGmGjYvXErEpyw+5WUotVofEi7IP1y/ytTyqaMtQSZ6y4owSkw6hQXWjtuRA7jDdMDhEiitrJ4KHoJZ13VRn7WWixNq6KCdua8LfEEWreqKJUvEfQVt/Po6bZXmOSHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=49762 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sYbvz-000441-1a;
	Mon, 29 Jul 2024 21:45:51 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Mon, 29 Jul 2024 18:38:33 -0400
Subject: [PATCH] io_uring: add napi busy settings to the fdinfo output
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
index b1e0e0d85349..3ba42e136a40 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -221,7 +221,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 			   cqe->user_data, cqe->res, cqe->flags);
 
 	}
-
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
 	spin_unlock(&ctx->completion_lock);
 }
 #endif
-- 
2.45.2


