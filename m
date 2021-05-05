Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEA13734BB
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 07:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhEEFif (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 01:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhEEFie (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 01:38:34 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3302C061574;
        Tue,  4 May 2021 22:37:37 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id l2so373800wrm.9;
        Tue, 04 May 2021 22:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=unYcznRdPcyvgkZrvsrvxIZQa+LjafDJyw9TLnEdcWw=;
        b=GSIhmA0V3VNz95ERxv/N81Yw3mWwBJypUlg7OhXiyXlc7+wevDHxLbUxvaW65YecRp
         eBJAyqE+WSR64btFqqAlNxdCQQlzTvGlatfh0T8NGvqkvNbcIxkNS9jsxGMxClL/2QF2
         pkGHxR56ElG9Nd/21NqOP2w8bEbddQ/bYOuCybTmyAeeAfI5ixBOJ7YP7kXEq21okGy9
         WgQDF1K91wR6bEETctYPiWVM4CpmatSaH3C3D8j9WhbF/sqhPyhaodUZusZ8KL2PEqrA
         6pbGeb2dYgVxFcQ35Z68e4cC07zMLQ7lM48wWYDWu1SD81o6Hi3wSPr4+P37R/zNZnZi
         Xthg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=unYcznRdPcyvgkZrvsrvxIZQa+LjafDJyw9TLnEdcWw=;
        b=IwYRoHDRuKcfmSidWZDRj3SiJrReZ7Jh/0TGOvVWiCVdzF0AfC8l3xi4q2wVbqw1mQ
         8qlpn9gRH6BXXeplTQGQ9tTkgChyNOplRUc2SestPtVWyvxKY7D2oqHl/N+hU1z8pV2j
         Qjip1D3+glP6xtsgKgx1BWrFbMJCaiOGoeP3YPxWnp3fukEmTmTWKa1MOMlTQUgkhy9D
         kcp14UFg7vUoNeENamGxDs+rXYFr2NM6dTDilKI5KYMzNML6ZPvKpCnq/m3i68dj6twW
         uusUtc4ksz+i1s9Chnn5D353zp1gIrAWBMueZ5Rj0popnKksMIV5xJHbGlvvzwupHe1j
         P5qg==
X-Gm-Message-State: AOAM532wheX4vdTiMZDcMfTecIkeWE/xZnhNX7RaucfSdxjLPXSN+Acq
        sSGVjXLEoqyNB8VgMCoLaxg=
X-Google-Smtp-Source: ABdhPJzflgbgjmD3C38IJSMoXY+c3Z+f/R5KmsfZlZTFMS9Aet/6rSOBOUx4Btnw5NYZFKATzH62zQ==
X-Received: by 2002:adf:e0c8:: with SMTP id m8mr36529361wri.349.1620193056219;
        Tue, 04 May 2021 22:37:36 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d40:3400:1d3:ebdb:5632:f627])
        by smtp.gmail.com with ESMTPSA id r17sm4396376wmh.25.2021.05.04.22.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 22:37:35 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: add io_uring tool to IO_URING
Date:   Wed,  5 May 2021 07:37:28 +0200
Message-Id: <20210505053728.3868-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The files in ./tools/io_uring/ are maintained by the IO_URING maintainers.
Reflect that fact in MAINTAINERS.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on next-20210505

Jens, please pick this quick minor cleanup patch.

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index efeaebe1bcae..3160d86b0057 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9563,6 +9563,7 @@ F:	fs/io-wq.h
 F:	fs/io_uring.c
 F:	include/linux/io_uring.h
 F:	include/uapi/linux/io_uring.h
+F:	tools/io_uring/
 
 IPMI SUBSYSTEM
 M:	Corey Minyard <minyard@acm.org>
-- 
2.17.1

