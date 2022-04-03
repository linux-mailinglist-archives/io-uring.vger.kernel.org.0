Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C01F4F0CED
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 01:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376646AbiDCXTe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 19:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356897AbiDCXTd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 19:19:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542B338DB9
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 16:17:39 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m18so6771993plx.3
        for <io-uring@vger.kernel.org>; Sun, 03 Apr 2022 16:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=bIa5xWDPxuyul2rkrLO1LeW/piEmi8gdCVs7L7VR+JI=;
        b=32JsNpPHGrLJTteAeg5+ttk30J249hK2S0ivN4Iu1e5dlWvZZ/8CsHbPmkjXhld4Od
         obP0k5R+2RXEJGktVarnW/QQCWVyozAI/o8jjYD/WM1KQvvqdY7XDROLIrlf+le8m/zO
         or9dEt2LFUnelJACpMLbxjZIu78P2Ufa5aryCI8GCYzkFYWEzF8/vFN1I1Tl1/M89lDc
         DI0xbs1gWPKneEF/BHNA9FD2YynB6FDPpvwUOl12D6gGJjy5Vz8VJoDqVJXL3wA0qc0I
         WRd1qwONvn7rZUMKfreKcEmgE0OnH6Z7c2a9pKrxeyno+N+8myZgYAp6+VuFn1ppfk7K
         hvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=bIa5xWDPxuyul2rkrLO1LeW/piEmi8gdCVs7L7VR+JI=;
        b=PylJcgvZ5QZI5X7pCXBt/dHnYR8SFejubFPaW/e2Spu/es8QK3MMSV/CKqntrU4gc4
         3VODefCh+iGhZEPyxh8ggiSXey5j1+9cppfdbJbmOVks91dCymZQfOV2HooaAsWQ6z/y
         ziMGcC0hvUjt4GCWLSNPwYdBbzVurmsfKJmZk2PAH9sxjTSAkMd4dgoCJYfJ8qA4iX0z
         sbRwNtFS6DFP4QccJZnkJ8nEZDOw08yn+X+vdfFnFeXEJ73u8n8qzMHdArv18S0gFoT8
         +FD/cZHyqEcpAEEmbMgIRCVzIxn5MuzyzBKkDgLKKLz6jC72+OodbmNooLBeHUucrVoO
         NiKg==
X-Gm-Message-State: AOAM532l4a475GVERB/trV3eewHT5JW6p1EZzEF+02/y/NqkuzDfHA3H
        7oK5nbhtC3dkhqxgXPYx297wSUbcSy0iJQ==
X-Google-Smtp-Source: ABdhPJwFFGeQetow1gIbusy36Ku3i03rHWD6zGHcR55IkHsLC8jadGSz1XCBcLYSD9QfSSkJjIC8dQ==
X-Received: by 2002:a17:903:1c7:b0:154:1831:1f76 with SMTP id e7-20020a17090301c700b0015418311f76mr21143497plh.0.1649027858593;
        Sun, 03 Apr 2022 16:17:38 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d11-20020a056a00198b00b004fa7da68465sm9768546pfl.60.2022.04.03.16.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 16:17:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
In-Reply-To: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
References: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v2 0/3] Simplify build for tests and gitignore cleanup
Message-Id: <164902785785.163860.3352688414836138819.b4-ty@kernel.dk>
Date:   Sun, 03 Apr 2022 17:17:37 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 4 Apr 2022 01:21:57 +0700, Ammar Faizi wrote:
> This is the v2, there are 3 patches in this series:
> 
>   - Rename `[0-9a-f]-test.c` to `[0-9a-f].c`.
> 
>   - Append -lpthread for all tests and remove the LDFLAGS override
>     for tests that use pthread.
> 
> [...]

Applied, thanks!

[1/3] test: Rename `[0-9a-f]-test.c` to `[0-9a-f].c`
      commit: 20b5edad904af8873ed06f683dee6dbfb05d9fcb
[2/3] test/Makefile: Append `-lpthread` to `LDFLAGS` for all tests
      commit: 664bf782a6d78f701301ef6ebdd7cf63b2e3ee09
[3/3] test/Makefile: Append `.t` to the test binary
      commit: f200b5bba7017de7658bd44441322949182a4749

Best regards,
-- 
Jens Axboe


