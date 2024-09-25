Return-Path: <io-uring+bounces-3300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76412985656
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 11:29:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34423284754
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 09:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8A115C15C;
	Wed, 25 Sep 2024 09:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gi6Vtva/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BB715B570
	for <io-uring@vger.kernel.org>; Wed, 25 Sep 2024 09:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727256537; cv=none; b=ERjZak/N5B46jx4lj3bYA0+nogC5yKeIMEQlC2xmskn8dn8tFXQNZlu21QdpmfyGN0EM96DHFIADVFZLpYTEbP0o+QWIsoPyN2MDq0X7k6r2lELllmuIN7ArmHN5zsBPtQTtWYIU+IkqNxlQHwBuV8LhEKDkameEptoVcV4Oti0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727256537; c=relaxed/simple;
	bh=mMWh3Z1Y0a6QMHBkqsaNi5Podd5MV+7sJ5y0oxuH01U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=TGlvUQFBT7Fpm4msADKR59+VQgKElP37DgIVjrz+ZLTSV/zSyDew1nlvk+V1GU1H6nhgvJ7695PH3qpEigB7npawmw0jlqfyLoX19CT+CzTkmF1YirTGexgfKoXAiOW6H891x5itf+TdsLxWijz/h+n1P/q0g//fw9STiIv93yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gi6Vtva/; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240925092848epoutp04c1ccae66c41b79a0fdfb91de8828b32d~4cqkwxYfe1112811128epoutp04X
	for <io-uring@vger.kernel.org>; Wed, 25 Sep 2024 09:28:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240925092848epoutp04c1ccae66c41b79a0fdfb91de8828b32d~4cqkwxYfe1112811128epoutp04X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727256528;
	bh=B6PiPsFEiraCQMw0Yc1r7WTRP21USjl00XIkTG0Mk4Q=;
	h=From:To:Cc:Subject:Date:References:From;
	b=gi6Vtva/0fSnnBWkYXqdm9z3v4PHJhLHXVNArIqfbiZHayZRL6meUt5Qbg9rgGZgq
	 1UUgobtLzWJ16mNz7Y8BhSYHpLqAIbaVAv2MPJJ+/V+lbH3C+o5VDgIvHFmh65Ys9P
	 tQzp7NRpANhxzvdNcUFjZmm5kYjohExK34th8s1w=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240925092847epcas5p2d5dd578346e67f76e75f6fa06d5040d1~4cqkWz0I80788307883epcas5p2e;
	Wed, 25 Sep 2024 09:28:47 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XDBHd6GJ9z4x9Q6; Wed, 25 Sep
	2024 09:28:45 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CE.12.09640.DC7D3F66; Wed, 25 Sep 2024 18:28:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240925085815epcas5p16fa977581284a81dae7b67da8bc96a85~4cP5mkhnx1293612936epcas5p1n;
	Wed, 25 Sep 2024 08:58:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240925085814epsmtrp2310113ec2b28c6371d9d562aa5695a9f~4cP5kA0vF2616326163epsmtrp2d;
	Wed, 25 Sep 2024 08:58:14 +0000 (GMT)
X-AuditID: b6c32a49-a57ff700000025a8-a3-66f3d7cd383c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D1.07.08964.6A0D3F66; Wed, 25 Sep 2024 17:58:14 +0900 (KST)
Received: from dev.. (unknown [109.105.118.18]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240925085813epsmtip1564bde7c46c1a79a0a91b0ea8ab8d6d5~4cP4ivrqD0082300823epsmtip1W;
	Wed, 25 Sep 2024 08:58:13 +0000 (GMT)
From: Ruyi Zhang <ruyi.zhang@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	peiwei.li@samsung.com, Ruyi Zhang <ruyi.zhang@samsung.com>
Subject: [PATCH v2 RESEND] io_uring/fdinfo: add timeout_list to fdinfo
Date: Wed, 25 Sep 2024 08:58:00 +0000
Message-ID: <20240925085800.1729-1-ruyi.zhang@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmpu7Z65/TDL7PNLCYs2obo8Xqu/1s
	Fu9az7FY/Oq+y2hxedccNotnezktvhz+zm5xdsIHVgcOj52z7rJ7XD5b6tG3ZRWjx+dNcgEs
	Udk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBHKCmU
	JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOy
	M47u1i3YKlFx+tV1xgbGz8JdjJwcEgImEjO/b2XpYuTiEBLYzShx58Q5KOcTo8THqS8ZQaqE
	BL4xSjz5aNfFyAHW8f6aO0TNXkaJs/+vsUI4TxglLh1sZANpYBPQlLg8swGsWURAW+L146ks
	IDazQIXEuttPmUAGCQu4Sby86g0SZhFQlZiyfCM7iM0rYCWxZslfVojr5CUW71jODBEXlDg5
	8wnUGHmJ5q2zmUH2SgicY5c49+AwC0SDi8T0i4fYIWxhiVfHt0DZUhKf3+1lg3igWOJhXz5E
	uIFRYtvvOgjbWuLflT0sICXMQOev36UPEZaVmHpqHRPEWj6J3t9PmCDivBI75sHYKhLvV7xj
	gtm0vnU3lO0hMbnxGzQIYyWuPVrPOIFRfhaSb2Yh+WYWwuYFjMyrGCVTC4pz01OLTQsM81LL
	4ZGanJ+7iRGcDrU8dzDeffBB7xAjEwfjIUYJDmYlEd5JNz+mCfGmJFZWpRblxxeV5qQWH2I0
	BQbxRGYp0eR8YELOK4k3NLE0MDEzMzOxNDYzVBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qB
	Safk4vR7Umk3yjkOd7r7dpxdylWtdukMw55DYl/2rbHP1JUzfPhwRluS1yHzji9zuhd+P/0/
	MzJu62z57eckmJPZT//bWLMihvmohFlB4vOWL7v8/adz9u0x1Zy8j8P1T+IcY56iyuCcw1l3
	Qp/0yAmlmF2fKrrpbuoWWZfz+VOP7k7+P3tXs7Bs9Du2/byixmHm22Qt+O4+O3Ev7su0E6+3
	5jokufDacRwsrzsWpfX9lHzYb8fl2+MjD8/afo/n4vGbE9xqGlvrlXNTrVzDrKV7X+x+/bB2
	1ZXLTToMRuastedXKD6+3VWq9v1Km0Z/rtQpx3Uia7aErP3L0zJN6ex+Z2cB0WeaMvOeHMoW
	UGIpzkg01GIuKk4EAHrJLecQBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsWy7bCSnO6yC5/TDG4dMbWYs2obo8Xqu/1s
	Fu9az7FY/Oq+y2hxedccNotnezktvhz+zm5xdsIHVgcOj52z7rJ7XD5b6tG3ZRWjx+dNcgEs
	UVw2Kak5mWWpRfp2CVwZR3frFmyVqDj96jpjA+Nn4S5GDg4JAROJ99fcuxi5OIQEdjNKzNw9
	lbGLkRMoLiVxs+kYE4QtLLHy33N2iKJHjBK3n1xnAUmwCWhKXJ7ZwAgySERAV6LxrgJImFmg
	RqLr6gQmkLCwgJvEy6veIGEWAVWJKcs3soPYvAJWEmuW/GWFGC8vsXjHcmaIuKDEyZlPWCDG
	yEs0b53NPIGRbxaS1CwkqQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYJDU0tz
	B+P2VR/0DjEycTAeYpTgYFYS4Z1082OaEG9KYmVValF+fFFpTmrxIUZpDhYlcV7xF70pQgLp
	iSWp2ampBalFMFkmDk6pBqbNOlMUBBofqKnPm7ah+kkv+6E3V6bxuvjX/Bbhmn9oheIEtfDN
	iZ+vPCldVm96YdV3k2u9nG2v1kjyHXXjOdN3nel75dFzNfce1y3hCrnyKPLLD76shfIyl3mc
	xcIVZ/dr3Ga8/tvnpRqnFEfQwfxlOj4qU5aZPBf/NvHdE8MzfzRP1y6yeLJ39TcdhoOJD+/2
	KhWbuLxebf/g75o5Jrzpz6pOh4hPmS9ys+V5/bLsA0IvrHX/eLT4sLOfUnpvc75E01Hpe/bq
	1gMXxU3u3FY0ap2k4iHPs0917QedK1V5G+7/tuDc03zkoVbQWj6ODfpfM1XXKvSX6UnH1B/V
	+l6ykFPmh+7nCSFLGITlzzxWYinOSDTUYi4qTgQAm0+h57wCAAA=
X-CMS-MailID: 20240925085815epcas5p16fa977581284a81dae7b67da8bc96a85
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240925085815epcas5p16fa977581284a81dae7b67da8bc96a85
References: <CGME20240925085815epcas5p16fa977581284a81dae7b67da8bc96a85@epcas5p1.samsung.com>

io_uring fdinfo contains most of the runtime information,which is
helpful for debugging io_uring applications; However, there is
currently a lack of timeout-related information, and this patch adds
timeout_list information.

--
changes since v1:
- use _irq version spin_lock.
- Fixed formatting issues and delete redundant code.
- v1 :https://lore.kernel.org/io-uring/20240812020052.8763-1-ruyi.zhang@samsung.com/
--

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


