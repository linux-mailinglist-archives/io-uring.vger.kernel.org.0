Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CDC6FDBF0
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 12:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbjEJKxh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 06:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236673AbjEJKxd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 06:53:33 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1F844A7;
        Wed, 10 May 2023 03:53:27 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id DAFFEC02C; Wed, 10 May 2023 12:53:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683716005; bh=H1p0zMwAlRrg5np5bavMOgRLY0r4yCyDEhIWpYZ9jIk=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=wr/7pEsNWxvv/ypWSARsqMWjZ7CyJqFtljRgR7vhvcmoyty/cFktdeJ00mcmT5t/n
         TEygVH3ADJg6cYnWPpJsgsDGsvBUvXU+4UzD9SZdDbm5SAU4bZCZ4r3ABfU2ofTG18
         3KdI04or4NXQ1Q4QDnvGFIPjq8lAMGvX04Ykxnne5OY0emx/RIaSEUvPUtQxOX95x7
         zmsmRv9dPCi6aya9YKb3kUL8J0CbF360vE6pSdhqK27IfnE8g5CjBIlZQoVVn30GF5
         K9zqAnD7iCmwVMkMCSg1E3NhneCPa8lAxok2uvaYdGKipqWfb/EwUGX/2xI6VdIpto
         ArqUd49sEKB7g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id F37E9C02A;
        Wed, 10 May 2023 12:53:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683716005; bh=H1p0zMwAlRrg5np5bavMOgRLY0r4yCyDEhIWpYZ9jIk=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=wr/7pEsNWxvv/ypWSARsqMWjZ7CyJqFtljRgR7vhvcmoyty/cFktdeJ00mcmT5t/n
         TEygVH3ADJg6cYnWPpJsgsDGsvBUvXU+4UzD9SZdDbm5SAU4bZCZ4r3ABfU2ofTG18
         3KdI04or4NXQ1Q4QDnvGFIPjq8lAMGvX04Ykxnne5OY0emx/RIaSEUvPUtQxOX95x7
         zmsmRv9dPCi6aya9YKb3kUL8J0CbF360vE6pSdhqK27IfnE8g5CjBIlZQoVVn30GF5
         K9zqAnD7iCmwVMkMCSg1E3NhneCPa8lAxok2uvaYdGKipqWfb/EwUGX/2xI6VdIpto
         ArqUd49sEKB7g==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id 4d95a4fa;
        Wed, 10 May 2023 10:53:02 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Wed, 10 May 2023 19:52:53 +0900
Subject: [PATCH v2 5/6] libfs: set FMODE_NOWAIT on dir open
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230422-uring-getdents-v2-5-2db1e37dc55e@codewreck.org>
References: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
In-Reply-To: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=682; i=asmadeus@codewreck.org;
 h=from:subject:message-id; bh=3L8S3Tjkbud7xRcndhKjERxB0eImBSqy3egrOvcuhks=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkW3eODbVbo0nPigVnkAT9G9sUTfJOIukU9jBqk
 Bmh59UjcPWJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZFt3jgAKCRCrTpvsapjm
 cOnpD/0VBTippxAMZnE4RXIlb2lkEJCv8U83LZ4j3IL2quetqUlhcx5V1oVb6nY+da3YXEZw/UJ
 15qUHuJYnivWMHoTBr7xXrlsWBve95rY6b2UqAE/eDhQUHOAwnQSVpHUWN2g+Bc+o2u2Adpdik4
 XrQgyb++SQLBrb/GxNuZR9jnI38R5zHPJ958spsQcdyY6uXoQiNYJsHslyw5Z6nIVgakKG00dQI
 +mM4BM8jtGfoC1qYOE3/Ls7g6XbH7ezUCJ08j7c+2tHlsG8F2gbYnMVdFeVTnk5kEOl6meGR70o
 LghN/HDN/la+E52OWEy5DX8Q9rQGO+paubIb1ncrrTCXaGKyhXRWXekMKA3qTihDdWTU0TuK3xR
 IsZ/PjRVkSjd3pYCuEsncbSfKuj4YXLmXrv5Fm658klTSeOTMeKsRg0DYvunZLbTXqFLb/WAmH6
 zyDwx8XsPyg578LSQSE/kocc7lO2Jbg2V52IV6EvnzIiu8g2RQoDk1Bcz5it41LbZXHDRyIRE1J
 Q/bTJTh+5Y/E4nTrK1xBuDg3SBJpAP3UJLkL01EHCNte33hAQc1vegwdWhXbjhyAPGmzgeXu06K
 fri1/9X/fCg2yHA8rb/Pi8azSDQZ7YdtFeOg+M5tt1xwAg7c+IqbsnzdPwTBiJ8GNeudqXrYUVX
 pItUy84Xv8fSsJg==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

the readdir can technically wait a bit on a spinlock, but that should
never wait for long enough to return EAGAIN -- just set the capability
flag on directories f_mode

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/libfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index 89cf614a3271..a3c7e42d90a7 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -81,6 +81,7 @@ EXPORT_SYMBOL(simple_lookup);
 int dcache_dir_open(struct inode *inode, struct file *file)
 {
 	file->private_data = d_alloc_cursor(file->f_path.dentry);
+	file->f_mode |= FMODE_NOWAIT;
 
 	return file->private_data ? 0 : -ENOMEM;
 }

-- 
2.39.2

