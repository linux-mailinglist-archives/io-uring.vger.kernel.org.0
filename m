Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70785691506
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 01:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjBJAAr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 19:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjBJAAr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 19:00:47 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F562552A8
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 16:00:45 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so3899775pjb.5
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 16:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1675987245;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r4xrYX7k8pNOMCdO+PbUbwhGj864sVL1aN/XP73HU+I=;
        b=Tw+BTKsUr0EQW5odh5ywkfSYV3+kKNCQWtZEkzxxhMG1nskJ3XkMn/3BuqpM2/kxnF
         4i4SVE9xOrBqLhExva+1lvO4VXf9kwARzpQxQMKINUTpdiyFQf340v3B2oQ3K6l+cxlh
         7li0VtwcriwPNP/ZldlMD5fBBOcrHl6CrTwRwMlIzIwxhieRCkKKSdYcmacWlzpLRx2M
         EAqb+YBnX1d28ktFszTwo4uEglzaGz58UJ27o4u2PsOaP41VAYL8aKQQnlJtvkPVdxUe
         7/mbYE8iF8Jyp3w31u0xLcYQ7K3cwyBZACkPPb1gE5wXulbTx4/6NP0L6CC2BGi8LicC
         E0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1675987245;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r4xrYX7k8pNOMCdO+PbUbwhGj864sVL1aN/XP73HU+I=;
        b=6IXQCQjrl+R1BWM+Fg2HrlJ/5HPfsdKQ4Nes1RODd+m5/3cNnjCwvH/A+wPDr7GGQX
         xbgvV3PxdkMugzO882pmG1APRU9OmAE4WeTDbDaBFZfntmTyyeZ1jqrdN0f6SlY56X8W
         zjtbCJY4zcYEhf2Gv9p1D1dEU6EoqF2uvm5u0m4hniOfvT5kIkAepQbzKTnUKyQPSoI7
         PjiHlXcGZQfPumiBO8TANwgQfb/MjeuUTeJsGAGqDSiX4aeK9PH6Aw/NMKPQ9/mskHRx
         mUdvydTL3uS5NR1N3o8/PG9Tr0lN9IkJgy1h5I8Uaio5Sg1c7n32TEO0K6YBCH7MPWKx
         Ahmw==
X-Gm-Message-State: AO0yUKUAuB9Zan31+UGjpIMxFQSSEsZoXwhMpB7P5K8d35YfbChiJ7OW
        3NToZ/RDnXVHUsbBJekzWwIG3iTtxJHZoQVK
X-Google-Smtp-Source: AK7set/7wiQJ8hX/bQr52Gwe/bMoFIKJ5ET+pyu/vsvrYnHpEyO8YGl/EVvbndeyTLhcW9NTDsPcVg==
X-Received: by 2002:a17:90a:be08:b0:22c:4b10:39de with SMTP id a8-20020a17090abe0800b0022c4b1039demr4998474pjs.3.1675987244860;
        Thu, 09 Feb 2023 16:00:44 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d14-20020a17090a6a4e00b00230745a7744sm3924900pjm.52.2023.02.09.16.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 16:00:44 -0800 (PST)
Message-ID: <ad80b5d1-111d-2f83-f4e8-f75cdc1462a6@kernel.dk>
Date:   Thu, 9 Feb 2023 17:00:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v8 4/7] io-uring: add napi busy poll support
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230209230144.465620-1-shr@devkernel.io>
 <20230209230144.465620-5-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230209230144.465620-5-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I'd fold 2+3 into this patch again, having them standalone don't really
make a lot of sense without this patch.

This looks a lot better and gets rid of the ifdef infestation! Minor
comments below, mostly just because I think we should fold those 3
patches anyway.

> diff --git a/io_uring/napi.c b/io_uring/napi.c
> new file mode 100644
> index 000000000000..c9e2afae382d
> --- /dev/null
> +++ b/io_uring/napi.c
> @@ -0,0 +1,281 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "io_uring.h"
> +#include "napi.h"
> +
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +
> +/* Timeout for cleanout of stale entries. */
> +#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
> +
> +struct io_napi_ht_entry {
> +	unsigned int		napi_id;
> +	struct list_head	list;
> +
> +	/* Covered by napi lock spinlock.  */
> +	unsigned long		timeout;
> +	struct hlist_node	node;
> +};
> +
> +static inline bool io_napi_busy_loop_on(struct io_ring_ctx *ctx)
> +{
> +	return READ_ONCE(ctx->napi_busy_poll_to);
> +}

I'd probably get rid of this helper, to be honest.

> +static bool io_napi_busy_loop(struct list_head *napi_list, bool prefer_busy_poll)
> +{
> +	struct io_napi_ht_entry *e;
> +	struct io_napi_ht_entry *n;
> +
> +	list_for_each_entry_safe(e, n, napi_list, list) {
> +		napi_busy_loop(e->napi_id, NULL, NULL, prefer_busy_poll,
> +			       BUSY_POLL_BUDGET);
> +	}

Looks like 8 spaces before that BUSY_POLL_BUDGET, should be a tab?

> +static void io_napi_blocking_busy_loop(struct list_head *napi_list,
> +				       struct io_wait_queue *iowq)
> +{
> +	unsigned long start_time = 0;
> +
> +	if (!list_is_singular(napi_list))
> +		start_time = busy_loop_current_time();
> +
> +	while (!list_is_singular(napi_list) &&
> +		io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll) &&
> +		!io_napi_busy_loop_should_end(iowq, start_time)) {
> +		;
> +	}
> +
> +	if (list_is_singular(napi_list)) {
> +		struct io_napi_ht_entry *ne = list_first_entry(napi_list,
> +						 struct io_napi_ht_entry, list);
> +
> +		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
> +			       iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
> +	}
> +}

This does look a LOT better! I do think a helper for the first while
would make sense, and then have a comment in that helper on what this is
doing exactly.

static void io_napi_multi_busy_loop(napi_list, iowq)
{
	unsigned long start_time = busy_loop_current_time();

	do {
		if (list_is_singular(napi_list))
			break;
		if (!io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
			break;
	} while (!io_napi_busy_loop_should_end(iowq, start_time));
}

static void io_napi_blocking_busy_loop(struct list_head *napi_list,
				       struct io_wait_queue *iowq)
{
	if (!list_is_singular(napi_list))
		io_napi_multi_busy_loop(napi_list, iowq);
	if (list_is_singular(napi_list)) {
		struct io_napi_ht_entry *ne;

		ne = list_first_entry(napi_list, struct io_napi_ht_entry, list);
		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
			       iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
	}
}

I think that is still much easier to read rather than all of these
combined statements. What do you think?

> +static void io_napi_merge_lists(struct io_ring_ctx *ctx, struct list_head *napi_list)
> +{
> +	spin_lock(&ctx->napi_lock);
> +	list_splice(napi_list, &ctx->napi_list);
> +	io_napi_remove_stale(ctx);
> +	spin_unlock(&ctx->napi_lock);
> +}

First line too long, split it into two. Did you look into the locking
side like I mentioned in the previous review?

> +/*
> + * io_napi_adjust_busy_loop_timeout() - Add napi id to the busy poll list
> + * @ctx: pointer to io-uring context structure
> + * @iowq: pointer to io wait queue
> + * @napi_list: pointer to head of napi list
> + * @ts: pointer to timespec or NULL
> + *
> + * Adjust the busy loop timeout according to timespec and busy poll timeout.
> + */
> +void io_napi_adjust_busy_loop_timeout(struct io_ring_ctx *ctx,
> +				struct io_wait_queue *iowq,
> +				struct list_head *napi_list,
> +				struct timespec64 *ts)
> +{
> +	if (!list_empty(napi_list)) {
> +		if (ts)
> +			__io_napi_adjust_busy_loop_timeout(
> +				READ_ONCE(ctx->napi_busy_poll_to),
> +				ts, &iowq->napi_busy_poll_to);
> +		else
> +			iowq->napi_busy_poll_to = READ_ONCE(ctx->napi_busy_poll_to);
> +	}
> +}

I'd make this:

void io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
			    struct list_head *napi_list, struct timespec64 *ts)
{
	if (list_empty(napi_list))
		return;

	__io_napi_adjust_timeout(ctx, iowq, napi_list, ts);
}

and put it in the header. That leaves the fast path mostly untouched,
rather than forcing a function call here.

Also note the alignment of the variables in the function header, this
applies in a bunch of spots. And just drop the busy_loop thing from the
naming where it isn't strictly needed, lots of these function names are
really long.


> +/*
> + * io_napi_setup_busy_loop() - setup the busy poll loop
> + * @ctx: pointer to io-uring context structure
> + * @iowq: pointer to io wait queue
> + * @napi_list: pointer to head of napi list
> + *
> + * Capture busy poll timeout and prefer busy poll seeting Splice of the napi list.
> + */
> +void io_napi_setup_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
> +			struct list_head *napi_list)
> +{
> +	iowq->napi_busy_poll_to = 0;
> +	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
> +
> +	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
> +		spin_lock(&ctx->napi_lock);
> +		list_splice_init(&ctx->napi_list, napi_list);
> +		spin_unlock(&ctx->napi_lock);
> +	}
> +}

Might need a comment here on why SQPOLL needs something extra?

> +/*
> + * io_napi_end_busy_loop() - execute busy poll loop
> + * @ctx: pointer to io-uring context structure
> + * @iowq: pointer to io wait queue
> + * @napi_list: pointer to head of napi list
> + *
> + * Execute the busy poll loop and merge the spliced off list.
> + */
> +void io_napi_end_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
> +			struct list_head *napi_list)
> +{
> +	if (iowq->napi_busy_poll_to)
> +		io_napi_blocking_busy_loop(napi_list, iowq);
> +
> +	if (!list_empty(napi_list))
> +		io_napi_merge_lists(ctx, napi_list);
> +}

This should go above the users in this file. Maybe others are like that
too, didn't check.

> +++ b/io_uring/napi.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef IOU_NAPI_H
> +#define IOU_NAPI_H
> +
> +#include <linux/kernel.h>
> +#include <linux/io_uring.h>
> +#include <net/busy_poll.h>
> +
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +
> +#define NAPI_LIST_HEAD(l) LIST_HEAD(l)
> +
> +void io_napi_init(struct io_ring_ctx *ctx);
> +void io_napi_free(struct io_ring_ctx *ctx);
> +
> +void io_napi_add(struct io_kiocb *req);
> +
> +void io_napi_setup_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
> +			struct list_head *napi_list);
> +void io_napi_adjust_busy_loop_timeout(struct io_ring_ctx *ctx,
> +			struct io_wait_queue *iowq, struct list_head *napi_list,
> +			struct timespec64 *ts);
> +void io_napi_end_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
> +			struct list_head *napi_list);
> +
> +#else
> +
> +#define NAPI_LIST_HEAD(l)
> +
> +static inline void io_napi_init(struct io_ring_ctx *ctx)
> +{
> +}
> +
> +static inline void io_napi_free(struct io_ring_ctx *ctx)
> +{
> +}
> +
> +static inline void io_napi_add(struct io_kiocb *req)
> +{
> +}
> +
> +#define io_napi_setup_busy_loop(ctx, iowq, napi_list) do {} while (0)
> +#define io_napi_adjust_busy_loop_timeout(ctx, iowq, napi_list, ts) do {} while (0)
> +#define io_napi_end_busy_loop(ctx, iowq, napi_list) do {} while (0)

This looks way better!

-- 
Jens Axboe

