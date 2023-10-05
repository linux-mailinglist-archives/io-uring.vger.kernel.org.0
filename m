Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993907B9913
	for <lists+io-uring@lfdr.de>; Thu,  5 Oct 2023 02:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241171AbjJEAFr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Oct 2023 20:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244177AbjJEAFq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Oct 2023 20:05:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7879E
        for <io-uring@vger.kernel.org>; Wed,  4 Oct 2023 17:05:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4A2111F38A;
        Thu,  5 Oct 2023 00:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696464341; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5B30aNuZqZAiEZ7O9e1YmL85qRMVmxV+iueEhBdsGDo=;
        b=IpCtW36lgs0RvCAVqPb1uQTdzEfTXI8FuX7PK9bdsBBqn82bw+UfFMg7q3Uy4hjOk2bcWX
        pJHdb95sjRapTVMdyJvPiSOGfkyS2qXTw6lLrNH7NFLMnNhhr9iJhm7ZjiJPlPwu7Z/5BN
        DWPfodVTmzsg99sBoC7Q3QdzKvFu9yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696464341;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5B30aNuZqZAiEZ7O9e1YmL85qRMVmxV+iueEhBdsGDo=;
        b=AcTps797O6hiw7AWoEa0JGILoMhgs3yDgdeVzS4EP7uus4Ud4ZTL2lBpnSr/a+ubeXlF9O
        8UZhfsU2mDa/5ADw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 138011331E;
        Thu,  5 Oct 2023 00:05:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GbyzOtT9HWWDDQAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 05 Oct 2023 00:05:40 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 1/3] io_uring: Fix check of BID wrapping in provided buffers
Date:   Wed,  4 Oct 2023 20:05:29 -0400
Message-ID: <20231005000531.30800-2-krisman@suse.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231005000531.30800-1-krisman@suse.de>
References: <20231005000531.30800-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Commit 3851d25c75ed0 ("io_uring: check for rollover of buffer ID when
providing buffers") introduced a check to prevent wrapping the BID
counter when sqe->off is provided, but it's off-by-one too
restrictive, rejecting the last possible BID (65534).

i.e., the following fails with -EINVAL.

     io_uring_prep_provide_buffers(sqe, addr, size, 0xFFFF, 0, 0);

Fixes: 3851d25c75ed ("io_uring: check for rollover of buffer ID when providing buffers")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 556f4df25b0f..52dba81c3f50 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -352,7 +352,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	tmp = READ_ONCE(sqe->off);
 	if (tmp > USHRT_MAX)
 		return -E2BIG;
-	if (tmp + p->nbufs >= USHRT_MAX)
+	if (tmp + p->nbufs > USHRT_MAX)
 		return -EINVAL;
 	p->bid = tmp;
 	return 0;
-- 
2.42.0

