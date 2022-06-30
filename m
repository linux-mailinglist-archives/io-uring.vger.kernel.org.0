Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235AD56194B
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 13:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbiF3LfS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 07:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbiF3LfR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 07:35:17 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F389A5A445;
        Thu, 30 Jun 2022 04:35:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VHsMSXI_1656588911;
Received: from 30.97.57.27(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VHsMSXI_1656588911)
          by smtp.aliyun-inc.com;
          Thu, 30 Jun 2022 19:35:12 +0800
Message-ID: <fdd06581-a8aa-5948-6043-fc7e3381eb2d@linux.alibaba.com>
Date:   Thu, 30 Jun 2022 19:35:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20220628160807.148853-1-ming.lei@redhat.com>
 <20220628160807.148853-2-ming.lei@redhat.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20220628160807.148853-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/6/29 00:08, Ming Lei wrote:

[...]

> +#define UBLK_MAX_PIN_PAGES	32
> +
> +static inline void ublk_release_pages(struct ublk_queue *ubq, struct page **pages,
> +		int nr_pages)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_pages; i++)
> +		put_page(pages[i]);
> +}
> +
> +static inline int ublk_pin_user_pages(struct ublk_queue *ubq, u64 start_vm,
> +		unsigned int nr_pages, unsigned int gup_flags,
> +		struct page **pages)
> +{
> +	return get_user_pages_fast(start_vm, nr_pages, gup_flags, pages);
> +}

> +
> +static inline unsigned ublk_copy_bv(struct bio_vec *bv, void **bv_addr,
> +		void *pg_addr, unsigned int *pg_off,
> +		unsigned int *pg_len, bool to_bv)
> +{
> +	unsigned len = min_t(unsigned, bv->bv_len, *pg_len);
> +
> +	if (*bv_addr == NULL)
> +		*bv_addr = kmap_local_page(bv->bv_page);
> +
> +	if (to_bv)
> +		memcpy(*bv_addr + bv->bv_offset, pg_addr + *pg_off, len);
> +	else
> +		memcpy(pg_addr + *pg_off, *bv_addr + bv->bv_offset, len);
> +
> +	bv->bv_offset += len;
> +	bv->bv_len -= len;
> +	*pg_off += len;
> +	*pg_len -= len;
> +
> +	if (!bv->bv_len) {
> +		kunmap_local(*bv_addr);
> +		*bv_addr = NULL;
> +	}
> +
> +	return len;
> +}
> +
> +/* copy rq pages to ublksrv vm address pointed by io->addr */
> +static int ublk_copy_pages(struct ublk_queue *ubq, struct request *rq, bool to_rq,
> +		unsigned int max_bytes)
> +{
> +	unsigned int gup_flags = to_rq ? 0 : FOLL_WRITE;
> +	struct ublk_io *io = &ubq->ios[rq->tag];
> +	struct page *pgs[UBLK_MAX_PIN_PAGES];
> +	struct req_iterator req_iter;
> +	struct bio_vec bv;
> +	const unsigned int rq_bytes = min(blk_rq_bytes(rq), max_bytes);
> +	unsigned long start = io->addr, left = rq_bytes;
> +	unsigned int idx = 0, pg_len = 0, pg_off = 0;
> +	int nr_pin = 0;
> +	void *pg_addr = NULL;
> +	struct page *curr = NULL;
> +
> +	rq_for_each_segment(bv, rq, req_iter) {
> +		unsigned len, bv_off = bv.bv_offset, bv_len = bv.bv_len;
> +		void *bv_addr = NULL;
> +
> +refill:
> +		if (pg_len == 0) {
> +			unsigned int off = 0;
> +
> +			if (pg_addr) {
> +				kunmap_local(pg_addr);
> +				if (!to_rq)
> +					set_page_dirty_lock(curr);
> +				pg_addr = NULL;
> +			}
> +
> +			/* refill pages */
> +			if (idx >= nr_pin) {
> +				unsigned int max_pages;
> +
> +				ublk_release_pages(ubq, pgs, nr_pin);
> +
> +				off = start & (PAGE_SIZE - 1);
> +				max_pages = min_t(unsigned, (off + left +
> +						PAGE_SIZE - 1) >> PAGE_SHIFT,
> +						UBLK_MAX_PIN_PAGES);
> +				nr_pin = ublk_pin_user_pages(ubq, start,
> +						max_pages, gup_flags, pgs);
> +				if (nr_pin < 0)
> +					goto exit;
> +				idx = 0;
> +			}
> +			pg_off = off;
> +			pg_len = min(PAGE_SIZE - off, left);
> +			off = 0;
> +			curr = pgs[idx++];
> +			pg_addr = kmap_local_page(curr);
> +		}
> +
> +		len = ublk_copy_bv(&bv, &bv_addr, pg_addr, &pg_off, &pg_len,
> +				to_rq);
> +		/* either one of the two has been consumed */
> +		WARN_ON_ONCE(bv.bv_len && pg_len);
> +		start += len;
> +		left -= len;
> +
> +		/* overflow */
> +		WARN_ON_ONCE(left > rq_bytes);
> +		WARN_ON_ONCE(bv.bv_len > bv_len);
> +		if (bv.bv_len)
> +			goto refill;
> +
> +		bv.bv_len = bv_len;
> +		bv.bv_offset = bv_off;
> +	}
> +	if (pg_addr) {
> +		kunmap_local(pg_addr);
> +		if (!to_rq)
> +			set_page_dirty_lock(curr);
> +	}
> +	ublk_release_pages(ubq, pgs, nr_pin);
> +
> +exit:
> +	return rq_bytes - left;
> +}
> +

Hi Ming, 

I note that you pin the user buffer's pages, memcpy() and release them immediately.

1) I think maybe copy_page_from_iter() is another choice for copying user buffer to biovecs
   since copy_page_from_iter() do not pin pages(But it may raise page fault).

2) Or will you design some mechanism such as LRU to manage these pinned pages? 
   For example pin those pages frequently required for a long time and release
   those pages not used for a long time.
   I remember you have talked about this LRU on pinned pages?

Which one do you think is better? copy_page_from_iter() or pin pages with LRU?
Maybe it depends on the user's workload?

Regards,
Zhang
