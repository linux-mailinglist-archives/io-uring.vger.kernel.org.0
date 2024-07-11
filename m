Return-Path: <io-uring+bounces-2499-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CA8F92E217
	for <lists+io-uring@lfdr.de>; Thu, 11 Jul 2024 10:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 437201C2165D
	for <lists+io-uring@lfdr.de>; Thu, 11 Jul 2024 08:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6AA1509A4;
	Thu, 11 Jul 2024 08:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ObYDFpcw"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AEA1514EF
	for <io-uring@vger.kernel.org>; Thu, 11 Jul 2024 08:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720686314; cv=none; b=SvjhrGstw9wkVbiWDaTuVQfMFRcHXe1hT/LK2VdyHaoErRQu4Kb25MKiVk3whp3DT44g/ft9tVuOPrqXZt/fVNh2FoQWYuP3s924w9DdGh+1ZcVcewBefbDo4Nc9XpwxfMZa57mQGhmUOfOpt89/F6I1ipL8AALNHmD/ZMsi6nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720686314; c=relaxed/simple;
	bh=eD3/0xgMkQVTmVqp2eDJA/FsESWS1CxYn4aHQNJAKlU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=YSyI2RxhGTnGTkIePDkU9pMMcxQXNfe5byGRQ2dcR/L1YsCX5yj8V0xjWocirxRs3AiAyX0AaO0BvurIB7IQhTA5oAXKvaUjndBSsINkX1PssJ8VmsYbUPee0msnCKM2JzqXE/DOeCcndcDLs0/GMe4V/8QeASqKaHh6TYEhVA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ObYDFpcw; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240711082504epoutp036885d9cd8609e49454c643d075c052b7~hGxOxqNqs0412804128epoutp03y
	for <io-uring@vger.kernel.org>; Thu, 11 Jul 2024 08:25:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240711082504epoutp036885d9cd8609e49454c643d075c052b7~hGxOxqNqs0412804128epoutp03y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720686304;
	bh=uAhOcVAfCmtm03saSrvaNUjradIhm4AGxePH+DZZAk4=;
	h=From:To:Cc:Subject:Date:References:From;
	b=ObYDFpcwJu7OO1AbH3Sz+UDAWnL7aV5aTOOZSuVYqrZYkK0mnXTHvFZaer9Nsd0cZ
	 NLtnQRuy+Fk8E+YK+pkBn88iOhbhiVyXVvdlDOAYPuy4qcvxVA0CgGU1bKk2zzTQ66
	 jUwIVchOn6uRLS/p7itGuGiQxoOyhPykJu3ybiV0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240711082503epcas5p353b8259a1ffd037f80ad53a95438f22b~hGxOT0bpo1497814978epcas5p3q;
	Thu, 11 Jul 2024 08:25:03 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WKST94dvxz4x9Q7; Thu, 11 Jul
	2024 08:25:01 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FF.B9.06857.DD69F866; Thu, 11 Jul 2024 17:25:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240711082438epcas5p3732ee8528964d2334f5670e36b0c3f10~hGw3IpXNI1225712257epcas5p35;
	Thu, 11 Jul 2024 08:24:38 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240711082438epsmtrp1157332ff6210903eea3a2cd6f1d9ecbf~hGw3H5U5I2361923619epsmtrp1D;
	Thu, 11 Jul 2024 08:24:38 +0000 (GMT)
X-AuditID: b6c32a4b-ae9fa70000021ac9-c7-668f96dd2f46
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FB.C6.19057.6C69F866; Thu, 11 Jul 2024 17:24:38 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240711082437epsmtip1f4882274f8a0fed3a416bb4df5d93c3d~hGw2MMub-1885618856epsmtip1I;
	Thu, 11 Jul 2024 08:24:37 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, hexue <xue01.he@samsung.com>
Subject: [PATCH v2] io_uring: Avoid polling configuration errors
Date: Thu, 11 Jul 2024 16:24:30 +0800
Message-Id: <20240711082430.609597-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmpu7daf1pBu23FS3mrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sFl0XTrE5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInKtslI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ2x/tF3
	poLtYhVP7pxja2BcJtTFyMkhIWAisWnaKvYuRi4OIYHdjBIrVv2Gcj4xStz9d5UJwvnGKNFx
	8ygzTMvOlf/ZIBJ7GSU2neiGcn4wSszpO88EUsUmoCSxf8sHRhBbREBYYn9HKwuIzSxQJPF6
	5jbWLkYODmEBB4lPe8HCLAKqEm/2P2EHsXkFrCQOLH3PCrFMXuJm135miLigxMmZT6DGyEs0
	b53NDLJXQmAfu8SC9WeZIBpcJE5/v8EGYQtLvDq+hR3ClpJ42d8GZedLTP6+nhHCrpFYt/kd
	C4RtLfHvyh4WkNuYBTQl1u/ShwjLSkw9tY4JYi+fRO/vJ1CreCV2zIOxlSSWHFkBNVJC4veE
	RVD3e0is+fQZ7H4hgViJn22H2CYwys9C8s4sJO/MQti8gJF5FaNkakFxbnpqsWmBcV5qOTxi
	k/NzNzGC06GW9w7GRw8+6B1iZOJgPMQowcGsJMI7/0Z3mhBvSmJlVWpRfnxRaU5q8SFGU2AY
	T2SWEk3OBybkvJJ4QxNLAxMzMzMTS2MzQyVx3tetc1OEBNITS1KzU1MLUotg+pg4OKUamNQK
	Tt3t9m2TKbx2tWS36stIvZvzLXs3KkxNCLX5IWooWSbbP8nOa3fMuxIHRWWmuD9HLm4/cGRt
	0KoDSbv65nw7eiNOdpnq3Z0Kuqtml36qqTknIjctfvN+kSY/zYr5i/ZPVclgPxXxe7LD9nJR
	FZescg6rBScCJh1w3cLjvmdnpvDe48sE53OcmpjkcElnyvl/ET6xS3+zeswzks2+/yrGwb/q
	tFljAcsWe4a3Vuv+LFyVfGujg4TIx8IZoZE/FGXXpqsFzShkuOruXeP3zVpS4sOp8t7kk1Hv
	ejczbvycELIyZOZhUSk+LqZdOmwn/+9TfL0h/eHB4zNPFGubqmSqJ27r1vVUDjyt9v5omBJL
	cUaioRZzUXEiAP3And0QBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWy7bCSnO6xaf1pBluny1nMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAlbH+0Xemgu1iFU/unGNrYFwm1MXIySEhYCKxc+V/ti5GLg4hgd2MEr2ts5kh
	EhISOx79YYWwhSVW/nvODlH0jVHi+NcTYAk2ASWJ/Vs+MILYIkBF+ztaWUBsZoEyiXcr1wPV
	cHAICzhIfNoLFmYRUJV4s/8JO4jNK2AlcWDpe6j58hI3u/YzQ8QFJU7OfAI1Rl6ieets5gmM
	fLOQpGYhSS1gZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcmFpaOxj3rPqgd4iR
	iYPxEKMEB7OSCO/8G91pQrwpiZVVqUX58UWlOanFhxilOViUxHm/ve5NERJITyxJzU5NLUgt
	gskycXBKNTAFuDKf6dTiWd7DeEdrtvuZmF+nvaOYqt72dLU4lD9/GFHJxKwTV65bV2NaUTM5
	9FwBd83MhdN8ky+ui59TV7j4Imfz/+n1YnIP751Zkt3nc83vwSkZ4dO9jnOeF7+eejurg21m
	xpqaXl7O4CKVFGGezpbK7a0nT3B+WsI9dYvz4Q3u626pOX334J2V0cl5Rc/GUy2eTzpw97/r
	3kc7byw52G4YOvdi5vOzp5tWif2YXmsT8X163k7Lz9b5bPzpqv80Hb3v2p0qmrO6J+LteUXN
	yMfP28+tCK0I2HRpvb/6DxZmm5/KlbNMXux6Y7X/4PO1x3NdzzCaFLW1v3NhDDvYpxv/30j9
	knPLCRuhn0osxRmJhlrMRcWJAFghbi67AgAA
X-CMS-MailID: 20240711082438epcas5p3732ee8528964d2334f5670e36b0c3f10
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240711082438epcas5p3732ee8528964d2334f5670e36b0c3f10
References: <CGME20240711082438epcas5p3732ee8528964d2334f5670e36b0c3f10@epcas5p3.samsung.com>

If user doesn't configured poll queue but do the polled IO, it will get
a low performeance than regular poll, but 100% CPU uage. And there's no
prompts or warnings.

This patch aims to help users more easily verify their configurations
correctly, avoiding time and performance losses.

--
changes from v1:
- without disrupting the original I/O process.
- move judgement from block to io_uring.

Signed-off-by: hexue <xue01.he@samsung.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            |  4 +++-
 io_uring/rw.c                  | 18 ++++++++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 91224bbcfa73..270c3edbbf21 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -428,6 +428,7 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+	bool				check_poll_queue;
 };
 
 struct io_tw_state {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 816e93e7f949..1b45b4c52ae0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3463,8 +3463,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	    !(ctx->flags & IORING_SETUP_SQPOLL))
 		ctx->task_complete = true;
 
-	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL))
+	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
 		ctx->lockless_cq = true;
+		ctx->check_poll_queue = false;
+	}
 
 	/*
 	 * lazy poll_wq activation relies on ->task_complete for synchronisation
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1a2128459cb4..20f417152a17 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -772,6 +772,23 @@ static bool need_complete_io(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+static void check_poll_queue_state(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	if (!ctx->check_poll_queue) {
+		struct block_device *bdev;
+		struct request_queue *q;
+		struct inode *inode = req->file->f_inode;
+
+		if (inode->i_rdev) {
+			bdev = blkdev_get_no_open(inode->i_rdev);
+			q = bdev->bd_queue;
+			if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+				pr_warn("the device does't configured with poll queues\n");
+		}
+		ctx->check_poll_queue = true;
+	}
+}
+
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -804,6 +821,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
 			return -EOPNOTSUPP;
+		check_poll_queue_state(ctx, req);
 
 		kiocb->private = NULL;
 		kiocb->ki_flags |= IOCB_HIPRI;
-- 
2.40.1


