Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0690A5AB647
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 18:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbiIBQMT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 12:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbiIBQLz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 12:11:55 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92E9290
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 09:06:36 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id i77so1978567ioa.7
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 09:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=YsNxMOf5LM72+d4kt2FeHAVCME8bs9+iFL3iEoAYK5k=;
        b=ggqTvGon1pNPipkqQEIhdDLTqBntf3tFv+VuIQXJgl7JDFNjadhaghMctdXZIliIu6
         foiBAFIQP3qP70R0mWYerMn5rrO2x/SxfGeiiyNpaw4HZSL096UXeaEzdricSX8HzZwV
         3VeyZywkyJHGfRrh9LP50qyr/GkfGkCfxQqvvLIGTgUmD8RM+kIW+qOSsMT9Bthn1A8G
         HHvH/7XyqDoIZXi1FfQjELfOIEGbalnYO4D+XszjwBPuH56PgLFzY0yeiDBUgQzAVTA1
         Jll8nIiAFYdPvJZHNeldlmPT6Odb/HFLUGb47kyi3X3ePPNyAjGZhL7sCMnTVdWlV7JP
         Ae5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YsNxMOf5LM72+d4kt2FeHAVCME8bs9+iFL3iEoAYK5k=;
        b=Ou0p+Ec/oxQx6sD6ZuskWOvTaDdg9oQRu+NqMRUcTnNB1QSyzXjVre4CSdp4DeWNUJ
         q/+kwTIVxP/ho/cs3SRzqQHnVZZQlcXDOkPK2o92oc0w1wuGGcm0tKtXNXoNL8ULRfst
         UPJ9gNpUouWM7yBhCS7yfF2C9U9dAK/aKjWCJ1BTh5PQ5qU4mfeFwhQogU1YG0YHEA53
         /U43rnQagWH50RBJjUyf5HAcXLxxmtJ/qzmZUMrhaMAQCYV5oIit7IqoTO4g0lPIy7ry
         YIPbJalyGKGm1lq9KEwibJNmTHDmkZ0a3bxJQL47Fw1o5yMxvOQpvfRq51VqWNrnWAZk
         Lucw==
X-Gm-Message-State: ACgBeo2p0b3EwtGa/NFMmh+dh0fjD6V4Ry/+CyurtldQxPn6OQ5kzPAv
        gcdVXk7WZEQCcIWJg/wtGdfX4g==
X-Google-Smtp-Source: AA6agR63XMol65orTkQhB3R5iR+tt0q5or/SxI8iXd1vEyi1Tkhf4V+06eu1o6xVK4XJu8RrNi2ZRg==
X-Received: by 2002:a5e:8414:0:b0:689:e3c:308a with SMTP id h20-20020a5e8414000000b006890e3c308amr17471363ioj.29.1662134795841;
        Fri, 02 Sep 2022 09:06:35 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u11-20020a92da8b000000b002ead7a3b185sm966699iln.13.2022.09.02.09.06.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 09:06:35 -0700 (PDT)
Message-ID: <f1e8a7fa-a1f8-c60a-c365-b2164421f98d@kernel.dk>
Date:   Fri, 2 Sep 2022 10:06:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH for-next v3 0/4] fixed-buffer for uring-cmd/passthrough
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
References: <CGME20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf@epcas5p1.samsung.com>
 <20220902151657.10766-1-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220902151657.10766-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/22 9:16 AM, Kanchan Joshi wrote:
> Hi,
> 
> Currently uring-cmd lacks the ability to leverage the pre-registered
> buffers. This series adds the support in uring-cmd, and plumbs
> nvme passthrough to work with it.
> 
> Using registered-buffers showed peak-perf hike from 1.85M to 2.17M IOPS
> in my setup.
> 
> Without fixedbufs
> *****************
> # taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
> submitter=0, tid=5256, file=/dev/ng0n1, node=-1
> polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> IOPS=1.85M, BW=904MiB/s, IOS/call=32/31
> IOPS=1.85M, BW=903MiB/s, IOS/call=32/32
> IOPS=1.85M, BW=902MiB/s, IOS/call=32/32
> ^CExiting on signal
> Maximum IOPS=1.85M

With the poll support queued up, I ran this one as well. tldr is:

bdev (non pt)	122M IOPS
irq driven	51-52M IOPS
polled		71M IOPS
polled+fixed	78M IOPS

Looking at profiles, it looks like the bio is still being allocated
and freed and not dipping into the alloc cache, which is using a
substantial amount of CPU. I'll poke a bit and see what's going on...

-- 
Jens Axboe


