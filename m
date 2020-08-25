Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65350251C97
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 17:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgHYPsF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 11:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgHYPsE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 11:48:04 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01638C061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 08:48:03 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u126so12920075iod.12
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 08:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4tA6pFHHaGUJh+dRBcHJCFI3NkPj9TitG3fNgVTOVJE=;
        b=NyMgxz5xnc95UlFkFYfrmmL0tM987yIfJVugP2hw+z0bYiyq5jXSVLK/dZrSzAeEmm
         jsco4e02qPrCC/KBexonpxVkVhjmDf3pY7OVueqrRmiH0imzv2wRJIT6HId3YI+RwBmK
         80UjOc33kNkG9AOywhKFGJHwm8kTjMXqyU2DbsAeBN+JY4XLdDDAL8zEVAnHMvOyqfMp
         AFKZsJorhoJSkSrf2K9G1kfLpylkg3Irk1bdq/a0ElgYnUwL3R2F0QDeP9rsPuQSTz3A
         wvAE/HMSZP8248u80QxQkHM913DMJqMLqUNvoIsGuPZM0y87G7m+p6cthl38ZLP4ZnNZ
         ofYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4tA6pFHHaGUJh+dRBcHJCFI3NkPj9TitG3fNgVTOVJE=;
        b=HrFrIYEoNudsyU1kQPsrJ5mC9KeOVpcpe4cwp3n4AKWWELHe/yluHUdhUPq+5OhQCN
         MTQYq0RurpRz6iuE6eZRm3+GitQrC7zBzqgDWNUO7lJINpU90b73JGfJtLYBxGlR+Mr3
         p7L1K1nY6r76nPTeaV+EgrzNwivSo5IeVxeAldUTm9Qp242C+aEHuuT09slJU99LBKjC
         0w1KxK7kpw4ylQJ22L7TVEIg5BggPdV/c/chfBxkwXpA7RP6OGL4XVtHT7jxW6YohDf7
         qumaC79940Hd1ztDoBxcvKJBq+wr9zaYF5jqbBm2hQejepK1kqwgjog8UyIA+p7zt5rJ
         J7Yg==
X-Gm-Message-State: AOAM532Tb/D1Yan4PDiLtqRypgS2tqawT1K0tbbYGmlzHqqSRe4gAAc3
        nhz5E3aNfUMCfJchPyhuFM5Tuw==
X-Google-Smtp-Source: ABdhPJxUQkxhliHgv6s2Jfju0J4Tq7oQBYFYUq2CRdeAmuINHiunLcykIhxj5eUP55sdlcUYWy1XOg==
X-Received: by 2002:a6b:37d5:: with SMTP id e204mr9382307ioa.104.1598370482133;
        Tue, 25 Aug 2020 08:48:02 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e23sm8601725iot.28.2020.08.25.08.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 08:48:01 -0700 (PDT)
Subject: Re: io_uring file descriptor address already in use error
From:   Jens Axboe <axboe@kernel.dk>
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+o=0zd9JQj+B0Fe1cONCtMJdKkfQuT+Hzx9X9jRigrfZQ@mail.gmail.com>
 <639db33b-08f2-4e10-8f06-b6d345677df8@kernel.dk>
 <308222a7-8bd2-44a6-c46c-43adf5469fa3@kernel.dk>
Message-ID: <c07b29d1-fff4-3019-4cba-0566c8a75fd0@kernel.dk>
Date:   Tue, 25 Aug 2020 09:48:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <308222a7-8bd2-44a6-c46c-43adf5469fa3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/20 9:17 AM, Jens Axboe wrote:
> On 8/25/20 9:12 AM, Jens Axboe wrote:
>> On 8/25/20 9:00 AM, Josef wrote:
>>> Hi,
>>>
>>> I found a bug submitting a server socket poll in io_uring. The file
>>> descriptor is not really closed when calling close(2), if I bind a new
>>> socket with the same address & port I'll get an "Already in use" error
>>> message
>>>
>>> example to reproduce it
>>> https://gist.github.com/1Jo1/3ace601884b86f7495fd5241190494dc
>>
>> Not sure this is an actual bug, but depends on how you look at it. Your
>> poll command has a reference to the file, which means that when you close
>> it here:
>>
>>     assert(close(sock_listen_fd1) == 0); 
>>
>> then that's not the final close. If you move the io_uring_queue_exit()
>> before that last create_server_socket() it should work, since the poll
>> will have been canceled (and hence the file closed) at that point.
>>
>> That said, I don't believe we actually need the file after arming the
>> poll, so we could potentially close it once we've armed it. That would
>> make your example work.
> 
> Actually we do need the file, in case we're re-arming poll. But as stated
> in the above email, this isn't unexpected behavior. You could cancel the
> poll before trying to setup the new server socket, that'd close it as
> well. Then the close() would actually close it. Ordering of the two
> operations wouldn't matter.

Just to wrap this one up, the below patch would make it behave like you
expect, and still retain the re-poll behavior we use on poll armed on
behalf of an IO request. At this point we're not holding a reference to
the file across the poll handler, and your close() would actually close
the file since it's putting the last reference to it.

But... Not actually sure this is warranted. Any io_uring request that
operates on a file will hold a reference to it until it completes. The
poll request in your example never completes. If you run poll(2) on a
file and you close that file, you won't get a poll event triggered.
It'll just sit there and wait on events that won't come in. poll(2)
doesn't hold a reference to the file once it's armed the handler, so
your example would work there.

What do you think?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 384df86dfc69..e3de6846d91a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4617,7 +4617,7 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->result && !READ_ONCE(poll->canceled)) {
+	if (!req->result && req->file && !READ_ONCE(poll->canceled)) {
 		struct poll_table_struct pt = { ._key = poll->events };
 
 		req->result = vfs_poll(req->file, &pt) & poll->events;
@@ -4845,10 +4845,11 @@ static void io_poll_req_insert(struct io_kiocb *req)
 static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 				      struct io_poll_iocb *poll,
 				      struct io_poll_table *ipt, __poll_t mask,
-				      wait_queue_func_t wake_func)
+				      wait_queue_func_t wake_func, bool hold)
 	__acquires(&ctx->completion_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct file *file = req->file;
 	bool cancel = false;
 
 	io_init_poll_iocb(poll, mask, wake_func);
@@ -4859,7 +4860,13 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 	ipt->req = req;
 	ipt->error = -EINVAL;
 
-	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
+	if (!hold)
+		req->file = poll->file = NULL;
+
+	mask = vfs_poll(file, &ipt->pt) & poll->events;
+
+	if (!hold)
+		io_put_file(req, file, req->flags & REQ_F_FIXED_FILE);
 
 	spin_lock_irq(&ctx->completion_lock);
 	if (likely(poll->head)) {
@@ -4917,7 +4924,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	ipt.pt._qproc = io_async_queue_proc;
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
-					io_async_wake);
+					io_async_wake, true);
 	if (ret || ipt.error) {
 		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
@@ -5100,7 +5107,7 @@ static int io_poll_add(struct io_kiocb *req)
 	ipt.pt._qproc = io_poll_queue_proc;
 
 	mask = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events,
-					io_poll_wake);
+					io_poll_wake, false);
 
 	if (mask) { /* no async, we'd stolen it */
 		ipt.error = 0;

-- 
Jens Axboe

