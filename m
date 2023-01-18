Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E087567203F
	for <lists+io-uring@lfdr.de>; Wed, 18 Jan 2023 15:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjAROyS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Jan 2023 09:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjAROyA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Jan 2023 09:54:00 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE9546D79
        for <io-uring@vger.kernel.org>; Wed, 18 Jan 2023 06:48:20 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CE57E5BFC0;
        Wed, 18 Jan 2023 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674053298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OiRjN7NIUQyd4jxpceaU2xclU8h8+TX458Q0uyHS+bE=;
        b=rhaYwMJXOB8YSnYT0dULNkC+WTceBFH9azijjF+mwxOiLcMKKm/5o5uRGQyWFfdPfdnzm7
        t3Ueyr4vdLt/sX91PHn+Z4XR3NX74b3upVcTEhoEN8Wj6aqsUfQUUXtm9nz5kbv42Lzq1M
        PRO1iwI5iynDax9RJ+JOcHy/xoUp8AI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674053298;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OiRjN7NIUQyd4jxpceaU2xclU8h8+TX458Q0uyHS+bE=;
        b=WJQxJTDdO+Pn5OZAfMpuKbW7tUEs/awvZTmdGdvJaOtIhqgJk/Km4+UYOkEsjqUnmx3mcr
        sEqvleXcxA+9KmBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4EFB2138FE;
        Wed, 18 Jan 2023 14:48:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id v03xBbIGyGO8bgAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 18 Jan 2023 14:48:18 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing] test/helpers: fix socket length type
Date:   Wed, 18 Jan 2023 11:48:06 -0300
Message-Id: <20230118144806.18352-1-krisman@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

t_create_socket_pair uses size_t for paddrlen, which is uint64 on 64-bit
architecture, while the network syscalls expect uint32.  The implicit
cast is always safe for little-endian here due to the structure format,
its small size and the fact it was previously zeroed - so the test
succeeds.

Still, on BE machines, our CI caught a few tests crashing on
connect(). For instance:

localhost:~/liburing/test # ./send_recv.t
connect failed
test_invalid failed

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/helpers.c b/test/helpers.c
index 869e90342f9a..37ba67c070c8 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -173,7 +173,7 @@ int t_create_socket_pair(int fd[2], bool stream)
 	int val;
 	struct sockaddr_in serv_addr;
 	struct sockaddr *paddr;
-	size_t paddrlen;
+	socklen_t paddrlen;
 
 	type |= SOCK_CLOEXEC;
 	fd[0] = socket(AF_INET, type, 0);
-- 
2.35.3

