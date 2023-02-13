Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D966951CD
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 21:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjBMUZG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 15:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjBMUZB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 15:25:01 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B304498;
        Mon, 13 Feb 2023 12:24:56 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id f16-20020a17090a9b1000b0023058bbd7b2so13426822pjp.0;
        Mon, 13 Feb 2023 12:24:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jeoNHRdTi75bvN7yIK3qjR8vRNZkI9OKUG3gsroE1Cs=;
        b=hkb8X/KKUQWDyAtgfI6n53B503K0lTcuG+H2qWInkGzWs0p5pn9seTKLSLI4ich8Ac
         wEleidfsl0o+jsfD7TGbOaf3PHj6PekXkQgf8CCOwWCATP7mvKD1kPDGgZUiP1r4ClJF
         9pTGdZa5kCUtgAEoGgkZDUaAYOOIFZjLlSZ4CYud74OicCGXqjpodnn0eRvX2vm0TQZM
         hpqOYFfTO4VmWnTekv3oFtnUKP66Y5eGBKjS9YHT7/yDo6+WQ1J24T4y+/UaqDttLZGS
         EK0r2f1UlD1maOeI1FnZvm6a+6SzDvyNG5FqgoFv+SigvnOWXVAEneu9pEMJvfnJhrfx
         i9cw==
X-Gm-Message-State: AO0yUKUElpQ3mWeF2cjvqhD87xe++IfneStUCDSq/SIGIkO3BSGEEE3y
        CbX71BWXlP2kYnzrheQQJrM=
X-Google-Smtp-Source: AK7set8spO+RK9kUMn3B8mnPoUYkvSz0i20QutEqmbE0WX0LAzgs+gTQ6F8WD1wPrvXw2DamckMIhA==
X-Received: by 2002:a17:903:32c6:b0:19a:9686:ea87 with SMTP id i6-20020a17090332c600b0019a9686ea87mr115904plr.55.1676319895980;
        Mon, 13 Feb 2023 12:24:55 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:dc5c:7c61:93f2:3d3d? ([2620:15c:211:201:dc5c:7c61:93f2:3d3d])
        by smtp.gmail.com with ESMTPSA id c3-20020a170902d48300b0018544ad1e8esm8663247plg.238.2023.02.13.12.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 12:24:54 -0800 (PST)
Message-ID: <d69f0203-2eff-e2c2-0a6c-ed341bdb1896@acm.org>
Date:   Mon, 13 Feb 2023 12:24:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, ming.lei@redhat.com
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com>
 <69443f85-5e16-e3db-23e9-caf915881c92@acm.org> <20230210193459.GA9184@green5>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230210193459.GA9184@green5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 11:34, Kanchan Joshi wrote:
> On Fri, Feb 10, 2023 at 10:18:08AM -0800, Bart Van Assche wrote:
>> On 2/10/23 10:00, Kanchan Joshi wrote:
>>> 3. DMA cost: is high in presence of IOMMU. Keith posted the work[1],
>>> with block IO path, last year. I imagine plumbing to get a bit simpler
>>> with passthrough-only support. But what are the other things that must
>>> be sorted out to have progress on moving DMA cost out of the fast path?
>>
>> Are performance numbers available?
> 
> Around 55% decline when I checked last (6.1-rcX kernel).
> 512b randread IOPS with optane, on AMD ryzen 9 box -
> when iommu is set to lazy (default config)= 3.1M
> when iommmu is disabled or in passthrough mode = 4.9M

Hi Kanchan,

Thank you for having shared these numbers. More information would be 
welcome, e.g. the latency impact on a QD=1 test of the IOMMU, the queue 
depth of the test results mentioned above and also how much additional 
CPU time is needed with the IOMMU enabled. I'm wondering whether the 
IOMMU cost is dominated by the IOMMU hardware or by software bottlenecks 
(e.g. spinlocks).

Thanks,

Bart.

