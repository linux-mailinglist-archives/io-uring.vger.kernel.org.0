Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D1B4F0A67
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 16:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243315AbiDCOyR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 10:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238092AbiDCOyR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 10:54:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BA0396B6
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 07:52:23 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x14so3230440pjf.2
        for <io-uring@vger.kernel.org>; Sun, 03 Apr 2022 07:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=TktrjPQ6SNSyOGXcLVNrcH5y7KaEIKbExcVu4XufANM=;
        b=14OxZ0u0ORP5/HNKmMmxOPYuBKQEbVNAS6O3dWDuNPdN51yUHop3LzOoTgrVgamk1C
         qo46JFzlyYPf/KA0YNS4bS08Lk2IP7DFR9iSO1l/wBtN0iFD2IxmLGdS5pcCd3EVNmlq
         YRuOeWDoCqbRTdcWdnrs38jmmUJltz5FuZD/xUHVBqc30u/MjV+PYKn6gu6H/mm0dxoW
         MENt0NxP8YjFVydBFWAuyqcE5/mDYKtjL4+8LC/ZqtijbfaMJIDTYCDvDX9Ny/hbS9fE
         a9LRZnkI4ifofufSQjIQF1lCxPxhlqw/nFKSAkH8k1pWlAhGHj2MeegLuLzSegEu0Z7H
         Xbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=TktrjPQ6SNSyOGXcLVNrcH5y7KaEIKbExcVu4XufANM=;
        b=sBzi2MOahcPb4D6u02VFEiCH54P3WYdAQ67j9HAzCHt5lhb/NqAfLqYsuHITqJf2jQ
         +bIvjKyjej9STFRaMYC+jhECOyjV0JyVRmb/3WRCF4G2PGnI0XxogGx3WNl9nOdqKCpi
         3JmcaQmswL6spihnI1mOUbhHbtRdrfmJSDOX4+ibU5W9dfr7K6A3QjOnkrnehmm3DpyY
         BEMSBk4pQUqiQVUMn2unGMSfeHEXSBHJCW1BL+wlJRSKDBQlC/ndJVAiIfXzKHglIMl+
         m0Hme2DMKHKJd6P0LEWxTAaMDAThzhab78WzEyqiX4B9txnozlYWIiCXEwpEDHjtqn3a
         fpCQ==
X-Gm-Message-State: AOAM532qmemLEXBiDP//DUs9d9kM9a3xbjcvDBUv4SpiPt29uOdvyMPr
        rtVzMHSXjBTWzEgNi/bsSjZxTg==
X-Google-Smtp-Source: ABdhPJzJfTpRe8DiFxizn2+O/uMSQkSn4rlAqmTLOyN8/SFw0HyEVsgwOS806gVsqm+i3wFG3dsjng==
X-Received: by 2002:a17:903:2cd:b0:156:780d:5b69 with SMTP id s13-20020a17090302cd00b00156780d5b69mr7286492plk.156.1648997542812;
        Sun, 03 Apr 2022 07:52:22 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7820e000000b004f7134a70cdsm8854126pfi.61.2022.04.03.07.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:52:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
In-Reply-To: <20220403095602.133862-1-ammarfaizi2@gnuweeb.org>
References: <20220403095602.133862-1-ammarfaizi2@gnuweeb.org>
Subject: Re: (subset) [PATCH liburing v1 0/2] SPDX fix and .gitignore improvement
Message-Id: <164899754199.19498.13604605286814558883.b4-ty@kernel.dk>
Date:   Sun, 03 Apr 2022 08:52:21 -0600
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

On Sun, 3 Apr 2022 16:56:00 +0700, Ammar Faizi wrote:
> Two patches in this series. The first patch is SPDX-License-Identifier
> fix. The second patch is a small improvement for .gitignore w.r.t. test.
> 
> When adding a new test, we often forget to add the new test binary to
> `.gitignore`. Append `.test` to the test binary filename, this way we
> can use a wildcard matching "test/*.test" in `.gitignore` to ignore all
> test binary files.
> 
> [...]

Applied, thanks!

[1/2] src/int_flags.h: Add missing SPDX-License-Identifier
      commit: c0a2850e7192edbf3679265db20e2fb2a828e830

Best regards,
-- 
Jens Axboe


