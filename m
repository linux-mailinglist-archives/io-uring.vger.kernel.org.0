Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E982A6E68BD
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 17:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbjDRP4s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 11:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjDRP4p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 11:56:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3CA9769
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 08:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681833354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bu2WXyCBFn70BrFOAHD2w7CCSZ5K+Kah1HWaszqXR7M=;
        b=GaGvzeK6fq3CKyeJZ42VIVrPfZRuOfKXl7yRj6NcyCZgDO0qUQGL5peeIjpAdKp5Ms96TX
        8R7h0505V+xeWAhC6U4S7/zooz3sHt/NJYm6yaHsWfM9uZAqxmDBzkB+52/X17/i4iNo+0
        zkHu0hqToYlym9ocKKOA3sLveY9gAdg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-_Nph-KYeOVmwoZD41Y9h2Q-1; Tue, 18 Apr 2023 11:55:51 -0400
X-MC-Unique: _Nph-KYeOVmwoZD41Y9h2Q-1
Received: by mail-wm1-f72.google.com with SMTP id j11-20020a05600c300b00b003f173ba3de6so2520698wmh.8
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 08:55:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681833350; x=1684425350;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bu2WXyCBFn70BrFOAHD2w7CCSZ5K+Kah1HWaszqXR7M=;
        b=QWLAZphWlAZmiYBkIqswf0MWCTpkXj/yyGyGKlV5xu5m+xMU/2tyd1pM6OpQq0aS1p
         Jr35KbJfJhOpqMqBLsjoVsZtJBcIyXPLZwLKXMTHcDgIKrhXn5ma+2dPE0E+kGQb5OA3
         V/M53pekQ5aBz8Bu3bRbz+nzosq62334YnwzR6MZV6VPDOKR9Ui9/W/yNoBbMXfMBiKF
         M1+agnqzDVapHSeLRNGljJnLn6yFkHT5xajNIuzxld6gl/bVm9e1WLxLj+uLPtc4npRZ
         J4W7NaSrXpnX73YOZQutvmtRxpcQXOeqleu/u73h1rD8hb3A1+NfmPUMScR3kxFNrVOm
         5Nbw==
X-Gm-Message-State: AAQBX9f0OEBCs+xl+xMVfttjSl19pD3a8qul/d5VMofHU0XQfxh/d8cB
        PKiu1QIGikb7JrOxISFe6cvKnnZkhFLMx7rvLDWFhMWsEHmAFINh0AM97UspE/pUevSK6ZaURnK
        BxhnZvFRYw0kIiEheBn0=
X-Received: by 2002:a7b:c7cb:0:b0:3f1:72e2:5d13 with SMTP id z11-20020a7bc7cb000000b003f172e25d13mr5852118wmk.16.1681833350225;
        Tue, 18 Apr 2023 08:55:50 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z1j/eqSrGsLGiAtdPfeIYhyQjZeuM76uEuc4151AByxVjGqnHN1YQGTPrOF+yr1m2bfY1Bnw==
X-Received: by 2002:a7b:c7cb:0:b0:3f1:72e2:5d13 with SMTP id z11-20020a7bc7cb000000b003f172e25d13mr5852102wmk.16.1681833349870;
        Tue, 18 Apr 2023 08:55:49 -0700 (PDT)
Received: from ?IPV6:2003:cb:c715:3f00:7545:deb6:f2f4:27ef? (p200300cbc7153f007545deb6f2f427ef.dip0.t-ipconnect.de. [2003:cb:c715:3f00:7545:deb6:f2f4:27ef])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003ee20b4b2dasm15205166wmc.46.2023.04.18.08.55.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 08:55:49 -0700 (PDT)
Message-ID: <7fabe6ee-ba8f-6c48-c9f7-90982e2e258c@redhat.com>
Date:   Tue, 18 Apr 2023 17:55:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18.04.23 17:49, Lorenzo Stoakes wrote:
> We are shortly to remove pin_user_pages(), and instead perform the required
> VMA checks ourselves. In most cases there will be a single VMA so this
> should caues no undue impact on an already slow path.
> 
> Doing this eliminates the one instance of vmas being used by
> pin_user_pages().
> 
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>   io_uring/rsrc.c | 55 ++++++++++++++++++++++++++++---------------------
>   1 file changed, 31 insertions(+), 24 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 7a43aed8e395..3a927df9d913 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1138,12 +1138,37 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
>   	return ret;
>   }
>   
> +static int check_vmas_locked(unsigned long addr, unsigned long len)

TBH, the whole "_locked" suffix is a bit confusing.

I was wondering why you'd want to check whether the VMAs are locked ...

> +{
> +	struct file *file;
> +	VMA_ITERATOR(vmi, current->mm, addr);
> +	struct vm_area_struct *vma = vma_next(&vmi);
> +	unsigned long end = addr + len;
> +
> +	if (WARN_ON_ONCE(!vma))
> +		return -EINVAL;
> +
> +	file = vma->vm_file;
> +	if (file && !is_file_hugepages(file))
> +		return -EOPNOTSUPP;

You'd now be rejecting vma_is_shmem() here, no?


-- 
Thanks,

David / dhildenb

