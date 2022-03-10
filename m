Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB14D402B
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 05:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiCJEPY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 23:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiCJEPY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 23:15:24 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2077807B
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 20:14:24 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id k5-20020a17090a3cc500b001befa0d3102so5422389pjd.1
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 20:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=bwN/6GkoqDkfoY3yn2mLxmQRADUiBaQOC0CQ6Jfm2sg=;
        b=lbffrn88bN/WgA/WROGCMFDx40DeR7drEiGfA9Btf0I56bZlRGANVGsi5m31cGDJzn
         sZgkhIKmaxyRImRNnDeMu4TPUXWMBpsOWX+RawpyI2TQ3RFe4o+j6ag20BI3MGnHwBvk
         F7pdA9lO5Y1qAM/a62/gsAVQHMJvALDuH9pmwDQ1XLY0B2E2+Jg0DoUlZ0OY1wtbDBn9
         ZhquKdZ5CR606gjaP0xXIL5wyFRLj5ZnKL6x/JvLPFKefsrVubkUWcmiMqeaqf/8+qBm
         y3TJrGIbHbXBoM5+yOOOIg3SrYOWQXZq6KxIObObFqpdXxrCDcGfIjMZiw8wjkm2/6NV
         SJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=bwN/6GkoqDkfoY3yn2mLxmQRADUiBaQOC0CQ6Jfm2sg=;
        b=oZY1gNzL++nA+OHJDKRxIRKgHSO1D84O+U+1JzxxTm5Dpo1YG56NgWJlIXsTtPYf3V
         EpBEDLFNvxwisfq+Gr5YRBGGA6tK/oSyskIad3epaE6oUteL288bK9Cn3YJFbnlmo5MP
         cul2gnuUoLJh9NL+28CxzU46ydZgcv6uoJ0k91mtUzVkH8nwfoxBsHLxodfjfUcQnvlk
         oy546tWScCGlTv9EnBdCVpltflEc9uviX6cyZwR8mj2dpZtFLbisO27fssgYc1DgD3UW
         ZmpZOQEzpTxml0U6yKfQJJ78P8ZKx9zxK4FGQPVmsp7uLt8SALezN+fPkHKbnsv1S8c2
         TRhQ==
X-Gm-Message-State: AOAM531lg6kBWUQSBHE48cewl/skOuKmGfrXElm4+7EmUAf43amrquG0
        5XKxOEoLCyLYtv11PIUgKNbPS6k3jwgaU2yu
X-Google-Smtp-Source: ABdhPJw3jM5he8PwBcnhYhGC2HVDFSXBGUrb3o31xvIob8l71GMydvvoNBHVbj7yjhlWmpAtOZmscg==
X-Received: by 2002:a17:903:281:b0:14c:f3b3:209b with SMTP id j1-20020a170903028100b0014cf3b3209bmr2866047plr.87.1646885663425;
        Wed, 09 Mar 2022 20:14:23 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m79-20020a628c52000000b004f6f249d298sm4663219pfd.80.2022.03.09.20.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 20:14:22 -0800 (PST)
Message-ID: <f12c2f2b-858a-421c-d663-b944b2adb472@kernel.dk>
Date:   Wed, 9 Mar 2022 21:14:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
 <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
 <a13e9f56-0f1c-c934-9ca7-07ca8f82c6c8@gmail.com>
 <9f8c753d-fed4-08ac-7b39-aee23b8ba04c@kernel.dk>
In-Reply-To: <9f8c753d-fed4-08ac-7b39-aee23b8ba04c@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/22 9:03 PM, Jens Axboe wrote:
> I'll mull over this a bit...

One idea... You issue the request as you normally would for ring1, and
you mark that request A with IOSQE_CQE_SKIP_SUCCESS. Then you link an
IORING_OP_WAKEUP_RING to request A, with the fd for it set to ring2, and
also mark that with IOSQE_CQE_SKIP_SUCCESS.

We'd need to have sqe->addr (or whatever field) in the WAKEUP_RING
request be set to the user_data of request A, so we can propagate it.

The end result is that ring1 won't see any completions for request A or
the linked WAKEUP, unless one of them fails. If that happens, then you
get to process things locally still, but given that this is a weird
error case, shouldn't affect things in practice. ring2 will get the CQE
posted once request A has completed, with the user_data filled in from
request A. Which is really what we care about here, as far as I
understand.

This basically works right now with what I posted, and without needing
to rearchitect a bunch of stuff. And it's pretty efficient. Only thing
we'd need to add is passing in the target cqe user_data for the WAKEUP
request. Would just need to be wrapped in something that allows you to
do this easily, as it would be useful for others too potentially.

-- 
Jens Axboe

