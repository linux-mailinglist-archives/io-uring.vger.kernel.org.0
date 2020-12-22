Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98AA2E109D
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 00:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgLVXmV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 18:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgLVXmV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 18:42:21 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F6EC0613D3
        for <io-uring@vger.kernel.org>; Tue, 22 Dec 2020 15:41:41 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id z21so9407647pgj.4
        for <io-uring@vger.kernel.org>; Tue, 22 Dec 2020 15:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f6w1ngW/D5dzNuVRWzneh8yQLANVkxTzQ38BJkhielI=;
        b=1ufC07m0BpyvkmSR56EH5LHU0+P+EmFjuJ7CsY+JMFWlc+jgOEbptpbSFg+R2tl66k
         CC3HdjFj0zKzze8K8mBbhJIdj71Acx4/7f9UWKVoV0NqQJ+nIbUxXfhqnv13zINChMQX
         yxCHmS4y7Dq1pth5QCNZb8lpPwvqYqcuz9mqZrNHtuSvoXSBmcCoRZstKsTN8ER/nsgd
         ioK30JlWsiJR7EJQR7LWhU5Wn99cvGp1o8rjNe+U06EV7ysy3cMrh4bukJJWAnEqx1O4
         fVqXHJ0AZLwRdLdYoU9s3hTp5n/EvmUelzjn338prezvnIVw6DkytQGFhet3E+kN0Dk7
         F7UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f6w1ngW/D5dzNuVRWzneh8yQLANVkxTzQ38BJkhielI=;
        b=k8xBz3xwos7O8sNdaQjjXwTnZKyTbKpFJfPQpfPz6GeYxUrWHmAHk4v+NiOraE9LZR
         7QBlkAhqCexceXdNpoLZP4bcCVvO8QusOLOc+kqBaACdYMEQr30IAz5NAjkJ7Ag0FRzF
         tj2ggh/2pN0V3SiydOenO2qEbeFajDFV+FDcPS01tvimWu4a9TxkIaBx8v7jF8eOOs5e
         C/sqF4lWDLaZBNSADqP2AhpNCqlOhkQtfYytXgvc++Xs8vUwLwhpWzqfDKTHEc2FoZWs
         ckncMjU7XDcBZHU0W7Gyf2AVKJdWgkzQEEJVC7WB1L6Z7go/7N30Ed+LU7j55QHhPOlf
         WWNg==
X-Gm-Message-State: AOAM532EjjIoNnAqajlEJxM8IkyHkm0HwqTWABTqS3ZFeey7QPZJ1oPK
        m4zgB/4kdl+/heHnlJJR7zfAYDYmF7wQ1w==
X-Google-Smtp-Source: ABdhPJzGLqQjdXyYGTNVEi/tysoZFbLc2mXeOMddaxxYHYn7Kb79OfUrbzsInxKpOLX/XUiMOCfp8g==
X-Received: by 2002:a63:d855:: with SMTP id k21mr10914380pgj.399.1608680500413;
        Tue, 22 Dec 2020 15:41:40 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b2sm21001592pff.79.2020.12.22.15.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 15:41:39 -0800 (PST)
Subject: Re: [PATCH] io_uring: hold uring_lock to complete faild polled io in
 io_wq_submit_work()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201214154941.10907-1-xiaoguang.wang@linux.alibaba.com>
 <b82a6652-4895-4669-fb8f-167e5150e9e8@gmail.com>
 <27952c41-111c-b505-e7f1-78b299f4b786@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <78388381-c8cf-a024-457d-1ad31207d2ef@kernel.dk>
Date:   Tue, 22 Dec 2020 16:41:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <27952c41-111c-b505-e7f1-78b299f4b786@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/20 12:36 PM, Pavel Begunkov wrote:
> On 20/12/2020 19:34, Pavel Begunkov wrote:
>> On 14/12/2020 15:49, Xiaoguang Wang wrote:
>>> io_iopoll_complete() does not hold completion_lock to complete polled
>>> io, so in io_wq_submit_work(), we can not call io_req_complete() directly,
>>> to complete polled io, otherwise there maybe concurrent access to cqring,
>>> defer_list, etc, which is not safe. Commit dad1b1242fd5 ("io_uring: always
>>> let io_iopoll_complete() complete polled io") has fixed this issue, but
>>> Pavel reported that IOPOLL apart from rw can do buf reg/unreg requests(
>>> IORING_OP_PROVIDE_BUFFERS or IORING_OP_REMOVE_BUFFERS), so the fix is
>>> not good.
>>>
>>> Given that io_iopoll_complete() is always called under uring_lock, so here
>>> for polled io, we can also get uring_lock to fix this issue.
>>
>> This returns it to the state it was before fixing + mutex locking for
>> IOPOLL, and it's much better than having it half-broken as it is now.
> 
> btw, comments are over 80, but that's minor.

I fixed that up, but I don't particularly like how 'req' is used after
calling complete. How about the below variant - same as before, just
using the ctx instead to determine if we need to lock it or not.


commit 253b60e7d8adcb980be91f77e64968a58d836b5e
Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date:   Mon Dec 14 23:49:41 2020 +0800

    io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work()
    
    io_iopoll_complete() does not hold completion_lock to complete polled io,
    so in io_wq_submit_work(), we can not call io_req_complete() directly, to
    complete polled io, otherwise there maybe concurrent access to cqring,
    defer_list, etc, which is not safe. Commit dad1b1242fd5 ("io_uring: always
    let io_iopoll_complete() complete polled io") has fixed this issue, but
    Pavel reported that IOPOLL apart from rw can do buf reg/unreg requests(
    IORING_OP_PROVIDE_BUFFERS or IORING_OP_REMOVE_BUFFERS), so the fix is not
    good.
    
    Given that io_iopoll_complete() is always called under uring_lock, so here
    for polled io, we can also get uring_lock to fix this issue.
    
    Fixes: dad1b1242fd5 ("io_uring: always let io_iopoll_complete() complete polled io")
    Cc: <stable@vger.kernel.org> # 5.5+
    Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
    [axboe: don't deref 'req' after completing it']
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b27f61e3e0d6..0a8cf3fad955 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6332,19 +6332,28 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 	}
 
 	if (ret) {
+		struct io_ring_ctx *lock_ctx = NULL;
+
+		if (req->ctx->flags & IORING_SETUP_IOPOLL)
+			lock_ctx = req->ctx;
+
 		/*
-		 * io_iopoll_complete() does not hold completion_lock to complete
-		 * polled io, so here for polled io, just mark it done and still let
-		 * io_iopoll_complete() complete it.
+		 * io_iopoll_complete() does not hold completion_lock to
+		 * complete polled io, so here for polled io, we can not call
+		 * io_req_complete() directly, otherwise there maybe concurrent
+		 * access to cqring, defer_list, etc, which is not safe. Given
+		 * that io_iopoll_complete() is always called under uring_lock,
+		 * so here for polled io, we also get uring_lock to complete
+		 * it.
 		 */
-		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
-			struct kiocb *kiocb = &req->rw.kiocb;
+		if (lock_ctx)
+			mutex_lock(&lock_ctx->uring_lock);
 
-			kiocb_done(kiocb, ret, NULL);
-		} else {
-			req_set_fail_links(req);
-			io_req_complete(req, ret);
-		}
+		req_set_fail_links(req);
+		io_req_complete(req, ret);
+
+		if (lock_ctx)
+			mutex_unlock(&lock_ctx->uring_lock);
 	}
 
 	return io_steal_work(req);

-- 
Jens Axboe

