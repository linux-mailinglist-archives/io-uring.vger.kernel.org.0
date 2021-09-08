Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AFC403F80
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 21:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbhIHTMe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 15:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344396AbhIHTMd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 15:12:33 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CC1C061575;
        Wed,  8 Sep 2021 12:11:25 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id z4so4808292wrr.6;
        Wed, 08 Sep 2021 12:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=epgRnVOOroSlbCA0eO/Yc0L+DFlk8dm3qxy0SzGKgSE=;
        b=djY15+HDTmLcbrb9TEdkCsLcyVO0aSv8wkoONIX5Aiu8lnt9XFjevDei32Zf2pJgU1
         ti088Nu7YNDc2glX5WbdXlBJXLZpRSjma5dhdS03Vgup8Fy+/+5OeL3mZ+bUjnbB7B/m
         X9oMvTvJgzjADkFSm8cebpYAc3KrndhRrnE66ycxUlpnHUpWf/MgOUL2stoLLoTDh/xO
         AOL7onky+jrxjmgOGr7TWYE0gRsPWogqsSLkxHrcYHdyMhgzLLN35wzb7envwRrmNKFU
         QqYnrw9RUKjSZ+8nHHv60qtAoTpMiirdvYzq9gr81uzYkwnPFuPv3ThIz6CBoH6O+0Si
         Wrnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=epgRnVOOroSlbCA0eO/Yc0L+DFlk8dm3qxy0SzGKgSE=;
        b=2uhRP+vnFSQsdtBQheIIVye92+5js3Nly/yQH3oVKMFFPrfbp8TlSWhday8es+ELpM
         x4r9KQqcUO4sgcl0KwnevnHaGHorkry1/M8yPC/I512hnKPXyxtcj/OH/JnYKTvvLsJo
         0hwdoZRXgpWuzKz8NUNBHcxvTkRzHjMgIKyhjr7gqx0Lfts8uiY+Y+HUVaAxZaEWrR2R
         FEq6BxXl42koXrbjiblByX1p6s+ABzqvKmJ893NTFxMW2Lx93SDm7/6v6aIoHYeTNS4Y
         tOJo5TMACtTKykjffDDiwkcB/r/UG0hMVl0ZRHzHRkEqCx23c3ulWq1sm+3z+fld/Gbb
         grXQ==
X-Gm-Message-State: AOAM530sXcRz2l+wLZypURgk1BYHqDhUrS64Az8BXgvnl0xzeJhfeqqK
        Pj14T9k67rBifZ5erPGK3s0=
X-Google-Smtp-Source: ABdhPJxuRN60pCl0//zAH6LpslSCTDwJcZxNY/uL+ya93rzUxsmkK9nh14sKzyyHpDf01qVL7ZxYmg==
X-Received: by 2002:adf:e745:: with SMTP id c5mr5771891wrn.321.1631128283911;
        Wed, 08 Sep 2021 12:11:23 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id h15sm827wrc.19.2021.09.08.12.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 12:11:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2] /dev/mem: nowait zero/null ops
Date:   Wed,  8 Sep 2021 20:10:38 +0100
Message-Id: <f11090f97ddc2b2ce49ea1211258658ddfbc5563.1631127867.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make read_iter_zero() to honor IOCB_NOWAIT, so /dev/zero can be
advertised as FMODE_NOWAIT. It's useful for io_uring, which needs it to
apply certain optimisations when doing I/O against the device.

Set FMODE_NOWAIT for /dev/null as well, it never waits and therefore
trivially meets the criteria.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2:
Don't stop IOCB_NOWAIT read after first page (Jens)
Adjust commit message (following Greg's reply)

iterate nowait until exhausting 

 drivers/char/mem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1c596b5cdb27..cc296f0823bd 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -495,6 +495,10 @@ static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
 		written += n;
 		if (signal_pending(current))
 			return written ? written : -ERESTARTSYS;
+		if (!need_resched())
+			continue;
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return written ? written : -EAGAIN;
 		cond_resched();
 	}
 	return written;
@@ -696,11 +700,11 @@ static const struct memdev {
 #ifdef CONFIG_DEVMEM
 	 [DEVMEM_MINOR] = { "mem", 0, &mem_fops, FMODE_UNSIGNED_OFFSET },
 #endif
-	 [3] = { "null", 0666, &null_fops, 0 },
+	 [3] = { "null", 0666, &null_fops, FMODE_NOWAIT },
 #ifdef CONFIG_DEVPORT
 	 [4] = { "port", 0, &port_fops, 0 },
 #endif
-	 [5] = { "zero", 0666, &zero_fops, 0 },
+	 [5] = { "zero", 0666, &zero_fops, FMODE_NOWAIT },
 	 [7] = { "full", 0666, &full_fops, 0 },
 	 [8] = { "random", 0666, &random_fops, 0 },
 	 [9] = { "urandom", 0666, &urandom_fops, 0 },
-- 
2.33.0

