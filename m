Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB8D2DF581
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 14:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgLTN0L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 08:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbgLTN0J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 08:26:09 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9E3C061282
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 05:25:16 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id y17so7984587wrr.10
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 05:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5+Tj75weGFQkWsgrMXfg+Hpddtu2UBtMsuuXRwWHzYc=;
        b=cdVoCfK9Uygep/URHeXFAK0yPM5H9rMhL4pHz3q/eZgDR3Wtf5e0lzL6stXFkV3bus
         BMVp3LTHF65mz5RWZLmnVRajCg+x4XQMa6ROD7zyyUeHsZi9UKg5jyUU23AoUoAZSubg
         DM92P6x/nOyLXZd7J0XVIJi0AwjnVfjlK2v7YG7pnVB0M6hwFQ/6Bs5cKOjMmkFPnFeN
         NqUtbFfXYRgP67V2CQeQB2V8r+ANERkuI5d/ZEhZ7nWHTQTjsQ6zbC2+jV+BU+DaZ37p
         cxyCX1mhyj68RwGdCG8CEIWAIKGuB8yH2BpfvfE2TDI6pt83DrGmGthvMEL0IfSKys6T
         mgfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5+Tj75weGFQkWsgrMXfg+Hpddtu2UBtMsuuXRwWHzYc=;
        b=DbxWlOG9An3ix2pm9TTuOV1HN6KsRyHRzXbmdCmGz+VsabeJtN0AXEeZPWnR22RXyK
         sdcvpC7t6Lg4FQIK+ARXz9etIj/UzXmtmPeOOyMqODpevHABgQcKSK7xujT1fZWrAUPa
         cdO3YZz/o+1jLt/KXbVJlfjziFAg/L8EdD6UArHcNj5CUlbq9C0CqAhRvEzR6SyDR1fc
         kXXiVeIh9gO1b8AzC3kigKNF2N52olxa54ktyN/RC2NwTaPerPjscVKEgK/6HYpoSgqJ
         +UVsfmxliIlX7bMhnfXklUxTVVYplumi4+ImB7NYPED+GM+oQTnhprBhw3sML3F3hPDc
         NW7Q==
X-Gm-Message-State: AOAM533R1KgS9hVAAH070x7BLVK9k3q2n3sWys7yYkQd+OjeZtHDlL10
        i5WDqZVERfpCowOKM2iKZRc=
X-Google-Smtp-Source: ABdhPJxk0p3DNoJOLCwDuREEYRpGnP6bNV0wS6rsFMetsJ2fmmyTXUomP3oOtB00dRNWRDTSM+gNnQ==
X-Received: by 2002:a05:6000:cc:: with SMTP id q12mr13862076wrx.335.1608470715125;
        Sun, 20 Dec 2020 05:25:15 -0800 (PST)
Received: from localhost.localdomain ([85.255.237.164])
        by smtp.gmail.com with ESMTPSA id l11sm22946519wrt.23.2020.12.20.05.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 05:25:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: end waiting before task cancel attempts
Date:   Sun, 20 Dec 2020 13:21:44 +0000
Message-Id: <21b8ea10ae41b0e87957229d226d6ff494c42b64.1608469706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608469706.git.asml.silence@gmail.com>
References: <cover.1608469706.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Get rid of TASK_UNINTERRUPTIBLE and waiting with finish_wait before
going for next iteration in __io_uring_task_cancel(), because
__io_uring_files_cancel() doesn't expect that sheduling is disallowed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 051461b5bf52..30edf47a8f1a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8982,9 +8982,9 @@ void __io_uring_task_cancel(void)
 		if (inflight != tctx_inflight(tctx))
 			continue;
 		schedule();
+		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
-	finish_wait(&tctx->wait, &wait);
 	atomic_dec(&tctx->in_idle);
 }
 
-- 
2.24.0

