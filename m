Return-Path: <io-uring+bounces-1882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2AF8C3A6A
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 05:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE8B41C20C66
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 03:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553B6145B03;
	Mon, 13 May 2024 03:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YbOVl1cv"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FC81C6AF
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 03:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715570493; cv=none; b=naaZvdlS3B+T3JwK3ju39nkNp4bEL79PnTWiMWStkw800jVV7V7apMxv4a+KMkjzEbNAw29A+W+Us9M5g+CoZu6IoVxQ2jYcChuO0u5TtQGyvYHuBH1Ot6z5FZhpa4PDeQvW27s3lSNlSvMefIKh+xIsDkk4zi9x4+PENHKU3lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715570493; c=relaxed/simple;
	bh=uM/CIEdfktRjxWO039dj3uT5yZ8xJY5aenxKOQ/n6qE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=EcoSumEgDzQo4E96KtrGS7nQU6SOSbwNOTAmgxpWQ8qFxnuGxU22HvMHmZcgr4N6x7qHpD4S56dXUG+TsrYtu4eFdO7rckiBjvuEwP0W3fi+hkGJidxTfRpD5gjsUxlwmBQF1UlxM2bPMuRy1+Af6xIIpoUyUIvDrXFcCvYAb40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YbOVl1cv; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240513032127epoutp03c6ea15ba83deded9c4fc57d784e9f8bd~O7kTUjsBs0973309733epoutp03I
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 03:21:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240513032127epoutp03c6ea15ba83deded9c4fc57d784e9f8bd~O7kTUjsBs0973309733epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715570487;
	bh=jJLaIkPrw18gwCyz+Ugie37WZhS2A+BQXTNYk+Cmids=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbOVl1cvhdMGU9wK7zUXuqOyUfPZYrXrEE2FPdF37WsN5waXc7uYXgMv/6jwiOwrT
	 iydgVM6xAT2n9qq7J+ocUq0bv8NhjQ/4GH4cx8X2SgVOdODY4DNuCtdMJTD8TR8bf4
	 7dirVFYw2B3sycqQ1P0CTJL6GFQBOm4p0gDo/pEs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240513032126epcas5p4ae4a6ce7072d18938bd3632a58d0e0df~O7kSAnst70306203062epcas5p4w;
	Mon, 13 May 2024 03:21:26 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Vd4X411cMz4x9Ps; Mon, 13 May
	2024 03:21:24 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	30.1D.09688.43781466; Mon, 13 May 2024 12:21:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240513032056epcas5p22f23ffea6848df3fd07e081a2b0bb659~O7j2TbZIj2885628856epcas5p2_;
	Mon, 13 May 2024 03:20:56 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240513032056epsmtrp22900391b7cccd69acb0cda051c314e4c~O7j2Sa_Ol0326703267epsmtrp2O;
	Mon, 13 May 2024 03:20:56 +0000 (GMT)
X-AuditID: b6c32a4a-5dbff700000025d8-1c-664187344ed8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	37.E7.08390.81781466; Mon, 13 May 2024 12:20:56 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240513032054epsmtip2bffa24e3cdafc4e5f55b79ada1f3b8ff~O7j1BdW0W2094720947epsmtip2b;
	Mon, 13 May 2024 03:20:54 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: anuj20.g@samsung.com, asml.silence@gmail.com, cliang01.li@samsung.com,
	io-uring@vger.kernel.org, joshi.k@samsung.com, kundan.kumar@samsung.com,
	linux-kernel@vger.kernel.org, peiwei.li@samsung.com, ruyi.zhang@samsung.com,
	wenwen.chen@samsung.com, xiaobing.li@samsung.com
Subject: Re: [PATCH v3] io_uring: releasing CPU resources when polling
Date: Mon, 13 May 2024 11:20:49 +0800
Message-Id: <20240513032049.336581-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240507091651.2720896-1-xue01.he@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmuq5Ju2OawdSFLBZNE/4yW8xZtY3R
	YvXdfjaL038fs1i8az3HYnH0/1s2i1/ddxkttn75ympxedccNotnezktvhz+zm5xdsIHVoup
	W3YwWXS0XGZ04PPYOesuu8fls6UefVtWMXp83iQXwBKVbZORmpiSWqSQmpecn5KZl26r5B0c
	7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKKSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4
	xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITvjQ8du1oJ+v4rDD/oZGxiv23cxcnJI
	CJhIvHi5l6mLkYtDSGA3o8TPL3vYIJxPjBLzH01lBqkSEvjGKDG7Sxumo+/4baiOvYwSu67/
	ZodwfjBKPD10mwWkik1ASWL/lg+MILaIgLDE/o5WFpAiZoHpTBLfvzSBJYQF3CSWrv0EtoJF
	QFXi3t3prCA2r4CVxPIv65gh1slL3OzaD2ZzCthITJjUB1UjKHFy5hOwZcxANc1bZzODLJAQ
	mMohsWzra6AnOIAcF4nN/zQh5ghLvDq+hR3ClpL4/G4vG4SdLzH5+3pGCLtGYt3mdywQtrXE
	vyt7WEDGMAtoSqzfpQ8RlpWYemodE8RaPone30+YIOK8EjvmwdhKEkuOrIAaKSHxe8IiVgjb
	Q2L3lUeMkMDqZ5TYvnw14wRGhVlI3pmF5J1ZCKsXMDKvYpRMLSjOTU8tNi0wyksth8dycn7u
	JkZwstXy2sH48MEHvUOMTByMhxglOJiVRHgdCu3ThHhTEiurUovy44tKc1KLDzGaAsN7IrOU
	aHI+MN3nlcQbmlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXAtM7ZryOG
	6ZVFQvXOPf12r4v8lqhWLjop7njxTqzgjSdzvK73M//fUX7v948pu2LM7/1vesO/eXmfRv2y
	A2cuW5ZYry/a93HLpKPHTxR9NJRMMNB1yfvOE7h6SZTpXxHne3VV9cpuB/fMM+LLECu96KzH
	L+wdIFJryu52yT/m6J+nLHdflgotf7y8t+93z+NH87+LP5j3zOnoTbbbzo6Za68fVLyr03mI
	d+sDwdX5TaXCSfVrbJ2c9+SI2EdYH59cztvap1U7e/XFzkb7J3Lv703Ye0yxYNueqfskj384
	cfPztKPGfw8+OXvg8tZFU6e+qpzcnGRlHXrK8LabK1f30uiJxlNnua5R7XB99PTV1xtKLMUZ
	iYZazEXFiQC0ZWDvPwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSvK5Eu2OawY8mLoumCX+ZLeas2sZo
	sfpuP5vF6b+PWSzetZ5jsTj6/y2bxa/uu4wWW798ZbW4vGsOm8WzvZwWXw5/Z7c4O+EDq8XU
	LTuYLDpaLjM68HnsnHWX3ePy2VKPvi2rGD0+b5ILYInisklJzcksSy3St0vgyvjQsZu1oN+v
	4vCDfsYGxuv2XYycHBICJhJ9x28zdTFycQgJ7GaUuL74KwtEQkJix6M/rBC2sMTKf8/ZIYq+
	MUrcPbecCSTBJqAksX/LB0YQWwSoaH9HKwtIEbPAUiaJhvvb2EASwgJuEkvXfmIGsVkEVCXu
	3Z0ONpVXwEpi+Zd1zBAb5CVudu0HszkFbCQmTOoDqxESsJaYsmkzM0S9oMTJmU/ArmMGqm/e
	Opt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBEeEltYOxj2r
	PugdYmTiYDzEKMHBrCTC61BonybEm5JYWZValB9fVJqTWnyIUZqDRUmc99vr3hQhgfTEktTs
	1NSC1CKYLBMHp1QDExOLaoDD3v2PUvcaKpcyv37yNGSPz8WiSe6TTZhjvuk1bc75rP/ZRvHG
	rH9a3Pe003Wi397YqcTV07Vym2RW+qJVPB2rL9oL1uyfWnfO83G9pOZ5kbUlp08uTNTx+67I
	FXL5/0yd76vcPkmsmyH92euKS8TjXY9WP8uLPfZ77kNRY/WtTfw3/hnsuzK526Bm6vWddXev
	Mh+ensjwdOvMwCnqq0MmBhbwti9/W/tGe9X5va+eN69I8lqj51j5v2Ft4xv22YHVaStem+bu
	/Tt73+a1Tl3nj+rt4xU6vFLmVdHizuUaDafvH30x+bDqH2l/Bt2MEJ1cZbvQfo4OkSvPHGKu
	+Mp1/XJf581oKio494sSS3FGoqEWc1FxIgAFOniM9wIAAA==
X-CMS-MailID: 20240513032056epcas5p22f23ffea6848df3fd07e081a2b0bb659
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240513032056epcas5p22f23ffea6848df3fd07e081a2b0bb659
References: <20240507091651.2720896-1-xue01.he@samsung.com>
	<CGME20240513032056epcas5p22f23ffea6848df3fd07e081a2b0bb659@epcas5p2.samsung.com>

On 5/7/24 17:16, hexue wrote:
>This patch is intended to release the CPU resources of io_uring in
>polling mode. When IO is issued, the program immediately polls for
>check completion, which is a waste of CPU resources when IO commands
>are executed on the disk.
>
>I add the hybrid polling feature in io_uring, enables polling to
>release a portion of CPU resources without affecting block layer.
>
>- Record the running time and context switching time of each
>  IO, and use these time to determine whether a process continue
>  to schedule.
>
>- Adaptive adjustment to different devices. Due to the real-time
>  nature of time recording, each device's IO processing speed is
>  different, so the CPU optimization effect will vary.
>
>- Set a interface (ctx->flag) enables application to choose whether
>  or not to use this feature.
>
>The CPU optimization in peak workload of patch is tested as follows:
>  set 8 poll queues
>  all CPU utilization of original polling is 100% for per CPU, after
>  optimization, the CPU utilization drop a lot (per CPU);
>
>   read(128k, QD64, 1Job)     37%   write(128k, QD64, 1Job)     40%
>   randread(4k, QD64, 16Job)  52%   randwrite(4k, QD64, 16Job)  12%
>
>  Compared to original polling, the optimised performance reduction
>  with peak workload within 1%.
>
>   read  0.29%     write  0.51%    randread  0.09%    randwrite  0%
>
>Signed-off-by: hexue <xue01.he@samsung.com>
>
>---
>
>changes:
>v2:
> - extend hybrid poll to async polled io
>
>v1:
> - initial version
>---
> include/linux/io_uring_types.h |  14 ++++
> include/uapi/linux/io_uring.h  |   1 +
> io_uring/io_uring.c            |   4 +-
> io_uring/io_uring.h            |   3 +
> io_uring/rw.c                  | 115 ++++++++++++++++++++++++++++++++-
> 5 files changed, 135 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>index 854ad67a5f70..3a75b9904326 100644
>--- a/include/linux/io_uring_types.h
>+++ b/include/linux/io_uring_types.h
>@@ -224,6 +224,11 @@ struct io_alloc_cache {
> 	size_t			elem_size;
> };
>
>+struct iopoll_info {
>+	long		last_runtime;
>+	long		last_irqtime;
>+};
>+
> struct io_ring_ctx {
> 	/* const or read-mostly hot data */
> 	struct {
>@@ -421,6 +426,7 @@ struct io_ring_ctx {
> 	unsigned short			n_sqe_pages;
> 	struct page			**ring_pages;
> 	struct page			**sqe_pages;
>+	struct xarray		poll_array;
> };
>
> struct io_tw_state {
>@@ -571,6 +577,12 @@ static inline void io_kiocb_cmd_sz_check(size_t cmd_sz)
> )
> #define cmd_to_io_kiocb(ptr)	((struct io_kiocb *) ptr)
>
>+struct hy_poll_time {
>+	int		poll_state;
>+	struct timespec64		iopoll_start;
>+	struct timespec64		iopoll_end;
>+};
>+
> struct io_kiocb {
> 	union {
> 		/*
>@@ -641,6 +653,8 @@ struct io_kiocb {
> 		u64			extra1;
> 		u64			extra2;
> 	} big_cqe;
>+	/* for hybrid iopoll */
>+	struct hy_poll_time		*hy_poll;
> };
>
> struct io_overflow_cqe {
>diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>index 7a673b52827b..0038cdfec18f 100644
>--- a/include/uapi/linux/io_uring.h
>+++ b/include/uapi/linux/io_uring.h
>@@ -198,6 +198,7 @@ enum {
>  * Removes indirection through the SQ index array.
>  */
> #define IORING_SETUP_NO_SQARRAY		(1U << 16)
>+#define IORING_SETUP_HY_POLL	(1U << 17)
>
> enum io_uring_op {
> 	IORING_OP_NOP,
>diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>index cd9a137ad6ce..2c14768bbe27 100644
>--- a/io_uring/io_uring.c
>+++ b/io_uring/io_uring.c
>@@ -311,6 +311,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
> 		goto err;
>
> 	ctx->flags = p->flags;
>+	xa_init(&ctx->poll_array);
> 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
> 	init_waitqueue_head(&ctx->sqo_sq_wait);
> 	INIT_LIST_HEAD(&ctx->sqd_list);
>@@ -2921,6 +2922,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
> 	kfree(ctx->cancel_table_locked.hbs);
> 	kfree(ctx->io_bl);
> 	xa_destroy(&ctx->io_bl_xa);
>+	xa_destroy(&ctx->poll_array);
> 	kfree(ctx);
> }
>
>@@ -4050,7 +4052,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
> 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
> 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
> 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
>-			IORING_SETUP_NO_SQARRAY))
>+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HY_POLL))
> 		return -EINVAL;
>
> 	return io_uring_create(entries, &p, params);
>diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>index d5495710c178..72d6a4c3b46d 100644
>--- a/io_uring/io_uring.h
>+++ b/io_uring/io_uring.h
>@@ -125,6 +125,9 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
> 	__io_req_task_work_add(req, 0);
> }
>
>+/* if sleep time less than 1us, then do not do the schedule op */
>+#define MIN_SCHETIME 1000
>+
> #define io_for_each_link(pos, head) \
> 	for (pos = (head); pos; pos = pos->link)
>
>diff --git a/io_uring/rw.c b/io_uring/rw.c
>index d5e79d9bdc71..29c7ce23ed71 100644
>--- a/io_uring/rw.c
>+++ b/io_uring/rw.c
>@@ -713,6 +713,46 @@ static bool need_complete_io(struct io_kiocb *req)
> 		S_ISBLK(file_inode(req->file)->i_mode);
> }
>
>+void init_hybrid_poll(struct io_ring_ctx *ctx, struct io_kiocb *req)
>+{
>+	/*
>+	 * In multiple concurrency, a thread may operate several files
>+	 * under different file systems, the inode numbers may be
>+	 * duplicated. Each device has a different IO command processing
>+	 * capability, so using device number to record the running time
>+	 * of device
>+	 */
>+	u32 index = req->file->f_inode->i_rdev;
>+	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);
>+	struct hy_poll_time *hpt = kmalloc(sizeof(struct hy_poll_time), GFP_KERNEL);
>+
>+	/* if alloc fail, go to regular poll */
>+	if (!hpt) {
>+		ctx->flags &= ~IORING_SETUP_HY_POLL;
>+		return;
>+	}
>+	hpt->poll_state = 0;
>+	req->hy_poll = hpt;
>+
>+	if (!entry) {
>+		entry = kmalloc(sizeof(struct iopoll_info), GFP_KERNEL);
>+		if (!entry) {
>+			ctx->flags &= ~IORING_SETUP_HY_POLL;
>+			return;
>+		}
>+		entry->last_runtime = 0;
>+		entry->last_irqtime = 0;
>+		xa_store(&ctx->poll_array, index, entry, GFP_KERNEL);
>+	}
>+
>+	/*
>+	 * Here we need nanosecond timestamps, some ways of reading
>+	 * timestamps directly are only accurate to microseconds, so
>+	 * there's no better alternative here for now
>+	 */
>+	ktime_get_ts64(&hpt->iopoll_start);
>+}
>+
> static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
> {
> 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
>@@ -750,6 +790,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
> 		kiocb->ki_flags |= IOCB_HIPRI;
> 		kiocb->ki_complete = io_complete_rw_iopoll;
> 		req->iopoll_completed = 0;
>+		if (ctx->flags & IORING_SETUP_HY_POLL)
>+			init_hybrid_poll(ctx, req);
> 	} else {
> 		if (kiocb->ki_flags & IOCB_HIPRI)
> 			return -EINVAL;
>@@ -1118,6 +1160,75 @@ void io_rw_fail(struct io_kiocb *req)
> 	io_req_set_res(req, res, req->cqe.flags);
> }
>
>+void io_delay(struct hy_poll_time *hpt, struct iopoll_info *entry)
>+{
>+	struct hrtimer_sleeper timer;
>+	struct timespec64 tc, oldtc;
>+	enum hrtimer_mode mode;
>+	ktime_t kt;
>+	long sleep_ti;
>+
>+	if (hpt->poll_state == 1)
>+		return;
>+
>+	if (entry->last_runtime <= entry->last_irqtime)
>+		return;
>+
>+	/*
>+	 * Avoid excessive scheduling time affecting performance
>+	 * by using only 25 per cent of the remaining time
>+	 */
>+	sleep_ti = (entry->last_runtime - entry->last_irqtime) / 4;
>+
>+	/*
>+	 * If the time available for sleep is too short, i.e. the
>+	 * totle running time and the context switching loss time
>+	 * are very close to each other, the scheduling operation
>+	 * is not performed to avoid increasing latency
>+	 */
>+	if (sleep_ti < MIN_SCHETIME)
>+		return;
>+
>+	ktime_get_ts64(&oldtc);
>+	kt = ktime_set(0, sleep_ti);
>+	hpt->poll_state = 1;
>+
>+	mode = HRTIMER_MODE_REL;
>+	hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
>+	hrtimer_set_expires(&timer.timer, kt);
>+	set_current_state(TASK_UNINTERRUPTIBLE);
>+	hrtimer_sleeper_start_expires(&timer, mode);
>+
>+	if (timer.task)
>+		io_schedule();
>+
>+	hrtimer_cancel(&timer.timer);
>+	mode = HRTIMER_MODE_ABS;
>+	__set_current_state(TASK_RUNNING);
>+	destroy_hrtimer_on_stack(&timer.timer);
>+
>+	ktime_get_ts64(&tc);
>+	entry->last_irqtime = tc.tv_nsec - oldtc.tv_nsec - sleep_ti;
>+}
>+
>+int io_uring_hybrid_poll(struct io_kiocb *req,
>+				struct io_comp_batch *iob, unsigned int poll_flags)
>+{
>+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
>+	struct io_ring_ctx *ctx = req->ctx;
>+	struct hy_poll_time *hpt = req->hy_poll;
>+	u32 index = req->file->f_inode->i_rdev;
>+	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);
>+	int ret;
>+
>+	io_delay(hpt, entry);
>+	ret = req->file->f_op->iopoll(&rw->kiocb, iob, poll_flags);
>+
>+	ktime_get_ts64(&hpt->iopoll_end);
>+	entry->last_runtime = hpt->iopoll_end.tv_nsec - hpt->iopoll_start.tv_nsec;
>+	return ret;
>+}
>+
> int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> {
> 	struct io_wq_work_node *pos, *start, *prev;
>@@ -1145,7 +1256,9 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> 		if (READ_ONCE(req->iopoll_completed))
> 			break;
>
>-		if (req->opcode == IORING_OP_URING_CMD) {
>+		if (ctx->flags & IORING_SETUP_HY_POLL) {
>+			ret = io_uring_hybrid_poll(req, &iob, poll_flags);
>+		} else if (req->opcode == IORING_OP_URING_CMD) {
> 			struct io_uring_cmd *ioucmd;
>
> 			ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);

Hi, Jens
I have revised some of the code according to your suggestions,
and added comments to the parts that were not modified.
Do you have any other comments?

--

Xue He

