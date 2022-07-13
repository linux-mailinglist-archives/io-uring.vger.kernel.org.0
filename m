Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B1B57362D
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 14:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbiGMMQn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 08:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiGMMQl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 08:16:41 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9329B9C5;
        Wed, 13 Jul 2022 05:16:40 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id z23-20020a7bc7d7000000b003a2e00222acso2166712wmk.0;
        Wed, 13 Jul 2022 05:16:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n8eCyagKJD1192UPqzMB5meP50tseHK9E50B0X3PFRQ=;
        b=WMMLoK9S6OvvxNbGOE1bdPMAe0e1aHWAbPab0Xiw9YdWF44KWRdury4RaxPWW2WQJP
         62pKOs1VYQqiaKhnPVAVxhfIeDTh6eq++nXhEL0ZZ0QiYjaZ9MHK3SOiQvCrTq3i1XlV
         V8du+i01wrqjLowaxwHxP7TtNYjyynOCdjEIWpn0CU0LuUrzDhEaKkX+oqOv0yyvPw3N
         tEYOs/G0WRW1xr0jH9ocOVDOQt90Hi6be45ajyxx0YoW6ClQoi62QW/4J7cFP00rVRgf
         +mDUtmshQICzICb0Zaq9ZfPzZnLx+DZU08yoXPtzPmtjHgxlEumrp7JzAi32yEu0ZlyL
         7M2g==
X-Gm-Message-State: AJIora9dJgG1tQ83N3E5EUxs+An5+jUQCQpHUD2QwegZR5t1tcppWzKX
        XCPaY3tSibTRWM2sdlIujQyl0vvloC0=
X-Google-Smtp-Source: AGRyM1t6s7YUfAjYHssbxL+0aWhZ1r/560DGbYAjEbsPRdwzdBPLYGVoGLXh+VfJcYUYUWP8wxYpVQ==
X-Received: by 2002:a05:600c:1c18:b0:3a2:e193:2bda with SMTP id j24-20020a05600c1c1800b003a2e1932bdamr3256228wms.2.1657714599185;
        Wed, 13 Jul 2022 05:16:39 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id q6-20020a1cf306000000b003a2e92edeccsm1986453wmq.46.2022.07.13.05.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 05:16:38 -0700 (PDT)
Message-ID: <156ed583-5150-d823-437a-de5b9ffcda99@grimberg.me>
Date:   Wed, 13 Jul 2022 15:16:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
 <20220711110155.649153-5-joshi.k@samsung.com> <20220712065250.GA6574@lst.de>
 <436c8875-5a99-4328-80ac-6a5aef7f16f4@grimberg.me>
 <20220713053633.GA13135@lst.de>
 <24f0a3e6-aa53-8c69-71b7-d66289a63eae@grimberg.me>
 <20220713101235.GA27815@lst.de>
 <772b461a-bc43-c229-906d-0e280091e17f@grimberg.me>
 <20220713112845.GA780@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220713112845.GA780@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>> I view uring passthru somewhat as a different thing than sending SG_IO
>> ioctls to dm-mpath. But it can be argued otherwise.
>>
>> BTW, the only consumer of it that I'm aware of commented that he
>> expects dm-mpath to retry SG_IO when dm-mpath retry for SG_IO submission
>> was attempted (https://www.spinics.net/lists/dm-devel/msg46924.html).
> 
> Yeah.  But the point is that if we have a path failure, the kernel
> will pick a new path next time anyway, both in dm-mpath and nvme-mpath.

If such a path is available at all.

>> I still think that there is a problem with the existing semantics for
>> passthru requests over mpath device nodes.
>>
>> Again, I think it will actually be cleaner not to expose passthru
>> devices for mpath at all if we are not going to support retry/failover.
> 
> I think they are very useful here.  Users of passthrough interface
> need to be able to retry anyway, even on non-multipath setups.  And
> a dumb retry will do the right thing.

I think you are painting a simple picture while this is not the case
necessarily. It is not a dumb retry, because the user needs to determine
if an available path for this particular namespace exists or wait for
one if it doesn't want to do a submit/fail constant loop.

A passthru interface does not mean that the user by definition needs to
understand multipathing, ana/ctrl/ns states/mappings, etc. The user may
just want to be able issue vendor-specific commands to the device.

If the user needs to understand multipathing by definition, he/she has
zero use of a mpath passthru device if it doesn't retry IMO.
