Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284F06E852F
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 00:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDSWsK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 18:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbjDSWsK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 18:48:10 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3B51701
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 15:48:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-2465835cf6fso44011a91.1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 15:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681944487; x=1684536487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=G2AFWVzxM0d5VyUOb3fRkyqa5yeRpyexIjMuXtje21Q=;
        b=ODnriCaPLWHwbp/Lzy4DCNCC3OZsa+mP2bHh3Ufd0ysd9Vi2dYkV2XO3NRCIMTcGZ8
         pxTfDN52mKSMR4HLUyb7/4XtIYU0ujx5V4WifEuIfUZntJXmz4uSnK5g429YuJw27mxa
         2zootqEM/uTvVLgGA2UTGTBEIi/+d0Tg59+YnvM+C0bwYQvrlAgV/7IHJFaSXApHx2Nb
         f9QCEDsit2uAP1hTPJ+eXAzuBANVaESd6yUqAvCrkGvGXpxJCNWkOIExFHXZLIVZhMn6
         lGcsIRNvFFmEt9T5Qosa7aKvxIH3ua7jDxYJQYJ6KrbzqSAXRtHOipvwZ02MDMtfPmJV
         EmmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681944487; x=1684536487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G2AFWVzxM0d5VyUOb3fRkyqa5yeRpyexIjMuXtje21Q=;
        b=lIKmzfJ9Aa1apPEmRwqMt0Vjcyl6nAf0DCzxJC/KwUnSL0ZyV09prGM6v4bjKu1143
         8JIiIHlvvaarnEjiiStXd5cLE/3ZQrAcEGmAujcRZAhtIWAko+04hD28En3/FLdhvavS
         nT7HqzUQn/fwAluCgbfy9CFGH8t4OtSZQNEidi8LxysOwdfzTvXK7agQIx+F2/kiQYZP
         uS0EzmD8Gg2YekTCrujoVOa+tUS1txur5MxBEYFGRVLODSapcru86r3DcTBhVuOwkdnD
         88w8G2zsbYaPXHTLUjaPzk11oXuNR75XhIijhlqNhg2NKJQnYlO/5mwz7zTPL90QXl1J
         O2HA==
X-Gm-Message-State: AAQBX9cS5cYawg7wqNtzGdhSsik4OGjsAG3C1ut4EDyjGA98ufU/749b
        WS/1fvelkYfBnjSrjLl/XPaGy4t3gfS8GcY2sSs=
X-Google-Smtp-Source: AKy350ZR2i1jzTcCaKC2n81zn/YGZQSRuOg/+ztYY/Q5AP/Ma2CRttc8PFRUK4rxX6Lv3EHtDCXigg==
X-Received: by 2002:a17:90a:199b:b0:249:78db:2635 with SMTP id 27-20020a17090a199b00b0024978db2635mr4337861pji.0.1681944487612;
        Wed, 19 Apr 2023 15:48:07 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l9-20020a17090a49c900b002353082958csm1853364pjm.10.2023.04.19.15.48.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:48:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/4] Support for mapping SQ/CQ rings into huge page
Date:   Wed, 19 Apr 2023 16:48:01 -0600
Message-Id: <20230419224805.693734-1-axboe@kernel.dk>
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

io_uring SQ/CQ rings are allocated by the kernel from contigious, normal
pages, and then the application mmap()'s the rings into userspace. This
works fine, but does require contigious pages to be available for the
given SQ and CQ ring sizes. As uptime increases on a given system, so
does memory fragmentation. Entropy is invevitable.

This patchset adds support for the application passing in a pre-allocated
huge page, and then placing the rings in that. This reduces the need for
contigious pages, and also reduces the TLB pressure for larger rings.

The liburing huge.2 branch has support for using this trivially.
Applications may use the normal ring init helpers and set
IORING_SETUP_NO_MMAP, in which case a huge page will get allocated for
them and used. Or they may use io_uring_queue_init_mem() and pass in
a pre-allocated huge page, getting the amount of it used returned. This
allows placing multiple rings into a single huge page.

-- 
Jens Axboe


