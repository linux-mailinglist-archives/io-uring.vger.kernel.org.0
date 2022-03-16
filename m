Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF154DAE87
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 11:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbiCPK6N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 06:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiCPK6M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 06:58:12 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E3F4615D;
        Wed, 16 Mar 2022 03:56:57 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id u16so1378972wru.4;
        Wed, 16 Mar 2022 03:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q/MkkdjXJWSKC5Rmk0bMMUh8KfXqf5PAK+ZeE9+76LA=;
        b=I89F4E4Vj9NLy3fm8yLmhgtBWaETzl2Ry1CCxMy43gehb/G6zp61TkgBKcavxyvGrl
         T6F5Ja/ygg/bFmb21SqZQwJbe0H12ym1EleGZ82PWbANN82FpNmqkfje9L6WJ3jnSCzb
         6cWmIzF5/zzkoySz8UBLRJhBihFUkBufrhOTNpt7XGdQeX5MISmi8tv+3XGPSkqjc3IT
         PpvrK1jlMK59f5YH2qp9utpN1jgzx3T7ecEQZXktbxzyNiUF9q5NtMmrFLzD4/0Ng6+e
         26aTCTx69U2viRLq+JyYDmw3qIiAu4K3162O5AEbas42f2ZfnWaKhM9Z8C3Sp6FMAFa8
         5/CQ==
X-Gm-Message-State: AOAM531anizoJjcHJfWrzDNh34Zg7D4pccbxERNS7EJJs6XAe+auF16g
        etOQRnl0TYyv0GIUpuIsuZUoWMdhO9c=
X-Google-Smtp-Source: ABdhPJz5JhnwaM3HpruKQYMhDVu991m3UztXZds21mGMAceECiK5QO/Y790DF91u+W0Ge9xBchwZmw==
X-Received: by 2002:a05:6000:154b:b0:203:7564:930 with SMTP id 11-20020a056000154b00b0020375640930mr23897520wry.349.1647428215985;
        Wed, 16 Mar 2022 03:56:55 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id n2-20020a056000170200b001f1e16f3c53sm1364822wrc.51.2022.03.16.03.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 03:56:55 -0700 (PDT)
Message-ID: <11f9e933-cfc8-2e3b-c815-c49a4b7db4ec@grimberg.me>
Date:   Wed, 16 Mar 2022 12:56:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>,
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
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220316092153.GA4885@test-zns>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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



On 3/16/22 11:21, Kanchan Joshi wrote:
> On Tue, Mar 15, 2022 at 11:02:30AM +0200, Sagi Grimberg wrote:
>>
>>>>> +int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd)
>>>>> +{
>>>>> +     struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
>>>>> +     struct nvme_ns_head *head = container_of(cdev, struct 
>>>>> nvme_ns_head, cdev);
>>>>> +     int srcu_idx = srcu_read_lock(&head->srcu);
>>>>> +     struct nvme_ns *ns = nvme_find_path(head);
>>>>> +     int ret = -EWOULDBLOCK;
>>>>> +
>>>>> +     if (ns)
>>>>> +             ret = nvme_ns_async_ioctl(ns, ioucmd);
>>>>> +     srcu_read_unlock(&head->srcu, srcu_idx);
>>>>> +     return ret;
>>>>> +}
>>>>
>>>> No one cares that this has no multipathing capabilities what-so-ever?
>>>> despite being issued on the mpath device node?
>>>>
>>>> I know we are not doing multipathing for userspace today, but this
>>>> feels like an alternative I/O interface for nvme, seems a bit cripled
>>>> with zero multipathing capabilities...
>>>
>>> Multipathing is on the radar. Either in the first cut or in
>>> subsequent. Thanks for bringing this up.
>>
>> Good to know...
>>
>>> So the char-node (/dev/ngX) will be exposed to the host if we enable
>>> controller passthru on the target side. And then the host can send
>>> commands using uring-passthru in the same way.
>>
>> Not sure I follow...
> 
> Doing this on target side:
> echo -n /dev/nvme0 > 
> /sys/kernel/config/nvmet/subsystems/testnqn/passthru/device_path
> echo 1 > /sys/kernel/config/nvmet/subsystems/testnqn/passthru/enable

Cool, what does that have to do with what I asked?

>>> May I know what are the other requirements here.
>>
>> Again, not sure I follow... The fundamental capability is to
>> requeue/failover I/O if there is no I/O capable path available...
> 
> That is covered I think, with nvme_find_path() at places including the
> one you highlighted above.

No it isn't. nvme_find_path is a simple function that retrieves an I/O
capable path which is not guaranteed to exist, it has nothing to do with
I/O requeue/failover.

Please see nvme_ns_head_submit_bio, nvme_failover_req,
nvme_requeue_work.
