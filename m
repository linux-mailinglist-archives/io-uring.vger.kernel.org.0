Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3AB561A63
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 14:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiF3Mdi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 08:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbiF3Mdi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 08:33:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6ACFE34659
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 05:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656592416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cgnrW5cxLH48CnZyxRoYJ8gOY4LsyuFZedpGVmm6qFI=;
        b=b4NwW4MbHSljygQawo0uDvJ1u+9cxbeL7HB6eQAROPTGyVwhuDT/yizJeLkhX5tFWHAy69
        ZkFT1rGey5NhbGiHo2BrLZWcP2VCEK6UINHstFyjY+sWRJeAfDcvPgVGcfUnUOKKzYXO2s
        oS/d8cRRrk8dUMUqgNgql66EGEZFRjA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-OqXdsN7APpq7dDidBfWA8Q-1; Thu, 30 Jun 2022 08:33:33 -0400
X-MC-Unique: OqXdsN7APpq7dDidBfWA8Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C3AE801233;
        Thu, 30 Jun 2022 12:33:32 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EC292026D64;
        Thu, 30 Jun 2022 12:33:25 +0000 (UTC)
Date:   Thu, 30 Jun 2022 20:33:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, ming.lei@redhat.com
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Message-ID: <Yr2YEIoBPOLxq6NB@T590>
References: <20220628160807.148853-1-ming.lei@redhat.com>
 <20220628160807.148853-2-ming.lei@redhat.com>
 <fdd06581-a8aa-5948-6043-fc7e3381eb2d@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdd06581-a8aa-5948-6043-fc7e3381eb2d@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 30, 2022 at 07:35:11PM +0800, Ziyang Zhang wrote:
> On 2022/6/29 00:08, Ming Lei wrote:
> 
> [...]
> 
> > +#define UBLK_MAX_PIN_PAGES	32
> > +
> > +static inline void ublk_release_pages(struct ublk_queue *ubq, struct page **pages,
> > +		int nr_pages)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < nr_pages; i++)
> > +		put_page(pages[i]);
> > +}
> > +
> > +static inline int ublk_pin_user_pages(struct ublk_queue *ubq, u64 start_vm,
> > +		unsigned int nr_pages, unsigned int gup_flags,
> > +		struct page **pages)
> > +{
> > +	return get_user_pages_fast(start_vm, nr_pages, gup_flags, pages);
> > +}
> 
> > +
> > +static inline unsigned ublk_copy_bv(struct bio_vec *bv, void **bv_addr,
> > +		void *pg_addr, unsigned int *pg_off,
> > +		unsigned int *pg_len, bool to_bv)
> > +{
> > +	unsigned len = min_t(unsigned, bv->bv_len, *pg_len);
> > +
> > +	if (*bv_addr == NULL)
> > +		*bv_addr = kmap_local_page(bv->bv_page);
> > +
> > +	if (to_bv)
> > +		memcpy(*bv_addr + bv->bv_offset, pg_addr + *pg_off, len);
> > +	else
> > +		memcpy(pg_addr + *pg_off, *bv_addr + bv->bv_offset, len);
> > +
> > +	bv->bv_offset += len;
> > +	bv->bv_len -= len;
> > +	*pg_off += len;
> > +	*pg_len -= len;
> > +
> > +	if (!bv->bv_len) {
> > +		kunmap_local(*bv_addr);
> > +		*bv_addr = NULL;
> > +	}
> > +
> > +	return len;
> > +}
> > +
> > +/* copy rq pages to ublksrv vm address pointed by io->addr */
> > +static int ublk_copy_pages(struct ublk_queue *ubq, struct request *rq, bool to_rq,
> > +		unsigned int max_bytes)
> > +{
> > +	unsigned int gup_flags = to_rq ? 0 : FOLL_WRITE;
> > +	struct ublk_io *io = &ubq->ios[rq->tag];
> > +	struct page *pgs[UBLK_MAX_PIN_PAGES];
> > +	struct req_iterator req_iter;
> > +	struct bio_vec bv;
> > +	const unsigned int rq_bytes = min(blk_rq_bytes(rq), max_bytes);
> > +	unsigned long start = io->addr, left = rq_bytes;
> > +	unsigned int idx = 0, pg_len = 0, pg_off = 0;
> > +	int nr_pin = 0;
> > +	void *pg_addr = NULL;
> > +	struct page *curr = NULL;
> > +
> > +	rq_for_each_segment(bv, rq, req_iter) {
> > +		unsigned len, bv_off = bv.bv_offset, bv_len = bv.bv_len;
> > +		void *bv_addr = NULL;
> > +
> > +refill:
> > +		if (pg_len == 0) {
> > +			unsigned int off = 0;
> > +
> > +			if (pg_addr) {
> > +				kunmap_local(pg_addr);
> > +				if (!to_rq)
> > +					set_page_dirty_lock(curr);
> > +				pg_addr = NULL;
> > +			}
> > +
> > +			/* refill pages */
> > +			if (idx >= nr_pin) {
> > +				unsigned int max_pages;
> > +
> > +				ublk_release_pages(ubq, pgs, nr_pin);
> > +
> > +				off = start & (PAGE_SIZE - 1);
> > +				max_pages = min_t(unsigned, (off + left +
> > +						PAGE_SIZE - 1) >> PAGE_SHIFT,
> > +						UBLK_MAX_PIN_PAGES);
> > +				nr_pin = ublk_pin_user_pages(ubq, start,
> > +						max_pages, gup_flags, pgs);
> > +				if (nr_pin < 0)
> > +					goto exit;
> > +				idx = 0;
> > +			}
> > +			pg_off = off;
> > +			pg_len = min(PAGE_SIZE - off, left);
> > +			off = 0;
> > +			curr = pgs[idx++];
> > +			pg_addr = kmap_local_page(curr);
> > +		}
> > +
> > +		len = ublk_copy_bv(&bv, &bv_addr, pg_addr, &pg_off, &pg_len,
> > +				to_rq);
> > +		/* either one of the two has been consumed */
> > +		WARN_ON_ONCE(bv.bv_len && pg_len);
> > +		start += len;
> > +		left -= len;
> > +
> > +		/* overflow */
> > +		WARN_ON_ONCE(left > rq_bytes);
> > +		WARN_ON_ONCE(bv.bv_len > bv_len);
> > +		if (bv.bv_len)
> > +			goto refill;
> > +
> > +		bv.bv_len = bv_len;
> > +		bv.bv_offset = bv_off;
> > +	}
> > +	if (pg_addr) {
> > +		kunmap_local(pg_addr);
> > +		if (!to_rq)
> > +			set_page_dirty_lock(curr);
> > +	}
> > +	ublk_release_pages(ubq, pgs, nr_pin);
> > +
> > +exit:
> > +	return rq_bytes - left;
> > +}
> > +
> 
> Hi Ming, 
> 
> I note that you pin the user buffer's pages, memcpy() and release them immediately.
> 
> 1) I think maybe copy_page_from_iter() is another choice for copying user buffer to biovecs
>    since copy_page_from_iter() do not pin pages(But it may raise page fault).

copy_page_from_iter/copy_page_to_iter needs the userspage page,
then copy between the userspace page and bvec_iter pages, what it does
is just kmap/copy/kunmap.

Not see it is useful here.

> 
> 2) Or will you design some mechanism such as LRU to manage these pinned pages? 
>    For example pin those pages frequently required for a long time and release
>    those pages not used for a long time.
>    I remember you have talked about this LRU on pinned pages?

I'd explain it a bit.

When I worked on v1/v2, 'perf report' shows that get_user_pages_fast()
as one of top samples. Turns out it is a bug, which is fixed in

https://github.com/ming1/linux/commit/3c9fd476951759858cc548dee4cedc074194d0b0

After the issue is fixed, not see get_user_pages_fast() being hot spot
any more. I actually implemented one patch which pins all pages in
the ubd device whole lifetime, but not see obvious improvement, so I gave
up the idea.

In the test VM on my laptop, single job ubd/null randwrite can reach 700K iops.

> 
> Which one do you think is better? copy_page_from_iter() or pin pages with LRU?
> Maybe it depends on the user's workload?

So far in the enablement stage, I think the current approach is just fine,
but we still can improve it in future.


Thanks,
Ming

