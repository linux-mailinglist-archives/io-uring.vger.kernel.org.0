Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3717444309B
	for <lists+io-uring@lfdr.de>; Tue,  2 Nov 2021 15:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhKBOlh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Nov 2021 10:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhKBOlh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Nov 2021 10:41:37 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC8DC061714
        for <io-uring@vger.kernel.org>; Tue,  2 Nov 2021 07:39:02 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so2167080wme.0
        for <io-uring@vger.kernel.org>; Tue, 02 Nov 2021 07:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GbZVKJHRRRy7B2uL7FoR2JTeAAV41FV6VMqdaoj3QOU=;
        b=g+WuFc5Nky0a0/nhfqqaCgPZ2hGwRhkJpFsI1TUD1/Rqj7CfrCNMo7XwFpTNWJyHtp
         Zazdo/sg24VPdVuba8H+SmdKibi1MCvudf/TsmGKkxnWdk6UzvwEZ/DDcgPUAHGDBRo2
         83oUiAWxrP730u3Y2Palrrjnx+XxMoOgcnF+EYIiRkyonoaT852+Z7I+pAwNKW6HeuMR
         LJ35ktTuI9H/Bv9LZRe3f0NDz4i3rtvNtlBYTLbYB8BFa/0lOShVKvLKKwJ+twj76CFS
         VT/x9Ax4DjhLNNXqwkFGS4ihcNn8Vs3JNmBpzoEgJVAJAcv/n/yIX4VpVJ46nfHYIX8/
         +M2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GbZVKJHRRRy7B2uL7FoR2JTeAAV41FV6VMqdaoj3QOU=;
        b=pgpDbQMiJW/CDQljQnxq0TyXljd2VUF7WhRwEeMXLsq65EBdFjU4NzGNS1H1GZTsJp
         tAHtFC3p3SdHrKduQNyaq+7IO0rGdU2ROZe76T38qOoIf1PYTXkB90AYGdh5CK048jvx
         6UGdjDD5/cZU5xylTEsmYm+tbnidBv67CeMwdxq4coqTO+m7U96Enl/yt1Q150ugE6gN
         ahLLQJ1LxGOTYkO/ZfZ2fA2J5GVP0bTxv6WRcoLpt69nPg4FNVJSAbboJ1mylTF2zzyH
         /gdyJd62bouHHiY/khR2e+kKjJ8xvRjDuS5ooNOcFb4XyWSk2I7JkpA9TjyxXTXvtJRq
         K8Ag==
X-Gm-Message-State: AOAM531iz3VuTUiy1Ug3BEf7GXeHBmHJoce8Nywxv9tzYwo+7qQ7phr8
        8JSAHWBV56ZP2PKQCQ2FqF9mJirp8LI=
X-Google-Smtp-Source: ABdhPJw5N2nbNelbNERr/3xIXiBomyAPs6rx7QU6XRtOVXVZtmRgcZwgkXzWEglTe1vgCc2JOZ0OJg==
X-Received: by 2002:a1c:183:: with SMTP id 125mr8021811wmb.0.1635863940932;
        Tue, 02 Nov 2021 07:39:00 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.219])
        by smtp.gmail.com with ESMTPSA id 10sm7260317wrb.75.2021.11.02.07.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 07:39:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/1] io_uring: clean up io_queue_sqe_arm_apoll
Date:   Tue,  2 Nov 2021 14:38:52 +0000
Message-Id: <130b1ea5605bbd81d7b874a95332295799d33b81.1635863773.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The fix for linked timeout unprep got a bit distored with two rebases,
handle linked timeouts for IO_APOLL_READY as with all other cases, i.e.
queue it at the end of the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3ecd4b51510e..61c962c29235 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6950,10 +6950,6 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 
 	switch (io_arm_poll_handler(req)) {
 	case IO_APOLL_READY:
-		if (linked_timeout) {
-			io_queue_linked_timeout(linked_timeout);
-			linked_timeout = NULL;
-		}
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-- 
2.33.1

