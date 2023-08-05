Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625117712EB
	for <lists+io-uring@lfdr.de>; Sun,  6 Aug 2023 00:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjHEWs5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Aug 2023 18:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjHEWsz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Aug 2023 18:48:55 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09EC19B5;
        Sat,  5 Aug 2023 15:48:54 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4RJHnH2g5Vz9scK;
        Sun,  6 Aug 2023 00:48:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
        t=1691275731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IH0KsC6OjiP5vq0A6Tdbg/v/G6fKP45ZcMl0AmDcmOA=;
        b=OCzkM9IUSZsSp6kO/WcZlLSUvAUOX3yTN30CSP6tAsr24VByzDMWKJUa3vvGeTo/Qlg8h1
        LcJpsf7EuGYPDVIDdHiEJFaaFVAe43P/sw/oUiQuEU+iGUeHfyYbpnGkgGfWeda8PPeV9B
        3D7D450vtUNt713nJI0zSW0vsZJwTUtlCXKOJKnWBFjRIqy/wLJqioHO3CIlHVFhuua73a
        LciCHOkNg6AE+fGFqtGhqkec5fjfJx/JeBS5T3pdN0gV8I6PrcBTAXFuEh/VuK/2i9ETcB
        Q1hTsGr1udZeiE/NLAew1Hw3V29+EcIAId20Hsz85CColTmfdNQ1gAd7MUbUSw==
From:   Aleksa Sarai <cyphar@cyphar.com>
Date:   Sun, 06 Aug 2023 08:48:08 +1000
Subject: [PATCH v2 1/2] open: make RESOLVE_CACHED correctly test for
 O_TMPFILE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230806-resolve_cached-o_tmpfile-v2-1-058bff24fb16@cyphar.com>
References: <20230806-resolve_cached-o_tmpfile-v2-0-058bff24fb16@cyphar.com>
In-Reply-To: <20230806-resolve_cached-o_tmpfile-v2-0-058bff24fb16@cyphar.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        stable@vger.kernel.org
X-Developer-Signature: v=1; a=openpgp-sha256; l=1006; i=cyphar@cyphar.com;
 h=from:subject:message-id; bh=OiJ0X41F7OTqXAqgldma319Yo5G2MNu2En+iv/Foe7M=;
 b=owGbwMvMwCWmMf3Xpe0vXfIZT6slMaScu3jiTIpvTXiAgVgoU8rPSOv3ZvyVqebmq5xCdxzY6
 6R58fP8jlIWBjEuBlkxRZZtfp6hm+YvvpL8aSUbzBxWJpAhDFycAjCRNU0Mf6XN2Thcf/bw/zds
 yXj1a/+KVZZfHvjZ7tHZenTK1rWlZ2IY/leeV+p6aXDv7xuzwr9HV0xbv4bnjMa0nXUlfCZvr0t
 eDmYGAA==
X-Developer-Key: i=cyphar@cyphar.com; a=openpgp;
 fpr=C9C370B246B09F6DBCFC744C34401015D1D2D386
X-Rspamd-Queue-Id: 4RJHnH2g5Vz9scK
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
fast-path check for RESOLVE_CACHED would reject all users passing
O_DIRECTORY with -EAGAIN, when in fact the intended test was to check
for __O_TMPFILE.

Cc: stable@vger.kernel.org # v5.12+
Fixes: 99668f618062 ("fs: expose LOOKUP_CACHED through openat2() RESOLVE_CACHED")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/open.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index b8883ec286f5..2634047c9e9f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1337,7 +1337,7 @@ inline int build_open_flags(const struct open_how *how, struct open_flags *op)
 		lookup_flags |= LOOKUP_IN_ROOT;
 	if (how->resolve & RESOLVE_CACHED) {
 		/* Don't bother even trying for create/truncate/tmpfile open */
-		if (flags & (O_TRUNC | O_CREAT | O_TMPFILE))
+		if (flags & (O_TRUNC | O_CREAT | __O_TMPFILE))
 			return -EAGAIN;
 		lookup_flags |= LOOKUP_CACHED;
 	}

-- 
2.41.0

