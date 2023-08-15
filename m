Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D255777C8E5
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 09:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbjHOHvr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 03:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbjHOHvS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 03:51:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A261980
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692085838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+NZXQHeGRtC2BhfxEymVhXBYqngBThVwVdw/XZHCYok=;
        b=Emv4E754He8+c21T2VaUrNj/ztBWGqmDFCynsk0AQKXDlVJHEgFBPTQxnQR9bqIAOPkd13
        V6qR9kOprDahZXI6CCNTl0A6bpTdjSiXpmUYCfpss1hwUBodGVUbOXEeNYYPl+E6BNoxqU
        iYb6gcwnjnmV5niw9EspYpYs6hVcndo=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-8X-vIY3INuOzufnK-AO4LQ-1; Tue, 15 Aug 2023 03:50:37 -0400
X-MC-Unique: 8X-vIY3INuOzufnK-AO4LQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b9ba719605so54068881fa.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692085836; x=1692690636;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+NZXQHeGRtC2BhfxEymVhXBYqngBThVwVdw/XZHCYok=;
        b=cNVN2RrNItn3MYAFj/QAsdHNBHQ/HoJjFPkWKhEypjOJhX8jH3ri3DkeZcMWPfSb93
         ZWpM5ibrf0qKH/+aMmLjMkQQPY8k/MWvPkYHh06oUGzKiE7PZ1pHac/TDoaTPJX6+JkY
         ujYMaM8bJSvR3tv/mkZ5dq6cDfNXihSboXoNXFFVdhXro2LqA3+LkEkMIdGNFGK8tlE3
         hYywjlUmJJXJEH+cfXD2Yic9APIpSzOgbNiF1eSKYoBp+1TzDfc0unQbdPwZ/rAazHzd
         mXrBqqs7+CptULTIhThadq6ak2G6DmB0QTDn5OdaGvRL1uN+pMYEVw1/m4+T1xh2VO9Q
         8q+w==
X-Gm-Message-State: AOJu0YznMmXWku1/hL2oV1Vnmty4bA3eR4QCTY8BGB7xxB5enn5noTd+
        hu/nap05YdD9Wr5YIXx513xOt+shAgyw1NiO7gexvzMATJlmUow5vBtbF6K4jBTIlc8uHiiNQ3T
        MzNy5o4YanUzUhSi0BYM=
X-Received: by 2002:a2e:8044:0:b0:2b9:5eae:814f with SMTP id p4-20020a2e8044000000b002b95eae814fmr7539268ljg.50.1692085835821;
        Tue, 15 Aug 2023 00:50:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6xMBWNQ50RjH4SNAiRzj+qQ7LnwtZA4RbJR5ijoKeLVl/iNAEJnVUKnjCWldRjeSCd1imNw==
X-Received: by 2002:a2e:8044:0:b0:2b9:5eae:814f with SMTP id p4-20020a2e8044000000b002b95eae814fmr7539252ljg.50.1692085835464;
        Tue, 15 Aug 2023 00:50:35 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id g5-20020adfe405000000b0031773a8e5c4sm16997012wrm.37.2023.08.15.00.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 00:50:34 -0700 (PDT)
Message-ID: <0e10262d-f961-9c04-74f7-931352b015da@redhat.com>
Date:   Tue, 15 Aug 2023 09:50:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6/9] mm: Remove HUGETLB_PAGE_DTOR
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-7-willy@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230815032645.1393700-7-willy@infradead.org>
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
> We can use a bit in page[1].flags to indicate that this folio belongs
> to hugetlb instead of using a value in page[1].dtors.  That lets
> folio_test_hugetlb() become an inline function like it should be.
> We can also get rid of NULL_COMPOUND_DTOR.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   .../admin-guide/kdump/vmcoreinfo.rst          | 10 +---
>   include/linux/mm.h                            |  2 -
>   include/linux/page-flags.h                    | 21 +++++++-
>   kernel/crash_core.c                           |  2 +-
>   mm/hugetlb.c                                  | 49 +++----------------
>   5 files changed, 29 insertions(+), 55 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
> index c18d94fa6470..baa1c355741d 100644
> --- a/Documentation/admin-guide/kdump/vmcoreinfo.rst


Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

