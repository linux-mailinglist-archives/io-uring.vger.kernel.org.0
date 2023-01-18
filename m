Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B8867224C
	for <lists+io-uring@lfdr.de>; Wed, 18 Jan 2023 17:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjARQBa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Jan 2023 11:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjARP7c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Jan 2023 10:59:32 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F394258642
        for <io-uring@vger.kernel.org>; Wed, 18 Jan 2023 07:56:17 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-12c8312131fso35947549fac.4
        for <io-uring@vger.kernel.org>; Wed, 18 Jan 2023 07:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TnZWFcWmNxBYxlm36v8cfD5yZDpkKQ0aC3UZSD0jltk=;
        b=wj7S76lZhgHNR/wz3qfMP29apc9hMbtbb5WF2C14Bo++5qkvJ4e7cUbAUDGb9J8QCX
         dzSYBgXtRaI++DQRqSSnYNv4SrPLLoVODS8JWIRHGIHcR24PSlF8sq5bNoyRdh8yv11i
         ATgVH2qgsjkEIuGwgsnQQ2woSpnbZ52db2BBqubVJuLYazxHpNBeE6rgv/hoU+sdGeAl
         jGCKsQIYzIkT8m8OYTEmlcQIt+IXAglqZv1DhGOuTztsGG/Ene1Ox27Si18bdlJal0Sa
         KiNNb73l/YhY8HBEaMZgGsFEny0fGoERIWiUzrpAw0MpO9tp8jaWbCcb7duo6AvCQFBx
         I+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TnZWFcWmNxBYxlm36v8cfD5yZDpkKQ0aC3UZSD0jltk=;
        b=nS9jlqLMwDog1ryVFrrkm37vDbwf+eqJ0KIs/zG0rFnGcnGA4sQ2Mq6w3pNMFhn/HA
         hRFfbsbD6SyrhA5sVsRbh2+raMvLEoC679ztDZ4Q6XgQLxbtsHfB1XyT/TvFpMingHi/
         GJqjE2fmWve8XzLBTjukRzcMdi5tVic9haDEFZDkRQ+xoClDnbMlGgMyqcjvTOZ1Hmyx
         EwZdm00uuZqevs/bzCglHDqvGLbIPIIaWG7DFT4El4ig+o7kZoHZ2/rEig8ZT3u+CZ//
         SLWHsWhPusR9dOQQ1ZFDIH8UUExUGL1C3SJU6PuX2oSHfJbcz9/GjTIiAAbaVhpol11C
         sMOQ==
X-Gm-Message-State: AFqh2kqc9dnWuqoMRLJ611kVF8ORFqsRpcdA44W6jIEnA4WB/u0ycEpm
        FxSD+p+ZZAxodBnkhcWCVZ/m/E/yiFpZsopG
X-Google-Smtp-Source: AMrXdXtO0qt6CqcaBM6jnu8tk2EWZ2JoCctBJbQ+Cucb0k7ebKS2GvCT120dezrjMJvHRCuOSiXiYw==
X-Received: by 2002:a05:6870:9564:b0:15b:a3dc:d5f6 with SMTP id v36-20020a056870956400b0015ba3dcd5f6mr789144oal.3.1674057377075;
        Wed, 18 Jan 2023 07:56:17 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d5-20020a4aaa85000000b004cb050fd09fsm16663392oon.29.2023.01.18.07.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 07:56:16 -0800 (PST)
Message-ID: <b3cbaa88-9b01-e82f-bcfa-2fccc69b37c4@kernel.dk>
Date:   Wed, 18 Jan 2023 08:56:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Problems replacing epoll with io_uring in tevent
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Samba Technical <samba-technical@lists.samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
 <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
 <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
 <2a9e4484-4025-2806-89c3-51c590cfd176@samba.org>
 <60ce8938-77ed-0b43-0852-7895140c3553@samba.org>
 <79b3e423-16aa-48f1-ee27-a198c2db2ba8@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <79b3e423-16aa-48f1-ee27-a198c2db2ba8@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/28/22 9:19?AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
> any change to get some feedback on these?
> https://lore.kernel.org/io-uring/60ce8938-77ed-0b43-0852-7895140c3553@samba.org/
> and
> https://lore.kernel.org/io-uring/c9a5b180-322c-1eb6-2392-df9370aeb45c@samba.org/
> 
> Thanks in advance!

Finally getting around to this after the break...

I think your initial patch looks reasonable for doing cancel-on-close.
Can you resubmit it against for-6.3/io_uring so we can get it moving
forward, hopefully?

That would also be a good point to discuss the fixed file case as well,
as ideally this should obviously work on both types.

-- 
Jens Axboe

