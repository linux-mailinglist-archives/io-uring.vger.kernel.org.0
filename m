Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC213FA7A9
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 23:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhH1VkD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 17:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhH1VkD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 17:40:03 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18838C061756
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 14:39:12 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id z4so16203930wrr.6
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 14:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QYBPxD7DHs+hyTofiTRuoCbWq5mHRIMGThSMH9y1TO8=;
        b=oaZtmIi0BSCYmu8Zk+KV9T4sLot5kkWu+D/r8X3dkbWGz/9Wm6EUZH9V+51oRzZh/w
         E20hoSMgUEAetYwXR6VCd3nFubD8MQ+Yv7n9iVp+t8cPotGZTTQ9I+fkpDGAhiZW93Wn
         Z0FRij8JG3Jo71H3GlULgq5WMWkyEcQOjy5pXQ8pAfSkVo77swl6tmBwxdP7iKoj4kmU
         nUltV0MaTH8l0QE3y4FrMALMgxfvC6Fm7ifNUjng5Tpwr6+eCwCSF7G650vIHlOQ7iXT
         hfysfx/TxlhH9IXU5XB5XnldlJNM2dLzlJZzNbJTeFp6pzrw49yzkhdQHdr4GXkXbtC3
         6jKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QYBPxD7DHs+hyTofiTRuoCbWq5mHRIMGThSMH9y1TO8=;
        b=srguaSUOT4Q18J20GP93QcCQmlC2buw2Mj0kgQ5BpixLMZWAokbNwJA/tyJvO5kS9d
         FIhDbP9jyrtkOloJVoBzlYE1kuO+FAY+VgSsM9YK0NgHG1mTQ28v2+sYitMwOK/xYCqD
         c0LWNQWS4J/A+ptZipJWZ45gF/Z+1NCKvxcAYwuuGn6IqRWfnilmauI7RxLixa5LI4ym
         cjVdDQqCCp/6PBGrhmoCs0jUnWv6yXcLVRJ3D/X2EXZGOIvM9ZVh61900GcBP9qDPHgs
         vwdEfEK9mfR0bg3fog2xz5nnMnqPDLtBdixabR7iI1WPUVbk4XupNrWdE989d1JooBbz
         R4BA==
X-Gm-Message-State: AOAM533Hl3UROn37FHnkQGVAiC0uNG07fbqlxk7QqBOsyUAIfvoICzur
        HIbxERCM8h3lCsOdoIV+8WxDqLn1n+A=
X-Google-Smtp-Source: ABdhPJwrsDIcg0mep+GlOnIfFMBi2+OYYP0FmdiAQYYxSYgBsrt8AwUs0mJHV0NFJv2clPPOvNJbUg==
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr18789201wrx.244.1630186750183;
        Sat, 28 Aug 2021 14:39:10 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.237.102])
        by smtp.gmail.com with ESMTPSA id y6sm12502094wrm.54.2021.08.28.14.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Aug 2021 14:39:09 -0700 (PDT)
Subject: Re: io_uring_prep_timeout_update on linked timeouts
To:     Jens Axboe <axboe@kernel.dk>, Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
 <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
 <CAM1kxwiAF3tmF8PxVf6KPV+Qsg_180sFvebxos5ySmU=TqxgmA@mail.gmail.com>
 <1b3865bd-f381-04f3-6e54-779fe6b43946@kernel.dk>
 <04e3c4ab-4e78-805c-bc4f-f9c6d7e85ec1@gmail.com>
 <b53e6d69-9591-607b-c391-bf5fed23c1af@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ebf4753c-dbe4-f6b5-e79c-39cc9a608beb@gmail.com>
Date:   Sat, 28 Aug 2021 22:38:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b53e6d69-9591-607b-c391-bf5fed23c1af@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/28/21 2:43 PM, Jens Axboe wrote:
> On 8/28/21 7:39 AM, Pavel Begunkov wrote:
>> On 8/28/21 4:22 AM, Jens Axboe wrote:
>>> On 8/26/21 7:40 PM, Victor Stewart wrote:
>>>> On Wed, Aug 25, 2021 at 2:27 AM Victor Stewart <v@nametag.social> wrote:
>>>>>
>>>>> On Tue, Aug 24, 2021 at 11:43 PM Victor Stewart <v@nametag.social> wrote:
>>>>>>
>>>>>> we're able to update timeouts with io_uring_prep_timeout_update
>>>>>> without having to cancel
>>>>>> and resubmit, has it ever been considered adding this ability to
>>>>>> linked timeouts?
>>>>>
>>>>> whoops turns out this does work. just tested it.
>>>>
>>>> doesn't work actually. missed that because of a bit of misdirection.
>>>> returns -ENOENT.
>>>>
>>>> the problem with the current way of cancelling then resubmitting
>>>> a new a timeout linked op (let's use poll here) is you have 3 situations:
>>>>
>>>> 1) the poll triggers and you get some positive value. all good.
>>>>
>>>> 2) the linked timeout triggers and cancels the poll, so the poll
>>>> operation returns -ECANCELED.
>>>>
>>>> 3) you cancel the existing poll op, and submit a new one with
>>>> the updated linked timeout. now the original poll op returns
>>>> -ECANCELED.
>>>>
>>>> so solely from looking at the return value of the poll op in 2) and 3)
>>>> there is no way to disambiguate them. of course the linked timeout
>>>> operation result will allow you to do so, but you'd have to persist state
>>>> across cqe processings. you can also track the cancellations and know
>>>> to skip the explicitly cancelled ops' cqes (which is what i chose).
>>>>
>>>> there's also the problem of efficiency. you can imagine in a QUIC
>>>> server where you're constantly updating that poll timeout in response
>>>> to idle timeout and ACK scheduling, this extra work mounts.
>>>>
>>>> so i think the ability to update linked timeouts via
>>>> io_uring_prep_timeout_update would be fantastic.
>>>
>>> Hmm, I'll need to dig a bit, but whether it's a linked timeout or not
>>> should not matter. It's a timeout, it's queued and updated the same way.
>>> And we even check this in some of the liburing tests.
>>
>> We don't keep linked timeouts in ->timeout_list, so it's not
>> supported and has never been. Should be doable, but we need
>> to be careful synchronising with the link's head.
> 
> Yeah shoot you are right, I guess that explains the ENOENT. Would be
> nice to add, though. Synchronization should not be that different from
> dealing with regular timeouts.

_Not tested_, but something like below should do. will get it
done properly later, but even better if we already have a test
case. Victor?


From: Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/2] io_uring: keep ltimeouts in a list

A preparation patch. Keep all queued linked timeout in a list, so they
may be found and updated.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf6551ea2c00..aad230b4cc2c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -375,6 +375,7 @@ struct io_ring_ctx {
 
 		struct io_submit_state	submit_state;
 		struct list_head	timeout_list;
+		struct list_head	ltimeout_list;
 		struct list_head	cq_overflow_list;
 		struct xarray		io_buffers;
 		struct xarray		personalities;
@@ -1277,6 +1278,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
+	INIT_LIST_HEAD(&ctx->ltimeout_list);
 	spin_lock_init(&ctx->rsrc_ref_lock);
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
@@ -1966,6 +1968,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		io_remove_next_linked(req);
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
+			list_del(&link->timeout.list);
 			io_cqring_fill_event(link->ctx, link->user_data,
 					     -ECANCELED, 0);
 			io_put_req_deferred(link);
@@ -5830,6 +5833,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
 		return -EINVAL;
 
+	INIT_LIST_HEAD(&req->timeout.list);
 	req->timeout.off = off;
 	if (unlikely(off && !req->ctx->off_timeout_used))
 		req->ctx->off_timeout_used = true;
@@ -6585,6 +6589,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 		if (!req_ref_inc_not_zero(prev))
 			prev = NULL;
 	}
+	list_del(&req->timeout.list);
 	req->timeout.prev = prev;
 	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
@@ -6608,6 +6613,7 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 		data->timer.function = io_link_timeout_fn;
 		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
 				data->mode);
+		list_add_tail(&req->timeout.list, &ctx->ltimeout_list);
 	}
 	spin_unlock_irq(&ctx->timeout_lock);
 	/* drop submission reference */
@@ -8900,6 +8906,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		sock_release(ctx->ring_sock);
 	}
 #endif
+	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
-- 
2.33.0


From: Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/2] io_uring: allow updating linked timeouts

We allow updating normal timeouts, add support for adjusting timings of
linked timeouts as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 44 +++++++++++++++++++++++++++++++----
 include/uapi/linux/io_uring.h | 11 +++++----
 2 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aad230b4cc2c..c9d672ba5eaf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -552,6 +552,7 @@ struct io_timeout_rem {
 	/* timeout update */
 	struct timespec64		ts;
 	u32				flags;
+	bool				ltimeout;
 };
 
 struct io_rw {
@@ -1069,6 +1070,7 @@ static int io_req_prep_async(struct io_kiocb *req);
 
 static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 				 unsigned int issue_flags, u32 slot_index);
+static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
 
 static struct kmem_cache *req_cachep;
 
@@ -5732,6 +5734,31 @@ static clockid_t io_timeout_get_clock(struct io_timeout_data *data)
 	}
 }
 
+static int io_linked_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
+				    struct timespec64 *ts, enum hrtimer_mode mode)
+	__must_hold(&ctx->timeout_lock)
+{
+	struct io_timeout_data *io;
+	struct io_kiocb *req;
+	bool found = false;
+
+	list_for_each_entry(req, &ctx->ltimeout_list, timeout.list) {
+		found = user_data == req->user_data;
+		if (found)
+			break;
+	}
+	if (!found)
+		return -ENOENT;
+
+	io = req->async_data;
+	if (hrtimer_try_to_cancel(&io->timer) == -1)
+		return -EALREADY;
+	hrtimer_init(&io->timer, io_timeout_get_clock(io), mode);
+	io->timer.function = io_link_timeout_fn;
+	hrtimer_start(&io->timer, timespec64_to_ktime(*ts), mode);
+	return 0;
+}
+
 static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 			     struct timespec64 *ts, enum hrtimer_mode mode)
 	__must_hold(&ctx->timeout_lock)
@@ -5763,10 +5790,15 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
+	tr->ltimeout = false;
 	tr->addr = READ_ONCE(sqe->addr);
 	tr->flags = READ_ONCE(sqe->timeout_flags);
-	if (tr->flags & IORING_TIMEOUT_UPDATE) {
-		if (tr->flags & ~(IORING_TIMEOUT_UPDATE|IORING_TIMEOUT_ABS))
+	if (tr->flags & IORING_TIMEOUT_UPDATE_MASK) {
+		if (hweight32(tr->flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
+			return -EINVAL;
+		if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
+			tr->ltimeout = true;
+		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
 			return -EINVAL;
 		if (get_timespec64(&tr->ts, u64_to_user_ptr(sqe->addr2)))
 			return -EFAULT;
@@ -5800,9 +5832,13 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 		spin_unlock_irq(&ctx->timeout_lock);
 		spin_unlock(&ctx->completion_lock);
 	} else {
+		enum hrtimer_mode mode = io_translate_timeout_mode(tr->flags);
+
 		spin_lock_irq(&ctx->timeout_lock);
-		ret = io_timeout_update(ctx, tr->addr, &tr->ts,
-					io_translate_timeout_mode(tr->flags));
+		if (tr->ltimeout)
+			ret = io_linked_timeout_update(ctx, tr->addr, &tr->ts, mode);
+		else
+			ret = io_timeout_update(ctx, tr->addr, &tr->ts, mode);
 		spin_unlock_irq(&ctx->timeout_lock);
 	}
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4ea0b46e3da0..4ae753650513 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -149,12 +149,13 @@ enum {
 /*
  * sqe->timeout_flags
  */
-#define IORING_TIMEOUT_ABS	(1U << 0)
-#define IORING_TIMEOUT_UPDATE	(1U << 1)
-#define IORING_TIMEOUT_BOOTTIME	(1U << 2)
-#define IORING_TIMEOUT_REALTIME	(1U << 3)
+#define IORING_TIMEOUT_ABS		(1U << 0)
+#define IORING_TIMEOUT_UPDATE		(1U << 1)
+#define IORING_TIMEOUT_BOOTTIME		(1U << 2)
+#define IORING_TIMEOUT_REALTIME		(1U << 3)
+#define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
-
+#define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
  * sqe->splice_flags
  * extends splice(2) flags
-- 
2.33.0
