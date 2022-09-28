Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2B75EE375
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 19:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbiI1Rtf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 13:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbiI1Rtd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 13:49:33 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871ACF6F55
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 10:49:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso3291596pjf.5
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 10:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=sbvQ8+O7Iu5pDsUhnetggBoxhwtGlOoUgDtHy9h5j3o=;
        b=ExvBbQ5KKBknu9xSg+qWbY/X1hG+kanpywR1B5ZpLcX5zZMnkusUvVsE2yTTNy5dS2
         KCUd9fpK0oJsxxdKmsquEDXqv/RqAl7gJrDyiBrtgLMVwNiZsMEao2uixWNVPMzCHm65
         FjlvXnxkvLI34FlfoH2qArhBK8IaqHYaS7EB7QuO85H5tr8wWWKsqASJDnhE6xwbZXiU
         UpdfLCo9hO90zqVeAVVQBS/NdcKO2uCxQUkreZpEvZySxDRIIeSU39dV/l3zbmWfI/eP
         Dg8uW0kll6L/k/5+b2dTO5ij+YIQRhM4MmSA5sl7+6opXvMDtTlilsugD3ft2z8W2Wha
         6gQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=sbvQ8+O7Iu5pDsUhnetggBoxhwtGlOoUgDtHy9h5j3o=;
        b=RkAW4FwhiVObzTGSicdnPGHk67XveoMNcoZJIUdwR3RprHMo5d85D1PoO2Q8hQTxBx
         a2+bBtWFWo/kmcQ8VMM5+qWLNQjnld33XG1u1JRSPUsXWgrrzVHg9zY3wozJPBTSx291
         BRJ5S9vj+iImm1RnXQOnLiqe9UsWedA84WNwemK/UWxMq6VYXhED/UVl9yV1828sMqvE
         dUw5YwTYBgEIc0OeGccGSFQ5G7LE3PF2qaY3sfUseExgeGgcRXXeX8A6iCzglC3Kl1j6
         54qsRPH6TKB5lJsKH2Woypx38hhI3ctu4/TU6b8QewxJXLcw6EzsIQ8ZJcI+ekoAzUjh
         cMNQ==
X-Gm-Message-State: ACrzQf2F70UuKGmfKvtVqhN5TBex2lqtfOpu6YIKbQCC25cZ4fzGUN+8
        xDVTqubjJ3emHTZHCQJskajFu5Fv3ph7wQ==
X-Google-Smtp-Source: AMsMyM6mVbp8UjUgd6Ua1oZ/TXcLqXeNHxfIUwGmNRJyCLGXI4Ip9GabzGAflN9Nblr0Z3b/p3hrUg==
X-Received: by 2002:a17:902:da81:b0:178:1d8b:6cb4 with SMTP id j1-20020a170902da8100b001781d8b6cb4mr948463plx.43.1664387369974;
        Wed, 28 Sep 2022 10:49:29 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f27-20020aa79d9b000000b0053e3ed14419sm4256392pfq.48.2022.09.28.10.49.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 10:49:29 -0700 (PDT)
Message-ID: <6ffd1719-e7c2-420f-1f9e-0b6d16540b46@kernel.dk>
Date:   Wed, 28 Sep 2022 11:49:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH for-next v10 5/7] block: factor out bio_map_get helper
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com
References: <20220927173610.7794-1-joshi.k@samsung.com>
 <CGME20220927174636epcas5p49008baa36dcbf2f61c25ba89c4707c0c@epcas5p4.samsung.com>
 <20220927173610.7794-6-joshi.k@samsung.com> <20220928173121.GC17153@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220928173121.GC17153@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/22 11:31 AM, Christoph Hellwig wrote:
> On Tue, Sep 27, 2022 at 11:06:08PM +0530, Kanchan Joshi wrote:
>> Move bio allocation logic from bio_map_user_iov to a new helper
>> bio_map_get. It is named so because functionality is opposite of what is
>> done inside bio_map_put. This is a prep patch.
> 
> I'm still not a fan of using bio_sets for passthrough and would be
> much happier if we could drill down what the problems with the
> slab per-cpu allocator are, but it seems like I've lost that fight
> against Jens..

I don't think there are necessarily big problems with the slab side,
it's just that the per-cpu freeing there needs to be IRQ safe. And the
double cmpxchg() used for that isn't that fast compared to being able
to cache these locally with just preempt protection.

>> +static struct bio *bio_map_get(struct request *rq, unsigned int nr_vecs,
>>  		gfp_t gfp_mask)
> 
> But these names just seems rather misleading.  Why not someting
> like blk_rq_map_bio_alloc and blk_mq_map_bio_put?
> 
> Not really new in this code but a question to Jens:  The existing
> bio_map_user_iov has no real upper bounds on the number of bios
> allocated, how does that fit with the very limited pool size of
> fs_bio_set?

Good question - I think we'd need to ensure that once we get
past the initial alloc that we clear any gfp flags that'd make
the mempool_alloc() wait for completions.

-- 
Jens Axboe


