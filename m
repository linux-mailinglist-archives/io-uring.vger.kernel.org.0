Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A8D13309B
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 21:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgAGUeO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 15:34:14 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33305 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgAGUeN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jan 2020 15:34:13 -0500
Received: by mail-io1-f65.google.com with SMTP id z8so801684ioh.0
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2020 12:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=n/4jVkbiGb1cbLYU3GmJXiEjjQ4BKrPEujBZO5PYkWw=;
        b=j8+9WOpwd1F/AGrrB6Awy2owBOCeenHRZuz7uwdHyHGffy9lJzsiAEGVfv9NVr2BcE
         Ddz3OuQjThJAzHTLBu0NmEmz9no1fcesrzH3qe9I74pzUuUXulyb6IDYoCFB5HKeYT7Z
         yhWWdp1Npd2akLdpNAnN7A4E3Rxh9qLib6ZaGsNPwYMi/YjRoAtkx61vFqJud0Gzh38L
         JjZia4I4wL7UB6VVlfya05maOBRF8WAFgyZVrWYHC5LoyNqvO9D2Fw/GzKBWD+Wo3bhW
         eI4DTofzXP7lFIns729+6IU0a65zEykEizzqA6S1X6VojhWdc8u6sGG1z2fzrTW2k1Br
         Glrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n/4jVkbiGb1cbLYU3GmJXiEjjQ4BKrPEujBZO5PYkWw=;
        b=aYKFcmjmdGJjGQCnVoo0ipSnXkIugtQYGQYu2ughoYx5b9f54euKvHZ510SYzuDy6N
         ipvm4tR0f/VRq9hRSg3m3Rn1EjNDvzUAbDGk0Zld3VXNp8ZNTZkyGdSGDp1Xlmx8E9t0
         6L4Ivvp2x4Fe06R1Wl1mve2giLJEyxVTgLhocotc57n8fMt3Bw5b6AuT9dlWHItHJY7K
         Q/kBrCaVyP9V1pB0vICLgRoOWLaM6Dto4vk9GDrPyRpdKLSH/Q/sa021kxxWWcuNONw8
         5eQVKhavB5x9Py/UXZ8OHF1W2/DjQPhMuBN17xYYnADt/rhOlDLxxvzIl69sywfDyZn+
         fsVA==
X-Gm-Message-State: APjAAAVTaGo4Z7JhopW/ClUnWt5w5qObetCV+OsZaJsUvNI+kqUGzQbG
        IK9zaz1nOjtj/iaKp+yYDzw/rxcQllo=
X-Google-Smtp-Source: APXvYqwvhpKpDkMv5RIGv9RgUfNEfZHT+DZB7yWCgHlJXbQEeVCCeEWGNOfwm96jcdW+HNuqHyg/+Q==
X-Received: by 2002:a6b:b606:: with SMTP id g6mr722646iof.114.1578429252732;
        Tue, 07 Jan 2020 12:34:12 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j26sm136864iok.3.2020.01.07.12.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 12:34:12 -0800 (PST)
Subject: Re: io_uring and spurious wake-ups from eventfd
From:   Jens Axboe <axboe@kernel.dk>
To:     Mark Papadakis <markuspapadakis@icloud.com>,
        io-uring@vger.kernel.org
References: <2005CB9A-0883-4C35-B975-1931C3640AA1@icloud.com>
 <55243723-480f-0220-2b93-74cc033c6e1d@kernel.dk>
Message-ID: <60360091-ffce-fc8b-50d5-1a20fecaf047@kernel.dk>
Date:   Tue, 7 Jan 2020 13:34:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <55243723-480f-0220-2b93-74cc033c6e1d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/7/20 1:26 PM, Jens Axboe wrote:
> On 1/7/20 8:55 AM, Mark Papadakis wrote:
>> This is perhaps an odd request, but if it’s trivial to implement
>> support for this described feature, it could help others like it ‘d
>> help me (I ‘ve been experimenting with io_uring for some time now).
>>
>> Being able to register an eventfd with an io_uring context is very
>> handy, if you e.g have some sort of reactor thread multiplexing I/O
>> using epoll etc, where you want to be notified when there are pending
>> CQEs to drain. The problem, such as it is, is that this can result in
>> un-necessary/spurious wake-ups.
>>
>> If, for example, you are monitoring some sockets for EPOLLIN, and when
>> poll says you have pending bytes to read from their sockets, and said
>> sockets are non-blocking, and for each some reported event you reserve
>> an SQE for preadv() to read that data and then you io_uring_enter to
>> submit the SQEs, because the data is readily available, as soon as
>> io_uring_enter returns, you will have your completions available -
>> which you can process.  The “problem” is that poll will wake up
>> immediately thereafter in the next reactor loop iteration because
>> eventfd was tripped (which is reasonable but un-necessary).
>>
>> What if there was a flag for io_uring_setup() so that the eventfd
>> would only be tripped for CQEs that were processed asynchronously, or,
>> if that’s non-trivial, only for CQEs that reference file FDs?
>>
>> That’d help with that spurious wake-up.
> 
> One easy way to do that would be for the application to signal that it
> doesn't want eventfd notifications for certain requests. Like using an
> IOSQE_ flag for that. Then you could set that on the requests you submit
> in response to triggering an eventfd event.

Something like this - totally untested. Note that for some error cases I
didn't go through the trouble of wiring this up, but for all the normal
cases it should work.

Patch is against my for-5.6/io_uring branch.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c770c2c0eb52..5c6da1e1f29c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -512,6 +512,7 @@ struct io_kiocb {
 #define REQ_F_HARDLINK		65536	/* doesn't sever on completion < 0 */
 #define REQ_F_FORCE_ASYNC	131072	/* IOSQE_ASYNC */
 #define REQ_F_CUR_POS		262144	/* read/write uses file position */
+#define REQ_F_NO_EVFD		524288	/* don't trigger eventfd for this req */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -960,13 +961,13 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 	return &rings->cqes[tail & ctx->cq_mask];
 }
 
-static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
+static void io_cqring_ev_posted(struct io_ring_ctx *ctx, bool evfd)
 {
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 	if (waitqueue_active(&ctx->sqo_wait))
 		wake_up(&ctx->sqo_wait);
-	if (ctx->cq_ev_fd)
+	if (evfd && ctx->cq_ev_fd)
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
 
@@ -1018,7 +1019,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		clear_bit(0, &ctx->cq_check_overflow);
 	}
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx, true);
 
 	while (!list_empty(&list)) {
 		req = list_first_entry(&list, struct io_kiocb, list);
@@ -1070,7 +1071,7 @@ static void io_cqring_add_event(struct io_kiocb *req, long res)
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
-	io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx, !(req->flags & REQ_F_NO_EVFD));
 }
 
 static inline bool io_is_fallback_req(struct io_kiocb *req)
@@ -1288,7 +1289,7 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 
 	req->flags |= REQ_F_LINK_NEXT;
 	if (wake_ev)
-		io_cqring_ev_posted(ctx);
+		io_cqring_ev_posted(ctx, true);
 }
 
 /*
@@ -1320,7 +1321,7 @@ static void io_fail_links(struct io_kiocb *req)
 
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx, true);
 }
 
 static void io_req_find_next(struct io_kiocb *req, struct io_kiocb **nxt)
@@ -3366,7 +3367,7 @@ static void io_poll_complete_work(struct io_wq_work **workptr)
 	io_poll_complete(req, mask, ret);
 	spin_unlock_irq(&ctx->completion_lock);
 
-	io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx, !(req->flags & REQ_F_NO_EVFD));
 
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -3379,6 +3380,7 @@ static void __io_poll_flush(struct io_ring_ctx *ctx, struct llist_node *nodes)
 {
 	struct io_kiocb *req, *tmp;
 	struct req_batch rb;
+	bool evfd = false;
 
 	rb.to_free = rb.need_iter = 0;
 	spin_lock_irq(&ctx->completion_lock);
@@ -3386,6 +3388,8 @@ static void __io_poll_flush(struct io_ring_ctx *ctx, struct llist_node *nodes)
 		hash_del(&req->hash_node);
 		io_poll_complete(req, req->result, 0);
 
+		if (!evfd && !(req->flags & REQ_F_NO_EVFD))
+			evfd = true;
 		if (refcount_dec_and_test(&req->refs) &&
 		    !io_req_multi_free(&rb, req)) {
 			req->flags |= REQ_F_COMP_LOCKED;
@@ -3394,7 +3398,7 @@ static void __io_poll_flush(struct io_ring_ctx *ctx, struct llist_node *nodes)
 	}
 	spin_unlock_irq(&ctx->completion_lock);
 
-	io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx, evfd);
 	io_free_req_many(ctx, &rb);
 }
 
@@ -3439,7 +3443,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			io_put_req(req);
 			spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
-			io_cqring_ev_posted(ctx);
+			io_cqring_ev_posted(ctx, !(req->flags & REQ_F_NO_EVFD));
 			req = NULL;
 		} else {
 			req->result = mask;
@@ -3557,7 +3561,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	spin_unlock_irq(&ctx->completion_lock);
 
 	if (mask) {
-		io_cqring_ev_posted(ctx);
+		io_cqring_ev_posted(ctx, !(req->flags & REQ_F_NO_EVFD));
 		io_put_req_find_next(req, nxt);
 	}
 	return ipt.error;
@@ -3597,7 +3601,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
-	io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx, !(req->flags & REQ_F_NO_EVFD));
 	req_set_fail_links(req);
 	io_put_req(req);
 	return HRTIMER_NORESTART;
@@ -3659,7 +3663,7 @@ static int io_timeout_remove(struct io_kiocb *req)
 	io_cqring_fill_event(req, ret);
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx, !(req->flags & REQ_F_NO_EVFD));
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_put_req(req);
@@ -3829,7 +3833,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	io_cqring_fill_event(req, ret);
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx, !(req->flags & REQ_F_NO_EVFD));
 
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -4528,7 +4532,8 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 }
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
-				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
+				IOSQE_IO_HARDLINK | IOSQE_ASYNC | 	\
+				IOSQE_NO_EVENTFD)
 
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			  struct io_submit_state *state, struct io_kiocb **link)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index be64c9757ff1..72af96a38ed8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -53,6 +53,7 @@ struct io_uring_sqe {
 #define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
 #define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */
 #define IOSQE_ASYNC		(1U << 4)	/* always go async */
+#define IOSQE_NO_EVENTFD	(1U << 5)	/* don't trigger eventfd */
 
 /*
  * io_uring_setup() flags

-- 
Jens Axboe

