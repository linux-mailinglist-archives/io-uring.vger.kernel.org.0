Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B5C2654DD
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 00:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgIJWL5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Sep 2020 18:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgIJWLz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Sep 2020 18:11:55 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831BDC061573
        for <io-uring@vger.kernel.org>; Thu, 10 Sep 2020 15:11:55 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id l191so5088803pgd.5
        for <io-uring@vger.kernel.org>; Thu, 10 Sep 2020 15:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=UK1YImjjN9OM5XUt04EcEBlzBu4qhyGeIGE/FROunGg=;
        b=rivKi9GqVCBDAMxrJPjMu9lsUc+VUUzGwht9+7gfHagAmW/1kefbdrVsiHHoI5TJfk
         7BhDI//CQNdUmtMKIeiK/uYrTWpKaigfS5x3BCSWUcgddthWe8MPhw9Pcdq1i0FUsq9o
         xT6VEtKsDs6ORyQY6ULZp6icgSsa14401Y08kJ2gyqQjYGAfBCE2ay1bqsRhvwJEevl3
         BrXblrLI/29BL5vwfblS7Cw+QFVjr9XjYN5e/LjzBwIhn43sI4yksauEU69Gf5Eg+aRf
         TRCFCDmrzln+5CAdE+e7YL797koUVK5dHb6/bu4pE+UN7XopLUhKK9CMbRG7O0/0cc/+
         wL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=UK1YImjjN9OM5XUt04EcEBlzBu4qhyGeIGE/FROunGg=;
        b=mx03W3GTOsoIOyb8yXc5crlzuI+i1o/D5xy6yaOAkzEbAWPAbDFxMIgiWraPIC6B0s
         N5F8FYHTFDmr7r8nhlv8VWjHCOPz0PhHBLqsRRAEIFfRFODxgAH1vLa25+BuUGCEOLZx
         t6tc3MtnqneLuDwVbJbmdm4FCjPGEkIeSSDHGwbQvPUx3kPNIfqZNYQ1XG6xpTKnSpws
         vOqAABtZOzwQu+WTssenexi2/zwnYws4kyqoj3AucHbzTCMLEZig5bLjYK8eZyvPPHfL
         SlwHlDQJln5Em5aKbY05wkgvhGLttZAIy93foNV00gSh4kMh5T7gtP1mjn6ffG4dPn3h
         YbSg==
X-Gm-Message-State: AOAM530DM7Ib65FchGH6FLqkj7dMVKL3c9cV50aIcMKwcQCbBnQ97nzw
        XvPHI8InytHpfxZroNLRcywEpA==
X-Google-Smtp-Source: ABdhPJxD/VGPDHricqtqHwgtvZIzl7++Fh7JF4NrlPPHNPd4Pi/gDGSNTwG9XiKY91vmtEgpa+ti2Q==
X-Received: by 2002:aa7:8b0c:: with SMTP id f12mr7401458pfd.58.1599775914940;
        Thu, 10 Sep 2020 15:11:54 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id fz22sm32008pjb.46.2020.09.10.15.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 15:11:53 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Jann Horn <jannh@google.com>
References: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
 <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com>
 <622649c5-e30d-bc3c-4709-bbe60729cca1@kernel.dk>
 <1c088b17-53bb-0d6d-6573-a1958db88426@kernel.dk>
 <801ed334-54ea-bdee-4d81-34b7e358b506@gmail.com>
 <370c055e-fa8d-0b80-bd34-ba3ba9bc6b37@kernel.dk>
 <74c2802e-788e-d6b2-3ee6-5ef67950dc94@gmail.com>
 <b52f5068-8e03-22a9-cf7d-c3e77fc8282f@kernel.dk>
 <33a6730c-8e0c-e34f-9094-c256a13961cd@gmail.com>
 <163d7844-e2a4-2739-af4e-79f4a3ec9a1d@kernel.dk>
 <73b8038a-eedf-04f7-6991-938512faaee6@kernel.dk>
 <f1c8b60c-a142-70bb-7a3d-03bf6a2106a2@kernel.dk>
Message-ID: <eefc2ece-0beb-c27a-2785-19cf1d6aab92@kernel.dk>
Date:   Thu, 10 Sep 2020 16:11:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f1c8b60c-a142-70bb-7a3d-03bf6a2106a2@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------0244F1EF373A2B67D1B8C320"
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------0244F1EF373A2B67D1B8C320
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 9/10/20 3:01 PM, Jens Axboe wrote:
> On 9/10/20 12:18 PM, Jens Axboe wrote:
>> On 9/10/20 7:11 AM, Jens Axboe wrote:
>>> On 9/10/20 6:37 AM, Pavel Begunkov wrote:
>>>> On 09/09/2020 19:07, Jens Axboe wrote:
>>>>> On 9/9/20 9:48 AM, Pavel Begunkov wrote:
>>>>>> On 09/09/2020 16:10, Jens Axboe wrote:
>>>>>>> On 9/9/20 1:09 AM, Pavel Begunkov wrote:
>>>>>>>> On 09/09/2020 01:54, Jens Axboe wrote:
>>>>>>>>> On 9/8/20 3:22 PM, Jens Axboe wrote:
>>>>>>>>>> On 9/8/20 2:58 PM, Pavel Begunkov wrote:
>>>>>>>>>>> On 08/09/2020 20:48, Jens Axboe wrote:
>>>>>>>>>>>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
>>>>>>>>>>>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
>>>>>>>>>>>> the ring fd/file appropriately so we can defer grab them.
>>>>>>>>>>>
>>>>>>>>>>> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
>>>>>>>>>>> that isn't the case with SQPOLL threads. Am I mistaken?
>>>>>>>>>>>
>>>>>>>>>>> And it looks strange that the following snippet will effectively disable
>>>>>>>>>>> such requests.
>>>>>>>>>>>
>>>>>>>>>>> fd = dup(ring_fd)
>>>>>>>>>>> close(ring_fd)
>>>>>>>>>>> ring_fd = fd
>>>>>>>>>>
>>>>>>>>>> Not disagreeing with that, I think my initial posting made it clear
>>>>>>>>>> it was a hack. Just piled it in there for easier testing in terms
>>>>>>>>>> of functionality.
>>>>>>>>>>
>>>>>>>>>> But the next question is how to do this right...> 
>>>>>>>>> Looking at this a bit more, and I don't necessarily think there's a
>>>>>>>>> better option. If you dup+close, then it just won't work. We have no
>>>>>>>>> way of knowing if the 'fd' changed, but we can detect if it was closed
>>>>>>>>> and then we'll end up just EBADF'ing the requests.
>>>>>>>>>
>>>>>>>>> So right now the answer is that we can support this just fine with
>>>>>>>>> SQPOLL, but you better not dup and close the original fd. Which is not
>>>>>>>>> ideal, but better than NOT being able to support it.
>>>>>>>>>
>>>>>>>>> Only other option I see is to to provide an io_uring_register()
>>>>>>>>> command to update the fd/file associated with it. Which may be useful,
>>>>>>>>> it allows a process to indeed to this, if it absolutely has to.
>>>>>>>>
>>>>>>>> Let's put aside such dirty hacks, at least until someone actually
>>>>>>>> needs it. Ideally, for many reasons I'd prefer to get rid of
>>>>>>>
>>>>>>> BUt it is actually needed, otherwise we're even more in a limbo state of
>>>>>>> "SQPOLL works for most things now, just not all". And this isn't that
>>>>>>> hard to make right - on the flush() side, we just need to park/stall the
>>>>>>
>>>>>> I understand that it isn't hard, but I just don't want to expose it to
>>>>>> the userspace, a) because it's a userspace API, so couldn't probably be
>>>>>> killed in the future, b) works around kernel's problems, and so
>>>>>> shouldn't really be exposed to the userspace in normal circumstances.
>>>>>>
>>>>>> And it's not generic enough because of a possible "many fds -> single
>>>>>> file" mapping, and there will be a lot of questions and problems.
>>>>>>
>>>>>> e.g. if a process shares a io_uring with another process, then
>>>>>> dup()+close() would require not only this hook but also additional
>>>>>> inter-process synchronisation. And so on.
>>>>>
>>>>> I think you're blowing this out of proportion. Just to restate the
>>>>
>>>> I just think that if there is a potentially cleaner solution without
>>>> involving userspace, we should try to look for it first, even if it
>>>> would take more time. That was the point.
>>>
>>> Regardless of whether or not we can eliminate that need, at least it'll
>>> be a relaxing of the restriction, not an increase of it. It'll never
>>> hurt to do an extra system call for the case where you're swapping fds.
>>> I do get your point, I just don't think it's a big deal.
>>
>> BTW, I don't see how we can ever get rid of a need to enter the kernel,
>> we'd need some chance at grabbing the updated ->files, for instance.
>> Might be possible to hold a reference to the task and grab it from
>> there, though feels a bit iffy to hold a task reference from the ring on
>> the task that holds a reference to the ring. Haven't looked too close,
>> should work though as this won't hold a file/files reference, it's just
>> a freeing reference.
> 
> Sort of half assed attempt...
> 
> Idea is to assign a ->files sequence before we grab files, and then
> compare with the current one once we need to use the files. If they
> mismatch, we -ECANCELED the request.
> 
> For SQPOLL, don't grab ->files upfront, grab a reference to the task
> instead. Use the task reference to assign files when we need it.
> 
> Adding Jann to help poke holes in this scheme. I'd be surprised if it's
> solid as-is, but hopefully we can build on this idea and get rid of the
> fcheck().

Split it into two, to make it easier to reason about. Added a few
comments, etc.

-- 
Jens Axboe


--------------0244F1EF373A2B67D1B8C320
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-implement-flush-sequence-to-handle-files-va.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-implement-flush-sequence-to-handle-files-va.pa";
 filename*1="tch"

From 766f5ffcfc9e511c6b26abb8a80e935359a5185f Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 10 Sep 2020 16:06:21 -0600
Subject: [PATCH 2/2] io_uring: implement ->flush() sequence to handle ->files
 validity

The current scheme stashes away ->ring_fd and ->ring_file, and uses
that to check against whether or not ->files could have changed. This
works, but doesn't work so well for SQPOLL. If the application does
close the ring_fd, then we require that applications enter the kernel
to refresh our state.

Add an atomic sequence for the ->flush() count on the ring fd, and if
we get a mismatch between checking this sequence before and after
grabbing the ->files, then we fail the request.

This should offer the same protection that we currently have, with the
added benefit of being able to update the ->files automatically.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 131 +++++++++++++++++++++++++++++---------------------
 1 file changed, 77 insertions(+), 54 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5d0247875237..bf994f195aaf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -308,8 +308,11 @@ struct io_ring_ctx {
 	 */
 	struct fixed_file_data	*file_data;
 	unsigned		nr_user_files;
-	int 			ring_fd;
-	struct file 		*ring_file;
+
+	/* incremented when ->flush() is called */
+	atomic_t		files_seq;
+	/* assigned when ->files are grabbed */
+	int			cur_files_seq;
 
 	/* if used, fixed mapped user buffers */
 	unsigned		nr_user_bufs;
@@ -394,6 +397,7 @@ struct io_close {
 	struct file			*file;
 	struct file			*put_file;
 	int				fd;
+	int				files_seq;
 };
 
 struct io_timeout_data {
@@ -409,6 +413,7 @@ struct io_accept {
 	int __user			*addr_len;
 	int				flags;
 	unsigned long			nofile;
+	int				files_seq;
 };
 
 struct io_sync {
@@ -461,6 +466,7 @@ struct io_sr_msg {
 struct io_open {
 	struct file			*file;
 	int				dfd;
+	int				files_seq;
 	struct filename			*filename;
 	struct open_how			how;
 	unsigned long			nofile;
@@ -471,6 +477,7 @@ struct io_files_update {
 	u64				arg;
 	u32				nr_args;
 	u32				offset;
+	int				files_seq;
 };
 
 struct io_fadvise {
@@ -492,6 +499,7 @@ struct io_epoll {
 	int				epfd;
 	int				op;
 	int				fd;
+	int				files_seq;
 	struct epoll_event		event;
 };
 
@@ -518,6 +526,7 @@ struct io_statx {
 	int				dfd;
 	unsigned int			mask;
 	unsigned int			flags;
+	int				files_seq;
 	const char __user		*filename;
 	struct statx __user		*buffer;
 };
@@ -3860,6 +3869,28 @@ static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock,
 	return 0;
 }
 
+/*
+ * Check that our ->files sequence matches. If files isn't assigned yet,
+ * just store the current sequence. If they are assigned, check against
+ * the sequence from when they got assigned. If we get a mismatch, we fail
+ * the request. This is only applicable to requests that sets ->file_table
+ * in io_op_defs[], indicating that they need access to the file_struct
+ * when executed async.
+ */
+static int io_check_files_seq(struct io_kiocb *req, int *seq)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!req->work.files) {
+		*seq = atomic_read(&ctx->files_seq);
+		return 0;
+	} else if (*seq == ctx->cur_files_seq) {
+		return 0;
+	}
+
+	return -EBADF;
+}
+
 static int io_epoll_ctl_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
@@ -3881,6 +3912,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 			return -EFAULT;
 	}
 
+	req->epoll.files_seq = req->ctx->cur_files_seq;
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3894,10 +3926,15 @@ static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock,
 	struct io_epoll *ie = &req->epoll;
 	int ret;
 
+	ret = io_check_files_seq(req, &ie->files_seq);
+	if (ret)
+		goto done;
+
 	ret = do_epoll_ctl(ie->epfd, ie->op, ie->fd, &ie->event, force_nonblock);
 	if (force_nonblock && ret == -EAGAIN)
 		return -EAGAIN;
 
+done:
 	if (ret < 0)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
@@ -3993,6 +4030,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->statx.filename = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->statx.buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	req->statx.flags = READ_ONCE(sqe->statx_flags);
+	req->statx.files_seq = req->ctx->cur_files_seq;
 
 	return 0;
 }
@@ -4002,6 +4040,10 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 	struct io_statx *ctx = &req->statx;
 	int ret;
 
+	ret = io_check_files_seq(req, &ctx->files_seq);
+	if (ret)
+		goto done;
+
 	if (force_nonblock) {
 		/* only need file table for an actual valid fd */
 		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
@@ -4012,6 +4054,7 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
 		       ctx->buffer);
 
+done:
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_req_complete(req, ret);
@@ -4037,11 +4080,11 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
-	if ((req->file && req->file->f_op == &io_uring_fops) ||
-	    req->close.fd == req->ctx->ring_fd)
+	if (req->file && req->file->f_op == &io_uring_fops)
 		return -EBADF;
 
 	req->close.put_file = NULL;
+	req->close.files_seq = req->ctx->cur_files_seq;
 	return 0;
 }
 
@@ -4051,6 +4094,10 @@ static int io_close(struct io_kiocb *req, bool force_nonblock,
 	struct io_close *close = &req->close;
 	int ret;
 
+	ret = io_check_files_seq(req, &close->files_seq);
+	if (ret)
+		goto done;
+
 	/* might be already done during nonblock submission */
 	if (!close->put_file) {
 		ret = __close_fd_get_file(close->fd, &close->put_file);
@@ -4069,10 +4116,11 @@ static int io_close(struct io_kiocb *req, bool force_nonblock,
 
 	/* No ->flush() or already async, safely close from here */
 	ret = filp_close(close->put_file, req->work.files);
-	if (ret < 0)
-		req_set_fail_links(req);
 	fput(close->put_file);
 	close->put_file = NULL;
+done:
+	if (ret < 0)
+		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
@@ -4526,6 +4574,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
+	accept->files_seq = req->ctx->cur_files_seq;
 	return 0;
 }
 
@@ -4536,6 +4585,10 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock,
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
 	int ret;
 
+	ret = io_check_files_seq(req, &accept->files_seq);
+	if (ret)
+		goto done;
+
 	if (req->file->f_flags & O_NONBLOCK)
 		req->flags |= REQ_F_NOWAIT;
 
@@ -4544,6 +4597,7 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock,
 					accept->nofile);
 	if (ret == -EAGAIN && force_nonblock)
 		return -EAGAIN;
+done:
 	if (ret < 0) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -5513,6 +5567,7 @@ static int io_files_update_prep(struct io_kiocb *req,
 	if (!req->files_update.nr_args)
 		return -EINVAL;
 	req->files_update.arg = READ_ONCE(sqe->addr);
+	req->files_update.files_seq = req->ctx->cur_files_seq;
 	return 0;
 }
 
@@ -5523,6 +5578,10 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 	struct io_uring_files_update up;
 	int ret;
 
+	ret = io_check_files_seq(req, &req->files_update.files_seq);
+	if (ret)
+		goto done;
+
 	if (force_nonblock)
 		return -EAGAIN;
 
@@ -5532,7 +5591,7 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 	mutex_lock(&ctx->uring_lock);
 	ret = __io_sqe_files_update(ctx, &up, req->files_update.nr_args);
 	mutex_unlock(&ctx->uring_lock);
-
+done:
 	if (ret < 0)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
@@ -6118,34 +6177,21 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 
 static int io_grab_files(struct io_kiocb *req)
 {
-	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_req_init_async(req);
 
 	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
 		return 0;
-	if (!ctx->ring_file)
-		return -EBADF;
 
-	rcu_read_lock();
 	spin_lock_irq(&ctx->inflight_lock);
-	/*
-	 * We use the f_ops->flush() handler to ensure that we can flush
-	 * out work accessing these files if the fd is closed. Check if
-	 * the fd has changed since we started down this path, and disallow
-	 * this operation if it has.
-	 */
-	if (fcheck(ctx->ring_fd) == ctx->ring_file) {
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		req->flags |= REQ_F_INFLIGHT;
-		req->work.files = current->files;
-		ret = 0;
-	}
+	list_add(&req->inflight_entry, &ctx->inflight_list);
+	req->flags |= REQ_F_INFLIGHT;
+	ctx->cur_files_seq = atomic_read(&ctx->files_seq);
+	req->work.files = current->files;
 	spin_unlock_irq(&ctx->inflight_lock);
-	rcu_read_unlock();
 
-	return ret;
+	return 0;
 }
 
 static inline int io_prep_work_files(struct io_kiocb *req)
@@ -6705,14 +6751,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		mutex_unlock(&ctx->uring_lock);
 	}
 
-	/*
-	 * If ->ring_file is NULL, we're waiting on new fd/file assigment.
-	 * Don't submit anything new until that happens.
-	 */
-	if (ctx->ring_file)
-		to_submit = io_sqring_entries(ctx);
-	else
-		to_submit = 0;
+	to_submit = io_sqring_entries(ctx);
 
 	/*
 	 * If submit got -EBUSY, flag us as needing the application
@@ -6756,7 +6795,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		}
 
 		to_submit = io_sqring_entries(ctx);
-		if (!to_submit || ret == -EBUSY || !ctx->ring_file)
+		if (!to_submit || ret == -EBUSY)
 			return SQT_IDLE;
 
 		finish_wait(&sqd->wait, &ctx->sqo_wait_entry);
@@ -8547,6 +8586,9 @@ static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 
+	/* assume current files sequence is no longer valid */
+	atomic_inc(&ctx->files_seq);
+
 	io_uring_cancel_files(ctx, data);
 
 	/*
@@ -8558,13 +8600,8 @@ static int io_uring_flush(struct file *file, void *data)
 	} else if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct io_sq_data *sqd = ctx->sq_data;
 
-		/* Ring is being closed, mark us as neding new assignment */
+		/* quiesce sqpoll thread */
 		io_sq_thread_park(sqd);
-		mutex_lock(&ctx->uring_lock);
-		ctx->ring_fd = -1;
-		ctx->ring_file = NULL;
-		mutex_unlock(&ctx->uring_lock);
-		io_ring_set_wakeup_flag(ctx);
 		io_sq_thread_unpark(sqd);
 	}
 
@@ -8701,18 +8738,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		if (!list_empty_careful(&ctx->cq_overflow_list))
 			io_cqring_overflow_flush(ctx, false);
-		if (fd != ctx->ring_fd) {
-			struct io_sq_data *sqd = ctx->sq_data;
-
-			io_sq_thread_park(sqd);
-
-			mutex_lock(&ctx->uring_lock);
-			ctx->ring_fd = fd;
-			ctx->ring_file = f.file;
-			mutex_unlock(&ctx->uring_lock);
-
-			io_sq_thread_unpark(sqd);
-		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT)
@@ -8720,8 +8745,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = to_submit;
 	} else if (to_submit) {
 		mutex_lock(&ctx->uring_lock);
-		ctx->ring_fd = fd;
-		ctx->ring_file = f.file;
 		submitted = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 
-- 
2.28.0


--------------0244F1EF373A2B67D1B8C320
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-stash-ctx-task-reference-instead-of-task-fi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-stash-ctx-task-reference-instead-of-task-fi.pa";
 filename*1="tch"

From e9194eaa20005913b3c39a5c5124c3f803e4074a Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 10 Sep 2020 16:01:15 -0600
Subject: [PATCH 1/2] io_uring: stash ctx task reference instead of task files

We can grab a reference to the task instead of stashing away the task
files_struct. This is doable without creating a circular reference
between the ring fd and the task itself.

This is in preparation for handling the ->files assignment a bit
differently, so we don't need to force SQPOLL to enter the kernel for
an update.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 98cddcc03a16..5d0247875237 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -290,11 +290,10 @@ struct io_ring_ctx {
 	struct io_wq		*io_wq;
 	struct mm_struct	*sqo_mm;
 	/*
-	 * For SQPOLL usage - no reference is held to this file table, we
-	 * rely on fops->flush() and our callback there waiting for the users
-	 * to finish.
+	 * For SQPOLL usage - we hold a reference to the parent task, so we
+	 * have access to the ->files
 	 */
-	struct files_struct	*sqo_files;
+	struct task_struct	*sqo_task;
 
 	struct wait_queue_entry	sqo_wait_entry;
 	struct list_head	sqd_list;
@@ -6824,10 +6823,12 @@ static int io_sq_thread(void *data)
 				old_cred = override_creds(ctx->creds);
 			}
 
-			if (current->files != ctx->sqo_files) {
+			if (current->files != ctx->sqo_task->files) {
+				task_lock(ctx->sqo_task);
 				task_lock(current);
-				current->files = ctx->sqo_files;
+				current->files = ctx->sqo_task->files;
 				task_unlock(current);
+				task_unlock(ctx->sqo_task);
 			}
 
 			ret |= __io_sq_thread(ctx, start_jiffies, cap_entries);
@@ -7148,6 +7149,11 @@ static void io_finish_async(struct io_ring_ctx *ctx)
 		io_wq_destroy(ctx->io_wq);
 		ctx->io_wq = NULL;
 	}
+
+	if (ctx->sqo_task) {
+		put_task_struct(ctx->sqo_task);
+		ctx->sqo_task = NULL;
+	}
 }
 
 #if defined(CONFIG_UNIX)
@@ -7794,11 +7800,11 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		mutex_unlock(&sqd->ctx_lock);
 
 		/*
-		 * We will exit the sqthread before current exits, so we can
-		 * avoid taking a reference here and introducing weird
-		 * circular dependencies on the files table.
+		 * Grab task reference for SQPOLL usage. This doesn't
+		 * introduce a circular reference, as the task reference is
+		 * just to ensure that the struct itself stays valid.
 		 */
-		ctx->sqo_files = current->files;
+		ctx->sqo_task = get_task_struct(current);
 
 		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
 		if (!ctx->sq_thread_idle)
@@ -7840,7 +7846,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 	return 0;
 err:
-	ctx->sqo_files = NULL;
+	if (ctx->sqo_task) {
+		put_task_struct(ctx->sqo_task);
+		ctx->sqo_task = NULL;
+	}
 	io_finish_async(ctx);
 	return ret;
 }
@@ -8554,7 +8563,6 @@ static int io_uring_flush(struct file *file, void *data)
 		mutex_lock(&ctx->uring_lock);
 		ctx->ring_fd = -1;
 		ctx->ring_file = NULL;
-		ctx->sqo_files = NULL;
 		mutex_unlock(&ctx->uring_lock);
 		io_ring_set_wakeup_flag(ctx);
 		io_sq_thread_unpark(sqd);
@@ -8701,7 +8709,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			mutex_lock(&ctx->uring_lock);
 			ctx->ring_fd = fd;
 			ctx->ring_file = f.file;
-			ctx->sqo_files = current->files;
 			mutex_unlock(&ctx->uring_lock);
 
 			io_sq_thread_unpark(sqd);
-- 
2.28.0


--------------0244F1EF373A2B67D1B8C320--
