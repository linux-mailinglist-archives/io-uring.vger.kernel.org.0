Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63ABC5ACEEC
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 11:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbiIEJdl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 05:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237619AbiIEJdf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 05:33:35 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23A64BA7F
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 02:33:34 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.42.181])
        by gnuweeb.org (Postfix) with ESMTPSA id EF90E7E3B9;
        Mon,  5 Sep 2022 09:33:30 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662370414;
        bh=JpDNIqOC08gmP+Eu+KSeagACX8qJOVufyb5bcqAy/Ok=;
        h=From:To:Cc:Subject:Date:From;
        b=KjBFa8X2UVU+9G8ykNrCE1CwsEVabnKRq/vvGFz35JqFa9oEBkeujxPCr0WlLQi4f
         yspFU1YfBBFlCvVUWPS6jf1gsa0Wu3K8gCs70cPWCl4lyviAnyD/RYkP0zKFFOLbSE
         MHLMMzyPhE2qWnQT11nQiRc5M0P8TvShijfnUBBiigJv5qu0DRAip0aFcjGTu1Jgot
         Az/gNvJ6hojCJvFGVGzDvbfMrwI18+A1jAosrx+Kbe7IB9mbs9azT+goN9M2Gj0RBR
         uQypbPdwuRvJcEaxsXF55YknP605stRyfFp8LBATOxVkv7Nv+py3QBBKye7RV2C2zg
         fnMuNXmc/sRIA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH liburing v2] test/ringbuf-read: Delete `.ringbuf-read.%d` before exit
Date:   Mon,  5 Sep 2022 16:33:17 +0700
Message-Id: <20220905093126.376009-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SORBS_WEB,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Running test/ringbuf-read.t leaves untracked files in git status:

  Untracked files:
    (use "git add <file>..." to include in what will be committed)
          .ringbuf-read.163521
          .ringbuf-read.163564
          .ringbuf-read.163605
          .ringbuf-read.163648

Make sure we unlink it properly. While in there, fix the exit code,
use T_EXIT_*.

v2:
  - Use T_EXIT_* for exit code (comment from Alviro).

Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/ringbuf-read.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/test/ringbuf-read.c b/test/ringbuf-read.c
index 673f2de..8616a49 100644
--- a/test/ringbuf-read.c
+++ b/test/ringbuf-read.c
@@ -133,63 +133,68 @@ static int test(const char *filename, int dio, int async)
 
 int main(int argc, char *argv[])
 {
 	char buf[BUF_SIZE];
 	char fname[80];
 	int ret, fd, i, do_unlink;
 
 	if (argc > 1) {
 		strcpy(fname, argv[1]);
 		do_unlink = 0;
 	} else {
 		sprintf(fname, ".ringbuf-read.%d", getpid());
 		t_create_file(fname, FSIZE);
 		do_unlink = 1;
 	}
 
 	fd = open(fname, O_WRONLY);
 	if (fd < 0) {
 		perror("open");
 		goto err;
 	}
 	for (i = 0; i < NR_BUFS; i++) {
 		memset(buf, i + 1, BUF_SIZE);
 		ret = write(fd, buf, BUF_SIZE);
 		if (ret != BUF_SIZE) {
 			fprintf(stderr, "bad file prep write\n");
+			close(fd);
 			goto err;
 		}
 	}
 	close(fd);
 
 	ret = test(fname, 1, 0);
 	if (ret) {
 		fprintf(stderr, "dio test failed\n");
-		return ret;
+		goto err;
 	}
 	if (no_buf_ring)
-		return 0;
+		goto pass;
 
 	ret = test(fname, 0, 0);
 	if (ret) {
 		fprintf(stderr, "buffered test failed\n");
-		return ret;
+		goto err;
 	}
 
 	ret = test(fname, 1, 1);
 	if (ret) {
 		fprintf(stderr, "dio async test failed\n");
-		return ret;
+		goto err;
 	}
 
 	ret = test(fname, 0, 1);
 	if (ret) {
 		fprintf(stderr, "buffered async test failed\n");
-		return ret;
+		goto err;
 	}
 
-	return 0;
+pass:
+	ret = T_EXIT_PASS;
+	goto out;
 err:
+	ret = T_EXIT_FAIL;
+out:
 	if (do_unlink)
 		unlink(fname);
-	return 1;
+	return ret;
 }

base-commit: 3bd7d6b27e6b7d7950bba1491bc9c385378fe4dd
-- 
Ammar Faizi

