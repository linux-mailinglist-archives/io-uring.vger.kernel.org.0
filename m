Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4D16D34FA
	for <lists+io-uring@lfdr.de>; Sun,  2 Apr 2023 01:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDAXU4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Apr 2023 19:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDAXUz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Apr 2023 19:20:55 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B9FAD09
        for <io-uring@vger.kernel.org>; Sat,  1 Apr 2023 16:20:54 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-62810466cccso1426628b3a.1
        for <io-uring@vger.kernel.org>; Sat, 01 Apr 2023 16:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680391254;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p33tA/nFj3CEaNdstFAoU0QaM2pQQzwoFAgildZYSEw=;
        b=bVyLvTH8UvkkxHjcCdN5ObSiE7bMq49Pr0QySiYvNwYgm1JKhV4UTF7KB1OwV8QZoP
         nLuFNWV6M3pZsDYhQLKJNyJZvedoQvMp4cf72apuJjpZ0DpGxLHXMCCaUUoDhgt9cTRA
         EwVORlwQu4b+rAli8MqfXXkS5BrS1VxrysOslgQTR84yjYCtegQ3rDDVgkLz+QZiSbp0
         0qUYlk6H4bb01K+MGdomSegcI5aVkI3Fi1zsHPVzF1KZATW8sr6GBybvacYDb9q0ayAk
         06KWGnWlTTETflgcXhYLRIdgpcca5rwTuuf7wmlj6Uap1VA5+nYNWVoPjzk0dHB0qfGW
         xDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680391254;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p33tA/nFj3CEaNdstFAoU0QaM2pQQzwoFAgildZYSEw=;
        b=o1QJgUfPfMiiV/L5tn3wE6XD/ycuoZAXLxusLnnxH2LKyaGb8vIGszCyfFqCJLqNSX
         4IgKCPn75RIaINjXblAusa/xeWYtWHyhdb+I2mOvvBqoRsDmRdMM4mZ7Xo/43zgSVpoF
         sfC6NMwtnJ9gRLw9e0hB1m6VBxpHDR3t61lJaRvCrNx3tZOi3h16M8rhDJ2R4DGWdpty
         8Ckd+DCssQrq0PA72BnrNGLRL8mw9V6y0CJG9yURsDUGrJfRUpTilaJgadXRafl7uMuj
         uG9DR2dceA53/4BynAAzMIxTNDtfwSeOXZPXPC3MgU/QqK0QHGKjEkidSasnkHPHpU77
         q0jw==
X-Gm-Message-State: AAQBX9cP0VDLnRaaRtrfyuvzjsV+jOtJGzCFPphxlJWaDrgSsxw3cVvB
        UmNAa0BDTuY+t7G3PStraMcYknY6BoYquT9QWYVUtw==
X-Google-Smtp-Source: AKy350a8Wcw6tWB3gIxsMl3K/GxLTEtyRKJmd2PvjrhDAlXvkil2Hyi/6/j/lbdrQG9pqbswUVyYCQ==
X-Received: by 2002:a05:6a00:1d11:b0:5db:aa2d:9ea0 with SMTP id a17-20020a056a001d1100b005dbaa2d9ea0mr10561578pfx.2.1680391253772;
        Sat, 01 Apr 2023 16:20:53 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 144-20020a630596000000b0050f7f783ff0sm1797712pgf.76.2023.04.01.16.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 16:20:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Wojciech Lukowicz <wlukowicz01@gmail.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20230401195039.404909-1-wlukowicz01@gmail.com>
References: <20230401195039.404909-1-wlukowicz01@gmail.com>
Subject: Re: [PATCH 0/2] fixes for removing provided buffers
Message-Id: <168039125320.142010.1136960342928786181.b4-ty@kernel.dk>
Date:   Sat, 01 Apr 2023 17:20:53 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-20972
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sat, 01 Apr 2023 20:50:37 +0100, Wojciech Lukowicz wrote:
> Two fixes for removing provided buffers. They are in the same area, but
> otherwise unrelated. I'll send a liburing test for the first one
> shortly.
> 
> Thanks,
> Wojciech
> 
> [...]

Applied, thanks!

[1/2] io_uring: fix return value when removing provided buffers
      commit: b4a72c0589fdea6259720375426179888969d6a2
[2/2] io_uring: fix memory leak when removing provided buffers
      commit: b4a72c0589fdea6259720375426179888969d6a2

Best regards,
-- 
Jens Axboe



