Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5695B77C903
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 10:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbjHOIAA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 04:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235515AbjHOH76 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 03:59:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14F81BEC
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692086353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+fhSb60DAO5zxv6eiqTf6hJuQxjQD5XlqwVvIqsMuc=;
        b=I+5SwnuymwSf+J7Olc3Lm3UBT78jbgIQsK31b1jnbuO6fsHDa1/+HvhpmUsOAiiYrncI83
        POsP7A1ZF+3f3g2Nb9aYxRK+sx8io8TSPjuX5JoU1TnKsdXA1LIvjaEf7rnSca7dEt4s4J
        Nz2UL95kxBIsMgXmbWpwttfXODBamUg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-7K8SbHutNq2IUtQn3LtaLA-1; Tue, 15 Aug 2023 03:59:11 -0400
X-MC-Unique: 7K8SbHutNq2IUtQn3LtaLA-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b9dc1bfdd2so52569651fa.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:59:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692086350; x=1692691150;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x+fhSb60DAO5zxv6eiqTf6hJuQxjQD5XlqwVvIqsMuc=;
        b=XMGpwtHlPEHFU5iPZ59D0mmN4Lrxr5GshnPnLajcB4UGgUUibiW8SNyg8AFLJwvAwI
         LLBQFQv8zGC5YCFYER+Ih3wM5xk6P/fZ/z3c8xQfGV3s0m/4ZJX1JI7F/L9C4FELOWJq
         DREo0+miQUEcR0/BjcoNHLUVcMT6ccR0uYjW6Wk43Ye/mNSWhIgOt+AkcuxSlPxfVCf5
         fMddHc+8708QxLdTld0LLaQGwj9zU5Q+hh7q8Vy/yddkiSbG+6OkxvBwvgSnk3crigy2
         gRM3ErDZoFXaoRF088HBYPJpL76P2nnc2Ew3x1KJOouKuKb8hVSZYs3WTcn5nMFKFz7E
         smZA==
X-Gm-Message-State: AOJu0YznTw//btvjaMI2WmsSNIdP9qUmWBS0aVlZFvzzyYNiBkzr0+sx
        itkYYBYzjnPJ+7h0A9zmJJES9GnZdg2LHesuyzW5qwzE7mg51roSy/86jYZ8okGIvwOiYGL3JQE
        ry/ITTks2HwlI5cyVImzyCtksc+o=
X-Received: by 2002:a2e:b6d4:0:b0:2b9:e6a0:5c3a with SMTP id m20-20020a2eb6d4000000b002b9e6a05c3amr8620620ljo.48.1692086349929;
        Tue, 15 Aug 2023 00:59:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOwU+qr16B3GOIa0XQyW4oGJLwdelMBJJ4sfS+du9r8szi/wusE0tAj+jxUERr9xt0lFsCBw==
X-Received: by 2002:a2e:b6d4:0:b0:2b9:e6a0:5c3a with SMTP id m20-20020a2eb6d4000000b002b9e6a05c3amr8620608ljo.48.1692086349560;
        Tue, 15 Aug 2023 00:59:09 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id c16-20020a7bc010000000b003fc00212c1esm16974708wmb.28.2023.08.15.00.59.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 00:59:09 -0700 (PDT)
Message-ID: <86579ba0-057e-37bd-e2ec-bd705026daa5@redhat.com>
Date:   Tue, 15 Aug 2023 09:59:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 9/9] mm: Free up a word in the first tail page
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-10-willy@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230815032645.1393700-10-willy@infradead.org>
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
> Store the folio order in the low byte of the flags word in the first
> tail page.  This frees up the word that was being used to store the
> order and dtor bytes previously.
> 

Is there still a free flag in page[1] after this change? I need one, at 
least for a prototype I'm working on. (could fallback to page[2], though 
eventually, though)

-- 
Cheers,

David / dhildenb

