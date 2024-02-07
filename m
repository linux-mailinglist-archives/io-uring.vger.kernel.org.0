Return-Path: <io-uring+bounces-575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C709384CFA3
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 18:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EB7F28EA36
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 17:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB94A823B4;
	Wed,  7 Feb 2024 17:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TFqIJnYH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A769823B8
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 17:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326388; cv=none; b=E3ivWpAY4my/689uJKxOsigyzTEfkocA4XQwyDyJbw9Rgmn5dbBZrR48jSliwEPjlQ8tgc9r+3ynS/Uy8sLnadnPwxIBaI+eHTGjzHCtM+8OPv5WbIsn4BTZWUBKtXa2HSHAjVrjyMaKB3gP5401Fu9anJKRU6+1UBtP7brh1zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326388; c=relaxed/simple;
	bh=48Gx8/Jp8WOdUwoot/MAsP5S47K9J5qjBMZcBNaSZWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxtCYiQZ128sLI/t/lV9+vIa+ixp0CK8eeNG3xofs/nyv7XluwglL080uIKI6PUrGA3NxkwfUa78JXNjy55ISQWaRW296AmjeB8090BtrLyb+O46hHBTB0/npymhvX0+TuupxmcfE4wfl5SSAjpHSINvej/K3mrHIPCc1jIX6ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TFqIJnYH; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-361a8f20e22so635555ab.0
        for <io-uring@vger.kernel.org>; Wed, 07 Feb 2024 09:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707326385; x=1707931185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FKB6xz72wVSOfpvPNPF4mIDyX2PnEOtIciWC2C6rd4Q=;
        b=TFqIJnYHCv4tlBG80AU3T7AKyshyqXTrQfnoy2yDB0DIEtlns3JENG2P2O5/U6ecjz
         PZHO8Mbpj+AO4kcNAHUTU53xVFDNFUWr6/2+7+NY18yoi9F1PO4bk1Xq/ROAOie/0kuo
         ISj3faoQfkdXQVPlzwaYjKS3FZ/yVeZFS7+GifdpATpRPumA+J85rNvG4S0jR+0dX/jH
         t239H7zm+z8gxktSYTsikEl2BbNT2RdQ5VjFvHEPIsHeDj/847ceygg47GhvTZ5zCS7X
         Xc0wCH+th0xKYY4IqxW7NMeH0HCei/WMrXnNGKTEUs8Ld9x7zqIZbWHzwi3Zj+fYajOe
         8EnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707326385; x=1707931185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FKB6xz72wVSOfpvPNPF4mIDyX2PnEOtIciWC2C6rd4Q=;
        b=UtaTH0QErVK/6wBhkOJJLdUNlXiX/eNfeWlC/HQcVcbiYnIC/gSW+ReyWOradkhA8N
         x7FnnrrBC4YzGbdJ0Mj1Q3AmWkEVPA14wjyfOqG6A4tZrL4BaobrvIpCf9XR3W8Bu/S0
         +13P8jB0TiHPVmlOuNxlYSu1pqxM4aiRFQmL5HeX2LmfMhU3273t1O0y1oXnD/Of3+M8
         dPvZTKQAW6ptTwo3mPdXn8RI0N7hEbxoKbbtoQqcUvhi/SfeZJXcdKfHLmBDmMDpmUe/
         woquhmAh6zRjhwXqubpucRJhc/+d0AuZ3gBIMCP/FLQTz8aO5GJ2S9e1CYYObnGKeuNw
         89wQ==
X-Gm-Message-State: AOJu0YzKNqh/QsVbiyosi1K+oeTj8YF7/ZdB8yDOdcKkwz2+qbfjzPsD
	KJgoTRGu7UWe3TjaPQLh7CH1NLx4xbsgoPy8+ibrrMUckLTAzgxdp8ue/GAyXD9xsycMq071ABQ
	VaKw=
X-Google-Smtp-Source: AGHT+IHAqgQycM8yIy9Gu20gr+5BC3KJssjmO1JDIZG9dvxVVKbyvE25xJH7BnAy53NRquwVUZhRyQ==
X-Received: by 2002:a6b:dc16:0:b0:7c3:f955:ada6 with SMTP id s22-20020a6bdc16000000b007c3f955ada6mr4059750ioc.1.1707326384892;
        Wed, 07 Feb 2024 09:19:44 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g22-20020a6b7616000000b007bc4622d199sm421131iom.22.2024.02.07.09.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 09:19:43 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring: expand main struct io_kiocb flags to 64-bits
Date: Wed,  7 Feb 2024 10:17:35 -0700
Message-ID: <20240207171941.1091453-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240207171941.1091453-1-axboe@kernel.dk>
References: <20240207171941.1091453-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're out of space here, and none of the flags are easily reclaimable.
Bump it to 64-bits and re-arrange the struct a bit to avoid gaps.

Add a specific bitwise type for the request flags, io_request_flags_t.
This will help catch violations of casting this value to a smaller type
on 32-bit archs, like unsigned int.

This creates a hole in the io_kiocb, so move nr_tw up and rsrc_node down
to retain needing only cacheline 0 and 1 for non-polled opcodes.

No functional changes intended in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h  | 77 ++++++++++++++++++---------------
 include/trace/events/io_uring.h | 14 +++---
 io_uring/filetable.h            |  2 +-
 io_uring/io_uring.c             |  9 ++--
 4 files changed, 55 insertions(+), 47 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 854ad67a5f70..56bf733d3ee6 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -468,70 +468,73 @@ enum {
 	__REQ_F_LAST_BIT,
 };
 
+typedef u64 __bitwise io_req_flags_t;
+#define IO_REQ_FLAG(bitno)	((__force io_req_flags_t) BIT_ULL((bitno)))
+
 enum {
 	/* ctx owns file */
-	REQ_F_FIXED_FILE	= BIT(REQ_F_FIXED_FILE_BIT),
+	REQ_F_FIXED_FILE	= IO_REQ_FLAG(REQ_F_FIXED_FILE_BIT),
 	/* drain existing IO first */
-	REQ_F_IO_DRAIN		= BIT(REQ_F_IO_DRAIN_BIT),
+	REQ_F_IO_DRAIN		= IO_REQ_FLAG(REQ_F_IO_DRAIN_BIT),
 	/* linked sqes */
-	REQ_F_LINK		= BIT(REQ_F_LINK_BIT),
+	REQ_F_LINK		= IO_REQ_FLAG(REQ_F_LINK_BIT),
 	/* doesn't sever on completion < 0 */
-	REQ_F_HARDLINK		= BIT(REQ_F_HARDLINK_BIT),
+	REQ_F_HARDLINK		= IO_REQ_FLAG(REQ_F_HARDLINK_BIT),
 	/* IOSQE_ASYNC */
-	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
+	REQ_F_FORCE_ASYNC	= IO_REQ_FLAG(REQ_F_FORCE_ASYNC_BIT),
 	/* IOSQE_BUFFER_SELECT */
-	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
+	REQ_F_BUFFER_SELECT	= IO_REQ_FLAG(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
-	REQ_F_CQE_SKIP		= BIT(REQ_F_CQE_SKIP_BIT),
+	REQ_F_CQE_SKIP		= IO_REQ_FLAG(REQ_F_CQE_SKIP_BIT),
 
 	/* fail rest of links */
-	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
+	REQ_F_FAIL		= IO_REQ_FLAG(REQ_F_FAIL_BIT),
 	/* on inflight list, should be cancelled and waited on exit reliably */
-	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
+	REQ_F_INFLIGHT		= IO_REQ_FLAG(REQ_F_INFLIGHT_BIT),
 	/* read/write uses file position */
-	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
+	REQ_F_CUR_POS		= IO_REQ_FLAG(REQ_F_CUR_POS_BIT),
 	/* must not punt to workers */
-	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
+	REQ_F_NOWAIT		= IO_REQ_FLAG(REQ_F_NOWAIT_BIT),
 	/* has or had linked timeout */
-	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
+	REQ_F_LINK_TIMEOUT	= IO_REQ_FLAG(REQ_F_LINK_TIMEOUT_BIT),
 	/* needs cleanup */
-	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
+	REQ_F_NEED_CLEANUP	= IO_REQ_FLAG(REQ_F_NEED_CLEANUP_BIT),
 	/* already went through poll handler */
-	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
+	REQ_F_POLLED		= IO_REQ_FLAG(REQ_F_POLLED_BIT),
 	/* buffer already selected */
-	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
+	REQ_F_BUFFER_SELECTED	= IO_REQ_FLAG(REQ_F_BUFFER_SELECTED_BIT),
 	/* buffer selected from ring, needs commit */
-	REQ_F_BUFFER_RING	= BIT(REQ_F_BUFFER_RING_BIT),
+	REQ_F_BUFFER_RING	= IO_REQ_FLAG(REQ_F_BUFFER_RING_BIT),
 	/* caller should reissue async */
-	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
+	REQ_F_REISSUE		= IO_REQ_FLAG(REQ_F_REISSUE_BIT),
 	/* supports async reads/writes */
-	REQ_F_SUPPORT_NOWAIT	= BIT(REQ_F_SUPPORT_NOWAIT_BIT),
+	REQ_F_SUPPORT_NOWAIT	= IO_REQ_FLAG(REQ_F_SUPPORT_NOWAIT_BIT),
 	/* regular file */
-	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
+	REQ_F_ISREG		= IO_REQ_FLAG(REQ_F_ISREG_BIT),
 	/* has creds assigned */
-	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
+	REQ_F_CREDS		= IO_REQ_FLAG(REQ_F_CREDS_BIT),
 	/* skip refcounting if not set */
-	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
+	REQ_F_REFCOUNT		= IO_REQ_FLAG(REQ_F_REFCOUNT_BIT),
 	/* there is a linked timeout that has to be armed */
-	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
+	REQ_F_ARM_LTIMEOUT	= IO_REQ_FLAG(REQ_F_ARM_LTIMEOUT_BIT),
 	/* ->async_data allocated */
-	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
+	REQ_F_ASYNC_DATA	= IO_REQ_FLAG(REQ_F_ASYNC_DATA_BIT),
 	/* don't post CQEs while failing linked requests */
-	REQ_F_SKIP_LINK_CQES	= BIT(REQ_F_SKIP_LINK_CQES_BIT),
+	REQ_F_SKIP_LINK_CQES	= IO_REQ_FLAG(REQ_F_SKIP_LINK_CQES_BIT),
 	/* single poll may be active */
-	REQ_F_SINGLE_POLL	= BIT(REQ_F_SINGLE_POLL_BIT),
+	REQ_F_SINGLE_POLL	= IO_REQ_FLAG(REQ_F_SINGLE_POLL_BIT),
 	/* double poll may active */
-	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
+	REQ_F_DOUBLE_POLL	= IO_REQ_FLAG(REQ_F_DOUBLE_POLL_BIT),
 	/* request has already done partial IO */
-	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
+	REQ_F_PARTIAL_IO	= IO_REQ_FLAG(REQ_F_PARTIAL_IO_BIT),
 	/* fast poll multishot mode */
-	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
+	REQ_F_APOLL_MULTISHOT	= IO_REQ_FLAG(REQ_F_APOLL_MULTISHOT_BIT),
 	/* recvmsg special flag, clear EPOLLIN */
-	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
+	REQ_F_CLEAR_POLLIN	= IO_REQ_FLAG(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
-	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
+	REQ_F_HASH_LOCKED	= IO_REQ_FLAG(REQ_F_HASH_LOCKED_BIT),
 	/* don't use lazy poll wake for this request */
-	REQ_F_POLL_NO_LAZY	= BIT(REQ_F_POLL_NO_LAZY_BIT),
+	REQ_F_POLL_NO_LAZY	= IO_REQ_FLAG(REQ_F_POLL_NO_LAZY_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
@@ -592,15 +595,17 @@ struct io_kiocb {
 	 * and after selection it points to the buffer ID itself.
 	 */
 	u16				buf_index;
-	unsigned int			flags;
+
+	unsigned			nr_tw;
+
+	/* REQ_F_* flags */
+	io_req_flags_t			flags;
 
 	struct io_cqe			cqe;
 
 	struct io_ring_ctx		*ctx;
 	struct task_struct		*task;
 
-	struct io_rsrc_node		*rsrc_node;
-
 	union {
 		/* store used ubuf, so we can prevent reloading */
 		struct io_mapped_ubuf	*imu;
@@ -621,10 +626,12 @@ struct io_kiocb {
 		/* cache ->apoll->events */
 		__poll_t apoll_events;
 	};
+
+	struct io_rsrc_node		*rsrc_node;
+
 	atomic_t			refs;
 	atomic_t			poll_refs;
 	struct io_task_work		io_task_work;
-	unsigned			nr_tw;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
 	/* internal polling, see IORING_FEAT_FAST_POLL */
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 69454f1f98b0..3d7704a52b73 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -148,7 +148,7 @@ TRACE_EVENT(io_uring_queue_async_work,
 		__field(  void *,			req		)
 		__field(  u64,				user_data	)
 		__field(  u8,				opcode		)
-		__field(  unsigned int,			flags		)
+		__field(  io_req_flags_t,		flags		)
 		__field(  struct io_wq_work *,		work		)
 		__field(  int,				rw		)
 
@@ -167,10 +167,10 @@ TRACE_EVENT(io_uring_queue_async_work,
 		__assign_str(op_str, io_uring_get_opcode(req->opcode));
 	),
 
-	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%x, %s queue, work %p",
+	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%lx, %s queue, work %p",
 		__entry->ctx, __entry->req, __entry->user_data,
-		__get_str(op_str),
-		__entry->flags, __entry->rw ? "hashed" : "normal", __entry->work)
+		__get_str(op_str), (long) __entry->flags,
+		__entry->rw ? "hashed" : "normal", __entry->work)
 );
 
 /**
@@ -378,7 +378,7 @@ TRACE_EVENT(io_uring_submit_req,
 		__field(  void *,		req		)
 		__field(  unsigned long long,	user_data	)
 		__field(  u8,			opcode		)
-		__field(  u32,			flags		)
+		__field(  io_req_flags_t,	flags		)
 		__field(  bool,			sq_thread	)
 
 		__string( op_str, io_uring_get_opcode(req->opcode) )
@@ -395,10 +395,10 @@ TRACE_EVENT(io_uring_submit_req,
 		__assign_str(op_str, io_uring_get_opcode(req->opcode));
 	),
 
-	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%x, "
+	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%lx, "
 		  "sq_thread %d", __entry->ctx, __entry->req,
 		  __entry->user_data, __get_str(op_str),
-		  __entry->flags, __entry->sq_thread)
+		  (long) __entry->flags, __entry->sq_thread)
 );
 
 /*
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index b47adf170c31..b2435c4dca1f 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -17,7 +17,7 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset);
 int io_register_file_alloc_range(struct io_ring_ctx *ctx,
 				 struct io_uring_file_index_range __user *arg);
 
-unsigned int io_file_get_flags(struct file *file);
+io_req_flags_t io_file_get_flags(struct file *file);
 
 static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd9a137ad6ce..b8ca907b77eb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1768,9 +1768,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
-unsigned int io_file_get_flags(struct file *file)
+io_req_flags_t io_file_get_flags(struct file *file)
 {
-	unsigned int res = 0;
+	io_req_flags_t res = 0;
 
 	if (S_ISREG(file_inode(file)->i_mode))
 		res |= REQ_F_ISREG;
@@ -2171,7 +2171,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	/* req is partially pre-initialised, see io_preinit_req() */
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
-	req->flags = sqe_flags = READ_ONCE(sqe->flags);
+	sqe_flags = READ_ONCE(sqe->flags);
+	req->flags = (io_req_flags_t) sqe_flags;
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
 	req->rsrc_node = NULL;
@@ -4153,7 +4154,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(SQE_COMMON_FLAGS >= (1 << 8));
 	BUILD_BUG_ON((SQE_VALID_FLAGS | SQE_COMMON_FLAGS) != SQE_VALID_FLAGS);
 
-	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof_field(struct io_kiocb, flags));
 
 	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
 
-- 
2.43.0


