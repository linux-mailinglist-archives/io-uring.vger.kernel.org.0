Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71ABA58F826
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 09:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiHKHMH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 03:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHKHMG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 03:12:06 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D808E451
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 00:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=cEhuImJwLUq0T88OZjlPjOOpXeplbjIucn/rGqYrHbE=; b=tOTkL2PhyG9ehZqquaeQms6s98
        WL6oZA7M1WKw/KIbdpIE7B6c2lqhsBJa+nB9nDquGExNvodG/lL5eFhcjFFH9vajJ+Up+F7QkIv3Z
        fe8U58lfci4GrlqdK4HOsppGfrET0v/5IgX2feh6R7DK5b7whYQ6+tZsVoG1M5brpFMUZ9BRc9F4A
        AGPWe6rJELa3Fqg12K+AmSIiC/et1xNvsE9bBFqw4o14MhePXzCOF47FAlw6YpAtFsrxCAsL7w9Ei
        1o6wgunGk9eFCVIw3qiV+zNt4rA9wI+AdA/4hYAHc/RxBIUh1Cr79znY9Hz511OvHLSzpzp2JgexJ
        +SSf75WL3J+6nObp0gL9ewp29rYEOLQVCFuq/+aoYxiCj0u/yw2AjXWNwsDU33g+Ti/q0YojA2fAU
        eVeBH3ZfThbpjAWYn2xUaJPoR4m5HDjFtk+RLa4wLvCP6y4KNz8OghoFW/z++uJR2aa1jjdNjIWgX
        Q4J65FAth50QujgE1ib1sXvl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oM2MM-0099uf-PX; Thu, 11 Aug 2022 07:12:03 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 1/3] io_uring: consistently make use of io_notif_to_data()
Date:   Thu, 11 Aug 2022 09:11:14 +0200
Message-Id: <8da6e9d12cf95ad4bc73274406d12bca7aabf72e.1660201408.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1660201408.git.metze@samba.org>
References: <cover.1660201408.git.metze@samba.org>
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

This makes the assignment typesafe. It prepares
changing io_kiocb_to_cmd() in the next commit.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 io_uring/notif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index b5f989dff9de..48d29dead62a 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -100,7 +100,7 @@ __cold int io_notif_unregister(struct io_ring_ctx *ctx)
 
 		if (!notif)
 			continue;
-		nd = io_kiocb_to_cmd(notif);
+		nd = io_notif_to_data(notif);
 		slot->notif = NULL;
 		if (!refcount_dec_and_test(&nd->uarg.refcnt))
 			continue;
-- 
2.34.1

