Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7A716A269
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 10:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgBXJfs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 04:35:48 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49995 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726216AbgBXJfs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 04:35:48 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 67A702099D;
        Mon, 24 Feb 2020 04:35:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 24 Feb 2020 04:35:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=MxMsqNAb7GAwS1J5Cd2NRuaub8+
        U6Y5YQ4LvFPeCJow=; b=lkyzl70N0cc7uFEPoIQjjRwxXmNzMvsMyDxRugo85Lu
        8QcfeCRRdykcZVPfYcQhaBPH0RsoMhjcmj2EjoFP6pd9RqZdgwXXRSYNY+B15VTx
        siXJEU78ILsP03qf+W9rk6VbMEViHU6h3BjqMyUWs0VjZLff4gB+p5oK/3Ej05N6
        oqmvadVApMa31p/+h11xoMMQGl4i+0BqDPVA2XXjNtW/Sbu/iuoIak8bEuKsemJ8
        xeIMm6d8svVelthUd1iCuGhzkCnzAyEU9ujCggZWlZkGOd4BjnRcKAquxsqp0WHj
        IfjBf4zKgk23UemCeI2M7uK2Gju8CnFgoLMN4tYiaJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MxMsqN
        Ab7GAwS1J5Cd2NRuaub8+U6Y5YQ4LvFPeCJow=; b=qXBENHW3qHCSaNSarfJrFu
        CNGmoBBvxjAh5H/dG4R9JAo3Xzf4C/mXUGMq9+Z2jwMuMFC3sPm2tp5omk2EdSsO
        I0QiLI6KkauChBtU8dT5pCtsRf3mZU/eRs2zhTyJe8wTZURnyC5JDjgZ9az1n7Sq
        L6LymxjW4TidtHY/Lf27QCH7VAtCumsZlUALJlvYnbvztAkItEKQMB+hDjItozd4
        FLXrPhT84SzbOqcHKD5eFrYWWS9Nu38aTpT+17ZE3gtkgQzt89N5chBZQs196iGk
        JHgkNkkwvuhuwzrMOl/ckAFYtOmPczW7hSdJifjv2Dp1NJObb26f+KqToWB4AK8A
        ==
X-ME-Sender: <xms:8phTXtkZWkJNMS2qJ_C2eciL6EiD1H8lbvNkUdROtsaMw-8TzOib6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrledtgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppeeije
    drudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:8phTXktGpRECYOzj9bgqXA8eapbQM4RDtb6dGD6UNZ-tV--QYlRzqg>
    <xmx:8phTXvI2vuA9CGfvkCBbbBUcCR9Tpm43LIPbUX9oUEd7M7amSAub1w>
    <xmx:8phTXhi75WxPU8wSuK5k2awoRZ0STfkx4KJkF9khieeadiVyqyW62g>
    <xmx:85hTXgoM4fNbfepbX8vBhdmA7F9aX6-V3-QayxPgtCx7b5890C7JPQ>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id A2F21328005E;
        Mon, 24 Feb 2020 04:35:46 -0500 (EST)
Date:   Mon, 24 Feb 2020 01:35:44 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: Buffered IO async context overhead
Message-ID: <20200224093544.kg4kmuerevg7zooq@alap3.anarazel.de>
References: <20200214195030.cbnr6msktdl3tqhn@alap3.anarazel.de>
 <c91551b2-9694-78cb-2aa6-bc8cccc474c3@kernel.dk>
 <20200214203140.ksvbm5no654gy7yi@alap3.anarazel.de>
 <4896063a-20d7-d2dd-c75e-a082edd5d72f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4896063a-20d7-d2dd-c75e-a082edd5d72f@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-14 13:49:31 -0700, Jens Axboe wrote:
> [description of buffered write workloads being slower via io_uring
> than plain writes]
> Because I'm working on other items, I didn't read carefully enough. Yes
> this won't change the situation for writes. I'll take a look at this when
> I get time, maybe there's something we can do to improve the situation.

I looked a bit into this.

I think one issue is the spinning the workers do:

static int io_wqe_worker(void *data)
{

	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
		set_current_state(TASK_INTERRUPTIBLE);
loop:
		if (did_work)
			io_worker_spin_for_work(wqe);
		spin_lock_irq(&wqe->lock);
		if (io_wqe_run_queue(wqe)) {

static inline void io_worker_spin_for_work(struct io_wqe *wqe)
{
	int i = 0;

	while (++i < 1000) {
		if (io_wqe_run_queue(wqe))
			break;
		if (need_resched())
			break;
		cpu_relax();
	}
}

even with the cpu_relax(), that causes quite a lot of cross socket
traffic, slowing down the submission side. Which after all frequently
needs to take the wqe->lock, just to be able to submit a queue
entry.

lock, work_list, flags all reside in one cacheline, so it's pretty
likely that a single io_wqe_enqueue would get the cacheline "stolen"
several times during one enqueue - without allowing any progress in the
worker, of course.


I also wonder if we can't avoid dequeuing entries one-by-one within the
worker, at least for the IO_WQ_WORK_HASHED case. Especially when writes
are just hitting the page cache, they're pretty fast, making it
plausible to cause pretty bad contention on the spinlock (even without
the spining above). Whereas the submission side is at least somewhat
likely to be able to submit several queue entries while the worker is
processing one job, that's pretty unlikely for workers.

In the hashed case there shouldn't be another worker processing entries
for the same hash. So it seems quite possible for the wqe to drain a few
of the entries for that hash within one spinlock acquisition, and then
process them one-by-one?

Greetings,

Andres Freund
