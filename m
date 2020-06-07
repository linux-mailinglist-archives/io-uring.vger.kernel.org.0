Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340AA1F0FE8
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 22:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgFGU7B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 16:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgFGU7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 16:59:00 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F39EC08C5C3
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 13:59:00 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u26so12907340wmn.1
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2020 13:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NZLiQfR5NOXB7nFP3mrlbc8XStqu2T3JsgS9H/cDvAI=;
        b=ohdCOdQUuOB3hyzrWjQUQAC16ypLuJ/b7txdW7nG/i9QA8Kt/n9SGmzvyLw1C9+C0h
         VtFYjSP62aLzrMgeMnWa6cTDAaG5clJYav14ph4Qs1ZM5KYmMhTnUHPA5yKg7Di1gH4T
         ePEYcA6ku5awX3tgt27TOJITvZcd82MAyeqK5sEAIQagGpgwF0O6jz74v7EF8c5F5Al+
         ZDFnRiIE7VeHjeQV9PpoKLrpX5BOcy3dovxPVstIZqTJL2wQOOLowl/g3VG65BGPHxr9
         K9QiOWkWsidvvGll6qguXJEtGYVED6bZVY0fGh2QCnUsOfZvvjL8488zPL9a6SABCQkw
         9Ysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NZLiQfR5NOXB7nFP3mrlbc8XStqu2T3JsgS9H/cDvAI=;
        b=iKWcupSGeMc/ddjUyF7GfsIAyfsHUyUcgfS1ByJnr6yRfImEZ2z6WIYLegVgxS3vNt
         OnJK5fWTLLE8ctSMkHUgvEtZeN9uff+GRK7QQ3SraX+x3Q3oEGpPmmdTPzjYbp3Wsg2h
         20n/aVjLa1mmo88SFoihiu1xDzW4UlVOEMi9HPVpGGE11Th3PVk8rCzGI+AjC+ZVX5Qr
         36z9bolN7kbbLqpJPI3DdAKdILcz21EMalAYjqj1lbC4Ggf2EwgnCVjKnqNxK3MzX2Vn
         Wr4EgtcnwpM9OOzsqpwPv5HxBeF1zmwxyve4Cpz6VIO32Nb29GCfxkkxW1XOUCCd6igE
         httw==
X-Gm-Message-State: AOAM533FhbjRFrEPhzEbUV8yhup4j86jHq6w5WoNQvdDfLvwTenGsjJi
        aHEPTuOh5u33PIKa8EbvUw0=
X-Google-Smtp-Source: ABdhPJw8kN7Ea74ojjXmxlJV2uq1BDJ4IBNs4jvE0hdufYZnEeQQIibDtofy8ug9oNyMTbXcguhB8g==
X-Received: by 2002:a1c:4808:: with SMTP id v8mr8230054wma.49.1591563538320;
        Sun, 07 Jun 2020 13:58:58 -0700 (PDT)
Received: from [192.168.43.135] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id o15sm20144489wmm.31.2020.06.07.13.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 13:58:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
 <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
 <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
 <8accdc46-53c9-cf89-1e61-51e7c269411c@gmail.com>
 <9f540577-0c13-fa4b-43c1-3c4d7cddcb8c@kernel.dk>
 <13c85adb-6502-f9c7-ed66-9a0adffa2dc8@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v5 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
Message-ID: <570f0f74-82a7-2f10-b186-582380200b15@gmail.com>
Date:   Sun, 7 Jun 2020 23:57:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <13c85adb-6502-f9c7-ed66-9a0adffa2dc8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/06/2020 23:36, Pavel Begunkov wrote:
> On 07/06/2020 18:02, Jens Axboe wrote:
>> On 6/3/20 7:46 AM, Pavel Begunkov wrote:
>>> On 02/06/2020 04:16, Xiaoguang Wang wrote:
>>>> hi Jens, Pavel,
>>>>
>>>> Will you have a look at this V5 version? Or we hold on this patchset, and
>>>> do the refactoring work related io_wq_work firstly.
>>>
>>> It's entirely up to Jens, but frankly, I think it'll bring more bugs than
>>> merits in the current state of things.
>>
>> Well, I'd really like to reduce the overhead where we can, particularly
>> when the overhead just exists to cater to the slow path.
>>
>> Planning on taking the next week off and not do too much, but I'll see
>> if I can get some testing in with the current patches.
>>
> 
> I just think it should not be done at expense of robustness.
> 
> e.g. instead of having tons of if's around ->func, we can get rid of
> it and issue everything with io_wq_submit_work(). And there are plenty
> of pros of doing that:
> - freeing some space in io_kiocb (in req.work in particular)
> - removing much of stuff with nice negative diffstat
> - helping this series
> - even safer than now -- can't be screwed with memcpy(req).
> 
> Extra switch-lookup in io-wq shouldn't even be noticeable considering
> punting overhead. And even though io-wq loses some flexibility, as for
> me that's fine as long as there is only 1 user.

How about diff below? if split and cooked properly.
3 files changed, 73 insertions(+), 164 deletions(-)


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 2bfa9117bc28..a44ad3b98886 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -112,6 +112,7 @@ struct io_wq {
 	unsigned long state;
 
 	free_work_fn *free_work;
+	io_wq_work_fn *do_work;
 
 	struct task_struct *manager;
 	struct user_struct *user;
@@ -528,7 +529,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 			hash = io_get_work_hash(work);
 			linked = old_work = work;
-			linked->func(&linked);
+			wq->do_work(&linked);
 			linked = (old_work == linked) ? NULL : linked;
 
 			work = next_hashed;
@@ -785,7 +786,7 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 		struct io_wq_work *old_work = work;
 
 		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		wq->do_work(&work);
 		work = (work == old_work) ? NULL : work;
 		wq->free_work(old_work);
 	} while (work);
@@ -1027,7 +1028,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	int ret = -ENOMEM, node;
 	struct io_wq *wq;
 
-	if (WARN_ON_ONCE(!data->free_work))
+	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
@@ -1041,6 +1042,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	}
 
 	wq->free_work = data->free_work;
+	wq->do_work = data->do_work;
 
 	/* caller must already hold a reference to this */
 	wq->user = data->user;
@@ -1097,7 +1099,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 bool io_wq_get(struct io_wq *wq, struct io_wq_data *data)
 {
-	if (data->free_work != wq->free_work)
+	if (data->free_work != wq->free_work || data->do_work != wq->do_work)
 		return false;
 
 	return refcount_inc_not_zero(&wq->use_refs);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index df8a4cd3236d..f3bb596f5a3f 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -85,7 +85,6 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 
 struct io_wq_work {
 	struct io_wq_work_node list;
-	void (*func)(struct io_wq_work **);
 	struct files_struct *files;
 	struct mm_struct *mm;
 	const struct cred *creds;
@@ -94,9 +93,9 @@ struct io_wq_work {
 	pid_t task_pid;
 };
 
-#define INIT_IO_WORK(work, _func)				\
+#define INIT_IO_WORK(work)					\
 	do {							\
-		*(work) = (struct io_wq_work){ .func = _func };	\
+		*(work) = (struct io_wq_work){};		\
 	} while (0)						\
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
@@ -108,10 +107,12 @@ static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 }
 
 typedef void (free_work_fn)(struct io_wq_work *);
+typedef void (io_wq_work_fn)(struct io_wq_work **);
 
 struct io_wq_data {
 	struct user_struct *user;
 
+	io_wq_work_fn *do_work;
 	free_work_fn *free_work;
 };
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3aebbf96c123..3bfce882ede5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -541,6 +541,7 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
+	REQ_F_QUEUE_TIMEOUT_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -596,6 +597,8 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* doesn't need file table for this request */
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
+	/* need to queue linked timeout */
+	REQ_F_QUEUE_TIMEOUT	= BIT(REQ_F_QUEUE_TIMEOUT_BIT),
 };
 
 struct async_poll {
@@ -1579,16 +1582,6 @@ static void io_free_req(struct io_kiocb *req)
 		io_queue_async_work(nxt);
 }
 
-static void io_link_work_cb(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *link;
-
-	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
-	io_queue_linked_timeout(link);
-	io_wq_submit_work(workptr);
-}
-
 static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 {
 	struct io_kiocb *link;
@@ -1600,7 +1593,7 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 	*workptr = &nxt->work;
 	link = io_prep_linked_timeout(nxt);
 	if (link)
-		nxt->work.func = io_link_work_cb;
+		nxt->flags |= REQ_F_QUEUE_TIMEOUT;
 }
 
 /*
@@ -2940,23 +2933,15 @@ static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static bool io_req_cancelled(struct io_kiocb *req)
-{
-	if (req->work.flags & IO_WQ_WORK_CANCEL) {
-		req_set_fail_links(req);
-		io_cqring_add_event(req, -ECANCELED);
-		io_put_req(req);
-		return true;
-	}
-
-	return false;
-}
-
-static void __io_fsync(struct io_kiocb *req)
+static int io_fsync(struct io_kiocb *req, bool force_nonblock)
 {
 	loff_t end = req->sync.off + req->sync.len;
 	int ret;
 
+	/* fsync always requires a blocking context */
+	if (force_nonblock)
+		return -EAGAIN;
+
 	ret = vfs_fsync_range(req->file, req->sync.off,
 				end > 0 ? end : LLONG_MAX,
 				req->sync.flags & IORING_FSYNC_DATASYNC);
@@ -2964,53 +2949,9 @@ static void __io_fsync(struct io_kiocb *req)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
 	io_put_req(req);
-}
-
-static void io_fsync_finish(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	if (io_req_cancelled(req))
-		return;
-	__io_fsync(req);
-	io_steal_work(req, workptr);
-}
-
-static int io_fsync(struct io_kiocb *req, bool force_nonblock)
-{
-	/* fsync always requires a blocking context */
-	if (force_nonblock) {
-		req->work.func = io_fsync_finish;
-		return -EAGAIN;
-	}
-	__io_fsync(req);
 	return 0;
 }
 
-static void __io_fallocate(struct io_kiocb *req)
-{
-	int ret;
-
-	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
-	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
-				req->sync.len);
-	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
-	if (ret < 0)
-		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
-}
-
-static void io_fallocate_finish(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	if (io_req_cancelled(req))
-		return;
-	__io_fallocate(req);
-	io_steal_work(req, workptr);
-}
-
 static int io_fallocate_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
@@ -3028,13 +2969,20 @@ static int io_fallocate_prep(struct io_kiocb *req,
 
 static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 {
+	int ret;
+
 	/* fallocate always requiring blocking context */
-	if (force_nonblock) {
-		req->work.func = io_fallocate_finish;
+	if (force_nonblock)
 		return -EAGAIN;
-	}
 
-	__io_fallocate(req);
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
+	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
+				req->sync.len);
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req(req);
 	return 0;
 }
 
@@ -3479,53 +3427,37 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	    req->close.fd == req->ctx->ring_fd)
 		return -EBADF;
 
+	req->close.put_file = NULL;
 	return 0;
 }
 
-/* only called when __close_fd_get_file() is done */
-static void __io_close_finish(struct io_kiocb *req)
-{
-	int ret;
-
-	ret = filp_close(req->close.put_file, req->work.files);
-	if (ret < 0)
-		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	fput(req->close.put_file);
-	io_put_req(req);
-}
-
-static void io_close_finish(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	/* not cancellable, don't do io_req_cancelled() */
-	__io_close_finish(req);
-	io_steal_work(req, workptr);
-}
-
 static int io_close(struct io_kiocb *req, bool force_nonblock)
 {
+	struct io_close *close = &req->close;
 	int ret;
 
-	req->close.put_file = NULL;
-	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
-	if (ret < 0)
-		return (ret == -ENOENT) ? -EBADF : ret;
+	/* might be already done during nonblock submission */
+	if (!close->put_file) {
+		ret = __close_fd_get_file(close->fd, &close->put_file);
+		if (ret < 0)
+			return (ret == -ENOENT) ? -EBADF : ret;
+	}
 
 	/* if the file has a flush method, be safe and punt to async */
-	if (req->close.put_file->f_op->flush && force_nonblock) {
+	if (close->put_file->f_op->flush && force_nonblock) {
 		/* avoid grabbing files - we don't need the files */
 		req->flags |= REQ_F_NO_FILE_TABLE | REQ_F_MUST_PUNT;
-		req->work.func = io_close_finish;
 		return -EAGAIN;
 	}
 
-	/*
-	 * No ->flush(), safely close from here and just punt the
-	 * fput() to async context.
-	 */
-	__io_close_finish(req);
+	/* No ->flush() or already async, safely close from here */
+	ret = filp_close(close->put_file, req->work.files);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	fput(close->put_file);
+	close->put_file = NULL;
+	io_put_req(req);
 	return 0;
 }
 
@@ -3547,38 +3479,20 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static void __io_sync_file_range(struct io_kiocb *req)
+static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 {
 	int ret;
 
+	/* sync_file_range always requires a blocking context */
+	if (force_nonblock)
+		return -EAGAIN;
+
 	ret = sync_file_range(req->file, req->sync.off, req->sync.len,
 				req->sync.flags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
 	io_put_req(req);
-}
-
-
-static void io_sync_file_range_finish(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	if (io_req_cancelled(req))
-		return;
-	__io_sync_file_range(req);
-	io_steal_work(req, workptr);
-}
-
-static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
-{
-	/* sync_file_range always requires a blocking context */
-	if (force_nonblock) {
-		req->work.func = io_sync_file_range_finish;
-		return -EAGAIN;
-	}
-
-	__io_sync_file_range(req);
 	return 0;
 }
 
@@ -4000,49 +3914,27 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int __io_accept(struct io_kiocb *req, bool force_nonblock)
+static int io_accept(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_accept *accept = &req->accept;
-	unsigned file_flags;
+	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
 	int ret;
 
-	file_flags = force_nonblock ? O_NONBLOCK : 0;
 	ret = __sys_accept4_file(req->file, file_flags, accept->addr,
 					accept->addr_len, accept->flags,
 					accept->nofile);
 	if (ret == -EAGAIN && force_nonblock)
 		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-	if (ret < 0)
+	if (ret < 0) {
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
 		req_set_fail_links(req);
+	}
 	io_cqring_add_event(req, ret);
 	io_put_req(req);
 	return 0;
 }
 
-static void io_accept_finish(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	if (io_req_cancelled(req))
-		return;
-	__io_accept(req, false);
-	io_steal_work(req, workptr);
-}
-
-static int io_accept(struct io_kiocb *req, bool force_nonblock)
-{
-	int ret;
-
-	ret = __io_accept(req, force_nonblock);
-	if (ret == -EAGAIN && force_nonblock) {
-		req->work.func = io_accept_finish;
-		return -EAGAIN;
-	}
-	return 0;
-}
-
 static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_connect *conn = &req->connect;
@@ -5434,12 +5326,25 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+static void io_link_work_cb(struct io_kiocb *req)
+{
+	struct io_kiocb *link;
+
+	if (!(req->flags & REQ_F_QUEUE_TIMEOUT))
+		return;
+
+	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
+	io_queue_linked_timeout(link);
+}
+
 static void io_wq_submit_work(struct io_wq_work **workptr)
 {
 	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	int ret = 0;
 
+	io_link_work_cb(req);
+
 	/* if NO_CANCEL is set, we must still run the work */
 	if ((work->flags & (IO_WQ_WORK_CANCEL|IO_WQ_WORK_NO_CANCEL)) ==
 				IO_WQ_WORK_CANCEL) {
@@ -5974,7 +5879,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	refcount_set(&req->refs, 2);
 	req->task = NULL;
 	req->result = 0;
-	INIT_IO_WORK(&req->work, io_wq_submit_work);
+	INIT_IO_WORK(&req->work);
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
@@ -6990,6 +6895,7 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 
 	data.user = ctx->user;
 	data.free_work = io_free_work;
+	data.do_work = io_wq_submit_work;
 
 	if (!(p->flags & IORING_SETUP_ATTACH_WQ)) {
 		/* Do QD, or 4 * CPUS, whatever is smallest */


-- 
Pavel Begunkov
