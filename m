Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F1A77C8D6
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 09:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbjHOHtj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 03:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235445AbjHOHtG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 03:49:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CE2198A
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692085697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OSgA22aTASG7kf7kmkk0CbjoADJSE+B67qAYQ8TTaYo=;
        b=LIiaCpM+UfxwpUGauIohFEaqiou+y3Z4cVtqMjkcQNKX/GXKDBKcv3yOUqY11HpgbK51sP
        YfiogP/h75h0YKtpMzF503LQVB6IO8BGypjHELtgqssUHPnxLQQmmnee+vAoBUzVyy0opL
        2lY5FuSDVKXZ1u5USLPD0ZzW8fxc6SA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-YLC5ZT9oPz2saJe7oJ5FIg-1; Tue, 15 Aug 2023 03:48:14 -0400
X-MC-Unique: YLC5ZT9oPz2saJe7oJ5FIg-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2bb930719ebso617941fa.3
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:48:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692085692; x=1692690492;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OSgA22aTASG7kf7kmkk0CbjoADJSE+B67qAYQ8TTaYo=;
        b=c8ruoBxXNuNDkuEFgXFc3lwDnSdyaWUZZYDnqQNFvp2mWPjT7N6LlGfRTHnr2DmPIV
         ZztmDobPZpe6f4ZuzXXua4CLeY+wCE63/zx6VQ0sRGpKq3yUYsQN+/gfhAxgBivQtsrT
         xjchPhcCz5DMch1PFO5r2824DzoXiWjAevvimc0jMhtvhOnbok24LkrnyCuSzlBNwpHK
         yKtvXiJlSjtkr4w4i5oiJHy5IUGDXktVCUJNFuEN/ET/eDyByHPDpVsIrRlXHvsNYrLp
         IyvsPl0uL0GgG1MZ/9dGQCatgcIEyTROXAgGxafVze5l7wrJ+4HCYTXwiTJF0TzqVlB+
         emRQ==
X-Gm-Message-State: AOJu0Yy74n4hk+8ikGMzng2CnKFawvQwDmaCHFdStNBnl1AJl++nQK92
        H0nLxQJrPbcmbmvb5fCA9PlK46miDRU1sGyfOonMaix7kUYo3cFNxTP35kvbJGtBKcZ+Xq1m1cR
        5VZ0A170uNYNzRPlf+jc=
X-Received: by 2002:a2e:910c:0:b0:2b9:e9c8:cb1 with SMTP id m12-20020a2e910c000000b002b9e9c80cb1mr8184965ljg.48.1692085692599;
        Tue, 15 Aug 2023 00:48:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvDkHXLCluyzb4LmqhzSYc+RuSfI3neOngQcWD9TW3hL8SED9CHVVrhKeNIG7tKvJmQLWEnQ==
X-Received: by 2002:a2e:910c:0:b0:2b9:e9c8:cb1 with SMTP id m12-20020a2e910c000000b002b9e9c80cb1mr8184958ljg.48.1692085692255;
        Tue, 15 Aug 2023 00:48:12 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id c6-20020a7bc846000000b003fe0a0e03fcsm19480088wml.12.2023.08.15.00.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 00:48:11 -0700 (PDT)
Message-ID: <100aa4cc-224f-f7b9-cb71-781d5073576d@redhat.com>
Date:   Tue, 15 Aug 2023 09:48:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4/9] mm: Make free_compound_page() static
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-5-willy@infradead.org>
 <880a26db-f46e-7d28-b4fc-ff34a2566acf@redhat.com>
Organization: Red Hat
In-Reply-To: <880a26db-f46e-7d28-b4fc-ff34a2566acf@redhat.com>
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

On 15.08.23 09:47, David Hildenbrand wrote:
> On 15.08.23 05:26, Matthew Wilcox (Oracle) wrote:
>> free_compound_page() is the only remaining dynamic destructor.
>> Call it unconditionally from destroy_large_folio() and convert it
>> to take a folio.  It used to be the last thing called from
>> free_transhuge_folio(), and the call from destroy_large_folio()
>> will take care of that case too.
>>
>> This was the last entry in the compound_page_dtors array, so delete it
>> and reword the comments that referred to it.
>>
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> ---
> 
> [...]
> 
>>    int min_free_kbytes = 1024;
>>    int user_min_free_kbytes = -1;
>>    static int watermark_boost_factor __read_mostly = 15000;
>> @@ -587,17 +582,17 @@ static inline void free_the_page(struct page *page, unsigned int order)
>>     * The remaining PAGE_SIZE pages are called "tail pages". PageTail() is encoded
>>     * in bit 0 of page->compound_head. The rest of bits is pointer to head page.
>>     *
>> - * The first tail page's ->compound_dtor holds the offset in array of compound
>> - * page destructors. See compound_page_dtors.
>> + * The first tail page's ->compound_dtor describes how to destroy the
>> + * compound page.
>>     *
>>     * The first tail page's ->compound_order holds the order of allocation.
>>     * This usage means that zero-order pages may not be compound.
>>     */
>>    
>> -void free_compound_page(struct page *page)
>> +static void free_compound_page(struct folio *folio)
> 
> "free_folio", maybe? Doesn't seem to be taken yet.

Ah, I see it gets removed in the following patch.

-- 
Cheers,

David / dhildenb

