Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B996750E50
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 18:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjGLQWR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 12:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbjGLQVk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 12:21:40 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AD830C3
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:45 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-682a5465e9eso1185204b3a.1
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689178845; x=1691770845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9IAdtt3/8DuY/QVZDICwnJG5hoGWNTwXHfpUVZziX4=;
        b=EM+PCGQWHPEVzL/Jc93Q5nC/tU063wfXE0e/0WH0Azz+MQ8bmp/vwQhO8z5thcxBS/
         ALTHKAPnHqLlU68wt2akeyFfBAU7SpDe6fJtnjleudk0djnb/RCiifn93hVHVDo06UE3
         lXBkJjmCF94KWc+TMT5Hcm16xDWp/POmxLJbMy81WBSJEiNVGN/GEVNd6Dz6LjjxpSmU
         CBQ5D2AIml3CfkDh3MzOzHxwZ/sE/Gu/Vvw73Dg58bNTx75oe8m61jqJ6SQz1JXHz9Im
         T0NbV/6u3YknwV7F/AxDvsTUluf0diDhAuQXWTSG4gL98OFv6ECMX0IWq3IS5UKU1Puk
         BGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178845; x=1691770845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9IAdtt3/8DuY/QVZDICwnJG5hoGWNTwXHfpUVZziX4=;
        b=UVRVdkkFWwfNGpmUK5iqcLvuzzo8S0tzZI5bCBj7s/npGHj3C1U76I6dkk82u3/UDD
         ZxS4RIPiu1xur9DK4KoCVMnCfDEYHG7WQeWw8ZFw+OHTatbaiCNhFee+rdHFioopbLuy
         tA838Z1g6OhsUgG/TVlE0F8OhuS0CqcKtE/Gw8x8p7KDLmcZXkUSCvQHVm4UmBFp+wjm
         IecpXHyNYMp7MaWHCB22PtWcS9Tr67O8WP1Amf185V8WlVPrmQztChSE24xqNlb142TD
         ncH+hCXkGdI9AVUuqdt8cxIx2KgcgFpqKMEL4j0dvrW/4r57i4n1Vw5x7kf0ysFK42hq
         J4QQ==
X-Gm-Message-State: ABy/qLZKGoxP9Sy7y2evPS7JQ6RijKV85HRSwlH8wx5MZB+k1/N80Us3
        sMctXrQJ14AEmuijDq0sdBSq4x2UCCcGRQfEie4=
X-Google-Smtp-Source: APBJJlEtOypA1RFF8/aajtMhumzTpVGIjNpPO69tWC224DdJYo4Sumfefx+Y7aU9ZQQPwkdTtOVHyw==
X-Received: by 2002:a05:6602:1490:b0:787:16ec:2699 with SMTP id a16-20020a056602149000b0078716ec2699mr11094280iow.2.1689178824145;
        Wed, 12 Jul 2023 09:20:24 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x24-20020a029718000000b0042aec33bc26sm1328775jai.18.2023.07.12.09.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:20:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] futex: abstract out futex_op_to_flags() helper
Date:   Wed, 12 Jul 2023 10:20:10 -0600
Message-Id: <20230712162017.391843-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712162017.391843-1-axboe@kernel.dk>
References: <20230712162017.391843-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
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
 kernel/futex/futex.h    | 17 +++++++++++++++++
 kernel/futex/syscalls.c | 13 +++----------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index b5379c0e6d6d..b8f454792304 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -291,4 +291,21 @@ extern int futex_unlock_pi(u32 __user *uaddr, unsigned int flags);
 
 extern int futex_lock_pi(u32 __user *uaddr, unsigned int flags, ktime_t *time, int trylock);
 
+static inline bool futex_op_to_flags(int op, int cmd, unsigned int *flags)
+{
+	*flags = 0;
+
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
index a8074079b09e..0b63d5bcdc77 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -86,17 +86,10 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
 	int cmd = op & FUTEX_CMD_MASK;
-	unsigned int flags = 0;
+	unsigned int flags;
 
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

