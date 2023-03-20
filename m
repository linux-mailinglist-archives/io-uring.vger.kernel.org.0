Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBDC6C2311
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 21:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjCTUnv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 16:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCTUnt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 16:43:49 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF52E1A0
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 13:43:00 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id bf15so6032926iob.7
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 13:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679344978;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qB89k+mp21XHp6F57o2ThBPOzJaPAjgc0F9LWJsVUoc=;
        b=iJ25y+acw88tHWJ6mHmb/UfMa0qgt0aF/oC3h3paFs95VnquXmWinHDK9GZUqq2NKq
         41KLKEFYqiggRUQMv0qTUWc3N5lQ7lvABa0bb2r/+1AN7hRVmzATvM/8T7D6WVMNrOs9
         +fPoMnywXk8EVAGi0r9B6hVdPpzh7jYCeiRGUOljcA7MXlkngVmqoVhZfgxqkdL6b5+4
         uTPhtM7dRZNdth3BhxiBKasMwjsIu4xhq7CW4KPOu+yRGsIb6UUMlMRmtMDPPF0UIzLU
         +scXAsHt4AaxV1AaSw4OcakY0qnfZGgdfNt8gCQdAEhBYu4FNXbGJZr0WTfsVUSszXT2
         cv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679344978;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qB89k+mp21XHp6F57o2ThBPOzJaPAjgc0F9LWJsVUoc=;
        b=ezkhSDp2Xv6h35zIxwdW4qzpoHaKwFhVZJPqwzJnYwkSO7ZoFl4GxVdLZ/alnWOkhL
         PgIpcNCOXX5Pg3K2M1Z0twXQG4ZKEjZbfDXFWtxzfkNz7b4bRnj8eRJxuSUvfljxcMs+
         a4TSb6TLVoYVf1fvi7phUVQNMf17Y0PCNMcxovozBtXnsDo8mGbCAJK1sVW+o5y+xJ5e
         zVuWyQn05dRMudURebJvh7GT4KpN36uUJ4pS/4z3RswXcOKDAoR/VoWXCZS+CluVeVeO
         aa6d6Iedkmfol6csiOCYEqZ+JcyJveAMxQY7hUzqsFZPiMzj2+jiVji6lqEJZ8XyppeV
         yVTA==
X-Gm-Message-State: AO0yUKWd195mjxlt3kpzqV46bkF++0rjFoTh/goR0BZAktMsgDi2s9/q
        T6cxvQkRBRKO1WqCxvaWa1dZyQ==
X-Google-Smtp-Source: AK7set/RWp1iOrNIifkeZgjD4ctqTtlAeIxoFqQ4iAMBj9dmxQ269K0+cDHE/rCjsTiNurj1yRFe2A==
X-Received: by 2002:a6b:5f09:0:b0:74e:5fba:d5df with SMTP id t9-20020a6b5f09000000b0074e5fbad5dfmr442709iob.0.1679344977892;
        Mon, 20 Mar 2023 13:42:57 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p5-20020a056638190500b003ff471861a4sm3503494jal.90.2023.03.20.13.42.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 13:42:57 -0700 (PDT)
Message-ID: <b488449b-3acc-35dd-1a44-ef6c8193a08d@kernel.dk>
Date:   Mon, 20 Mar 2023 14:42:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] io_uring/uring_cmd: push IRQ based completions through
 task_work
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
References: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
 <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
 <a3c007ee-f324-df9c-56ae-2356f10d76e6@kernel.dk>
In-Reply-To: <a3c007ee-f324-df9c-56ae-2356f10d76e6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/23 2:03?PM, Jens Axboe wrote:
> On 3/20/23 9:06?AM, Kanchan Joshi wrote:
>> On Sun, Mar 19, 2023 at 8:51?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> This is similar to what we do on the non-passthrough read/write side,
>>> and helps take advantage of the completion batching we can do when we
>>> post CQEs via task_work. On top of that, this avoids a uring_lock
>>> grab/drop for every completion.
>>>
>>> In the normal peak IRQ based testing, this increases performance in
>>> my testing from ~75M to ~77M IOPS, or an increase of 2-3%.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>> index 2e4c483075d3..b4fba5f0ab0d 100644
>>> --- a/io_uring/uring_cmd.c
>>> +++ b/io_uring/uring_cmd.c
>>> @@ -45,18 +45,21 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
>>>  void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
>>>  {
>>>         struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>>> +       struct io_ring_ctx *ctx = req->ctx;
>>>
>>>         if (ret < 0)
>>>                 req_set_fail(req);
>>>
>>>         io_req_set_res(req, ret, 0);
>>> -       if (req->ctx->flags & IORING_SETUP_CQE32)
>>> +       if (ctx->flags & IORING_SETUP_CQE32)
>>>                 io_req_set_cqe32_extra(req, res2, 0);
>>> -       if (req->ctx->flags & IORING_SETUP_IOPOLL)
>>> +       if (ctx->flags & IORING_SETUP_IOPOLL) {
>>>                 /* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>>                 smp_store_release(&req->iopoll_completed, 1);
>>> -       else
>>> -               io_req_complete_post(req, 0);
>>> +               return;
>>> +       }
>>> +       req->io_task_work.func = io_req_task_complete;
>>> +       io_req_task_work_add(req);
>>>  }
>>
>> Since io_uring_cmd_done itself would be executing in task-work often
>> (always in case of nvme), can this be further optimized by doing
>> directly what this new task-work (that is being set up here) would
>> have done?
>> Something like below on top of your patch -
>>
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index e1929f6e5a24..7a764e04f309 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -58,8 +58,12 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd,
>> ssize_t ret, ssize_t res2)
>>                 smp_store_release(&req->iopoll_completed, 1);
>>                 return;
>>         }
>> -       req->io_task_work.func = io_req_task_complete;
>> -       io_req_task_work_add(req);
>> +       if (in_task()) {
>> +               io_req_complete_defer(req);
>> +       } else {
>> +               req->io_task_work.func = io_req_task_complete;
>> +               io_req_task_work_add(req);
>> +       }
>>  }
>>  EXPORT_SYMBOL_GPL(io_uring_cmd_done);
> 
> Good point, though I do think we should rework to pass in the flags
> instead. I'll take a look.

Something like this, totally untested... And this may be more
interesting than it would appear, because the current:

	io_req_complete_post(req, 0);

in io_uring_cmd_done() is passing in that it has the CQ ring locked, but
that does not look like it's guaranteed? So this is more of a
correctness thing first and foremost, more so than an optimization.

Hmm?


diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index d1d1c8d606c8..6615986e976c 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -715,7 +715,7 @@ static void __ublk_fail_req(struct ublk_queue *ubq, struct ublk_io *io,
 	}
 }
 
-static void ubq_complete_io_cmd(struct ublk_io *io, int res)
+static void ubq_complete_io_cmd(struct ublk_io *io, int res, unsigned flags)
 {
 	/* mark this cmd owned by ublksrv */
 	io->flags |= UBLK_IO_FLAG_OWNED_BY_SRV;
@@ -727,7 +727,7 @@ static void ubq_complete_io_cmd(struct ublk_io *io, int res)
 	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
 
 	/* tell ublksrv one io request is coming */
-	io_uring_cmd_done(io->cmd, res, 0);
+	io_uring_cmd_done(io->cmd, res, 0, flags);
 }
 
 #define UBLK_REQUEUE_DELAY_MS	3
@@ -744,7 +744,7 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 	mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
 }
 
-static inline void __ublk_rq_task_work(struct request *req)
+static inline void __ublk_rq_task_work(struct request *req, unsigned issue_flags)
 {
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
 	int tag = req->tag;
@@ -782,7 +782,7 @@ static inline void __ublk_rq_task_work(struct request *req)
 			pr_devel("%s: need get data. op %d, qid %d tag %d io_flags %x\n",
 					__func__, io->cmd->cmd_op, ubq->q_id,
 					req->tag, io->flags);
-			ubq_complete_io_cmd(io, UBLK_IO_RES_NEED_GET_DATA);
+			ubq_complete_io_cmd(io, UBLK_IO_RES_NEED_GET_DATA, issue_flags);
 			return;
 		}
 		/*
@@ -820,17 +820,17 @@ static inline void __ublk_rq_task_work(struct request *req)
 			mapped_bytes >> 9;
 	}
 
-	ubq_complete_io_cmd(io, UBLK_IO_RES_OK);
+	ubq_complete_io_cmd(io, UBLK_IO_RES_OK, issue_flags);
 }
 
-static inline void ublk_forward_io_cmds(struct ublk_queue *ubq)
+static inline void ublk_forward_io_cmds(struct ublk_queue *ubq, unsigned flags)
 {
 	struct llist_node *io_cmds = llist_del_all(&ubq->io_cmds);
 	struct ublk_rq_data *data, *tmp;
 
 	io_cmds = llist_reverse_order(io_cmds);
 	llist_for_each_entry_safe(data, tmp, io_cmds, node)
-		__ublk_rq_task_work(blk_mq_rq_from_pdu(data));
+		__ublk_rq_task_work(blk_mq_rq_from_pdu(data), flags);
 }
 
 static inline void ublk_abort_io_cmds(struct ublk_queue *ubq)
@@ -842,12 +842,12 @@ static inline void ublk_abort_io_cmds(struct ublk_queue *ubq)
 		__ublk_abort_rq(ubq, blk_mq_rq_from_pdu(data));
 }
 
-static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd)
+static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd, unsigned issue_flags)
 {
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	struct ublk_queue *ubq = pdu->ubq;
 
-	ublk_forward_io_cmds(ubq);
+	ublk_forward_io_cmds(ubq, issue_flags);
 }
 
 static void ublk_rq_task_work_fn(struct callback_head *work)
@@ -856,8 +856,9 @@ static void ublk_rq_task_work_fn(struct callback_head *work)
 			struct ublk_rq_data, work);
 	struct request *req = blk_mq_rq_from_pdu(data);
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+	unsigned issue_flags = IO_URING_F_UNLOCKED;
 
-	ublk_forward_io_cmds(ubq);
+	ublk_forward_io_cmds(ubq, issue_flags);
 }
 
 static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
@@ -1111,7 +1112,8 @@ static void ublk_cancel_queue(struct ublk_queue *ubq)
 		struct ublk_io *io = &ubq->ios[i];
 
 		if (io->flags & UBLK_IO_FLAG_ACTIVE)
-			io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0);
+			io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0,
+						IO_URING_F_UNLOCKED);
 	}
 
 	/* all io commands are canceled */
@@ -1351,7 +1353,7 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	return -EIOCBQUEUED;
 
  out:
-	io_uring_cmd_done(cmd, ret, 0);
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
 			__func__, cmd_op, tag, ret, io->flags);
 	return -EIOCBQUEUED;
@@ -2233,7 +2235,7 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (ub)
 		ublk_put_device(ub);
  out:
-	io_uring_cmd_done(cmd, ret, 0);
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: cmd done ret %d cmd_op %x, dev id %d qid %d\n",
 			__func__, ret, cmd->cmd_op, header->dev_id, header->queue_id);
 	return -EIOCBQUEUED;
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 723e7d5b778f..fd547b81d1d2 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -464,7 +464,7 @@ static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
 	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
 }
 
-static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd)
+static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd, unsigned flags)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	struct request *req = pdu->req;
@@ -485,17 +485,17 @@ static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd)
 		blk_rq_unmap_user(req->bio);
 	blk_mq_free_request(req);
 
-	io_uring_cmd_done(ioucmd, status, result);
+	io_uring_cmd_done(ioucmd, status, result, flags);
 }
 
-static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
+static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd, unsigned flags)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
 
-	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->u.result);
+	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->u.result, flags);
 }
 
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
@@ -517,7 +517,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	 * Otherwise, move the completion to task work.
 	 */
 	if (cookie != NULL && blk_rq_is_poll(req))
-		nvme_uring_task_cb(ioucmd);
+		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
 	else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 
@@ -539,7 +539,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req,
 	 * Otherwise, move the completion to task work.
 	 */
 	if (cookie != NULL && blk_rq_is_poll(req))
-		nvme_uring_task_meta_cb(ioucmd);
+		nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
 	else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_meta_cb);
 
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 934e5dd4ccc0..562453edff69 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -27,7 +27,7 @@ struct io_uring_cmd {
 	const void	*cmd;
 	union {
 		/* callback to defer completions to task context */
-		void (*task_work_cb)(struct io_uring_cmd *cmd);
+		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
 		/* used for polled completion */
 		void *cookie;
 	};
@@ -39,9 +39,10 @@ struct io_uring_cmd {
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
-void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
+			unsigned issue_flags);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *));
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
@@ -72,11 +73,11 @@ static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 	return -EOPNOTSUPP;
 }
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
-		ssize_t ret2)
+		ssize_t ret2, bool *locked)
 {
 }
 static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *))
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
 {
 }
 static inline struct sock *io_uring_get_socket(struct file *file)
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 2e4c483075d3..9a1dee571872 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -15,12 +15,13 @@
 static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned issue_flags = *locked ? 0 : IO_URING_F_UNLOCKED;
 
-	ioucmd->task_work_cb(ioucmd);
+	ioucmd->task_work_cb(ioucmd, issue_flags);
 }
 
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *))
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
@@ -42,7 +43,8 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
+		       unsigned issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
@@ -56,7 +58,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
 	else
-		io_req_complete_post(req, 0);
+		io_req_complete_post(req, issue_flags);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 

-- 
Jens Axboe

