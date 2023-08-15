Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2802777C8D8
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 09:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbjHOHtk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 03:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbjHOHtY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 03:49:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964C211A
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692085717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0LmXbT2cqrnfIcuqb+LxCY3oi+h86qKI0tWvN/rblOE=;
        b=cBZ3cHfawljRiY0ukhfwoyaazSlfcdyuzNLm4AGZhcb/PcSczQtGkr/LiGhcmUeUB6t6ed
        GeGLoOJJflAOT8RRJdcN4Cstdysag2iSqHxJV/vIN6Ix5Pe7e4aVGhi0wfI/uzgYwbT+NJ
        6p8zM+ZlU0IKfwceQs1jsly1LedL2Bc=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-KZYcYlmZPP2IQhcpCTYJ3Q-1; Tue, 15 Aug 2023 03:48:36 -0400
X-MC-Unique: KZYcYlmZPP2IQhcpCTYJ3Q-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ba7156eadfso35720861fa.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:48:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692085714; x=1692690514;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0LmXbT2cqrnfIcuqb+LxCY3oi+h86qKI0tWvN/rblOE=;
        b=AAjI1diXwMqejdLkdbSzp136XTFz8s19MsyIrQHZ5oO9egzgvDw/zD/w9s0OkSHUHW
         NVgDbiYXWcv2KKbioFYXz5jTeJCjZGCH32fLQ4sFVZeNW/oOqPAUY4BWPqPzMpY42Q9c
         71jExT9LjCnlBOICim/nTi2j3TuL78A3VPPqFFWTnI7XQEcfx0FPZaK0WmCJhe97xVHx
         WVXIZzRuVeeIsV68kjH/HLdP8BmUj40w9XSgABxBNfeA6Z4TjditlZ2u5TRqJ4A4mw5G
         dBz0G7D9UykNX3Ph8eumuGVPwDpBEYyt9M+JAylIOHnVZlSxzma40tCJ5QBdGw3YG9Es
         C/4w==
X-Gm-Message-State: AOJu0YwgpAqIZ4OGanVBRr9L8rkfpJ1KG+0tAHOAOfjdKq1IHPscVvds
        AhvRz0CWilzUr4SwvbXP98m6eOADbMXWoeAyRCyBh4e15fFc/HeAj720g+ki99eiDOzwYPz3e7N
        g9b1rWsX/7gru35D28H690/7TvB8=
X-Received: by 2002:a2e:9587:0:b0:2b6:a6e7:5afa with SMTP id w7-20020a2e9587000000b002b6a6e75afamr8667214ljh.12.1692085714763;
        Tue, 15 Aug 2023 00:48:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRCIxNPh3Oi+B/3AlBm3t1XObf57+A1RZie/0ec/LObbjijnLgVRsKEG3QcV+RHqrtCtUV7g==
X-Received: by 2002:a2e:9587:0:b0:2b6:a6e7:5afa with SMTP id w7-20020a2e9587000000b002b6a6e75afamr8667203ljh.12.1692085714459;
        Tue, 15 Aug 2023 00:48:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id b13-20020a05600c11cd00b003fe1a96845bsm19750883wmi.2.2023.08.15.00.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 00:48:34 -0700 (PDT)
Message-ID: <74eec38b-12a9-7932-0670-10b34960a8c5@redhat.com>
Date:   Tue, 15 Aug 2023 09:48:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5/9] mm: Remove free_compound_page()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-6-willy@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230815032645.1393700-6-willy@infradead.org>
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
> Inline it into its one caller.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   mm/page_alloc.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 804982faba4e..21af71aea6eb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -589,12 +589,6 @@ static inline void free_the_page(struct page *page, unsigned int order)
>    * This usage means that zero-order pages may not be compound.
>    */
>   
> -static void free_compound_page(struct folio *folio)
> -{
> -	mem_cgroup_uncharge(folio);
> -	free_the_page(&folio->page, folio_order(folio));
> -}
> -
>   void prep_compound_page(struct page *page, unsigned int order)
>   {
>   	int i;
> @@ -618,7 +612,8 @@ void destroy_large_folio(struct folio *folio)
>   
>   	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR)
>   		free_transhuge_folio(folio);
> -	free_compound_page(folio);
> +	mem_cgroup_uncharge(folio);
> +	free_the_page(&folio->page, folio_order(folio));
>   }
>   
>   static inline void set_buddy_order(struct page *page, unsigned int order)

I'd squash that into the previous commit

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

