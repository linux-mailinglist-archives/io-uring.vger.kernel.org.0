Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FBD77D03E
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 18:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238539AbjHOQmT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 12:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238535AbjHOQly (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 12:41:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B8D1BD9
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692117660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TPjGUIOwNAgmU1eVNVpchmSMQTA9SU2ipzoUuHgNVM4=;
        b=I+lr7IsD+6sB2MMMbYB57Ro50fTwaI9sXbEZ0yWmYFXPHo8w35pd8fipochSEBZ98XEehr
        p3nE1N9+j5K6miTR/VMqAuwiEmZpOclEhCw4AazNabExY9Ln80e6Uz1EMYDhdLwI+JxiBg
        Hh7wTwK1o8dh3M7FzLxIygG9jFPw2iQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185--xWC224VNxu65-o9tt4bdw-1; Tue, 15 Aug 2023 12:40:59 -0400
X-MC-Unique: -xWC224VNxu65-o9tt4bdw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b9bb2d0b47so53852241fa.2
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 09:40:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692117657; x=1692722457;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TPjGUIOwNAgmU1eVNVpchmSMQTA9SU2ipzoUuHgNVM4=;
        b=Ao37J9yQl4jW6EOXs4//HM3pGH7JOAmWFoiYNHhWruuV1iiDGWVFxWx5ga6b3sBuYo
         ywtAk04dnDpkXzUq7pRw8D3/sNY0zzbSPBk+7mvBhs/fgmyk/k/bXxpr1JxCGB2VavbA
         aiB5eH6ONrhNQAQ4jqHH13fW6/fBzVHsQmPU7REh0ya+h80J7BfG+AoQGuPsYWYgW9YQ
         zWcB3QQzrzBvzcO5v+Qc1nuJB3Yd/KJxYgl23qokdPB+POywM6wtni8qhQb6tMB+CeuA
         U0Q3pYfJvLkO21umWd2Tz4Dq9e5JeDw6N1ld3ZNXC6yUTFadBmOarB7xwuADL1v9abBh
         vX5Q==
X-Gm-Message-State: AOJu0YzgzHN4KR+VJ3+XvDBKUQ5myULSaMpbYNghvzAGlwl/fBa36uey
        weJDorn9Dm6p7eVPdII90P/A8EjpHFMAjBjDbjWDUaYWDRFJowXCCgSKHtqXbFqeYocxBIF6+gT
        OJhU+uvOS52Lr5avYvks=
X-Received: by 2002:a05:6512:2210:b0:4fb:7666:3bbf with SMTP id h16-20020a056512221000b004fb76663bbfmr10746866lfu.26.1692117657536;
        Tue, 15 Aug 2023 09:40:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRCeuXlTNoB/q8src6Mv9NrqQMBZJ6GPbyli6kjcay7y78IutQUBxlHuzs+g9davK92xRDFw==
X-Received: by 2002:a05:6512:2210:b0:4fb:7666:3bbf with SMTP id h16-20020a056512221000b004fb76663bbfmr10746855lfu.26.1692117657134;
        Tue, 15 Aug 2023 09:40:57 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id x1-20020a05600c21c100b003fe1e3937aesm18243115wmj.20.2023.08.15.09.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 09:40:56 -0700 (PDT)
Message-ID: <88bdc3d2-56e4-4c09-77fe-74fb4c116893@redhat.com>
Date:   Tue, 15 Aug 2023 18:40:55 +0200
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH 7/9] mm: Add deferred_list page flag
In-Reply-To: <ZNuaiY483XCq1K1/@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15.08.23 17:32, Matthew Wilcox wrote:
> On Tue, Aug 15, 2023 at 09:54:36AM +0200, David Hildenbrand wrote:
>> On 15.08.23 05:26, Matthew Wilcox (Oracle) wrote:
>>> Stored in the first tail page's flags, this flag replaces the destructor.
>>> That removes the last of the destructors, so remove all references to
>>> folio_dtor and compound_dtor.
>>>
>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>> ---
>>
>> [...]
>>
>>> +	/* Has a deferred list (may be empty).  First tail page. */
>>> +	PG_deferred_list = PG_reclaim,
>>> +
>>
>> If PG_deferred_list implies thp (and replaces the thp dtor), should we
>> rather name this PG_thp or something along those lines?
> 
> We're trying to use 'thp' to mean 'a folio which is pmd mappable',
> so I'd rather not call it that.

There is no conclusion on that.

And I am not sure if inventing new terminology will help anybody (both, 
users and developers). Just call the old thing "PMD-sized THP".

After all, the deferred split queue is just an implementation detail, 
and it happens to live in tailpage 2, no?

Once we would end up initializing something else in 
prep_transhuge_page(), it would turn out pretty confusing if that is 
called folio_remove_deferred() ...

In the end, I don't care as long as it doesn't add confusion; this did. 
We most probably won't reach a conclusion here and that shouldn't block 
this patch set.

So at least prep_transhuge_page() should not be renamed to 
folio_remove_deferred() imho ...

-- 
Cheers,

David / dhildenb

