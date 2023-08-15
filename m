Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3865B77C8D3
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 09:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbjHOHs3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 03:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbjHOHsT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 03:48:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111441737
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692085655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U9WI6vQ5llVHbEYM78RYbjm6tRjhBC9Sm9S02m/dXqw=;
        b=fLJc89YjOYM3+hbm1WAjPuz6/98YWTsDB8IoTlnW02LcxIdF5dXQ9wpNMNj4UY1MJIIuOV
        B+rXC8W+kYtZjjOiIgOMJN1/TUQotSgHLfI/9a3Ehn3OHUrJD/q7YTZDpeQrytjEAzDrlH
        Sx1qHH33aFEFPZR98dq3+y4aowe2O/c=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-dH2KFlphN3KnqFg1AbijCw-1; Tue, 15 Aug 2023 03:47:34 -0400
X-MC-Unique: dH2KFlphN3KnqFg1AbijCw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4fe3e3472bcso4700495e87.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692085653; x=1692690453;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U9WI6vQ5llVHbEYM78RYbjm6tRjhBC9Sm9S02m/dXqw=;
        b=crAbodCAqABXeU5RPpyekJARmZ8eRMis16snxQDPC7NRgjXNC/q/n00kTPCWTuJ1U/
         f2/iC0BkWu8lEjGIiSgNzBUiJYzDNhLJGznPc5UsivAgvsMUeR7GbCDAnRLUfY7sjWfX
         uahLM1+f1UWcjyDp+RURGSUAaD+ctfoUEXzmkmTv8x3dnmiuLKPvjL5rSypM3M7kmcZG
         wDUqm6uQIPYtBymbaolazwxUHz1U1kjPcWPiK0e+Uam3KLZBNp4dBMOEXod1HzvFuSOZ
         mJrK9ERfudnMTVEWfes3b20kwVTL821+29L0HwZgPiaQKXjAeGcqRdcBumV62bdXlzTd
         chpg==
X-Gm-Message-State: AOJu0YwRZRa+ZN1KVH6TAkT1UTxOQvq1DQkyErnVkpir6pAsHjH2OLFH
        GHwlHjdAFKuCOoHGhzWkHZM8wXyAlP+0Xhq6Lx5mUVm1qdSaqlVtO6phmQb8HfK0OMuNsr5GdrH
        iygfoNSS+21hxNpdkToUKBBqnZms=
X-Received: by 2002:ac2:58f9:0:b0:4fb:52f1:9ab4 with SMTP id v25-20020ac258f9000000b004fb52f19ab4mr6917005lfo.50.1692085653122;
        Tue, 15 Aug 2023 00:47:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEn/+9FLUMvqvZJAedRtIcoaqf3xBJfwu2f9J7bpfh05zvjIPFKbBEjBFVDDIYjgtcjXl575Q==
X-Received: by 2002:ac2:58f9:0:b0:4fb:52f1:9ab4 with SMTP id v25-20020ac258f9000000b004fb52f19ab4mr6916766lfo.50.1692085642570;
        Tue, 15 Aug 2023 00:47:22 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id v1-20020a05600c214100b003fe215e4492sm16925604wml.4.2023.08.15.00.47.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 00:47:22 -0700 (PDT)
Message-ID: <880a26db-f46e-7d28-b4fc-ff34a2566acf@redhat.com>
Date:   Tue, 15 Aug 2023 09:47:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4/9] mm: Make free_compound_page() static
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-5-willy@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230815032645.1393700-5-willy@infradead.org>
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
> free_compound_page() is the only remaining dynamic destructor.
> Call it unconditionally from destroy_large_folio() and convert it
> to take a folio.  It used to be the last thing called from
> free_transhuge_folio(), and the call from destroy_large_folio()
> will take care of that case too.
> 
> This was the last entry in the compound_page_dtors array, so delete it
> and reword the comments that referred to it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

[...]

>   int min_free_kbytes = 1024;
>   int user_min_free_kbytes = -1;
>   static int watermark_boost_factor __read_mostly = 15000;
> @@ -587,17 +582,17 @@ static inline void free_the_page(struct page *page, unsigned int order)
>    * The remaining PAGE_SIZE pages are called "tail pages". PageTail() is encoded
>    * in bit 0 of page->compound_head. The rest of bits is pointer to head page.
>    *
> - * The first tail page's ->compound_dtor holds the offset in array of compound
> - * page destructors. See compound_page_dtors.
> + * The first tail page's ->compound_dtor describes how to destroy the
> + * compound page.
>    *
>    * The first tail page's ->compound_order holds the order of allocation.
>    * This usage means that zero-order pages may not be compound.
>    */
>   
> -void free_compound_page(struct page *page)
> +static void free_compound_page(struct folio *folio)

"free_folio", maybe? Doesn't seem to be taken yet.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

