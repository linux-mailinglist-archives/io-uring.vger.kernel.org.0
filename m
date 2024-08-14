Return-Path: <io-uring+bounces-2761-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 837D795177C
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 11:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24B492832AF
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 09:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98475148305;
	Wed, 14 Aug 2024 09:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QLh8R+K+"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB5D13A418
	for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 09:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723627016; cv=none; b=IR6WfpvFQ2/aal+xjZF9rEi+eVwOj07qCur9dAWwVYHbBGfE7C/aUNNWtd4kyUyIwTc/D6FoN3hssv3CPQcvGd3BQhbYhCd+TY6rvn2Quc43Ubr7kF1L9JrBANspkziYskV5sNl2O2t23+qEz4O7Wk4g7ANshZzMKH+cWTjwLLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723627016; c=relaxed/simple;
	bh=Doh6wkff6pjesrno2q6cFCz5DJ8Ez9ZQU9maNAW0u3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=hTTLuACz7TktBA6fyaA9qQQ7+WF8M9PDHboPfv56y2nZNUecLB/h0QLd6EpuTV0dt97//T9H2x380KI08wCCTV/RGwpMoEi1RyvOv8GlBG6h4hynCfX7z5GEF6wJUZE6wceUF/Q7zRT1YVhEbuZAMaX/kFMrNRelAW0MJnPRR6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QLh8R+K+; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240814091650epoutp042cf19101decc7c7c67da933d0c070b0c~rjaJTb2m01721917219epoutp04a
	for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 09:16:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240814091650epoutp042cf19101decc7c7c67da933d0c070b0c~rjaJTb2m01721917219epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1723627010;
	bh=HEjYo58jAIAL6vDabyrsfrMSSkWTYcx4zeUJIL/UZaw=;
	h=From:To:Cc:Subject:Date:References:From;
	b=QLh8R+K+m75G4ySWAQoGDZ6zcr/+jdJyRo9VoxJrAZrAzSYMEHkWUk4wDKUhg37zZ
	 fQZpq821lh4+1S6FsQ8Qr7R03C+1QA8eSXzbtbqwFN/5oNod0ZAWnYl9pzXmzuq2/w
	 QDB45nZagjhNHTYWz0NpNbA35EYsqtU+rclB+p4c=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240814091650epcas5p4d9ccc58f7f8ccb8dd893b9ca516da2a6~rjaI9e4OD2252922529epcas5p4h;
	Wed, 14 Aug 2024 09:16:50 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WkN1F0tBkz4x9Pt; Wed, 14 Aug
	2024 09:16:49 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6C.E4.19863.0067CB66; Wed, 14 Aug 2024 18:16:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240814091610epcas5p36e83248f7f1be4171549abf6a8c037ee~rjZjcDTB10427804278epcas5p3c;
	Wed, 14 Aug 2024 09:16:10 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240814091610epsmtrp22a38e9cec9b3c2b06c71587f1492b146~rjZjbRPC10641006410epsmtrp2l;
	Wed, 14 Aug 2024 09:16:10 +0000 (GMT)
X-AuditID: b6c32a50-c73ff70000004d97-fc-66bc7600936a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	96.08.08964.9D57CB66; Wed, 14 Aug 2024 18:16:09 +0900 (KST)
Received: from dev.. (unknown [109.105.118.18]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240814091608epsmtip185afafdb548caa8e961bc22e8996add3~rjZiNZD3Q3127531275epsmtip1C;
	Wed, 14 Aug 2024 09:16:08 +0000 (GMT)
From: Ruyi Zhang <ruyi.zhang@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, peiwei.li@samsung.com, ruyi.zhang@samsung.com
Subject: [PATCH] io_uring/fdinfo: add timeout_list to fdinfo
Date: Wed, 14 Aug 2024 09:15:49 +0000
Message-ID: <20240814091549.2085-1-ruyi.zhang@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZdlhTQ5exbE+awcFiizmrtjFarL7bz2bx
	rvUci8Wv7ruMFpd3zWGzeLaX0+LL4e/sFmcnfGB14PDYOesuu8fls6UefVtWMXp83iQXwBKV
	bZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdIOSQlli
	TilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITvj
	2IE77AUfxCrmrfVsYDwp1MXIySEhYCKx++5l5i5GLg4hgT2MEhP7m1ghnE+MEtOebmaHcL4x
	SlyZ3MAI09L47CEjRGIvo8T1JY9YIJwnjBLfzh9gBqliE9CUuDwTokNEQFhif0crWBGzQDOj
	xJczr9hBEsICNhJTzqxgBbFZBFQlpl2dBdbMK2Alsf/5eiaIdfISi3csh4oLSpyc+YQFxGYG
	ijdvnQ12uYTAKXaJOa9vMkM0uEgc+bKQHcIWlnh1fAuULSXx+d1eti5GDiC7WOJhXz5EuIFR
	YtvvOgjbWuLflT0sICXMQA+s36UPEZaVmHpqHRPEWj6J3t9PoE7jldgxD8ZWkXi/4h0TzKb1
	rbuhbA+JtS8/MYGMFBKIlZi3o3ICo/wsJM/MQvLMLITFCxiZVzFKpRYU56anJpsWGOrmpZbD
	IzY5P3cTIzgpagXsYFy94a/eIUYmDsZDjBIczEoivIEmu9KEeFMSK6tSi/Lji0pzUosPMZoC
	g3gis5Rocj4wLeeVxBuaWBqYmJmZmVgamxkqifO+bp2bIiSQnliSmp2aWpBaBNPHxMEp1cBk
	yHwv/Lr0tgd5FgK9arNZq4Qtlyyc/e605/ld007uNN9/aJa2vN2mxEOm0mbvuXv2tW5beizs
	UAFLxdZ7Wf/kp3ZvOdYWohxfm75ZhftS3Un+Wcu3fDJfcO+Akl9DwLO3FUXybieetck8erir
	MSFwy6Ll+ox3CgScFD9xaS84OI31+6vA3XsP/08sDNPJ5IidZlvIeedA1lSz4xbrDosciX/z
	3lPXVXayIO+O4+sc/FP9Gt4qBOsfFazJ2XVbblvSYsOjz9Q1jmdmPSxIuXx4n0R6x6ECP0vB
	nS56L3T1Ajy1r65VXmqutee2Q8IVt4ruzlsJL8/cO267pij7PX9paKBmRffuuT6ML/l8Hd8o
	sRRnJBpqMRcVJwIAWemYmRMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsWy7bCSnO7N0j1pBm1zbCzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLZXk6LL4e/s1ucnfCB1YHDY+esu+wel8+WevRtWcXo8XmTXABL
	FJdNSmpOZllqkb5dAlfGsQN32As+iFXMW+vZwHhSqIuRk0NCwESi8dlDxi5GLg4hgd2MErf/
	b2GDSEhJ3Gw6xgRhC0us/PecHaLoEaNE94UPYAk2AU2JyzMbGEFsEaCi/R2tLCBFzAKdjBJt
	J+eygySEBWwkppxZwQpiswioSky7OosZxOYVsJLY/3w91AZ5icU7lkPFBSVOznzCAmIzA8Wb
	t85mnsDINwtJahaS1AJGplWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMEhqqW5g3H7
	qg96hxiZOBgPMUpwMCuJ8Aaa7EoT4k1JrKxKLcqPLyrNSS0+xCjNwaIkziv+ojdFSCA9sSQ1
	OzW1ILUIJsvEwSnVwJTR0LePWU5SbKaXS66kQ1iG2uoDjdFJhw+wrJhpd5l//at/66O99p4y
	sVu47Mp9xubPv+fc9mt/9zrzVkHg24p9n+IjtPY2q6QesFuiFvFM7mWmq8MHCZ60LXWzOXSe
	rriaWsZb6zpBQjcgTM3z04cUqQ3fT358KHhpoZ3nnnO74lctyZj6VGPTyQPeT0/OkDmSZ1P8
	w/LVp9s1Hxp0vrFwKi9nFFPeZFKuNsWhmE/Pf9HimX9CDnaFTvt3cEXlu70VpxO9H0aIT1Cb
	c0i8MdzWJKHEunbFpsCZIvtEqpbfKnbYZPf//gubkH83WJR+nPx+UYB9ywT9ecm5n5NP1p3b
	v2hK5YxDMyJsRB7s/HlTiaU4I9FQi7moOBEA34Q/HcACAAA=
X-CMS-MailID: 20240814091610epcas5p36e83248f7f1be4171549abf6a8c037ee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240814091610epcas5p36e83248f7f1be4171549abf6a8c037ee
References: <CGME20240814091610epcas5p36e83248f7f1be4171549abf6a8c037ee@epcas5p3.samsung.com>

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
index d43e1b5fcb36..f3295ec8cb8c 100644
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
@@ -235,5 +237,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
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
+
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


