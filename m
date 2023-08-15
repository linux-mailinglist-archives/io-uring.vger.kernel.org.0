Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98277C8A5
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 09:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbjHOHiF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 03:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbjHOHhm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 03:37:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1AE198C
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692085011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5xYsmOFje5yTGttZ6v6G6PZw9DbgvJ1RnyLESMQbsig=;
        b=DcyxvPottNhdPCoCPHNqTsgjfZT5qkc4kPTbapLgb9CVYBd6L1td4dbS0DZyOCVrjK6FUB
        sXi0QfOskUOzRWpskLxB1fKXGMxocJ/YaxQ0w6NVNG+R1Camwke3C9NXE7PQzuIlDTxvD1
        U3YGpTlv5fDna/m0dYKEI6THOW+ymMk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-EqKuMIZxOHOi1RLDGGqjXw-1; Tue, 15 Aug 2023 03:36:50 -0400
X-MC-Unique: EqKuMIZxOHOi1RLDGGqjXw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-317a84a3ebeso2744008f8f.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692085009; x=1692689809;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5xYsmOFje5yTGttZ6v6G6PZw9DbgvJ1RnyLESMQbsig=;
        b=Bo/xd/giCnjNA82ez+f7UOidZV1CYoKnfh0PjnHGY4MMD3p3P9kTw36uH/PhX4YuxA
         dTuMxJlXnPEK5+V6L4a6HZ7m9hoLhPK53PtTeJYRf3a9K1sIMvrU0fNwycLIqqODJHp+
         BTDsY9bBebDwzPBxoIIV6pivE+nxtQPYbc47jPEIlLNzp9hHEMsjYODbCzTezR0CVcmd
         sulvrey6aVJiGUtXq7e9dz5WZ+ZpKrgHVN+N2YYu+mEImUzO99N8C14mm+BMDxXNtVVG
         aaL0l8fRVumZ+G5xUFU4nuT/Z3Te1bS+gmQfvaeP5yEI6GEJutBMy1LDS+3jzJ10i7Ir
         RkYg==
X-Gm-Message-State: AOJu0YzC1GK+cLOoJ6NMST+dOK4iYM4H+amDNjv7BHVZExnE3bceIDd2
        md5xaE4TnZ8qzR6lgVBZ1gBhz8e0zmzkdcAptbDecfFwqSdfTnsS8POtZLg7NKENmGMPvkqebSs
        zWK/X5iublFTiirrr6D0=
X-Received: by 2002:adf:e912:0:b0:317:417e:a467 with SMTP id f18-20020adfe912000000b00317417ea467mr910010wrm.6.1692085008886;
        Tue, 15 Aug 2023 00:36:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4BLbc0ajsG2PUQkkYbOcqfYBJBCjFQA/1JcmpTjMqb2JosO9nATgJcn3uasJezff3hjVvyQ==
X-Received: by 2002:adf:e912:0:b0:317:417e:a467 with SMTP id f18-20020adfe912000000b00317417ea467mr909991wrm.6.1692085008522;
        Tue, 15 Aug 2023 00:36:48 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id v9-20020a5d6b09000000b0031759e6b43fsm16970637wrw.39.2023.08.15.00.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 00:36:48 -0700 (PDT)
Message-ID: <2fef37cc-1fd7-e8b1-28c4-becd131f82b7@redhat.com>
Date:   Tue, 15 Aug 2023 09:36:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 2/9] mm: Call the hugetlb destructor directly
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-3-willy@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230815032645.1393700-3-willy@infradead.org>
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
> a direct call, and pass a folio instead of the head page to save a few
> more instructions.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   include/linux/hugetlb.h |  3 ++-
>   include/linux/mm.h      |  6 +-----
>   mm/hugetlb.c            | 26 ++++++++++++--------------
>   mm/page_alloc.c         |  8 +++++---
>   4 files changed, 20 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 0a393bc02f25..9555859537a3 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -26,6 +26,8 @@ typedef struct { unsigned long pd; } hugepd_t;
>   #define __hugepd(x) ((hugepd_t) { (x) })
>   #endif
>   
> +void free_huge_page(struct folio *folio);
> +
>   #ifdef CONFIG_HUGETLB_PAGE
>   
>   #include <linux/mempolicy.h>
> @@ -165,7 +167,6 @@ int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   				bool *migratable_cleared);
>   void folio_putback_active_hugetlb(struct folio *folio);
>   void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
> -void free_huge_page(struct page *page);
>   void hugetlb_fix_reserve_counts(struct inode *inode);
>   extern struct mutex *hugetlb_fault_mutex_table;
>   u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 19493d6a2bb8..7fb529dbff31 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1278,13 +1278,9 @@ typedef void compound_page_dtor(struct page *);
>   enum compound_dtor_id {
>   	NULL_COMPOUND_DTOR,
>   	COMPOUND_PAGE_DTOR,
> -#ifdef CONFIG_HUGETLB_PAGE
>   	HUGETLB_PAGE_DTOR,
> -#endif
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>   	TRANSHUGE_PAGE_DTOR,
> -#endif
> -	NR_COMPOUND_DTORS,
> +	NR_COMPOUND_DTORS
>   };
>   
>   static inline void folio_set_compound_dtor(struct folio *folio,
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e327a5a7602c..bc340f5dbbd4 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1875,13 +1875,12 @@ struct hstate *size_to_hstate(unsigned long size)
>   	return NULL;
>   }
>   
> -void free_huge_page(struct page *page)
> +void free_huge_page(struct folio *folio)

free_huge_page" but passing a folio, hm. Maybe something like 
"free_hugetlb_folio" would be better.


Apart from that LGTM.

-- 
Cheers,

David / dhildenb

