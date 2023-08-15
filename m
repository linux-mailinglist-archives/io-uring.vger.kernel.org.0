Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DEB77C8ED
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 09:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbjHOHzi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 03:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235508AbjHOHzc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 03:55:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E56DD
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692086082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=52L9b9Mi43z1EbpzS7SV3VGj58zAQOpCt8GztcHHKRA=;
        b=Hv9DmKvlXxUiHmRBhkMERVYnhP91RVFK5AVQrZkbwa/wKcTOxcEoLBbms3g53f8ZHqnVLa
        0HwRdECKzlmdoppdudS40W00eiJU4GPDWSUFJqrsIoWJ0MPHD1ckhuP+Uu/QoWac+hwMpi
        pRc89fT+GA7BgetrUBkelI126cQmHrk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-4IB9pKG1PM2F5fnz6YyQlg-1; Tue, 15 Aug 2023 03:54:41 -0400
X-MC-Unique: 4IB9pKG1PM2F5fnz6YyQlg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fe1bef4223so32581225e9.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:54:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692086080; x=1692690880;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=52L9b9Mi43z1EbpzS7SV3VGj58zAQOpCt8GztcHHKRA=;
        b=gykhf0KW7POfOzVmtFUkItSiwvaQ4ODKg9zHV/8Nr3LNOxoCCYz9Bpi53yMMEGNy39
         BZCaimN9yHiInWaJyg60dcnwOfK5MPwh6lFGFPs+MwXlPc+Kn/qRxwfkWVEbiOW3T/d5
         AStWVnkKkl94HfrGXkKJW7+f59Astw5m3VB7p8cexRd2lrB5xrdCj/UHfERDcWDCFYkc
         KgvM7iuonKvfkidtBWxOvaATtF9UKtiXtf936jTJhy1P553JLqvwlZm8xhh90WH/GnwU
         qQb8Xbo5zX213YpfkJWHUUW7y/IRaiL4O60sDnv2aZ5kRFXjHM0w4TPEE94+YZYZSsmU
         tMqQ==
X-Gm-Message-State: AOJu0YwwhFW72MKK0x4HJHVsmtVJ0kPv+dnahuOEPiSvc62z9S/c027d
        CVYs4IBvQG9BYGs2Eo0ioNd7JDG1W1QN+cDco6gv+RtHBQ8/95M5vW5X+xXKSqL8W9Nl+jpGnAz
        FHTXC4+FDb/TgJXhUO7qfpYfwMn8=
X-Received: by 2002:a7b:ca58:0:b0:3fb:fca1:1965 with SMTP id m24-20020a7bca58000000b003fbfca11965mr8512311wml.18.1692086079858;
        Tue, 15 Aug 2023 00:54:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxhnz+wFgUlTRjw+52bilvuzRtQRQ0QKuM/57SaDktB8X+UWeYgPrVXLsEWcOGbiG88OqcBA==
X-Received: by 2002:a7b:ca58:0:b0:3fb:fca1:1965 with SMTP id m24-20020a7bca58000000b003fbfca11965mr8512262wml.18.1692086077928;
        Tue, 15 Aug 2023 00:54:37 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id e7-20020a05600c218700b003fe3674bb39sm16965703wme.2.2023.08.15.00.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 00:54:37 -0700 (PDT)
Message-ID: <7c1bb01d-620c-ca97-c4a2-2bb7c126c687@redhat.com>
Date:   Tue, 15 Aug 2023 09:54:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 7/9] mm: Add deferred_list page flag
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-8-willy@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230815032645.1393700-8-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15.08.23 05:26, Matthew Wilcox (Oracle) wrote:
> Stored in the first tail page's flags, this flag replaces the destructor.
> That removes the last of the destructors, so remove all references to
> folio_dtor and compound_dtor.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

[...]

>   
> +	/* Has a deferred list (may be empty).  First tail page. */
> +	PG_deferred_list = PG_reclaim,
> +

If PG_deferred_list implies thp (and replaces the thp dtor), should we 
rather name this PG_thp or something along those lines?

[...]

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 21af71aea6eb..9fe9209605a5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -582,9 +582,6 @@ static inline void free_the_page(struct page *page, unsigned int order)
>    * The remaining PAGE_SIZE pages are called "tail pages". PageTail() is encoded
>    * in bit 0 of page->compound_head. The rest of bits is pointer to head page.
>    *
> - * The first tail page's ->compound_dtor describes how to destroy the
> - * compound page.
> - *
>    * The first tail page's ->compound_order holds the order of allocation.
>    * This usage means that zero-order pages may not be compound.
>    */
> @@ -603,14 +600,12 @@ void prep_compound_page(struct page *page, unsigned int order)
>   
>   void destroy_large_folio(struct folio *folio)
>   {
> -	enum compound_dtor_id dtor = folio->_folio_dtor;
> -
>   	if (folio_test_hugetlb(folio)) {
>   		free_huge_page(folio);
>   		return;
>   	}
>   
> -	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR)
> +	if (folio_test_deferred_list(folio))

Similar question as before: why not have folio_test_transhuge() perform 
this check internally?

The sequence of

	if (folio_test_deferred_list(folio))
		free_transhuge_folio(folio);

Looks less clear to what we had before.

-- 
Cheers,

David / dhildenb

