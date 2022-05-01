Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180625167E2
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354792AbiEAVAY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238355AbiEAVAX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:23 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A2518398
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:56:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e24so11247148pjt.2
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DCjDZJR+4VcKHW9/13acFz19EHglURVM6I0inYsDJ8k=;
        b=V6rPJlcdtQlJprxL5XOYpReJx5B8ocQspxouFdpbPfhg/OoldaMa4HZdaJhynvbsmJ
         QUOB4E1pnW4EEdXiwRyGCUPi8W9x1qA+v6Wl5PiJt9jALVMg9SrA86ZccdXArhc1tR9G
         zj1l2Nls7IABLuJcLJQiVl/yp38J6vGqP2D1nQ4hzwtats3nzNeRfA/DbkLXIq34Vuvr
         rAHwdYjSNeG3PayBGujACQv5JSmBkcfj3euozAUMWjrXN9PhuCP/KVkW3w+SU6DwVvRd
         p6NH8c4DBGFzUZdsBEQp8ISTs+8h8Kly68Xn1ieTqatUrtK8bbxndVWceerlNW/FZHIv
         yVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DCjDZJR+4VcKHW9/13acFz19EHglURVM6I0inYsDJ8k=;
        b=ze75C/Udjp8WKJIQtkyZ+1evE9o35ECTONL8NCLDn+2EZwJL0yMt3XyngyVuf8oCG/
         GiuclHj7yVHr0S6ohILeXHSzyhwzJUhwh/lAs4no/8h++MALIZ6fxC4C6NCwjTxhgu+D
         R0Z0rhqivRmeK4wjnqQcIkaP3+QOoEqdx364Qdi7PAyW4Gy+FvHLY7Q8iW85CbgGPaeJ
         RrQfmwYpwDMlU/Dzfx8AXMQL5QsxE1X6HBvGAW6Tm2sy+juAmQj/3fBgpJkpWQb6vFzL
         0EkBl/Vk2ZUJvV1SuwVeB1aFGTtyIs0VAY9/j2AE21MBojvBxrGsSJZF1Dwn5xz7J2GB
         rPUw==
X-Gm-Message-State: AOAM530/cW25Rs4o1Q6Zg62I6a3u6bsNPDgNzFS4S8zJr0tOdNn+923u
        PEuFE3UNSHx7OLlxjTQoDvGG1gpqM4MLTg==
X-Google-Smtp-Source: ABdhPJyWT2J6iVEhbtO3mc/tg1vZwY2GXAYO0GvDZq9Q4qpiI9EUt1XyrymqIuGWhyN+sDtRHGxn8A==
X-Received: by 2002:a17:902:edd0:b0:15c:6f65:d06b with SMTP id q16-20020a170902edd000b0015c6f65d06bmr8623791plk.91.1651438616125;
        Sun, 01 May 2022 13:56:56 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:56:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCHSET v4 0/16] Add support for ring mapped provided buffers
Date:   Sun,  1 May 2022 14:56:37 -0600
Message-Id: <20220501205653.15775-1-axboe@kernel.dk>
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

This series builds to adding support for a different way of doing
provided buffers. The interesting bits here are patch 16, which also has
some performance numbers an an explanation of it.

Patches 1..6 are cleanups that should just applied separately, I
think the clean up the existing code quite nicely.

Patch 7 switches provided buffers from the hashed list approach to
using an array (for up to 64 groups), and using an xarray for a
larger sparse space.

Patches 8..13 are just cleanups and generic optimizations.

Patch 14 adds NOP support for provided buffers, just so that we can
benchmark the last change.

Patch 15 just abstracts out the pinning code.

Patch 16 finally adds the feature.

This passes the full liburing suite, and various test cases I adopted
to use ring provided buffers.

v4:	- Shrink io_kiocb compared to before this series (-8 bytes)
	- Save some space in io_buffer_list
	- Add patch moving provided buffers to array + xarray
	- Add comments
	- Unify cflags handling for classic/ring buffers
	- Fix bid/bgid types

Can also be found in my git repo, for-5.19/io_uring-pbuf branch:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-pbuf

 fs/io_uring.c                 | 599 ++++++++++++++++++++++++----------
 include/uapi/linux/io_uring.h |  28 ++
 2 files changed, 462 insertions(+), 165 deletions(-)

-- 
Jens Axboe


