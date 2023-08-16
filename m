Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588F777E507
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344179AbjHPPXS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344103AbjHPPWs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:22:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB10F7
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692199322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBcZ0qgYuUHjYQeZqoRe/0dlHfm+do76R6cqmuSlLyc=;
        b=R9bPAhqUEdJsnP9ckdM8aPdlZK4Favkd4R0koFHIcWNfYzHZ1ZI0DbqBMstt/NkEnzr79+
        PVFMqWMgWImzKelB/In7Hgrul3wx6dFJ8xfeXhPdeuGMskEA/331fxEYFa/8d6hZHv0whK
        EmRnnYkH+RG9P5P+1r/0Bf8PvCS8gDA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-B6zUwfEROFGW22noVp-P8Q-1; Wed, 16 Aug 2023 11:22:01 -0400
X-MC-Unique: B6zUwfEROFGW22noVp-P8Q-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ba83b74a49so39139841fa.2
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:22:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692199319; x=1692804119;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBcZ0qgYuUHjYQeZqoRe/0dlHfm+do76R6cqmuSlLyc=;
        b=ElJQW7gA3V+RPJOlg1iyRyAoOq/0mTHT51dPzvR+xYKth8ZXGMKWI8dYSmTDlGUF50
         Y0hZJvU5qm6wIScFX2/xgNUVEchYYrOw6FI+s2RVxj1e0XePsMY08Ol+HiMy5ZzzngLV
         3KtI6A0iRyXWZVm/6PUMioo3k12Q5ObwbtPft1qgTZndhkEV5LBV7Mja03cVBFvfBWW5
         LWEmJ4yWuqULuvpVynqJRO4ZUIJEpdMSN9Pl3D4eZ1Q6ZkdYdpU4SGxq3EU04mTuybf8
         XAiI1hJj0ADPdNzpJXzhBVO3iJE6xZAKiI57nBRCb3WHq6KWIZNWBKi3iQtbveU7dvsN
         ZJQg==
X-Gm-Message-State: AOJu0YxZXYh+pECSUayHBEd3yO+NO54z7K2dLziY8AORvBvmN+gTi1G8
        l1avqKa3bJoWDmU8xxB0OdQad2/2LsrTKFDI7T4d6EJ+/ftOKneMokeav5QBLj86HHYuq1dBCMP
        Bn+H9mF8vC6uXNgVb8zI=
X-Received: by 2002:a2e:9f57:0:b0:2b6:b6c4:6e79 with SMTP id v23-20020a2e9f57000000b002b6b6c46e79mr1894187ljk.1.1692199319641;
        Wed, 16 Aug 2023 08:21:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHO95sA0EX/EvVXLOUxUM/6sQI+dxzUPqDmInX4WwAbLVC3zYS6VwjAcA6rs4uMEoWtv6Sb2A==
X-Received: by 2002:a2e:9f57:0:b0:2b6:b6c4:6e79 with SMTP id v23-20020a2e9f57000000b002b6b6c46e79mr1894166ljk.1.1692199319162;
        Wed, 16 Aug 2023 08:21:59 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:8b00:5520:fa3c:c527:592f? (p200300cbc74b8b005520fa3cc527592f.dip0.t-ipconnect.de. [2003:cb:c74b:8b00:5520:fa3c:c527:592f])
        by smtp.gmail.com with ESMTPSA id u16-20020a5d4690000000b00313de682eb3sm21547979wrq.65.2023.08.16.08.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 08:21:58 -0700 (PDT)
Message-ID: <46e3dfa6-9fea-df51-cff7-e1b916e77a31@redhat.com>
Date:   Wed, 16 Aug 2023 17:21:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 12/13] mm: Add tail private fields to struct folio
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-13-willy@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230816151201.3655946-13-willy@infradead.org>
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

On 16.08.23 17:12, Matthew Wilcox (Oracle) wrote:
> Because THP_SWAP uses page->private for each page, we must not use
> the space which overlaps that field for anything which would conflict
> with that.  We avoid the conflict on 32-bit systems by disallowing
> THP_SWAP on 32-bit.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   include/linux/mm_types.h | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 659c7b84726c..3880b3f2e321 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -340,8 +340,11 @@ struct folio {
>   			atomic_t _pincount;
>   #ifdef CONFIG_64BIT
>   			unsigned int _folio_nr_pages;
> -#endif
> +			/* 4 byte gap here */
>   	/* private: the union with struct page is transitional */
> +			/* Fix THP_SWAP to not use tail->private */
> +			unsigned long _private_1;

If you could give

https://lkml.kernel.org/r/b887e764-ffa3-55ee-3c44-69cb15f8a115@redhat.com

a quick glimpse to see if anything important jumps at you, that would be 
great.

That really should be fixed.

-- 
Cheers,

David / dhildenb

