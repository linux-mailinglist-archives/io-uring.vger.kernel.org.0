Return-Path: <io-uring+bounces-561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA1284C040
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 23:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E62D1C23F25
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 22:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC52D1C2BC;
	Tue,  6 Feb 2024 22:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Y9fa4IPy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF681C298
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 22:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707260289; cv=none; b=b819xLmD6Bz5MHjrpEPFTv7BZQWgMvhKsRNS7tsWOKbovMP4H/jDWhZ1OsDpLplKqGsCCdegvl14/DwqXfGB/Pdao/9aVNVC7UWt1lFVzyvro919/wocEE4GzMQF+5k2G8QGAfdBowQp3Pc8+qi3cSaPnv1//Qkdf9KOl/us2jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707260289; c=relaxed/simple;
	bh=AKVGw0iOBnQfLEMxIkUiHQ6zXF1NObNZd+V5o4FePOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LS3e7K0SEUW69HsQoSwCnx3wMDc5vfhych/iAOEYZgTJp6eHVTLHDh+JJQcAA4ZEMlnNcGz3vFfXHHfsU4hxCADigEIn06TgwznxTnhixoab61nkkVt7IsbVUk7q2GdXscRq52ZpwdoXoAxTMEkBxoFHxtq6aESU0UfLk37PE44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Y9fa4IPy; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-58962bf3f89so2115164a12.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 14:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707260284; x=1707865084; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X/cEB0RcUsF6VheZ5wCRjTLsN7f70D8WWSRTQzCAfu4=;
        b=Y9fa4IPyF3ZjYOLODMHMmfNCM/Pt3SWQo/L1iGP0HEXPsK3KaoY2lHkK8atvfvzlL8
         wP6mmfA8Hz1gf0yvSbwURuCNnRK6L+V97A+uPJE4kv7CUYkcVhdWqQzpdlBg08hsCqEO
         5OUVZy0bp9EET+RTCZm313+NBOxL9L71NR9mHoAr06uijIcoZZ+w7KC8rbYGIdYmc7MU
         45ucuMw6h8Fx4+LexRKq2yhEyhnoTdjMirwVOxTXcco5HpicAE5J6JOnBcIh1a6vxX7/
         AxeY1X3xqMw+8Umg5Xjid06JrSnUKvdjDRJfWJ5LHhMGONIbai8EuIk2YK6sHtkME5e5
         3J1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707260284; x=1707865084;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X/cEB0RcUsF6VheZ5wCRjTLsN7f70D8WWSRTQzCAfu4=;
        b=NtoLvPN4d7BDH19Yj8eBZ30xHPIadgNcM9bWnx3S/sUd4SG+hVVzQMwwc4tBMFpW0o
         F8XfFZz6ZYp9b05QOb+300WBD4ctKs0BIxyAQrIr2RdJX7/LGos6u+QIMy4PzOOzCJvX
         eRpH6hww7hzTWSttkST172WLvtWUwgsNE1QPLfFvpVpLXYCtotLDyjXOxmb85BLm/wij
         kOwNiyinUDpoDV7fAQq2sh8MA8qDBHYkUWtq6H4HQjIqhU6KPjeviwHJlqJm0YHYwyL6
         fmXTeC+YI5OUBxPQuu98n+YBE50z54I01EOXxMJ8ejRDKyH/A0wm72WXOwiD46tVWaje
         MHhA==
X-Gm-Message-State: AOJu0YzBsAJ87XBwMkXcfxaEEnX3LtF/4D3elTAOaTwdGZcQseMA1IJP
	7RUo6GHVIij89H1zzlqgotA/Uc8Heagv+qkPRz0iA/ToYa3DLYaIpOwVYDTub+LjytF9p9h6VM2
	RSdY=
X-Google-Smtp-Source: AGHT+IEg+7yLrYqUyZ8WTNJMxrL33JdCIjTUlBdVRkELWjqFHajW5ST12WzLfO+8zg4JT3AUqPRVAg==
X-Received: by 2002:a05:6a20:4322:b0:19e:a3be:3d7a with SMTP id h34-20020a056a20432200b0019ea3be3d7amr516504pzk.2.1707260284062;
        Tue, 06 Feb 2024 14:58:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id o71-20020a62cd4a000000b006e04082ad5esm18709pfg.142.2024.02.06.14.58.03
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 14:58:03 -0800 (PST)
Message-ID: <3811d2eb-d8d4-487d-b28d-98771371551f@kernel.dk>
Date: Tue, 6 Feb 2024 15:58:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] io_uring: expand main struct io_kiocb flags to
 64-bits
Content-Language: en-US
To: io-uring@vger.kernel.org
References: <20240206162402.643507-1-axboe@kernel.dk>
 <20240206162402.643507-2-axboe@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240206162402.643507-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 9:22 AM, Jens Axboe wrote:
> We're out of space here, and none of the flags are easily reclaimable.
> Bump it to 64-bits and re-arrange the struct a bit to avoid gaps.
> 
> Add a specific bitwise type for the request flags, io_request_flags_t.
> This will help catch violations of casting this value to a smaller type
> on 32-bit archs, like unsigned int.
> 
> No functional changes intended in this patch.

Looks like I didn't run this through testing after making the 32-bit
change, my bad. Here's v2 of it, no changes to the rest.

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 854ad67a5f70..5aef24ef467b 100644
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
@@ -592,15 +595,14 @@ struct io_kiocb {
 	 * and after selection it points to the buffer ID itself.
 	 */
 	u16				buf_index;
-	unsigned int			flags;
 
-	struct io_cqe			cqe;
+	atomic_t			refs;
+
+	io_req_flags_t			flags;
 
 	struct io_ring_ctx		*ctx;
 	struct task_struct		*task;
 
-	struct io_rsrc_node		*rsrc_node;
-
 	union {
 		/* store used ubuf, so we can prevent reloading */
 		struct io_mapped_ubuf	*imu;
@@ -615,18 +617,23 @@ struct io_kiocb {
 		struct io_buffer_list	*buf_list;
 	};
 
+	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
+	struct hlist_node		hash_node;
+
 	union {
 		/* used by request caches, completion batching and iopoll */
 		struct io_wq_work_node	comp_list;
 		/* cache ->apoll->events */
 		__poll_t apoll_events;
 	};
-	atomic_t			refs;
-	atomic_t			poll_refs;
+
+	struct io_rsrc_node		*rsrc_node;
+
+	struct io_cqe			cqe;
+
 	struct io_task_work		io_task_work;
+	atomic_t			poll_refs;
 	unsigned			nr_tw;
-	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
-	struct hlist_node		hash_node;
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
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
index cd9a137ad6ce..360a7ee41d3a 100644
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
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(u64));
 
 	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
 
-- 
Jens Axboe


