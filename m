Return-Path: <io-uring+bounces-2700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAC8994E49B
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 04:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89D8D281C26
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 02:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C84C7404E;
	Mon, 12 Aug 2024 02:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kZuV2Ji0"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3C24D8D1
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 02:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723428214; cv=none; b=qsQFErMeDpZ92fGHxOfPCtVpdGRpASSr+WHRJhgIbmeLdsSA4Z/Ek/y0IlKLCIBLyJlRqZ8bDmvUKoEBHwicpCbH0xmMENWNNVE5K7kjJvxNI0p0LmiTsoOCvAjpzQB5CDfNedVolod5CNETmPO3zrVTzd8feZxsq+JVMtlz7Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723428214; c=relaxed/simple;
	bh=gzENJ0dQXjSWK0FWn3jiefTLZtVAMIY+wX5WCI8SApI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=ZzOoH3mTc2BA+AvrBzJgKD2IObNGb6eNa+8/+g/wlVPn7VBJ02F+DTdyA7XJvsOflQJMy3lO+lSAovY67lghOmtC8iPh+zZZs4y3RJHGcexZiHH3yq4ONc/iI5B9k8Cvqrb5z3evLu5EoJE203+zvUceYT9vWCjhKfVn472q+dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kZuV2Ji0; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240812020329epoutp02580f5c2b10ec760ad3a51541b4599297~q2NNGduTn1298012980epoutp02d
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 02:03:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240812020329epoutp02580f5c2b10ec760ad3a51541b4599297~q2NNGduTn1298012980epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1723428209;
	bh=lj8I5YKR1TrGVdtwcge9p6tZoG7mhhk0ncplt2OJ2Ls=;
	h=From:To:Cc:Subject:Date:References:From;
	b=kZuV2Ji0rKw1/O+TvEUEv+AJcHtMHN9KgpmZ+EstCkL/+Wunv4W8zD1KBqhLvWVkU
	 +A+fje1WCijWfuAVypjG5DpuSbGk/FzUBqDCUa192YhGLIeaymLvPSksoRQ5kaJD9p
	 G2W/BnIE14ufiEGUDx+otinOxLxS3LwtBPdopYY8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240812020328epcas5p2597cb14dc89844b7b1a26a14468896c0~q2NMsxlwx0980209802epcas5p2Z;
	Mon, 12 Aug 2024 02:03:28 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WhyV75Gvnz4x9QC; Mon, 12 Aug
	2024 02:03:27 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C0.B6.08855.F6D69B66; Mon, 12 Aug 2024 11:03:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240812020140epcas5p3431842ed5508ffb5ae9f1d1812cae4d5~q2LoGNsh22355823558epcas5p3I;
	Mon, 12 Aug 2024 02:01:40 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240812020140epsmtrp2402dbde90fa339be95342955b039daec~q2LoFN70O3237932379epsmtrp2-;
	Mon, 12 Aug 2024 02:01:40 +0000 (GMT)
X-AuditID: b6c32a44-15fb870000002297-9c-66b96d6f0bde
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	10.4A.07567.40D69B66; Mon, 12 Aug 2024 11:01:40 +0900 (KST)
Received: from dev.. (unknown [109.105.118.18]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240812020139epsmtip29bca888632856d039203d0d77bde7989~q2Lm7UxQf0976209762epsmtip2X;
	Mon, 12 Aug 2024 02:01:39 +0000 (GMT)
From: Ruyi Zhang <ruyi.zhang@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, peiwei.li@samsung.com, Ruyi Zhang
	<ruyi.zhang@samsung.com>
Subject: [PATCH] io_uring/fdinfo: add timeout_list to fdinfo
Date: Mon, 12 Aug 2024 02:00:51 +0000
Message-ID: <20240812020052.8763-1-ruyi.zhang@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdlhTXTc/d2eawcMbShZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZvFsL6fFl8Pf2S3OTvjA6sDhsXPWXXaPy2dLPfq2rGL0+LxJLoAl
	KtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gIJYWy
	xJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BSYFecWJucWleul5eaomVoYGBkSlQYUJ2
	RtOBiywFb8QrZi3tZmpgXCvcxcjJISFgItHSupSli5GLQ0hgN6PErNnf2CCcT4wSTZuOMkI4
	3xgl/v2eyN7FyAHWsuFoCER8L6NE98VZ7BDOE0aJG39mM4HMZRPQlLg8s4ERxBYREJbY39EK
	toNZYBKjxMJla1lAEsICNhJTzqxgBbFZBFQlnjQ8A2vmFbCSaOibzQpxoLzE4h3LmSHighIn
	Zz4B62UGijdvnc0MMlRC4BS7xK8/Z9ggGlwkNi7shGoWlnh1fAs7hC0l8fndXjaIF4olHvbl
	Q4QbGCW2/a6DsK0l/l3ZwwJSwgz0wPpd+hBhWYmpp9YxQazlk+j9/YQJIs4rsWMejK0i8X7F
	OyaYTetbd0PZHhJvvjwFu0ZIIFbi6r5NbBMY5Wch+WYWkm9mIWxewMi8ilEytaA4Nz012bTA
	MC+1HB6xyfm5mxjBaVHLZQfjjfn/9A4xMnEwHmKU4GBWEuFtDt+UJsSbklhZlVqUH19UmpNa
	fIjRFBjEE5mlRJPzgYk5ryTe0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYO
	TqkGprCldk9ef8rbfUKVvSb+/PrJ6vyS3pOjvVVneYbKLLnt8Z6xWOqEj+trA9U+u9qMx4m3
	td8dUfYVEFU6d+WuxZnAWK4i+6vMEyZo8ZuUlFT3/rzl+id9jzT7Mv9d95cxFT9p41r/dMX7
	SV1OsmZSc/W1Nl9XOx22dunzriCOrMrJC+Rz/8z3PHNAyP294tV0C4tD7lM/fZ4uavF14/eQ
	GwmPWpcxXzsYI7W/29duc8Sl3a9qE9J/B6k4V6ZVv/13ekc24w4hgSaNT9GecjVLVLiuXWPZ
	cuvAz6zrCm9/n1hZUnKPs+rz33XLgy4VP9qjsK45dsrKV226eqsnO5lkeLD7pycUT6myaXF9
	xcbPqMRSnJFoqMVcVJwIACPy8NsUBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsWy7bCSvC5L7s40g60XDCzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLZXk6LL4e/s1ucnfCB1YHDY+esu+wel8+WevRtWcXo8XmTXABL
	FJdNSmpOZllqkb5dAldG04GLLAVvxCtmLe1mamBcK9zFyMEhIWAiseFoCIgpJLCbUeIdcxcj
	J1BUSuJm0zEmCFtYYuW/5+xdjFxAJY8YJR63XAArYhPQlLg8s4ERxBYBKtrf0coCUsQsMI1R
	YlPTE7AiYQEbiSlnVrCC2CwCqhJPGp6BTeUVsJJo6JvNCrFBXmLxjuXMEHFBiZMzn7CA2MxA
	8eats5knMPLNQpKahSS1gJFpFaNkakFxbnpusmGBYV5quV5xYm5xaV66XnJ+7iZGcHhqaexg
	vDf/n94hRiYOxkOMEhzMSiK8zeGb0oR4UxIrq1KL8uOLSnNSiw8xSnOwKInzGs6YnSIkkJ5Y
	kpqdmlqQWgSTZeLglGpgilrO87pk5VSV1Rtfnpr1582MjRqK8nm5MvEia6ctCmRuZNwq7bHs
	/YcNv3gPPWo26H61NvbTzcdrQ59n278VFUlY2flw/s/pRUGqfeqdHVXhv5WmVZ5bz7Lg+Qkx
	8WhLRoFpjh4/r/BXGDl9Klz5zuX7i9YsFxfGt1Usu7c/4TjqmHnlljbDOxM9vUezV+ewizst
	/fhIMTRCSe3NJVbG1WGJ3YFnnK8wHL7v9eqx2tXeG5Iv9nktOb52z/0VBm1MHz7WW360O+CR
	ISMkYfyuY72TUZegg+uPpwduH3m4NrFO+pmOYO6GN16uiQc1JQL+JfV5ZXsFn3RvObLon7/t
	1pgGbQ7mPV/yJDkORzxapcRSnJFoqMVcVJwIAOAacke+AgAA
X-CMS-MailID: 20240812020140epcas5p3431842ed5508ffb5ae9f1d1812cae4d5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240812020140epcas5p3431842ed5508ffb5ae9f1d1812cae4d5
References: <CGME20240812020140epcas5p3431842ed5508ffb5ae9f1d1812cae4d5@epcas5p3.samsung.com>

io_uring fdinfo contains most of the runtime information,
which is helpful for debugging io_uring applications;
However, there is currently a lack of timeout-related
information, and this patch adds timeout_list information.

Signed-off-by: Ruyi Zhang <ruyi.zhang@samsung.com>
---
 io_uring/fdinfo.c  | 16 ++++++++++++++--
 io_uring/timeout.c | 12 ------------
 io_uring/timeout.h | 12 ++++++++++++
 3 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index b1e0e0d85349..33c3efd79f98 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -14,6 +14,7 @@
 #include "fdinfo.h"
 #include "cancel.h"
 #include "rsrc.h"
+#include "timeout.h"
 
 #ifdef CONFIG_PROC_FS
 static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
@@ -54,6 +55,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 	struct io_overflow_cqe *ocqe;
+	struct io_timeout *timeout;
 	struct io_rings *r = ctx->rings;
 	struct rusage sq_usage;
 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
@@ -219,9 +221,19 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 
 		seq_printf(m, "  user_data=%llu, res=%d, flags=%x\n",
 			   cqe->user_data, cqe->res, cqe->flags);
-
 	}
-
 	spin_unlock(&ctx->completion_lock);
+
+	seq_puts(m, "TimeoutList:\n");
+	spin_lock(&ctx->timeout_lock);
+	list_for_each_entry(timeout, &ctx->timeout_list, list) {
+		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
+		struct io_timeout_data *data = req->async_data;
+
+		seq_printf(m, "  off=%d, target_seq=%d, repeats=%x,  ts.tv_sec=%lld, ts.tv_nsec=%ld\n",
+			   timeout->off, timeout->target_seq, timeout->repeats,
+			   data->ts.tv_sec, data->ts.tv_nsec);
+	}
+	spin_unlock(&ctx->timeout_lock);
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


