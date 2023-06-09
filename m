Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E7672A242
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 20:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjFISbf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 14:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjFISbd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 14:31:33 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D55A3A85
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 11:31:32 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-777a9ca9112so20758039f.1
        for <io-uring@vger.kernel.org>; Fri, 09 Jun 2023 11:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686335491; x=1688927491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRcYjvsoYs3sziamhSQYD0QqxzzMy87FZ6PyQbKgmQo=;
        b=PPXRvFdEMz9gAaG477US1WVBni/WF+iO3rgx8ynnUAkmxSlFiazRex2lYED0U6V2VZ
         OAY9FRt/kRdCLgKUB9STG/5Yp6A4AtFmx1vAn1iH5iWxpsoxwzpqm6FLi86SCyajMrKl
         5N1mtPsyyiOqkTPgt+oO1iKKX4+whFFWOh+KXpG1ytrd0DwdVXujekReoKXmK7SjrtZ8
         m7R6q+uRxootQwZ+Bbsf0ShjVoGY7TNU2LJVEezKtPOE+cX1zjTmdF6jA/dV1li4Kcd/
         8aeNE3k8bkv9SALiJe5cWx6z+Qb5IPAWG17yJKhcbg+Mk8ZbK6ToRi+EYk6xPL7WHJpD
         iGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686335491; x=1688927491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRcYjvsoYs3sziamhSQYD0QqxzzMy87FZ6PyQbKgmQo=;
        b=PdbZ9qDialOPTTs9JJxrktll/EurFzKSsX/ZMlezrdcaLKlQ6/5WUsaq73/dTB+yHA
         GzqyR+lDL/cszKkwqrk02UtE1BeaSHVLXhl0d8LPrh9A8CWU3DOsI3hKNXUCGb4+sURu
         RA77Fnqgzh6YDNYD+v9kaWkMxGQWEnA+zRnv+THnbCsQyIR+Drlf6o1D7H6P9GcNUeIX
         1C5xMRlHOWcJp0mc/loyrDR+2XLCsdyKG+TXPFn+5yTzxcqMnnqVe01+/oFWBNr1VK0w
         +EE+Bj+umUp8zYoHpx1xw+Q5tlqJZvF3+kDyGAnWb6zLp3Lqybiq4TlN4eWhYMPG8jm+
         h8hA==
X-Gm-Message-State: AC+VfDyOK7ujcNltYgcNsFIpwL1UqN1dKAeOUTkzFUlMFWulssqjn2u6
        2iyx6gnWZpd0VEHMnJ3pOscO0mavfE1nQDzZT34=
X-Google-Smtp-Source: ACHHUZ7/hrN0SacC93P/3OrV7yYM63SNkWf8vOrKzVIQpNF43WVeUkM/v3cw1HpVWgeJxKbKdl6whw==
X-Received: by 2002:a6b:b308:0:b0:777:a5a8:b6f8 with SMTP id c8-20020a6bb308000000b00777a5a8b6f8mr1799718iof.0.1686335490998;
        Fri, 09 Jun 2023 11:31:30 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j4-20020a02a684000000b0040fb2ba7357sm1103124jam.4.2023.06.09.11.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:31:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] futex: abstract out futex_op_to_flags() helper
Date:   Fri,  9 Jun 2023 12:31:20 -0600
Message-Id: <20230609183125.673140-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230609183125.673140-1-axboe@kernel.dk>
References: <20230609183125.673140-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
2.39.2

