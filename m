Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2351777DE47
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 12:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbjHPKNr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 06:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243826AbjHPKNj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 06:13:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3522C138
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 03:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692180768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pxeSOckQKw4dtSxcy30SLEYbSszPBpgrvgvEwcI35yo=;
        b=cHjD5WO1pn8N6B8tqC8qTAOgOOiQaEuPbpypnSkqqYOpM/Ea20IMr8l5szt2Jf0QEZfM1M
        3X5Dndb+1ARO3ona/8IH46VE0CmPaJ56PmjBd/fV9UJolDOV7Pc0gK1jtOffwAvIRMM13z
        el0KYE2V0vx4Uh7pBgWh9f4vgVdLShQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-4Rvma4VJMu6W0Cfrlk5eCg-1; Wed, 16 Aug 2023 06:12:46 -0400
X-MC-Unique: 4Rvma4VJMu6W0Cfrlk5eCg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fe44619c97so33554525e9.0
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 03:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692180765; x=1692785565;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pxeSOckQKw4dtSxcy30SLEYbSszPBpgrvgvEwcI35yo=;
        b=Zuc7OXC9FwwNxbdkN9pYKd6U7cEOq+7odgv4FggwxCtuLU3+NYqvNbRycg/jvmFzvy
         xSZJB4ADBDRhbmawnSQpzHyBtInEwzViKbUXGoUnLwmQreb1NzlSaqyZW+NX5LRwZ68O
         YosoksNUJmhKBSY5YoK140x3gZpUNDLB2pjr/3p5TcKxvaoz+Ro63i8FpblcN4tXYL7B
         j3LFQxVoz4CsE+mTHufQOeirEmx8NjISdQ7wFlHViYjNaReU9rdzD2CJdux0J9083p9P
         e8V+Ahm51nsIRm4K04yTtGBww6Sq2DCOPlADf0062rz0QVH0IUXY21MBQ4xAcEsxAZGN
         vFnA==
X-Gm-Message-State: AOJu0YwCLjyk+odsV0rH4T8u0CjSGsx1ChzFq8Vsv+e+9FsOotXQ5fHe
        NqvIVtye1Y7dJq10YxXiDVjmEFFKRSyTO0Jrco0wkWjtN7KP8kHI0DYd90px+o9yipBfYByAh5q
        u4DtfEKdfk2+vErhSJ14=
X-Received: by 2002:a7b:ce96:0:b0:3fb:af9a:bf30 with SMTP id q22-20020a7bce96000000b003fbaf9abf30mr1285771wmj.2.1692180765682;
        Wed, 16 Aug 2023 03:12:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqO5dx9GO1vQCAK5+arzBnsN6aBIoqM8XkI0MI+rXYVfXFTOndkgoOu924oMpblFAwifphRQ==
X-Received: by 2002:a7b:ce96:0:b0:3fb:af9a:bf30 with SMTP id q22-20020a7bce96000000b003fbaf9abf30mr1285749wmj.2.1692180765222;
        Wed, 16 Aug 2023 03:12:45 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:8b00:5520:fa3c:c527:592f? (p200300cbc74b8b005520fa3cc527592f.dip0.t-ipconnect.de. [2003:cb:c74b:8b00:5520:fa3c:c527:592f])
        by smtp.gmail.com with ESMTPSA id e9-20020a05600c218900b003fe195cecb3sm23635677wme.38.2023.08.16.03.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 03:12:44 -0700 (PDT)
Message-ID: <fc1372e6-d64a-1788-fab8-bc0fdb12587d@redhat.com>
Date:   Wed, 16 Aug 2023 12:12:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH 7/9] mm: Add deferred_list page flag
In-Reply-To: <ZNw/FEDndlAsHlVm@casper.infradead.org>
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

On 16.08.23 05:14, Matthew Wilcox wrote:
> On Tue, Aug 15, 2023 at 08:58:24PM +0100, Matthew Wilcox wrote:
>> On Tue, Aug 15, 2023 at 07:27:26PM +0200, David Hildenbrand wrote:
>>> On 15.08.23 19:06, Matthew Wilcox wrote:
>>>> Theree are a lot of counters called THP and TransHuge and other variants
>>>> which are exposed to userspace, and the (user) assumption is that this counts
>>>> PMD-sized folios.  If you grep around for folio_test_pmd_mappable(),
>>>> you'll find them.  If we have folio_test_thp(), people will write:
>>>>
>>>> 	if (folio_test_thp(folio))
>>>> 		__mod_lruvec_state(lruvec, NR_SHMEM_THPS, nr);
>>>>
>>>> instead of using folio_test_pmd_mappable().
>>>
>>> So if we *really* don't want to use THP to express that we have a page, then
>>> let's see what these pages are:
>>> * can be mapped to user space
>>> * are transparent to most MM-related systemcalls by (un) mapping
>>>    them in system page size (PTEs)
>>
>>   * Are managed on the LRU
> 
> I think this is the best one to go with.  Either that or "managed by
> rmap".  That excludes compoud pages which are allocated from vmalloc()
> (which can be mmaped), page tables, slab, etc.  It includes both file
> and anon folios.
> 
> I have a handy taxonomy here: https://kernelnewbies.org/MemoryTypes
> 
> Unfortunately, folio_test_lru() already exists and means something
> different ("Is this folio on an LRU list").  I fear folio_test_rmap()
> would have a similar confusion -- "Is this folio currently findable by
> rmap", or some such. folio_test_rmappable()?
But what about hugetlb, they are also remappable? We could have 
folio_test_rmappable(), but that would then also better include hugetlb ...

(in theory, one could envision hugetlb also using an lru mechanism, 
although I doubt/hope it will ever happen)

Starting at the link you provided, I guess "vmalloc" and "net pool" 
would not fall under that category, or would they? (I'm assuming they 
don't get mapped using the rmap, so they are "different", and they are 
not managed by lru).

So I assume we only care about anon+file (lru-managed). Only these are 
rmappable (besides hugetlb), correct?

folio_test_lru_managed()

Might be cleanest to describe anon+file that are managed by the lru, 
just might not be on a lru list right now (difference to folio_test_lru()).


I've been also thinking about

"folio_test_normal"

But it only makes sense when "all others (including hugetlb) are the odd 
one".

-- 
Cheers,

David / dhildenb

