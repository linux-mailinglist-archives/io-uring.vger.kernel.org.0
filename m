Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B4977DDF4
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 11:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjHPJ4Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 05:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243635AbjHPJ4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 05:56:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F442D1
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 02:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692179718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+l6CVYESkWNXZKOgwhwVdfDgv7To5sUrc78oVwNDueY=;
        b=R9Mjh55QxPR81Mkw5rc+7+mj3V4Ljlv5BebVtHq7hU37+PYsuikzKwTYRJPoGwFu0uba2b
        vkLKFymsn+dW+p33+ImACP53AtvPRhp2QkSpBZo54Iy/Y22VIQgQ2ke9/ge7JvR6FB/ko7
        jjZMVrHvGFdwYs8Bcrus+XaHqdRDUBs=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-YUK0SNMlMUyt-YzD1pC6Uw-1; Wed, 16 Aug 2023 05:55:17 -0400
X-MC-Unique: YUK0SNMlMUyt-YzD1pC6Uw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b8405aace3so61221251fa.3
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 02:55:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692179713; x=1692784513;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+l6CVYESkWNXZKOgwhwVdfDgv7To5sUrc78oVwNDueY=;
        b=RHVEjB/J02cp0OZAZlyoPC5fP+A/obs6DkGLDfgFxM2gTbw4cM3btOpCzkXHbDf07L
         iOJvCVA4lW6q5+wIqWfS50K5GUCAiZUgGUU4rvO3lrxfOzEhtq7DHwQPxgI+oLXGRpZW
         yEQSyDc/nTdOWW5w9pGQYMK4kFLpMJiYcXYlnuv2E/XDzqTXR5mQ+syp0bqq2IcqIeEw
         2BgQtObneJoNLdtpP5KRbIGRpd25L0SEKmG62AuWv7JvxWRq52nmoRxtsiY6ky5pmMsF
         U9GxLFtPanzRhxI6N8qGwroPAYUD4VSLJ+QuWIazjjrL0lg/BdfMdrsEJIX1t7v7e24S
         g6yA==
X-Gm-Message-State: AOJu0Yxas9x6/5k5TFgl6jYvdt/qaxE587n6TH7ih5aliL3CsHRUdV7f
        vdgTYe/rO7ESQyQs5+l1qt24YXWKxolz7M80ttlDbOKfVf3nUgIn/BXXRM2wJxfS7iGMUHFJ4CH
        rNrcur9UAww2SW8f9GKkLmQUOU6I=
X-Received: by 2002:a2e:6f16:0:b0:2b9:c676:434a with SMTP id k22-20020a2e6f16000000b002b9c676434amr1108396ljc.15.1692179713715;
        Wed, 16 Aug 2023 02:55:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJq2vzPFGwybgPTa4U1oMr8QMSVMGXmm9UusE5Tq36K9vQoxcrWDmAYbbzDL97NzJSypd23g==
X-Received: by 2002:a2e:6f16:0:b0:2b9:c676:434a with SMTP id k22-20020a2e6f16000000b002b9c676434amr1108384ljc.15.1692179713324;
        Wed, 16 Aug 2023 02:55:13 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:8b00:5520:fa3c:c527:592f? (p200300cbc74b8b005520fa3cc527592f.dip0.t-ipconnect.de. [2003:cb:c74b:8b00:5520:fa3c:c527:592f])
        by smtp.gmail.com with ESMTPSA id l5-20020a7bc345000000b003feae747ff2sm4374556wmj.35.2023.08.16.02.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 02:55:12 -0700 (PDT)
Message-ID: <f4e04f9d-082b-bd9b-28c6-bc28193d7d52@redhat.com>
Date:   Wed, 16 Aug 2023 11:55:12 +0200
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZNvY4AbRCwjwVY7f@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15.08.23 21:58, Matthew Wilcox wrote:
> On Tue, Aug 15, 2023 at 07:27:26PM +0200, David Hildenbrand wrote:
>> On 15.08.23 19:06, Matthew Wilcox wrote:
>>> Theree are a lot of counters called THP and TransHuge and other variants
>>> which are exposed to userspace, and the (user) assumption is that this counts
>>> PMD-sized folios.  If you grep around for folio_test_pmd_mappable(),
>>> you'll find them.  If we have folio_test_thp(), people will write:
>>>
>>> 	if (folio_test_thp(folio))
>>> 		__mod_lruvec_state(lruvec, NR_SHMEM_THPS, nr);
>>>
>>> instead of using folio_test_pmd_mappable().
>>
>> So if we *really* don't want to use THP to express that we have a page, then
>> let's see what these pages are:
>> * can be mapped to user space
>> * are transparent to most MM-related systemcalls by (un) mapping
>>    them in system page size (PTEs)
> 
>   * Are managed on the LRU
>   * Can be dirtied, written back

Right, but at least hugetlb *could* be extended to do that as well (and 
even implement swapping). I think the biggest difference is the 
transparency/PTE-mapping/unmapping/ ....

> 
>> That we can split these pages (not PTE-map, but convert from large folio to
>> small folios) is one characteristic, but IMHO not the main one (and maybe
>> not even required at all!).
> 
> It's the one which distinguishes them from, say, compound pages used for
> slab.  Or used by device drivers.  Or net pagepool, or vmalloc.  There's
> a lot of compound allocations out there, and the only ones which need
> special treatment here are the ones which are splittable.

And my point is that that is an implementation detail I'm afraid. 
Instead of splitting the folio into order-0 folios, you could also 
migrate off all data to order-0 folios and just free the large folio.

Because splitting only succeeds if there are no other references on the 
folio, just like migration.

But let's not get distracted :)

> 
>> Maybe we can come up with a better term for "THP, but not necessarily
>> PMD-sized".
>>
>> "Large folio" is IMHO bad. A hugetlb page is a large folio and not all large
>> folios can be mapped to user space.
>>
>> "Transparent large folios" ? Better IMHO.
> 
> I think this goes back to Johannes' point many months ago that we need
> separate names for some things.  He wants to split anon & file memory
> apart (who gets to keep the name "folio" in the divorce?  what do we
> name the type that encompasses both folios and the other one?  or do
> they both get different names?)

Good question. I remember discussing a type hierarchy back when you 
upstreamed folios.

Maybe we would have "file folios" and "anon folios.

> 
>>> Perhaps the key difference between normal compound pages and file/anon
>>> compound pages is that the latter are splittable?  So we can name all
>>> of this:
>>>
>>> 	folio_init_splittable()
>>> 	folio_test_splittable()
>>> 	folio_fini_splittable()
>>>
>>> Maybe that's still too close to an implementation detail, but it's at
>>> least talking about _a_ characteristic of the folio, even if it's not
>>> the _only_ characteristic of the folio.
>>
>> Maybe folio_init_transparent() ... avoiding the "huge" part of it.
>>
>> Very open for alternatives. As expressed in other context, we really should
>> figure this out soon.
> 
> Yeah, I'm open to better naming too.  At this point in the flow we're
> trying to distinguish between compound pages used for slab and compound
> pages used for anon/file, but that's not always going to be the case
> elsewhere.


Yes. Let me reply to your other mail.

-- 
Cheers,

David / dhildenb

