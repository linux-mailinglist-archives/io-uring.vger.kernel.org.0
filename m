Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89D41E1504
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2020 21:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388737AbgEYT7m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 May 2020 15:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390316AbgEYT7m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 May 2020 15:59:42 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2750AC08C5C0
        for <io-uring@vger.kernel.org>; Mon, 25 May 2020 12:59:42 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ci23so300651pjb.5
        for <io-uring@vger.kernel.org>; Mon, 25 May 2020 12:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9QyaJyq91Y21TWm2mWkWyDIqO2sYo0+Z1NrqQRUgE7I=;
        b=ljaUWVc5kIlmJQUxPYKdrG6BE7ChLk5cxtVZHrDO/iKFgRVeR8sCGvDiLiJ7PdjYMq
         skBIof5jY//HbHYTMpHrjUqvSqJnTaRZ2I/DRCmcSLhY7X25HgI2DyEWArWJe8zc1klo
         i2MeTI3lRNAD4GSrXtizBZGz9MZWYzvILEzBSynARIxp/Z+5yJWcdz6Pz8Ur9tmUAbkU
         8VoDQdnPzU0/sjPlZjuzfuqlFF7aVEcVrs5Yoj9Gn6kSZ6w6rMwivhKMWGBthwlWPre0
         viG7280TWn22JpuLyygLzIsUTnbpQCNThKW2khSm64E2PoxFf/ihBqAqoPDH6FWcpGD/
         66Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9QyaJyq91Y21TWm2mWkWyDIqO2sYo0+Z1NrqQRUgE7I=;
        b=HfzHxhck7ZrLQk8kjKWLmsEMm3l6biZKB0T9CCoVzw+QNTq6Eh8fQtTZ9idQdjlpxa
         6EEv2hui3NT9K/wKqPfWdU1PF4Itv6RFX1rtHeI2BMPhj4B4ac7Qh171gURTx1uVqMY+
         yoR46p5xUdFTj8gtG9QgCIFUkivXlbFDFPA7KcUnsus93V2pqYPL1d3qXuUAO0z2JGbn
         sbVKs3S9fyvWsTN9PXRxDaPbfVfx9CePMiAWWB+XB+XoA4YvD6+nriEehW27PMc59T/g
         0/uzKM4jeTOU5Qd56/G59qpJjSAfI7E5VUFzNDzW8/cGYh1OMON08OlB4C4+Bwwhl3vE
         Ouag==
X-Gm-Message-State: AOAM532XpT0BCTAD2mJkeysT8whOeAvY9cqmR5Z7yTw8tG6WHi5bohuK
        4SRjuvxO5dN716zFcQ21UDq7MA==
X-Google-Smtp-Source: ABdhPJyY+QwGKRIjKWxot2txvsWSCPAcuOYNxRHnVVq+NncrgyPaB5T+Hy9x86k3ekiQxKGDgZe9Hg==
X-Received: by 2002:a17:90a:e016:: with SMTP id u22mr22462041pjy.28.1590436780796;
        Mon, 25 May 2020 12:59:40 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:3c00:cb1c:41a3:c8d? ([2605:e000:100e:8c61:3c00:cb1c:41a3:c8d])
        by smtp.gmail.com with ESMTPSA id q25sm13482591pfh.94.2020.05.25.12.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 12:59:40 -0700 (PDT)
Subject: Re: [PATCH 12/12] io_uring: support true async buffered reads, if
 file provides it
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20200523185755.8494-1-axboe@kernel.dk>
 <20200523185755.8494-13-axboe@kernel.dk>
 <8d429d6b-81ee-0a28-8533-2e1d4faa6b37@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <717e474a-5168-8e1e-2e02-c1bdff007bd9@kernel.dk>
Date:   Mon, 25 May 2020 13:59:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <8d429d6b-81ee-0a28-8533-2e1d4faa6b37@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/20 1:29 AM, Pavel Begunkov wrote:
> On 23/05/2020 21:57, Jens Axboe wrote:
>> If the file is flagged with FMODE_BUF_RASYNC, then we don't have to punt
>> the buffered read to an io-wq worker. Instead we can rely on page
>> unlocking callbacks to support retry based async IO. This is a lot more
>> efficient than doing async thread offload.
>>
>> The retry is done similarly to how we handle poll based retry. From
>> the unlock callback, we simply queue the retry to a task_work based
>> handler.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 99 insertions(+)
>>
> ...
>> +
>> +	init_task_work(&rw->task_work, io_async_buf_retry);
>> +	/* submit ref gets dropped, acquire a new one */
>> +	refcount_inc(&req->refs);
>> +	tsk = req->task;
>> +	ret = task_work_add(tsk, &rw->task_work, true);
>> +	if (unlikely(ret)) {
>> +		/* queue just for cancelation */
>> +		init_task_work(&rw->task_work, io_async_buf_cancel);
>> +		tsk = io_wq_get_task(req->ctx->io_wq);
> 
> IIRC, task will be put somewhere around io_free_req(). Then shouldn't here be
> some juggling with reassigning req->task with task_{get,put}()?

Not sure I follow? Yes, we'll put this task again when the request
is freed, but not sure what you mean with juggling?

>> +		task_work_add(tsk, &rw->task_work, true);
>> +	}
>> +	wake_up_process(tsk);
>> +	return 1;
>> +}
> ...
>>  static int io_read(struct io_kiocb *req, bool force_nonblock)
>>  {
>>  	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>> @@ -2601,6 +2696,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>  	if (!ret) {
>>  		ssize_t ret2;
>>  
>> +retry:
>>  		if (req->file->f_op->read_iter)
>>  			ret2 = call_read_iter(req->file, kiocb, &iter);
>>  		else
>> @@ -2619,6 +2715,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>  			if (!(req->flags & REQ_F_NOWAIT) &&
>>  			    !file_can_poll(req->file))
>>  				req->flags |= REQ_F_MUST_PUNT;
>> +			if (io_rw_should_retry(req))
> 
> It looks like a state machine with IOCB_WAITQ and gotos. Wouldn't it be cleaner
> to call call_read_iter()/loop_rw_iter() here directly instead of "goto retry" ?

We could, probably making that part a separate helper then. How about the
below incremental?

> BTW, can this async stuff return -EAGAIN ?

Probably? Prefer not to make any definitive calls on that being possible or
not, as it's sure to disappoint. If it does and IOCB_WAITQ is already set,
then we'll punt to a thread like before.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index a5a4d9602915..669dccd81207 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2677,6 +2677,13 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	return false;
 }
 
+static int __io_read(struct io_kiocb *req, struct iov_iter *iter)
+{
+	if (req->file->f_op->read_iter)
+		return call_read_iter(req->file, &req->rw.kiocb, iter);
+	return loop_rw_iter(READ, req->file, &req->rw.kiocb, iter);
+}
+
 static int io_read(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
@@ -2710,11 +2717,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	if (!ret) {
 		ssize_t ret2;
 
-retry:
-		if (req->file->f_op->read_iter)
-			ret2 = call_read_iter(req->file, kiocb, &iter);
-		else
-			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
+		ret2 = __io_read(req, &iter);
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
@@ -2729,8 +2732,11 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 			if (!(req->flags & REQ_F_NOWAIT) &&
 			    !file_can_poll(req->file))
 				req->flags |= REQ_F_MUST_PUNT;
-			if (io_rw_should_retry(req))
-				goto retry;
+			if (io_rw_should_retry(req)) {
+				ret2 = __io_read(req, &iter);
+				if (ret2 != -EAGAIN)
+					goto out_free;
+			}
 			kiocb->ki_flags &= ~IOCB_WAITQ;
 			return -EAGAIN;
 		}

-- 
Jens Axboe

