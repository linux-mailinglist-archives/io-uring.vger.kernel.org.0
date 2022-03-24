Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7A74E61E2
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 11:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349562AbiCXKoV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 06:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349559AbiCXKoT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 06:44:19 -0400
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5243AA146F;
        Thu, 24 Mar 2022 03:42:47 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id yy13so8302394ejb.2;
        Thu, 24 Mar 2022 03:42:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z+tOhomyyHuPVoCuADsMsVAjnchfBPFbDYj/vr6ULFk=;
        b=mV3bfzolQVC2jlxhUiJy06qFMco1LBQp2MWBzh+H/gm+zVPNYDjkalyOwMXvJsihuS
         jMxwuMYBOfnekr1dNnNI2wvEeNurRqnZK5qTLWA0KMSuvw5P12ny5N4uOc+7NzgmwCac
         SBiN+we2cwKiEZzzb1U5GBqAQGHu7M213R58uZgqJyuTNqRsn7G6f61We5J5KYm74iI8
         ROipGr7beoUR0p0mS+qR1OkO+b2vbikVVGAKQFveLxA2TgvI9F/DbZ0/NSi5/W6rX7zP
         IzC1XfRgKWhFHTKHQcUoPdWd/Z4g8VDDhtkO6skGQEWyVU0vBUA69d7AsGKNu8Rp/JK2
         SXDg==
X-Gm-Message-State: AOAM531F7N0rHnNzF6dEQCNP3WI7gXJiO1/SnD6W7r2Xqr/ZuWWr2O5O
        BqXIyCd/MEA0m8RPQQ6+5AM=
X-Google-Smtp-Source: ABdhPJwIdokZm/Y/j1GkNTRNcR1YxV/an65AItscWscYJKvj1/Qq6h7xM55DmHKiD8wf1owr5GZbZg==
X-Received: by 2002:a17:906:6547:b0:6bd:e2ad:8c82 with SMTP id u7-20020a170906654700b006bde2ad8c82mr4794402ejn.693.1648118565765;
        Thu, 24 Mar 2022 03:42:45 -0700 (PDT)
Received: from [10.100.102.14] (85.65.206.129.dynamic.barak-online.net. [85.65.206.129])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709060cc200b006d3d91e88c7sm959117ejh.214.2022.03.24.03.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 03:42:44 -0700 (PDT)
Message-ID: <88827a86-1304-e699-ec11-2718e280f9ad@grimberg.me>
Date:   Thu, 24 Mar 2022 12:42:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshiiitr@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220308152105.309618-6-joshi.k@samsung.com>
 <7a123895-1102-4b36-2d6e-1e00e978d03d@grimberg.me>
 <CA+1E3rK8wnABptQLQrEo8XRdsbua9t_88e3ZP-Ass3CnxHv+oA@mail.gmail.com>
 <8f45a761-5ecb-5911-1064-9625a285c93d@grimberg.me>
 <20220316092153.GA4885@test-zns>
 <11f9e933-cfc8-2e3b-c815-c49a4b7db4ec@grimberg.me>
 <CA+1E3r+_DEw5ABPbLzSp9Gvg6L8XU-2HBoLK7kuXucLjr=+Ezw@mail.gmail.com>
 <3ed01280-5487-7206-a326-0cd110118b65@grimberg.me>
 <666deb0e-fa10-8a39-c1aa-cf3908b3795c@kernel.dk>
 <28b53100-9930-92d4-ba3b-f9c5e8773808@grimberg.me>
 <20220324062053.GA12519@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220324062053.GA12519@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>>>> I know, and that was my original question, no one cares that this
>>>> interface completely lacks this capability? Maybe it is fine, but
>>>> it is not a trivial assumption given that this is designed to be more
>>>> than an interface to send admin/vs commands to the controller...
>>>
>>> Most people don't really care about or use multipath, so it's not a
>>> primary goal.
>>
>> This statement is generally correct. However what application would be
>> interested in speaking raw nvme to a device and gaining performance that
>> is even higher than the block layer (which is great to begin with)?
> 
> If passthrough is faster than the block I/O path we're doing someting
> wrong.  At best it should be the same performance.

That is not what the changelog says.

> That being said multipathing is an integral part of the nvme driver
> architecture, and the /dev/ngX devices.  If we want to support uring
> async commands on /dev/ngX it will have to support multipath.

Couldn't agree more...
