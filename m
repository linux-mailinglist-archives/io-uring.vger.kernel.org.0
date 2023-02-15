Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8FC6981EE
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 18:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjBOR0s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 12:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjBOR0r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 12:26:47 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B7E39CF7
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 09:26:27 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6676F5C0193;
        Wed, 15 Feb 2023 12:26:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Feb 2023 12:26:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1676481986; x=1676568386; bh=tbLxJ8k5ke
        PwYJh0MRMj5kqQ4IlnKGIkv42OBJ3PMFA=; b=g84zFJnatQsvIuYm4rVannSVxQ
        t9Iidzyw11jzykdWMNec6VIIwP2uiPrhRvCp+hDbbwF/Zt8XyJzwhox8GDFhzKeN
        dwb80bqvE68ewDJ4dPCjEe+jxluXX9SEmTXRq7ihBcbPcnfJhlzc4QRUgQKK+y3Q
        o/tEUUMVTEenjP0z8003YWUHt7+oxymIRACGmqgQyYYPYsPQv8TKKoaDEr1I5rgt
        hp08ocklTcBnLnOVtiEvPDwxMyZ1BoTsUn4aRabmkezCNusV1QKia1fO0RLXyuFh
        k5zR7khgYpGNM4T2GHdXJ8yVuNdg5Zy4GQOs5l0gKfFqnjLTyEF+JVxAUJ2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676481986; x=1676568386; bh=tbLxJ8k5kePwYJh0MRMj5kqQ4Iln
        KGIkv42OBJ3PMFA=; b=rDaJo0q55/hFA/okpubGxoTsW2OYiX4b9UeviUi2jlrT
        8VeqOxLu8z4mzmEtc42z5NO9GMeF/w5xr67ImUr9muS0eb81xgGUzPj34GOFeb0i
        XqKoE5vR4mOJwgoUxYs4V+tKmdaVoU8fUja4k45fzggasdzMrMv2VLHRTpcXSm8+
        2qC0bN2NYwTMjTiyNFG6T+2G2us42hyW1uXPQ/jNgUZZ4vgSGoSU2pk2vbUXq4BP
        OQ1NB3cTrGlm/98RhXnZrQNDMFNevr2lVC88WLyD2EfSHiDpwNKGKE0AWuGKwea+
        myMzdepez3XEPSgFe/5pphEwrxqco+oDWSyBHZaanw==
X-ME-Sender: <xms:whXtY_TbuzoUMmjq0a952-zAbMyDKzPFvMeRuqa55cS4Ykwhh9bXCg>
    <xme:whXtYwz7f26aRvAhuBybc8LSygJb04L8hAHOLgBi95lTcvOEh5_jAKbBzzWQrG2p8
    IiYTGb-hWdd5fUUptk>
X-ME-Received: <xmr:whXtY00Ee9bY5vkHru7nGdKdhOfbR6B8GIJuYCZujtwV5LkbHNsQLRiguJtvPh0vr7kbVPKIvnSsCWfeq8VbSFaqwKFSzW6YW_siLxbD>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeihedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:whXtY_BuHdqd74_LKIXwUO4L3V4dyOEdZvcGfQOwHjbMOh_dJOcLsA>
    <xmx:whXtY4igt_EQ8RbspyC-xjiE5w1BylmLH3HX0ibYtb9YAMz-EwzBrQ>
    <xmx:whXtYzomsFNERimX0QTSjlC23KvDtZqtFky0JBzcUt6UXXgSgHSjWQ>
    <xmx:whXtYwfS5KGzTtdVUgu-XFJ7YKFKey_ZIFmeGlqIhrEJNuw9t68_OQ>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Feb 2023 12:26:25 -0500 (EST)
References: <20230209230144.465620-1-shr@devkernel.io>
 <20230209230144.465620-5-shr@devkernel.io>
 <ad80b5d1-111d-2f83-f4e8-f75cdc1462a6@kernel.dk>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v8 4/7] io-uring: add napi busy poll support
Date:   Wed, 15 Feb 2023 09:22:25 -0800
In-reply-to: <ad80b5d1-111d-2f83-f4e8-f75cdc1462a6@kernel.dk>
Message-ID: <qvqwh6vmalhf.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

> I'd fold 2+3 into this patch again, having them standalone don't really
> make a lot of sense without this patch.
>
> This looks a lot better and gets rid of the ifdef infestation! Minor
> comments below, mostly just because I think we should fold those 3
> patches anyway.
>
>> diff --git a/io_uring/napi.c b/io_uring/napi.c
>> new file mode 100644
>> index 000000000000..c9e2afae382d
>> --- /dev/null
>> +++ b/io_uring/napi.c
>> @@ -0,0 +1,281 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include "io_uring.h"
>> +#include "napi.h"
>> +
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +
>> +/* Timeout for cleanout of stale entries. */
>> +#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
>> +
>> +struct io_napi_ht_entry {
>> +	unsigned int		napi_id;
>> +	struct list_head	list;
>> +
>> +	/* Covered by napi lock spinlock.  */
>> +	unsigned long		timeout;
>> +	struct hlist_node	node;
>> +};
>> +
>> +static inline bool io_napi_busy_loop_on(struct io_ring_ctx *ctx)
>> +{
>> +	return READ_ONCE(ctx->napi_busy_poll_to);
>> +}
>
> I'd probably get rid of this helper, to be honest.
>

I removed the helper in the next version.

>> +static bool io_napi_busy_loop(struct list_head *napi_list, bool prefer_busy_poll)
>> +{
>> +	struct io_napi_ht_entry *e;
>> +	struct io_napi_ht_entry *n;
>> +
>> +	list_for_each_entry_safe(e, n, napi_list, list) {
>> +		napi_busy_loop(e->napi_id, NULL, NULL, prefer_busy_poll,
>> +			       BUSY_POLL_BUDGET);
>> +	}
>
> Looks like 8 spaces before that BUSY_POLL_BUDGET, should be a tab?
>

Fixed.

>> +static void io_napi_blocking_busy_loop(struct list_head *napi_list,
>> +				       struct io_wait_queue *iowq)
>> +{
>> +	unsigned long start_time = 0;
>> +
>> +	if (!list_is_singular(napi_list))
>> +		start_time = busy_loop_current_time();
>> +
>> +	while (!list_is_singular(napi_list) &&
>> +		io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll) &&
>> +		!io_napi_busy_loop_should_end(iowq, start_time)) {
>> +		;
>> +	}
>> +
>> +	if (list_is_singular(napi_list)) {
>> +		struct io_napi_ht_entry *ne = list_first_entry(napi_list,
>> +						 struct io_napi_ht_entry, list);
>> +
>> +		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
>> +			       iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
>> +	}
>> +}
>
> This does look a LOT better! I do think a helper for the first while
> would make sense, and then have a comment in that helper on what this is
> doing exactly.
>
> static void io_napi_multi_busy_loop(napi_list, iowq)
> {
> 	unsigned long start_time = busy_loop_current_time();
>
> 	do {
> 		if (list_is_singular(napi_list))
> 			break;
> 		if (!io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
> 			break;
> 	} while (!io_napi_busy_loop_should_end(iowq, start_time));
> }
>
> static void io_napi_blocking_busy_loop(struct list_head *napi_list,
> 				       struct io_wait_queue *iowq)
> {
> 	if (!list_is_singular(napi_list))
> 		io_napi_multi_busy_loop(napi_list, iowq);
> 	if (list_is_singular(napi_list)) {
> 		struct io_napi_ht_entry *ne;
>
> 		ne = list_first_entry(napi_list, struct io_napi_ht_entry, list);
> 		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
> 			       iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
> 	}
> }
>
> I think that is still much easier to read rather than all of these
> combined statements. What do you think?
>

I personally prefer the while loop, but I made the above change in the
next version.

>> +static void io_napi_merge_lists(struct io_ring_ctx *ctx, struct list_head *napi_list)
>> +{
>> +	spin_lock(&ctx->napi_lock);
>> +	list_splice(napi_list, &ctx->napi_list);
>> +	io_napi_remove_stale(ctx);
>> +	spin_unlock(&ctx->napi_lock);
>> +}
>
> First line too long, split it into two. Did you look into the locking
> side like I mentioned in the previous review?
>

Fixed.

I looked at the locking, however not all code path where io_napi_add is
called guarantee that the io-uring lock is taken.

>> +/*
>> + * io_napi_adjust_busy_loop_timeout() - Add napi id to the busy poll list
>> + * @ctx: pointer to io-uring context structure
>> + * @iowq: pointer to io wait queue
>> + * @napi_list: pointer to head of napi list
>> + * @ts: pointer to timespec or NULL
>> + *
>> + * Adjust the busy loop timeout according to timespec and busy poll timeout.
>> + */
>> +void io_napi_adjust_busy_loop_timeout(struct io_ring_ctx *ctx,
>> +				struct io_wait_queue *iowq,
>> +				struct list_head *napi_list,
>> +				struct timespec64 *ts)
>> +{
>> +	if (!list_empty(napi_list)) {
>> +		if (ts)
>> +			__io_napi_adjust_busy_loop_timeout(
>> +				READ_ONCE(ctx->napi_busy_poll_to),
>> +				ts, &iowq->napi_busy_poll_to);
>> +		else
>> +			iowq->napi_busy_poll_to = READ_ONCE(ctx->napi_busy_poll_to);
>> +	}
>> +}
>
> I'd make this:
>
> void io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
> 			    struct list_head *napi_list, struct timespec64 *ts)
> {
> 	if (list_empty(napi_list))
> 		return;
>
> 	__io_napi_adjust_timeout(ctx, iowq, napi_list, ts);
> }
>
> and put it in the header. That leaves the fast path mostly untouched,
> rather than forcing a function call here.
>
> Also note the alignment of the variables in the function header, this
> applies in a bunch of spots. And just drop the busy_loop thing from the
> naming where it isn't strictly needed, lots of these function names are
> really long.
>
>

Unfortunately the function doesn't get inlined. I added a new helper
io_napi to avoid this case.

>> +/*
>> + * io_napi_setup_busy_loop() - setup the busy poll loop
>> + * @ctx: pointer to io-uring context structure
>> + * @iowq: pointer to io wait queue
>> + * @napi_list: pointer to head of napi list
>> + *
>> + * Capture busy poll timeout and prefer busy poll seeting Splice of the napi list.
>> + */
>> +void io_napi_setup_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
>> +			struct list_head *napi_list)
>> +{
>> +	iowq->napi_busy_poll_to = 0;
>> +	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
>> +
>> +	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
>> +		spin_lock(&ctx->napi_lock);
>> +		list_splice_init(&ctx->napi_list, napi_list);
>> +		spin_unlock(&ctx->napi_lock);
>> +	}
>> +}
>
> Might need a comment here on why SQPOLL needs something extra?
>

I added a comment.

>> +/*
>> + * io_napi_end_busy_loop() - execute busy poll loop
>> + * @ctx: pointer to io-uring context structure
>> + * @iowq: pointer to io wait queue
>> + * @napi_list: pointer to head of napi list
>> + *
>> + * Execute the busy poll loop and merge the spliced off list.
>> + */
>> +void io_napi_end_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
>> +			struct list_head *napi_list)
>> +{
>> +	if (iowq->napi_busy_poll_to)
>> +		io_napi_blocking_busy_loop(napi_list, iowq);
>> +
>> +	if (!list_empty(napi_list))
>> +		io_napi_merge_lists(ctx, napi_list);
>> +}
>
> This should go above the users in this file. Maybe others are like that
> too, didn't check.
>

There are no users in this file.

>> +++ b/io_uring/napi.h
>> @@ -0,0 +1,49 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#ifndef IOU_NAPI_H
>> +#define IOU_NAPI_H
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/io_uring.h>
>> +#include <net/busy_poll.h>
>> +
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +
>> +#define NAPI_LIST_HEAD(l) LIST_HEAD(l)
>> +
>> +void io_napi_init(struct io_ring_ctx *ctx);
>> +void io_napi_free(struct io_ring_ctx *ctx);
>> +
>> +void io_napi_add(struct io_kiocb *req);
>> +
>> +void io_napi_setup_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
>> +			struct list_head *napi_list);
>> +void io_napi_adjust_busy_loop_timeout(struct io_ring_ctx *ctx,
>> +			struct io_wait_queue *iowq, struct list_head *napi_list,
>> +			struct timespec64 *ts);
>> +void io_napi_end_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
>> +			struct list_head *napi_list);
>> +
>> +#else
>> +
>> +#define NAPI_LIST_HEAD(l)
>> +
>> +static inline void io_napi_init(struct io_ring_ctx *ctx)
>> +{
>> +}
>> +
>> +static inline void io_napi_free(struct io_ring_ctx *ctx)
>> +{
>> +}
>> +
>> +static inline void io_napi_add(struct io_kiocb *req)
>> +{
>> +}
>> +
>> +#define io_napi_setup_busy_loop(ctx, iowq, napi_list) do {} while (0)
>> +#define io_napi_adjust_busy_loop_timeout(ctx, iowq, napi_list, ts) do {} while (0)
>> +#define io_napi_end_busy_loop(ctx, iowq, napi_list) do {} while (0)
>
> This looks way better!
