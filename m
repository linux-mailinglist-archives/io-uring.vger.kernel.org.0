Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721762D0501
	for <lists+io-uring@lfdr.de>; Sun,  6 Dec 2020 13:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgLFMz6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Dec 2020 07:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbgLFMzg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Dec 2020 07:55:36 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C11C0613D1
        for <io-uring@vger.kernel.org>; Sun,  6 Dec 2020 04:54:49 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h21so11151670wmb.2
        for <io-uring@vger.kernel.org>; Sun, 06 Dec 2020 04:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=shGEQZvpWocLAHt1893SfkClceVcJawlXvrYVNhrJns=;
        b=f0eqEkauba86SyJttxoqNSdFpOeivfMcoJ7/GMEgRq92xg7U8aPPV7uLcSo85+ybdX
         cTZcsNUPCMkg//Ntppk+SVvsaOnHTtIekRhS2qs0m7sa5cBHELKUmtq/Dh7OFwGQhn4E
         x5kX7IzR3Lmo8d0JR5hAGGeH0HJOcoBb/wduTDrdINzkZJogVKEybRM6fQyD43ytb6AR
         LUMBIeifI2eASvOyGJ06/SO63QfcfUwIp4z+hDzvA48p9bfxnGF1+0z9DrgYjf1ReVzV
         IKSYm3upV0oFRc0ZMLG6a2FdOAaFs4SlSkq4p93ZyfGCCWZKRimTd6c4tdTPWCcMKM/T
         m2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=shGEQZvpWocLAHt1893SfkClceVcJawlXvrYVNhrJns=;
        b=cCg6R2E+q1fPMOU1duUfr7384OSsm1a/M76ZPyFicmm67R0Ry7ZoRWUzWr54kIxxin
         D0tIE9SNUnGBpe5dI7sFTCSGA6s31YvklNUHEAQD55QoT01okc8CoyQ9WWPTIR0ts/7C
         ngJt31M6v4ZD8gKdLR0cA9yPYHe/fCQjLh+Eye4ZMH3mY+y3vGOjZLzao0SL7JAk2PCI
         LaltjQzvJ671eGilqVH71HeQAvFcbEDJC6WQ7/9eT4k/08dKrGIx9FlSXLmsQWhVbm2V
         qQpGxQ+49Qym7h2RLuz2meeLNZeWhWrk0gxauYrp3vLwUERlx056vHzA0XuzFW+UCD6o
         eOjg==
X-Gm-Message-State: AOAM531PdExRdl6DYqXXJmYFTlBOmSfQF4mhlVUvvwSbr2ZwMPvrA2Ir
        t1iQsNHb1A1+cI6NwHb5JnmdYYlW3LZFRA==
X-Google-Smtp-Source: ABdhPJwhdUI9c1uLu1/4KCnLOd692TVie2qpVdGNTTdPVnzPvltyXgSxdI2N8CrNZsbw53qUtcPRrQ==
X-Received: by 2002:a1c:99d7:: with SMTP id b206mr6853538wme.12.1607259288701;
        Sun, 06 Dec 2020 04:54:48 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.45])
        by smtp.gmail.com with ESMTPSA id j14sm10590632wrs.49.2020.12.06.04.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 04:54:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/3] test/rw: name flags for clearness
Date:   Sun,  6 Dec 2020 12:51:21 +0000
Message-Id: <d90c51d04ad52c887f1a2c06be93d99129423999.1607258973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607258973.git.asml.silence@gmail.com>
References: <cover.1607258973.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace obscure v1-v6 with more readable flag names.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/read-write.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/test/read-write.c b/test/read-write.c
index 3bea26f..d47bebb 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -696,18 +696,19 @@ int main(int argc, char *argv[])
 		nr = 32;
 
 	for (i = 0; i < nr; i++) {
-		int v1, v2, v3, v4, v5, v6;
-
-		v1 = (i & 1) != 0;
-		v2 = (i & 2) != 0;
-		v3 = (i & 4) != 0;
-		v4 = (i & 8) != 0;
-		v5 = (i & 16) != 0;
-		v6 = (i & 32) != 0;
-		ret = test_io(fname, v1, v2, v3, v4, v5, v6);
+		int write = (i & 1) != 0;
+		int buffered = (i & 2) != 0;
+		int sqthread = (i & 4) != 0;
+		int fixed = (i & 8) != 0;
+		int mixed_fixed = (i & 16) != 0;
+		int nonvec = (i & 32) != 0;
+
+		ret = test_io(fname, write, buffered, sqthread, fixed,
+			      mixed_fixed, nonvec);
 		if (ret) {
 			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d/%d\n",
-					v1, v2, v3, v4, v5, v6);
+					write, buffered, sqthread, fixed,
+					mixed_fixed, nonvec);
 			goto err;
 		}
 	}
-- 
2.24.0

