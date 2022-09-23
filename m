Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A065E7CA5
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 16:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiIWOPf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 10:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiIWOPd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 10:15:33 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF46111DF1
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:15:32 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id q83so928iod.7
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=UWmSkIcj2Zi0W95Qe0q25OStbn3befeirPvCr4MRQSQ=;
        b=D2yf3TlFalE7EQgO4dw4+/YaX1DhboXIHpiQ3fxco/I0FzbFXMnkI9U2xiatkh9t2c
         nLQASI0sqeJwJmqy0E/wtVtgC5vep4UieANkH0I9W+I9WGrki+D76hbN6Fp/9Pw5dp6x
         mHDFqkjHesmdGr8jaIw2/O7AclhwSxCIZk2vlreVNrOngHhTBr2RigHvgR8mMR83xHVc
         15f4/Op6S+4vymQP3tWaR4DgF8plZoCLH35Biwinj73bIpozGDLUX2UUle7+TxE7VGAc
         vb1P0oFzD1imNOhDp9l3X75Uaqt5Kx5GNBoTfyBHWJ1gHgJEgKBk1mjJ/3iVZa/r7C3r
         FY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=UWmSkIcj2Zi0W95Qe0q25OStbn3befeirPvCr4MRQSQ=;
        b=0fz1/sQszn0qyQIh9zLiKducnRvgtkE9AblZoSURyVkgr8NC6LR1r3o3SKJv3tvgTy
         AByWnn6xrRV6WD3+vS+ok7QcZ8NdezYzJ48G1XC76s8fCigkEcCFEGQEQ5mJ3Eb29Ja7
         9keuI6dQVHAqs4V7oYj31YeU4skUGC854qXTz1HUoo0clQ9gHU187FKrT8mHMZ91Flxf
         L/RCkGJ/WuDjjWHpmC1QgWlpIJFw4X9hd1hmQM4XBjYnBomUDMVIbPBzrrn9mzebkr1G
         QJtjMHrNztcqLwScgzN4Cb6mCXNBnobpm1MorEz3uE5rpDPFnLZqZ3+TIJHAZDpmzdUl
         sP5A==
X-Gm-Message-State: ACrzQf0YVRnPPOqcibKzGkmY+MuyFgMLWtQ8v7MPn8Zb9AC+v0plzZPA
        2hgq9kFrWDsYMTrsMJuepvWnRQ==
X-Google-Smtp-Source: AMsMyM53Z12Kuv8H+dqvBgr3DBBg4AIRzLDXTvx9NPbXSHl0B74YnwyuZKRp6Ju5owk5lxsokGhe1Q==
X-Received: by 2002:a02:cc83:0:b0:35a:1461:5be8 with SMTP id s3-20020a02cc83000000b0035a14615be8mr4925685jap.32.1663942531405;
        Fri, 23 Sep 2022 07:15:31 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k10-20020a6bba0a000000b006a19152b3f0sm3653752iof.5.2022.09.23.07.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 07:15:30 -0700 (PDT)
Message-ID: <c9750503-b16b-a756-b3e3-c9dfa0c482c3@kernel.dk>
Date:   Fri, 23 Sep 2022 08:15:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-next v8 0/5] fixed-buffer for uring-cmd/passthru
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
References: <CGME20220923093906epcas5p1308a262f3de722a923339c2e804fc5ee@epcas5p1.samsung.com>
 <20220923092854.5116-1-joshi.k@samsung.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220923092854.5116-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/23/22 3:28 AM, Kanchan Joshi wrote:
> Currently uring-cmd lacks the ability to leverage the pre-registered
> buffers. This series adds that support in uring-cmd, and plumbs
> nvme passthrough to work with it.
> 
> Using registered-buffers showed IOPS hike from 1.9M to 2.2M in my tests.

Ran my peak test on this, specifically:

t/io_uring -pX -d128 -b512 -s32 -c32 -F1 -B0 -R1 -X1 -n24 -P1 -u1 -O0 /dev/ng0n1 /dev/ng1n1 /dev/ng2n1 /dev/ng3n1 /dev/ng4n1 /dev/ng5n1 /dev/ng6n1 /dev/ng7n1 /dev/ng8n1 /dev/ng9n1 /dev/ng10n1 /dev/ng11n1 /dev/ng12n1 /dev/ng13n1 /dev/ng14n1 /dev/ng15n1 /dev/ng16n1 /dev/ng17n1 /dev/ng18n1 /dev/ng19n1 /dev/ng20n1 /dev/ng21n1 /dev/ng22n1 /dev/ng23n1

Before:

Polled (-p1): 96.8M IOPS
IRQ driven (-p0): 56.2M IOPS

With patches, set -B1 in the above:

Polled (-p1): 121.8M IOPS
IRQ driven (-p0): 68.7M IOPS

+22-26% improvement, which is not unexpected.

-- 
Jens Axboe


