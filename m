Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E044DB35C
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 15:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbiCPOhK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 10:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiCPOhK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 10:37:10 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747D552E2C
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 07:35:56 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id r2so2526949iod.9
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 07:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eaff+ZDUoXqtqYBeMMWRXCXNeSj/5wDimU+/EYD5/Gk=;
        b=JThsvMwLIHIkGD1jdC/++Zj9xOlDlcjpnnA48h6EYeK4lmy7fjOLg99PtzOSpvprMC
         Xp0MVCYEn/cvEASmV8+QmHsLbXswKKiO8uwpl4Rm70ne1kWNpaNY5CYDZfZNvEQnrKQ3
         SViYIUUPuU2xyma9JdiZDqDjiuA/1ehgaVybZujWJna/wawr9Iu6+WhVqCq3c2SrijLi
         YQQ5etvqaKVc4jy/NVsz6B3bm2VZI+BXruhkLbHLpv4s2BsyoOgcdV8AIV/mjdWtS6Uo
         39MSbH3/oZndxpT9q42TjzuMcR5HGSnScrbCtmWj0GvAakZJyjzINPU5AGdjWWCJTSho
         yKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eaff+ZDUoXqtqYBeMMWRXCXNeSj/5wDimU+/EYD5/Gk=;
        b=2iiflpPJuMcWB7i4eijU76dW1fXcxlZBl21wpjljL2wmRn6MOisEox763JxfdJ9lm6
         okW11lgVBGcX+4nOpjyrj1gEaRPtaNLBT5zobPkopGtd9jFEvEVVsfHh6cPBpe4XG2d4
         mIhUjxd9LQHBX2k70rsFulTT/vEmXRGSZ2Z9n/GeuqAyDCZ7a/Vk6Nt3fI08KeawnRWS
         LfOtIPMAgZfCBxSSzIWJTjk5YAXj/PVJ043PZEV7FWOXGZS+Ah+XLc0BlJu10PpdgcZz
         k/rbuim54w/+7qzNYgfUBLXWAeG481YVyxtdoget8nAFpRsK8euUuMPOwep4JPMAXjzp
         oJqw==
X-Gm-Message-State: AOAM531X8SJvzgGH85MRjj3ZVKqdN1Oi7i1mv9/XX6/M52VBSaZtSKPu
        9Z8hgZmWm7XaHC0R6feKihtHBA==
X-Google-Smtp-Source: ABdhPJwQOXSKwhIW3xtIEqlzxJ3pNORPswTtyklm1l1o03V1DSh/93Z6RrmC6PwtXl3YEjBm/8ThUA==
X-Received: by 2002:a02:6a60:0:b0:315:4758:1be1 with SMTP id m32-20020a026a60000000b0031547581be1mr26549262jaf.316.1647441355684;
        Wed, 16 Mar 2022 07:35:55 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i18-20020a056e02055200b002c7b2ac7ba2sm1220084ils.26.2022.03.16.07.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 07:35:55 -0700 (PDT)
Message-ID: <666deb0e-fa10-8a39-c1aa-cf3908b3795c@kernel.dk>
Date:   Wed, 16 Mar 2022 08:35:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Content-Language: en-US
To:     Sagi Grimberg <sagi@grimberg.me>,
        Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com>
 <7a123895-1102-4b36-2d6e-1e00e978d03d@grimberg.me>
 <CA+1E3rK8wnABptQLQrEo8XRdsbua9t_88e3ZP-Ass3CnxHv+oA@mail.gmail.com>
 <8f45a761-5ecb-5911-1064-9625a285c93d@grimberg.me>
 <20220316092153.GA4885@test-zns>
 <11f9e933-cfc8-2e3b-c815-c49a4b7db4ec@grimberg.me>
 <CA+1E3r+_DEw5ABPbLzSp9Gvg6L8XU-2HBoLK7kuXucLjr=+Ezw@mail.gmail.com>
 <3ed01280-5487-7206-a326-0cd110118b65@grimberg.me>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3ed01280-5487-7206-a326-0cd110118b65@grimberg.me>
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

On 3/16/22 7:52 AM, Sagi Grimberg wrote:
> 
>>>>>>> No one cares that this has no multipathing capabilities what-so-ever?
>>>>>>> despite being issued on the mpath device node?
>>>>>>>
>>>>>>> I know we are not doing multipathing for userspace today, but this
>>>>>>> feels like an alternative I/O interface for nvme, seems a bit cripled
>>>>>>> with zero multipathing capabilities...
> 
> [...]
> 
>> Got it, thanks. Passthrough (sync or async) just returns the failure
>> to user-space if that fails.
>> No attempt to retry/requeue as the block path does.
> 
> I know, and that was my original question, no one cares that this
> interface completely lacks this capability? Maybe it is fine, but
> it is not a trivial assumption given that this is designed to be more
> than an interface to send admin/vs commands to the controller...

Most people don't really care about or use multipath, so it's not a
primary goal. For passthrough, most of request types should hit the
exact target, I would suggest that if someone cares about multipath for
specific commands, that they be flagged as such.

-- 
Jens Axboe

