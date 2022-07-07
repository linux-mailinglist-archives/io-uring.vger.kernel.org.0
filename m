Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B0256A52C
	for <lists+io-uring@lfdr.de>; Thu,  7 Jul 2022 16:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbiGGOOV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 10:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiGGOOT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 10:14:19 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C002F38C
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 07:14:18 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dn9so27385348ejc.7
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 07:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/iwdvLNwdILLGbbj5+PGHQP7PZ0tgLha+x+EmB31DpU=;
        b=Sh4d83p6h+XYNKnCQrd6wkn5WXI/d9OKVc53p/VBAC7KCYyfdpZeDLTlaIxln0pZgO
         ++gk1tCJLqCVEgbv5hGUDMCDQS7jMLtqkC59LYRxx5YzEYQj7Y3dB/FZSMX0xDN96Ii2
         Ym2smh2z3AAJ7soItNbMp0jMqZko69zdViUvBFzfocIAKabg3r6ZG7wS6ucksKLbosrB
         fpqW8U97xfr0GQ3zz0L6aPQ/jE8MK6b+gXCaWiTbmKT65HyteHaAxytrfVgq5MJ9Fg1G
         4xZMDN55a0Binl5/G+b1UHUy1SZi1ZMw5ZcgWhWPljqnKyd+SxJRo2lajofhNgHLxDlw
         Wb4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/iwdvLNwdILLGbbj5+PGHQP7PZ0tgLha+x+EmB31DpU=;
        b=Kx0fZNZ3TaZVhI1yYShQIKdbMIvg9scwP5/KeOo209HxjKh8qoh8epnv23puGaySXZ
         DCec+99jZ6IFm9lGk807kk0QEcakPstLI5/UOrC/UI/TgpPBp3P5rTWIQ00brpkhrGRo
         E4LF+5iMTecnd8yKWUsS853o418tDJ3RN8r0XS1yYdiE5I0E+w1iacYynNgo8iJllwao
         l2yZ5jYO7FCIae7uwiCr+roinNTRCyytGnEQQnut2UvqR6UBVYY+b9GIb41NukytvQDc
         dkN+76ZWYWKw1JrLKAdkGTY2tqU3PL6TTo8VMrzOqrZ358bRAqZmMIzPcqw62mJOtuJA
         kKVg==
X-Gm-Message-State: AJIora9nNGB+3v3OZP8LJrhfsG1rGvatV0LOlPVvi1gMFfsXWih2TFr1
        WWlpVzyZl18R0XXlZ+dTkqOuoY+CPvxOQtTp
X-Google-Smtp-Source: AGRyM1uc6rE6QU9qD1aSIPntslyFm98FGe/7Q99ypNOfh5spJCb5peBIKfrLajM6STsgPjjFRxTPeg==
X-Received: by 2002:a17:907:9816:b0:726:2b90:4bab with SMTP id ji22-20020a170907981600b007262b904babmr45585951ejc.544.1657203257267;
        Thu, 07 Jul 2022 07:14:17 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:3fc3])
        by smtp.gmail.com with ESMTPSA id bq15-20020a056402214f00b00435a742e350sm28254125edb.75.2022.07.07.07.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:14:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        syzbot+49950ba66096b1f0209b@syzkaller.appspotmail.com
Subject: [PATCH for-next 1/4] io_uring: don't miss setting REQ_F_DOUBLE_POLL
Date:   Thu,  7 Jul 2022 15:13:14 +0100
Message-Id: <8b680d83ded07424db83e8745585e7a6d72826ef.1657203020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657203020.git.asml.silence@gmail.com>
References: <cover.1657203020.git.asml.silence@gmail.com>
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

When adding a second poll entry we should set REQ_F_DOUBLE_POLL
unconditionally. We might race with the first entry removal but that
doesn't change the rule.

Fixes: a18427bb2d9b ("io_uring: optimise submission side poll_refs")
Reported-and-tested-by: syzbot+49950ba66096b1f0209b@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 57747d92bba4..3710a0a46a87 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -401,16 +401,18 @@ static void io_poll_double_prepare(struct io_kiocb *req)
 	/* head is RCU protected, see io_poll_remove_entries() comments */
 	rcu_read_lock();
 	head = smp_load_acquire(&poll->head);
-	if (head) {
-		/*
-		 * poll arm may not hold ownership and so race with
-		 * io_poll_wake() by modifying req->flags. There is only one
-		 * poll entry queued, serialise with it by taking its head lock.
-		 */
+	/*
+	 * poll arm may not hold ownership and so race with
+	 * io_poll_wake() by modifying req->flags. There is only one
+	 * poll entry queued, serialise with it by taking its head lock.
+	 */
+	if (head)
 		spin_lock_irq(&head->lock);
-		req->flags |= REQ_F_DOUBLE_POLL;
+
+	req->flags |= REQ_F_DOUBLE_POLL;
+
+	if (head)
 		spin_unlock_irq(&head->lock);
-	}
 	rcu_read_unlock();
 }
 
-- 
2.36.1

