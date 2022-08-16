Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C0C595A32
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 13:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbiHPLcx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 07:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiHPLch (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 07:32:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4BDB1DE
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 03:51:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3F1651F9C2;
        Tue, 16 Aug 2022 10:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660647095; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P07ffsOFUmsbckrFkmoI4YoymIAs4Iys1kUYyiuWDnw=;
        b=oRMA+8BnLI5TMyHbHvdrvnm0aVqi0RXVH/R7PNxqtI+Agl2taMW3Kf/Rv2XoQdkyvwmmQh
        kNXP0S53r+fJ5o9EP6dC7W6Zwb0xRzxP5h6UA5HUzO9e6Ahzlk5dBUQ4i4eVkLGZeCMIvK
        Tpflmd2E8VrO6Oy19P43oN/Y9Xl10iw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660647095;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P07ffsOFUmsbckrFkmoI4YoymIAs4Iys1kUYyiuWDnw=;
        b=vAi2wH00quiF1/DoLVDfXWnsWAIxrPrAZdUuaWHLPy2Ro5S6Pwo1aNin6jtvAvTrENmuay
        wAWTQ7T3NvQlr2Bw==
Received: from localhost.localdomain (unknown [10.100.208.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 133982C149;
        Tue, 16 Aug 2022 10:51:35 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Stefan Roesch <shr@fb.com>
Subject: [PATCH v2] test/xattr: don't rely on NUL-termination
Date:   Tue, 16 Aug 2022 12:51:34 +0200
Message-Id: <20220816105134.9824-1-jslaby@suse.cz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220816104645.9554-1-jslaby@suse.cz>
References: <20220816104645.9554-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The returned value from io_uring_fgetxattr() needs not be NUL-terminated,
as we stored non-NUL-terminated string by io_uring_fsetxattr()
previously.

So don't use strlen() on value, but on VALUE1, and VALUE2 respectively.

This fixes random test failures.

Cc: Stefan Roesch <shr@fb.com>
Fixes: d6515e06f73c ("liburing: Add new test program to verify xattr support")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
[v2] added Fixes, Cc, and fixed a typo in the message above.

 test/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/xattr.c b/test/xattr.c
index d88059cb..101d82b3 100644
--- a/test/xattr.c
+++ b/test/xattr.c
@@ -210,14 +210,14 @@ static int test_fxattr(void)
 
 	/* Test reading attributes. */
 	value_len = io_uring_fgetxattr(&ring, fd, KEY1, value, XATTR_SIZE);
-	if (value_len != strlen(value) || strncmp(value, VALUE1, value_len)) {
+	if (value_len != strlen(VALUE1) || strncmp(value, VALUE1, value_len)) {
 		fprintf(stderr, "Error: fgetxattr expected value: %s, returned value: %s\n", VALUE1, value);
 		rc = -1;
 		goto Exit;
 	}
 
 	value_len = io_uring_fgetxattr(&ring, fd, KEY2, value, XATTR_SIZE);
-	if (value_len != strlen(value)|| strncmp(value, VALUE2, value_len)) {
+	if (value_len != strlen(VALUE2) || strncmp(value, VALUE2, value_len)) {
 		fprintf(stderr, "Error: fgetxattr expected value: %s, returned value: %s\n", VALUE2, value);
 		rc = -1;
 		goto Exit;
-- 
2.35.3

