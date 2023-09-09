Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546997999BD
	for <lists+io-uring@lfdr.de>; Sat,  9 Sep 2023 18:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjIIQZk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Sep 2023 12:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346568AbjIIPLn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Sep 2023 11:11:43 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2631AA
        for <io-uring@vger.kernel.org>; Sat,  9 Sep 2023 08:11:39 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b89b0c73d7so6309435ad.1
        for <io-uring@vger.kernel.org>; Sat, 09 Sep 2023 08:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694272298; x=1694877098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hj0krNamRyunx+87gZWWI4NCQd0EZ/VG7L3ywY2jp+A=;
        b=IREUPGI/rhLzFa4bSWb/x3u6PFPFlqoK8iNwniZBosxMls25K8TolPbfsi3z6TxF8M
         Nf2fEaojXZBullHPWjNpSUNWv+Wb6OBm66cuYo4QESDc3SoZD1arSKafAt/flRDib9xf
         Gsmy6MNo8oN53sBfxbJT6EeOmZPIrlrP1amO4BMTEhg/DVcsWeM+I0Ucy/pgsrAAZ7RL
         K8Iy3QDcD+LHmv+k7FwY8lGazgVYNgmNq2BRk4DVefxLJON2jgrvfmNbrIGgYw3j6AAa
         R0UWbrWn6teejSEz2hEWj30Obv8bpNefd2gvOmZa0+nLG4eXVqy5gOVyk2nomrRF1GhZ
         zu1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694272298; x=1694877098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hj0krNamRyunx+87gZWWI4NCQd0EZ/VG7L3ywY2jp+A=;
        b=qYgOa8S/9ldPnRrg/TsDsph7UVWy4f1Pq70hwx2j9jB2DWu9fHnr5GwCm3SnJf+LBQ
         3mQw3wirpL0qfhKmncxan6ykSErd/DW4D8Haty5nPXS4PWSvVwxgrwAsbxiHUSPGTAwb
         I2ymJSGHg+BValBofiNYD2dDVJ8inFFwiVHBGQ3D/ExLhK3byBGeJYC86YWlGvEQCNPx
         NhwxQGDWBaQ+Ddy2QFtG+HdZG3HSff6VHE6ZDBaRED4aRxBhOHrF6E/Fps6dVChLVYkG
         s/TLoZjVvARgFEoor6MboxaVfjVGP6glzzHnhnxGgimPaqtm5r1nYtyYLrdVV+FtibR2
         J3TA==
X-Gm-Message-State: AOJu0YzKprS3XNHrwkk9KntiTJKUiTiu0UwmPzFWkFv2mY8mQF8XuHME
        D+UYAikKhEbot0DFOIgyB4hlAmYutMckbx+Iw0+2yg==
X-Google-Smtp-Source: AGHT+IFeGlliY0bcmNr6CAhPU+5bLogwMp6BCuBJzKimTG8ALA5dXgvUOijxo1ZSXplYdvAZ+uqWcg==
X-Received: by 2002:a17:902:e546:b0:1bb:9e6e:a9f3 with SMTP id n6-20020a170902e54600b001bb9e6ea9f3mr6242597plf.4.1694272298339;
        Sat, 09 Sep 2023 08:11:38 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902ff0f00b001bdb0483e65sm3371450plj.265.2023.09.09.08.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Sep 2023 08:11:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] exit: add kernel_waitid_prepare() helper
Date:   Sat,  9 Sep 2023 09:11:22 -0600
Message-Id: <20230909151124.1229695-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230909151124.1229695-1-axboe@kernel.dk>
References: <20230909151124.1229695-1-axboe@kernel.dk>
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
index c6fba9ecca27..817c22bd7ae0 100644
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

