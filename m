Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C164DB1E6
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 14:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354524AbiCPNyI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 09:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354231AbiCPNyG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 09:54:06 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63231A0;
        Wed, 16 Mar 2022 06:52:49 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id r10so3100398wrp.3;
        Wed, 16 Mar 2022 06:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g2JpBcc/NKpDAPZChPw+W7kZSZTO1SHhUlKPE+wqy+c=;
        b=cEXPzBe9iZJm8x8F+SKEPIItgducZEaCyqnlFWGGi4JXCBL+DbK0v8TIVJkyQTbSHr
         HeF+X1kqQ/buOojXUcMStApxgE+F8jeX3GOPgPLr3ginXS6UHTEd5sgIg+GAgDKRWQHc
         zcj8lZlWp1lUWjvfY3+/fbvtk/NZfnRIgBvopFhtVj/RXtCLwZJQyMnVhY92gRoj6BTL
         PANi75cNCM5Gypf2WoPzORTIs0YltItrKJRH3VBsQ5Bm7zLZe92ZBd8kS/hC5gI67srq
         lim8ZPZjTtOio7guPNKnWVf31y1szBgrTbDuck9pD9lJQCMtXGe/Xm4jL2Dk96JVVuet
         GrKg==
X-Gm-Message-State: AOAM533uIp5/ecF+RqP4hQ22fUyD2R4q28yuzsQCGKdDN3ZP2xKzvcMf
        eM+oPFkawDUA1RL35iZSJv8=
X-Google-Smtp-Source: ABdhPJwLwWzFdFkbUnONXVDVXs/3GZdMiKVABbSaSYh1u911dOx3621EujfQC+sGuf1CeLp19Qm79A==
X-Received: by 2002:a5d:55c5:0:b0:1f0:7672:637d with SMTP id i5-20020a5d55c5000000b001f07672637dmr101416wrw.170.1647438768337;
        Wed, 16 Mar 2022 06:52:48 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id e10-20020a056000178a00b0020393321552sm1921536wrg.85.2022.03.16.06.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 06:52:47 -0700 (PDT)
Message-ID: <3ed01280-5487-7206-a326-0cd110118b65@grimberg.me>
Date:   Wed, 16 Mar 2022 15:52:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
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
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <CA+1E3r+_DEw5ABPbLzSp9Gvg6L8XU-2HBoLK7kuXucLjr=+Ezw@mail.gmail.com>
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


>>>>>> No one cares that this has no multipathing capabilities what-so-ever?
>>>>>> despite being issued on the mpath device node?
>>>>>>
>>>>>> I know we are not doing multipathing for userspace today, but this
>>>>>> feels like an alternative I/O interface for nvme, seems a bit cripled
>>>>>> with zero multipathing capabilities...

[...]

> Got it, thanks. Passthrough (sync or async) just returns the failure
> to user-space if that fails.
> No attempt to retry/requeue as the block path does.

I know, and that was my original question, no one cares that this
interface completely lacks this capability? Maybe it is fine, but
it is not a trivial assumption given that this is designed to be more
than an interface to send admin/vs commands to the controller...
