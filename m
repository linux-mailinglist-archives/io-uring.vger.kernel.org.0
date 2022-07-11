Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86F3570998
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 19:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiGKRzw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 13:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiGKRzv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 13:55:51 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C00E7CB7B;
        Mon, 11 Jul 2022 10:55:49 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id d16so7987412wrv.10;
        Mon, 11 Jul 2022 10:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=txFXdouWdbSMaKn/caC2kD6TFZVlGEJSQ/STyjeuePM=;
        b=BxSHKxONkAubYXXEnjLsxUhliMo19FXENBf7GX8pzgiTrD39un4ucSB3FTgPlnvFMD
         x21E7V76RgBajKzKgWsK60YlRcdy4tHdbPYVuK2kToYD7pYkctPmeTCga3TCLesehC0I
         xBT7Rk7tJCphu///zn9wM3cC/hpNG08fBFH1j5Nee2hK3TA0J7SITG2y6VuJAMlll3l1
         DFkq2YDcXMJorLWbYhezdL/WMkCC0JwAgJOnUYkzMgVuIVphYDcbifmICIRgHUMYcABp
         yBGZnO1zjzbIfttpyA7MVr7tsVe6epV2FMYJWmJvf9vjpm+VdUKH/1E9SgPHIOepq2Dt
         6JBw==
X-Gm-Message-State: AJIora/FjRkhHOmAdA3v+cgEunIGBdm4go0Nz+YB4Gh0Lp+JKll3jL7P
        DMlXQz/KzmOStbzYao01yWk=
X-Google-Smtp-Source: AGRyM1sKxx1B26hTHr9NFnILGrSO5IkEVbBifXCrW4nydchvlUTDPmtgCkdme4W/ypt+B+OyHU0BLw==
X-Received: by 2002:adf:f946:0:b0:21d:6433:a7bb with SMTP id q6-20020adff946000000b0021d6433a7bbmr18582857wrr.518.1657562148165;
        Mon, 11 Jul 2022 10:55:48 -0700 (PDT)
Received: from [10.100.102.14] (46-117-125-14.bb.netvision.net.il. [46.117.125.14])
        by smtp.gmail.com with ESMTPSA id w2-20020adfde82000000b00213ba3384aesm6353066wrl.35.2022.07.11.10.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 10:55:47 -0700 (PDT)
Message-ID: <43955a42-7185-2afc-9a55-80cc2de53bf9@grimberg.me>
Date:   Mon, 11 Jul 2022 20:55:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 3/4] io_uring: grow a field in struct
 io_uring_cmd
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b@epcas5p2.samsung.com>
 <20220711110155.649153-4-joshi.k@samsung.com>
 <2b644543-9a54-c6c4-fd94-f2a64d0701fa@kernel.dk>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <2b644543-9a54-c6c4-fd94-f2a64d0701fa@kernel.dk>
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


>> Use the leftover space to carve 'next' field that enables linking of
>> io_uring_cmd structs. Also introduce a list head and few helpers.
>>
>> This is in preparation to support nvme-mulitpath, allowing multiple
>> uring passthrough commands to be queued.
> 
> It's not clear to me why we need linking at that level?

I think the attempt is to allow something like blk_steal_bios that
nvme leverages for io_uring_cmd(s).

nvme failover steals all the bios from requests that fail (and should
failover) and puts them on a requeue list, and then schedules
a work that takes these bios one-by-one and submits them on a different
bottom namespace (see nvme_failover_req/nvme_requeue_work).
