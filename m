Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5789A203D8D
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2020 19:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgFVRLo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 13:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729689AbgFVRLn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 13:11:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB40C061573
        for <io-uring@vger.kernel.org>; Mon, 22 Jun 2020 10:11:43 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b201so8694287pfb.0
        for <io-uring@vger.kernel.org>; Mon, 22 Jun 2020 10:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=mp2Ju8SyRcKjiXAa9AoMI9dS4jFvQocbB+hFFPnnH3k=;
        b=MTf9XsaOH+WW8O9P+fUVPp3GtOLY2KSD32XBWtj12C9v3K57MT1zfOcNND54qqtM8g
         /n7Ta785AHHj42S4DE77jt29cdZOR1vqPiPuzuefwjgZRHHz8TWdaP39XpAHpmpJgcGg
         QtHl5yw1cdHA8wXnTeVU/c3eIr/0nS3vz2uvKBfslyIJlusoPw+k1a5ZL1Jpfe+2/i3W
         zRAR0GCbzmuaXs+G49LMJLvE+ThQJ1iq6Utse57x7qE5QIFygdX2lPnjbwvM2KtXBSY7
         47RLwLYxEYG1/X4sb/SwbJYvaucBrWGd95okjdUAEoVlfm8G42FRLlLj7WJqLbTMojmt
         sgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=mp2Ju8SyRcKjiXAa9AoMI9dS4jFvQocbB+hFFPnnH3k=;
        b=HlzHBq0tqRMVw5flAmjBTSKyDnlsftJ/nUJJYnVtFJ1rUb61JM9E+g6ortXROg6xyx
         T4a3xc+OsSPNtZ7iYqo5DH0Kz8ws9ebaJONvT4oVwsfJugfuRke5LjbF+8MS8lk1ZHhh
         wDfepj/r3ThkT0JbD0pXH+FiFadmf6FF6fZU1ZbL94DkUnbtJVqF7WAT4KBgDDIHg817
         Ms1Y3S6UhHNSW8hEzRZ2vQrgGZUrJRjJ49w0ugB4W5jL1suD5nNiJYZ1K2Nixzsu4mVx
         VdBy3r1d3sfjAeWlh3oEmldSPVhp4T9/YkjfEbwSUoDhKrXc+PeEwZm4CAQGNPIjo5em
         83yQ==
X-Gm-Message-State: AOAM5309anRP3Twj9OvAJGnBEVGEZBvdvJFAPBCeZ9QeTUP3I4ZESFXg
        DQ+K8RxovR/HVQhivYDlMXRjFLz6QXU=
X-Google-Smtp-Source: ABdhPJwaQOGO8TTLPlnSrauhwPA7kfdkC5oIyc+RKSD7jgfyLDM1n7GBeaoyZ20NlxoBiXFLXHeZsA==
X-Received: by 2002:a63:8f17:: with SMTP id n23mr14136373pgd.40.1592845903058;
        Mon, 22 Jun 2020 10:11:43 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j130sm14558673pfd.94.2020.06.22.10.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 10:11:41 -0700 (PDT)
Subject: Re: [RFC] io_commit_cqring __io_cqring_fill_event take up too much
 cpu
From:   Jens Axboe <axboe@kernel.dk>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Dust.li@linux.alibaba.com
References: <20200622132910.GA99461@e02h04398.eu6sqa>
 <bb4b567f-4337-6c9d-62aa-fa62db2882f3@kernel.dk>
Message-ID: <c0859031-f4df-8c38-d5e1-aba8f82a9f98@kernel.dk>
Date:   Mon, 22 Jun 2020 11:11:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <bb4b567f-4337-6c9d-62aa-fa62db2882f3@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------0E6610594A5A01BEDB4CF812"
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------0E6610594A5A01BEDB4CF812
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 6/22/20 8:50 AM, Jens Axboe wrote:
> On 6/22/20 7:29 AM, Xuan Zhuo wrote:
>> Hi Jens,
>> I found a problem, and I think it is necessary to solve it. But the change
>> may be relatively large, so I would like to ask you and everyone for your
>> opinions. Or everyone has other ideas about this issue:
>>
>> Problem description:
>> ===================
>> I found that in the sq thread mode, the CPU used by io_commit_cqring and
>> __io_cqring_fill_event accounts for a relatively large amount. The reason is
>> because a large number of calls to smp_store_release and WRITE_ONCE.
>> These two functions are relatively slow, and we need to call smp_store_release
>> every time we submit a cqe. This large number of calls has caused this
>> problem to become very prominent.
>>
>> My test environment is in qemu, using io_uring to accept a large number of
>> udp packets in sq thread mode, the speed is 800000pps. I submitted 100 sqes
>> to recv udp packet at the beginning of the application, and every time I
>> received a cqe, I submitted another sqe. The perf top result of sq thread is
>> as follows:
>>
>>
>>
>> 17.97% [kernel] [k] copy_user_generic_unrolled
>> 13.92% [kernel] [k] io_commit_cqring
>> 11.04% [kernel] [k] __io_cqring_fill_event
>> 10.33% [kernel] [k] udp_recvmsg
>>   5.94% [kernel] [k] skb_release_data
>>   4.31% [kernel] [k] udp_rmem_release
>>   2.68% [kernel] [k] __check_object_size
>>   2.24% [kernel] [k] __slab_free
>>   2.22% [kernel] [k] _raw_spin_lock_bh
>>   2.21% [kernel] [k] kmem_cache_free
>>   2.13% [kernel] [k] free_pcppages_bulk
>>   1.83% [kernel] [k] io_submit_sqes
>>   1.38% [kernel] [k] page_frag_free
>>   1.31% [kernel] [k] inet_recvmsg
>>
>>
>>
>> It can be seen that io_commit_cqring and __io_cqring_fill_event account
>> for 24.96%. This is too much. In general, the proportion of syscall may not
>> be so high, so we must solve this problem.
>>
>>
>> Solution:
>> =================
>> I consider that when the nr of an io_submit_sqes is too large, we don't call
>> io_cqring_add_event directly, we can put the completed req in the queue, and
>> then call __io_cqring_fill_event for each req then call once io_commit_cqring
>> at the end of the io_submit_sqes function. In this way my local simple test
>> looks good.
> 
> I think the solution here is to defer the cq ring filling + commit to the
> caller instead of deep down the stack, I think that's a nice win in general.
> To do that, we need to be able to do it after io_submit_sqes() has been
> called. We can either do that inline, by passing down a list or struct
> that allows the caller to place the request there instead of filling
> the event, or out-of-band by having eg a percpu struct that allows the
> same thing. In both cases, the actual call site would do something ala:
> 
> if (comp_list && successful_completion) {
> 	req->result = ret;
> 	list_add_tail(&req->list, comp_list);
> } else {
> 	io_cqring_add_event(req, ret);
> 	if (!successful_completion)
> 		req_set_fail_links(req);
> 	io_put_req(req);
> }
> 
> and then have the caller iterate the list and fill completions, if it's
> non-empty on return.
> 
> I don't think this is necessarily hard, but to do it nicely it will
> touch a bunch code and hence be quite a bit of churn. I do think the
> reward is worth it though, as this applies to the "normal" submission
> path as well, not just the SQPOLL variant.

Something like this series. I'd be interested to hear if it makes your
specific test case any better.

Patches are against my for-5.9/io_uring branch.

-- 
Jens Axboe


--------------0E6610594A5A01BEDB4CF812
Content-Type: text/x-patch; charset=UTF-8;
 name="0005-io_uring-enable-READ-WRITE-to-use-deferred-completio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-io_uring-enable-READ-WRITE-to-use-deferred-completio.pa";
 filename*1="tch"

From 941e155f8386b76f5c9788d472a47bf2db4c8aa3 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 22 Jun 2020 11:09:46 -0600
Subject: [PATCH 5/5] io_uring: enable READ/WRITE to use deferred completion
 list

A bit more surgery required here, as completions are generally done
through the kiocb->ki_complete() callback, even if they complete inline.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0c5787f1a376..d415a6126675 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1982,7 +1982,8 @@ static inline void req_set_fail_links(struct io_kiocb *req)
 		req->flags |= REQ_F_FAIL_LINK;
 }
 
-static void io_complete_rw_common(struct kiocb *kiocb, long res)
+static void io_complete_rw_common(struct kiocb *kiocb, long res,
+				  struct list_head *comp_list)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	int cflags = 0;
@@ -1994,7 +1995,7 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 		req_set_fail_links(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_kbuf(req);
-	io_cqring_add_event(req, res, cflags);
+	__io_req_complete(req, res, cflags, comp_list);
 }
 
 static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
@@ -2097,14 +2098,18 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 	return false;
 }
 
+static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
+			     struct list_head *comp_list)
+{
+	if (!io_rw_reissue(req, res))
+		io_complete_rw_common(&req->rw.kiocb, res, comp_list);
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-	if (!io_rw_reissue(req, res)) {
-		io_complete_rw_common(kiocb, res);
-		io_put_req(req);
-	}
+	__io_complete_rw(req, res, res2, NULL);
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
@@ -2338,14 +2343,15 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
-static void kiocb_done(struct kiocb *kiocb, ssize_t ret)
+static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
+		       struct list_head *comp_list)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
 	if (ret >= 0 && kiocb->ki_complete == io_complete_rw)
-		io_complete_rw(kiocb, ret, 0);
+		__io_complete_rw(req, ret, 0, comp_list);
 	else
 		io_rw_done(kiocb, ret);
 }
@@ -2881,7 +2887,8 @@ static int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
 	return loop_rw_iter(READ, req->file, &req->rw.kiocb, iter);
 }
 
-static int io_read(struct io_kiocb *req, bool force_nonblock)
+static int io_read(struct io_kiocb *req, bool force_nonblock,
+		   struct list_head *comp_list)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2916,7 +2923,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
-			kiocb_done(kiocb, ret2);
+			kiocb_done(kiocb, ret2, comp_list);
 		} else {
 			iter.count = iov_count;
 			iter.nr_segs = nr_segs;
@@ -2931,7 +2938,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 				if (ret2 == -EIOCBQUEUED) {
 					goto out_free;
 				} else if (ret2 != -EAGAIN) {
-					kiocb_done(kiocb, ret2);
+					kiocb_done(kiocb, ret2, comp_list);
 					goto out_free;
 				}
 			}
@@ -2977,7 +2984,8 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_write(struct io_kiocb *req, bool force_nonblock)
+static int io_write(struct io_kiocb *req, bool force_nonblock,
+		    struct list_head *comp_list)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -3046,7 +3054,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2);
+			kiocb_done(kiocb, ret2, comp_list);
 		} else {
 			iter.count = iov_count;
 			iter.nr_segs = nr_segs;
@@ -5372,7 +5380,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_read(req, force_nonblock);
+		ret = io_read(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
@@ -5382,7 +5390,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_write(req, force_nonblock);
+		ret = io_write(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_FSYNC:
 		if (sqe) {
-- 
2.27.0


--------------0E6610594A5A01BEDB4CF812
Content-Type: text/x-patch; charset=UTF-8;
 name="0004-io_uring-pass-in-comp_list-to-appropriate-issue-side.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-io_uring-pass-in-comp_list-to-appropriate-issue-side.pa";
 filename*1="tch"

From b26f6d418de1a69c22d0263e1ca05a8903216dfb Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 22 Jun 2020 10:13:11 -0600
Subject: [PATCH 4/5] io_uring: pass in 'comp_list' to appropriate issue side
 handlers

Provide the completion list to the handlers that we know can complete
inline, so they can utilize this for batching completions.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 97 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 40 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d0dda9ba701a..0c5787f1a376 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1352,15 +1352,21 @@ static void io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
 	io_cqring_ev_posted(ctx);
 }
 
-static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags)
+static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
+			      struct list_head *comp_list)
 {
-	io_cqring_add_event(req, res, cflags);
-	io_put_req(req);
+	if (!comp_list) {
+		io_cqring_add_event(req, res, cflags);
+		io_put_req(req);
+	} else {
+		req->result = res;
+		list_add_tail(&req->list, comp_list);
+	}
 }
 
 static void io_req_complete(struct io_kiocb *req, long res)
 {
-	__io_req_complete(req, res, 0);
+	__io_req_complete(req, res, 0, NULL);
 }
 
 static inline bool io_is_fallback_req(struct io_kiocb *req)
@@ -3164,14 +3170,14 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 /*
  * IORING_OP_NOP just posts a completion event, nothing else.
  */
-static int io_nop(struct io_kiocb *req)
+static int io_nop(struct io_kiocb *req, struct list_head *comp_list)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	io_req_complete(req, 0);
+	__io_req_complete(req, 0, 0, comp_list);
 	return 0;
 }
 
@@ -3393,7 +3399,8 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 	return i;
 }
 
-static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock)
+static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock,
+			     struct list_head *comp_list)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3412,7 +3419,7 @@ static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock)
 	io_ring_submit_lock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, comp_list);
 	return 0;
 }
 
@@ -3470,7 +3477,8 @@ static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
 	return i ? i : -ENOMEM;
 }
 
-static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock)
+static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock,
+			      struct list_head *comp_list)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3499,7 +3507,7 @@ static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock)
 	io_ring_submit_unlock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, comp_list);
 	return 0;
 }
 
@@ -3530,7 +3538,8 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock)
+static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock,
+			struct list_head *comp_list)
 {
 #if defined(CONFIG_EPOLL)
 	struct io_epoll *ie = &req->epoll;
@@ -3542,7 +3551,7 @@ static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, comp_list);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3687,7 +3696,8 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_close(struct io_kiocb *req, bool force_nonblock)
+static int io_close(struct io_kiocb *req, bool force_nonblock,
+		    struct list_head *comp_list)
 {
 	struct io_close *close = &req->close;
 	int ret;
@@ -3714,7 +3724,7 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 		req_set_fail_links(req);
 	fput(close->put_file);
 	close->put_file = NULL;
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, comp_list);
 	return 0;
 }
 
@@ -3800,7 +3810,8 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return ret;
 }
 
-static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
+static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
+		      struct list_head *comp_list)
 {
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
@@ -3849,11 +3860,12 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, comp_list);
 	return 0;
 }
 
-static int io_send(struct io_kiocb *req, bool force_nonblock)
+static int io_send(struct io_kiocb *req, bool force_nonblock,
+		   struct list_head *comp_list)
 {
 	struct socket *sock;
 	int ret;
@@ -3891,7 +3903,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, comp_list);
 	return 0;
 }
 
@@ -4034,7 +4046,8 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	return ret;
 }
 
-static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
+static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
+		      struct list_head *comp_list)
 {
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
@@ -4090,11 +4103,12 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, cflags);
+	__io_req_complete(req, ret, cflags, comp_list);
 	return 0;
 }
 
-static int io_recv(struct io_kiocb *req, bool force_nonblock)
+static int io_recv(struct io_kiocb *req, bool force_nonblock,
+		   struct list_head *comp_list)
 {
 	struct io_buffer *kbuf = NULL;
 	struct socket *sock;
@@ -4146,7 +4160,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, cflags);
+	__io_req_complete(req, ret, cflags, comp_list);
 	return 0;
 }
 
@@ -4166,7 +4180,8 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_accept(struct io_kiocb *req, bool force_nonblock)
+static int io_accept(struct io_kiocb *req, bool force_nonblock,
+		     struct list_head *comp_list)
 {
 	struct io_accept *accept = &req->accept;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
@@ -4185,7 +4200,7 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock)
 			ret = -EINTR;
 		req_set_fail_links(req);
 	}
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, comp_list);
 	return 0;
 }
 
@@ -4209,7 +4224,8 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 					&io->connect.address);
 }
 
-static int io_connect(struct io_kiocb *req, bool force_nonblock)
+static int io_connect(struct io_kiocb *req, bool force_nonblock,
+		      struct list_head *comp_list)
 {
 	struct io_async_ctx __io, *io;
 	unsigned file_flags;
@@ -4245,7 +4261,7 @@ static int io_connect(struct io_kiocb *req, bool force_nonblock)
 out:
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, comp_list);
 	return 0;
 }
 #else /* !CONFIG_NET */
@@ -5126,7 +5142,8 @@ static int io_files_update_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_files_update(struct io_kiocb *req, bool force_nonblock)
+static int io_files_update(struct io_kiocb *req, bool force_nonblock,
+			   struct list_head *comp_list)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_files_update up;
@@ -5144,7 +5161,7 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, comp_list);
 	return 0;
 }
 
@@ -5345,7 +5362,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
-		ret = io_nop(req);
+		ret = io_nop(req, comp_list);
 		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
@@ -5407,9 +5424,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				break;
 		}
 		if (req->opcode == IORING_OP_SENDMSG)
-			ret = io_sendmsg(req, force_nonblock);
+			ret = io_sendmsg(req, force_nonblock, comp_list);
 		else
-			ret = io_send(req, force_nonblock);
+			ret = io_send(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_RECVMSG:
 	case IORING_OP_RECV:
@@ -5419,9 +5436,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				break;
 		}
 		if (req->opcode == IORING_OP_RECVMSG)
-			ret = io_recvmsg(req, force_nonblock);
+			ret = io_recvmsg(req, force_nonblock, comp_list);
 		else
-			ret = io_recv(req, force_nonblock);
+			ret = io_recv(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_TIMEOUT:
 		if (sqe) {
@@ -5445,7 +5462,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_accept(req, force_nonblock);
+		ret = io_accept(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_CONNECT:
 		if (sqe) {
@@ -5453,7 +5470,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_connect(req, force_nonblock);
+		ret = io_connect(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
 		if (sqe) {
@@ -5485,7 +5502,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_close(req, force_nonblock);
+		ret = io_close(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_FILES_UPDATE:
 		if (sqe) {
@@ -5493,7 +5510,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_files_update(req, force_nonblock);
+		ret = io_files_update(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_STATX:
 		if (sqe) {
@@ -5533,7 +5550,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_epoll_ctl(req, force_nonblock);
+		ret = io_epoll_ctl(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_SPLICE:
 		if (sqe) {
@@ -5549,7 +5566,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_provide_buffers(req, force_nonblock);
+		ret = io_provide_buffers(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_REMOVE_BUFFERS:
 		if (sqe) {
@@ -5557,7 +5574,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_remove_buffers(req, force_nonblock);
+		ret = io_remove_buffers(req, force_nonblock, comp_list);
 		break;
 	case IORING_OP_TEE:
 		if (sqe) {
-- 
2.27.0


--------------0E6610594A5A01BEDB4CF812
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io_uring-pass-down-comp_list-to-issue-side.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-io_uring-pass-down-comp_list-to-issue-side.patch"

From ac8ce673e64582266e8ce4d35f3e92331efee8dc Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 22 Jun 2020 09:34:30 -0600
Subject: [PATCH 3/5] io_uring: pass down 'comp_list' to issue side

No functional changes in this patch, just in preparation for having the
completion list be available on the issue side. Later on, this will allow
requests that complete inline to be completed in batches.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 66 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bea72642a576..d0dda9ba701a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -901,7 +901,8 @@ static void io_cleanup_req(struct io_kiocb *req);
 static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		       int fd, struct file **out_file, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req,
-			   const struct io_uring_sqe *sqe);
+			   const struct io_uring_sqe *sqe,
+			   struct list_head *comp_list);
 
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter,
@@ -2791,7 +2792,7 @@ static void io_async_buf_retry(struct callback_head *cb)
 	__set_current_state(TASK_RUNNING);
 	if (!io_sq_thread_acquire_mm(ctx, req)) {
 		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(req, NULL);
+		__io_queue_sqe(req, NULL, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	} else {
 		__io_async_buf_error(req, -EFAULT);
@@ -4415,7 +4416,7 @@ static void io_poll_task_func(struct callback_head *cb)
 		struct io_ring_ctx *ctx = nxt->ctx;
 
 		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(nxt, NULL);
+		__io_queue_sqe(nxt, NULL, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	}
 }
@@ -4540,7 +4541,7 @@ static void io_async_task_func(struct callback_head *cb)
 			goto end_req;
 		}
 		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(req, NULL);
+		__io_queue_sqe(req, NULL, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	} else {
 		io_cqring_ev_posted(ctx);
@@ -5337,7 +5338,7 @@ static void io_cleanup_req(struct io_kiocb *req)
 }
 
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			bool force_nonblock)
+			bool force_nonblock, struct list_head *comp_list)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -5622,7 +5623,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 
 	if (!ret) {
 		do {
-			ret = io_issue_sqe(req, NULL, false);
+			ret = io_issue_sqe(req, NULL, false, NULL);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -5799,7 +5800,8 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 	return nxt;
 }
 
-static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			   struct list_head *comp_list)
 {
 	struct io_kiocb *linked_timeout;
 	struct io_kiocb *nxt;
@@ -5819,7 +5821,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			old_creds = override_creds(req->work.creds);
 	}
 
-	ret = io_issue_sqe(req, sqe, true);
+	ret = io_issue_sqe(req, sqe, true, comp_list);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
@@ -5877,7 +5879,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		revert_creds(old_creds);
 }
 
-static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			 struct list_head *comp_list)
 {
 	int ret;
 
@@ -5906,21 +5909,22 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 		io_queue_async_work(req);
 	} else {
-		__io_queue_sqe(req, sqe);
+		__io_queue_sqe(req, sqe, comp_list);
 	}
 }
 
-static inline void io_queue_link_head(struct io_kiocb *req)
+static inline void io_queue_link_head(struct io_kiocb *req,
+				      struct list_head *comp_list)
 {
 	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
 		io_put_req(req);
 		io_req_complete(req, -ECANCELED);
 	} else
-		io_queue_sqe(req, NULL);
+		io_queue_sqe(req, NULL, comp_list);
 }
 
 static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			 struct io_kiocb **link)
+			 struct io_kiocb **link, struct list_head *comp_list)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -5960,7 +5964,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 		/* last request of a link, enqueue the link */
 		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
-			io_queue_link_head(head);
+			io_queue_link_head(head, comp_list);
 			*link = NULL;
 		}
 	} else {
@@ -5980,18 +5984,46 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				req->flags |= REQ_F_FAIL_LINK;
 			*link = req;
 		} else {
-			io_queue_sqe(req, sqe);
+			io_queue_sqe(req, sqe, comp_list);
 		}
 	}
 
 	return 0;
 }
 
+static void io_submit_flush_completions(struct io_submit_state *state)
+{
+	struct io_ring_ctx *ctx = state->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	while (!list_empty(&state->comp_list)) {
+		struct io_kiocb *req;
+
+		req = list_first_entry(&state->comp_list, struct io_kiocb, list);
+		list_del(&req->list);
+		io_cqring_fill_event(req, req->result);
+		if (!(req->flags & REQ_F_LINK_HEAD)) {
+			req->flags |= REQ_F_COMP_LOCKED;
+			io_put_req(req);
+		} else {
+			spin_unlock_irq(&ctx->completion_lock);
+			io_put_req(req);
+			spin_lock_irq(&ctx->completion_lock);
+		}
+	}
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+}
+
 /*
  * Batched submission is done, ensure local IO is flushed out.
  */
 static void io_submit_state_end(struct io_submit_state *state)
 {
+	if (!list_empty(&state->comp_list))
+		io_submit_flush_completions(state);
 	blk_finish_plug(&state->plug);
 	io_state_file_put(state);
 	if (state->free_reqs)
@@ -6180,7 +6212,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, io_async_submit(ctx));
-		err = io_submit_sqe(req, sqe, &link);
+		err = io_submit_sqe(req, sqe, &link, &state.comp_list);
 		if (err)
 			goto fail_req;
 	}
@@ -6191,7 +6223,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		percpu_ref_put_many(&ctx->refs, nr - ref_used);
 	}
 	if (link)
-		io_queue_link_head(link);
+		io_queue_link_head(link, &state.comp_list);
 	io_submit_state_end(&state);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
-- 
2.27.0


--------------0E6610594A5A01BEDB4CF812
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-add-comp_list-to-io_submit_state.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-io_uring-add-comp_list-to-io_submit_state.patch"

From 9eca18f0e902d5fa009dec2867548af6ee5b1da8 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 22 Jun 2020 09:29:15 -0600
Subject: [PATCH 2/5] io_uring: add 'comp_list' to io_submit_state

No functional changes in this patch, just in preparation for passing back
pending completions to the caller.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0cdf088c56cd..bea72642a576 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -681,6 +681,9 @@ struct io_kiocb {
 struct io_submit_state {
 	struct blk_plug		plug;
 
+	struct list_head	comp_list;
+	struct io_ring_ctx	*ctx;
+
 	/*
 	 * io_kiocb alloc cache
 	 */
@@ -5999,12 +6002,14 @@ static void io_submit_state_end(struct io_submit_state *state)
  * Start submission side cache.
  */
 static void io_submit_state_start(struct io_submit_state *state,
-				  unsigned int max_ios)
+				  struct io_ring_ctx *ctx, unsigned int max_ios)
 {
 	blk_start_plug(&state->plug);
 #ifdef CONFIG_BLOCK
 	state->plug.nowait = true;
 #endif
+	INIT_LIST_HEAD(&state->comp_list);
+	state->ctx = ctx;
 	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
@@ -6139,7 +6144,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
-	io_submit_state_start(&state, nr);
+	io_submit_state_start(&state, ctx, nr);
 
 	ctx->ring_fd = ring_fd;
 	ctx->ring_file = ring_file;
-- 
2.27.0


--------------0E6610594A5A01BEDB4CF812
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-provide-generic-io_req_complete-helper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-provide-generic-io_req_complete-helper.patch"

From 55115277bf8e45d9e2a017670b304b1ab7019724 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 22 Jun 2020 09:17:17 -0600
Subject: [PATCH 1/5] io_uring: provide generic io_req_complete() helper

We have lots of callers of:

io_cqring_add_event(req, result);
io_put_req(req);

Provide a helper that does this for us. It helps clean up the code, and
also provides a more convenient location for us to change the completion
handling.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 106 ++++++++++++++++++++------------------------------
 1 file changed, 43 insertions(+), 63 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c686061c3762..0cdf088c56cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1335,7 +1335,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	__io_cqring_fill_event(req, res, 0);
 }
 
-static void __io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
+static void io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
@@ -1348,9 +1348,15 @@ static void __io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
 	io_cqring_ev_posted(ctx);
 }
 
-static void io_cqring_add_event(struct io_kiocb *req, long res)
+static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags)
 {
-	__io_cqring_add_event(req, res, 0);
+	io_cqring_add_event(req, res, cflags);
+	io_put_req(req);
+}
+
+static void io_req_complete(struct io_kiocb *req, long res)
+{
+	__io_req_complete(req, res, 0);
 }
 
 static inline bool io_is_fallback_req(struct io_kiocb *req)
@@ -1978,7 +1984,7 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 		req_set_fail_links(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_kbuf(req);
-	__io_cqring_add_event(req, res, cflags);
+	io_cqring_add_event(req, res, cflags);
 }
 
 static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
@@ -2041,9 +2047,8 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 		return true;
 	kfree(iovec);
 end_req:
-	io_cqring_add_event(req, ret);
 	req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return false;
 }
 
@@ -3110,10 +3115,9 @@ static int io_tee(struct io_kiocb *req, bool force_nonblock)
 	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
-	io_cqring_add_event(req, ret);
 	if (ret != sp->len)
 		req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3147,10 +3151,9 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
-	io_cqring_add_event(req, ret);
 	if (ret != sp->len)
 		req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3164,8 +3167,7 @@ static int io_nop(struct io_kiocb *req)
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	io_cqring_add_event(req, 0);
-	io_put_req(req);
+	io_req_complete(req, 0);
 	return 0;
 }
 
@@ -3204,8 +3206,7 @@ static int io_fsync(struct io_kiocb *req, bool force_nonblock)
 				req->sync.flags & IORING_FSYNC_DATASYNC);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3238,8 +3239,7 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3335,8 +3335,7 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3409,8 +3408,7 @@ static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock)
 	io_ring_submit_lock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3497,8 +3495,7 @@ static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock)
 	io_ring_submit_unlock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3541,8 +3538,7 @@ static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3578,8 +3574,7 @@ static int io_madvise(struct io_kiocb *req, bool force_nonblock)
 	ret = do_madvise(ma->addr, ma->len, ma->advice);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3618,8 +3613,7 @@ static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3658,8 +3652,7 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3715,10 +3708,9 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 	ret = filp_close(close->put_file, req->work.files);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
 	fput(close->put_file);
 	close->put_file = NULL;
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3752,8 +3744,7 @@ static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 				req->sync.flags);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3852,10 +3843,9 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3895,10 +3885,9 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
 			ret = -EINTR;
 	}
 
-	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -4095,10 +4084,9 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
+	__io_req_complete(req, ret, cflags);
 	return 0;
 }
 
@@ -4152,10 +4140,9 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 
 	kfree(kbuf);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
+	__io_req_complete(req, ret, cflags);
 	return 0;
 }
 
@@ -4194,8 +4181,7 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock)
 			ret = -EINTR;
 		req_set_fail_links(req);
 	}
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -4255,8 +4241,7 @@ static int io_connect(struct io_kiocb *req, bool force_nonblock)
 out:
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 #else /* !CONFIG_NET */
@@ -4548,7 +4533,7 @@ static void io_async_task_func(struct callback_head *cb)
 	if (!canceled) {
 		__set_current_state(TASK_RUNNING);
 		if (io_sq_thread_acquire_mm(ctx, req)) {
-			io_cqring_add_event(req, -EFAULT);
+			io_cqring_add_event(req, -EFAULT, 0);
 			goto end_req;
 		}
 		mutex_lock(&ctx->uring_lock);
@@ -4797,10 +4782,9 @@ static int io_poll_remove(struct io_kiocb *req)
 	ret = io_poll_cancel(ctx, addr);
 	spin_unlock_irq(&ctx->completion_lock);
 
-	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -5156,8 +5140,7 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -5650,8 +5633,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 
 	if (ret) {
 		req_set_fail_links(req);
-		io_cqring_add_event(req, ret);
-		io_put_req(req);
+		io_req_complete(req, ret);
 	}
 
 	io_steal_work(req, workptr);
@@ -5768,8 +5750,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req(prev);
 	} else {
-		io_cqring_add_event(req, -ETIME);
-		io_put_req(req);
+		io_req_complete(req, -ETIME);
 	}
 	return HRTIMER_NORESTART;
 }
@@ -5878,9 +5859,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	/* and drop final reference, if we failed */
 	if (ret) {
-		io_cqring_add_event(req, ret);
 		req_set_fail_links(req);
-		io_put_req(req);
+		io_req_complete(req, ret);
 	}
 	if (nxt) {
 		req = nxt;
@@ -5902,9 +5882,9 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
 fail_req:
-			io_cqring_add_event(req, ret);
 			req_set_fail_links(req);
-			io_double_put_req(req);
+			io_put_req(req);
+			io_req_complete(req, ret);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
 		if (!req->io) {
@@ -5930,8 +5910,8 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static inline void io_queue_link_head(struct io_kiocb *req)
 {
 	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
-		io_cqring_add_event(req, -ECANCELED);
-		io_double_put_req(req);
+		io_put_req(req);
+		io_req_complete(req, -ECANCELED);
 	} else
 		io_queue_sqe(req, NULL);
 }
@@ -6188,8 +6168,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 
 		if (unlikely(err)) {
 fail_req:
-			io_cqring_add_event(req, err);
-			io_double_put_req(req);
+			io_put_req(req);
+			io_req_complete(req, err);
 			break;
 		}
 
-- 
2.27.0


--------------0E6610594A5A01BEDB4CF812--
