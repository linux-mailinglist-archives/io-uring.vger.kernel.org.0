Return-Path: <io-uring+bounces-1092-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 860EB87E569
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 10:09:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1308B214A4
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 09:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A392C19B;
	Mon, 18 Mar 2024 09:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PB09b9U0"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15D328E2B
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 09:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710752958; cv=none; b=G07zl/VvGHFMWIh+/lqp579+ZTJMyANicIcazlQUaCtvSPFxbiUQOJDkkWH9k1XoOZ1Af+JryCaEnGX91ADq54o7ZoLt+2wQRj5gNxmkZpR1TV/oVuFNFF+9ysNp1RWkSOUBuirzt2B5JWO0Epzrn3AcIhIkNjOblzzCxuD12Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710752958; c=relaxed/simple;
	bh=aEppG9iaFODNpw+Wt/8CaphvppwlOceD0fDTrKZquVI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=fIuoukWxU5Y8NWYipqHd8IMX15n2Le1NCWn6EFKwU2Mb0slC8MnMtfRYGsL89DdUA6k4KJlULIPQ2DbpJOxtlnJBQ9at5F2lyad1r7aiuk9CYfWqYahuCLdptkCs2+6ZmEdpBZk4P03cBLiUa5VZaYP9zFHQlBMvKofRbmCJY3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PB09b9U0; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240318090037epoutp045e41d5b25f22cbb17431f9c8a82d7ad3~90Ec8VdIt3152831528epoutp04G
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 09:00:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240318090037epoutp045e41d5b25f22cbb17431f9c8a82d7ad3~90Ec8VdIt3152831528epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1710752437;
	bh=G26gc3xc+FDhaQIvlsFcqtDYTkQQusByv+KsYxyx4gY=;
	h=From:To:Cc:Subject:Date:References:From;
	b=PB09b9U0Q0sb8pHoooN9mIKcCRng4JBkl1z6y9kPfoUxa4ZeKdGA3yWsdN368o/bD
	 E0fCnBrDl7EAE9Xl2gQHfDrxwktRgtwc4H1rjUjq1gaIKpeq4ABgQ7SY1dqKwhf5tr
	 VcuaJZYmHl/+WLOuGhr+wJKPoB5w+VRMHBVlllnA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240318090037epcas5p2ca6845581e4d3b1b6e35c8167b3f8b49~90EcQ9ooE1848618486epcas5p2l;
	Mon, 18 Mar 2024 09:00:37 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4TypjH5GZWz4x9Pv; Mon, 18 Mar
	2024 09:00:35 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E9.D0.08600.3B208F56; Mon, 18 Mar 2024 18:00:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240318090025epcas5p452bc7fea225684119c7ebc139787f848~90ERy7VdG1941219412epcas5p4b;
	Mon, 18 Mar 2024 09:00:25 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240318090025epsmtrp21d6fde9ef7a56d7dc787cc3ae4f9f69c~90ERyBZIl0996209962epsmtrp2U;
	Mon, 18 Mar 2024 09:00:25 +0000 (GMT)
X-AuditID: b6c32a44-6c3ff70000002198-9a-65f802b36b98
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	02.3D.08924.9A208F56; Mon, 18 Mar 2024 18:00:25 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240318090024epsmtip17c3f73b7213298467846fc6fb6845fec~90EQD_glS2657326573epsmtip1k;
	Mon, 18 Mar 2024 09:00:23 +0000 (GMT)
From: Xue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com,
	xue01.he@samsung.com
Subject: [PATCH] io_uring: releasing CPU resources when polling
Date: Mon, 18 Mar 2024 17:00:17 +0800
Message-Id: <20240318090017.3959252-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmpu5mph+pBhv2Kls0TfjLbDFn1TZG
	i9V3+9ksTv99zGLxrvUci8XR/2/ZLH5132W02PrlK6vF5V1z2Cye7eW0+HL4O7vF2QkfWC2m
	btnBZNHRcpnRouvCKTYHfo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAdyoplCXmlAKFAhKLi5X07WyK8ktL
	UhUy8otLbJVSC1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjP2zHrGVLAtueLS31ksDYxr
	PbsYOTkkBEwkeg8cYe1i5OIQEtjNKPHz/DJmkISQwCdGiSWzBCAS3xgllm2bzgLT8fgNSBFI
	Yi+jxIWDk1ggnF+MEmcaWxlBqtgEFCTOH/7MBGKLCAhL7O9oBStiFljPJNF09B4bSEJYwF7i
	7Y5WsH0sAqoSFy9eAWvmFbCW2HbvDCvEOnmJ/QfPMkPEBSVOznwCdgYzULx562ywMyQEGjkk
	Dp9+yATR4CLxasIidghbWOLV8S1QtpTE53d72SDsfInJ39czQtg1Eus2v4P6zVri35U9QDYH
	0AJNifW79CHCshJTT61jgtjLJ9H7+wnUKl6JHfNgbCWJJUdWQI2UkPg9YRHU/R4Sr/asYgYZ
	KSQQK/F3Z9oERvlZSL6ZheSbWQiLFzAyr2KUTC0ozk1PTTYtMMxLLYdHbHJ+7iZGcHLVctnB
	eGP+P71DjEwcjIcYJTiYlUR4XcW+pgrxpiRWVqUW5ccXleakFh9iNAUG8URmKdHkfGB6zyuJ
	NzSxNDAxMzMzsTQ2M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgWn17zixa57J+iLt2ypf
	Lu+eHxB/Yo38z5TCD+/3mYV+n3GoY3FJ+twtXQG5598raOr2bjiuduZYfbaXxfSNORv5u95b
	lfadDuIqkTwq96BG8anZu3Wx8g56m26z53SHbxe/11vWwnz+Zg/D/VzplKjn4Ttaip4dXuFj
	VrI5VWnXw7IbO6v2THyk/Uqm7NmUmSt5Ow/7GglE+RW83Tzz4e65OfJsMc62OjqfXTSUP27r
	49y2837eDq7kRq5jCTfE/orVGPMzKcZ0TiqtZE1l7TiYxZvOofBfiLst275dd7vCo7veT3b+
	+RKeeDxfp+s/y+pH057trM08c3xz08end0vC+M2EljUy37h3p95/qhJLcUaioRZzUXEiAHtp
	na83BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnO5Kph+pBr8na1g0TfjLbDFn1TZG
	i9V3+9ksTv99zGLxrvUci8XR/2/ZLH5132W02PrlK6vF5V1z2Cye7eW0+HL4O7vF2QkfWC2m
	btnBZNHRcpnRouvCKTYHfo+ds+6ye1w+W+rRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGXtm
	PWMq2JZccenvLJYGxrWeXYycHBICJhKP3yxj7mLk4hAS2M0o0T5lEzNEQkJix6M/rBC2sMTK
	f8/ZIYp+MEp8a9rGApJgE1CQOH/4MxOILQJUtL+jlQWkiFlgL5PE7a1vwCYJC9hLvN3RCmaz
	CKhKXLx4hRHE5hWwlth27wzUBnmJ/QfPMkPEBSVOznwCtoAZKN68dTbzBEa+WUhSs5CkFjAy
	rWKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECA51Lc0djNtXfdA7xMjEwXiIUYKDWUmE
	11Xsa6oQb0piZVVqUX58UWlOavEhRmkOFiVxXvEXvSlCAumJJanZqakFqUUwWSYOTqkGpmv8
	f0zN6n3T7r03yXdlXFStoLAs9JOo2Y1lPbtO3C7s/lGl/tzhhGums8KWfImejpaIau3Dnav3
	yOjE9FVMurrl027lvj9WPxLuWrU/yv4Q+2FaZZbReoZapY3rJvzJ3DSNIdzFvoXDyPj7hyCv
	bt2rl5f7WS+teXNmg8ff05e4uFm/HhdR6a5P1Ng8OfPGyed//krclfv9/E/5Ls/6PXUGAf9Z
	er5ERRSG7L9VMu2txSMNlqM6T7zOzH6V8zEob37uQXm5tGlMuXYLmnkXiN43CTulsfjEu/U7
	M2bxlT3yXv9m3cVX2458+rNIotV69dait40PJ207o9W892tp6KRT9tddrLbIHQ9vVsi8sViJ
	pTgj0VCLuag4EQAFit8t5AIAAA==
X-CMS-MailID: 20240318090025epcas5p452bc7fea225684119c7ebc139787f848
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240318090025epcas5p452bc7fea225684119c7ebc139787f848
References: <CGME20240318090025epcas5p452bc7fea225684119c7ebc139787f848@epcas5p4.samsung.com>

From: hexue <xue01.he@samsung.com>

This patch is intended to reduce the CPU usage of io_uring in polling
mode. When io_uring is configured to use polling but the
underlying device is not configured with poll queue, this patch is
trying to optimaize the CPU when io_uring is polling for completions
of IOs that will actually be completed via interrupts.

The patch is implemented as follows:
        - Get the poll queue information of the underling device
        in io_uring.

        - If there is no poll queue, IO will be arrive as
        interruption, then io_uring's polling detection will keep
        spinning empty, resulting in a waste of CPU resources,
        so let the process release CPU before IO completes.

        - Record the running time and context switching time of each
        IO, and use these time to determine whether a process continue
        to schedule.
        In specific implementations, applying to consecutive IOs, each
        IO is judged based on the recording time of the previous IO,
        and when the idle time is greater than 1us, it will schedule to
        ensure that the performance is not compromised.

        - Adaptive adjustment to different devices. Due to the real-time
        nature of time recording, each device's IO processing speed is
        different, so the CPU optimization effect will vary, but could
        ensure that the performance will not be degraded.

        - Set a interface enables application to choose whether or not
        to require this feature.
        Add a tag of flag, when the application adds this tag, the
        optimization provided by this patch will only be adopted if
        the above condition is met, i.e., if io_uring is polling and
        the underlying device is not configured with a poll queue,
        which means that the user chooses the CPU low-loss prioritized
        approach for IO. If the application does not set this tag, then
        even if the conditions are met, it will remain the same as
        native io_uring, with no changes or impacts.

The CPU optimization of patch is tested as follows:
        In the case of reaching the peak of the disk's spec, the
        performance is not significantly reduced from native kernel,
        but the CPU usage of per CPU is reduced by about 50% for
        sequential R&W, and by ~80% for Randomwrite.

        This optimization does not affect IO performance in other cases,
        e.g., when both the underlying device and io_uring allow
        polling, performance is not affected by this patch.

                - test tool: Fio 3.35, 8 core VM
                - test method: Run performance tests on bare disks
                and use the htop tool to observe CPU utilization
                - Fio peak workload command:
                  [global]
                  ioengine=io_uring
                  norandommap=1
                  randrepeat=0
                  refill_buffers
                  group_reporting
                  ramp_time=30s
                  time_based
                  runtime=1m
                  filename=/dev/nvme0n1
                  hipri=1
                  direct=1
                  iodepth=64

                  [disk0]                 |     [disk0]
                  bs=4k                   |     bs=128k
                  numjobs=16              |     numjobs=1
                  rw=randread/randwrite   |     rw=read/write

                - Detailed test results
                  |-------------|---------|--------------------|
                  |  rw=read    |  BW/s   |per CPU utilization |
                  |  Native     |  10.9G  |       100%         |
                  |Optimization |  10.8G  |       44%          |

                  |-------------|---------|--------------------|
                  |  rw=write   |  BW/s   |per CPU utilization |
                  |  Native     |  6175   |       100%         |
                  |Optimization |  6150   |       32%          |

                  |-------------|---------|--------------------|
                  | rw=randread |  KIOPS  |per CPU utilization |
                  |  Native     |  1680   |       100%         |
                  |Optimization |  1608   |       100%         |

                  |-------------|---------|--------------------|
                  | rw=randwrite|  KIOPS  |per CPU utilization |
                  |  Native     |   225   |       100%         |
                  |Optimization |   225   |       15%          |

Signed-off-by: hexue <xue01.he@samsung.com>
---
 include/linux/io_uring_types.h | 12 ++++++++
 include/uapi/linux/io_uring.h  |  1 +
 io_uring/io_uring.c            | 47 ++++++++++++++++++++++++++++-
 io_uring/io_uring.h            |  2 ++
 io_uring/rw.c                  | 55 ++++++++++++++++++++++++++++++++++
 5 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 854ad67a5f70..55d22f6e1eb0 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -224,6 +224,12 @@ struct io_alloc_cache {
 	size_t			elem_size;
 };
 
+struct iopoll_info {
+	bool		poll_state;
+	long		last_runtime;
+	long		last_irqtime;
+};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -421,6 +427,7 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+	struct xarray		poll_array;
 };
 
 struct io_tw_state {
@@ -641,6 +648,11 @@ struct io_kiocb {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
+	/* for adaptive iopoll */
+	int				poll_flag;
+	bool			poll_state;
+	struct timespec64		iopoll_start;
+	struct timespec64		iopoll_end;
 };
 
 struct io_overflow_cqe {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7a673b52827b..cd11a7786c51 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -198,6 +198,7 @@ enum {
  * Removes indirection through the SQ index array.
  */
 #define IORING_SETUP_NO_SQARRAY		(1U << 16)
+#define IORING_SETUP_NO_POLLQUEUE	(1U << 17)
 
 enum io_uring_op {
 	IORING_OP_NOP,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd9a137ad6ce..9609acc60868 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -79,6 +79,8 @@
 
 #include <uapi/linux/io_uring.h>
 
+#include <linux/time.h>
+#include <linux/timekeeping.h>
 #include "io-wq.h"
 
 #include "io_uring.h"
@@ -122,6 +124,9 @@
 #define IO_COMPL_BATCH			32
 #define IO_REQ_ALLOC_BATCH		8
 
+#define IO_POLL_QUEUE 1
+#define IO_NO_POLL_QUEUE 0
+
 enum {
 	IO_CHECK_CQ_OVERFLOW_BIT,
 	IO_CHECK_CQ_DROPPED_BIT,
@@ -311,6 +316,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	xa_init(&ctx->poll_array);
 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
@@ -1875,11 +1881,32 @@ static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
 	return !!req->file;
 }
 
+/* Get poll queue information of the device */
+int get_poll_queue_state(struct io_kiocb *req)
+{
+	struct block_device *bdev;
+	struct request_queue *q;
+	struct inode *inode;
+
+	inode = req->file->f_inode;
+	if (!inode->i_rdev)
+		return 1;
+	bdev = blkdev_get_no_open(inode->i_rdev);
+	q = bdev->bd_queue;
+	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags)) {
+		return IO_NO_POLL_QUEUE;
+	} else {
+		return IO_POLL_QUEUE;
+	}
+}
+
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	const struct cred *creds = NULL;
+	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
+	u32 index;
 
 	if (unlikely(!io_assign_file(req, def, issue_flags)))
 		return -EBADF;
@@ -1890,6 +1917,21 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (!def->audit_skip)
 		audit_uring_entry(req->opcode);
 
+	if (ctx->flags & IORING_SETUP_NO_POLLQUEUE) {
+		index = req->file->f_inode->i_rdev;
+		struct iopoll_info *entry = xa_load(&ctx->poll_array, index);
+
+		if (!entry) {
+			entry = kmalloc(sizeof(struct iopoll_info), GFP_KERNEL);
+			entry->poll_state = get_poll_queue_state(req);
+			entry->last_runtime = 0;
+			entry->last_irqtime = 0;
+			xa_store(&ctx->poll_array, index, entry, GFP_KERNEL);
+			}
+		req->poll_state = entry->poll_state;
+		ktime_get_ts64(&req->iopoll_start);
+	}
+
 	ret = def->issue(req, issue_flags);
 
 	if (!def->audit_skip)
@@ -2176,6 +2218,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->file = NULL;
 	req->rsrc_node = NULL;
 	req->task = current;
+	req->poll_flag = 0;
+	req->poll_state = 1;
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
@@ -2921,6 +2965,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->poll_array);
 	kfree(ctx);
 }
 
@@ -4050,7 +4095,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY))
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_NO_POLLQUEUE))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d5495710c178..4281a0bb7ed9 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -125,6 +125,8 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 	__io_req_task_work_add(req, 0);
 }
 
+#define LEFT_TIME 3000
+
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index d5e79d9bdc71..db589a2cf659 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1118,6 +1118,44 @@ void io_rw_fail(struct io_kiocb *req)
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
+	if (entry->last_runtime <= entry->last_irqtime || (entry->last_runtime - entry->last_irqtime) < LEFT_TIME)
+		return;
+
+	req->poll_flag = 1;
+	ktime_get_ts64(&oldtc);
+	sleep_ti = (entry->last_runtime - entry->last_irqtime) / 2;
+	kt = ktime_set(0, sleep_ti);
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
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
@@ -1136,12 +1174,28 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
 		struct file *file = req->file;
 		int ret;
+		u32 index = file->f_inode->i_rdev;
 
 		/*
 		 * Move completed and retryable entries to our local lists.
 		 * If we find a request that requires polling, break out
 		 * and complete those lists first, if we have entries there.
 		 */
+
+		if ((ctx->flags & IORING_SETUP_NO_POLLQUEUE) && !req->poll_state) {
+			struct iopoll_info *entry = xa_load(&ctx->poll_array, index);
+
+			do {
+				if (READ_ONCE(req->iopoll_completed)) {
+					ktime_get_ts64(&req->iopoll_end);
+					entry->last_runtime = req->iopoll_end.tv_nsec - req->iopoll_start.tv_nsec;
+					break;
+				}
+				io_delay(req, entry);
+			} while (1);
+			goto complete;
+		}
+
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
@@ -1172,6 +1226,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	else if (!pos)
 		return 0;
 
+complete:
 	prev = start;
 	wq_list_for_each_resume(pos, prev) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
-- 
2.34.1


