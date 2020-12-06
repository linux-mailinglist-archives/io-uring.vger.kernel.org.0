Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBB12D0515
	for <lists+io-uring@lfdr.de>; Sun,  6 Dec 2020 14:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgLFNUM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Dec 2020 08:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbgLFNUM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Dec 2020 08:20:12 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15584C0613D0
        for <io-uring@vger.kernel.org>; Sun,  6 Dec 2020 05:19:32 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id g185so11168800wmf.3
        for <io-uring@vger.kernel.org>; Sun, 06 Dec 2020 05:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AVXCcgTQ/cE/NuXRJIHNNIFdstou+ZYQXeYlg/l1kGE=;
        b=imguuz1BupFwtSNNcqH1S8ZnRNDtoK5sqN3JcSppeQ52qWL4s6LdMIncpdU7YXgtfb
         /LE/Si7wV/Gc1o1uyKlSEvKSbtACXoHgutyGbG7LNOPZE05kfIJLLLVE6AkAimiXgFpR
         qDc3vQJUqEfEAVIDcnVm66wVRQj7B+1BS7UUBRIGo44jEWUHbPVntcwvml80moYbYPLY
         WBeejTy09+nogxI+Oq7eyw+i8zGGGQc8valQf+PoZZzI1qd0X3vUeUneHxlA/QNM7ALz
         VCa6XTcEFGBxm3yL2UERz7kUynDMf7y9GSb4khaXgFgzhiuviwcvoP+/JJ1S184+LKP/
         j0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AVXCcgTQ/cE/NuXRJIHNNIFdstou+ZYQXeYlg/l1kGE=;
        b=allg3tXkUGKvxd/zsqfL4G4Vky62haM7HimhJ5UvVHfW+jTT+/tIuZ0Y1FLuvh52a3
         eAI5/bNw2ki8ns0eGC6zRaiq/XwuQAOiMWmHz6+cscOxSeFnG9bn7uUgGbifrwC54QY7
         RMI7Rd08M5LTEHQyxwO9C0/+5QM43rGUClvKtUDOqv9j5we/dc1woxDiplLGDxAdnCxa
         vj7X6Fg7N4BEFUIpL0SpqB6NEjPy05YPD9a9SVVqeGYpGbicsJP5qsMWNnIG4o1zPuuK
         s9l+qBDKJh0+jAe3djr1aOu8hTOtu9keRzUnryFeMhMUsTCCS1DZb5feIklKvly83u8D
         WdbQ==
X-Gm-Message-State: AOAM530eqU4aPP2YwrHRAcKpqdLvVJGUtvSCaAvgGebll5REf0Rpp+w/
        LZf09wrVW8S7aauIuok+ABOg511e+LdifQ==
X-Google-Smtp-Source: ABdhPJzAqKzkS5zpwtSBPcxQVEsGO5joMPcK4S29YX2163RThW9bZ8Da9/5zYYtsCyvExTghhO96iw==
X-Received: by 2002:a1c:bc88:: with SMTP id m130mr13985858wmf.82.1607260770728;
        Sun, 06 Dec 2020 05:19:30 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.45])
        by smtp.gmail.com with ESMTPSA id l8sm11182086wro.46.2020.12.06.05.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 05:19:30 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 5.11] man/io_uring_enter.2: describe timeout updates
Date:   Sun,  6 Dec 2020 13:16:07 +0000
Message-Id: <24c4f1133eb4dd3ff2e979a6a744ac0032fb7a2d.1607260546.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_enter.2 | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index ae7e687..a1e486a 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -325,7 +325,9 @@ Available since 5.4.
 
 .TP
 .B IORING_OP_TIMEOUT_REMOVE
-Attempt to remove an existing timeout operation.
+If
+.I timeout_flags are zero, then it attempts to remove an existing timeout
+operation.
 .I addr
 must contain the
 .I user_data
@@ -341,6 +343,19 @@ value of
 .I -ENOENT
 Available since 5.5.
 
+If
+.I timeout_flags
+contain
+.I IORING_TIMEOUT_UPDATE,
+instead of removing an existing operation it updates it.
+.I addr
+and return values are same as before.
+.I addr2
+field must contain a pointer to a struct timespec64 structure.
+.I timeout_flags
+may also contain IORING_TIMEOUT_ABS.
+Available since 5.11.
+
 .TP
 .B IORING_OP_ACCEPT
 Issue the equivalent of an
-- 
2.24.0

