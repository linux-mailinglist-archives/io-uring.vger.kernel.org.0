Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0967B64A871
	for <lists+io-uring@lfdr.de>; Mon, 12 Dec 2022 21:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiLLUKg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Dec 2022 15:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLLUKf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Dec 2022 15:10:35 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1964EBC00
        for <io-uring@vger.kernel.org>; Mon, 12 Dec 2022 12:10:35 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id z9so3944509ilu.10
        for <io-uring@vger.kernel.org>; Mon, 12 Dec 2022 12:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=duVg7YE8kXobQYG89edMgB9ZK3Pd44ubaYu/ZnbS5Ms=;
        b=0eOQpFAKdhAY23J8uN8pdqNtoji/zWW2Yt5oQ4Rk8N1AZTCrpQg460mjt2prb94gK0
         P23i4zq6LRMF1enxdKD21S6WxloFUQt1g0AkmjsfKIPMYpFWD64hXe0f7IQYrgvtaZZM
         exrU5vEIFJvaaiVSooukIjLZLf2MoZ44IwqJlzCDttSBpcu3nSCO4n/Hiry77lpjYJZf
         jLVRuFGqOnB+6nQ6PBNa4ohRhqIDBVCWi4/R4Po4vUq+8ktePNkCMdpmrOaWDpDbJcGR
         AGA3G0OqxMTN11uh1AvUO6KYAlB5h6xgH0QPoEFCzDei5sWDhfwHcfg44+2TF7/cLjpY
         uBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=duVg7YE8kXobQYG89edMgB9ZK3Pd44ubaYu/ZnbS5Ms=;
        b=DpBwKvmCb/C4zVxT2KWDw4CIrwft7wJMoatuSBa66cqRYtrT6wJ4ucWmAu3AFwkPcw
         RchT2TlRx5qokwiruOAS7MazEVuiS5gNnkcriUwUbqoGSAPoUtYB/b79gilauejTwHAT
         yxKc0pfY35DJtAy35xvBXpRh7oEE2C2D6GnjaBOW2IpIC4AkzuAmIBwFJhogLOUMF4Fl
         vjO0qZLLt6vxkahU7e5i6JYtLXh2Ic6sMACDYw+J8No6ew2WVrykjLisDzhEU4dmJ7XO
         3WSXB3BphDo0z3BYFtUZwk1IY/pnJ3J+wcrIOSNcL9Xi1pTwkOqZNbLjA8yOu+wtXggM
         gX9A==
X-Gm-Message-State: ANoB5pmRn/SWUd9ecMsvYFnRCK3rOBhztiac6E6CmDwENI9vlMq66uBE
        b86/xAZutZKpbs7zt4MqNoH6AY+WsQgMVIsP7/4=
X-Google-Smtp-Source: AA0mqf6aNVtOH3Ye/8SYQl6RstdFYdnav6OcK6a5Qaacve8kwG+Cxiko3Qb+kMNPHIiVyCq0oy5Tsw==
X-Received: by 2002:a92:cd8d:0:b0:302:d99a:bfd1 with SMTP id r13-20020a92cd8d000000b00302d99abfd1mr2735864ilb.0.1670875834339;
        Mon, 12 Dec 2022 12:10:34 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u26-20020a02b1da000000b00375f143b0c2sm218397jah.8.2022.12.12.12.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 12:10:33 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Yuriy Chernyshov <georgthegreat@gmail.com>
In-Reply-To: <20221212125121.68094-1-ammarfaizi2@gnuweeb.org>
References: <20221212125121.68094-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [RESEND PATCH] test/sendmsg_fs_cve: Fix the wrong SPDX-License-Identifier
Message-Id: <167087583333.16472.16779657643774982927.b4-ty@kernel.dk>
Date:   Mon, 12 Dec 2022 13:10:33 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-50ba3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 12 Dec 2022 19:51:21 +0700, Ammar Faizi wrote:
> This test program's license is GPL-2.0-or-later, but I put the wrong
> SPDX-License-Identifier in commit:
> 
>    d36db0b72b9 ("test: Add missing SPDX-License-Identifier")
> 
> Fix it.
> 
> [...]

Applied, thanks!

[1/1] test/sendmsg_fs_cve: Fix the wrong SPDX-License-Identifier
      commit: 4458aa0372738e844008397f71c062bd8bfadcac

Best regards,
-- 
Jens Axboe


