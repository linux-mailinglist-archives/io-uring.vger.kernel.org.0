Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6627D5768EC
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 23:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiGOVcj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 17:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiGOVci (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 17:32:38 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9920E7FE74
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 14:32:37 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso7303631pjk.3
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 14:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ESan9JBmRokIZHcl3xO2oQu/yLuGmLntw5PPB729yuE=;
        b=noo704f8mSs/qVYaE8jN+WxPasbir+fSLLjfDYmjxXB3mRTjQciOhaNH0MLTATfQ3p
         tsz81HvqFoe1o/XZDn7JiMENk6vpsz9WSyGoBluR7G1G2j7rYvSjgnqxRDfKDcT9tNVv
         UR03bucAfDQQtEp963FnmZz0FVof5GdJsrSWo3NE8HLz7KkorM63SkEElyMYS3ogLeqh
         TCFJC7RwMAApK91x+Qai/1UjSh1RsT0SGTVnFABUf2TUrpDHyjvr8DuTZv7rNf7QFNuY
         jCCXRncwlWbm6KueNqteYwvzuV7WMcClXPA13fjv86zqKN2yzKTTbcJu7EJIOqP+EEJA
         tq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ESan9JBmRokIZHcl3xO2oQu/yLuGmLntw5PPB729yuE=;
        b=z6fJX0D5kYyoEuHjUNpid/YVyOGFQKfHYbllpynkVT2cr5szq4X7an1rAhMxLxVL79
         UI/eyaRrdaM8Iy7BW2MLe+vEiMCsVAlaxVehhZMWRoSngrZ8dAQQRvWapGQS3KV/4Ebs
         ttliE25tucOniuT/1SZ5pUhXvQFMTBxeIIEBSHdShaKmjtgdy+G+uVyXzchlNR4+rq4l
         HgBbzDwFIDv/J27BIYHYdYO/SDmMqTPad8ll56pr0/U3Pr/5WdXXNKr5p93m5l9A9OA5
         E7Q95NhDtFfLmAqDcqlqKGK+K5LrQFBwJCLFyBFbJl0oEwicosZZtfts77CEuDU8wsom
         LZeA==
X-Gm-Message-State: AJIora9Biz/W/KmLrr03lZm4eXshhrmsVUry+UuW4xn7YAc51UHM7yYk
        h4A/KeLQusdYbsMZDJglCRrCkw==
X-Google-Smtp-Source: AGRyM1uazsESb2FdRADBB9x052XegnOHXqVck2P43LgHiqV6DSc2FTXLWWFTWvKwKAugfS1uHWw9lA==
X-Received: by 2002:a17:90b:1a8c:b0:1ef:c1b2:b2cd with SMTP id ng12-20020a17090b1a8c00b001efc1b2b2cdmr18265028pjb.190.1657920756898;
        Fri, 15 Jul 2022 14:32:36 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bd3-20020a656e03000000b00419a6f3c8f5sm3577260pgb.19.2022.07.15.14.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 14:32:36 -0700 (PDT)
Message-ID: <da03fb01-83e6-974e-d273-ce86c770e5b2@kernel.dk>
Date:   Fri, 15 Jul 2022 15:32:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file
 op
Content-Language: en-US
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, joshi.k@samsung.com,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
 <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
 <a91fdbe3-fe01-c534-29ee-f05056ffd74f@kernel.dk>
 <CAHC9VhRCW4PFwmwyAYxYmLUDuY-agHm1CejBZJUpHTVbZE8L1Q@mail.gmail.com>
 <711b10ab-4ac7-e82f-e125-658460acda89@kernel.dk>
 <1b220ed8-c010-15f2-3bc2-6ec4b2e7532f@schaufler-ca.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1b220ed8-c010-15f2-3bc2-6ec4b2e7532f@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/22 3:16 PM, Casey Schaufler wrote:
> On 7/15/2022 1:00 PM, Jens Axboe wrote:
>> I agree that it should've been part of the initial series. As mentioned
>> above, I wasn't much apart of that earlier discussion in the series, and
>> hence missed that it was missing. And as also mentioned, LSM isn't much
>> on my radar as nobody I know uses it.
> 
> There are well over 6 Billion systems deployed in the wild that use LSM.
> Every Android device. Every Samsung TV, camera and watch. Chromebooks.
> Data centers. AWS. HPC. Statistically, a system that does not use LSM is
> extremely rare. The only systems that *don't* use LSM are the ones hand
> configured by Linux developers for their own use.

I'm not talking about systems that only I use, but I believe you that
it's in wide use. Didn't mean to imply that it isn't, just that since I
don't come across it in my work or the people/systems that I've worked
with, it hasn't been much on my radar and nobody has asked for it.

>>  This will cause oversights, even
>> if they are unfortunate. My point is just that no ill intent should be
>> assumed here.
> 
> I see no ill intent. And io_uring addresses an important issue.
> It just needs to work for the majority of Linux systems, not just
> the few that don't use LSM.

Agree, and hopefully we can make sure that it does, going forward as
well.

-- 
Jens Axboe

