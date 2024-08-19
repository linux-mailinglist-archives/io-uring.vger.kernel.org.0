Return-Path: <io-uring+bounces-2831-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF739564E5
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 09:47:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 977C01C213AF
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 07:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF6F157A48;
	Mon, 19 Aug 2024 07:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Se4ieLxq"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA3E14B959
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 07:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724053621; cv=none; b=u6FG2BMNlFCBFxfC+QX5MESGm8pE30LeIqDeUEfdwD+aLRa5lzjW/j6HVGtXAzwn/VCFSAmjSPkgKS3zVgqFVqTqLZ80I0+8qIxhtdv9mX9GW15znXStn6pIOCMqdXhageTA/JmSoTVgvX/ox35xTJV2LZEy0P+/g6Tai8Q51o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724053621; c=relaxed/simple;
	bh=wK47MsqCFa27d2aERFh0btpxSPjkr3QYv7hBIOB5qpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=AwIpCiJ/0jN4FHtks/I+7r81WbnwXVp6GtmFdjHYAE1ZZJWB9rhIx2Ko6IU5XgtgZKiA6WqIHrIHaHCMePF9aWHi1tGHU+SgGe0/n9rLuAAncV1EoQBL2mqnunA4HibSmhF2hPzZxj1BqTKngkTUOFq84x1IYWRX1WpF5hopbfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Se4ieLxq; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240819074654epoutp03dac798e987615d5e1a3730dcb4df37ed~tEaDbWxDc0071700717epoutp03g
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 07:46:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240819074654epoutp03dac798e987615d5e1a3730dcb4df37ed~tEaDbWxDc0071700717epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724053614;
	bh=OUaNSPHd4+xzf8o8jo3lM+JfDC4FvaxHFWNa6XiSao8=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Se4ieLxq4vsaQWNmAW3eNkWB8yhrBQ0h0udJ3a/T6hfqFzI7ZaduFVMET/Qm13mkc
	 qotFxIQv76t5STjklNVC2sXzUlg2qHj6caamvRSbwV7M6pVIwjpHOWDV/9mdjCKj0z
	 MuUTVoyxBWkr62M7JiqrPgJWfZwwggh6B47GXSUg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240819074654epcas5p10cc4ae7618c3918dd324ea03b8428b9f~tEaDDr7PK3243832438epcas5p1D;
	Mon, 19 Aug 2024 07:46:54 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WnPn82ZqCz4x9Q2; Mon, 19 Aug
	2024 07:46:52 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	12.F8.19863.C68F2C66; Mon, 19 Aug 2024 16:46:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240819074356epcas5p10e5ac15305513608c788d22fe994167a~tEXdSBXIM2487824878epcas5p1F;
	Mon, 19 Aug 2024 07:43:56 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240819074356epsmtrp236c48e4c78ab4098b1702f5c1f4628ea~tEXdROEpc3005930059epsmtrp2W;
	Mon, 19 Aug 2024 07:43:56 +0000 (GMT)
X-AuditID: b6c32a50-ef5fe70000004d97-4f-66c2f86c39fe
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	81.23.07567.CB7F2C66; Mon, 19 Aug 2024 16:43:56 +0900 (KST)
Received: from dev.. (unknown [109.105.118.18]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240819074354epsmtip2c06a0b1c7b11f1313026963e4ceafbe5~tEXbU6nCL2089420894epsmtip25;
	Mon, 19 Aug 2024 07:43:54 +0000 (GMT)
From: Ruyi Zhang <ruyi.zhang@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	peiwei.li@samsung.com, Ruyi Zhang <ruyi.zhang@samsung.com>
Subject: [PATCH v2] io_uring/fdinfo: add timeout_list to fdinfo
Date: Mon, 19 Aug 2024 07:43:23 +0000
Message-ID: <20240819074323.644650-1-ruyi.zhang@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7bCmlm7Oj0NpBkfn8ljMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8WzvZwWXw5/Z7c4O+EDqwOHx85Zd9k9Lp8t9ejbsorR4/MmuQCW
	qGybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAjlBTK
	EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZ
	GTcuHWMqeCtW8erPPrYGxhNCXYycHBICJhJ7V+1k7mLk4hAS2MMo0fXzDAuE84lR4uaMOWwQ
	zjdGiSs7tzLBtKyY3QnVspdRYsOe94wQzhNGiTvNO1lBqtgENCUuz2xgBLFFBLQlXj+eygJi
	MwtUSKy7/RRoEgeHsIC9xO7zdiAmi4CqxJ2HVSAmr4CNRP9kXohV8hKLdyxnBrF5BQQlTs58
	AjVEXqJ562ywEyQETrFLNKx/xQbR4CJxZ98KRghbWOLV8S3sELaUxOd3e9lA5ksIFEs87MuH
	CDcwSmz7XQdhW0v8u7KHBaSEGej49bv0IcKyElNPrWOCWMsn0fv7CTQUeCV2zIOxVSTer3jH
	BLNpfetuKNtDoudXO9j5QgKxEo+WnmKdwCg/C8k3s5B8Mwth8wJG5lWMUqkFxbnpqcmmBYa6
	eanl8GhNzs/dxAhOiVoBOxhXb/ird4iRiYPxEKMEB7OSCG/3y4NpQrwpiZVVqUX58UWlOanF
	hxhNgSE8kVlKNDkfmJTzSuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1OTS1ILYLpY+Lg
	lGpgSt3+jV1R49a5Z5qfb/w7dqX1vnqmooK4UI/LxHe6p2T6P2VGaSZsvx/YJuiTEBf9bucF
	zkc3euNqdhtIf5q8vtc2Xcq6hXEql8zzqKVH0o78LZZl93q6Y2rQTIP5hinX+VXsTh0Nni3w
	RpdZ/2r6t8UP7suk1s9/+y7tr2KMSuHq7KnyVc1BG/Tt9F7tTmLany3o2VCgo6MUmPj+22b9
	1LMsn4VNbu9btVIyaNmlE9vXdW1qXrJP73Vh1yRNych/M7a71D+5verHKZen+pXM5zeW7Vh9
	Ta59YqrPp+Ozj83jP7px0y2uuknmN9mu829u+hCdxOX2t8e/e8pfQf+8e//eNHeKrn22p31t
	836hN0osxRmJhlrMRcWJAAo2flMSBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWy7bCSvO6e74fSDBovilrMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8WzvZwWXw5/Z7c4O+EDqwOHx85Zd9k9Lp8t9ejbsorR4/MmuQCW
	KC6blNSczLLUIn27BK6MG5eOMRW8Fat49WcfWwPjCaEuRk4OCQETiRWzO5m7GLk4hAR2M0rs
	etvACJGQkrjZdIwJwhaWWPnvOTuILSTwiFFiUkMYiM0moClxeSZIPQeHiICuRONdBZAws0CN
	RNfVCUwgYWEBe4nd5+1ATBYBVYk7D6tATF4BG4n+ybwQs+UlFu9Yzgxi8woISpyc+YQFYoi8
	RPPW2cwTGPlmIUnNQpJawMi0ilEytaA4Nz032bDAMC+1XK84Mbe4NC9dLzk/dxMjODC1NHYw
	3pv/T+8QIxMH4yFGCQ5mJRHe7pcH04R4UxIrq1KL8uOLSnNSiw8xSnOwKInzGs6YnSIkkJ5Y
	kpqdmlqQWgSTZeLglGpg0ujXPHnUZ9n11OXVl/t38zmYrNOamdleYMpRrrf8u5XdbpMVVzzP
	1E6Sl+iWFAiWXlryYA6Xr5a5yNyyWTqK/45P3uAfYap4ZlnmW3Zm9l3GU//WR091M9jkO8no
	g6SNHuPnb8f+zqpwzteKs10ste/bS4c1PSadfp/59tmkeDusn9tQeNYw7VSUyNTLqw/6CXHG
	yKvpfPktL1GXNcG25e9f6ePTX035bv5qqTOr5y/nXxc5n/CElltUsYnvMuzm3PVnxfMLk/7f
	L435HGVbOXGnoUX6zm4t64a557mNkovFHMOC34X+vCMtsivqa5jMCenUnpncd0OPKqlz1GmW
	u35e6jibzf/EdZ5LkfuVWIozEg21mIuKEwEyT5iRuwIAAA==
X-CMS-MailID: 20240819074356epcas5p10e5ac15305513608c788d22fe994167a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240819074356epcas5p10e5ac15305513608c788d22fe994167a
References: <CGME20240819074356epcas5p10e5ac15305513608c788d22fe994167a@epcas5p1.samsung.com>

io_uring fdinfo contains most of the runtime information,which is
helpful for debugging io_uring applications; However, there is
currently a lack of timeout-related information, and this patch adds
timeout_list information.

Signed-off-by: Ruyi Zhang <ruyi.zhang@samsung.com>
---
 io_uring/fdinfo.c  | 14 ++++++++++++++
 io_uring/timeout.c | 12 ------------
 io_uring/timeout.h | 12 ++++++++++++
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index d43e1b5fcb36..f524c3cd6f57 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -14,6 +14,7 @@
 #include "fdinfo.h"
 #include "cancel.h"
 #include "rsrc.h"
+#include "timeout.h"
 
 #ifdef CONFIG_PROC_FS
 static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
@@ -55,6 +56,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	struct io_ring_ctx *ctx = file->private_data;
 	struct io_overflow_cqe *ocqe;
 	struct io_rings *r = ctx->rings;
+	struct io_timeout *timeout;
 	struct rusage sq_usage;
 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
 	unsigned int sq_head = READ_ONCE(r->sq.head);
@@ -235,5 +237,17 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		seq_puts(m, "NAPI:\tdisabled\n");
 	}
 #endif
+
+	seq_puts(m, "TimeoutList:\n");
+	spin_lock_irq(&ctx->timeout_lock);
+	list_for_each_entry(timeout, &ctx->timeout_list, list) {
+		struct io_timeout_data *data;
+
+		data = cmd_to_io_kiocb(timeout)->async_data;
+		seq_printf(m, "  off=%u, repeats=%u, sec=%lld, nsec=%ld\n",
+			   timeout->off, timeout->repeats, data->ts.tv_sec,
+			   data->ts.tv_nsec);
+	}
+	spin_unlock_irq(&ctx->timeout_lock);
 }
 #endif
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 9973876d91b0..4449e139e371 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -13,18 +13,6 @@
 #include "cancel.h"
 #include "timeout.h"
 
-struct io_timeout {
-	struct file			*file;
-	u32				off;
-	u32				target_seq;
-	u32				repeats;
-	struct list_head		list;
-	/* head of the link, used by linked timeouts only */
-	struct io_kiocb			*head;
-	/* for linked completions */
-	struct io_kiocb			*prev;
-};
-
 struct io_timeout_rem {
 	struct file			*file;
 	u64				addr;
diff --git a/io_uring/timeout.h b/io_uring/timeout.h
index a6939f18313e..befd489a6286 100644
--- a/io_uring/timeout.h
+++ b/io_uring/timeout.h
@@ -1,5 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0
 
+struct io_timeout {
+	struct file			*file;
+	u32				off;
+	u32				target_seq;
+	u32				repeats;
+	struct list_head		list;
+	/* head of the link, used by linked timeouts only */
+	struct io_kiocb			*head;
+	/* for linked completions */
+	struct io_kiocb			*prev;
+};
+
 struct io_timeout_data {
 	struct io_kiocb			*req;
 	struct hrtimer			timer;
-- 
2.43.0


