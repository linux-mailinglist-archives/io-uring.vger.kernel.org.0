Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787CE501C9E
	for <lists+io-uring@lfdr.de>; Thu, 14 Apr 2022 22:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346287AbiDNU0w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 16:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346285AbiDNU0u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 16:26:50 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281852B1
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 13:24:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id bx5so6090887pjb.3
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 13:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q82VN1yMiUO0hCAz3FOrmCha5EABFIA745iWkKLrBbE=;
        b=Dt9UHrkRGBKbUn3gkh6iiwkVBFHpwhnfBeVWPCglG5YI4F7oejkOwSdUYmEO5Np/uI
         j00akjurfnXkcEm32cky9UQE4Gi+/JJj8OrB6iZ4tUGz0lsG4ettlqMf2loH3fDiP6lN
         Palu4ZriIJwdmp4NxUN76SXNKvmLqAUl8piY4+1OKzTgVX8Xigb+ZI1bxccK0MMBnKnB
         cvmxfMiv9cY8ub+M22/cgN3YOtmjtudQPieX0RvO8tP5ciGiQ6jXo4AysGh+7mYyw+J4
         EXZH5byMU9L0EzvE75ouphzqv/9rwhAXqsjAqDIYeU4q9ATLPl27hZ0S6boTSpaGXI7t
         RD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q82VN1yMiUO0hCAz3FOrmCha5EABFIA745iWkKLrBbE=;
        b=xzrMUJTX9goNuHVyqh53LFubjJLkwHwJYhOXg7YvHbjriC59lmYdoH2sTqEqE50Es1
         SzilYKG9Ry7HyHtNtN0ETthBi2hHyAps0gyimkkDLEu/9saG623L6ztj1tmz/z6RJVk/
         KOByWxSL+TzPNyCS1u1kfuW6MP6hYeDYlw9yActxt93ZqgP1ZocCVUAWcu3dGooBuM6f
         uhf7pfhR0AcPrZe0BCl6EjZbNJHqkpyaHe9pQbfjtxJimdMRnnY8bBonhquwVygGaLwb
         6dUDAfOVMq0PjFQiEzZKoHK/JmqfnGSqHFarQiqni979/ZB1KD//YDJ96fK/XgCjqXJ+
         xmng==
X-Gm-Message-State: AOAM532n2BjNQ1A6iRg481PKO0GpdtYZWQ6WztiPzxdzjTsvg1/JOKSW
        cllbCPPbB1BaUkK1yk/QRyNJHcwceu6LLA==
X-Google-Smtp-Source: ABdhPJwT/ymzqX7MCCe3BLQusWzZixoNZQ63jdlgAGjVIg6AFI+FpdWFGHlQODrNZGLjBKdR+a3aDw==
X-Received: by 2002:a17:90a:aa8a:b0:1c9:bfd8:9a90 with SMTP id l10-20020a17090aaa8a00b001c9bfd89a90mr355653pjq.118.1649967861498;
        Thu, 14 Apr 2022 13:24:21 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id v16-20020a62a510000000b0050759c9a891sm689365pfm.6.2022.04.14.13.24.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 13:24:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET next 0/4] Allow cancelation based on fd
Date:   Thu, 14 Apr 2022 14:24:15 -0600
Message-Id: <20220414202419.201614-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

We currently only support looking up and canceling requests based on
the user_data of the original request. Sometimes it can be useful to
instead key off the fd used in the original request, eg if a socket
goes away.

Patch 1 is just a cleanup spotted while doing this, 2+3 are prep patches,
and patch 4 then finally is the meat of it.

Adds IORING_ASYNC_CANCEL_FD as a IORING_OP_ASYNC_CANCEL request flag,
which tells the kernel that we're looking up by fd rather than user_data.

-- 
Jens Axboe


