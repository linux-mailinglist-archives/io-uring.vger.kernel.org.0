Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EBE5272A3
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 17:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiENPct (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 11:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiENPcs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 11:32:48 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF545F95
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 08:32:47 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i17so10591631pla.10
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 08:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=TLWRt16VhqFn1JQPTa9IF93uwbgfE/0VX4zSO4XY8DU=;
        b=VCCdKnTZY1Po91T2is+mbHS9tI20YGT/alEE7rhQ06SD7Iyx+GnbdkBI5WSWIpw6cY
         QSCUqoGieVcqrpfagSlPLEcEw3wPzSIT0u8HWecSWgTVP11HXWFRVgZq9sbTHtV9jtEH
         PaR9kR1bSnB97YmIaetQ1/PXydd/ex3rhxbPBxbuuhJLvEVQxAB63YC0oy6zUKwhOk6y
         lU4/fbTzfHx11wn1g5qKBMEiN/IGcHPU8H5erFEyZKwcKxLubAHB4uESg0DxWrUatIOU
         JSr1jakwgDeGfVaSCL4YvBWyfYCJCDS0BzE3cAJRwdCfRX53mcuzxWUDIHjIimR1CyD4
         gMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=TLWRt16VhqFn1JQPTa9IF93uwbgfE/0VX4zSO4XY8DU=;
        b=e1hcuU/7xVOX5FsxTgZVtRM9ax5w0/O8L9dgN6e1v118YJwlZ8HA/0H/XT9vE4OtL5
         WB+IWj+K+AsgztQl9lXWUhpoZy9biKtDac9DLvqLgv6ulmnKssiiCj1wK0hVLuHCswo0
         y3KX3/TkR7D+OMiY5m5hA2FJhult8PSlHU5OiwlnPDUOgIIOZEPFr1IDNn4AzD0L2+fW
         pP7JcTs0TPVSeOkzO44ZZNgFE8Mnr3J3D5E9j4UmUmRKeE/D7Nd7N1M0EKUV9HaQ5sKA
         aLQJ9XHQrPHuYNOlYxPrEjR07F1ii0d7SeOdgJJqDGsrMIVezlhk+rNp3UleHzkUWlra
         6IMg==
X-Gm-Message-State: AOAM533LqFdC7C67DyN23DiKguACvXVuUTsRXli6RvP/hXhLinvzPqUc
        +6EoTGnijQUjWgXEWRncYI/eVA==
X-Google-Smtp-Source: ABdhPJxuoM7UKjM4vI75THGFu/9XR2YliB4zLSCd6I3aYSYbF/WNSmwBtjLV5MrshZeUmFL/B15WrQ==
X-Received: by 2002:a17:902:f789:b0:156:5f56:ddff with SMTP id q9-20020a170902f78900b001565f56ddffmr9960225pln.116.1652542366887;
        Sat, 14 May 2022 08:32:46 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j17-20020a170902da9100b0015e8d4eb25asm3840089plx.164.2022.05.14.08.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 08:32:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     haoxu.linux@gmail.com, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
In-Reply-To: <20220514143534.59162-1-haoxu.linux@gmail.com>
References: <20220514143534.59162-1-haoxu.linux@gmail.com>
Subject: Re: [PATCH liburing 0/6] liburing changes for multishot accept
Message-Id: <165254236587.105163.8034789120219914920.b4-ty@kernel.dk>
Date:   Sat, 14 May 2022 09:32:45 -0600
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

On Sat, 14 May 2022 22:35:28 +0800, Hao Xu wrote:
> This adds two APIs for multishot accept, and some tests for it.
> Man page changes as well.
> 
> Hao Xu (6):
>   test/accept.c: close the listen fd at the end of the test
>   liburing.h: support multishot accept
>   liburing.h: add api to support multishot accept direct
>   test/accept.c: add test for multishot mode accept
>   test/accept.c: test for multishot direct accept with wrong arg
>   man/io_uring_prep_accept.3: add man info for multishot accept
> 
> [...]

Applied, thanks!

[1/6] test/accept.c: close the listen fd at the end of the test
      commit: 19b0d25193330d3cfcd636d4cc2e4ec1ec019271
[2/6] liburing.h: support multishot accept
      commit: e7c7089e352f5a6ead9c409a7d8a43ffe9cd59a5
[3/6] liburing.h: add api to support multishot accept direct
      commit: 305eb96b9dbb84a3dd3151d0debde753a354d81e
[4/6] test/accept.c: add test for multishot mode accept
      commit: 66cf84527c34acf8ea37b5cc048f04018b22ed2c
[5/6] test/accept.c: test for multishot direct accept with wrong arg
      commit: 70e40d8de2ce5e3196c84344f611ca70f34e8182
[6/6] man/io_uring_prep_accept.3: add man info for multishot accept
      commit: 9997778eed96c4ba2240c1a18773e3047be95290

Best regards,
-- 
Jens Axboe


