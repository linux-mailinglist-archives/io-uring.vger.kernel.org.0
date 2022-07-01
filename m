Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDB7562A15
	for <lists+io-uring@lfdr.de>; Fri,  1 Jul 2022 06:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiGAEGu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jul 2022 00:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGAEGt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jul 2022 00:06:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9868C65
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 21:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656648407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q5jk1l3nemtPitwsm3adMLWKvzv1zkSeiDxFawfBWR8=;
        b=M6UG8LySASCXO+6ZK/5yw8a4qExQTLAtEZ4wzpegG+Q+Oj5tUF1hqDQKUoarji8pBAT+2H
        SgQhTE9JiX0Pa4RrgKfJsER0upggFNPzG1hSGdQ5FWaIXf+bvL316qy9BaXBvZ0kSTfvh9
        0SbhTzTUFEId/v/ZWv2Y4AWmp+eNQmI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-dAYBM4ttOnGSIandJPd5PQ-1; Fri, 01 Jul 2022 00:06:46 -0400
X-MC-Unique: dAYBM4ttOnGSIandJPd5PQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B159B1032964;
        Fri,  1 Jul 2022 04:06:45 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82B3A1410F3B;
        Fri,  1 Jul 2022 04:06:38 +0000 (UTC)
Date:   Fri, 1 Jul 2022 12:06:33 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Message-ID: <Yr5yyZuFgTvxasT4@T590>
References: <20220628160807.148853-1-ming.lei@redhat.com>
 <20220628160807.148853-2-ming.lei@redhat.com>
 <fdd06581-a8aa-5948-6043-fc7e3381eb2d@linux.alibaba.com>
 <Yr2YEIoBPOLxq6NB@T590>
 <5cdc86b9-3c8f-48dc-6b14-392df842c4cb@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cdc86b9-3c8f-48dc-6b14-392df842c4cb@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 01, 2022 at 10:47:30AM +0800, Ziyang Zhang wrote:
> On 2022/6/30 20:33, Ming Lei wrote:
> > On Thu, Jun 30, 2022 at 07:35:11PM +0800, Ziyang Zhang wrote:
> >> On 2022/6/29 00:08, Ming Lei wrote:
> >>
> >> [...]
> >>
> >>> +#define UBLK_MAX_PIN_PAGES	32
> >>> +
> >>> +static inline void ublk_release_pages(struct ublk_queue *ubq, struct page **pages,
> >>> +		int nr_pages)
> >>> +{
> >>> +	int i;
> >>> +
> >>> +	for (i = 0; i < nr_pages; i++)
> >>> +		put_page(pages[i]);
> >>> +}
> >>> +
> >>> +static inline int ublk_pin_user_pages(struct ublk_queue *ubq, u64 start_vm,
> >>> +		unsigned int nr_pages, unsigned int gup_flags,
> >>> +		struct page **pages)
> >>> +{
> >>> +	return get_user_pages_fast(start_vm, nr_pages, gup_flags, pages);
> >>> +}
> >>
> >>> +
> >>> +static inline unsigned ublk_copy_bv(struct bio_vec *bv, void **bv_addr,
> >>> +		void *pg_addr, unsigned int *pg_off,
> >>> +		unsigned int *pg_len, bool to_bv)
> >>> +{
> >>> +	unsigned len = min_t(unsigned, bv->bv_len, *pg_len);
> >>> +
> >>> +	if (*bv_addr == NULL)
> >>> +		*bv_addr = kmap_local_page(bv->bv_page);
> >>> +
> >>> +	if (to_bv)
> >>> +		memcpy(*bv_addr + bv->bv_offset, pg_addr + *pg_off, len);
> >>> +	else
> >>> +		memcpy(pg_addr + *pg_off, *bv_addr + bv->bv_offset, len);
> >>> +
> >>> +	bv->bv_offset += len;
> >>> +	bv->bv_len -= len;
> >>> +	*pg_off += len;
> >>> +	*pg_len -= len;
> >>> +
> >>> +	if (!bv->bv_len) {
> >>> +		kunmap_local(*bv_addr);
> >>> +		*bv_addr = NULL;
> >>> +	}
> >>> +
> >>> +	return len;
> >>> +}
> >>> +
> >>> +/* copy rq pages to ublksrv vm address pointed by io->addr */
> >>> +static int ublk_copy_pages(struct ublk_queue *ubq, struct request *rq, bool to_rq,
> >>> +		unsigned int max_bytes)
> >>> +{
> >>> +	unsigned int gup_flags = to_rq ? 0 : FOLL_WRITE;
> >>> +	struct ublk_io *io = &ubq->ios[rq->tag];
> >>> +	struct page *pgs[UBLK_MAX_PIN_PAGES];
> >>> +	struct req_iterator req_iter;
> >>> +	struct bio_vec bv;
> >>> +	const unsigned int rq_bytes = min(blk_rq_bytes(rq), max_bytes);
> >>> +	unsigned long start = io->addr, left = rq_bytes;
> >>> +	unsigned int idx = 0, pg_len = 0, pg_off = 0;
> >>> +	int nr_pin = 0;
> >>> +	void *pg_addr = NULL;
> >>> +	struct page *curr = NULL;
> >>> +
> >>> +	rq_for_each_segment(bv, rq, req_iter) {
> >>> +		unsigned len, bv_off = bv.bv_offset, bv_len = bv.bv_len;
> >>> +		void *bv_addr = NULL;
> >>> +
> >>> +refill:
> >>> +		if (pg_len == 0) {
> >>> +			unsigned int off = 0;
> >>> +
> >>> +			if (pg_addr) {
> >>> +				kunmap_local(pg_addr);
> >>> +				if (!to_rq)
> >>> +					set_page_dirty_lock(curr);
> >>> +				pg_addr = NULL;
> >>> +			}
> >>> +
> >>> +			/* refill pages */
> >>> +			if (idx >= nr_pin) {
> >>> +				unsigned int max_pages;
> >>> +
> >>> +				ublk_release_pages(ubq, pgs, nr_pin);
> >>> +
> >>> +				off = start & (PAGE_SIZE - 1);
> >>> +				max_pages = min_t(unsigned, (off + left +
> >>> +						PAGE_SIZE - 1) >> PAGE_SHIFT,
> >>> +						UBLK_MAX_PIN_PAGES);
> >>> +				nr_pin = ublk_pin_user_pages(ubq, start,
> >>> +						max_pages, gup_flags, pgs);
> >>> +				if (nr_pin < 0)
> >>> +					goto exit;
> >>> +				idx = 0;
> >>> +			}
> >>> +			pg_off = off;
> >>> +			pg_len = min(PAGE_SIZE - off, left);
> >>> +			off = 0;
> >>> +			curr = pgs[idx++];
> >>> +			pg_addr = kmap_local_page(curr);
> >>> +		}
> >>> +
> >>> +		len = ublk_copy_bv(&bv, &bv_addr, pg_addr, &pg_off, &pg_len,
> >>> +				to_rq);
> >>> +		/* either one of the two has been consumed */
> >>> +		WARN_ON_ONCE(bv.bv_len && pg_len);
> >>> +		start += len;
> >>> +		left -= len;
> >>> +
> >>> +		/* overflow */
> >>> +		WARN_ON_ONCE(left > rq_bytes);
> >>> +		WARN_ON_ONCE(bv.bv_len > bv_len);
> >>> +		if (bv.bv_len)
> >>> +			goto refill;
> >>> +
> >>> +		bv.bv_len = bv_len;
> >>> +		bv.bv_offset = bv_off;
> >>> +	}
> >>> +	if (pg_addr) {
> >>> +		kunmap_local(pg_addr);
> >>> +		if (!to_rq)
> >>> +			set_page_dirty_lock(curr);
> >>> +	}
> >>> +	ublk_release_pages(ubq, pgs, nr_pin);
> >>> +
> >>> +exit:
> >>> +	return rq_bytes - left;
> >>> +}
> >>> +
> >>
> >> Hi Ming, 
> >>
> >> I note that you pin the user buffer's pages, memcpy() and release them immediately.
> >>
> >> 1) I think maybe copy_page_from_iter() is another choice for copying user buffer to biovecs
> >>    since copy_page_from_iter() do not pin pages(But it may raise page fault).
> > 
> > copy_page_from_iter/copy_page_to_iter needs the userspage page,
> > then copy between the userspace page and bvec_iter pages, what it does
> > is just kmap/copy/kunmap.
> > 
> > Not see it is useful here.
> 
> 
> No, I don't agree.
> copy_page_from_iter(): copy data from an iovec to kernel pages(such as bio's bv pages).
> It finally calls raw_copy_from_user().
> 
> Here the src(iovec, here it is from user) is actually generated 
> from a single void __user *ubuf, not a userspace page.
> 
> In copy_page_from_iter() I only find kmap/kunmap for the dest(kernel pages)
> but it is unnecessary to kmap/kunmap the src iovec(from user) 
> and please check the exception table usage in this routine.
> I think raw_copy_from_user() inside copy_page_from_iter() should handle page faults.
> 
> You may find blk_rq_map_user() and bio_copy_from_iter() use copy_page_from_iter()
> to copy from  void __user *ubuf to bio's bv pages. 

OK, maybe I misunderstood your point, but I don't think it is good idea:

1) get_user_page_fast() has been proved to be efficient in fast io path,
and relying kernel to handle user page fault should be slower

2) in future, maybe v4, we can extend the pinned page lifetime to
cover the io's lifetime, in this way we can call madvise(MADV_DONTNEED)
in advance for user io buffer before starting ubd device, then once
io is completed, pages pinned for this io can be reclaimed by mm without
needing to swap out, this way will improve memory utilization much.
 

Thanks,
Ming

