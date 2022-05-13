Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98787525FD6
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 12:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354802AbiEMKZn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 06:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378694AbiEMKZa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 06:25:30 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD04174904
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 03:25:29 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id p18so9405613edr.7
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 03:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/IqZzmCAFIuIa6bmT64yF7CNrH3z2PH5sCNrJxXfleY=;
        b=bPSrd7RW+vtYUeq48ZJezc8YlZ2w46TS7h7SWpUJTybpTJg/LYPSbRDieqYoEV8nHK
         eSsO8218UGLA6Lv1RomC1taabG1hrq95A5d0pZt/UOF8ktXxS1piqEvBeLUfXe3n7x1J
         ECdcbhPkIVOwwocisSQ323tpRHtJGoy/Se3rl6En3pGUZVuu4IIjTD8//FbA2uoGK4V7
         QyoGf4/GPTn9haPqbL6tirPJ+Wx+AE4FdKoinJSV6mMBXtFwWRQk4Yoq+DE5p1kZJS14
         ac3sLcjYcP8TOVpDsqSYq7lKTGnHstFD7YC8COhkeG1wgcMdEbqDZK0Y/W6gSegTdsSh
         vL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/IqZzmCAFIuIa6bmT64yF7CNrH3z2PH5sCNrJxXfleY=;
        b=FOeKAs92HlHsV+cGf/6NEDWWnEh5LI6UDMzNRcYhs39xd3rdMyHZeZ/lKwwJKu3w8J
         /V2a0/a+88cfz4lVf0V8XOJ57nO4jVRe9Ur5zacx4t7FcLxbGhsSQvsqjvFtUV5VW4BI
         C9/tQ7sVcuSQudn7I7UyRu62PaqZlQx55h4qBNzgqiqWFxnysisRbmGXofOgIxy0/tJa
         q4NREPFVGZbb9Z1yBmnjiLu+MIWzJKZsmGwYfdtJ2zxTQ5AWT3N9kGXgB56j4Oy3BYyg
         gmiP8vLRgEl9KfAXJFOwIpC3QKe7BjwYKUKcFBDc2J0K/xEkHtWk7GNVC2hWeo0J+kST
         DGyg==
X-Gm-Message-State: AOAM5337S3y2FcDChwIbidPruY2b8IawLH+RRJtLwyfdzZan29fZ4Zfb
        6Vz5UDCOyW0qP2hLksw7o+Q4Xgf4Ln8=
X-Google-Smtp-Source: ABdhPJxvCEIr/V9+ss3s17tICSmszzTpcCre6gW+u5wSw3m7SiYDr1qC0GRmnTPFAU2aH7CD932dWg==
X-Received: by 2002:a05:6402:40c5:b0:427:af77:c10c with SMTP id z5-20020a05640240c500b00427af77c10cmr39822809edb.387.1652437527515;
        Fri, 13 May 2022 03:25:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j18-20020aa7c412000000b0042617ba63b8sm769881edq.66.2022.05.13.03.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 03:25:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH] io_uring: avoid iowq again trap
Date:   Fri, 13 May 2022 11:24:56 +0100
Message-Id: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If an opcode handler semi-reliably returns -EAGAIN, io_wq_submit_work()
might continue busily hammer the same handler over and over again, which
is not ideal. The -EAGAIN handling in question was put there only for
IOPOLL, so restrict it to IOPOLL mode only.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e01f595f5b7d..3af1905efc78 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7319,6 +7319,8 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		 * wait for request slots on the block side.
 		 */
 		if (!needs_poll) {
+			if (!(req->ctx->flags & IORING_SETUP_IOPOLL))
+				break;
 			cond_resched();
 			continue;
 		}
-- 
2.36.0

