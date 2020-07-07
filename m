Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171F72173CF
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 18:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgGGQVS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 12:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727886AbgGGQVS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 12:21:18 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622BEC061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 09:21:18 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t27so31548551ill.9
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 09:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ylXLDPwjFwmNUX021iadtYVQcvfBwbfAN12x96EMekU=;
        b=NPb157AWz4yddSc2cQeFATh1/6cybV/M0QCmEGk0NxwpuHaVc5hllxortFUJd74Vcn
         iRPSimRdxYRRCaake0SrQs6UQw2jGRPN30vnoLaZ5S5HiXhwpOe+UCyBvdn5qk2a7Bz0
         04VzLnlHM713YBqYzXmg4aPVa3pUMfxUm8fsu2nqDA9qY3ujRtNbZd+3tK7djhfH9rYS
         kERRAQjAjQ4qOj4fxGX8ttzS6GBj/IpsjBElPYmFMYsCN3pBV8+kVJ1pmRjS4IQ8RigW
         zAF2MEEDgpWpkrO5avoTIP55zh40zWcXE5vihJOPXut3d9puKFimAcMy85IIJxej//N/
         hWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ylXLDPwjFwmNUX021iadtYVQcvfBwbfAN12x96EMekU=;
        b=tqfHfezGwrYDCPCUMK2Enb66f2QWjNREOZK9rq/ClPbpMkbRx5f6dH6faz7NEzAroo
         hqLTOpByFZlyOafixxVQ3XHpTaUOG2lpXy3LhP3f29RBBMSbhYeZJP070KzVpFTAGJ1Y
         +21bx7a46vA7+WKeNRA2lqdjI6vvmCnqrqOHULUCJ7sSUnIuv2tUzs6yNe8U6StFN8wz
         YS9JfBJpowdSY2lGCmGaFEhxZxgYl7crZbTkB/HFP6DwCWP+MaATXs4Y8ddfR7hns4VF
         d7XT7U1N3g1+h6+kgCsMvHNj8Z2jJc8xeT+k+4Fqm+TXdG26YO6uVEQgeLipePAJzdbK
         wcNw==
X-Gm-Message-State: AOAM5315W1NRxTpdgnHTRhBFb6RJfo74itAKYQZs4qMMEXqT4ziq9KVl
        m1qll1sx9+lEomAlfjF0PV2RQQi2yYMGPQ==
X-Google-Smtp-Source: ABdhPJz+o+5s4fpFpyd4V3BzCzj0BfD1OfQjpW7MIYidUlHO+gl4nK4YdEgo0YWjzYwD8VfEMZi9Xw==
X-Received: by 2002:a05:6e02:46:: with SMTP id i6mr35283991ilr.91.1594138876538;
        Tue, 07 Jul 2020 09:21:16 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t14sm13642133ilk.17.2020.07.07.09.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 09:21:15 -0700 (PDT)
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200707132420.2007-1-xiaoguang.wang@linux.alibaba.com>
 <0ebded37-3660-e3c0-aa51-d3d7e56d634c@kernel.dk>
Message-ID: <bb9e165a-3193-5da2-d342-e5d9ed200070@kernel.dk>
Date:   Tue, 7 Jul 2020 10:21:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0ebded37-3660-e3c0-aa51-d3d7e56d634c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 8:28 AM, Jens Axboe wrote:
> On 7/7/20 7:24 AM, Xiaoguang Wang wrote:
>> For those applications which are not willing to use io_uring_enter()
>> to reap and handle cqes, they may completely rely on liburing's
>> io_uring_peek_cqe(), but if cq ring has overflowed, currently because
>> io_uring_peek_cqe() is not aware of this overflow, it won't enter
>> kernel to flush cqes, below test program can reveal this bug:
>>
>> static void test_cq_overflow(struct io_uring *ring)
>> {
>>         struct io_uring_cqe *cqe;
>>         struct io_uring_sqe *sqe;
>>         int issued = 0;
>>         int ret = 0;
>>
>>         do {
>>                 sqe = io_uring_get_sqe(ring);
>>                 if (!sqe) {
>>                         fprintf(stderr, "get sqe failed\n");
>>                         break;;
>>                 }
>>                 ret = io_uring_submit(ring);
>>                 if (ret <= 0) {
>>                         if (ret != -EBUSY)
>>                                 fprintf(stderr, "sqe submit failed: %d\n", ret);
>>                         break;
>>                 }
>>                 issued++;
>>         } while (ret > 0);
>>         assert(ret == -EBUSY);
>>
>>         printf("issued requests: %d\n", issued);
>>
>>         while (issued) {
>>                 ret = io_uring_peek_cqe(ring, &cqe);
>>                 if (ret) {
>>                         if (ret != -EAGAIN) {
>>                                 fprintf(stderr, "peek completion failed: %s\n",
>>                                         strerror(ret));
>>                                 break;
>>                         }
>>                         printf("left requets: %d\n", issued);
>>                         continue;
>>                 }
>>                 io_uring_cqe_seen(ring, cqe);
>>                 issued--;
>>                 printf("left requets: %d\n", issued);
>>         }
>> }
>>
>> int main(int argc, char *argv[])
>> {
>>         int ret;
>>         struct io_uring ring;
>>
>>         ret = io_uring_queue_init(16, &ring, 0);
>>         if (ret) {
>>                 fprintf(stderr, "ring setup failed: %d\n", ret);
>>                 return 1;
>>         }
>>
>>         test_cq_overflow(&ring);
>>         return 0;
>> }
>>
>> To fix this issue, export cq overflow status to userspace, then
>> helper functions() in liburing, such as io_uring_peek_cqe, can be
>> aware of this cq overflow and do flush accordingly.
> 
> Is there any way we can accomplish the same without exporting
> another set of flags? Would it be enough for the SQPOLl thread to set
> IORING_SQ_NEED_WAKEUP if we're in overflow condition? That should
> result in the app entering the kernel when it's flushed the user CQ
> side, and then the sqthread could attempt to flush the pending
> events as well.
> 
> Something like this, totally untested...

OK, took a closer look at this, it's a generic thing, not just
SQPOLL related. My bad!

Anyway, my suggestion would be to add IORING_SQ_CQ_OVERFLOW to the
existing flags, and then make a liburing change almost identical to
what you had.

Hence kernel side:


diff --git a/fs/io_uring.c b/fs/io_uring.c
index d37d7ea5ebe5..af9fd5cefc51 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1234,11 +1234,12 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	struct io_uring_cqe *cqe;
 	struct io_kiocb *req;
 	unsigned long flags;
+	bool ret = true;
 	LIST_HEAD(list);
 
 	if (!force) {
 		if (list_empty_careful(&ctx->cq_overflow_list))
-			return true;
+			goto done;
 		if ((ctx->cached_cq_tail - READ_ONCE(rings->cq.head) ==
 		    rings->cq_ring_entries))
 			return false;
@@ -1284,7 +1285,11 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		io_put_req(req);
 	}
 
-	return cqe != NULL;
+	ret = cqe != NULL;
+done:
+	if (ret)
+		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
+	return ret;
 }
 
 static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
@@ -5933,10 +5938,13 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	int i, submitted = 0;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
-	if (test_bit(0, &ctx->sq_check_overflow)) {
+	if (unlikely(test_bit(0, &ctx->sq_check_overflow))) {
 		if (!list_empty(&ctx->cq_overflow_list) &&
-		    !io_cqring_overflow_flush(ctx, false))
+		    !io_cqring_overflow_flush(ctx, false)) {
+			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
+			smp_mb();
 			return -EBUSY;
+		}
 	}
 
 	/* make sure SQ entry isn't read before tail */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92c22699a5a7..9c7e028beda5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -197,6 +197,7 @@ struct io_sqring_offsets {
  * sq_ring->flags
  */
 #define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
+#define IORING_SQ_CQ_OVERFLOW	(1U << 1) /* app needs to enter kernel */
 
 struct io_cqring_offsets {
 	__u32 head;

and then this for the liburing side:


diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 6a73522..e4314ed 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -202,6 +202,7 @@ struct io_sqring_offsets {
  * sq_ring->flags
  */
 #define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
+#define IORING_SQ_CQ_OVERFLOW	(1U << 1)
 
 struct io_cqring_offsets {
 	__u32 head;
diff --git a/src/queue.c b/src/queue.c
index 88e0294..1f00251 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -32,6 +32,11 @@ static inline bool sq_ring_needs_enter(struct io_uring *ring,
 	return false;
 }
 
+static inline bool cq_ring_needs_flush(struct io_uring *ring)
+{
+	return IO_URING_READ_ONCE(*ring->sq.kflags) & IORING_SQ_CQ_OVERFLOW;
+}
+
 static int __io_uring_peek_cqe(struct io_uring *ring,
 			       struct io_uring_cqe **cqe_ptr)
 {
@@ -67,22 +72,26 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 	int ret = 0, err;
 
 	do {
+		bool cq_overflow_flush = false;
 		unsigned flags = 0;
 
 		err = __io_uring_peek_cqe(ring, &cqe);
 		if (err)
 			break;
 		if (!cqe && !to_wait && !submit) {
-			err = -EAGAIN;
-			break;
+			if (!cq_ring_needs_flush(ring)) {
+				err = -EAGAIN;
+				break;
+			}
+			cq_overflow_flush = true;
 		}
 		if (wait_nr && cqe)
 			wait_nr--;
-		if (wait_nr)
+		if (wait_nr || cq_overflow_flush)
 			flags = IORING_ENTER_GETEVENTS;
 		if (submit)
 			sq_ring_needs_enter(ring, submit, &flags);
-		if (wait_nr || submit)
+		if (wait_nr || submit || cq_overflow_flush)
 			ret = __sys_io_uring_enter(ring->ring_fd, submit,
 						   wait_nr, flags, sigmask);
 		if (ret < 0) {

If you agree with this approach, could you test this and resubmit the
two patches?

-- 
Jens Axboe

