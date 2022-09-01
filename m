Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD4A5A9B56
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 17:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiIAPN0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 11:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiIAPNY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 11:13:24 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6733785FFD
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 08:13:23 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y187so14847841iof.0
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 08:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=3jiI6egaVcYbT668Z3YqjtrAH0Qiub0xsZDDicZTnWU=;
        b=oErgsFd6HrJ83L569lCnCjcLLaxpT3KuY9xlDnfZ1qk8/g5leqWPparzsrCvTDGa6C
         vZTp2Iv4pm3CJNgSK6vksBhc8hM5aw9HXX0j1rzUEViXhAPss40/N/GtMsCNeQyXvpVx
         0oOJQfNGJhCgbCe/r/AHPRp5PHAHN4NU2MXMIOSWp/+hCpF4WsE8HX85KLQp+tvUY3By
         x4ayCj9k6RWBg1dF0dthpSWPPUOVpxapg9OsupCr/AVyYn2yVZjuJG+p/6PMofpGM+c0
         s2552sGCg/ng1IX7NTDXTRACwIsO5FjYbwDYYkVWK/G2t0NPj3yFiAB7XU12QMeNpSgM
         js8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3jiI6egaVcYbT668Z3YqjtrAH0Qiub0xsZDDicZTnWU=;
        b=OIcRLEk91DReTUPWbzJpMxEL6TFF0UEtowmbk2NrCTvWPcSkhUeAcU6gfwl+QV53o1
         t+nDYyfLQAOmjeIz2a8v/PFQQwxkfbcarZTKihl3vfU0+O8XQE29e+Aio2LkadwiAgZo
         ByOY9eiaVH+vL0mlcpqYSGJIjgRsCcrtMNwEMP3/0HhwNnTRZ2ITboEYJmIBZ9SfbUxe
         buRUrDOzSq4RjPGZ68tTlV3TInjxByrqmRosX4frU2RUlrAasYr3u7COSoafRlHnu+9C
         OQsX5ZdBKI+M6TWkrW4PnmOrSJ3g0NnOe4qXL2ui6pxk/FqlaNfF94CyerWJLge2oYwR
         Yakg==
X-Gm-Message-State: ACgBeo0Cc6cV2YRAT9g+gOLeg+C+0I3ji3LAUji5mv5rvjClVI+byUNK
        fOtMqp8ObXWzsrMAowHTP203OahrXP/J4Q==
X-Google-Smtp-Source: AA6agR76OuD4oNsCEufQQP/wxci501Ip6jCyrZu2+JKAa7lWEaB5R/i0Y+n35I3CCL9Iz0crSesQGg==
X-Received: by 2002:a6b:7a0a:0:b0:68b:938:5384 with SMTP id h10-20020a6b7a0a000000b0068b09385384mr12224794iom.177.1662045202702;
        Thu, 01 Sep 2022 08:13:22 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u190-20020a0223c7000000b00343617e8368sm8235294jau.99.2022.09.01.08.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 08:13:22 -0700 (PDT)
Message-ID: <cca21012-06ea-effd-b214-05373e8b20fa@kernel.dk>
Date:   Thu, 1 Sep 2022 09:13:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [RFC 0/6] io_uring simplify zerocopy send API
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1662027856.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1662027856.git.asml.silence@gmail.com>
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

On 9/1/22 4:53 AM, Pavel Begunkov wrote:
> We're changing zerocopy send API making it a bit less flexible but
> much simpler based on the feedback we've got from people trying it
> out. We replace slots and flushing with a per request notifications.
> The API change is described in 5/6 in more details.
> more in 5/6.
> 
> The only real functional change is in 5/6, 2-4 are reverts, and patches
> 1 and 6 are fixing selftests.

Let's go for this, we can always bring back notification slots in a
later release if it's deemed necessary or beneficial, however we
can't take it out if we release 6.0 with the change...

-- 
Jens Axboe


