Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F317139BD75
	for <lists+io-uring@lfdr.de>; Fri,  4 Jun 2021 18:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhFDQp7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Jun 2021 12:45:59 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:50829 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhFDQp7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Jun 2021 12:45:59 -0400
Received: by mail-wm1-f44.google.com with SMTP id f20so1532726wmg.0
        for <io-uring@vger.kernel.org>; Fri, 04 Jun 2021 09:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bkBNx6CDCDug1216WbBvCHNO3z3k0uzKIx7Lyd/dMUk=;
        b=QnWXAwxqftxBN5G3P0eytpuh1koyN5NIuWZD0EjlOmJ8CwoSbrx47fLH9GKk3cYxEJ
         wnx1zunVoelHxzcD7ooVRa1wReAhoXHUtv6/oaF84ZsFE8Yg4cLCsWVYD5M5KD2hQMi/
         amLmiCR7G1KfqBFzEbi+dKv0q1bjSBFl9kUtjlvaqLXuyHKSsiuiPql0oL7FNMSG+leh
         mAhm4hSJ8vgmE/FCKB8w89tSzgRHUWU24BhNeM0iEFKQjIfIMOukFYkY1AkqanGvjGHN
         u6upIrTttgDK1nO/J/+YSGVMwKydGLoTJmHUg3KMnG5RQMSxKCgJE+GNdEmui6TMNb8C
         Tcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bkBNx6CDCDug1216WbBvCHNO3z3k0uzKIx7Lyd/dMUk=;
        b=nJEocBBUOmJiDAZwunfQud6LZTBsscXf/NGCYHb/m7a2EyA2yvy34cpha1k4grwdTq
         ikYVGObcVpmly7eT2zTp9uyHFXPNu7VPWHA2fK9v77KKpKmyNe4U9Bf/C2JCMlEntI0M
         wanlz2uo43eqROY573in0cI5sm19kxPkdq2sCpazrVxfMu8Dgp5tjq5rRwv/Fxjm+M2x
         AJu6T1BY04Hv4Mh/cPz0lZyZFnQwm8sPG35gak3yMm9witrxzrWp3zZP81t3IjpKyIF2
         0uO9gnnFKIYuFguHygdz0YL0VVPD4gEnko+q3B6QzzmEFUvtW5WrY0659Z5SN4TcmnMi
         Pj1g==
X-Gm-Message-State: AOAM5301/tKqn5hw0x4IAuJmzXo+kBNCpEYNX0lyOMn6d9p/KVIbwAO3
        UmDVLcKcL1bhlGiJkN0+xkBe4A==
X-Google-Smtp-Source: ABdhPJzhUDiMzdE25g7rnhzQyTIyOEOiCrZBu8aUm5OCjgLLlyigN+uz9OY4t/M+Kb8+84P2eqV7qw==
X-Received: by 2002:a05:600c:2054:: with SMTP id p20mr4217278wmg.175.1622824977481;
        Fri, 04 Jun 2021 09:42:57 -0700 (PDT)
Received: from localhost ([91.110.139.87])
        by smtp.gmail.com with ESMTPSA id k16sm5998458wmr.42.2021.06.04.09.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 09:42:57 -0700 (PDT)
From:   Fam Zheng <fam.zheng@bytedance.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, fam.zheng@bytedance.com, fam@euphon.net
Subject: [PATCH] io_uring: Fix comment of io_get_sqe
Date:   Fri,  4 Jun 2021 17:42:56 +0100
Message-Id: <20210604164256.12242-1-fam.zheng@bytedance.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The sqe_ptr argument has been gone since 709b302faddf (io_uring:
simplify io_get_sqring, 2020-04-08), made the return value of the
function. Update the comment accordingly.

Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 903458afd56c..bb3685ba335d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6670,7 +6670,7 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 }
 
 /*
- * Fetch an sqe, if one is available. Note that sqe_ptr will point to memory
+ * Fetch an sqe, if one is available. Note this returns a pointer to memory
  * that is mapped by userspace. This means that care needs to be taken to
  * ensure that reads are stable, as we cannot rely on userspace always
  * being a good citizen. If members of the sqe are validated and then later
-- 
2.31.1

