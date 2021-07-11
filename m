Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6343C3F8B
	for <lists+io-uring@lfdr.de>; Sun, 11 Jul 2021 23:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhGKVoa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Jul 2021 17:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhGKVoa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Jul 2021 17:44:30 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF71FC0613DD
        for <io-uring@vger.kernel.org>; Sun, 11 Jul 2021 14:41:41 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id f17so22225940wrt.6
        for <io-uring@vger.kernel.org>; Sun, 11 Jul 2021 14:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lipSaO3jHW0KegNTuPbPTFnWdKHPd8XW/kURnnPVDiw=;
        b=KcuilSQBnLedV3AuhXJKO0o0TcL16bvWAvy1hMLLZilxg3cKO+1N7XDHHtYNeRIkIi
         t+aFtxTCN5DKnHIHoynpB6ycKNyvLNWuyKYIMGq9A2+SPfR9ACjY3QZDqfSnHdG4PINx
         xky3F0iupaoWOu2AMD143YUkYg5hwyHqXtPQl2QlYEhJVI8P9WQ1e9Tob3pEKv6xKnax
         IKzfmibIWCaURjzc0R8gpKmcQskaIgQv0v+DiXveXq9Y5Nvup7vMLehZ//qUkVQmm++k
         tkzhVH+vgNs9nh5BKJHDoHPBoodGaGUUNEUkDLaGIRhRoeXeJfSBrLzhCp9ucdnqyFE8
         PRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lipSaO3jHW0KegNTuPbPTFnWdKHPd8XW/kURnnPVDiw=;
        b=rMUyiHeJtBhuz192owSGoPTwBMoA8qhk2mkywMhA1Ie6dVJr54C4XZ/Ow1W13TsP05
         XSgCL8X2dbRHWJC9+9sQUN2Hxc7pbAmWjCO+4Kml6JePG0iDMS/aPufP8TMapXlcAsW9
         Hw1IMPwSvHuNleq+svDAhxk19Ca7DcRF4401iRMtxtlKtIZAEP+hp4FNKij+oU4n3fIT
         aduN7ALGoUHrkmcfxY0ekjBKvTHbXrGYrv7U2edUM9rAexZMsVHv0YbSsebRey8rsKcG
         FhA4k8bZNmcE+4QUulbCHzcNX1prBLY1rYtFLTpEki9fy79HAkYoG2xE09+hWgJtmIEj
         SYlA==
X-Gm-Message-State: AOAM531OBao++3Ly/rRw6ySs57BxBwvr2ixoRLXtPnDK02UuJ0qoNVI4
        5EtArutdMtSH3tR6mSCFIGQ=
X-Google-Smtp-Source: ABdhPJyrz4Fcr7KAt6opl3TaEy1YIU4jWEd+Pa9TsGoIgXgnePMoWWaAYldTEQs+YfIWz+Xt3LIrXw==
X-Received: by 2002:adf:edc8:: with SMTP id v8mr53576476wro.279.1626039700670;
        Sun, 11 Jul 2021 14:41:40 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.168])
        by smtp.gmail.com with ESMTPSA id n20sm10576223wmk.12.2021.07.11.14.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 14:41:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+ba6fcd859210f4e9e109@syzkaller.appspotmail.com
Subject: [PATCH] io_uring: fix io_drain_req()
Date:   Sun, 11 Jul 2021 22:41:13 +0100
Message-Id: <4d3c53c4274ffff307c8ae062fc7fda63b978df2.1626039606.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_drain_req() return whether the request has been consumed or not, not
an error code. Fix a stupid mistake slipped from optimisation patches.

Reported-by: syzbot+ba6fcd859210f4e9e109@syzkaller.appspotmail.com
Fixes: 76cc33d79175a ("io_uring: refactor io_req_defer()")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 118215211bb2..0cac361bf6b8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6019,11 +6019,13 @@ static bool io_drain_req(struct io_kiocb *req)
 
 	ret = io_req_prep_async(req);
 	if (ret)
-		return ret;
+		goto fail;
 	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL);
 	if (!de) {
-		io_req_complete_failed(req, -ENOMEM);
+		ret = -ENOMEM;
+fail:
+		io_req_complete_failed(req, ret);
 		return true;
 	}
 
-- 
2.32.0

