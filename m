Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3999375BA74
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjGTWTe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjGTWTa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:19:30 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238152D55
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:19 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-785ccd731a7so17738539f.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689891558; x=1690496358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GnoTCF2aB/aSqWAJBLGbR4gHlscBgYaA7yXEbb2wyGE=;
        b=Q0st3/uuG+jmslAaSSiW1B/Bh02MVEa8TbQgCgFVQqY2UOskLaiChfSXbE5u306RwE
         /1d8d7kO9+BLFVoQ/IsCvuamQmixezGP3fpL+Yqa3RGQE4S/Kr7iJMXWM7bi9xbHPbiB
         NU10/v4EYu6lYpP7RWP49FgU3SPYyDh0n0tYDQe8b7cLIlCr0pXANH7grAtV6JM4MV6Z
         HGnyq4VGdfAUyoDQAEq2+pZ6tHwiBHBD7M3Eupp00m46BKov5Ezh+ANgfhYO4Cx+/lxl
         /OrUNy7KLxAyyN4H0pC1Q3WmysodwCXsAhUZGu/a+k5HT9GfGdDKclTggq6wLbeZRcPB
         n8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689891558; x=1690496358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GnoTCF2aB/aSqWAJBLGbR4gHlscBgYaA7yXEbb2wyGE=;
        b=NoQo68Ml5HL8zpuL9QQdeFHS+YXok+OWGANMxMFUOgfqacYOBgdiExjIKEjhhhraeU
         98I9rYqjn0ca1KRRc/qgoKmQdMlQ2X53U5aEkKIA8e6cYvFXUkoFEC3WBouiEfflLZuv
         bu6ttd0qkwaBtR0UghsilaG/kkwo/GFZ4RjRPV7F/3OhDmqNIUd9NMzNuvcUH8n7Eb/H
         oVcDYWYHw42rdWrQKV4aiUHdZsF432jkuTd2qepuJjnFMM8kdeBAazAHVCejd3/wvtdD
         Y2pO1GQSVHCaU5EPCCO5taeaTddSu2kBVO143byRwpzroSxeMEY4iRZoJWG6Mueygop/
         +XdA==
X-Gm-Message-State: ABy/qLY622GcjVfP4SKybqzkTEZ4M52reDDRuH/PxnzazXuQDNdIsFNs
        aPCS/5J+P/e4SFtBVXWnk64bOkkZ27M7++9p/EA=
X-Google-Smtp-Source: APBJJlHJ3y0UO1OnuKcbD2vWBLPGzHgJOOKVljSm7EoBfs00AdoLwdBa0iHswzpqam3eIWA8noQUyA==
X-Received: by 2002:a05:6602:14d2:b0:783:6ec1:65f6 with SMTP id b18-20020a05660214d200b007836ec165f6mr184768iow.1.1689891558118;
        Thu, 20 Jul 2023 15:19:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q1-20020a63bc01000000b0055b3af821d5sm1762454pge.25.2023.07.20.15.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 15:19:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/10] futex: make futex_parse_waitv() available as a helper
Date:   Thu, 20 Jul 2023 16:18:56 -0600
Message-Id: <20230720221858.135240-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720221858.135240-1-axboe@kernel.dk>
References: <20230720221858.135240-1-axboe@kernel.dk>
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

To make it more generically useful, augment it with allowing the caller
to pass in the wake handler and wake data. Convert the futex_waitv()
syscall, passing in the default handlers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    |  5 +++++
 kernel/futex/syscalls.c | 14 ++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 292224816814..3536d21adff9 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -327,6 +327,11 @@ struct futex_vector {
 	struct futex_q q;
 };
 
+extern int futex_parse_waitv(struct futex_vector *futexv,
+			     struct futex_waitv __user *uwaitv,
+			     unsigned int nr_futexes, futex_wake_fn *wake,
+			     void *wake_data);
+
 extern int futex_wait_multiple(struct futex_vector *vs, unsigned int count,
 			       struct hrtimer_sleeper *to);
 
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 7234538a490d..a182ea44ea89 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -187,12 +187,15 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
  * @futexv:	Kernel side list of waiters to be filled
  * @uwaitv:     Userspace list to be parsed
  * @nr_futexes: Length of futexv
+ * @wake:	Wake to call when futex is woken
+ * @wake_data:	Data for the wake handler
  *
  * Return: Error code on failure, 0 on success
  */
-static int futex_parse_waitv(struct futex_vector *futexv,
-			     struct futex_waitv __user *uwaitv,
-			     unsigned int nr_futexes)
+int futex_parse_waitv(struct futex_vector *futexv,
+		      struct futex_waitv __user *uwaitv,
+		      unsigned int nr_futexes, futex_wake_fn *wake,
+		      void *wake_data)
 {
 	struct futex_waitv aux;
 	unsigned int i;
@@ -219,6 +222,8 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 		futexv[i].w.val = aux.val;
 		futexv[i].w.uaddr = aux.uaddr;
 		futexv[i].q = futex_q_init;
+		futexv[i].q.wake = wake;
+		futexv[i].q.wake_data = wake_data;
 	}
 
 	return 0;
@@ -295,7 +300,8 @@ SYSCALL_DEFINE5(futex_waitv, struct futex_waitv __user *, waiters,
 		goto destroy_timer;
 	}
 
-	ret = futex_parse_waitv(futexv, waiters, nr_futexes);
+	ret = futex_parse_waitv(futexv, waiters, nr_futexes, futex_wake_mark,
+				NULL);
 	if (!ret)
 		ret = futex_wait_multiple(futexv, nr_futexes, timeout ? &to : NULL);
 
-- 
2.40.1

