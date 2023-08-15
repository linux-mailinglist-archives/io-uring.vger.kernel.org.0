Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F1B77C8B3
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 09:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbjHOHly (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 03:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbjHOHlt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 03:41:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CA31733
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692085262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VMWcbMD7dCDauI4c941mIOz5QiUyfMWfolSH1guXv34=;
        b=Oq7kq5rzFbPC9RNg+YuYmSuo+N0bLYtWWedGPpl6B4QZYBZ7yS5dW8Mba8cFcPYwhnZUfI
        smTx4JixUUGeuORDDMvxIogfnreTeqCEz3xjduwmsiy0XqGXUYj8hQdQxJrfjLG2/RUGmb
        yAm090AJxrTWQAFd4CnyF1e/WYAp08g=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29--cy7_oveMoWob4Bd2dvOzQ-1; Tue, 15 Aug 2023 03:41:01 -0400
X-MC-Unique: -cy7_oveMoWob4Bd2dvOzQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4fe8a28a1aaso5061977e87.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692085260; x=1692690060;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VMWcbMD7dCDauI4c941mIOz5QiUyfMWfolSH1guXv34=;
        b=WGa+9WprHCJfVnrV0vGsFSz9bFBb+M0AY/VMwIqN2mXGj6PTPDv75es2YHuZtnlXev
         guxQs70fmSBeJtJQG9V/mBF6yywCP86wKilN8IUVP/+huuAIzIrAp/Be0VIKdlDQGP8+
         olLS5GnMF3rWJaObiO0ycwYMtvb6rXVYe3GSPljkKy2B7yhI9RoHPAGH7lJfXh/OKkeL
         bELdPhFvDFBBQy/Z7tDJhcCyneJ2LcQVT+7Q13zohcx7igLELoVxJkBKY6sXiqRjGeSS
         fC5+2jAuSe/Q97f2+2UgfXVGmR74EyNIj4hI16yoR3MzOdZ+4n6rRvTjDN90Y8IZ5loK
         foPA==
X-Gm-Message-State: AOJu0YznrUqVjE8OPdZoQoRBquvpZZzYjZX9Z+oXqVeuGshLRkznQ2o+
        jjE1Iv8TromR56q14ip33577TKk0t/BuEWR+PDO0KNvgxVP06Rid0jAtR5oQWYQ9AgNjQ6FL4FA
        zMFPXqH+0lXu7t6+kwRU=
X-Received: by 2002:a05:6512:110d:b0:4f8:770f:1b01 with SMTP id l13-20020a056512110d00b004f8770f1b01mr9383121lfg.19.1692085259849;
        Tue, 15 Aug 2023 00:40:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjheDo758qMjd4Sp+jKLUMoXw3IW6sNphJ76PGIWLOUqSx+5exN5WWHYW/K9+fIzg2UpuQpQ==
X-Received: by 2002:a05:6512:110d:b0:4f8:770f:1b01 with SMTP id l13-20020a056512110d00b004f8770f1b01mr9383107lfg.19.1692085259456;
        Tue, 15 Aug 2023 00:40:59 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id l10-20020a7bc44a000000b003fc06169ab3sm19546694wmi.20.2023.08.15.00.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 00:40:58 -0700 (PDT)
Message-ID: <075a00b7-1e92-1709-5ac6-371eec9b1459@redhat.com>
Date:   Tue, 15 Aug 2023 09:40:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/9] mm: Call free_transhuge_folio() directly from
 destroy_large_folio()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-4-willy@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230815032645.1393700-4-willy@infradead.org>
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
> Indirect calls are expensive, thanks to Spectre.  Convert this one to
> a direct call, and pass a folio instead of the head page for type safety.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   include/linux/huge_mm.h | 2 +-
>   mm/huge_memory.c        | 5 ++---
>   mm/page_alloc.c         | 8 +++++---
>   3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 20284387b841..24aee49a581a 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -144,7 +144,7 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
>   		unsigned long len, unsigned long pgoff, unsigned long flags);
>   
>   void prep_transhuge_page(struct page *page);
> -void free_transhuge_page(struct page *page);
> +void free_transhuge_folio(struct folio *folio);
>   
>   bool can_split_folio(struct folio *folio, int *pextra_pins);
>   int split_huge_page_to_list(struct page *page, struct list_head *list);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8480728fa220..516fe3c26ef3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2779,9 +2779,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
>   	return ret;
>   }
>   
> -void free_transhuge_page(struct page *page)
> +void free_transhuge_folio(struct folio *folio)
>   {
> -	struct folio *folio = (struct folio *)page;
>   	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
>   	unsigned long flags;
>   
> @@ -2798,7 +2797,7 @@ void free_transhuge_page(struct page *page)
>   		}
>   		spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
>   	}
> -	free_compound_page(page);
> +	free_compound_page(&folio->page);
>   }
>   
>   void deferred_split_folio(struct folio *folio)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1f67d4968590..feb2e95cf021 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -287,9 +287,6 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
>   static compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
>   	[NULL_COMPOUND_DTOR] = NULL,
>   	[COMPOUND_PAGE_DTOR] = free_compound_page,
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	[TRANSHUGE_PAGE_DTOR] = free_transhuge_page,
> -#endif
>   };
>   
>   int min_free_kbytes = 1024;
> @@ -624,6 +621,11 @@ void destroy_large_folio(struct folio *folio)
>   		return;
>   	}
>   
> +	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR) {
> +		free_transhuge_folio(folio);

I really wonder if folio_test_transhuge() should be written similar to 
folio_test_hugetlb() instead, such that the dtor check is implicit.

Any good reasons not to do that?

-- 
Cheers,

David / dhildenb

