Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203246E68C3
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 17:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjDRP5g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 11:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbjDRP5d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 11:57:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871FFC678
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 08:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681833404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Juss3UIfNZnJDgajqfUY7HSWywG2tSbHHgh51Zf9/Ao=;
        b=JCk1pFo0nM/aWrQNqZjorNM7I4gaDyt9wToIOTO08qVOjl37WEClsZTauTycIYcSOdTup/
        YBoTS47l4SJ2jhUnWAllwSpOjoM315S3Y8euUKhgtJ2uSVy2TsN2Lyc87Wvh5q+ZpR4MJW
        8ukyptJNLeNSoDjaHgBJWTKU+D9tiJA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-owfnxk3PMlSkaueMeY5x7Q-1; Tue, 18 Apr 2023 11:56:43 -0400
X-MC-Unique: owfnxk3PMlSkaueMeY5x7Q-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f0b0c85c4fso42618895e9.0
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 08:56:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681833402; x=1684425402;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Juss3UIfNZnJDgajqfUY7HSWywG2tSbHHgh51Zf9/Ao=;
        b=dVCgtrmWcKtULo/K5fqPl2larQTK1uoBFG2+vjVXt1lQWpGiFgKwAA2JF+fWUQjHIT
         iLX2snEO+bfNNDgAeHO1HOiBMC5DYg/eiri0JV5VaTaa7m2vDybCOi1WO2UKJAsA1OrP
         vaWaJh4WgEOLr4tO8W1uwTnQoOxhynbY+tcOpWimajHuQhC6t6WPTlUfiUsP+Rt7IYxC
         +12AJ/ptH+8mWDJxsnA9ZFpHEiCGgRObHisSe4lYpm4ZZKJunV+ueTEu4DzQlHSYHK0k
         1ssaeuHLFwIL5xmwYH3AW4RvSYpwCTAtlvyBM6N86Qfq95Dx+M3paQ7JYDDizwPrBFj6
         pRkQ==
X-Gm-Message-State: AAQBX9cdIdVk1cAiVdwF52Aw9zeMCMReOvoW1HeJiTxUJ5sSFcvihqaU
        z91LtYbnOpd+OHYrEU1zYH0Dlnr+e/Pnudf5UZ39feUxFLhFUpZ8kZWrVLynzi7E3Aw6nzSgUaE
        QH/1L2Qt0qNhdbEsNq0s=
X-Received: by 2002:a5d:6781:0:b0:2fc:3596:7392 with SMTP id v1-20020a5d6781000000b002fc35967392mr2628936wru.24.1681833402338;
        Tue, 18 Apr 2023 08:56:42 -0700 (PDT)
X-Google-Smtp-Source: AKy350YBuzvTWcCQhnHtly8+4rzkBkEULSOiTAtS5qyHVRgWX5InlOQK650XXEk9mTPSPN0p7akgTA==
X-Received: by 2002:a5d:6781:0:b0:2fc:3596:7392 with SMTP id v1-20020a5d6781000000b002fc35967392mr2628920wru.24.1681833402021;
        Tue, 18 Apr 2023 08:56:42 -0700 (PDT)
Received: from ?IPV6:2003:cb:c715:3f00:7545:deb6:f2f4:27ef? (p200300cbc7153f007545deb6f2f427ef.dip0.t-ipconnect.de. [2003:cb:c715:3f00:7545:deb6:f2f4:27ef])
        by smtp.gmail.com with ESMTPSA id z2-20020adff1c2000000b002f900cfc262sm8099302wro.66.2023.04.18.08.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 08:56:41 -0700 (PDT)
Message-ID: <21bc9c1e-9941-9f51-0a38-85ae406ff2cd@redhat.com>
Date:   Tue, 18 Apr 2023 17:56:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <7fabe6ee-ba8f-6c48-c9f7-90982e2e258c@redhat.com>
Organization: Red Hat
In-Reply-To: <7fabe6ee-ba8f-6c48-c9f7-90982e2e258c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18.04.23 17:55, David Hildenbrand wrote:
> On 18.04.23 17:49, Lorenzo Stoakes wrote:
>> We are shortly to remove pin_user_pages(), and instead perform the required
>> VMA checks ourselves. In most cases there will be a single VMA so this
>> should caues no undue impact on an already slow path.
>>
>> Doing this eliminates the one instance of vmas being used by
>> pin_user_pages().
>>
>> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
>> ---
>>    io_uring/rsrc.c | 55 ++++++++++++++++++++++++++++---------------------
>>    1 file changed, 31 insertions(+), 24 deletions(-)
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index 7a43aed8e395..3a927df9d913 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -1138,12 +1138,37 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
>>    	return ret;
>>    }
>>    
>> +static int check_vmas_locked(unsigned long addr, unsigned long len)
> 
> TBH, the whole "_locked" suffix is a bit confusing.
> 
> I was wondering why you'd want to check whether the VMAs are locked ...

FWIW, "check_vmas_compatible_locked" might be better. But the "_locked" 
is still annoying.

-- 
Thanks,

David / dhildenb

