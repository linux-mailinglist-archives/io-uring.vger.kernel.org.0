Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8517712EF
	for <lists+io-uring@lfdr.de>; Sun,  6 Aug 2023 00:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjHEWtB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Aug 2023 18:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjHEWs7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Aug 2023 18:48:59 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050:0:465::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914AD19B5;
        Sat,  5 Aug 2023 15:48:58 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4RJHnM24c3z9sXg;
        Sun,  6 Aug 2023 00:48:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
        t=1691275735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gTrtNNENm22a5owwWX6fpH4Q0oDQAef+vTZzTwxbU1c=;
        b=C6iyo5xuH4J6DGdV5Wj/y8uix7OOeA27r7ua4t2iV+7C6dZA8n5Ldj6aFLCYDQfgHTGcQh
        kmBvrUCDvougnR6fgcy2cxKzNVgCBma+Zw9YZMIn+EiJPH2ADKmrCAN1qWVWCYPLusDsP6
        B4QDsE6njXYpWhexLFd2tCCHqG4Z34ioEGajXFPcpBvQqewxkqcV9S/26DFLtGk3128C7E
        J4tw0VX1+UzMU4eOgChKBLunnrmBknICUOtnYqJQbfwp7TIt2jHi7EiTqmzGHHNacWJgaL
        HCjncVCUHuWulXxj2fkMksi0X8TmZ2eb9YmRvdH9vTFsuFPRSgceYVPPqCmSUw==
From:   Aleksa Sarai <cyphar@cyphar.com>
Date:   Sun, 06 Aug 2023 08:48:09 +1000
Subject: [PATCH v2 2/2] io_uring: correct check for O_TMPFILE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230806-resolve_cached-o_tmpfile-v2-2-058bff24fb16@cyphar.com>
References: <20230806-resolve_cached-o_tmpfile-v2-0-058bff24fb16@cyphar.com>
In-Reply-To: <20230806-resolve_cached-o_tmpfile-v2-0-058bff24fb16@cyphar.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        stable@vger.kernel.org
X-Developer-Signature: v=1; a=openpgp-sha256; l=1068; i=cyphar@cyphar.com;
 h=from:subject:message-id; bh=/9+yxvKGEmdLwvOcpr7FLQ4otf1WYZ3hs0L34KRntms=;
 b=owGbwMvMwCWmMf3Xpe0vXfIZT6slMaScu3jy1qz3bXtf7e40zt7d8OH4hXe7nFZkBQgbVGuLX
 f/EbzeptaOUhUGMi0FWTJFlm59n6Kb5i68kf1rJBjOHlQlkCAMXpwBMxPQUI8PFv0cnPOSYuMPY
 5cbsM7N/PNl8xn/ZdfbKSWyRRtc5DmWsZ/ifLyMbYaIQtfnvivM3siPmsVs11Ee3qW2UPb75t7x
 d6zc+AA==
X-Developer-Key: i=cyphar@cyphar.com; a=openpgp;
 fpr=C9C370B246B09F6DBCFC744C34401015D1D2D386
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
 io_uring/openclose.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 10ca57f5bd24..a029c230119f 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -35,9 +35,9 @@ static bool io_openat_force_async(struct io_open *open)
 {
 	/*
 	 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
-	 * it'll always -EAGAIN
+	 * it'll always -EAGAIN.
 	 */
-	return open->how.flags & (O_TRUNC | O_CREAT | O_TMPFILE);
+	return open->how.flags & (O_TRUNC | O_CREAT | __O_TMPFILE);
 }
 
 static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)

-- 
2.41.0

