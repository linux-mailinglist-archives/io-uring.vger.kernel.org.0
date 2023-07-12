Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E4074FC52
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 02:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjGLArP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 20:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjGLArP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 20:47:15 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5A810CF
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:13 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b867f9198dso11378595ad.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689122833; x=1691714833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8G3IrOMNGlFczpaPrC8wvkVroG8Z2Lzb2MR2ORlnT9Y=;
        b=Vf1GAj6GvM+KaDdgiHg64eKqsxyAT6AMQg5TB9LHR+eDiSwMVsx4LaD8iOrRhentya
         AudG97oDq9deM0vTzfBmWPseEjk4/5TUQ1gnTjSicsRSl99fsfZD3IJ+2ywyp/9otCQI
         0wUpyNtBeoA3N6UTxwqAs7t+eFcb3OAEnMD1jmgRn9M3HYGG2LBLgP1ncJd2kLhsgEBj
         c+R4XxjMub1ZM3aMdj1IyVy19gNw6KZT05pa7YJImPzgNAy7YqVq6hKNmtEr917lGs5k
         TPaozL/JMy0nsJ8sr4d3GOgfr9I1JinC+n1z0zswWwr552vv7lVBXwaDCqlVkzcssXzs
         2vkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689122833; x=1691714833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8G3IrOMNGlFczpaPrC8wvkVroG8Z2Lzb2MR2ORlnT9Y=;
        b=AbfFm6ptekaMhZ5ScaaB4G/hxAkHiuzjZxiBx8zZwr4upWgzzCWrPw0uBzYxjiViaf
         g6FTCOeutIVDwD3j5IHrhhFPqSpeql/MU2lp28drtNCVivyd1jCVRfF0CLoGoKwWuVsO
         lz8pN0pweKY8Ywm7eV6AgE/6Ce6Dd2MMOppN47+kA2SDV/BdCfrh63WHuX8ncXcWe2n7
         h6cjNxoZTxTtIYrnR8CjU63iCaKgYz4dmMmWFFDs3YERO+si3BIuAKw1ighy8wUhPT/I
         MIIb+2SuTpXVuI40Mk3kXNHXQsCuFI7W5H3Sx0uEJp3uwMq5089AIAYm9CnpCP4hOyMd
         r4yw==
X-Gm-Message-State: ABy/qLaCc144YrQdK0ZpIlBv+JFCKBXn7cXNLaaeFcKYaEMWTVA9lSO2
        YRY2kCqsTufmBWD9VALrOjFKVUJhsYJ735AWqN8=
X-Google-Smtp-Source: APBJJlG8unC4NI3vyoRqEhxk2e87ftX0VFPToHU5Br3bIxKcqYJe9ZSi3mf0hLaBfoR5QF9T8q+oog==
X-Received: by 2002:a17:902:f683:b0:1b1:9272:55e2 with SMTP id l3-20020a170902f68300b001b1927255e2mr21727777plg.3.1689122832734;
        Tue, 11 Jul 2023 17:47:12 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902b18800b001b694140d96sm2543542plr.170.2023.07.11.17.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 17:47:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] futex: abstract out futex_op_to_flags() helper
Date:   Tue, 11 Jul 2023 18:46:59 -0600
Message-Id: <20230712004705.316157-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712004705.316157-1-axboe@kernel.dk>
References: <20230712004705.316157-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than needing to duplicate this for the io_uring hook of futexes,
abstract out a helper.

No functional changes intended in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    | 15 +++++++++++++++
 kernel/futex/syscalls.c | 11 ++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index b5379c0e6d6d..d2949fca37d1 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -291,4 +291,19 @@ extern int futex_unlock_pi(u32 __user *uaddr, unsigned int flags);
 
 extern int futex_lock_pi(u32 __user *uaddr, unsigned int flags, ktime_t *time, int trylock);
 
+static inline bool futex_op_to_flags(int op, int cmd, unsigned int *flags)
+{
+	if (!(op & FUTEX_PRIVATE_FLAG))
+		*flags |= FLAGS_SHARED;
+
+	if (op & FUTEX_CLOCK_REALTIME) {
+		*flags |= FLAGS_CLOCKRT;
+		if (cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI &&
+		    cmd != FUTEX_LOCK_PI2)
+			return false;
+	}
+
+	return true;
+}
+
 #endif /* _FUTEX_H */
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index a8074079b09e..75ca8c41cc94 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -88,15 +88,8 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	int cmd = op & FUTEX_CMD_MASK;
 	unsigned int flags = 0;
 
-	if (!(op & FUTEX_PRIVATE_FLAG))
-		flags |= FLAGS_SHARED;
-
-	if (op & FUTEX_CLOCK_REALTIME) {
-		flags |= FLAGS_CLOCKRT;
-		if (cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI &&
-		    cmd != FUTEX_LOCK_PI2)
-			return -ENOSYS;
-	}
+	if (!futex_op_to_flags(op, cmd, &flags))
+		return -ENOSYS;
 
 	switch (cmd) {
 	case FUTEX_WAIT:
-- 
2.40.1

