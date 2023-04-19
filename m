Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0C06E7F90
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 18:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjDSQZ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 12:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbjDSQZ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 12:25:56 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5447F10C1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:25:55 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b9f00640eso15030b3a.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681921554; x=1684513554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=toVfklchumbtFrUnA8SGKenhZ6u9CN2GQvMh+PIxLnU=;
        b=pQr1pGnqNy87qdfU9RZio+rczwJJWLDerbqQqN6Zjs3oLadyydN4sntbuFsQ9j5GNU
         ibhVm87wNwwgdlna10ArA6zoxTcqtWvyKc5OjCZBVBmM0uYthe6hVJlC3WYQTbRkS65/
         kmKeHJPRUTj4ub5OFwsh7rciLApK6jlk8SuW9mDnpVS8t6ZGJuWeXANOKPwG/f7h8jZw
         oaDI7ocZDDpaOxRqw7JAjVGoADs1h4b2NRlFZim63KA5osWUWEK8k+S7q10kiAwrbXQK
         C1oQwYwNHFz9oSuuguwrT7aHFj1aJM+LN7+LeIUP8SKSHl+Zk+MxqNm9usE7Mih2Q3pH
         sQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681921554; x=1684513554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=toVfklchumbtFrUnA8SGKenhZ6u9CN2GQvMh+PIxLnU=;
        b=es+xQYf4DviclDKB6yWVCOLpTdmZGgiHb+riwHKZ8vyF3/UOt1KdIQveuzBPObi6TM
         bNh6Rfwx+ub9THKtPUHBdpw7yKLC8PtDuWe0PzGCBSB12JD8pw+o8Cz4f09bsLXCIPgP
         NNO+DQZx6gazTpMpcst2hpeBSTL3ExEKo0Bl+j0X7+GVLWmO4vTmXWVXw7tueNEN9TW6
         joxR6PclzIC0tct33xpZ9yRSPxyanEOw+PCK7htLDO23/4f6dZXTacintmqjIxJ58JEH
         BsUkQcoXfBzxpB2XzdhlHUdXWHlb3FDHwRT0wB2Dh7+kmspcMX2ys+D2CFGPPsxd6u5J
         ERpA==
X-Gm-Message-State: AAQBX9de3lsZKPuqP8Hnva732vwB07RlOkqP/sg2LtHSyznF1TGmu4cW
        n1E4y/WErU5mJItNPItVSE+7c6m9+O5/RbpakFU=
X-Google-Smtp-Source: AKy350Yw4b+6XW41a1yAeBKFRZu2u7N60Q6CLryeKLg4Bd0/epoats4Ax3xHk620iAAHZ0t36cZhdA==
X-Received: by 2002:a05:6a00:338f:b0:5e4:f141:568b with SMTP id cm15-20020a056a00338f00b005e4f141568bmr19984244pfb.3.1681921554503;
        Wed, 19 Apr 2023 09:25:54 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k19-20020aa790d3000000b0063d2cd02d69sm4531334pfk.54.2023.04.19.09.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:25:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com
Subject: [PATCHSET 0/6] Enable NO_OFFLOAD support
Date:   Wed, 19 Apr 2023 10:25:46 -0600
Message-Id: <20230419162552.576489-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
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

This series enables support for forcing no-offload for requests that
otherwise would have been punted to io-wq. In essence, it bypasses
the normal non-blocking issue in favor of just letting the issue block.
This is only done for requests that would've otherwise hit io-wq in
the offload path, anything pollable will still be doing non-blocking
issue. See patch 3 for details.

Patches 1-2 are just prep patches, and patch 4-5 are reverts of async
cleanups, and patch 6 enables this for requests that don't support
nonblocking issue at all.

-- 
Jens Axboe


