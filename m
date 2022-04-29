Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1289F51530C
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379501AbiD2SAC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356565AbiD2SAA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:00 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5700C3EA0
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:39 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id g10so4461302ilf.6
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S4KnDR6CDDMQX1AjzrjMjtxdplEBfWHssbwaH9YBykk=;
        b=pKPgQuyt/sd6HEzFL3qY3frBnnvz+ZTHvAv+nIzwkZ5QYcLVlXzPEqUoyxkPmIb1G0
         5LEIbLMu374BL8Vv1jnG8bQX5VtD6z+OH9sCAuVAsrjw9fzp4FA9oNdUlJT719dk3MZE
         s4HiTBdrgkKoKTmMrIt+M7hch4xRieDcYsZex9Wl3NEfGn5rgdqT8nkQK90LOCEHvMCm
         GxIHE+Xb+1Q9G5Zu3+q2ShB3dZTmgRNYk9ph2p+26xlNgTL+s06A6vEEli8iW66ZQrRH
         3XnSqb6h+t4t4b3/ZZyptChq5XlDA7w4yaBqUCB7TI8oHQtJUe9NRVn8i/vfnV7kgSfa
         AF9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S4KnDR6CDDMQX1AjzrjMjtxdplEBfWHssbwaH9YBykk=;
        b=Vsq9AV0PQ3G+DTs2EEdRUg1hfhmkFNwW+e7cOpn0yQyWfA3ls/yVmOWQCY1L3vdrG1
         KfxXJ3jVE4b7GD8fWV1Rg8opE+82+R5NHPXP+usSN9GktuZS9rTbo+3QCtP5zcaZHS9i
         pjzI/tahdTsK0SUZnwVsH26VbToAmSuq12sU2F04uYPolqjda/XdwTg6+tmsi/f01qsw
         wNDIawc1qX0V1H1VDuTvPiD7O2sp8yRA4MHGUnKdj3+dOzjBobIHytR2oD2fDFqbrJ2B
         GJhLWDRxfyQQJKdDnp0/XUfylnYdN4R98mZ2x2cal8f6DeMpU9Gy9Hv1medWq2VxroVS
         W5iA==
X-Gm-Message-State: AOAM5308ueLcrVLCjQf75BEqpM0B6MxObuOt/4cCzU0PpuwwawuztJ8T
        Ldjj6x0Ink19aqx6syNPrk/F/MjGCH7U5w==
X-Google-Smtp-Source: ABdhPJxRF6+bKAaXIJrEkGDKOGqSa0vV+ScANB1dt+DGyrDWJzSbisS5JynzoRjdjuLZ/F3JvSyXLA==
X-Received: by 2002:a92:d4cf:0:b0:2cd:6e3e:9d8c with SMTP id o15-20020a92d4cf000000b002cd6e3e9d8cmr210981ilm.242.1651254998202;
        Fri, 29 Apr 2022 10:56:38 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.37
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v2 RFC 0/11] Add support for ring mapped provided buffers
Date:   Fri, 29 Apr 2022 11:56:24 -0600
Message-Id: <20220429175635.230192-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This series builds to adding support for a different way of doing
provided buffers. The interesting bits here are patch 11, which also has
some performance numbers an an explanation of it.

Patches 1..5 are cleanups that should just applied separately, I
think the clean up the existing code quite nicely.

Patch 6 is a generic optimization for the buffer list lookups.

Patch 7 adds NOP support for provided buffers, just so that we can
benchmark the last change.

Patches 8..10 are prep for patch 11.

Patch 11 finally adds the feature.

This passes the full liburing suite - obviously this just means that it
didn't break anything existing (that I know of), the only test case for
the ring buffers is the nop peak benchmark referenced in patch 11.

v2:	- Minor optimizations
	- Fix 4k PAGE_SIZE assumption
	- Style cleanup

Can also be found in my git repo, for-5.19/io_uring-pbuf branch:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-pbuf

 fs/io_uring.c                 | 463 +++++++++++++++++++++++++---------
 include/uapi/linux/io_uring.h |  26 ++
 2 files changed, 370 insertions(+), 119 deletions(-)

-- 
Jens Axboe


