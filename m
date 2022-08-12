Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4B8590A03
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 03:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiHLBvo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 21:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiHLBvn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 21:51:43 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36060A1D00
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 18:51:42 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s206so18639759pgs.3
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 18:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=GuxTtKiCEQk9KYEcOuaDJGVVTCjKqdZJW2DY0vIvo3U=;
        b=TttniqHbI0gANs8KdytEYIcUKxL6AiUMkf8+JXIESZY2FoYsahWVliLQMpFSlgvQs7
         fu3kiK93+FfFVf8UUuU2BGNp+IPNucFVX2UgzmUwzPycqyCTgChVd3ueOtka8UA3wNDd
         GMUujl4CB8mintaolt2FCabCjSCtcO3iTMJ81RcEasFDD77HGX/K8/Jp+Z5l72DUMPGm
         zy7DSdWM1PMBUlIfBVtuOy5WcacR18cVgbuuZB8X/anBwV6NTnMRqi7ag3eDQXiOn5Wg
         EaldAS0Sq8ZUd60xoL33Y4nBjgR5VqIWZl3B/vzK+Q+19G6X2+cEwxH7oKfkAFV+5/5j
         eoGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=GuxTtKiCEQk9KYEcOuaDJGVVTCjKqdZJW2DY0vIvo3U=;
        b=qEaWs3Zyg3PaXDZMXb0nyMzoC+3VaOIJZunhDHoBu1PfAOeUxIBQisxwiIRDBTohZ4
         kjAbFVj8IpcT1Ga5+XZJQCYGmrtYRl8Y2g0ptMB0NkFGvd4YfI14BwU0LdxH2HamhjVI
         x4fnmK8BC9Y1ojWZR72FntHK4KoAR1/BiMP6sdeJWaryOcH1c+3IQL4xvbgkGMb+i+sf
         +mscZQ5a66DSu1Wp8G8MXWaVTKv0DC5p6lFexFdFTgLLgsa2W5oWapl6326dqxkLjqnJ
         PHDP0N4eHX90QCyCN540uk1QOrTMQiy00JDyv1IFaxUnwrw2dqO1UdrPrVvcoqZqupOb
         NEKw==
X-Gm-Message-State: ACgBeo0uEo/uO0Ye/HCao8GVrgkjCmzW6W93Soq28BcaegnwtkQ30Zij
        y6jYugpyAsAXSSI+LxBQnSSOiQ==
X-Google-Smtp-Source: AA6agR5/gYSyH7BuZsjlwPXiuZ2IK9ORyeqeM9nn3L0x1kyV3fexuNHaUZvFTQyGNvb4XYoRo+e7UQ==
X-Received: by 2002:a62:1808:0:b0:52d:9eeb:8853 with SMTP id 8-20020a621808000000b0052d9eeb8853mr1809400pfy.45.1660269101605;
        Thu, 11 Aug 2022 18:51:41 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s32-20020a17090a69a300b001f74ddac693sm4241752pjj.52.2022.08.11.18.51.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 18:51:41 -0700 (PDT)
Message-ID: <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
Date:   Thu, 11 Aug 2022 19:51:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing 0/5] Add basic test for nvme uring passthrough
 commands
Content-Language: en-US
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Ankit Kumar <ankit.kumar@samsung.com>
Cc:     io-uring@vger.kernel.org, paul@paul-moore.com, joshi.k@samsung.com
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com>
 <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/22 6:43 PM, Casey Schaufler wrote:
> On 7/19/2022 6:52 AM, Ankit Kumar wrote:
>> This patchset adds test/io_uring_passthrough.c to submit uring passthrough
>> commands to nvme-ns character device. The uring passthrough was introduced
>> with 5.19 io_uring.
>>
>> To send nvme uring passthrough commands we require helpers to fetch NVMe
>> char device (/dev/ngXnY) specific fields such as namespace id, lba size.
> 
> There wouldn't be a way to run these tests using a more general
> configuration, would there? I spent way too much time trying to
> coax my systems into pretending it has this device.

It's only plumbed up for nvme. Just use qemu with an nvme device?

-drive id=drv1,if=none,file=nvme.img,aio=io_uring,cache.direct=on,discard=on \
-device nvme,drive=drv1,serial=blah2

Paul was pondering wiring up a no-op kind of thing for null, though.

-- 
Jens Axboe

