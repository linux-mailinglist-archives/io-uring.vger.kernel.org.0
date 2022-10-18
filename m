Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAC6603364
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJRTfL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 15:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiJRTfK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:35:10 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED35727912;
        Tue, 18 Oct 2022 12:35:08 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g27so22019667edf.11;
        Tue, 18 Oct 2022 12:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MEQQitYjZbXJANs1RoNeTAqxiMmroK05libS5bTqvrM=;
        b=TJzasUE+7XDdqHpODudt3fj6P+0tKD8DDMWv0VxudtiYJJ2BkfW3a6bW3SaS1pMmm/
         yTiJE1PsdoxcsYWHPdmWiHt6lBejV/ngHqWbk2rDW6msyzxEorIbdCG/jW4EuYc4cSZr
         uQuobg8AR2IdelBxzmvz813y9TsH2OCmNmDdtpc61MCdY+CPp1w3e55qsXDbHhE5Ey3w
         Hqy0Jy4wyMUjure6VzAxBREpMIn1q2g+dbPk2d936iAk+Nu+Gkr/S74Oc9n5KmzQFfFy
         5025/ZO/MB2nbLdwFtKPt8TXNBAtZU4A5w61PItwUnTRY7DucFccuM2OU/VtMji9cp8D
         WO4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEQQitYjZbXJANs1RoNeTAqxiMmroK05libS5bTqvrM=;
        b=Z6s/9ypnjIkNHCjDuJKE5u+XoCBtGrdqRKucXq13g6quGGVl2fxH6P7sePu8jWb6aC
         qcq/axjE7+gSdr0ZjCoOoQ9Kr7olePmsRcgt3ikWjihpZ6Cnb7b+nayokDEm/4sh7edL
         QHSWDIkmEWB+UmKMsTbhVuH3/LsfI7EhKPoB7P+HFrF8yAcBqu/iIzQyyplReD1wMIuM
         4kmB/nb8qYu9K+o1AbjLyt7sy9yeVEx9Zos0jdoOBgBlNL0WVWjRi+bdmKYwt6LDPRZZ
         Cb5x+PgHtTs8ViTNCn3NjaFBdwuLapD+HWQbWKNQD14aSi/aIJlGuOLwmsanw915HXl6
         vltQ==
X-Gm-Message-State: ACrzQf2Hv1/CvR0Cm5d4QqMnb1fgw9sGxP5VBBDpLWg9LVd/9qEYslGY
        1f3EY5N36Gh3CH1BVy9fimAVM+eqkuI=
X-Google-Smtp-Source: AMsMyM7h+SUBLedOYfsL7w7vWlAu8tjqt8DlKZke2cYAMbdZAWvCaOPqZVV9lSh+zp5K3iqPTBfEQQ==
X-Received: by 2002:aa7:d7c5:0:b0:459:fad8:fd2 with SMTP id e5-20020aa7d7c5000000b00459fad80fd2mr4117207eds.336.1666121707476;
        Tue, 18 Oct 2022 12:35:07 -0700 (PDT)
Received: from [192.168.8.100] (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id fd13-20020a056402388d00b0045b3853c4b7sm9309479edb.51.2022.10.18.12.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 12:35:07 -0700 (PDT)
Message-ID: <9c92c1fa-1a67-1fb1-0cc6-c65c708db01e@gmail.com>
Date:   Tue, 18 Oct 2022 20:33:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [RFC for-next 0/4] enable pcpu bio caching for IRQ I/O
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <cover.1666114003.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1666114003.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/22 19:47, Pavel Begunkov wrote:
> This series implements bio pcpu caching for normal / IRQ-driven I/O
> extending REQ_ALLOC_CACHE currently limited to iopoll. The allocation side
> still only works from non-irq context, which is the reason it's not enabled
> by default, but turning it on for other users (e.g. filesystems) is
> as a matter of passing a flag.

Ooops, wrong version, will resend


> t/io_uring with an Optane SSD setup showed +7% for batches of 32 requests
> and +4.3% for batches of 8.
> 
> IRQ, 128/32/32, cache off
> IOPS=59.08M, BW=28.84GiB/s, IOS/call=31/31
> IOPS=59.30M, BW=28.96GiB/s, IOS/call=32/32
> IOPS=59.97M, BW=29.28GiB/s, IOS/call=31/31
> IOPS=59.92M, BW=29.26GiB/s, IOS/call=32/32
> IOPS=59.81M, BW=29.20GiB/s, IOS/call=32/31
> 
> IRQ, 128/32/32, cache on
> IOPS=64.05M, BW=31.27GiB/s, IOS/call=32/31
> IOPS=64.22M, BW=31.36GiB/s, IOS/call=32/32
> IOPS=64.04M, BW=31.27GiB/s, IOS/call=31/31
> IOPS=63.16M, BW=30.84GiB/s, IOS/call=32/32
> 
> IRQ, 32/8/8, cache off
> IOPS=50.60M, BW=24.71GiB/s, IOS/call=7/8
> IOPS=50.22M, BW=24.52GiB/s, IOS/call=8/7
> IOPS=49.54M, BW=24.19GiB/s, IOS/call=8/8
> IOPS=50.07M, BW=24.45GiB/s, IOS/call=7/7
> IOPS=50.46M, BW=24.64GiB/s, IOS/call=8/8
> 
> IRQ, 32/8/8, cache on
> IOPS=51.39M, BW=25.09GiB/s, IOS/call=8/7
> IOPS=52.52M, BW=25.64GiB/s, IOS/call=7/8
> IOPS=52.57M, BW=25.67GiB/s, IOS/call=8/8
> IOPS=52.58M, BW=25.67GiB/s, IOS/call=8/7
> IOPS=52.61M, BW=25.69GiB/s, IOS/call=8/8
> 
> The main part is in patch 3. Would be great to take patch 1 separately
> for 6.1 for extra safety.
> 
> Pavel Begunkov (4):
>    bio: safeguard REQ_ALLOC_CACHE bio put
>    bio: split pcpu cache part of bio_put into a helper
>    block/bio: add pcpu caching for non-polling bio_put
>    io_uring/rw: enable bio caches for IRQ rw
> 
>   block/bio.c   | 92 +++++++++++++++++++++++++++++++++++++++------------
>   io_uring/rw.c |  3 +-
>   2 files changed, 73 insertions(+), 22 deletions(-)
> 

-- 
Pavel Begunkov
