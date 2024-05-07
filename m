Return-Path: <io-uring+bounces-1818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 081C28BF3F8
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 03:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 743891F232AF
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 01:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32EE38F45;
	Wed,  8 May 2024 01:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eqj19y/s"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB38BA50
	for <io-uring@vger.kernel.org>; Wed,  8 May 2024 01:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715131054; cv=none; b=A7uD/iLnEjNMuizBr3XewH2TTcuxouuoJqkciT0vLJKcYpwt2tutcbkWT9v4zCnjIkAUm8u4Q4QDzZTzOACh4oWZ8uKM2ue7snoisF1sfg9b0ybuONYMf3jldpNIXLxi3Mk17rR95E8GBwCkPeimJv4Ycva8sIA2wgdTr5kF9BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715131054; c=relaxed/simple;
	bh=kCo07mCmQKCtOuiRij7SWYzXZ4E9FdxcixjDNaCq57A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=hbLEq3i3NHYgaQ/CrWEyXRlls45Nt19XqYHAsuTtdO1YmvSLTYOdEH3GvccKS1n8s4CS5Zz/ZzYtyMCqlCyor7CTqVPDhxTLcfNojb0lBuDm3FPw1PCoxb1llybGrIWviRNeU3eWQarb8bVWx6eRb6epRQ78h/7K8xkA6akJjG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eqj19y/s; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240508011723epoutp03e14b2dd71835340873d89f0ac9fbad26~NXpjZVVdy0469404694epoutp03p
	for <io-uring@vger.kernel.org>; Wed,  8 May 2024 01:17:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240508011723epoutp03e14b2dd71835340873d89f0ac9fbad26~NXpjZVVdy0469404694epoutp03p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715131043;
	bh=1LXVPAAamQQo0v73q7rn/44JypB1pyXGcPOaVKm0s1Q=;
	h=From:To:Cc:Subject:Date:References:From;
	b=eqj19y/s81YttL5vvEddwn1MNdluTWP7+AQsi5d0ZsLPAPnj7Wv+5SnmK6389ey63
	 yD5IUsiJgoNE8NKEP3dprvJqiU15/CB2YO2eRgYrc0DVJKBVHJ/iTEfjgEi3AgvVf6
	 8n6iJ2TNLmYzxn5UyxhYkFC+46e0AHBHCfQ5OYbw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240508011723epcas5p35fe4ae1bd02bfa1d3a6652e7017d0497~NXpi79jt-1190611906epcas5p3q;
	Wed,  8 May 2024 01:17:23 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VYy1F0pg7z4x9Q1; Wed,  8 May
	2024 01:17:21 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AC.FA.09666.0A2DA366; Wed,  8 May 2024 10:17:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240507091704epcas5p14ae67ce9a9cf6ab8c366d4a99b9a19ef~NKjFD5Vwi2201322013epcas5p1_;
	Tue,  7 May 2024 09:17:04 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240507091704epsmtrp2d0a0a048f6f1fddef5034ae65b760b1c~NKjFCyirN1375513755epsmtrp2G;
	Tue,  7 May 2024 09:17:04 +0000 (GMT)
X-AuditID: b6c32a49-f53fa700000025c2-d7-663ad2a0bc4c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0F.31.08390.091F9366; Tue,  7 May 2024 18:17:04 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240507091702epsmtip156e685531be4ee4044078e3b539161cb~NKjDoeze72566625666epsmtip1G;
	Tue,  7 May 2024 09:17:02 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, ruyi.zhang@samsung.com,
	wenwen.chen@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com,
	hexue <xue01.he@samsung.com>
Subject: [PATCH v3] io_uring: releasing CPU resources when polling
Date: Tue,  7 May 2024 17:16:51 +0800
Message-Id: <20240507091651.2720896-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGJsWRmVeSWpSXmKPExsWy7bCmlu6CS1ZpBo+OWlk0TfjLbDFn1TZG
	i9V3+9ksTv99zGLxrvUci8XR/2/ZLH5132W02PrlK6vF5V1z2Cye7eW0+HL4O7vF2QkfWC2m
	btnBZNHRcpnRouvCKTYHfo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAdyoplCXmlAKFAhKLi5X07WyK8ktL
	UhUy8otLbJVSC1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjOebH3CWrDWq+L/9mUsDYyT
	bLoYOTkkBEwkji4/w9bFyMUhJLCbUWJ3aysrhPOJUaLhyAV2COcbo8SEE0eZYFo+fbgF1bKX
	UeLQwSYWCOcHo8Tmb1tYQarYBJQk9m/5wAhiiwgIS+zvaAUrYhbYziTxbtVWsISwgJNE+4qF
	LCA2i4CqxIY/t8BsXgFrieXnJrNDrJOXuNm1nxkiLihxcuYTsBpmoHjz1tnMIEMlBP6yS9x+
	s40ZosFF4vDhd1C2sMSr41ugBklJfH63lw3CzpeY/H09I4RdI7Fu8zsWCNta4t+VPUA2B9AC
	TYn1u/QhwrISU0+tY4LYyyfR+/sJNCh4JXbMg7GVJJYcWQE1UkLi94RFrBC2h8SuG4/BaoQE
	YiVWtsxmnsAoPwvJO7OQvDMLYfMCRuZVjJKpBcW56anFpgWGeanl8KhNzs/dxAhOsFqeOxjv
	Pvigd4iRiYPxEKMEB7OSCO/RdvM0Id6UxMqq1KL8+KLSnNTiQ4ymwDCeyCwlmpwPTPF5JfGG
	JpYGJmZmZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwaUl/0b1w8ee/E9V3gvZF
	pynUb5otK196/vT9lb+iYyalFrVVu7P7nSn9dmaupIn92R2zOHJOpn1ed1FxOn+bvOCEVZeu
	LFt/bKojm2abj5VnzUtp2TyODyx5GvfWP5oQ3vu8Ya3UmtOWnGeVf99f12W+6zBPlHrCyb13
	1WbrVGZfZ7iUX2Av0atTZfTGIWm/jPxf8Yc6r9S9swJ6WyQV+H88iJubWqvxb7foWmXpIM1I
	Y+mL7R5J0nc2PX79ZM1bbWuHhs/518+6sK4X0VysyfBuc0TAD0+2h66cSS9yQma/ymOKC59h
	yDp177JLM77xX+M+qnBhu49MZfSOqsQjXxPu+Ghm+/6dvHVf0KMUJZbijERDLeai4kQAhJsB
	0TkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnO6Ej5ZpBo+PsVk0TfjLbDFn1TZG
	i9V3+9ksTv99zGLxrvUci8XR/2/ZLH5132W02PrlK6vF5V1z2Cye7eW0+HL4O7vF2QkfWC2m
	btnBZNHRcpnRouvCKTYHfo+ds+6ye1w+W+rRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGU+2
	PmEtWOtV8X/7MpYGxkk2XYycHBICJhKfPtxi62Lk4hAS2M0ocfzrXFaIhITEjkd/oGxhiZX/
	nrNDFH1jlHhz8Ro7SIJNQEli/5YPjCC2CFDR/o5WFpAiZoGjTBLTm56CJYQFnCTaVyxkAbFZ
	BFQlNvy5BWbzClhLLD83mR1ig7zEza79zBBxQYmTM5+A1TADxZu3zmaewMg3C0lqFpLUAkam
	VYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwaGupbWDcc+qD3qHGJk4GA8xSnAwK4nw
	Hm03TxPiTUmsrEotyo8vKs1JLT7EKM3BoiTO++11b4qQQHpiSWp2ampBahFMlomDU6qBSeZj
	1KuSt70X//knHGxiFcpZtS+WrYm5zdpwgbHriT4vvY3vf2suCRF+8PXH4rKMQEZmQUfeA7fe
	qXyVviRx/IK2NPOh+WwzVq5lMpD7eISXzUrB+endJRPUmJZqZim4BYt2HktNyerL32hYyX4k
	rP5Y679SLeVbi5+yhjpXP8gMe+9k9Eia32a56uk/29XSHc1OztXJ6BRe2vv388Fn9xwlJXIf
	q5QrT23jEz6wJ/ta0WzHH0FHv11KPm+/5Yy3m1Xmq82x/I2CL81UrF6oLnJ89M+56rDIp5di
	SeWT95zRPPR2dswbg6kt5bfnqs4LS8wXv8PpLdZW9uXL/l0tz2Sy/Ow25v3gCtG09QlXYinO
	SDTUYi4qTgQA1HR0uuQCAAA=
X-CMS-MailID: 20240507091704epcas5p14ae67ce9a9cf6ab8c366d4a99b9a19ef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240507091704epcas5p14ae67ce9a9cf6ab8c366d4a99b9a19ef
References: <CGME20240507091704epcas5p14ae67ce9a9cf6ab8c366d4a99b9a19ef@epcas5p1.samsung.com>

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


