Return-Path: <io-uring+bounces-1587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE778AAACF
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 10:47:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FB681C21E99
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 08:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B39574BEC;
	Fri, 19 Apr 2024 08:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vX56U9WB"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCCC38D
	for <io-uring@vger.kernel.org>; Fri, 19 Apr 2024 08:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713516429; cv=none; b=WIcqiPAgNuSCb9asUN3y2m4jxgTPbgqjKzk4Nxlis8kZDM3S5KBH9D0doxWAS3P/EQatykdKlVm+D1ZgtRMS3Y0ZagruLtX5Gt+Au38bq3aNf+8InwyVfbaLpElQYnQgIqsUWHgGYFRlYD14OZOu7k09TJAYrp6PUlxINtmXQoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713516429; c=relaxed/simple;
	bh=sKLHNAP+CBKZ6NvzbOmNkIdk5jdYo/MQTys0X6MTYXA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=fGNwESgoza0/PTdMJIooXgyBhoRQ7e0dDRCtW91uPv+QQ536fXBgbjonuAvO0Di/Q63w6lOIjD1a01IPQAvKU2PdtWF5ZAu+HABH61cNMYIz27wBSehBft2viKl/12CXmitpSmdJKiF+qNyXJcfNn+TxzBcS4fSdlpY0m3gfvcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vX56U9WB; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240419084704epoutp03248c76532f928ca0b1ccdfab138c9219~HohwbFCGE0878308783epoutp03w
	for <io-uring@vger.kernel.org>; Fri, 19 Apr 2024 08:47:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240419084704epoutp03248c76532f928ca0b1ccdfab138c9219~HohwbFCGE0878308783epoutp03w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1713516424;
	bh=27cSkEbgmQOpgLT4F8oDDNJFXdoKKhQcvYfKD/PWAIg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=vX56U9WBDzhK/h/I20NJ9B2Kz+ExDUaHaVjv83/usERhE1jw5LmY7CNAdlTM3/5HN
	 x9djJc9xoCY6WDFXZ8+rdMPFNIx7znTbSuGy5wvqVgC7Whv5Bt62WrtZzMVqqmUaEO
	 O7dIp87qkNDbsi0t/4pvXReUd0IRmRsqvbuKx/Ws=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240419084704epcas5p28ebadc36b6f68a3e6a230538796baa10~Hohv271t71736517365epcas5p2l;
	Fri, 19 Apr 2024 08:47:04 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VLSts4XtPz4x9Px; Fri, 19 Apr
	2024 08:47:01 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	14.E7.09666.58F22266; Fri, 19 Apr 2024 17:47:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240418093150epcas5p31dc20cc737c72009265593f247e48262~HVfjWalFB1099010990epcas5p3x;
	Thu, 18 Apr 2024 09:31:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240418093150epsmtrp16685b4bd219ecdaf5eff0b8995cc7dca~HVfjVftpC1412614126epsmtrp1E;
	Thu, 18 Apr 2024 09:31:50 +0000 (GMT)
X-AuditID: b6c32a49-5721da80000025c2-4e-66222f8530a0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	27.D1.08924.688E0266; Thu, 18 Apr 2024 18:31:50 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240418093148epsmtip28c07423fe19b3428db3b19f4775558ba~HVfh1mMQA1461114611epsmtip2A;
	Thu, 18 Apr 2024 09:31:48 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com,
	hexue <xue01.he@samsung.com>
Subject: [PATCH v2] io_uring: releasing CPU resources when polling
Date: Thu, 18 Apr 2024 17:31:43 +0800
Message-Id: <20240418093143.2188131-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmhm6rvlKawaIDChZNE/4yW8xZtY3R
	YvXdfjaL038fs1i8az3HYnH0/1s2i1/ddxkttn75ympxedccNotnezktvhz+zm5xdsIHVoup
	W3YwWXS0XGa06Lpwis2B32PnrLvsHpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZe
	uq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QnUoKZYk5pUChgMTiYiV9O5ui/NKS
	VIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IwvL94xFZxwqVjfuo+xgfGl
	eRcjJ4eEgIlE/+LjLF2MXBxCArsZJeYum84E4XxilHjcfwwq841RYvHhTaxdjBxgLR9feULE
	9zJKLOtbxArh/GCUOPD2MBvIXDYBJYn9Wz4wgtgiAsIS+ztawSYxC2xnkri8agsTSEJYwEli
	+5lHYA0sAqoSa6/uBWvgFbCWuHZpAyvEgfISN7v2M0PEBSVOznzCAmIzA8Wbt85mBhkqIfCX
	XWLOjXZmiAYXiTmLdjBC2MISr45vYYewpSRe9rdB2fkSk7+vh6qpkVi3+R0LhG0t8e/KHhaQ
	N5kFNCXW79KHCMtKTD21jgliL59E7+8nTBBxXokd82BsJYklR1ZAjZSQ+D1hEdT9HhIbH2wC
	iwsJxEqs/LKUbQKj/Cwk78xC8s4shM0LGJlXMUqmFhTnpqcWmxYY5qWWw2M2OT93EyM4vWp5
	7mC8++CD3iFGJg7GQ4wSHMxKIrxmHIppQrwpiZVVqUX58UWlOanFhxhNgWE8kVlKNDkfmODz
	SuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1OTS1ILYLpY+LglGpgkjyeHMTdeOrHwjv/
	4h/qFjuxvj8bLVHn/iNx5tsv0x8uYjFR0TnqeGKuTdKNO31CTyUmPK2WmdLXtX2rY3vQhE3p
	X3Uyt+859y0sL3ulRJHDtM9KvblMuv8fsin5iefOspr7MmVKm9E+2bUnzv6fc1HGJ3j+9KXS
	5hobWFznyLFfesaz9qzfgjlB6mXLYpifls1g3T/3UkyahPI8CeH7fBpTr+3f0nZV7KVXpa6U
	+5J6I6GFqcLL/C8v/fL2p9NvzsY1kq19zupJLk7f+TMfSuR8y9h9/8GnA8mVXA+Lg/uOfGJM
	E9DvfbfoP2+hpPPqKLtQfd3u3ORlzLmzLrlbno69k5ttsi5cUb+Qz0pCiaU4I9FQi7moOBEA
	8mTpIzgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSvG7bC4U0g4+XBS2aJvxltpizahuj
	xeq7/WwWp/8+ZrF413qOxeLo/7dsFr+67zJabP3yldXi8q45bBbP9nJafDn8nd3i7IQPrBZT
	t+xgsuhoucxo0XXhFJsDv8fOWXfZPS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujC8v
	3jEVnHCpWN+6j7GB8aV5FyMHh4SAicTHV55djFwcQgK7GSU+nnjO2MXICRSXkNjx6A8rhC0s
	sfLfc3aIom+MEgffd4Al2ASUJPZv+QDWIAJUtL+jlQWkiFngKJPE+2sHWUASwgJOEtvPPGID
	sVkEVCXWXt0L1sArYC1x7dIGqA3yEje79jNDxAUlTs58AtbLDBRv3jqbeQIj3ywkqVlIUgsY
	mVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgQHupbmDsbtqz7oHWJk4mA8xCjBwawk
	wtsiLJsmxJuSWFmVWpQfX1Sak1p8iFGag0VJnFf8RW+KkEB6YklqdmpqQWoRTJaJg1Oqgcn2
	Lnva6jftcj+rtyUxX3l1wEdP7ezk2CWusT/OK5eXLqvdJd/j4PDr/qqdoi8ECk+z5sYLpTTb
	dxe8tTb6Ldj5T0ftmw7HqchlbzQb0nfqsEj5R13lrTJV5bhw60z/sqwb3ME6JWK3izvmVX/W
	0s54xPzqmjtz/825S/taf0ZMnlM3yylgbWnxWVnpjt2isoo+RXdixWZsV7O+wvDx/wmrvh+p
	2aJ6azau43RTufX+doj6v7RFQaeeM2YfWnT8kBL7vQe655NrM8WFDwXrfLr2d+2uJ3s+patf
	T793TOPSe37NptxG1h//0zYV9dyo2PNyn9IUNauk6H1/Xe9X6nDMEjzqW9e0cOYS1lKdE0os
	xRmJhlrMRcWJAGrOFXXjAgAA
X-CMS-MailID: 20240418093150epcas5p31dc20cc737c72009265593f247e48262
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240418093150epcas5p31dc20cc737c72009265593f247e48262
References: <CGME20240418093150epcas5p31dc20cc737c72009265593f247e48262@epcas5p3.samsung.com>

This patch is intended to release the CPU resources of io_uring in
polling mode. When IO is issued, the program immediately polls for
check completion, which is a waste of CPU resources when IO commands
are executed on the disk.

I add the hybrid polling feature in io_uring, enables polling to
release a portion of CPU resources without affecting block layer.

- Record the running time and context switching time of each
  IO, and use these time to determine whether a process continue
  to schedule.

- Adaptive adjustment to different devices. Due to the real-time
  nature of time recording, each device's IO processing speed is
  different, so the CPU optimization effect will vary.

- Set a interface (ctx->flag) enables application to choose whether
  or not to use this feature.

The CPU optimization in peak workload of patch is tested as follows:
  all CPU utilization of original polling is 100% for per CPU, after
  optimization, the CPU utilization drop a lot (per CPU);

   read(128k, QD64, 1Job)     37%   write(128k, QD64, 1Job)     40%
   randread(4k, QD64, 16Job)  52%   randwrite(4k, QD64, 16Job)  12%

  Compared to original polling, the optimised performance reduction
  with peak workload within 1%.

   read  0.29%     write  0.51%    randread  0.09%    randwrite  0%

Reviewed-by: KANCHAN JOSHI <joshi.k@samsung.com>
Signed-off-by: hexue <xue01.he@samsung.com>
---
 include/linux/io_uring_types.h | 10 +++++
 include/uapi/linux/io_uring.h  |  1 +
 io_uring/io_uring.c            | 28 +++++++++++++-
 io_uring/io_uring.h            |  2 +
 io_uring/rw.c                  | 69 ++++++++++++++++++++++++++++++++++
 5 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 854ad67a5f70..7607fd8de91c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -224,6 +224,11 @@ struct io_alloc_cache {
 	size_t			elem_size;
 };
 
+struct iopoll_info {
+	long		last_runtime;
+	long		last_irqtime;
+};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -421,6 +426,7 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+	struct xarray		poll_array;
 };
 
 struct io_tw_state {
@@ -641,6 +647,10 @@ struct io_kiocb {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
+	/* for hybrid iopoll */
+	int				poll_flag;
+	struct timespec64		iopoll_start;
+	struct timespec64		iopoll_end;
 };
 
 struct io_overflow_cqe {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7a673b52827b..0038cdfec18f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -198,6 +198,7 @@ enum {
  * Removes indirection through the SQ index array.
  */
 #define IORING_SETUP_NO_SQARRAY		(1U << 16)
+#define IORING_SETUP_HY_POLL	(1U << 17)
 
 enum io_uring_op {
 	IORING_OP_NOP,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd9a137ad6ce..bfb94e975f97 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -79,6 +79,8 @@
 
 #include <uapi/linux/io_uring.h>
 
+#include <linux/time.h>
+#include <linux/timekeeping.h>
 #include "io-wq.h"
 
 #include "io_uring.h"
@@ -311,6 +313,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	xa_init(&ctx->poll_array);
 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
@@ -1875,10 +1878,28 @@ static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
 	return !!req->file;
 }
 
+void init_hybrid_poll_info(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	u32 index;
+
+	index = req->file->f_inode->i_rdev;
+	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);
+
+	if (!entry) {
+		entry = kmalloc(sizeof(struct iopoll_info), GFP_KERNEL);
+		entry->last_runtime = 0;
+		entry->last_irqtime = 0;
+		xa_store(&ctx->poll_array, index, entry, GFP_KERNEL);
+	}
+
+	ktime_get_ts64(&req->iopoll_start);
+}
+
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	const struct cred *creds = NULL;
+	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	if (unlikely(!io_assign_file(req, def, issue_flags)))
@@ -1890,6 +1911,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (!def->audit_skip)
 		audit_uring_entry(req->opcode);
 
+	if (ctx->flags & IORING_SETUP_HY_POLL)
+		init_hybrid_poll_info(ctx, req);
+
 	ret = def->issue(req, issue_flags);
 
 	if (!def->audit_skip)
@@ -2176,6 +2200,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->file = NULL;
 	req->rsrc_node = NULL;
 	req->task = current;
+	req->poll_flag = 0;
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
@@ -2921,6 +2946,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->poll_array);
 	kfree(ctx);
 }
 
@@ -4050,7 +4076,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY))
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HY_POLL))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d5495710c178..d5b175826adb 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -125,6 +125,8 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 	__io_req_task_work_add(req, 0);
 }
 
+#define LEFT_TIME 1000
+
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index d5e79d9bdc71..ac73121030ee 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1118,6 +1118,69 @@ void io_rw_fail(struct io_kiocb *req)
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
+void io_delay(struct io_kiocb *req, struct iopoll_info *entry)
+{
+	struct hrtimer_sleeper timer;
+	ktime_t kt;
+	struct timespec64 tc, oldtc;
+	enum hrtimer_mode mode;
+	long sleep_ti;
+
+	if (req->poll_flag == 1)
+		return;
+
+	if (entry->last_runtime <= entry->last_irqtime)
+		return;
+
+	/*
+	 * Avoid excessive scheduling time affecting performance
+	 * by using only 25 per cent of the remaining time
+	 */
+	sleep_ti = (entry->last_runtime - entry->last_irqtime) / 4;
+	if (sleep_ti < LEFT_TIME)
+		return;
+
+	ktime_get_ts64(&oldtc);
+	kt = ktime_set(0, sleep_ti);
+	req->poll_flag = 1;
+
+	mode = HRTIMER_MODE_REL;
+	hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
+	hrtimer_set_expires(&timer.timer, kt);
+
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	hrtimer_sleeper_start_expires(&timer, mode);
+	if (timer.task) {
+		io_schedule();
+	}
+	hrtimer_cancel(&timer.timer);
+	mode = HRTIMER_MODE_ABS;
+
+	__set_current_state(TASK_RUNNING);
+	destroy_hrtimer_on_stack(&timer.timer);
+
+	ktime_get_ts64(&tc);
+	entry->last_irqtime = tc.tv_nsec - oldtc.tv_nsec - sleep_ti;
+}
+
+int iouring_hybrid_poll(struct io_kiocb *req, struct io_comp_batch *iob, unsigned int poll_flags)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct iopoll_info *entry;
+	int ret;
+	u32 index;
+
+	index = req->file->f_inode->i_rdev;
+	entry = xa_load(&ctx->poll_array, index);
+	io_delay(req, entry);
+	ret = req->file->f_op->iopoll(&rw->kiocb, iob, poll_flags);
+
+	ktime_get_ts64(&req->iopoll_end);
+	entry->last_runtime = req->iopoll_end.tv_nsec - req->iopoll_start.tv_nsec;
+	return ret;
+}
+
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
@@ -1145,6 +1208,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
+		if (ctx->flags & IORING_SETUP_HY_POLL) {
+			ret = iouring_hybrid_poll(req, &iob, poll_flags);
+			goto comb;
+		}
+
 		if (req->opcode == IORING_OP_URING_CMD) {
 			struct io_uring_cmd *ioucmd;
 
@@ -1156,6 +1224,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 
 			ret = file->f_op->iopoll(&rw->kiocb, &iob, poll_flags);
 		}
+comb:
 		if (unlikely(ret < 0))
 			return ret;
 		else if (ret)
-- 
2.40.1


