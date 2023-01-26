Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B47867C193
	for <lists+io-uring@lfdr.de>; Thu, 26 Jan 2023 01:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjAZA27 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Jan 2023 19:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjAZA24 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Jan 2023 19:28:56 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B80D611D4
        for <io-uring@vger.kernel.org>; Wed, 25 Jan 2023 16:28:49 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id nn18-20020a17090b38d200b0022bfb584987so322630pjb.2
        for <io-uring@vger.kernel.org>; Wed, 25 Jan 2023 16:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GNB8M2nIlyWuGv4yTPs892G5V+vQXVoAibtrT6cdXNs=;
        b=r75VNQE0xQD1lvEV4BB9Yu8kVvS+m7+XGfDQ5ULH9FcaEbr8tcp4tzRfntzjzmxYKK
         xNegxALvd+oy8EEVa//RfQEcFw0Ujrs8CL+4pSUKaJjJpCqloaXZMuZuLTlbkx4Ipn5b
         UgKZPXfU6/J0bn3jUXS9e0eBwdqYGxKxcWJrpMqwqrKFaAom6Hl07EtVrR7YOzP/D/N1
         6+vCynAOInTEf7RV4oFclTy50xam9ZjJx45U0yOEPBPp5M3RJJn6qCk6OTsBamqZy1jc
         UOfEaF5y3lQzSLZXr3wW3hBnJPgw5tMcRfHj4h5QVoWUYZvqwtw8tdi+S9V/rqcTWgIg
         x3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GNB8M2nIlyWuGv4yTPs892G5V+vQXVoAibtrT6cdXNs=;
        b=3TdTWYjf2lAsN3h+wufQ7pgC5K3hGNyNS7/iNdaZ9bjDbwmgRmU/hZMEceVWpnLpWY
         3C9EBW0eKduQNMBY+mPfjEH3cHWk5gO3fv86/2H90LmUeVVk9lwwjslS3LzKpSldEBQs
         1dPgl7i9BmcPQ0BM19fp4DFwZeVgW6ZkJS0QzmG/AnTjbQSCJsHhVGOee9fdpvEi8xft
         qzj61Yi1Dlc95rpkm5Ic6BQZvX1IKi/kpUc8oT/wN21j9ikrFEcE46UpO+qa5uKW/K/n
         o5hxGwrueDIu5pXg6Pszq6XRBP2qMtl+Tp3ngB5qk81Hsv58OT31ZUdsSl8xHyeY0Q52
         zTVw==
X-Gm-Message-State: AFqh2kpyu/lKewmR5MU9wEgLFRtOL7j2nDcu9beXoFxO5dxO0pNC1IoW
        XVG7hY4uuIjws62kM9B8uQMdbg==
X-Google-Smtp-Source: AMrXdXvmbWlEIwchSLhfaQYY/WUfo3x53HJEpiXxe3E6174EvCXEb3WalHM6meh0i3oNXx/vJXQLDw==
X-Received: by 2002:a05:6a20:429e:b0:b5:f664:b4bc with SMTP id o30-20020a056a20429e00b000b5f664b4bcmr10963392pzj.2.1674692928731;
        Wed, 25 Jan 2023 16:28:48 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o14-20020a63730e000000b00477def759cbsm3790692pgc.58.2023.01.25.16.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 16:28:48 -0800 (PST)
Message-ID: <0f7cd96e-7f89-4833-c0af-f90b2c5cf67d@kernel.dk>
Date:   Wed, 25 Jan 2023 17:28:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Phoronix pts fio io_uring test regression report on upstream v6.1
 and v5.15
Content-Language: en-US
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230119213655.2528828-1-saeed.mirzamohammadi@oracle.com>
 <af6f6d3d-b6ea-be46-d907-73fa4aea7b80@kernel.dk>
 <DM5PR10MB14190335EEB0AEF2B48DF6BAF1CE9@DM5PR10MB1419.namprd10.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <DM5PR10MB14190335EEB0AEF2B48DF6BAF1CE9@DM5PR10MB1419.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/25/23 5:22?PM, Saeed Mirzamohammadi wrote:
> Hi Jens,
> 
> I applied your patch (with a minor conflict in xfs_file_open() since FMODE_BUF_WASYNC isn't in v5.15) and did the same series of tests on the v5.15 kernel. All the io_uring benchmarks regressed 20-45% after it. I haven't tested on v6.1 yet.

It should basically make the behavior the same as before once you apply
the patch, so please pass on the patch that you applied for 5.15 so we
can take a closer look.

Also, please don't top post. Replies go below the context, that's normal
OSS etiquette. Just like I did in the first one, and in this one.

-- 
Jens Axboe

