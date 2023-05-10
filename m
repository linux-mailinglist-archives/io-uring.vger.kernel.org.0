Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AEE6FE169
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 17:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbjEJPR5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 11:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbjEJPR4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 11:17:56 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D6A10C1
        for <io-uring@vger.kernel.org>; Wed, 10 May 2023 08:17:54 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-33110a36153so1647575ab.0
        for <io-uring@vger.kernel.org>; Wed, 10 May 2023 08:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683731874; x=1686323874;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lN7tbsnewymx3Hha9SErMkfjnHX+bufyhRuLjrWne0Q=;
        b=kedPAOWw1SnhirRMkBOdCYfWJOhBtIQddzc6tVfVtEhapV90gOFqq0WkqycAGdytwZ
         1481+dK/0lz2B5/haB7EY2dgOlc2Itn+JrhyNfKFBr+s+zAWBJxctx1lvleSUFOiFeSQ
         ZRmRkuO2MonNEdoAz+T6u866p9FFjB+RDM4DFDzFywJXuytT5ZD6xnSifKdF1UGXnfif
         7oTgr7KRUR5+hqjiYwMC9Ba6kTiUsHZK6srDAhWWCUuTxe5YCYfIXPUdjJr+Sp+Wn9Ax
         0LG+IaC+v9nVr/Q1kfnASsRat0WhMGqjx6xV6gwHMnX8dzOkSStS2bkqRsKU8oXA12aC
         wN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683731874; x=1686323874;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lN7tbsnewymx3Hha9SErMkfjnHX+bufyhRuLjrWne0Q=;
        b=FMIW+HJVfzClNm2r89PVq2GjNSIdAbXDT8++1XAAQNK3nhoDEsIO75t5aNnjiCoBLB
         WoGfCsYii85O30Oxu6U/R2+/gq/DHl3rjic9/uPuOHBXlD5BfBzlQaulf8s59cro3gqV
         dPOzd/Qy9c/QMNHWgW7R6yS44bW4+9iyiHtvLSRawk5BAn9EP4fy5xGN0+KdNuakB/Ne
         o2Cb4COCthL1zYXOQ79FSHKWEww0Lvl8uDQ4WtcVghzfpCRbGjQi+8V3OBRUyHOaX1Ul
         zQkhlkmS36N3LQUxyuQe+B72EkgUw/RXaddzBP1PCkl1IDPGhq/1BcCeuoyYeJGoRkZX
         7p6Q==
X-Gm-Message-State: AC+VfDzkyTObnwEdvAq5RO9Pt6xvUZav2BtbChnsqm3VCTR/OupQRL1U
        BZsGJJYwmOVgefrwutwapNkdSD+UIu9hM9El570=
X-Google-Smtp-Source: ACHHUZ7idZS3nGS0DkQmkhqX2ZSUVTjY3GYuAVz9kd+gohWAtXgNwQpsNjx1FQLF1cyTr6TteIlIZw==
X-Received: by 2002:a05:6e02:1d9b:b0:32b:51df:26a0 with SMTP id h27-20020a056e021d9b00b0032b51df26a0mr10042992ila.2.1683731873752;
        Wed, 10 May 2023 08:17:53 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t12-20020a92c90c000000b003248469e5easm2399300ilp.43.2023.05.10.08.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 08:17:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     =?utf-8?q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>,
        Michael William Jonathan <moe@gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
In-Reply-To: <20230510143927.123170-1-ammarfaizi2@gnuweeb.org>
References: <20230510143927.123170-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v1 0/2] 2 fixes for recv-msgall.c
Message-Id: <168373187265.405534.8990004306948050012.b4-ty@kernel.dk>
Date:   Wed, 10 May 2023 09:17:52 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Wed, 10 May 2023 21:39:25 +0700, Ammar Faizi wrote:
> This is the follow up patchset for the recent issue found in
> recv-msgall.c. There are two patches in this series.
> 
> 1. Fix undefined behavior in `recv_prep()`.
> The lifetime of `struct msghdr msg;` must be long enough until the CQE
> is generated because the recvmsg operation will write to that storage. I
> found this test segfault when compiling with -O0 optimization. This is
> undefined behavior and may behave randomly. Fix this by making the
> lifetime of `struct msghdr msg;` long enough.
> 
> [...]

Applied, thanks!

[1/2] recv-msgall: Fix undefined behavior in `recv_prep()`
      commit: 05c6317367cab6fd4b8cf38c68cea1563bf31c5f
[2/2] recv-msgall: Fix invalid mutex usage
      commit: 09c3661278bebb8431fbc10ed213e42181e7cac7

Best regards,
-- 
Jens Axboe



