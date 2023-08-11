Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C58477919F
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 16:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbjHKOQm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 10:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235601AbjHKOQd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 10:16:33 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD1D10E4
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 07:16:33 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6874a386ec7so412811b3a.1
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 07:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691763392; x=1692368192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7SdvGakOC76UVVqy+Q7KBbtdiqly+wN0IeNy1TtcFHw=;
        b=yZ0jizWLa+0++mgdS1Vx1V5O0p2BLQ4scMOevPUBIl4x8laXJA/aIp0EdjmJz/h/Ua
         GSQkF52hwg8GF5x28SG7aAqxb+2dp3XK+JF4ZJ/eJfSn2XqBLt6lb1poWLcWV/Fkur4y
         LCQ+UN1nP2ogkioPaom+xeJrhN+zoxR+/nCe9ur80IwhWo+bczxcjDdDaFEIZ2XrtLV0
         0Oo9ummWzCQiDvPP2Ov2Lbz6dSrhtbUL6s5fezYc3uXXNPqbAo4YTCHpBjeQ+gDTeQmr
         mTSaOGrin7EPkIfPsdViCmwW3wArMNbxEPkVGyqNBMryUCAPet4Qj6V3vv/D0oo+2Q4r
         6p9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691763392; x=1692368192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7SdvGakOC76UVVqy+Q7KBbtdiqly+wN0IeNy1TtcFHw=;
        b=TWQTljjsBMhv4dHEwEsKMzj8wIjGU6LI6GxR01Wlb9fjjS8NzWHCKztk2CNczsxsyl
         DTqwqgq5tdpk4DOzWV29M5VDrS4h/q2+9ZwtmA41UhHIyQPLsgtkTZVvEQPohborZCNZ
         kkSgwbnCjLDUMm0I2xEUmqRHMq+XT2Jyb2Nb8tQDAP8trZDUAORZJV4W/rGUXdwv7nrq
         CItvEzsRabdtRRxfO7zZtEBBYhLQBGmJRCP7Abt4qM9hjWXj4kSLLWEb57sPb+0vYtKu
         zvQjFx7LIVTCYltTd0KFYNOgvaJWr709U0y5cot+o2ByQuU3jAsLswGw1shPj8p6tHOy
         gpzA==
X-Gm-Message-State: AOJu0YzZKYFPOVWReIcI2fEKLov7wCZbaXs18VXeP1H6gAKjVUHGLX4k
        nAoIpW67T1FJjAS7Dqif1p2pw9mP9gmbwUfjnF0=
X-Google-Smtp-Source: AGHT+IFTv33H7TQ5Vz1rRa3eC5PGIPsBDbTU66gf2S3cOedCZ9tjfIsdlsRcRn3zS5x6brWuAPPKyg==
X-Received: by 2002:a05:6a21:6d88:b0:13f:9233:58d with SMTP id wl8-20020a056a216d8800b0013f9233058dmr3197361pzb.2.1691763392274;
        Fri, 11 Aug 2023 07:16:32 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s21-20020a639255000000b00564ca424f79sm3422311pgn.48.2023.08.11.07.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 07:16:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] exit: add kernel_waitid_prepare() helper
Date:   Fri, 11 Aug 2023 08:16:24 -0600
Message-Id: <20230811141626.161210-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811141626.161210-1-axboe@kernel.dk>
References: <20230811141626.161210-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the setup logic out of kernel_waitid(), and into a separate helper.

No functional changes intended in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/exit.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d8fb124cc038..5c4cd1769641 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1662,14 +1662,13 @@ static long do_wait(struct wait_opts *wo)
 	return retval;
 }
 
-static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
-			  int options, struct rusage *ru)
+static int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
+				 struct waitid_info *infop, int options,
+				 struct rusage *ru)
 {
-	struct wait_opts wo;
+	unsigned int f_flags = 0;
 	struct pid *pid = NULL;
 	enum pid_type type;
-	long ret;
-	unsigned int f_flags = 0;
 
 	if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED|
 			__WNOTHREAD|__WCLONE|__WALL))
@@ -1712,19 +1711,32 @@ static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
 		return -EINVAL;
 	}
 
-	wo.wo_type	= type;
-	wo.wo_pid	= pid;
-	wo.wo_flags	= options;
-	wo.wo_info	= infop;
-	wo.wo_rusage	= ru;
+	wo->wo_type	= type;
+	wo->wo_pid	= pid;
+	wo->wo_flags	= options;
+	wo->wo_info	= infop;
+	wo->wo_rusage	= ru;
 	if (f_flags & O_NONBLOCK)
-		wo.wo_flags |= WNOHANG;
+		wo->wo_flags |= WNOHANG;
+
+	return 0;
+}
+
+static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
+			  int options, struct rusage *ru)
+{
+	struct wait_opts wo;
+	long ret;
+
+	ret = kernel_waitid_prepare(&wo, which, upid, infop, options, ru);
+	if (ret)
+		return ret;
 
 	ret = do_wait(&wo);
-	if (!ret && !(options & WNOHANG) && (f_flags & O_NONBLOCK))
+	if (!ret && !(options & WNOHANG) && (wo.wo_flags & WNOHANG))
 		ret = -EAGAIN;
 
-	put_pid(pid);
+	put_pid(wo.wo_pid);
 	return ret;
 }
 
-- 
2.40.1

