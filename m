Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8677E76A611
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 03:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjHABLY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 21:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjHABLX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 21:11:23 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDABE71
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 18:11:22 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bba9539a23so6799015ad.1
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 18:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690852282; x=1691457082;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iEDpUQYa1sYoZpIoyPnzMOH94o/93Z6XlJyNk88m9Dw=;
        b=S4hYK/eSdBZ04vvgXn1rSU+1Z0mmrGFHPqq2+ElrnsJRWggw8Jte9SSLac083X7+b8
         Z6mi6l/LsueAomjRGLLNzALEwrEUF8e/Wdnw38ZEk5V2O5BFdElGgr7fGA/hMw50Vcd9
         waP7o4l7kfW0zBk33udzTjYvbQeWvKtgtxE6h2LgZuNNrLNOtyXRXlP1pvXldfsS1QNM
         ot7OVDA0MflrqcG2+ApxkvbtHMl0oQ2IU68/FfgDiWHNXsvKIPE3nVEUlCBCC3yHDXPx
         XAVfsvR0aZBIIEf/wxPH7LultbyYg9CNTsuqNvngjNTEgJHgT4i2j0C6vsxaPa2p2Pwz
         Doyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690852282; x=1691457082;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iEDpUQYa1sYoZpIoyPnzMOH94o/93Z6XlJyNk88m9Dw=;
        b=gOZ+ZYzD3MGl7Gpz/YOYSGJNZucAVWGj8zwsgDz11eZO/oZOUWyiOr2XK2Dkuu1TUe
         fXu0h5cUTCxOstMB56fvWiEifJ+7upfz1rnexEyvvmDDZJJL39VFWdv18+u13c+QHv6I
         qoezKgpcYENoqcaNttLaiZYuKa52ZmBYycvLIw2qSWfw/HFnAUfLYPNk1sYaTG4o6tv9
         +79ATd58E8UB/en8iZfeWMQ5gO3PFG7U9Xmj/1hb1GiKGlki2mF2hvf47gqPA6nD0xhP
         do1bqEyOHBpOyV+T33RF7u1+cvH4BCAQt56g9rYw2xCH19jP7uPpqQg6LCfB9HIzgIGw
         QD3w==
X-Gm-Message-State: ABy/qLaN27F5IZzYVaKXWbnAT7atmuD6LxKkJY7gk9WKGxx0DTP5pBji
        Mla4i/4yXdsvnkctdH+RqTEGzA==
X-Google-Smtp-Source: APBJJlGG2/+2f/wUdNe0NwNOe0XNaryQK6905qsBBZDsx/NkmWnGD32Vq8w3tM6bfUo/lhTZ4WzPuA==
X-Received: by 2002:a17:902:ea04:b0:1b8:17e8:547e with SMTP id s4-20020a170902ea0400b001b817e8547emr10250653plg.1.1690852282175;
        Mon, 31 Jul 2023 18:11:22 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q10-20020a170902edca00b001bbdf32f011sm9014136plk.269.2023.07.31.18.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 18:11:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Nicholas Rosenberg <inori@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
In-Reply-To: <20230801010434.2697794-1-ammarfaizi2@gnuweeb.org>
References: <20230801010434.2697794-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing] github: Fix LLVM packages conflict
Message-Id: <169085228161.30140.1864539026063442003.b4-ty@kernel.dk>
Date:   Mon, 31 Jul 2023 19:11:21 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 01 Aug 2023 08:04:34 +0700, Ammar Faizi wrote:
> Recently, the CI hits the following error:
> 
>   The following packages have unmet dependencies:
>   python3-lldb-14 : Conflicts: python3-lldb-x.y
>   python3-lldb-17 : Conflicts: python3-lldb-x.y
>   E: Error, pkgProblemResolver::Resolve generated breaks, this may be caused by held packages.
> 
> [...]

Applied, thanks!

[1/1] github: Fix LLVM packages conflict
      commit: e1e758ae8360521334399c2a6eace05fa518e218

Best regards,
-- 
Jens Axboe



