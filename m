Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0774DB3B1
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 15:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiCPOwL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 10:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbiCPOwK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 10:52:10 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45A35F4C6;
        Wed, 16 Mar 2022 07:50:56 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id x15so3286264wru.13;
        Wed, 16 Mar 2022 07:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bI4ZhjQL8dIuJvz21TfUD5JbGeAx7Qdq2Uugzf6XgB0=;
        b=T8eaUq22SmrqQEkehJYK1KwHHKCraiQH+4hHcqgNBQs+Scx79ozCBs1JN48AnC9eP1
         5EUEn4qjPWOW2TbrGeYkC2iLd0GC6DDMqbvmjsWZnf3XbKjH4Luhifn4MOmifOlTfCWR
         nu7xZ4PzuwCbBITZUatpCMQA/OdZMGPyTZSbip6YaX7d9Q6Dr8fG433rs7yAS1B31FF7
         mflix6gZ/mx7PVKzRv76SOvWLGJBCT09PPCaLwIqvxFjQYSzlPS2I0dGL6u6jCHLj20b
         36K3MSO1TOnq5ci4kDV8DMTPYs3I/5QsdLcVr+dKc9DA3jWLIKuOi4zYvGxlGLWPjAyM
         I80g==
X-Gm-Message-State: AOAM533EY5CgNqtUTieYVFhwclZbpMGUF4U7O54hDoSm6lirKT40g63Y
        i84O2P/Wwrm6e8rb6mlRS38=
X-Google-Smtp-Source: ABdhPJzrRH5zBsn9fYkNcZjd08EnDBOCdVlS4Q3hFeb7W2Pq1bG2CpbUzWEW5D36WNgcL+UcKvbCng==
X-Received: by 2002:a5d:6c6b:0:b0:1ea:77ea:dde8 with SMTP id r11-20020a5d6c6b000000b001ea77eadde8mr271610wrz.690.1647442255234;
        Wed, 16 Mar 2022 07:50:55 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm513959wmq.40.2022.03.16.07.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 07:50:54 -0700 (PDT)
Message-ID: <28b53100-9930-92d4-ba3b-f9c5e8773808@grimberg.me>
Date:   Wed, 16 Mar 2022 16:50:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshiiitr@gmail.com>
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
 <666deb0e-fa10-8a39-c1aa-cf3908b3795c@kernel.dk>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <666deb0e-fa10-8a39-c1aa-cf3908b3795c@kernel.dk>
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


>> [...]
>>
>>> Got it, thanks. Passthrough (sync or async) just returns the failure
>>> to user-space if that fails.
>>> No attempt to retry/requeue as the block path does.
>>
>> I know, and that was my original question, no one cares that this
>> interface completely lacks this capability? Maybe it is fine, but
>> it is not a trivial assumption given that this is designed to be more
>> than an interface to send admin/vs commands to the controller...
> 
> Most people don't really care about or use multipath, so it's not a
> primary goal.

This statement is generally correct. However what application would be 
interested in speaking raw nvme to a device and gaining performance that
is even higher than the block layer (which is great to begin with)?

First thing that comes to mind is a high-end storage array, where
dual-ported drives are considered to be the standard. I could argue the
same for a high-end oracle appliance or something like that... Although
in a lot of cases, each nvme port will connect to a different host...

What are the use-cases that need this interface that are the target
here? Don't remember seeing this come up in the cover-letter or previous
iterations...

> For passthrough, most of request types should hit the
> exact target, I would suggest that if someone cares about multipath for
> specific commands, that they be flagged as such.
What do you mean by "they be flagged as such"?
