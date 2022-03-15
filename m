Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683284D9702
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 10:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346337AbiCOJDs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Mar 2022 05:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346368AbiCOJDq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Mar 2022 05:03:46 -0400
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408284DF48;
        Tue, 15 Mar 2022 02:02:35 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id 7-20020a05600c228700b00385fd860f49so1077030wmf.0;
        Tue, 15 Mar 2022 02:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5GjeOUkjo80DozStTtPXhVzQRQej4Y2nGzurYGhi8tM=;
        b=X/t80WTaZ7reqZIYu737CU1WFjDhs3nJANEcRN+3TxzaImtCf/x0DzH93RbCMjpfEZ
         O4ZO4q354pqcl3FJmtdN/HvfX//RtNjMb7sA0ENgf8dWAmVMNPXLYk3ItKo2EYQv9rn1
         BzE3oidYMmWCX1QLtzfT2Seo86yMMX7VGJSBOrZB959ld+N63CHl4X79dnGL3WqHTicc
         RdwOEfhEf6YXsj00A53TjzFAJALd0pyS7zdUcK6KpniVOUC6TPXX/VWi2EUC95CEvGUf
         EF1Or09+6kHd7jPY4UKp+1WdkMtLzQXYaC8K9TRixHi/QNoVJ7mkekwT/1KQGOI9TBIW
         HlSw==
X-Gm-Message-State: AOAM533R97Izcg8DpdiMJk1IsEyCU/ZO0Xj0Cn5FY5700BSrkfzOiTmg
        QAH/5ooe1UDtniHT0Bc0Bj8=
X-Google-Smtp-Source: ABdhPJwWmkBm9T7IWXeFPmodjHRzLLkW+dwv0nCn/xwaXmyQoWXmh9laUOz1x8EayF3ghihBHG7gKA==
X-Received: by 2002:a05:600c:1c02:b0:389:cf43:da63 with SMTP id j2-20020a05600c1c0200b00389cf43da63mr2336863wms.205.1647334953730;
        Tue, 15 Mar 2022 02:02:33 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id bh19-20020a05600c3d1300b0038b481f357dsm1471479wmb.3.2022.03.15.02.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 02:02:33 -0700 (PDT)
Message-ID: <8f45a761-5ecb-5911-1064-9625a285c93d@grimberg.me>
Date:   Tue, 15 Mar 2022 11:02:30 +0200
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
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <CA+1E3rK8wnABptQLQrEo8XRdsbua9t_88e3ZP-Ass3CnxHv+oA@mail.gmail.com>
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


>>> +int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd)
>>> +{
>>> +     struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
>>> +     struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
>>> +     int srcu_idx = srcu_read_lock(&head->srcu);
>>> +     struct nvme_ns *ns = nvme_find_path(head);
>>> +     int ret = -EWOULDBLOCK;
>>> +
>>> +     if (ns)
>>> +             ret = nvme_ns_async_ioctl(ns, ioucmd);
>>> +     srcu_read_unlock(&head->srcu, srcu_idx);
>>> +     return ret;
>>> +}
>>
>> No one cares that this has no multipathing capabilities what-so-ever?
>> despite being issued on the mpath device node?
>>
>> I know we are not doing multipathing for userspace today, but this
>> feels like an alternative I/O interface for nvme, seems a bit cripled
>> with zero multipathing capabilities...
> 
> Multipathing is on the radar. Either in the first cut or in
> subsequent. Thanks for bringing this up.

Good to know...

> So the char-node (/dev/ngX) will be exposed to the host if we enable
> controller passthru on the target side. And then the host can send
> commands using uring-passthru in the same way.

Not sure I follow...

> May I know what are the other requirements here.

Again, not sure I follow... The fundamental capability is to
requeue/failover I/O if there is no I/O capable path available...

> Bit of a shame that I missed adding that in the LSF proposal, but it's
> correctible.

