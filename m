Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7B7564754
	for <lists+io-uring@lfdr.de>; Sun,  3 Jul 2022 15:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiGCNBB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jul 2022 09:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiGCNA7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jul 2022 09:00:59 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0804162C1
        for <io-uring@vger.kernel.org>; Sun,  3 Jul 2022 06:00:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g20-20020a17090a579400b001ed52939d72so7032025pji.4
        for <io-uring@vger.kernel.org>; Sun, 03 Jul 2022 06:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=O994vOf9UI6tKZvF2wEGp5HxYx2phH8UMlwqKM11CuM=;
        b=vuLxj4MNL/ahYcUx2CO5OTo+AcTtqF7pHfX8iRhxnZH9B6Q3D62LgI6dAGN2SVz2e+
         3IriDPE1x6Jm1HVDxgFe3vZuAtodh23dZ1wtYfolNr2+P1E+6zGEDYb+r/YfO4rEeeUR
         p05noO+QfCMd1r3qTk4TPV80auYxAt0d/N3JY9mlefyGCpyaL5qAwOrmg05L7dAbbx83
         FyaEByux7dwBnZi7qFiIEiT/E9qbpEs0vHmBV9i4yEt2Gt0DRkoks/DvLADQq/oG3o0N
         MY8MN08LbYf0tSL/GdVRRO0humHluh21M8X4FsBONIpEqCqIaJC4FUjClHZL9TL38kj1
         CILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=O994vOf9UI6tKZvF2wEGp5HxYx2phH8UMlwqKM11CuM=;
        b=qBeKNowjX6pklCAY8CRderjCor2wXHihX84pY9eCcjSBsVw/K/nNjUVQ+hgWufRIrB
         bOigHOUr46gDQUjJ7gj0bGiNsKaR6sKqzA1QU/+QucckCUqmdzyhw/46XUspYM5y+2IS
         ANZ4q+bg/lut/AyEJVJnEhZr3dv51z2mQDaAwdZ1849kb9TEoJGVe0pVd3/gMbWUBqNF
         kuAgtnZCI3UJLppQe9VpM5tN37KwOTShfncjDWbufK9TnPbqCjua4UHxx885gdmpKSZO
         jToVTYa6Qj1/HWTOtqOwIKiuExRIG+kGA/0qyiF4/wvr/pJe//gccS0BKLPpA4/Juljx
         E2gw==
X-Gm-Message-State: AJIora+MwvKyIbntp58vPfA6Q3YHVyEIXsNrN9p36GJ9DkmrciP+S6aZ
        a4iHA1Yy61CE7tz6Rx4mCNxMtg==
X-Google-Smtp-Source: AGRyM1sF65o6SCQvLxJZCuVoUzFudcj1bpd0aqxlcMYoJF9nnm4uVidcPkrEVdV5/Ht4mvzw8Idaig==
X-Received: by 2002:a17:902:aa47:b0:16b:8e4c:93d2 with SMTP id c7-20020a170902aa4700b0016b8e4c93d2mr29807973plr.27.1656853258465;
        Sun, 03 Jul 2022 06:00:58 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902e88800b0016403cae7desm1819752plg.276.2022.07.03.06.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jul 2022 06:00:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     alviro.iskandar@gnuweeb.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, howeyxu@tencent.com,
        fernandafmr12@gnuweeb.org, gwml@vger.gnuweeb.org
In-Reply-To: <20220703115240.215695-1-ammar.faizi@intel.com>
References: <20220703115240.215695-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v1 0/2] __hot and __cold
Message-Id: <165685325716.1105109.7309063844690717749.b4-ty@kernel.dk>
Date:   Sun, 03 Jul 2022 07:00:57 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 3 Jul 2022 18:59:10 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> This series adds __hot and __cold macros. Currently, the __hot macro
> is not used. The __cold annotation hints the compiler to optimize for
> code size. This is good for the slow-path in the setup.c file.
> 
> [...]

Applied, thanks!

[1/2] lib: Add __hot and __cold macros
      commit: ee459df3c83ab86b84e1acaaa23c340efb5bab35
[2/2] setup: Mark the exported functions as __cold
      commit: 907c171fa4aac773fee9421bc38fcf9581e54f61

Best regards,
-- 
Jens Axboe


