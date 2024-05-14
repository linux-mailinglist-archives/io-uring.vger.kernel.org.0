Return-Path: <io-uring+bounces-1904-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30AAD8C4D6B
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 10:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E1761F213A0
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 08:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6FFA17583;
	Tue, 14 May 2024 08:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JcbfG/Ub"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788F3125A9
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 08:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715673695; cv=none; b=cEoJ6JXeKj50QV7vz+WWhYCmTOpizZIEZp+3nzFVfVpH3LnyYHaO1OSTRwjJXdaucATd7/SYbfgrN8HNUfwlYq4nQ6Mjo48cUi4qdrebLn65PMHtv/c/oN2Uy3OiXPckCCXBnOHAjOZgirna8UuHISpbTA23F9gKzx8h8YBoa7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715673695; c=relaxed/simple;
	bh=Bn43btKuiH6buNWIn4YsAt+J+q3EmB8CcDq/4sdW4Cs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=QtnlcgSINQWoUDu+FNPJQS/qv8B32b+w5CwaDV3kvYDJXVQMSg0RBrmcR/kdp1YCarzmIPlYkwHZokxZmK+tZat/b5b9Cbl1A5zBYF2hGXFsS0Mf+i3+go415hGxkXmb9MZ07vSyO86FxeQ/Vk7z/twU1lr+W7sOB/6v5zCEFGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JcbfG/Ub; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240514080130epoutp0409c2172346d920b7c2e885fc18726a29~PTCG1AKyI1378613786epoutp04J
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 08:01:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240514080130epoutp0409c2172346d920b7c2e885fc18726a29~PTCG1AKyI1378613786epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715673690;
	bh=BX6SHsh56ZWjckh1DjCA23/Y4maEzBj6vKCsZkwt7mY=;
	h=From:To:Cc:Subject:Date:References:From;
	b=JcbfG/UbJlh4iSzF4LU74KqnKVmweVQ0+BZ/vj99+gjUQcYLxeq2ALyOuZFxHemMa
	 I6TZ0/UIhen66v/F8+4bpA3c1Pow6gG3XaKI9C/bEch8UBHsd1iD//nppxfeVrrqFA
	 poRY4bd//2Z7yKylynbjCJf5DlbLo8qXQqcBieXY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240514080130epcas5p2df08c4c811618847f9d97fbcca0cbc58~PTCGUmth90805408054epcas5p26;
	Tue, 14 May 2024 08:01:30 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Vdphm0ptjz4x9Q0; Tue, 14 May
	2024 08:01:28 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A0.0B.08600.75A13466; Tue, 14 May 2024 17:01:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240514080007epcas5p2b597ff212998cfe8a59332a8b320ec60~PTA48BUQG0233102331epcas5p2d;
	Tue, 14 May 2024 08:00:07 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240514080007epsmtrp23e7f4e3b8417840e9b98e7077eeab1ee~PTA46KFxc1048410484epsmtrp2Q;
	Tue, 14 May 2024 08:00:07 +0000 (GMT)
X-AuditID: b6c32a44-921fa70000002198-3b-66431a57c2f6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	55.83.08390.60A13466; Tue, 14 May 2024 17:00:06 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240514080005epsmtip134f7e78f00960d45feb422a8149ea24f~PTA3e2VPp0969409694epsmtip1t;
	Tue, 14 May 2024 08:00:05 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, ruyi.zhang@samsung.com,
	wenwen.chen@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com,
	hexue <xue01.he@samsung.com>
Subject: [PATCH v4] io_uring: releasing CPU resources when polling
Date: Tue, 14 May 2024 15:59:59 +0800
Message-Id: <20240514075959.734682-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmpm6ElHOawfzpTBZNE/4yW8xZtY3R
	YvXdfjaL038fs1i8az3HYnH0/1s2i1/ddxkttn75ympxedccNotnezktvhz+zm5xdsIHVoup
	W3YwWXS0XGa06Lpwis2B32PnrLvsHpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZe
	uq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QnUoKZYk5pUChgMTiYiV9O5ui/NKS
	VIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IwVXW/ZCxa4Vyx7cJGtgfGa
	ZRcjJ4eEgInEm2nH2UFsIYHdjBITlkd2MXIB2Z8YJeYdOMsG4XxjlFjbMYkVpuN+y0sWiMRe
	RokPP6YzQjg/GCU2H77KBlLFJqAksX/LB0YQW0RAWGJ/RytYB7PAdiaJd6u2AiU4OIQFnCSe
	T88GqWERUJWYeWoZ2B28AlYSsx5MZILYJi9xs2s/M0RcUOLkzCcsIDYzULx562xmkJkSAo0c
	Eh9PfWOBaHCR+Le6nRHCFpZ4dXwLO4QtJfH53V42CDtfYvL39VA1NRLrNr+D6rWW+HdlDwvI
	bcwCmhLrd+lDhGUlpp5axwSxl0+i9/cTqNt4JXbMg7GVJJYcWQE1UkLi94RF0NDykNj+8TML
	JHxjJd6fa2WbwCg/C8k7s5C8Mwth8wJG5lWMkqkFxbnpqcmmBYZ5qeXwiE3Oz93ECE6uWi47
	GG/M/6d3iJGJg/EQowQHs5IIr0OhfZoQb0piZVVqUX58UWlOavEhRlNgGE9klhJNzgem97yS
	eEMTSwMTMzMzE0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGpguBcxfo7i0eGrbxHZm
	a5MrZqbLc5u9OnxlLptvqch3vbH8xsQb+70kvWtVE/ZYpRTdFf4Y2NocxFtXtNFi+uRIZwa2
	3+v/BgqfUMm488WE6f9b2xur5BaemMgSMGO1Zq5tyOUXM/Y+0TS3N5E323LeNeRqyrJvbKwL
	TWp9v4bOP/7F95I6j7/aR9mLhppScdtDV+65phcx6/YHl6kOtxev+Lh0WWB5/b69os5tsnOt
	5bMW2+xtsDkQcZ1JhNfv4KkJyt8bvGfc3JDzwj3Ij9f5Wc8ED7mtKQeX6nyYdG6OekvRm4bD
	6R/uOav/bzGvM402l/5nzH8h9nfBnp+LgjkmLLiosrkjINKwWmzVhjwlluKMREMt5qLiRABr
	grHjNwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSnC6blHOawfr7ZhZNE/4yW8xZtY3R
	YvXdfjaL038fs1i8az3HYnH0/1s2i1/ddxkttn75ympxedccNotnezktvhz+zm5xdsIHVoup
	W3YwWXS0XGa06Lpwis2B32PnrLvsHpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxoqu
	t+wFC9wrlj24yNbAeM2yi5GTQ0LAROJ+y0uWLkYuDiGB3YwS+7adY4ZISEjsePSHFcIWllj5
	7zk7RNE3Romz054zgSTYBJQk9m/5wAhiiwAV7e9oBZvELHCUSWJ601OgBAeHsICTxPPp2SA1
	LAKqEjNPLWMHsXkFrCRmPZjIBLFAXuJm135miLigxMmZT1hAbGagePPW2cwTGPlmIUnNQpJa
	wMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjONC1tHYw7ln1Qe8QIxMH4yFGCQ5m
	JRFeh0L7NCHelMTKqtSi/Pii0pzU4kOM0hwsSuK83173pggJpCeWpGanphakFsFkmTg4pRqY
	qhYH1Dh8rlj8bHGCqu19hsweUf/LkwVlI5zeFP8P4r1Rk8wZHJd3u5XpSvmpCdZBxgtXaTG6
	rrghZnPq+YqTi58taI9esefkrBD1yOvSfEaljflVG75POib54fzyQ9KNb67xW1bkrLTt8eVq
	8vggf1Nrnoj9k0ti+26EzrnBuvj5z98XFaZFHtrwX8lpafsTMcduC7WSXRVfxE3vffl+pMhv
	Q4LnjwOR53yj/NV3/s/i9vL7bMdypO/M3WrGUyeX2apuEUpb3l71TM6Bk+cHc9LLnw4TIuYd
	v3l75e/pua88l0hXft2dHehrJnD0s4L4LNGcC/Huv+Zpxs/+Zsmzan3S4+2M87kXlfB+SNUr
	VGIpzkg01GIuKk4EAKXYkEHjAgAA
X-CMS-MailID: 20240514080007epcas5p2b597ff212998cfe8a59332a8b320ec60
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240514080007epcas5p2b597ff212998cfe8a59332a8b320ec60
References: <CGME20240514080007epcas5p2b597ff212998cfe8a59332a8b320ec60@epcas5p2.samsung.com>

This patch is intended to release the CPU resources of io_uring in
polling mode. When IO is issued, the program immediately polls for
check completion, which is a waste of CPU resources when IO commands
are executed on the disk.

I add the hybrid polling feature in io_uring, enables polling to
release a portion of CPU resources without affecting block layer.

The CPU optimization in peak workload of patch is tested as follows:
  set 8 poll queues
  all CPU utilization of original polling is 100% for per CPU, after
  optimization, the CPU utilization drop a lot (per CPU);

   read(128k, QD64, 1Job)     37%   write(128k, QD64, 1Job)     40%
   randread(4k, QD64, 16Job)  52%   randwrite(4k, QD64, 16Job)  12%

  Compared to original polling, the optimised performance reduction
  with peak workload within 1%.

   read  0.29%     write  0.51%    randread  0.09%    randwrite  0%

Signed-off-by: hexue <xue01.he@samsung.com>

---

changes:
v3:
 - Simplified the patch comments

v2:
 - extend hybrid poll to async polled io

v1:
 - initial version
---
 include/linux/io_uring_types.h |  14 ++++
 include/uapi/linux/io_uring.h  |   1 +
 io_uring/io_uring.c            |   4 +-
 io_uring/io_uring.h            |   3 +
 io_uring/rw.c                  | 115 ++++++++++++++++++++++++++++++++-
 5 files changed, 135 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 854ad67a5f70..3a75b9904326 100644
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
@@ -571,6 +577,12 @@ static inline void io_kiocb_cmd_sz_check(size_t cmd_sz)
 )
 #define cmd_to_io_kiocb(ptr)	((struct io_kiocb *) ptr)
 
+struct hy_poll_time {
+	int		poll_state;
+	struct timespec64		iopoll_start;
+	struct timespec64		iopoll_end;
+};
+
 struct io_kiocb {
 	union {
 		/*
@@ -641,6 +653,8 @@ struct io_kiocb {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
+	/* for hybrid iopoll */
+	struct hy_poll_time		*hy_poll;
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
index cd9a137ad6ce..2c14768bbe27 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -311,6 +311,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	xa_init(&ctx->poll_array);
 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
@@ -2921,6 +2922,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->poll_array);
 	kfree(ctx);
 }
 
@@ -4050,7 +4052,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY))
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HY_POLL))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d5495710c178..72d6a4c3b46d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -125,6 +125,9 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 	__io_req_task_work_add(req, 0);
 }
 
+/* if sleep time less than 1us, then do not do the schedule op */
+#define MIN_SCHETIME 1000
+
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index d5e79d9bdc71..29c7ce23ed71 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -713,6 +713,46 @@ static bool need_complete_io(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+void init_hybrid_poll(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	/*
+	 * In multiple concurrency, a thread may operate several files
+	 * under different file systems, the inode numbers may be
+	 * duplicated. Each device has a different IO command processing
+	 * capability, so using device number to record the running time
+	 * of device
+	 */
+	u32 index = req->file->f_inode->i_rdev;
+	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);
+	struct hy_poll_time *hpt = kmalloc(sizeof(struct hy_poll_time), GFP_KERNEL);
+
+	/* if alloc fail, go to regular poll */
+	if (!hpt) {
+		ctx->flags &= ~IORING_SETUP_HY_POLL;
+		return;
+	}
+	hpt->poll_state = 0;
+	req->hy_poll = hpt;
+
+	if (!entry) {
+		entry = kmalloc(sizeof(struct iopoll_info), GFP_KERNEL);
+		if (!entry) {
+			ctx->flags &= ~IORING_SETUP_HY_POLL;
+			return;
+		}
+		entry->last_runtime = 0;
+		entry->last_irqtime = 0;
+		xa_store(&ctx->poll_array, index, entry, GFP_KERNEL);
+	}
+
+	/*
+	 * Here we need nanosecond timestamps, some ways of reading
+	 * timestamps directly are only accurate to microseconds, so
+	 * there's no better alternative here for now
+	 */
+	ktime_get_ts64(&hpt->iopoll_start);
+}
+
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -750,6 +790,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
+		if (ctx->flags & IORING_SETUP_HY_POLL)
+			init_hybrid_poll(ctx, req);
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
@@ -1118,6 +1160,75 @@ void io_rw_fail(struct io_kiocb *req)
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
+void io_delay(struct hy_poll_time *hpt, struct iopoll_info *entry)
+{
+	struct hrtimer_sleeper timer;
+	struct timespec64 tc, oldtc;
+	enum hrtimer_mode mode;
+	ktime_t kt;
+	long sleep_ti;
+
+	if (hpt->poll_state == 1)
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
+
+	/*
+	 * If the time available for sleep is too short, i.e. the
+	 * totle running time and the context switching loss time
+	 * are very close to each other, the scheduling operation
+	 * is not performed to avoid increasing latency
+	 */
+	if (sleep_ti < MIN_SCHETIME)
+		return;
+
+	ktime_get_ts64(&oldtc);
+	kt = ktime_set(0, sleep_ti);
+	hpt->poll_state = 1;
+
+	mode = HRTIMER_MODE_REL;
+	hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
+	hrtimer_set_expires(&timer.timer, kt);
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	hrtimer_sleeper_start_expires(&timer, mode);
+
+	if (timer.task)
+		io_schedule();
+
+	hrtimer_cancel(&timer.timer);
+	mode = HRTIMER_MODE_ABS;
+	__set_current_state(TASK_RUNNING);
+	destroy_hrtimer_on_stack(&timer.timer);
+
+	ktime_get_ts64(&tc);
+	entry->last_irqtime = tc.tv_nsec - oldtc.tv_nsec - sleep_ti;
+}
+
+int io_uring_hybrid_poll(struct io_kiocb *req,
+				struct io_comp_batch *iob, unsigned int poll_flags)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct hy_poll_time *hpt = req->hy_poll;
+	u32 index = req->file->f_inode->i_rdev;
+	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);
+	int ret;
+
+	io_delay(hpt, entry);
+	ret = req->file->f_op->iopoll(&rw->kiocb, iob, poll_flags);
+
+	ktime_get_ts64(&hpt->iopoll_end);
+	entry->last_runtime = hpt->iopoll_end.tv_nsec - hpt->iopoll_start.tv_nsec;
+	return ret;
+}
+
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
@@ -1145,7 +1256,9 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
-		if (req->opcode == IORING_OP_URING_CMD) {
+		if (ctx->flags & IORING_SETUP_HY_POLL) {
+			ret = io_uring_hybrid_poll(req, &iob, poll_flags);
+		} else if (req->opcode == IORING_OP_URING_CMD) {
 			struct io_uring_cmd *ioucmd;
 
 			ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-- 
2.40.1


