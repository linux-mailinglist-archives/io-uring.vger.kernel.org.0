Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F1E53ACA1
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 20:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238756AbiFASVn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 14:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356586AbiFASVl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 14:21:41 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA09337A84
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 11:21:39 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id f7-20020a1c3807000000b0039c1a10507fso1552176wma.1
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 11:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eos8jTICSkCmjWtmbegE07yHg2TGv/RtJUhZ44YV3ow=;
        b=VkqBHJFUResvUpmQ6R8XQ27K7mSoy2eKx+6f4yaePoqQ+DsA18c4U8xdikN+iTjKBj
         LjFm7+S+t6VhLC5ZO7NNdAvBXXyARhoV4bbC0bmxFgEok1Zk58vWCVUf0W7h7PmksjaJ
         ROzDuQDrNGUAUR2fkZv+MeVRyqlAPWAPtyX/gH6cC2F/hO55rbLm0lVkitkQKU+Txh4b
         WhAeVDGRbLHppOx6wAZAeQVnwB8x7zwlC6Z6OIAlVo7ffTaq9oa5rEaV6yDa/tWhGoh+
         SAWHRCBAm6iKynT0rF3e+LBv3E645M1pwDGypcf4d0PMl80Q+valyHYlRoI0c9M+vmq/
         M55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eos8jTICSkCmjWtmbegE07yHg2TGv/RtJUhZ44YV3ow=;
        b=eCxXMTXJStARTkT1DOMQdqPRYnSQssk2lj2Vf+mfzZPDzsVPmILgbtaFxCJS9/tUGU
         X1dFbSEgnHg2PfVXXuaVAXz9GY1JjaMuyKhdqdogV99BmtjjD4DjRrL1Z8k1eBZnvkxt
         cEAoKiaQyL/4nnhWyGaFF5Dd0OhTDkPpFX2IK6xbsubCzf2rO0BW5XNsFbVWmIWbaZHo
         df0z5TPdUlJsYgiK1Y7pj/4Pyg2k+/fyfeQnjzXkHluo4aTBcUtNlwcvZDN/clGV+y2Y
         YH9zaHemwx0n7GGFlFN59YV/ubT4UBueCkK+asdkvJMOkV5AyTLr1LAy6ggqYFCDb/Cq
         zAzg==
X-Gm-Message-State: AOAM532us5N5piP4XsjLqed1l5Oeg1ySaImLnM3xfhk0qO9vruc/fmFU
        eEW5e3H1GyxB3MMbrtBC8vdRJ0Lr8YV5Tpjc
X-Google-Smtp-Source: ABdhPJxEqFrz6y9aPN/YbhN84Z77gvC2hXxy0DEa5I8mu5cHylaSvthGpx304XgF8tPtEZ5+jx/RAA==
X-Received: by 2002:a1c:2504:0:b0:397:288c:c58b with SMTP id l4-20020a1c2504000000b00397288cc58bmr607111wml.53.1654107698244;
        Wed, 01 Jun 2022 11:21:38 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id y6-20020a5d6146000000b0020d106c0386sm2259519wrt.89.2022.06.01.11.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 11:21:37 -0700 (PDT)
Message-ID: <32c3c699-3e3a-d85e-d717-05d1557c17b9@kernel.dk>
Date:   Wed, 1 Jun 2022 12:21:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Olivier Langlois <olivier@trillion01.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
 <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
 <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
 <20220326143049.671b463c@kernel.org>
 <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
 <CAHk-=wiTyisXBgKnVHAGYCNvkmjk=50agS2Uk6nr+n3ssLZg2w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wiTyisXBgKnVHAGYCNvkmjk=50agS2Uk6nr+n3ssLZg2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/1/22 12:09 PM, Linus Torvalds wrote:
> I'm looking forward to the day when we can just delete all epoll code,
> but io_uring may be a making that even worse, in how it has then
> exposed epoll as an io_uring operation. That was probably a *HORRIBLE*
> mistake.

Of the added opcodes in io_uring, that one I'm actually certain never
ended up getting used. I see no reason why we can't just deprecate it
and eventually just wire it up to io_eopnotsupp().

IOW, that won't be the one holding us back killing epoll.

-- 
Jens Axboe

