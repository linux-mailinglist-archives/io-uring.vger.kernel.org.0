Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA6977E1BB
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 14:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbjHPMgA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 08:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245319AbjHPMfm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 08:35:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8945A1FDC
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 05:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692189296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LT/9A75T+w/iAKJtkcjWJyHj4m/aFLjb8Mw44pMTVhk=;
        b=i5me2bVQXLOXMrAPkfSWnhvHK5aWl/AoutwEljBpjaYJKghWkqFXgGEKbmKhNbqmjTJkLD
        7o8bR1PyhAdR+8BqH9/XBNdhrBf8vBaj9i9zW9OiJ0uj6PbbvbbT7AxQ9lxKO+vt+/hAGp
        J+l2gRGQDhdwtpUhwu3GlL4C1E1khpA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-KfBUfDDvPgWfxxnbq05vkA-1; Wed, 16 Aug 2023 08:34:55 -0400
X-MC-Unique: KfBUfDDvPgWfxxnbq05vkA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3178ddc3d94so3778546f8f.1
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 05:34:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692189294; x=1692794094;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LT/9A75T+w/iAKJtkcjWJyHj4m/aFLjb8Mw44pMTVhk=;
        b=VkqlTaFekHhK7dXe3CCqC50Wlm+0cOod2z21i4kpXSrrzMiH3n+i3CjWAyeIhwZYYI
         4iooibqbECHfExuKLY8gYUOQwh+1byPirjULbXnAwDqt04EIKCWuMfCLvTH7S5bn9u0q
         phXM06ZiAd+rMEMPqEsB1ZpVhhmca1H43pOgew14WIH/+LhSFZEPLUSaDlTGXqHV9YtV
         Ogcgl0KEDv32TDkt0KTqIMaVyjnh+zW3VmwsQfIItVkdZGj/KAizjfxoSIGVZdqdajyI
         yT8WYfPWpaFqelfcJ+fD2eW8ZL4rST2luG3nTp5EzHStmDJwiq7LRHEDfRXvrFW413NU
         zN9g==
X-Gm-Message-State: AOJu0YyIPv65oszkWXYPxsyuzcGDQ98Y9x8GrdeFxyuEjTDNJEa8HHm4
        ot6Gvv3WZzeVyOXpxayCm+9zDYS8CSNX3NcAspn/GxpMwknD/gfomcBg9c8dsyiieHCSvWW9sZg
        LUcFkK/HZ5Mbt0aYcRGqiqLjIJq8=
X-Received: by 2002:a5d:4a52:0:b0:318:8ad:f9f with SMTP id v18-20020a5d4a52000000b0031808ad0f9fmr1248706wrs.24.1692189294430;
        Wed, 16 Aug 2023 05:34:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1/dgwjAHj/2XRgEyRb5SS0JpDAwq79+mdcAKB3CZlE9CcEj8vLHIr7+IAVkwJslEihZtzVg==
X-Received: by 2002:a5d:4a52:0:b0:318:8ad:f9f with SMTP id v18-20020a5d4a52000000b0031808ad0f9fmr1248677wrs.24.1692189294045;
        Wed, 16 Aug 2023 05:34:54 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:8b00:5520:fa3c:c527:592f? (p200300cbc74b8b005520fa3cc527592f.dip0.t-ipconnect.de. [2003:cb:c74b:8b00:5520:fa3c:c527:592f])
        by smtp.gmail.com with ESMTPSA id q4-20020adff944000000b003143c9beeaesm21273051wrr.44.2023.08.16.05.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 05:34:53 -0700 (PDT)
Message-ID: <82b26676-4483-201b-bcf1-a0a2192acaf2@redhat.com>
Date:   Wed, 16 Aug 2023 14:34:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 7/9] mm: Add deferred_list page flag
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-8-willy@infradead.org>
 <7c1bb01d-620c-ca97-c4a2-2bb7c126c687@redhat.com>
 <ZNuaiY483XCq1K1/@casper.infradead.org>
 <88bdc3d2-56e4-4c09-77fe-74fb4c116893@redhat.com>
 <ZNuwm2kPzmeHo2bU@casper.infradead.org>
 <aac4404a-1012-fe7f-4337-cace30795176@redhat.com>
 <ZNvY4AbRCwjwVY7f@casper.infradead.org>
 <ZNw/FEDndlAsHlVm@casper.infradead.org>
 <fc1372e6-d64a-1788-fab8-bc0fdb12587d@redhat.com>
 <ZNy7jBAjO+SCHaoE@casper.infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZNy7jBAjO+SCHaoE@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16.08.23 14:05, Matthew Wilcox wrote:
> On Wed, Aug 16, 2023 at 12:12:44PM +0200, David Hildenbrand wrote:
>> On 16.08.23 05:14, Matthew Wilcox wrote:
>>>>    * Are managed on the LRU
>>>
>>> I think this is the best one to go with.  Either that or "managed by
>>> rmap".  That excludes compoud pages which are allocated from vmalloc()
>>> (which can be mmaped), page tables, slab, etc.  It includes both file
>>> and anon folios.
>>>
>>> I have a handy taxonomy here: https://kernelnewbies.org/MemoryTypes
>>>
>>> Unfortunately, folio_test_lru() already exists and means something
>>> different ("Is this folio on an LRU list").  I fear folio_test_rmap()
>>> would have a similar confusion -- "Is this folio currently findable by
>>> rmap", or some such. folio_test_rmappable()?
>> But what about hugetlb, they are also remappable? We could have
>> folio_test_rmappable(), but that would then also better include hugetlb ...
> 
> We could do that!  Have both hugetlb & huge_memory.c set the rmappable
> flag.  We'd still know which destructor to call because hugetlb also sets
> the hugetlb flag.
> 
>> Starting at the link you provided, I guess "vmalloc" and "net pool" would
>> not fall under that category, or would they? (I'm assuming they don't get
>> mapped using the rmap, so they are "different", and they are not managed by
>> lru).
> 
> Right, neither type of page ends up on the LRU, and neither is added to
> rmap.
> 
>> So I assume we only care about anon+file (lru-managed). Only these are
>> rmappable (besides hugetlb), correct?
>>
>> folio_test_lru_managed()
>>
>> Might be cleanest to describe anon+file that are managed by the lru, just
>> might not be on a lru list right now (difference to folio_test_lru()).
> 
> Something I didn't think about last night is that this flag only
> _exists_ for large folios.  folio_test_lru_managed() (and
> folio_test_rmappable()) both sound like they might work if you call them
> on single-page folios, but we BUG if you do (see folio_flags())
> 
>> I've been also thinking about
>>
>> "folio_test_normal"
>>
>> But it only makes sense when "all others (including hugetlb) are the odd
>> one".
> 
> Who's to say slab is abnormal?  ;-)  But this one also fails to
> communicate "only call this on large folios".  folio_test_splittable()
> does at least communicate that this is related to large folios, although
> one might simply expect it to return false for single-page folios rather
> than BUG.
> 
> folio_test_large_rmappable()?

Sounds good to me. We can then further test if it's hugetlb to rule that 
one out.

-- 
Cheers,

David / dhildenb

