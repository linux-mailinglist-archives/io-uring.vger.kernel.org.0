Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DFE403789
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 12:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhIHKIj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 06:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbhIHKIj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 06:08:39 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC183C061575;
        Wed,  8 Sep 2021 03:07:31 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so1078538wml.3;
        Wed, 08 Sep 2021 03:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IuVAXOniPs80otZ91yGL82RmtViOBhOlj/adKgbx/8w=;
        b=pGl8ltgHx8yuhgvAVU3pBI0QcBs8QIiIpX4gpxovbtjVtV8j2ojaZvf4JCYYEDllIq
         NAZrwG030ghSvhp+zTCnXEmc18nYyl2dAc/rSU5X/1G0kY6Hjg7JWKB28tr120XeiNEk
         aC1e7gm0jJ8Bg1NPc75R+WVpRhk1Hbyd329JVOPUbelz2w69WqZ4e3pxVM13Y/Rhc9I1
         KtvU+v3+ZZUegwp/E245WrG5sjyrgyBJ3tMSlECp9pDsM0tk7uDaCmw8hmQRh//o5VzW
         CThsAc8rxwoZsmV3VzLy8WCRxNTZrkbJO9pYQVNTVkIbH7iZhn50r/3CzGjohxfwsmKL
         uKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IuVAXOniPs80otZ91yGL82RmtViOBhOlj/adKgbx/8w=;
        b=rbz1uiIA2XPD9zyC3kCk7MgUGpaGKedtCqrriazxwnyrWdubBoOaCaS7eHVs4a7llV
         O7CfSeONhnjSU/1BXrG0PdWo4SC216VLv+tdR5m/KrHv9a5iJkWjJ86sUCrhp76UVGkk
         8hN48TheuIeljXfRcvV+ou7zXGFpt1ajLyhMJBTCMwfwxKhCT74nf5dURpfNMhU9nddX
         5U40wP+3/6xk6yZeJ86hC8kYsAGL0Ziy38Gil3mID8OzumHWd0lsfNUNczhDFPKoJM77
         wAluDGscV08wMiDU0qIREUMXPAcpbTAOsPVzDYuTjvpKTOHwvnHL5gQAeGadsY2eTava
         a2GQ==
X-Gm-Message-State: AOAM531KNV5rmAA4OnVf3WfJES1pMwXHFh+HnQcm+qMQn4qPJ3JJlJ9v
        COTkoidQ8P16Ac1HPCUJoFE=
X-Google-Smtp-Source: ABdhPJz8H/7Kpg3SF8tU6o2SIr20U4JEZtzuEn1zTwFGBxm80uM76lyVBzpvzIDuMLeFNrtqRHbt+Q==
X-Received: by 2002:a05:600c:3209:: with SMTP id r9mr2725457wmp.106.1631095650468;
        Wed, 08 Sep 2021 03:07:30 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id l26sm1623961wmi.13.2021.09.08.03.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 03:07:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] /dev/mem: nowait zero/null ops
Date:   Wed,  8 Sep 2021 11:06:51 +0100
Message-Id: <16c78d25f507b571df7eb852a571141a0fdc73fd.1631095567.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make read_iter_zero() to honor IOCB_NOWAIT, so /dev/zero can be
advertised as FMODE_NOWAIT. This helps subsystems like io_uring to use
it more effectively. Set FMODE_NOWAIT for /dev/null as well, it never
waits and therefore trivially meets the criteria.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/char/mem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1c596b5cdb27..531f144d7132 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -495,6 +495,8 @@ static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
 		written += n;
 		if (signal_pending(current))
 			return written ? written : -ERESTARTSYS;
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return written ? written : -EAGAIN;
 		cond_resched();
 	}
 	return written;
@@ -696,11 +698,11 @@ static const struct memdev {
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

