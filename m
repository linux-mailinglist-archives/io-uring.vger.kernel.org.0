Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAEB5EE39C
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 19:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbiI1Ryv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 13:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbiI1Ryc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 13:54:32 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BAEFAD80
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 10:53:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 9so13142360pfz.12
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 10:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=g5BzfU1Ctin05aGCszFYs/HZPFJIFqu4VCfUEaRWslY=;
        b=IshhxIUEVKUCgXM5zkpHJwazY5WYQlr72ei1K5sG5UzdsZVkpfEW2Mw+iZ9kiOCOE/
         gdKjiMVPLD2m+N52gToWtxVgV/AGbU8rh8aX3jGhXRQC1g1yZ0SK0QVzs1T8x47oZmxW
         RXRzgvB3myoFJztcU4PbIcMySGXWG0nwzqHkx4qkx8TiQMELbss4qLIC0lByyf+N2s9q
         MNrdhM9rWgnHVko/RkDKsbQMWBVSVyk+9ZiB65Mm0Sbr98mBZjD23Gnc2qKafznwjRA0
         wmzWJUgy0SE0JxKy5ScBEvz+srBNhKq/qr/dGl92x2SVAbssA8wMUlLB+XxiLdzSLd/h
         8Dkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=g5BzfU1Ctin05aGCszFYs/HZPFJIFqu4VCfUEaRWslY=;
        b=sSfAW/LDDlv7n6+Hj7jOjls/tsGfD7j/fVfmo+UsCg5ZH7JVXi2rq1BZVVxz1xmIDL
         KsUjJ0g2z+FWMqRzvQY5Eiu5tc12twsuQ2gKkFhvZbvdDVmOmMqRlYrwv6mdK6z+CgIZ
         rTvxTraSK08USGMc/qTukb5/cpI/3rxs9lSC/Jjn9dRynAzpVGapUZTv2mMOsvqchxLp
         HSw3IoZz0suFbXk1P++Wgl4iD1bhi53GUnRxenEL0kEgLMll0t2GWjsBJuNEUPpxEl0h
         j8xjz1vDqomy00iNE2nm2MC+2KAbq1K2XPBDl2q4w/udvpG2yAgv+z0lVOZ9r7r9ezzw
         /5ew==
X-Gm-Message-State: ACrzQf0rboTSbnvFaSBOtet/moqHM5l8kuDax7Om4hd1222E9tBU6uQW
        Bca4X2LyZ4h+EzXivxR9VJn0tQ==
X-Google-Smtp-Source: AMsMyM5TNVPcFsDxIqgpdI3sm1ULmxd+i3nI72g5FVi49MX4X80NFGYlg9gXNWAdjgnvJJqiUpfFOA==
X-Received: by 2002:a63:1f12:0:b0:438:fa5b:ff76 with SMTP id f18-20020a631f12000000b00438fa5bff76mr30448629pgf.390.1664387639098;
        Wed, 28 Sep 2022 10:53:59 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a12-20020a170902eccc00b0015e8d4eb219sm4131010plh.99.2022.09.28.10.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 10:53:58 -0700 (PDT)
Message-ID: <40eb2cae-ea17-e1f8-c2f0-2d747ba05c91@kernel.dk>
Date:   Wed, 28 Sep 2022 11:53:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH for-next v10 5/7] block: factor out bio_map_get helper
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com
References: <20220927173610.7794-1-joshi.k@samsung.com>
 <CGME20220927174636epcas5p49008baa36dcbf2f61c25ba89c4707c0c@epcas5p4.samsung.com>
 <20220927173610.7794-6-joshi.k@samsung.com> <20220928173121.GC17153@lst.de>
 <6ffd1719-e7c2-420f-1f9e-0b6d16540b46@kernel.dk>
In-Reply-To: <6ffd1719-e7c2-420f-1f9e-0b6d16540b46@kernel.dk>
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

On 9/28/22 11:49 AM, Jens Axboe wrote:
>> Not really new in this code but a question to Jens:  The existing
>> bio_map_user_iov has no real upper bounds on the number of bios
>> allocated, how does that fit with the very limited pool size of
>> fs_bio_set?
> 
> Good question - I think we'd need to ensure that once we get
> past the initial alloc that we clear any gfp flags that'd make
> the mempool_alloc() wait for completions.

Either that, or just have the passthrough code use non-waiting flags to
begin with. Not guaranteeing forward progress is a bit iffy though...
But in practice it'd be no different than getting a failure due to OOM
because the application submitted a big request and we needed to alloc
and map multiple bios.

-- 
Jens Axboe
