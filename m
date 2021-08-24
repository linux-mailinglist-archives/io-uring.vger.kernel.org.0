Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247853F5D37
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 13:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbhHXLkx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 07:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbhHXLkw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 07:40:52 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2AEC061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 04:40:08 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h4so651435wro.7
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 04:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QNZqrm4iF7P0cOq2N46sx6m/GdQCHfm4FTPVOVRCXbs=;
        b=EszwGDQNRDQfIOg5JEkyT+2kC98rkOVROGSy0qP8T2enGWrlMo3l8CB81ggsgIjuMF
         PQ62i4no4E5MvYbBtTViJ7ilkSnf/wkoiBpfj3k0aTW9fYERpCSrmgVr4jtaz5IVXNHO
         41lkzMWLOMrQNv52jc96GBFAMxbb5Vfoyd2LVmXr6i4dTtal5e9Nl8X+++sfnQYi/BzS
         9VZ96hUxgLlK63bY8TC/SEH8fhOodfrdYw6U+oX/WhD3a9igVdOsTkR2ZwBXM6HJkjqo
         kYWD2b5p1DkN5eAYdCbBWUCyMou+64sGIelBY56wHbR0Sab2UR/Qbm/Ounc7V7RtwLaS
         a8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QNZqrm4iF7P0cOq2N46sx6m/GdQCHfm4FTPVOVRCXbs=;
        b=Cj2LK4wGapaiaf2m6pJbTrY1JFjCAGiFsySSd3KJotylTcjNLQ0f43dZM6IexAcWfY
         Oxrsuk4brPOR+aQF1Tf3dSp5UoDmnRBfyyUPxL3veS3J6qj6SNK/VX6NhovGbiI6UMHl
         BKBYoV6iA0eMxgtTbQiU47Ga7xtAdm3Zi7pbbWlDUX2ceVL/EYLsCHN0ibCz/SIUvaCR
         NALoTx/YKYmPMX0p51FtM196rk9nIWKz0CwjOGtk6GEmHsDeR/5FCmWBzN8od3hNirwr
         bl3Ijks0zdzt6N31leUAo0XKu0tBppiuTQhl8DuwEEhopzWk4KjaE9ayStNCOpZ+sp9c
         Dalg==
X-Gm-Message-State: AOAM531iOIrIhIbVimtJwxCN1lnZx6XTEvCTDO1dBXTiZklOqrJ2wKFT
        62Igf5+eFSkLswpVxu/fPLU=
X-Google-Smtp-Source: ABdhPJz+gubhOra7+4qWtp1gKcDg3qaOo1CGJVZndHGrwgC1r8V3NesywfKRuk4N4C1qBAHLnEV3yw==
X-Received: by 2002:a5d:440d:: with SMTP id z13mr17903268wrq.216.1629805207076;
        Tue, 24 Aug 2021 04:40:07 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id m4sm2126869wml.28.2021.08.24.04.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 04:40:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] tests: non-privileged io_uring_enter
Date:   Tue, 24 Aug 2021 12:39:28 +0100
Message-Id: <34c67bd613fe241a5942a1c5befecaa81cb73dc9.1629805109.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629805109.git.asml.silence@gmail.com>
References: <cover.1629805109.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Decrease the ring size in io_uring_enter if can't allocate a large ring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io_uring_enter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/test/io_uring_enter.c b/test/io_uring_enter.c
index 12f4ac9..4ea990c 100644
--- a/test/io_uring_enter.c
+++ b/test/io_uring_enter.c
@@ -30,6 +30,7 @@
 #include "../src/syscall.h"
 
 #define IORING_MAX_ENTRIES 4096
+#define IORING_MAX_ENTRIES_FALLBACK 128
 
 int
 expect_failed_submit(struct io_uring *ring, int error)
@@ -218,6 +219,8 @@ main(int argc, char **argv)
 		return 0;
 
 	ret = io_uring_queue_init(IORING_MAX_ENTRIES, &ring, 0);
+	if (ret == -ENOMEM)
+		ret = io_uring_queue_init(IORING_MAX_ENTRIES_FALLBACK, &ring, 0);
 	if (ret < 0) {
 		perror("io_uring_queue_init");
 		exit(1);
-- 
2.32.0

