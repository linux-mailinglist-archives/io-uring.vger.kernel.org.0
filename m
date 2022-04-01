Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF67B4EEEEA
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 16:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346679AbiDAOMt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 10:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346700AbiDAOMt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 10:12:49 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D101D4195
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 07:10:58 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220401141055epoutp01aa0be2d9c90e684289a130d518196a4e~hyxsbsS9m3134431344epoutp01L
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 14:10:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220401141055epoutp01aa0be2d9c90e684289a130d518196a4e~hyxsbsS9m3134431344epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648822255;
        bh=Hc5xXzpwjZD44aIEo0taGOc8FgWd+auSVJeKiNrii9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUSgST9p0mwZsII1/3ypa/76OjR6qFKF3/reBFHJKZML2skNVdTGqMhaJX7Nabu54
         vomR2YIx9A3nP416zZWHjgo72Nn6OoC/RKRQs+CcZittF4Sr/EG+b+vxqe+EWi7h6z
         UJl4SUogglWjJ7peyz5FaX2dHYD+fL4u20cFjRp0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220401141055epcas5p126001f302e40741f0794b91410360257~hyxrvkU-42341723417epcas5p1a;
        Fri,  1 Apr 2022 14:10:55 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KVMXC6mkpz4x9Pv; Fri,  1 Apr
        2022 14:10:51 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.D7.09952.BE707426; Fri,  1 Apr 2022 23:10:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220401110836epcas5p37bd59ab5a48cf77ca3ac05052a164b0b~hwSgjXGRE2406524065epcas5p3Q;
        Fri,  1 Apr 2022 11:08:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220401110836epsmtrp2c483bdfb7743c8fb2683a25a48ff7a68~hwSgia4zx2799827998epsmtrp2t;
        Fri,  1 Apr 2022 11:08:36 +0000 (GMT)
X-AuditID: b6c32a4b-4b5ff700000226e0-14-624707eb70d9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.63.24342.43DD6426; Fri,  1 Apr 2022 20:08:36 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220401110834epsmtip1545bc422309a60c847041436c5dd9a89~hwSe3TavS0870608706epsmtip1y;
        Fri,  1 Apr 2022 11:08:34 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        pankydev8@gmail.com, javier@javigon.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [RFC 4/5] io_uring: add support for big-cqe
Date:   Fri,  1 Apr 2022 16:33:09 +0530
Message-Id: <20220401110310.611869-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401110310.611869-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCJsWRmVeSWpSXmKPExsWy7bCmlu5rdvckg+0PTS2aJvxltpizahuj
        xeq7/WwWK1cfZbJ413qOxaLz9AUmi/NvDzNZzF/2lN3ixoSnjBaHJjczWay5+ZTFgdtj56y7
        7B7NC+6weFw+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ6y9PoW9oM2t4u6V
        uYwNjFcsuhg5OCQETCSe7AEyuTiEBHYzSlyb/ZIRwvnEKLHuwQUo5xujxPuzn1i7GDnBOu69
        uM8MkdjLKHFj5goo5zOjxP8ph5hA5rIJaEpcmFwK0iAiIC/x5fZaFpAaZoFrjBKPXx1iA0kI
        A016vOwVmM0ioCrR/6gFzOYVsJTY0dDIBrFNXmLmpe/sIDangJXEoX8boWoEJU7OfMICYjMD
        1TRvnQ12hITAQg6J9R23GCGaXSRWPn4ANUhY4tXxLewQtpTE53d7oeLJEq3bL7NDAqNEYskC
        dYiwvcTFPX/BfmEG+mX9Ln2IsKzE1FPrmCDW8kn0/n7CBBHnldgxD8ZWlLg36Sk0sMQlHs5Y
        wgox3UNid08EJKh6GSXmTGxmmcCoMAvJN7OQfDMLYfMCRuZVjJKpBcW56anFpgXGeanl8DhO
        zs/dxAhOvlreOxgfPfigd4iRiYPxEKMEB7OSCO/VWNckId6UxMqq1KL8+KLSnNTiQ4ymwOCe
        yCwlmpwPTP95JfGGJpYGJmZmZiaWxmaGSuK8p9I3JAoJpCeWpGanphakFsH0MXFwSjUwCT3c
        tFS78evSkkkVlwy6DwWmXYmti1isHrNXt/vP5LtNiyNC4oLm9nKZPFLbc9yx/NrH6KojPtFn
        ag4tefim+JJHfsxuv87NxjbTFc1eqznIdNZzmNpec/gdEfbV4tLWxq2aRt0nJu4/wdbqv8d1
        JcfbBczLev3NtaUe/80z+seZ9UKzy+6b84Z1X/a+fnGF/cI6zbAD7x62+r1/rr/sWLeN4a5D
        LT93MdX/cFNxU3kmL2l/RN7H63N05r27Sbs/b1TyVd79ccNnE7lZCmJORkkFl0RF9zyS2Fyz
        w2RdNo9Ce0rhS2VZq5/aXStdPxUuTf0boRxaL7BGeIFGU/isY783/xLd9P1v5822aLFtSizF
        GYmGWsxFxYkA1iHVsEcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSnK7JXbckg0c3lSyaJvxltpizahuj
        xeq7/WwWK1cfZbJ413qOxaLz9AUmi/NvDzNZzF/2lN3ixoSnjBaHJjczWay5+ZTFgdtj56y7
        7B7NC+6weFw+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        Ergy1l6fwl7Q5lZx98pcxgbGKxZdjJwcEgImEvde3GfuYuTiEBLYzSjxYkofK0RCXKL52g92
        CFtYYuW/5+wQRR8ZJc4fmcLWxcjBwSagKXFhcilIjYiAosTGj02MIDXMAg8YJe5P/80GkhAG
        2vB42Sswm0VAVaL/UQuYzStgKbGjoZENYoG8xMxL38GWcQpYSRz6txEsLgRUs3/qPBaIekGJ
        kzOfgNnMQPXNW2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxN
        jOAY0dLcwbh91Qe9Q4xMHIyHGCU4mJVEeK/GuiYJ8aYkVlalFuXHF5XmpBYfYpTmYFES573Q
        dTJeSCA9sSQ1OzW1ILUIJsvEwSnVwCR2iZvXZcHVpsk3N6j7qnGw9Qd7TH+pk+HyvXzjnBK+
        27cvfzZZuEFjXe8rRUHhZM2SpNrWWzc/bkt4f+377PfTbmgZCr84cW6WcOzJlPLweJNlhhKv
        d3B+UfhicfLApodN9rbvtZkmXp8kddo76IT405o3x//uuHi8sSZRyC+8fE3L8a+xq0Xjyyq2
        Pb9nrz/lWkWDkL94y/RL8z013pw/lxv2e8OirCKheVvu/Z9vsqFB/9BNpg1cskVN5msD9PwW
        ym35mxMS0iM6rag4Szjgzdv9Qb6u6Wc4J4Xbb/1+66LDRMXrPSvq9ApLdnDEVM92uW/hNe/X
        vT6/1b4Tnz36mRYmW51tULuVcRbLxu9KLMUZiYZazEXFiQC4uOGcAAMAAA==
X-CMS-MailID: 20220401110836epcas5p37bd59ab5a48cf77ca3ac05052a164b0b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220401110836epcas5p37bd59ab5a48cf77ca3ac05052a164b0b
References: <20220401110310.611869-1-joshi.k@samsung.com>
        <CGME20220401110836epcas5p37bd59ab5a48cf77ca3ac05052a164b0b@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add IORING_SETUP_CQE32 flag to allow setting up ring with big-cqe which
is 32 bytes in size. Also modify uring-cmd completion infra to accept
additional result and fill that up in big-cqe.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c                 | 82 +++++++++++++++++++++++++++++------
 include/linux/io_uring.h      | 10 +++--
 include/uapi/linux/io_uring.h | 11 +++++
 3 files changed, 87 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd0e6b102a7b..b819c0ad47fc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -211,8 +211,8 @@ struct io_mapped_ubuf {
 struct io_ring_ctx;
 
 struct io_overflow_cqe {
-	struct io_uring_cqe cqe;
 	struct list_head list;
+	struct io_uring_cqe cqe; /* this must be kept at end */
 };
 
 struct io_fixed_file {
@@ -1713,6 +1713,13 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 		return NULL;
 
 	tail = ctx->cached_cq_tail++;
+
+	/* double index for large CQE */
+	if (ctx->flags & IORING_SETUP_CQE32) {
+		mask = 2 * ctx->cq_entries - 1;
+		tail <<= 1;
+	}
+
 	return &rings->cqes[tail & mask];
 }
 
@@ -1792,13 +1799,16 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	while (!list_empty(&ctx->cq_overflow_list)) {
 		struct io_uring_cqe *cqe = io_get_cqe(ctx);
 		struct io_overflow_cqe *ocqe;
+		int cqeshift = 0;
 
 		if (!cqe && !force)
 			break;
+		/* copy more for big-cqe */
+		cqeshift = ctx->flags & IORING_SETUP_CQE32 ? 1 : 0;
 		ocqe = list_first_entry(&ctx->cq_overflow_list,
 					struct io_overflow_cqe, list);
 		if (cqe)
-			memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
+			memcpy(cqe, &ocqe->cqe, sizeof(*cqe) << cqeshift);
 		else
 			io_account_cq_overflow(ctx);
 
@@ -1884,11 +1894,17 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 }
 
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     s32 res, u32 cflags)
+				     s32 res, u32 cflags, u64 res2,
+				     int bigcqe)
 {
 	struct io_overflow_cqe *ocqe;
+	int size = sizeof(*ocqe);
+
+	/* allocate more for big-cqe */
+	if (bigcqe)
+		size += sizeof(struct io_uring_cqe);
 
-	ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
+	ocqe = kmalloc(size, GFP_ATOMIC | __GFP_ACCOUNT);
 	if (!ocqe) {
 		/*
 		 * If we're in ring overflow flush mode, or in task cancel mode,
@@ -1907,6 +1923,11 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	ocqe->cqe.user_data = user_data;
 	ocqe->cqe.res = res;
 	ocqe->cqe.flags = cflags;
+	if (bigcqe) {
+		struct io_uring_cqe32 *bcqe = (struct io_uring_cqe32 *)&ocqe->cqe;
+
+		bcqe->res2 = res2;
+	}
 	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
 	return true;
 }
@@ -1928,13 +1949,38 @@ static inline bool __fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
 		WRITE_ONCE(cqe->flags, cflags);
 		return true;
 	}
-	return io_cqring_event_overflow(ctx, user_data, res, cflags);
+	return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, false);
 }
 
+static inline bool __fill_big_cqe(struct io_ring_ctx *ctx, u64 user_data,
+				 s32 res, u32 cflags, u64 res2)
+{
+	struct io_uring_cqe32 *bcqe;
+
+	/*
+	 * If we can't get a cq entry, userspace overflowed the
+	 * submission (by quite a lot). Increment the overflow count in
+	 * the ring.
+	 */
+	bcqe = (struct io_uring_cqe32 *) io_get_cqe(ctx);
+	if (likely(bcqe)) {
+		WRITE_ONCE(bcqe->cqe.user_data, user_data);
+		WRITE_ONCE(bcqe->cqe.res, res);
+		WRITE_ONCE(bcqe->cqe.flags, cflags);
+		WRITE_ONCE(bcqe->res2, res2);
+		return true;
+	}
+	return io_cqring_event_overflow(ctx, user_data, res, cflags, res2,
+		       true);
+}
 static inline bool __io_fill_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 {
 	trace_io_uring_complete(req->ctx, req, req->user_data, res, cflags);
-	return __fill_cqe(req->ctx, req->user_data, res, cflags);
+	if (!(req->ctx->flags & IORING_SETUP_CQE32))
+		return __fill_cqe(req->ctx, req->user_data, res, cflags);
+	else
+		return __fill_big_cqe(req->ctx, req->user_data, res, cflags,
+				req->uring_cmd.res2);
 }
 
 static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
@@ -4126,10 +4172,12 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret)
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 {
 	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
 
+	/* store secondary result in res2 */
+	req->uring_cmd.res2 = res2;
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_complete(req, ret);
@@ -4163,7 +4211,7 @@ static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	/* queued async, consumer will call io_uring_cmd_done() when complete */
 	if (ret == -EIOCBQUEUED)
 		return 0;
-	io_uring_cmd_done(ioucmd, ret);
+	io_uring_cmd_done(ioucmd, ret, 0);
 	return 0;
 }
 
@@ -9026,13 +9074,20 @@ static void *io_mem_alloc(size_t size)
 	return (void *) __get_free_pages(gfp_flags, get_order(size));
 }
 
-static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
-				size_t *sq_offset)
+static unsigned long rings_size(struct io_uring_params *p,
+		size_t *sq_offset)
 {
+	unsigned sq_entries, cq_entries;
 	struct io_rings *rings;
 	size_t off, sq_array_size;
 
-	off = struct_size(rings, cqes, cq_entries);
+	sq_entries = p->sq_entries;
+	cq_entries = p->cq_entries;
+
+	if (p->flags & IORING_SETUP_CQE32)
+		off = struct_size(rings, cqes, 2 * cq_entries);
+	else
+		off = struct_size(rings, cqes, cq_entries);
 	if (off == SIZE_MAX)
 		return SIZE_MAX;
 
@@ -10483,7 +10538,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
-	size = rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
+	size = rings_size(p, &sq_array_offset);
 	if (size == SIZE_MAX)
 		return -EOVERFLOW;
 
@@ -10713,7 +10768,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED | IORING_SETUP_SQE128))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SQE128 |
+			IORING_SETUP_CQE32))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index cedc68201469..0aba7b50cde6 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -14,7 +14,10 @@ enum io_uring_cmd_flags {
 
 struct io_uring_cmd {
 	struct file     *file;
-	void            *cmd;
+	union {
+		void            *cmd; /* used on submission */
+		u64		res2; /* used on completion */
+	};
 	/* for irq-completion - if driver requires doing stuff in task-context*/
 	void (*driver_cb)(struct io_uring_cmd *cmd);
 	u32             flags;
@@ -25,7 +28,7 @@ struct io_uring_cmd {
 };
 
 #if defined(CONFIG_IO_URING)
-void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret);
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 			void (*driver_cb)(struct io_uring_cmd *));
 struct sock *io_uring_get_socket(struct file *file);
@@ -48,7 +51,8 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
-static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
+static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
+		ssize_t ret2)
 {
 }
 static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d7a4bdb9bf3b..85b8ff046496 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -113,6 +113,7 @@ enum {
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 #define IORING_SETUP_SQE128	(1U << 7)	/* SQEs are 128b */
+#define IORING_SETUP_CQE32	(1U << 8)	/* CQEs are 32b */
 
 enum {
 	IORING_OP_NOP,
@@ -207,6 +208,16 @@ struct io_uring_cqe {
 	__u32	flags;
 };
 
+/*
+ * If the ring is initializefd with IORING_SETUP_CQE32, we setup large cqe.
+ * Large CQE is created by combining two adjacent regular CQES.
+ */
+struct io_uring_cqe32 {
+	struct io_uring_cqe	cqe;
+	__u64	res2;
+	__u64	unused;
+};
+
 /*
  * cqe->flags
  *
-- 
2.25.1

