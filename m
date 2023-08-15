Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830F577D0FF
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbjHOR3N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238713AbjHOR2z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:28:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48171BD1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692120450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2uSl+ad9ZJrMAwLExJuewpBdrVGNDC/Z6BFlUzuDmqw=;
        b=H6iO2qTZmCt9SdL1hnb2O/GutT0wtAWMoc6ZJ9WZN3nQO5BYn14EwUJPE2epXo3EjFLHTD
        y/j46hBFJpd/1pv6ax/IH7PdkPJuEL39hHus6y3i0aND2WrMgTJN3IlHvMS3hyHS09Q2OM
        kegJrx4bxMzcdEdhl97qAQW6MPC/JjA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-6jBvsdGrO0qshJFP-qLfOA-1; Tue, 15 Aug 2023 13:27:29 -0400
X-MC-Unique: 6jBvsdGrO0qshJFP-qLfOA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3176c4de5bbso3169292f8f.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:27:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120448; x=1692725248;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2uSl+ad9ZJrMAwLExJuewpBdrVGNDC/Z6BFlUzuDmqw=;
        b=k7TqFUrrqef2JjgKV7YmcdwZFxADKM8m5UCXkKyV273BaMBEG5RNrUo/mCrJi+I5aX
         IB68KMtEnrw5KbQcFlUUVVMeQZIE9CfafVSEZWCyS+UNJJ8+k9h8EhVWIcIIJMFLXQqL
         OAqvyxcH29utztBURlVdYBEnRZoL2IpcJ25RZwJYDFmzfsJrEsENrVsG5rSLOCHCDZ0d
         yxzMMnpNkElpasPEDTYIa4ISnavHP9QE1eUG2Dxiu33NPFV6IILZug+ObgXAf0c/hirU
         COEiHHyuZBskNeY9CDMe29NEifjIFS61VZUZsMpPRxoLuTXIpbGUeP2s5opoZGbMJZIB
         4O7A==
X-Gm-Message-State: AOJu0YxI7VbQbFiDmAvGB3sb2+SlZaI61A9XTHGRaNTIP1vJbKInSbi5
        KKpEAZnSqO7s1uHawohkgIvBHu3v7Yfz117haqRkjtsXJO02pPmuKQm9GtEais1OWYBE1fLGnBT
        KkBmShS/VKSkgSNDbyOQ=
X-Received: by 2002:adf:efc2:0:b0:314:370f:e92c with SMTP id i2-20020adfefc2000000b00314370fe92cmr10407119wrp.67.1692120447928;
        Tue, 15 Aug 2023 10:27:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFHpJTpEtdHaORHl3IBepG/4Q1QmmaT6Ir71bM+CX9L0QpUJUTo+h1XxGn9yYs2bQkHm5Mvw==
X-Received: by 2002:adf:efc2:0:b0:314:370f:e92c with SMTP id i2-20020adfefc2000000b00314370fe92cmr10407096wrp.67.1692120447566;
        Tue, 15 Aug 2023 10:27:27 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id i7-20020a5d5587000000b00314172ba213sm18569627wrv.108.2023.08.15.10.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 10:27:26 -0700 (PDT)
Message-ID: <aac4404a-1012-fe7f-4337-cace30795176@redhat.com>
Date:   Tue, 15 Aug 2023 19:27:26 +0200
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH 7/9] mm: Add deferred_list page flag
In-Reply-To: <ZNuwm2kPzmeHo2bU@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15.08.23 19:06, Matthew Wilcox wrote:
> On Tue, Aug 15, 2023 at 06:40:55PM +0200, David Hildenbrand wrote:
>> On 15.08.23 17:32, Matthew Wilcox wrote:
>>> On Tue, Aug 15, 2023 at 09:54:36AM +0200, David Hildenbrand wrote:
>>>> On 15.08.23 05:26, Matthew Wilcox (Oracle) wrote:
>>>>> Stored in the first tail page's flags, this flag replaces the destructor.
>>>>> That removes the last of the destructors, so remove all references to
>>>>> folio_dtor and compound_dtor.
>>>>>
>>>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>>>> ---
>>>>
>>>> [...]
>>>>
>>>>> +	/* Has a deferred list (may be empty).  First tail page. */
>>>>> +	PG_deferred_list = PG_reclaim,
>>>>> +
>>>>
>>>> If PG_deferred_list implies thp (and replaces the thp dtor), should we
>>>> rather name this PG_thp or something along those lines?
>>>
>>> We're trying to use 'thp' to mean 'a folio which is pmd mappable',
>>> so I'd rather not call it that.
>>
>> There is no conclusion on that.
> 
> Theree are a lot of counters called THP and TransHuge and other variants
> which are exposed to userspace, and the (user) assumption is that this counts
> PMD-sized folios.  If you grep around for folio_test_pmd_mappable(),
> you'll find them.  If we have folio_test_thp(), people will write:
> 
> 	if (folio_test_thp(folio))
> 		__mod_lruvec_state(lruvec, NR_SHMEM_THPS, nr);
> 
> instead of using folio_test_pmd_mappable().
> 


So if we *really* don't want to use THP to express that we have a page, 
then let's see what these pages are:
* can be mapped to user space
* are transparent to most MM-related systemcalls by (un) mapping
   them in system page size (PTEs)

That we can split these pages (not PTE-map, but convert from large folio 
to small folios) is one characteristic, but IMHO not the main one (and 
maybe not even required at all!).

Maybe we can come up with a better term for "THP, but not necessarily 
PMD-sized".

"Large folio" is IMHO bad. A hugetlb page is a large folio and not all 
large folios can be mapped to user space.

"Transparent large folios" ? Better IMHO.


>> After all, the deferred split queue is just an implementation detail, and it
>> happens to live in tailpage 2, no?
>>
>> Once we would end up initializing something else in prep_transhuge_page(),
>> it would turn out pretty confusing if that is called folio_remove_deferred()
>> ...
> 
> Perhaps the key difference between normal compound pages and file/anon
> compound pages is that the latter are splittable?  So we can name all
> of this:
> 
> 	folio_init_splittable()
> 	folio_test_splittable()
> 	folio_fini_splittable()
> 
> Maybe that's still too close to an implementation detail, but it's at
> least talking about _a_ characteristic of the folio, even if it's not
> the _only_ characteristic of the folio.

Maybe folio_init_transparent() ... avoiding the "huge" part of it.

Very open for alternatives. As expressed in other context, we really 
should figure this out soon.

-- 
Cheers,

David / dhildenb

