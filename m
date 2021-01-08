Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9802EF67B
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 18:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbhAHReG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jan 2021 12:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbhAHReF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jan 2021 12:34:05 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58189C061380;
        Fri,  8 Jan 2021 09:33:25 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id 186so9140039qkj.3;
        Fri, 08 Jan 2021 09:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=niCrEzZ4Zwb/AmCjiCKG8IO1Lknv6I/uxlNpmIn2B8s=;
        b=DN6FtqFmdJSv1e5zhuWoA5rG+8u6H1/zKFWSfbNt4tCa3d8gtVCbZHd18qMLkwb0wW
         IBEjBnKXJ3rhpjgytBcESlREG9rlzxD7Vt1AlAcaz700oL1fAGMMm1H2mfusBJA+CS/9
         PDRFupmGOdQzngWVFI2t5m73/tfggV3amJfWc2OGtVGVc7IH64ySQ++yVkWxtSvhrJqc
         K51znLV8kdsidWUt5wbOwuTBjaFoGy4Vb5Eio8JukeRUSha5eVlJQg3gRWs11OzfDuJP
         /x4WdoJ0/3fC76JFimvoJG9aXyy8n0l3isPgp852TmOUnZz6g3jORz4H0pgGyEUrGq58
         1zhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=niCrEzZ4Zwb/AmCjiCKG8IO1Lknv6I/uxlNpmIn2B8s=;
        b=E3LsefDSBCfPQHWBtfPTS1bkvmrAmRAIu+z0ee7yjNw6Ldi3O8gF1knR+QVJyhQ6YV
         GOEtQFvS5KcwU7jSqZ8iY6kwv7F4mEcVb7SrhYCbheGkcpCYUYr/HafsCZso3w4U7YRh
         EXEYw3BiC8mH9ObPXCcYN0xT5ziSewdsvpJQHHwAgav+oXwbbQ1EFqBU3vC2mtz8govD
         lFFBu6SjYYyJ0TI8nillapVWYtdbh5W9nfIZlIv9EU0DG3o9V9voT85DmwxSb9B5AKWg
         LlxLlTttomO0K7NyoaDXJ6IFIG7aov1cB79EOfrsvgtHqbYnNJh378Dr3mE4Xv8/mbdd
         J8dQ==
X-Gm-Message-State: AOAM530eypdGmOWr8UpOvvZPVLBWFxB/5UH4C2awmWnj4L4IPmZ+FBlT
        nWiueQqJhuP3hfshB0O3b+I=
X-Google-Smtp-Source: ABdhPJxj7c8wIBkEzVGUVgEwDiWQq0r77+LRdemzPoh7f3yF2CAg0W6rbK0iizbA9aGmN+YqKTJvhw==
X-Received: by 2002:ae9:ed41:: with SMTP id c62mr4855441qkg.111.1610127202932;
        Fri, 08 Jan 2021 09:33:22 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id m64sm5145000qkb.90.2021.01.08.09.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 09:33:21 -0800 (PST)
Sender: Mike Snitzer <snitzer@gmail.com>
Date:   Fri, 8 Jan 2021 12:33:20 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 3/7] block: add iopoll method for non-mq device
Message-ID: <20210108173320.GA6584@lobo>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-4-jefflexu@linux.alibaba.com>
 <20210107214758.GC21239@redhat.com>
 <b081f3bd-fc6f-f7c1-80eb-c8380fc8e8b9@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b081f3bd-fc6f-f7c1-80eb-c8380fc8e8b9@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 07 2021 at 10:24pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> 
> 
> On 1/8/21 5:47 AM, Mike Snitzer wrote:
> > On Wed, Dec 23 2020 at  6:26am -0500,
> > Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> > 
> >> ->poll_fn is introduced in commit ea435e1b9392 ("block: add a poll_fn
> >> callback to struct request_queue") for supporting non-mq queues such as
> >> nvme multipath, but removed in commit 529262d56dbe ("block: remove
> >> ->poll_fn").
> >>
> >> To add support of IO polling for non-mq device, this method need to be
> >> back. Since commit c62b37d96b6e ("block: move ->make_request_fn to
> >> struct block_device_operations") has moved all callbacks into struct
> >> block_device_operations in gendisk, we also add the new method named
> >> ->iopoll in block_device_operations.
> > 
> > Please update patch subject and header to:
> > 
> > block: add iopoll method to support bio-based IO polling
> > 
> > ->poll_fn was introduced in commit ea435e1b9392 ("block: add a poll_fn
> > callback to struct request_queue") to support bio-based queues such as
> > nvme multipath, but was later removed in commit 529262d56dbe ("block:
> > remove ->poll_fn").
> > 
> > Given commit c62b37d96b6e ("block: move ->make_request_fn to struct
> > block_device_operations") restore the possibility of bio-based IO
> > polling support by adding an ->iopoll method to gendisk->fops.
> > Elevate bulk of blk_mq_poll() implementation to blk_poll() and reduce
> > blk_mq_poll() to blk-mq specific code that is called from blk_poll().
> > 
> >> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> >> ---
> >>  block/blk-core.c       | 79 ++++++++++++++++++++++++++++++++++++++++++
> >>  block/blk-mq.c         | 70 +++++--------------------------------
> >>  include/linux/blk-mq.h |  3 ++
> >>  include/linux/blkdev.h |  1 +
> >>  4 files changed, 92 insertions(+), 61 deletions(-)
> >>
> >> diff --git a/block/blk-core.c b/block/blk-core.c
> >> index 96e5fcd7f071..2f5c51ce32e3 100644
> >> --- a/block/blk-core.c
> >> +++ b/block/blk-core.c
> >> @@ -1131,6 +1131,85 @@ blk_qc_t submit_bio(struct bio *bio)
> >>  }
> >>  EXPORT_SYMBOL(submit_bio);
> >>  
> >> +static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
> >> +{
> >> +	struct blk_mq_hw_ctx *hctx;
> >> +
> >> +	/* TODO: bio-based device doesn't support hybrid poll. */
> >> +	if (!queue_is_mq(q))
> >> +		return false;
> >> +
> >> +	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> >> +	if (blk_mq_poll_hybrid(q, hctx, cookie))
> >> +		return true;
> >> +
> >> +	hctx->poll_considered++;
> >> +	return false;
> >> +}
> > 
> > I don't see where you ever backfill bio-based hybrid support (in
> > the following patches in this series, so it is lingering TODO).
> 
> Yes the hybrid polling is not implemented and thus bypassed for
> bio-based device currently.
> 
> > 
> >> +
> >> +/**
> >> + * blk_poll - poll for IO completions
> >> + * @q:  the queue
> >> + * @cookie: cookie passed back at IO submission time
> >> + * @spin: whether to spin for completions
> >> + *
> >> + * Description:
> >> + *    Poll for completions on the passed in queue. Returns number of
> >> + *    completed entries found. If @spin is true, then blk_poll will continue
> >> + *    looping until at least one completion is found, unless the task is
> >> + *    otherwise marked running (or we need to reschedule).
> >> + */
> >> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> >> +{
> >> +	long state;
> >> +
> >> +	if (!blk_qc_t_valid(cookie) ||
> >> +	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> >> +		return 0;
> >> +
> >> +	if (current->plug)
> >> +		blk_flush_plug_list(current->plug, false);
> >> +
> >> +	/*
> >> +	 * If we sleep, have the caller restart the poll loop to reset
> >> +	 * the state. Like for the other success return cases, the
> >> +	 * caller is responsible for checking if the IO completed. If
> >> +	 * the IO isn't complete, we'll get called again and will go
> >> +	 * straight to the busy poll loop. If specified not to spin,
> >> +	 * we also should not sleep.
> >> +	 */
> >> +	if (spin && blk_poll_hybrid(q, cookie))
> >> +		return 1;
> >> +
> >> +	state = current->state;
> >> +	do {
> >> +		int ret;
> >> +		struct gendisk *disk = queue_to_disk(q);
> >> +
> >> +		if (disk->fops->iopoll)
> >> +			ret = disk->fops->iopoll(q, cookie);
> >> +		else
> >> +			ret = blk_mq_poll(q, cookie);
> 
> The original code is indeed buggy. For bio-based device, ->iopoll() may
> not be implemented while QUEUE_FLAG_POLL flag is still set, in which
> case blk_mq_poll() will be called for this bio-based device.

Yes, here is the patch I created to capture my suggestions.  Provided it
looks good to you, please fold it into patch 3 when you rebase for
posting a v2 of your patchset:

From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 7 Jan 2021 20:45:17 -0500
Subject: [PATCH] fixup patch 3

---
 block/blk-core.c       | 51 +++++++++++++++++++++-----------------------------
 block/blk-mq.c         |  6 ++----
 include/linux/blk-mq.h |  3 ++-
 3 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e6671f6ce1a4..44f62dc0fa9f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1212,22 +1212,6 @@ int blk_bio_poll(struct request_queue *q, blk_qc_t cookie)
 }
 EXPORT_SYMBOL(blk_bio_poll);
 
-static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
-{
-	struct blk_mq_hw_ctx *hctx;
-
-	/* TODO: bio-based device doesn't support hybrid poll. */
-	if (!queue_is_mq(q))
-		return false;
-
-	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
-	if (blk_mq_poll_hybrid(q, hctx, cookie))
-		return true;
-
-	hctx->poll_considered++;
-	return false;
-}
-
 /**
  * blk_poll - poll for IO completions
  * @q:  the queue
@@ -1243,6 +1227,8 @@ static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
 int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 {
 	long state;
+	struct blk_mq_hw_ctx *hctx = NULL;
+	struct gendisk *disk = NULL;
 
 	if (!blk_qc_t_valid(cookie) ||
 	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
@@ -1251,26 +1237,31 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	if (current->plug)
 		blk_flush_plug_list(current->plug, false);
 
-	/*
-	 * If we sleep, have the caller restart the poll loop to reset
-	 * the state. Like for the other success return cases, the
-	 * caller is responsible for checking if the IO completed. If
-	 * the IO isn't complete, we'll get called again and will go
-	 * straight to the busy poll loop. If specified not to spin,
-	 * we also should not sleep.
-	 */
-	if (spin && blk_poll_hybrid(q, cookie))
-		return 1;
+	if (queue_is_mq(q)) {
+		/*
+		 * If we sleep, have the caller restart the poll loop to reset
+		 * the state. Like for the other success return cases, the
+		 * caller is responsible for checking if the IO completed. If
+		 * the IO isn't complete, we'll get called again and will go
+		 * straight to the busy poll loop. If specified not to spin,
+		 * we also should not sleep.
+		 */
+		hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
+		if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
+			return 1;
+		hctx->poll_considered++;
+	} else
+		disk = queue_to_disk(q);
 
 	state = current->state;
 	do {
 		int ret;
-		struct gendisk *disk = queue_to_disk(q);
 
-		if (disk->fops->iopoll)
+		if (hctx)
+			ret = blk_mq_poll(q, hctx, cookie);
+		else if (disk->fops->iopoll)
 			ret = disk->fops->iopoll(q, cookie);
-		else
-			ret = blk_mq_poll(q, cookie);
+
 		if (ret > 0) {
 			__set_current_state(TASK_RUNNING);
 			return ret;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index fcb44604f806..90d8dead1da5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3826,12 +3826,10 @@ bool blk_mq_poll_hybrid(struct request_queue *q,
 	return blk_mq_poll_hybrid_sleep(q, rq);
 }
 
-int blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
+int blk_mq_poll(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
 {
 	int ret;
-	struct blk_mq_hw_ctx *hctx;
-
-	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
 
 	hctx->poll_invoked++;
 	ret = q->mq_ops->poll(hctx);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2f3742207df5..b95f2ffa866f 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -607,7 +607,8 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 }
 
 blk_qc_t blk_mq_submit_bio(struct bio *bio);
-int blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
+int blk_mq_poll(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
 bool blk_mq_poll_hybrid(struct request_queue *q,
 		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
-- 
2.15.0

