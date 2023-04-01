Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AB16D33A3
	for <lists+io-uring@lfdr.de>; Sat,  1 Apr 2023 21:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDATvd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Apr 2023 15:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDATvc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Apr 2023 15:51:32 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929159750
        for <io-uring@vger.kernel.org>; Sat,  1 Apr 2023 12:51:31 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id l12so25568648wrm.10
        for <io-uring@vger.kernel.org>; Sat, 01 Apr 2023 12:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680378690;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zDCm8vmIDPLinAQT4FoJ9EosJ4cjEDXsOXudjo4YkUM=;
        b=ch/d1Rmh2g63FuvRA1ulOUTaNVczIv12LXcqmSSvoe9v79yZ4aOKd8KOVP/VoRiiCZ
         1Uxjt1JPcIoRstadwXiLZzqui1cdPuSUetYgtYBcwbCRPR1GvRWgzeRng1a2+L9IzwZP
         nJXxk0BZChDNsbiHHU9pCM/vwZL23MAe7Nu4cEu8nR8x2r7I9ROoit/YYkD21dxMchMv
         B/vPQZAhJzl9JpAfzX45U+WBTZ1iPiPIg5Yv5lDPwhgZjiQdV9SMpMqFd+5vJdhOroVL
         dpFpKUzyIkSZji9Um+TWIaeU+pLLWYCLhBDOPNn1cY/Ldz0zX3GpK+QiV9qOfMzmPt2d
         cvgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680378690;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zDCm8vmIDPLinAQT4FoJ9EosJ4cjEDXsOXudjo4YkUM=;
        b=dkb8LvSH/FuoU39zykFvVtCcPc472uN1hzhaViv5ELHakGIkZF3SCmx3dHvmmc82Hi
         jPBY3v6xN2tnSV2qUuc6vvaXUHnsBb8rD8hcelXjIrypve+LiSqZWgZ1oil9s3yMWrYc
         xrkhbx2P3KVvzlS/xPYbntlKOewVwbIMRDt/PyjVJQPNOOZ5mQP4ESlRge+nIGWlaApR
         DsOsRYIJYDJ7uOQLKwmHUwA8JM7ZOY/wVhDdcwpQFdI9ShzTyalVlKuhrEpyYeqJJF4S
         fZj5Ua+cJgni1hChCiPleDvxl1mgzzD2VUpCq9nWqeZkhhbu/lJeTiQ1Oqr3XryIgY88
         0HKw==
X-Gm-Message-State: AAQBX9cgu3Bu0fSy+XSkyAuhF/HzTJPuAnAz8cchkFSYwBddBtqpcxTi
        P5jPL3hno7R1rSPlsYNQV58=
X-Google-Smtp-Source: AKy350ZdErVfOpwaLxvBHFZSybTH1iZcbqx0GagnvLTdcFkjrxkulAnoiCMZ4Uf6DeNxAuPWzzSsLw==
X-Received: by 2002:adf:eace:0:b0:2cf:e3d0:2a43 with SMTP id o14-20020adfeace000000b002cfe3d02a43mr26782988wrn.4.1680378689860;
        Sat, 01 Apr 2023 12:51:29 -0700 (PDT)
Received: from localhost.localdomain ([152.37.82.41])
        by smtp.gmail.com with ESMTPSA id b6-20020a5d5506000000b002e463bd49e3sm5561009wrv.66.2023.04.01.12.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 12:51:29 -0700 (PDT)
From:   Wojciech Lukowicz <wlukowicz01@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Wojciech Lukowicz <wlukowicz01@gmail.com>
Subject: [PATCH 0/2] fixes for removing provided buffers
Date:   Sat,  1 Apr 2023 20:50:37 +0100
Message-Id: <20230401195039.404909-1-wlukowicz01@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Two fixes for removing provided buffers. They are in the same area, but
otherwise unrelated. I'll send a liburing test for the first one
shortly.

Thanks,
Wojciech

Wojciech Lukowicz (2):
  io_uring: fix return value when removing provided buffers
  io_uring: fix memory leak when removing provided buffers

 io_uring/io_uring.c | 2 +-
 io_uring/kbuf.c     | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.30.2

