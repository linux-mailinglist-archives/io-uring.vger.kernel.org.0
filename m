Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3905B5FA999
	for <lists+io-uring@lfdr.de>; Tue, 11 Oct 2022 03:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJKBGH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 21:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJKBGG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 21:06:06 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5283551401
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 18:06:05 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bp11so6529508wrb.9
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 18:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/3HLSDasW/qE2O218K7CPuwWXUGu236QWXVEieFBqto=;
        b=esnCUIF78bELU2g4+xK5kf2Vc+gQoyOvwSAddk8BBHZLTWafPGIyc+qILkaFoDqYS2
         DCpKsvB24jxwfF4czPI86kVmftgyVJ8iDiiYnxqD62oJbzWqb1zpm219yiq3wNkBx+Ql
         rlqWU1IaGdeULWFnCcyissmw24BYZCR9GMAsN4bqS8R2PN77VuCGZjTd+wlyvgpVgs1Q
         7Air5TO1Cj26LDr+niSn1BUnenyxq/U0PcrnMsQ4JoAAGBubDj5d06tDULStIWOdfsud
         5K4UPGoZSa/JZ7nyJ8ndhksUecQTLz+QPUxsh3EQIJ3/o/vhlnqV25YSKzPYaCj/7lJT
         sMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/3HLSDasW/qE2O218K7CPuwWXUGu236QWXVEieFBqto=;
        b=4sZ6sGrk0PE6iRRtkRzTKzFGzjpH2JZxmIDhTLmD5P6q2nilqbHGOo8vO7L88xuOcQ
         sJlQWf50eu5gEBHLe7XV++P6rpMcC4mW/05vUx5iQm/CpXbk7ZX0THz4bLlfZiwZ2aUw
         Q9+8+zlTO5WSHn+WQaOQ9oMIorMA/yjVlQ/y8pYN0nyV/MrvOVq2eF6LHZlinyOR+O8f
         MyBy/uoGCI3q4PyX6iAXsAGhwEZoB7/q3j4F2TAp4eLmttbIpJjY5eY6lalleKilLgWZ
         6m+VG9GJh6aYZPnB2yxr6FB1NEyubDgAipQaQN1cdnGsgx45meW+cmry0py4t51nzUAZ
         v+Fg==
X-Gm-Message-State: ACrzQf2JFwoG6+VevFEbLtL/H7a9gSfgRT/KOzCNv2ABAN/Jt+3d4gu+
        loknCLSNuTYffYB5akO7b3MWU321I50=
X-Google-Smtp-Source: AMsMyM5Q+ewRxzQGNHowQW8eKkkYOIfyP3D1FP//qzpNQCLaYQQDqxHsjTAynGv7UvPmLh2YRgzzJA==
X-Received: by 2002:a05:6000:18a:b0:22e:c396:6c3d with SMTP id p10-20020a056000018a00b0022ec3966c3dmr11689056wrx.499.1665450363448;
        Mon, 10 Oct 2022 18:06:03 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.221.180.threembb.co.uk. [94.196.221.180])
        by smtp.gmail.com with ESMTPSA id z3-20020adff1c3000000b0022cdeba3f83sm9971593wro.84.2022.10.10.18.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 18:06:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        syzbot+e5198737e8a2d23d958c@syzkaller.appspotmail.com
Subject: [PATCH 1/1] io_uring: fix fdinfo sqe offsets calculation
Date:   Tue, 11 Oct 2022 01:59:57 +0100
Message-Id: <8b41287cb75d5efb8fcb5cccde845ddbbadd8372.1665449983.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

Only with the big sqe feature they take 128 bytes per entry, but we
unconditionally advance by 128B. Fix it by using sq_shift.

Fixes: 3b8fdd1dc35e3 ("io_uring/fdinfo: fix sqe dumping for IORING_SETUP_SQE128")
Reported-and-tested-by: syzbot+e5198737e8a2d23d958c@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/fdinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 4eae088046d0..2e04850a657b 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -94,7 +94,7 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 		sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;
-		sqe = &ctx->sq_sqes[sq_idx << 1];
+		sqe = &ctx->sq_sqes[sq_idx << sq_shift];
 		seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu, "
 			      "addr:0x%llx, rw_flags:0x%x, buf_index:%d "
 			      "user_data:%llu",
-- 
2.38.0

