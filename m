Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11B5589F7B
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 18:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbiHDQm3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 12:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbiHDQm2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 12:42:28 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85973A49B
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 09:42:26 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c139so24900pfc.2
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 09:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+CnBeoe7uqEcxaB+1aAe8bKxhqf9IbvpUHHTGwUqr4U=;
        b=WmRCslE9kOuIR6KnPHmII1JL58W/uouaQW7Tcin9RLlyJDDrGFhgfwB1M8A5f3tMAf
         Aw41mRetrEtddPH+vaIptXu8+gpN1C7OlGiMoXSm9a5QgNzUpBt7XodP79FPPQmegTNr
         hkgUSOE7Lpj4XmSo7rksCTRKaD2kvBQ13I8sKOYpu/iFPLFofommLFjx9+DEntWY7s47
         OLbnacVu6uy2MY34Qq5d6L6EoUtBTEFaheopOEHNog0y5QeQCkZmz0/TKyC38y8YBkt2
         3h1Ab7b9GkCKg5PuFmOLIThaSSll6kXXslvaSgKdYWMHNv59lC432ht+tAV8ug48Ebfn
         CU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+CnBeoe7uqEcxaB+1aAe8bKxhqf9IbvpUHHTGwUqr4U=;
        b=YVCA8fU793ugOPWt/IwmZNFC/8q74tVmRFydSBnAQ3Msi1HqHlB4z8CWQzp+wXeYhb
         RYgIK0lxQbHKhzUU7ahFT9nJXLj0bevm+4d9ibhuwwIn37VHYrizt0eKmhraNIzXGJ7W
         EjkJwoWmQ3c2bd2j2rOiFb6D6sRdtDjtLnl2Zpv9sDyswXBaJrmK0DKq4gIeOpLVSlf8
         Yhj1MiURnciw64n91ZJsRMW8uNf73HAv+FDv99hRcTyiSMQ1Axqy7Q5l31wqGoAbVdGG
         tLDQavOLHToGfIC7wcMZops/sKddV56tjKTHKMDmDN1MnzeGyi95SbnY35I2eNxly3NB
         LsXA==
X-Gm-Message-State: ACgBeo0W8omDkKsgdIF2f3h8LyEDZiZOJF8zG92c80E9sDhx38cTuFqQ
        QgewuYRogHx1rHnuVAS/twOFDw==
X-Google-Smtp-Source: AA6agR6kMtN9endtZcnUlYAQ+oFGuA9Xrr1w70/pFRQoDTBxqaqU9fUwrglmB1vgkcAfMZVmAWfUrg==
X-Received: by 2002:a63:5353:0:b0:419:f140:2dae with SMTP id t19-20020a635353000000b00419f1402daemr2253734pgl.526.1659631346066;
        Thu, 04 Aug 2022 09:42:26 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s25-20020aa78bd9000000b0052e0b928c3csm1132114pfd.219.2022.08.04.09.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 09:42:25 -0700 (PDT)
Message-ID: <d72ea27d-ba80-2b9b-11e0-7fff11c8bf3f@kernel.dk>
Date:   Thu, 4 Aug 2022 10:42:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCHv2 0/7] dma mapping optimisations
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@lst.de,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>
References: <20220802193633.289796-1-kbusch@fb.com>
 <5f8fc910-8fad-f71a-704b-8017d364d0ed@kernel.dk>
 <YuvzqbcXwGUMtKmm@kbusch-mbp.dhcp.thefacebook.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YuvzqbcXwGUMtKmm@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/4/22 10:28 AM, Keith Busch wrote:
> On Wed, Aug 03, 2022 at 02:52:11PM -0600, Jens Axboe wrote:
>> I ran this on my test box to see how we'd do. First the bad news:
>> smaller block size IO seems slower. I ran with QD=8 and used 24 drives,
>> and using t/io_uring (with registered buffers, polled, etc) and a 512b
>> block size I get:
>>
>> IOPS=44.36M, BW=21.66GiB/s, IOS/call=1/1
>> IOPS=44.64M, BW=21.80GiB/s, IOS/call=2/2
>> IOPS=44.69M, BW=21.82GiB/s, IOS/call=1/1
>> IOPS=44.55M, BW=21.75GiB/s, IOS/call=2/2
>> IOPS=44.93M, BW=21.94GiB/s, IOS/call=1/1
>> IOPS=44.79M, BW=21.87GiB/s, IOS/call=1/2
>>
>> and adding -D1 I get:
>>
>> IOPS=43.74M, BW=21.36GiB/s, IOS/call=1/1
>> IOPS=44.04M, BW=21.50GiB/s, IOS/call=1/1
>> IOPS=43.63M, BW=21.30GiB/s, IOS/call=2/2
>> IOPS=43.67M, BW=21.32GiB/s, IOS/call=1/1
>> IOPS=43.57M, BW=21.28GiB/s, IOS/call=1/2
>> IOPS=43.53M, BW=21.25GiB/s, IOS/call=2/1
>>
>> which does regress that workload.
> 
> Bummer, I would expect -D1 to be no worse. My test isn't nearly as consistent
> as yours, so I'm having some trouble measuring. I'm only coming with a few
> micro-optimizations that might help. A diff is below on top of this series. I
> also created a branch with everything folded in here:

That seemed to do the trick! Don't pay any attention to the numbers
being slightly different than before for -D0, it's a slightly different
kernel. But same test, -d8 -s2 -c2, polled:

-D0 -B1
IOPS=45.39M, BW=22.16GiB/s, IOS/call=1/1
IOPS=46.06M, BW=22.49GiB/s, IOS/call=2/1
IOPS=45.70M, BW=22.31GiB/s, IOS/call=1/1
IOPS=45.71M, BW=22.32GiB/s, IOS/call=2/2
IOPS=45.83M, BW=22.38GiB/s, IOS/call=1/1
IOPS=45.64M, BW=22.29GiB/s, IOS/call=2/2

-D1 -B1
IOPS=45.94M, BW=22.43GiB/s, IOS/call=1/1
IOPS=46.08M, BW=22.50GiB/s, IOS/call=1/1
IOPS=46.27M, BW=22.59GiB/s, IOS/call=2/1
IOPS=45.88M, BW=22.40GiB/s, IOS/call=1/1
IOPS=46.18M, BW=22.55GiB/s, IOS/call=2/1
IOPS=46.13M, BW=22.52GiB/s, IOS/call=2/2
IOPS=46.40M, BW=22.66GiB/s, IOS/call=1/1

which is a smidge higher, and definitely not regressing now.

-- 
Jens Axboe

