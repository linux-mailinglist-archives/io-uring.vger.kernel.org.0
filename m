Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFB777D356
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 21:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbjHOTXu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 15:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239925AbjHOTXr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 15:23:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8242F268A
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 12:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692127287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cCj7FTFwL6F6V9/SO6Bj9kXHRFGJMD24dS3CtJ8ffZE=;
        b=EN5ktXtYpyqlKw8aOms/SAdWOuVogc/OCnlwyFNa6FCE1QUSk579Xa6JhEIPq4cAY/OONK
        RsTdjbn3m+H+O8ysOFy9PRxpYUL7IsCSahjrdU5G7+H09+8W36Nu9LmUJmLK3arpGqy3yZ
        oapFlg3i5dN1Xjdm/X1pcdafUIlk/zo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-9N6wPPDUMDGNXVhAVXJLMA-1; Tue, 15 Aug 2023 15:21:24 -0400
X-MC-Unique: 9N6wPPDUMDGNXVhAVXJLMA-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-63d2b88325bso16283836d6.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 12:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692127284; x=1692732084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cCj7FTFwL6F6V9/SO6Bj9kXHRFGJMD24dS3CtJ8ffZE=;
        b=TV3XJSBffjNYQ0h2MU+1//CF+tKS16B3g1kEt7AY3ei9snS5rXd79BP28VzYoXZdHJ
         iCLfClr3C2ZMan+62+U4uRx3lsMO9w88eq/+xDLx+O7IduGeNJ+avQnlDZ3p0poytCUa
         GznxpuW+vHrNnxDBgUi+LTQNKzkiTtWtbZOJ1rb9yG+U+ir7kytRuSkSxuGmiavF25RL
         /4fcV/jqqNjAEfFtwVb9hjdIRRSsnDR+v3Z1hfYfxjpVqbEReLlEo9JCYnrFpb/YMryS
         DXMkaH5vc062saSBBgPYRmrrupl6NpVMtO+na+cHxy7F9A0xPSySOEbFw07zMAkeqzKQ
         OHVA==
X-Gm-Message-State: AOJu0Yw9zKGPKba1GAYmgeH/e/txO52xKM4G/tUqamNRd+r5hlJh2/ji
        sr8AfLXJl7ni5HSXAAObblAYjy4HZG7NHMRzkASefppVIn6YOahpJTzge7VyvJ4pIGLntR4rMbJ
        TS1C3R8h8lkZcH+afp3TrsQ5xkdo=
X-Received: by 2002:a05:6214:dc6:b0:63c:7427:e7e9 with SMTP id 6-20020a0562140dc600b0063c7427e7e9mr7813157qvt.6.1692127283937;
        Tue, 15 Aug 2023 12:21:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIwXaTyKTXy6svtJfFPnFrTAlBeXjdhHuUb89o0ka25yDqZPveTO2U3SkZ8a2bZNLetaPAoA==
X-Received: by 2002:a05:6214:dc6:b0:63c:7427:e7e9 with SMTP id 6-20020a0562140dc600b0063c7427e7e9mr7813144qvt.6.1692127283632;
        Tue, 15 Aug 2023 12:21:23 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id s14-20020a0cdc0e000000b006431027ac44sm1915699qvk.83.2023.08.15.12.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 12:21:23 -0700 (PDT)
Date:   Tue, 15 Aug 2023 15:21:14 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 9/9] mm: Free up a word in the first tail page
Message-ID: <ZNvQKuk5h5SfYy0e@x1n>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-10-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230815032645.1393700-10-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 04:26:45AM +0100, Matthew Wilcox (Oracle) wrote:
> Store the folio order in the low byte of the flags word in the first
> tail page.  This frees up the word that was being used to store the
> order and dtor bytes previously.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm.h       | 10 +++++-----
>  include/linux/mm_types.h |  3 +--
>  kernel/crash_core.c      |  1 -
>  mm/internal.h            |  2 +-
>  mm/page_alloc.c          |  4 +++-
>  5 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index cf0ae8c51d7f..85568e2b2556 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1028,7 +1028,7 @@ struct inode;
>   * compound_order() can be called without holding a reference, which means
>   * that niceties like page_folio() don't work.  These callers should be
>   * prepared to handle wild return values.  For example, PG_head may be
> - * set before _folio_order is initialised, or this may be a tail page.
> + * set before the order is initialised, or this may be a tail page.
>   * See compaction.c for some good examples.
>   */
>  static inline unsigned int compound_order(struct page *page)
> @@ -1037,7 +1037,7 @@ static inline unsigned int compound_order(struct page *page)
>  
>  	if (!test_bit(PG_head, &folio->flags))
>  		return 0;
> -	return folio->_folio_order;
> +	return folio->_flags_1 & 0xff;
>  }
>  
>  /**
> @@ -1053,7 +1053,7 @@ static inline unsigned int folio_order(struct folio *folio)
>  {
>  	if (!folio_test_large(folio))
>  		return 0;
> -	return folio->_folio_order;
> +	return folio->_flags_1 & 0xff;
>  }
>  
>  #include <linux/huge_mm.h>
> @@ -2025,7 +2025,7 @@ static inline long folio_nr_pages(struct folio *folio)
>  #ifdef CONFIG_64BIT
>  	return folio->_folio_nr_pages;
>  #else
> -	return 1L << folio->_folio_order;
> +	return 1L << (folio->_flags_1 & 0xff);
>  #endif
>  }
>  
> @@ -2043,7 +2043,7 @@ static inline unsigned long compound_nr(struct page *page)
>  #ifdef CONFIG_64BIT
>  	return folio->_folio_nr_pages;
>  #else
> -	return 1L << folio->_folio_order;
> +	return 1L << (folio->_flags_1 & 0xff);
>  #endif
>  }
>  
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index d45a2b8041e0..659c7b84726c 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -282,7 +282,6 @@ static inline struct page *encoded_page_ptr(struct encoded_page *page)
>   * @_refcount: Do not access this member directly.  Use folio_ref_count()
>   *    to find how many references there are to this folio.
>   * @memcg_data: Memory Control Group data.
> - * @_folio_order: Do not use directly, call folio_order().
>   * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
>   * @_nr_pages_mapped: Do not use directly, call folio_mapcount().
>   * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
> @@ -334,8 +333,8 @@ struct folio {
>  		struct {
>  			unsigned long _flags_1;
>  			unsigned long _head_1;
> +			unsigned long _folio_avail;

This can just be dropped?  Having this single field as "avail" is weird,
without mentioning the rest, IMHO.

We can have a separate patch to resolve what's available, either you can
leave that to my series, or if you dislike that you can propose what you've
replied to my cover letter but add all the available bits.

>  	/* public: */
> -			unsigned char _folio_order;
>  			atomic_t _entire_mapcount;
>  			atomic_t _nr_pages_mapped;
>  			atomic_t _pincount;
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 934dd86e19f5..693445e1f7f6 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -455,7 +455,6 @@ static int __init crash_save_vmcoreinfo_init(void)
>  	VMCOREINFO_OFFSET(page, lru);
>  	VMCOREINFO_OFFSET(page, _mapcount);
>  	VMCOREINFO_OFFSET(page, private);
> -	VMCOREINFO_OFFSET(folio, _folio_order);
>  	VMCOREINFO_OFFSET(page, compound_head);
>  	VMCOREINFO_OFFSET(pglist_data, node_zones);
>  	VMCOREINFO_OFFSET(pglist_data, nr_zones);
> diff --git a/mm/internal.h b/mm/internal.h
> index e3d11119b04e..c415260c1f06 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -407,7 +407,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
>  	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
>  		return;
>  
> -	folio->_folio_order = order;
> +	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
>  #ifdef CONFIG_64BIT
>  	folio->_folio_nr_pages = 1U << order;
>  #endif
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9fe9209605a5..0e0e0d18a81b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1115,8 +1115,10 @@ static __always_inline bool free_pages_prepare(struct page *page,
>  
>  		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
>  
> -		if (compound)
> +		if (compound) {
>  			ClearPageHasHWPoisoned(page);
> +			page[1].flags &= ~0xffUL;

Could we hide the hard-coded 0xff in some way?

One easy way would be using a macro with a bunch of helpers, like
folio_set|get|clear_order().

The other way is maybe we can also define _flags_1 an enum, where we can
just move over the compound_order field at offset 0?  But I'm not sure how
that looks like at last.

Thanks,

> +		}
>  		for (i = 1; i < (1 << order); i++) {
>  			if (compound)
>  				bad += free_tail_page_prepare(page, page + i);
> -- 
> 2.40.1
> 
> 

-- 
Peter Xu

