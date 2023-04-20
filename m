Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B1A6E9C25
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 20:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjDTS5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 14:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjDTS5l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 14:57:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9FF18D
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 11:57:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 84E0221986;
        Thu, 20 Apr 2023 18:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1682017059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=fOJ4B7lJuAuRSMaDvfK8itejVRzdh6oeWmoacpZvDCM=;
        b=mJDD92DOTZ5fm64T2uZO8JYKxvUq81+SV9pqI2pSlqAn39rWKds2KXZsYMN56Hkqx1lAtc
        +uPLDRBccD08HtEbM8t8Pw7b7rDSkc/lPQli0RLD/bTEIgBA5dvVNNb6hJXDN742yrP32A
        KF+gBO7f+U9FTD2U+aTY68e6cDBj8eI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1682017059;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=fOJ4B7lJuAuRSMaDvfK8itejVRzdh6oeWmoacpZvDCM=;
        b=n0r/6I0bH+ELuyQ7cfgE3U7NqHrmZaH4tSd7jRFqClngxcpGoQF74vk9Hjxg6ePiwoDCxR
        gAaPtQICuvMhcyAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4CC9713584;
        Thu, 20 Apr 2023 18:57:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FAkwDSOLQWRmQAAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 20 Apr 2023 18:57:39 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH] test/file-verify.t: Don't run over mlock limit when run as non-root
Date:   Thu, 20 Apr 2023 14:57:28 -0400
Message-Id: <20230420185728.4104-1-krisman@suse.de>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

test/file-verify tries to get 2MB of pinned memory at once, which is
higher than the default allowed for non-root users in older
kernels (64kb before v5.16, nowadays 8mb).  Skip the test for non-root
users if the registration fails instead of failing the test.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/file-verify.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/test/file-verify.c b/test/file-verify.c
index f33b24a..89cbb02 100644
--- a/test/file-verify.c
+++ b/test/file-verify.c
@@ -381,9 +381,12 @@ static int test(struct io_uring *ring, const char *fname, int buffered,
 			v[i].iov_base = buf[i];
 			v[i].iov_len = CHUNK_SIZE;
 		}
-		ret = io_uring_register_buffers(ring, v, READ_BATCH);
+		ret = t_register_buffers(ring, v, READ_BATCH);
 		if (ret) {
-			fprintf(stderr, "Error buffer reg %d\n", ret);
+			if (ret == T_SETUP_SKIP) {
+				ret = 0;
+				goto free_bufs;
+			}
 			goto err;
 		}
 	}
@@ -477,6 +480,7 @@ static int test(struct io_uring *ring, const char *fname, int buffered,
 done:
 	if (registered)
 		io_uring_unregister_buffers(ring);
+free_bufs:
 	if (vectored) {
 		for (j = 0; j < READ_BATCH; j++)
 			for (i = 0; i < nr_vecs; i++)
-- 
2.40.0

