Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8CA1EA5BE
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 16:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgFAO0u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 10:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgFAO0u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 10:26:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7B9C05BD43;
        Mon,  1 Jun 2020 07:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qcaW7kM1FeNeZDxjYDiBD+HVABREC6q8IwJJi9uWfas=; b=WMihkXKOcI2hSSU0oFKHkV0u1r
        Le+5snAEEYV9wkCUV0VMA+ifWaY0vKrtJGErZFhk1nmn4mPayyHGEcF1rgQvQOjrwpJwQt0gy+Zhw
        3degdL1kgxN7ESOBhBORSVuMTraNHVDmU47PF9Pw+rQGyPi+qmSKYAb6xYytsDvS56vz+dPR2h3oW
        9KUBAdmvnMXdj6UE7/f0yGP9Mcjja6M92/tiG1fHBBH2FkwTvKIbQ0q2e3brpYhKrfnfk61uQ0dIB
        RqOn0IV+1LLV+NnAdgSPw4WzHumgD+TttCYxuwfiP1K5L3U8MSe/hT7C7FvnGbglsOPRyC4/T8aZ5
        cdMRLDng==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jflOr-0003DU-I3; Mon, 01 Jun 2020 14:26:49 +0000
Date:   Mon, 1 Jun 2020 07:26:49 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 04/12] mm: add support for async page locking
Message-ID: <20200601142649.GJ19604@bombadil.infradead.org>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526195123.29053-5-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26, 2020 at 01:51:15PM -0600, Jens Axboe wrote:
> +static int __wait_on_page_locked_async(struct page *page,
> +				       struct wait_page_queue *wait, bool set)
> +{
> +	struct wait_queue_head *q = page_waitqueue(page);
> +	int ret = 0;
> +
> +	wait->page = page;
> +	wait->bit_nr = PG_locked;
> +
> +	spin_lock_irq(&q->lock);
> +	if (set)
> +		ret = !trylock_page(page);
> +	else
> +		ret = PageLocked(page);
> +	if (ret) {
> +		__add_wait_queue_entry_tail(q, &wait->wait);
> +		SetPageWaiters(page);
> +		if (set)
> +			ret = !trylock_page(page);
> +		else
> +			ret = PageLocked(page);

Between the callers and this function, we actually look at PG_lock three
times; once in the caller, then after taking the spinlock, then after
adding ourselves to the waitqueue.  I understand the first and third, but
is it really worth doing the second test?  It feels unlikely to succeed
and only saves us setting PageWaiters.
