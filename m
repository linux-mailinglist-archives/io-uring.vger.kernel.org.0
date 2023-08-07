Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F2D771850
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 04:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjHGCYw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Aug 2023 22:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjHGCYv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Aug 2023 22:24:51 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637611703;
        Sun,  6 Aug 2023 19:24:49 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4RK0Wx39WDz9sDN;
        Mon,  7 Aug 2023 04:24:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
        t=1691375085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RjIz0d/LyFh1HN+ykIhW6eGVn/BJvPsew0dX158t2RI=;
        b=iEWTtFcZdxFOAs+0l4674VmuAzO4IeVvxQuFCMi1YnnjgDoz+UBrg3UFMdBQzUQQrDiQj1
        +RErtXMyktY7sc6YQ8//gSCg5J0ESHLYR9UwgKdVrdwaoRjn3FJ8mGTGO8vt+T09v4aeN9
        p/+p/921P/sLb433m2azotaAUXHwfztOIzAkniIRTQCZH7a+I0S/NWcecB9UUNM9vqZs84
        KjHUFFYqy0OjjiggjtfU4PfnZztixc19J+kv6JC9lDUPJqP1XkQgwVd0bZTHDyOtqsC/1V
        HrB8C09v2XwZ+MHQbGOReiHJS5+PevJsJstazC/eGgQWvmTKzXdIkFMGAlJ6Ww==
From:   Aleksa Sarai <cyphar@cyphar.com>
Date:   Mon, 07 Aug 2023 12:24:15 +1000
Subject: [PATCH v3] io_uring: correct check for O_TMPFILE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230807-resolve_cached-o_tmpfile-v3-1-e49323e1ef6f@cyphar.com>
X-B4-Tracking: v=1; b=H4sIAM5V0GQC/43NwQ6DIAyA4VdZOK8LoCLbae+xLEawDBIVA4bMG
 N996G03j3/Tfl1JxOAwksdlJQGTi86POYrrhWjbjh8E1+UmnPKCSiogYPR9wka32mIHvpmHybg
 e4V5LrXghVSckyedTQOO+B/1657Yuzj4sx6fE9ukJNDFgUKuWibxYigqfeplsG27aD2RXEz8rc
 aBAK6mM4aVRTPxJ27b9AEPcKzgLAQAA
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, stable@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1769; i=cyphar@cyphar.com;
 h=from:subject:message-id; bh=wPyNGrBAAbtCrG61WptNEwxMQZr6Mx68bOkIIkKOnxc=;
 b=owGbwMvMwCWmMf3Xpe0vXfIZT6slMaRcCH3+66lU9Yokud4DnadP+r79vGenfnHfafFQjhNM9
 Ut3WT817ShlYRDjYpAVU2TZ5ucZumn+4ivJn1aywcxhZQIZwsDFKQATOfKH4Z9xOGOgToaO4oSL
 Gaz6gnNnZXSIHDdNqrvQcP3Vv4PLOJsZGd7U/TywKK76zOb0LvujdWX5S3Zk7Hzx23xaVoW85Z0
 z1YwA
X-Developer-Key: i=cyphar@cyphar.com; a=openpgp;
 fpr=C9C370B246B09F6DBCFC744C34401015D1D2D386
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

O_TMPFILE is actually __O_TMPFILE|O_DIRECTORY. This means that the old
check for whether RESOLVE_CACHED can be used would incorrectly think
that O_DIRECTORY could not be used with RESOLVE_CACHED.

Cc: stable@vger.kernel.org # v5.12+
Fixes: 3a81fd02045c ("io_uring: enable LOOKUP_CACHED path resolution for filename lookups")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
Changes in v3:
- drop openat2 patch, as it's already in Christian's tree
- explain __O_TMPFILE usage in io_openat_force_async comment
- v2: https://lore.kernel.org/r/20230806-resolve_cached-o_tmpfile-v2-0-058bff24fb16@cyphar.com

Changes in v2:
- fix io_uring's io_openat_force_async as well.
- v1: <https://lore.kernel.org/r/20230806-resolve_cached-o_tmpfile-v1-1-7ba16308465e@cyphar.com>
---
 io_uring/openclose.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 10ca57f5bd24..e3fae26e025d 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -35,9 +35,11 @@ static bool io_openat_force_async(struct io_open *open)
 {
 	/*
 	 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
-	 * it'll always -EAGAIN
+	 * it'll always -EAGAIN. Note that we test for __O_TMPFILE because
+	 * O_TMPFILE includes O_DIRECTORY, which isn't a flag we need to force
+	 * async for.
 	 */
-	return open->how.flags & (O_TRUNC | O_CREAT | O_TMPFILE);
+	return open->how.flags & (O_TRUNC | O_CREAT | __O_TMPFILE);
 }
 
 static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)

---
base-commit: 272af00d6825f19b48b9d9cfd11b1f6bdc011e2c
change-id: 20230806-resolve_cached-o_tmpfile-978cb238bd68

Best regards,
-- 
Aleksa Sarai <cyphar@cyphar.com>

