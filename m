Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FA65ACC26
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 09:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbiIEHTI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 03:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237566AbiIEHSf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 03:18:35 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F204DB30
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 00:13:46 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.39.110])
        by gnuweeb.org (Postfix) with ESMTPSA id 2F2747E254;
        Mon,  5 Sep 2022 07:12:42 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662361967;
        bh=KNnxh4u9cUj673J8B4AGd0GRsIg4ioEtEBcVVBlMeA8=;
        h=From:To:Cc:Subject:Date:From;
        b=XUEAOMVty/REKqmrjuSz9M7+TP5GGAyIm5RudocDucCV8+b8LKzAuw7vDm1fLc0VF
         JHR14v8hFHdEC4ePoj0BeqzmqgvaPGWZbFQAjWGQyVCkGWEJvvnajotZ9bh9yt/Wuo
         D3We0gspErpHCpc1Guq0HbsMFgMdjuTKA4l25IImZKqZ0zqYubRC1FsSpyTrPPPfIe
         jjbkrOTufcIajuf2yVia2sFwSNvvwxHac8+brZKzSAjDyEXPxJkWCLaHX2AiuW0WZx
         +z6MaN7eT5BqQ/3nfM/MhpatPfWeSKr2RXBzG58UPP9sZ00qJvdnVMUkErb+Jf82be
         XZc2ctp5vyG5Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
Subject: [PATCH liburing v1] test/ringbuf-read: Delete `.ringbuf-read.%d` before exit
Date:   Mon,  5 Sep 2022 14:12:28 +0700
Message-Id: <20220905070633.187725-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Make sure we unlink it properly.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/ringbuf-read.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/test/ringbuf-read.c b/test/ringbuf-read.c
index 673f2de..060eb1d 100644
--- a/test/ringbuf-read.c
+++ b/test/ringbuf-read.c
@@ -133,63 +133,64 @@ static int test(const char *filename, int dio, int async)
 
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
-		goto err;
+		ret = 1;
+		goto out;
 	}
 	for (i = 0; i < NR_BUFS; i++) {
 		memset(buf, i + 1, BUF_SIZE);
 		ret = write(fd, buf, BUF_SIZE);
 		if (ret != BUF_SIZE) {
 			fprintf(stderr, "bad file prep write\n");
-			goto err;
+			ret = 1;
+			close(fd);
+			goto out;
 		}
 	}
 	close(fd);
 
 	ret = test(fname, 1, 0);
 	if (ret) {
 		fprintf(stderr, "dio test failed\n");
-		return ret;
+		goto out;
+	}
+	if (no_buf_ring) {
+		ret = 0;
+		goto out;
 	}
-	if (no_buf_ring)
-		return 0;
 
 	ret = test(fname, 0, 0);
 	if (ret) {
 		fprintf(stderr, "buffered test failed\n");
-		return ret;
+		goto out;
 	}
 
 	ret = test(fname, 1, 1);
 	if (ret) {
 		fprintf(stderr, "dio async test failed\n");
-		return ret;
+		goto out;
 	}
 
 	ret = test(fname, 0, 1);
-	if (ret) {
+	if (ret)
 		fprintf(stderr, "buffered async test failed\n");
-		return ret;
-	}
-
-	return 0;
-err:
+out:
 	if (do_unlink)
 		unlink(fname);
-	return 1;
+	return ret;
 }

base-commit: 3bd7d6b27e6b7d7950bba1491bc9c385378fe4dd
-- 
Ammar Faizi

