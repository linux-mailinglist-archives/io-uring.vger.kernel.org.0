Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E214D4F86AD
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 19:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiDGR5J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 13:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239237AbiDGR5I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 13:57:08 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E2622F3DA
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 10:55:07 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id q11so7736023iod.6
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 10:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=6bglbZez7qX+4ahIZRP8tPyay3820xxGQG6wS6Ijfx4=;
        b=0AKAp5aRBQDMf/r5yBNrUvYuYBYhuGK2q0J+Yi/wo7KKmKdDJYfrPqUGzxjaNdwCXh
         f/RNfFsM5RgRYFUwk7ZNWK2R1W+zE1J+FTQ8sI+IX2SyxwBROGGdhxDU6LnVfmkdcKNa
         XunJ5s4nD3JZCYISLBYjKqQBCW3f+dRsV6mUjb5RV3U5NGewVmSIxvpc0KIAx8aYlos1
         YKuVpNEFKH80dq/Arm3cQYJ23vBn3uUIObrlNfVqkSzNUAGULQHb6RDE2iFuzsCj2KqG
         fm7fc82vsOItY4AOKmgROHk7LguxxN4rG7KCtGhVQiVA6kpe1Ye0VEIRHSNOfPjLn06N
         /sSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=6bglbZez7qX+4ahIZRP8tPyay3820xxGQG6wS6Ijfx4=;
        b=2x4NUJjQMcOaJviR31ydealCSSj5dj90iPBxaP6wqwbxDdUuHOjk4Fm9hjjtJaXbw1
         6VOCIIVVYDyTxSRuLKiauv+hfdrN/VAfQbtNnKgDMszy8yylvgciu5O44AzyQ91dSnD7
         9DGrpFhft9OTkGXezsycPnpvYSpQLoe1H+BJH0RFJ/VaJq0Ga3klZKf4SFltD7wNeMYM
         PZOp9IIl8pVv4hHlnOUm2OjQcf272g4KDAvJbId4T0ZYh/qpP8JdT12z8iDUtEOLO2c3
         UG5sxCB7EDHUecZqJir35obg6J3jl3Tike+rc3PSsBGZzNjtS0vhK+7Mq+PDcCZH2A3L
         1nSA==
X-Gm-Message-State: AOAM530jMFRidsCq8Hw/KiwUPswxCARjgdj2ju3D/U/MX45oPHQ1RPEN
        ShdruWiULpV9hheU/Uj6ou3KonRn0BjFAg==
X-Google-Smtp-Source: ABdhPJwptGrTGqXg2wgs2kAwl4R67dxAg1BIcflzdzagBByPiF2tQ8OrkdSdV/G/vao0X8EBOUZh2g==
X-Received: by 2002:a05:6638:144b:b0:321:589b:a8ea with SMTP id l11-20020a056638144b00b00321589ba8eamr7677913jad.296.1649354107150;
        Thu, 07 Apr 2022 10:55:07 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s7-20020a92c5c7000000b002ca7e65f3d7sm934790ilt.56.2022.04.07.10.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:55:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1649334991.git.asml.silence@gmail.com>
References: <cover.1649334991.git.asml.silence@gmail.com>
Subject: Re: [PATCH next 0/5] simplify SCM accounting
Message-Id: <164935410648.218477.4736604874036916352.b4-ty@kernel.dk>
Date:   Thu, 07 Apr 2022 11:55:06 -0600
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

On Thu, 7 Apr 2022 13:40:00 +0100, Pavel Begunkov wrote:
> Just a refactoring series killing some lines of the SCM registration
> side and making it simpler overall.
> 
> Pavel Begunkov (5):
>   io_uring: uniform SCM accounting
>   io_uring: refactor __io_sqe_files_scm
>   io_uring: don't pass around fixed index for scm
>   io_uring: deduplicate SCM accounting
>   io_uring: rename io_sqe_file_register
> 
> [...]

Applied, thanks!

[1/5] io_uring: uniform SCM accounting
      commit: b302191999697ac6972c70d38d16a8a3e9546216
[2/5] io_uring: refactor __io_sqe_files_scm
      commit: daee35f002ecabfaf6b9c6d5adc727b40aeaa048
[3/5] io_uring: don't pass around fixed index for scm
      commit: 6c5f2c03659346f28334b3c757c8e752d96c41e2
[4/5] io_uring: deduplicate SCM accounting
      commit: f8b9357ae7788235abc84ffc8fe1c66e8607aa47
[5/5] io_uring: rename io_sqe_file_register
      commit: d9ed9fcf4bd6b8997d7e7533b650e18fa6273ed1

Best regards,
-- 
Jens Axboe


