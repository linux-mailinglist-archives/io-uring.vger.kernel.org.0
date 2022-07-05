Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D53566FEF
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 15:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiGENxg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 09:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiGENxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 09:53:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DDA24BF1
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 06:29:57 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6C8ED1FED2;
        Tue,  5 Jul 2022 13:29:56 +0000 (UTC)
Received: from oldboy.suse.de (unknown [10.168.4.145])
        by relay2.suse.de (Postfix) with ESMTP id 5A6952C141;
        Tue,  5 Jul 2022 13:29:56 +0000 (UTC)
From:   =?UTF-8?q?Dirk=20M=C3=BCller?= <dirk@dmllr.de>
To:     io-uring@vger.kernel.org
Cc:     =?UTF-8?q?Dirk=20M=C3=BCller?= <dirk@dmllr.de>
Subject: [PATCH] Handle EINTR in tests
Date:   Tue,  5 Jul 2022 15:29:39 +0200
Message-Id: <20220705132939.7744-1-dirk@dmllr.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On an otherwise busy machine the test suite is quite flaky. Restart
the syscalls that are aborted with EINTR.

Signed-off-by: Dirk Müller <dirk@dmllr.de>
---
 test/ce593a6c480a.c | 5 ++++-
 test/io-cancel.c    | 7 ++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/test/ce593a6c480a.c b/test/ce593a6c480a.c
index 1c5669e..4c71fbc 100644
--- a/test/ce593a6c480a.c
+++ b/test/ce593a6c480a.c
@@ -111,7 +111,10 @@ int main(int argc, char *argv[])
 			(void*) (intptr_t) other_fd);
 
 	/* Wait on the event fd for an event to be ready */
-	ret = read(loop_fd, buf, 8);
+	do {
+		ret = read(loop_fd, buf, 8);
+	} while (ret < 0 && errno == EINTR);
+
 	if (ret < 0) {
 		perror("read");
 		return T_EXIT_FAIL;
diff --git a/test/io-cancel.c b/test/io-cancel.c
index d5e3ae9..13bf84f 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -365,8 +365,13 @@ static int test_cancel_req_across_fork(void)
 		exit(0);
 	} else {
 		int wstatus;
+		pid_t childpid;
 
-		if (waitpid(p, &wstatus, 0) == (pid_t)-1) {
+		do {
+			childpid = waitpid(p, &wstatus, 0);
+		} while (childpid == (pid_t)-1 && errno == EINTR);
+
+		if (childpid == (pid_t)-1) {
 			perror("waitpid()");
 			return 1;
 		}
-- 
2.36.1

