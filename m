Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC66466B226
	for <lists+io-uring@lfdr.de>; Sun, 15 Jan 2023 16:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjAOPiK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Jan 2023 10:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjAOPiJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Jan 2023 10:38:09 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40D8C66C
        for <io-uring@vger.kernel.org>; Sun, 15 Jan 2023 07:38:08 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso28890891pjf.1
        for <io-uring@vger.kernel.org>; Sun, 15 Jan 2023 07:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QOLLt/AgarnsEi8wtpFns6047FYGiFoqRAoVOMkf78=;
        b=1dloYt1ncy975LIBvXlb8bdI119j0ILdmPLfntQgM2rIWn+qOYtRJJBCqyBgmX94hq
         7OWs81xwiGJNNCp30EuwPaXgAyegqGslUuEOOlysufymT19JmjCLuYbEXMawxmCMokbQ
         OGts3s2cs4gmdy2Pi6AEWQfPUmxMnsnmSKij5l5YeKTC+HezEMw4rLkAlvk8BuS7mSw8
         9KSZIME6AXHC32eThUqQiDAG9NjGx6fNBmttgHOBQtRyc6aJW35RFkqUpmzvZVmIotwZ
         CmfmPrFH7N7GhDTbXMNVAaAWz18ZPmmL882flGQh8zvsChGCbUMIzgvv0LWWf0J79xAh
         iTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6QOLLt/AgarnsEi8wtpFns6047FYGiFoqRAoVOMkf78=;
        b=0d5AVafrPm4XTpQsmxWK/4e9yNNAn29j9VG+T2vj9M219tC93RHiVFyX3Tcn5xc9wi
         imQvIcH1dR7xUGAu2RyyDiSHFjjAE3tv67qj8sleKLDOFvceuOBU78ltI4W1buogRJc4
         oEdCygW0e3rGfZZ7fhLZCyzddNGrNRVEDL7P3L3WdYUiiV4rRWrVDcXFzUuGBIjleBHC
         0WOQu/uCVX20Cb2QGy05XtEUVpfqGDRpTv8WCZFrX42+23u0w/4tAh234W4CEcsoDA5T
         vhyqV91kwOcbEiuxmYZViPLUUgmSHq0uPapV8eHv8htDx4K679efyebHKsI/EYfrlp5Z
         HNTQ==
X-Gm-Message-State: AFqh2koDgCQXoNtQ5X+Ohiupxk2TrNL03yczUbp7rrYxD/gcrUYEi3tR
        2MoF05KlN0QOSQEd9D+PS15OBdBUZX32V6aj
X-Google-Smtp-Source: AMrXdXseWfZYCInUIQnnmf/FJ1bD08hOq9FUPA79HcigY0YKSzRxFd4xRAmF0O2mkcfF/zwS/NzJgA==
X-Received: by 2002:a17:90a:f0c9:b0:229:560:9ffc with SMTP id fa9-20020a17090af0c900b0022905609ffcmr3000035pjb.1.1673797088022;
        Sun, 15 Jan 2023 07:38:08 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n35-20020a17090a2ca600b0021904307a53sm15673165pjd.19.2023.01.15.07.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 07:38:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, Quanfa Fu <quanfafu@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20230115071519.554282-1-quanfafu@gmail.com>
References: <20230115071519.554282-1-quanfafu@gmail.com>
Subject: Re: [PATCH] io_uring: make io_sqpoll_wait_sq return void
Message-Id: <167379708711.240357.6386972081559602417.b4-ty@kernel.dk>
Date:   Sun, 15 Jan 2023 08:38:07 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-78c63
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sun, 15 Jan 2023 15:15:19 +0800, Quanfa Fu wrote:
> Change the return type to void since it always return 0, and no need
> to do the checking in syscall io_uring_enter.
> 
> 

Applied, thanks!

[1/1] io_uring: make io_sqpoll_wait_sq return void
      commit: 19d49cb3be0d03cd19f02fd5a0760a53bcc2ae25

Best regards,
-- 
Jens Axboe



