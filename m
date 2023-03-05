Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F576AAE45
	for <lists+io-uring@lfdr.de>; Sun,  5 Mar 2023 06:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjCEFOU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Mar 2023 00:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCEFOT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Mar 2023 00:14:19 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3868FC648
        for <io-uring@vger.kernel.org>; Sat,  4 Mar 2023 21:14:18 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l1so5753712wry.12
        for <io-uring@vger.kernel.org>; Sat, 04 Mar 2023 21:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViQaDPMxdG0fRx5gzd5Joc/ow9iU7e7BqQyY3D6AH7c=;
        b=c1CEjiMvzaX/51x7NtkoIMeoIpHwapLrWxnGhZ4tkbALFdG/ZWaMWCnXYrjTqs/mNC
         Qhm1vJZFqiD/YGcsIRs6lffxh46BuWBvYXvMuCLfWhNTeqKHL1vMfLhCcMc55oNBQX+w
         w6kiUcIAkeXyAwEjNFFg4YoaRjD8U6Wjp79LVOrvUq1LukjP3fsDus6P959GQKSMKhul
         OM96Z4puzdtinpDj3k4WM+xw6pMJHNuBnu+I2GKI5n8MlIUd/alyuL1zOFSFjGkRJmQc
         2FycfxA28UiC0h7vg8K/MiseSkkgWmCSZcR1UIcqlxNzIZUlb8T+l+GwG9Cw4hWpE0fp
         FDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ViQaDPMxdG0fRx5gzd5Joc/ow9iU7e7BqQyY3D6AH7c=;
        b=mD19nKiZEp6chkSeUscb9LlBjTlDddMAsipxv4t7ZvJ9sWVfgALPW/lu6xFain4svV
         oy4LiTmR7M38O42ydXmMwcybzwKnNL3MUCkKtUmD3cTxr0P0XhkNcnxNu7EG15Hqdzi2
         70UvZ4BrpPlCITNjlBGUoYx2Jz7fUbVT5VxLlwoBarZB0GKNQU5qgIn+bQIYzEMWpav7
         5lgAM12Kvf6qSmcTgMrO0n1viTLkEt9qExmJDGpa0F7ZXZHeK75YwoEkq0Ij12AYuL3l
         6VdXhFSe0kMlccWmzaU5DnytJeEufVoaqvGwyYhYMrxD34UBwubOASdrDAx2udfCJb7H
         Dwdw==
X-Gm-Message-State: AO0yUKXFDCz2pM86wqggI61iMZwkQiLS7U/eqfZbbHQREB+wQgEBQXBH
        Sb4Nnwq5kESTBk13ZYZBcXohc0B56e0=
X-Google-Smtp-Source: AK7set8OT3nIznw5jU16G5KsqzwX7QZjIZ9YcYFVd+Pp+wnFTfXifSp4TOcRXOApmlUJpzj44tH1tA==
X-Received: by 2002:adf:e242:0:b0:2c5:4db8:3dde with SMTP id bl2-20020adfe242000000b002c54db83ddemr3957114wrb.70.1677993256626;
        Sat, 04 Mar 2023 21:14:16 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.92.184.threembb.co.uk. [94.196.92.184])
        by smtp.gmail.com with ESMTPSA id j4-20020adfff84000000b002cda9aa1dc1sm6524348wrr.111.2023.03.04.21.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 21:14:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 5/5] examples/send-zc: kill sock bufs configuration
Date:   Sun,  5 Mar 2023 05:13:08 +0000
Message-Id: <521e3524b08499700c927984fbf6a25b38ed2e40.1677993039.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677993039.git.asml.silence@gmail.com>
References: <cover.1677993039.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove SO_RCVLOWAT / SO_RCVBUF, they are arbitrary and drastically
affect performance.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index 8e1242e..f400f38 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -237,8 +237,6 @@ static void do_setup_rx(int domain, int type, int protocol)
 	if (fd == -1)
 		t_error(1, errno, "socket r");
 
-	do_setsockopt(fd, SOL_SOCKET, SO_RCVBUF, 1 << 21);
-	do_setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT, 1 << 16);
 	do_setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, 1);
 
 	setup_sockaddr(cfg_family, str_addr, &addr);
@@ -328,8 +326,6 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 	if (fd == -1)
 		t_error(1, errno, "socket t");
 
-	do_setsockopt(fd, SOL_SOCKET, SO_SNDBUF, 1 << 21);
-
 	if (connect(fd, (void *)&td->dst_addr, cfg_alen))
 		t_error(1, errno, "connect, idx %i", td->idx);
 
-- 
2.39.1

