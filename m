Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52965366D0
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 20:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344784AbiE0SDL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 14:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiE0SDK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 14:03:10 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4E9EC335
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 11:03:09 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e3so5399028ios.6
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 11:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5ie/HR1hbmrS5lwYhUC7z0fo4VgdjvdRtjlnI9FabTU=;
        b=1QARBhEnh8b3XRNC0GhYrrqtp+kRckStM7wEQYL2JRN8poQjMhHuolDMKnoktdoGYx
         6ovcXHBgu/9TwEWbQxlrL24fP3XcOKliJmEf+G91ABYypc/D5xQLBE6vi9H7AGrovRgH
         /DCMolTUAJnalEaGd0x3DVTz6wvLKdWBZevFjWmeAerzTQfYg3AqUuzY5CvnnAcwXazy
         b05DZZ81cskjiN2PbZiFI7vKoDWkUGhGdquS5qxzpLJpauxwZUedN4WjSXsVvpjUIke8
         tOqdkd9KQtsg3iksDEgXK1ctaG6ahxmr4fyGGJVIM0eIQhnkUH4rn/FeH2AFRw9woHeC
         H4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5ie/HR1hbmrS5lwYhUC7z0fo4VgdjvdRtjlnI9FabTU=;
        b=EADqG6nq8L8DRfuK9Az1c/gnicLCPiqi1ifUZrpFP3bVfqfR9yfCN+j462iZHrxuEI
         cvM7XCNaDaPGh9adA1yxeHVW6f51c8je8yE0j/jMOBjysCiNJlS2bI/sS2r2XnjJ7jLU
         RCMiHE8IQ80sxFdmrJvd380VtBr8Tpr6XaqglmVOSom9HCuau5NoS9u3PEYldWNnQu6d
         34s8QRk+rmKg9FJTynK/g49s279rAEuk1+9AFCq6JK0FHZ6O+nbeyEiO8dzUs1m+FNli
         ZgR8wEwbptHrK57ifI7UEVaaYnHEHzjNuMHNbIYgN1zbt1MJyO21oE2kCUxkP5aVAZfB
         PzKA==
X-Gm-Message-State: AOAM533D6fjO9XJDplZErT2qih3cyLzHr/K5h2wfwjU3hMviyndzRT6o
        mNaNlYh+rT72SsaW3mSxAK8aGA==
X-Google-Smtp-Source: ABdhPJyUlBo8DclJOw5tA751BOhUh1uXqP3MgeOPAXKNqAOtg16cI08gn4UY9IILLuNExuDqUp0kzQ==
X-Received: by 2002:a05:6638:1409:b0:331:53:a88c with SMTP id k9-20020a056638140900b003310053a88cmr1165522jad.27.1653674588991;
        Fri, 27 May 2022 11:03:08 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x5-20020a056e021bc500b002cf846fe476sm1446297ilv.77.2022.05.27.11.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 11:03:08 -0700 (PDT)
Message-ID: <587a9737-9979-302e-4484-dfdbebe29d78@kernel.dk>
Date:   Fri, 27 May 2022 12:03:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2] io_uring: defer alloc_hint update to
 io_file_bitmap_set()
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <dce4572c-fecf-bb84-241e-2ea7b4093fef@kernel.dk>
 <20220527173914.50320-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220527173914.50320-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/22 11:39 AM, Xiaoguang Wang wrote:
> io_file_bitmap_get() returns a free bitmap slot, but if it isn't
> used later, such as io_queue_rsrc_removal() returns error, in this
> case, we should not update alloc_hint at all, which still should
> be considered as a valid candidate for next io_file_bitmap_get()
> calls.
> 
> To fix this issue, only update alloc_hint in io_file_bitmap_set().

Why are you changing the io_file_bitmap_set() type?


-- 
Jens Axboe

