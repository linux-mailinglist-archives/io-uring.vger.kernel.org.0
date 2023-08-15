Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C7A77C89E
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 09:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbjHOHeS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 03:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbjHOHdx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 03:33:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D16310C
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692084785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iwEGsjAYYmU/0NnOLMGjjwtkw3W4YTwviDDRA2jQ7dI=;
        b=Y8qOITozj9Myql3TPeaclP0ur1Ak/+H1kSVKLtASASCSg5Jl4RTcgbheYnckgGncpwExOZ
        VO2DzoTKEb2pv392DB8xdyqOvN3a7Axg/XSUIHEhEOtz4JUs9utvvT0la0AklKSMbx1wvW
        3YhkWEFWN+f715nT81CsyitzzF6eCSM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-Zut4ZYbMN4-HSLgIS4Yadw-1; Tue, 15 Aug 2023 03:33:03 -0400
X-MC-Unique: Zut4ZYbMN4-HSLgIS4Yadw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fe603e8054so34092125e9.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 00:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692084782; x=1692689582;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iwEGsjAYYmU/0NnOLMGjjwtkw3W4YTwviDDRA2jQ7dI=;
        b=kEQRhVQ4mNnjLVcdR0km7/eLoAvFriUBulFcDkWgrE5lUfv+u5bcDU1CMBfXxCoQ/0
         kH6QYhqsScJivPwYpDPr9kXyBbHE1QW4Wzk1VWu7s7nQHBxqetzVEKrTHBfjtOY/RHkn
         732wcELMN0dtzQYLL4hfgQHM2oQn+Lx5P5pGyfoDiC0wARHXcCMXWfAuccEMy6dqNytO
         AbeYLeVDcrAOShl5TQba8Z9Oi9xK7wXegwRhfTn/QBr91MjVlD/qyfforxHwGL7sM5cW
         7HPmVarnoP+0KbVcnKTAzMpekxE51Vi5tEH6UyMlq8iUuZdUX4nRRn+q40vj+jrC4/9i
         nk2Q==
X-Gm-Message-State: AOJu0YzoBCQK5vFUH/VewJzVIw3XDpmhTl2juSuigx+1AI9fg1T2VJfn
        OKoq0CzFq77OToRbjVBi2g5JtgGFGiOqsljkoa6zfaCsUBNAIB58yb6iDd72KaL3Y0o9FeznnwF
        J6icELiQ/4nBXkag/t4E=
X-Received: by 2002:a7b:c3d3:0:b0:3fe:f45:774c with SMTP id t19-20020a7bc3d3000000b003fe0f45774cmr9938108wmj.41.1692084782763;
        Tue, 15 Aug 2023 00:33:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaBBeG0wiCjx9Od4TsN9U8hE55XJB1UuXeO2ZEtO0OkvJZJPWfFKGmivq/oXPKey55VMWIlQ==
X-Received: by 2002:a7b:c3d3:0:b0:3fe:f45:774c with SMTP id t19-20020a7bc3d3000000b003fe0f45774cmr9938098wmj.41.1692084782361;
        Tue, 15 Aug 2023 00:33:02 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:3100:c642:ba83:8c37:b0e? (p200300cbc7013100c642ba838c370b0e.dip0.t-ipconnect.de. [2003:cb:c701:3100:c642:ba83:8c37:b0e])
        by smtp.gmail.com with ESMTPSA id 14-20020a05600c22ce00b003fba2734f1esm19876731wmg.1.2023.08.15.00.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 00:33:01 -0700 (PDT)
Message-ID: <5c36b8a5-4e10-1a20-e84b-b4f22573000e@redhat.com>
Date:   Tue, 15 Aug 2023 09:33:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/9] io_uring: Stop calling free_compound_page()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-2-willy@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230815032645.1393700-2-willy@infradead.org>
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
> folio_put() is the standard way to write this, and it's not
> appreciably slower.  This is an enabling patch for removing
> free_compound_page() entirely.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---


Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

