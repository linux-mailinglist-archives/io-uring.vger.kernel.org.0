Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5855260CF9E
	for <lists+io-uring@lfdr.de>; Tue, 25 Oct 2022 16:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiJYOxo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Oct 2022 10:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiJYOxm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Oct 2022 10:53:42 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA2E19E91E;
        Tue, 25 Oct 2022 07:53:41 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5so506376wmo.1;
        Tue, 25 Oct 2022 07:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A+O8rQxYMCKxiugB25CpOR5TRiPSVHAXloU6ZW0+2ew=;
        b=pw2goslS3d3YvdLr34VC/tMBSPVNUxcfMFEACL/u5/FDOrUTKYELsEqTZ1Qhq0erDw
         lVNIxCUOtDALppjPpKhIfGd4z1rbvTz6uLvxvA6a+rYhWUThM5FWQ9mwQrOlVkOMHGGo
         jgzeAxkVSMPb+bNWd3lmlcWotCVStpokXeema2bhYB35NS9YAslYye/3PX3sZ2tvt0TO
         79A8JHvawHz2EWIn0b3oAWnVHWCkIRnKw6tTLMyOzVF9bKQ9g+de8NlO3qaPEMJTsCBh
         5Ibch6MjWdBOdr7mIZbusCjtZ2Oug6S46d3aXf/0HFxFoD5/geW4PaJ9a6vx7Yweggk/
         bkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A+O8rQxYMCKxiugB25CpOR5TRiPSVHAXloU6ZW0+2ew=;
        b=aDgtnsdAkaxadI7lYU4Hl1mSzQl5DXzI7bJ2gEPTdQ7YhdT5b/GNi8HskSVNa9ZnjP
         sNM65hiBLw+Q9hW8I+8RVacFE+kiiJxWkOXTvKJYgejwlc5nf4LzH5TyNvQAbCdnx3xd
         rVHlriqwDmfS/nvmMCWAxzAvM7S+Aj/1LZ/zMWLCeyy11sorsE+SDtQXckQmwmy7eof8
         umDpzmS9DGbvZpodJgxINhptkwpjhyZShqGpE7fZz4T5MrmuxS4yEIBsfJ+lX9MEW4G+
         DdBrlNlEDzPwNoq1pUPxvIwlGnjk12XvRPbbdToqPYaqb7epNJv62B5S6Y2AK/rCOFvH
         lSFQ==
X-Gm-Message-State: ACrzQf0lIS1yrkuFGMtFKqLHfrhObVomXNCYTGufSlSA8ptBhtCfceG+
        T2Z+fXMWZ0lVNZkVBcRpHh3Cj+ps6mdVWA==
X-Google-Smtp-Source: AMsMyM5KkaSWVGkgxvT1Hnc2uk6gGbPrMvIJsthGvrjpaVipp3s1NodJ4PrH3fMGk4iOew3wAt+RfQ==
X-Received: by 2002:a05:600c:4588:b0:3c6:f645:dad0 with SMTP id r8-20020a05600c458800b003c6f645dad0mr27572232wmo.114.1666709620462;
        Tue, 25 Oct 2022 07:53:40 -0700 (PDT)
Received: from [10.1.2.99] (wifi-guest-gw.tecnico.ulisboa.pt. [193.136.152.65])
        by smtp.gmail.com with ESMTPSA id e17-20020a5d5011000000b002305cfb9f3dsm2724433wrt.89.2022.10.25.07.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 07:53:40 -0700 (PDT)
Message-ID: <25567965-4eb5-7557-db49-e17776cec3d4@gmail.com>
Date:   Tue, 25 Oct 2022 15:51:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-next v3 0/3] implement pcpu bio caching for IRQ I/O
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
References: <CGME20221021103627epcas5p34eaaf3c8161bbee33160cce8b58efd5f@epcas5p3.samsung.com>
 <cover.1666347703.git.asml.silence@gmail.com>
 <20221025132502.GA31530@test-zns>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221025132502.GA31530@test-zns>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/25/22 14:25, Kanchan Joshi wrote:
> On Fri, Oct 21, 2022 at 11:34:04AM +0100, Pavel Begunkov wrote:
>> Add bio pcpu caching for normal / IRQ-driven I/O extending REQ_ALLOC_CACHE,
>> which was limited to iopoll. 
> 
> So below comment (stating process context as MUST) can also be removed as
> part of this series now?

Right, good point


> 495  * If REQ_ALLOC_CACHE is set, the final put of the bio MUST be done from process
> 496  * context, not hard/soft IRQ.
> 497  *
> 498  * Returns: Pointer to new bio on success, NULL on failure.
> 499  */
> 500 struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
> 501                              blk_opf_t opf, gfp_t gfp_mask,
> 502                              struct bio_set *bs)
> 503 {
[...]
>> The next step will be turning it on for other users, hopefully by default.
>> The only restriction we currently have is that the allocations can't be
>> done from non-irq context and so needs auditing.
> 
> Isn't allocation (of bio) happening in non-irq context already?

That's my assumption, true for most of them, but I need to actually
check that. Will be following up after this series is merged.


> Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

thanks

-- 
Pavel Begunkov
