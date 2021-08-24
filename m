Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A063F6883
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 19:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239978AbhHXR7k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 13:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240564AbhHXR7c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 13:59:32 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECCEC0DFC4E
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 10:39:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k8so32481292wrn.3
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 10:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AoA7EkEeK108R+FQtA9oToMKAZvEoSNs7bMpsvocxYA=;
        b=aeOlS7MhIOJCYue1XQZ/USE7TrelTPK6X4FZeTYu5J0OhrqrLKdDrOvAx+7qxSaL4A
         G22RaIZ/h8Jm9m3h42iRAatRK/0QMB+4QwrR+Sv5rCCSWbjZeP6lNThyh45RnF2sUeuP
         H1U132zs/Doosmc0LxYBG4GoFeUwOm6SrrAyQuq5Va+VHK6CE8QXjVjTcW2Rwf7ve9/P
         HsCalwnRK/7FW4vP1Jf2TtcQJ+XBoIiQTn4dQCDJs5BbPXm7TnifR4gVG1fwp28+1VDw
         kg/XV9dxSbYJkIIZTaRDeB8NNB9FRD/vIr5SD3mrNvpOCFSghAC+QZ1NfNZ6LRODrDSt
         bvcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AoA7EkEeK108R+FQtA9oToMKAZvEoSNs7bMpsvocxYA=;
        b=mCks7/qa0AH7VWYTBg3iSyJh52hV1RUAhyUMgiA/4lLxFAGxy9ucLKXF8xUpo0SoGO
         M9sp0W1bDseowW2VfpD3MSJV8n0hyJKMmd4KfVMHzf5uZALz1xxBElHjcdVEhIzQjg1j
         ALBAh+X4mi5mcnM7TCNGDJJPBvDUKTZcyqtVWM7j7XRI3df2zKBBIdNLW6o9lqrLoC+N
         CJYefEMq5ShrFdIlLKn/CzslMxYqs8GViNA5G3AIoZb/Wm2NPxXjDTEYCdilt5PD7V6D
         /eL+mhMlkceyIZwmWJsywMNanNDXGRB0cWBLTo7yNfs66KIam8ilAwkZehIlMBxis1AF
         w+Ew==
X-Gm-Message-State: AOAM531tGBKeQwsEZxzItl31zmJx12NyHNdl6+xVgDQmR4KR7/sbIX/z
        f2c1i+UIN1S1mwk6XftvqTmL5GhzpSU=
X-Google-Smtp-Source: ABdhPJz1zJiLM2yWhsEKLNLdpzwM2WfCcu0LL3U6qhR2gDrrDPsWlSSZL0EACNScMXGmEBj2Fc5G6A==
X-Received: by 2002:a5d:6d86:: with SMTP id l6mr1359149wrs.158.1629826766326;
        Tue, 24 Aug 2021 10:39:26 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id z6sm2853471wmp.1.2021.08.24.10.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 10:39:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/1] tests: fix poll-mshot-update
Date:   Tue, 24 Aug 2021 18:38:47 +0100
Message-Id: <7e588f712ec61e0ddc619ce016d1c3b9445716e1.1629826707.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

poll-mshot-update constantly hangs. Apparently, the reason is
reap_polls() clearing ->triggered flags racing with trigger_polls()
setting them. So, reinit the flags only after joining the thread.

Also, replace magic constants with proper identificators, e.g.
1 -> IORING_POLL_ADD_MULTI.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/poll-mshot-update.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/test/poll-mshot-update.c b/test/poll-mshot-update.c
index a3e4951..6bf4679 100644
--- a/test/poll-mshot-update.c
+++ b/test/poll-mshot-update.c
@@ -71,7 +71,7 @@ static int arm_poll(struct io_uring *ring, int off)
 	}
 
 	io_uring_prep_poll_add(sqe, p[off].fd[0], POLLIN);
-	sqe->len = 1;
+	sqe->len = IORING_POLL_ADD_MULTI;
 	sqe->user_data = off;
 	return 0;
 }
@@ -88,7 +88,7 @@ static int reap_polls(struct io_uring *ring)
 		sqe = io_uring_get_sqe(ring);
 		/* update event */
 		io_uring_prep_poll_update(sqe, (void *)(unsigned long)i, NULL,
-					  POLLIN, 2);
+					  POLLIN, IORING_POLL_UPDATE_EVENTS);
 		sqe->user_data = 0x12345678;
 	}
 
@@ -107,7 +107,6 @@ static int reap_polls(struct io_uring *ring)
 		off = cqe->user_data;
 		if (off == 0x12345678)
 			goto seen;
-		p[off].triggered = 0;
 		ret = read(p[off].fd[0], &c, 1);
 		if (ret != 1) {
 			if (ret == -1 && errno == EAGAIN)
@@ -195,7 +194,7 @@ int main(int argc, char *argv[])
 	struct io_uring_params params = { };
 	struct rlimit rlim;
 	pthread_t thread;
-	int i, ret;
+	int i, j, ret;
 
 	if (argc > 1)
 		return 0;
@@ -256,6 +255,9 @@ int main(int argc, char *argv[])
 		if (ret)
 			goto err;
 		pthread_join(thread, NULL);
+
+		for (j = 0; j < NFILES; j++)
+			p[j].triggered = 0;
 	}
 
 	io_uring_queue_exit(&ring);
-- 
2.32.0

