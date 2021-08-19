Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183E73F1ACE
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 15:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbhHSNni (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 09:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238463AbhHSNni (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 09:43:38 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDD5C061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 06:43:01 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x12so9166956wrr.11
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 06:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LQseWbrOVENeyREdFJsxTZCOGSN5kxONZV//Q7YrWxo=;
        b=t4+fvR5tB2uOiy91h7eFzG+cwmLdQAgs/oV/Pl4hdKJXR5g2BTvcpAzC721hUBtIFw
         jacwY9MANFs2LJCYA7bn+BzupcD7+t3fd6h6sQuyjgUIWvUYVBNPQmWwhFm2CJ6ua6SB
         eQRxy6a+UYQQj7aiiqkxuAJWz+xDvGtPgiXC64HZU5JjC2c86c5xISQSYLn4t73YR8mD
         eNnW2/LcHjFQfY6SthHT8z6r24dM8Geg4OL2fItNM3Pr61w1ptkMFjsiAha/H0/krg8F
         BIvh1UJQU4rarofrrMpTH5TBrJNdfZGXgp2t1P/5QHsOtbAyBkwWKyzJBRqRGn6LIarY
         dNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LQseWbrOVENeyREdFJsxTZCOGSN5kxONZV//Q7YrWxo=;
        b=B9yJTiDDgqma3UV08ceugkdCjGDmsYGK6hlkxGG4AThXF2jIvZgbt2kDb2zWcYbtsA
         bIPu67wDLoEar20b3OxaG7R7J95r+G1crgkuBgJEeIept8MRDjYeov+JXa7UWkRnrNIY
         FMqrCMoQHgGZT5wVzA7RiKro5/r09uPeIP7P+ld3ONv3OxQXKfTd/9rluEI0ZDgPk8cv
         QD58L5iVRLzwhdUaJqdKuXD7+RWYF1JOWTZHTHZLU0OMhU7NTTKfwqCOd+Na2zyM231L
         PG2sl2bOyvwHHCefM7V7XrdKTWrjjwyC9BQW0bK4w8OgKclyRdOM5LO2B70TSh6fxtTX
         pYRw==
X-Gm-Message-State: AOAM530dvdiDKtU9GSuCcaBAw3L2d8zz5hT1HpTgEkmFGFS/+4bq7bpp
        lsXcWVA/dOqdX5HgOJhpwTirKEeiLjM=
X-Google-Smtp-Source: ABdhPJwj8MSwsJdGJmi0lG5A7jmfu60DjEpM9VibpsDQOZnrnAEdjwAM+F7sCmUGWu85bh6VZY9lXw==
X-Received: by 2002:adf:f80f:: with SMTP id s15mr4039794wrp.330.1629380580523;
        Thu, 19 Aug 2021 06:43:00 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.21])
        by smtp.gmail.com with ESMTPSA id z13sm2939459wrs.71.2021.08.19.06.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:43:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] tests: create new files for rw testing
Date:   Thu, 19 Aug 2021 14:42:21 +0100
Message-Id: <470033f83e6ee15af154fd1a464ba3118f2bf2eb.1629380408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629380408.git.asml.silence@gmail.com>
References: <cover.1629380408.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently rw/iopoll tests use a fixed name file, so several instances of
the same test can't run in parallel. Use unique names instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/iopoll.c     | 6 +++++-
 test/read-write.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/test/iopoll.c b/test/iopoll.c
index 3d94dfe..1adee7f 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -325,6 +325,7 @@ static int probe_buf_select(void)
 int main(int argc, char *argv[])
 {
 	int i, ret, nr;
+	char buf[256];
 	char *fname;
 
 	if (probe_buf_select())
@@ -333,7 +334,10 @@ int main(int argc, char *argv[])
 	if (argc > 1) {
 		fname = argv[1];
 	} else {
-		fname = ".iopoll-rw";
+		srand((unsigned)time(NULL));
+		snprintf(buf, sizeof(buf), ".basic-rw-%u-%u",
+			(unsigned)rand(), (unsigned)getpid());
+		fname = buf;
 		t_create_file(fname, FILE_SIZE);
 	}
 
diff --git a/test/read-write.c b/test/read-write.c
index d0a77fa..b0a2bde 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -746,12 +746,16 @@ err:
 int main(int argc, char *argv[])
 {
 	int i, ret, nr;
+	char buf[256];
 	char *fname;
 
 	if (argc > 1) {
 		fname = argv[1];
 	} else {
-		fname = ".basic-rw";
+		srand((unsigned)time(NULL));
+		snprintf(buf, sizeof(buf), ".basic-rw-%u-%u",
+			(unsigned)rand(), (unsigned)getpid());
+		fname = buf;
 		t_create_file(fname, FILE_SIZE);
 	}
 
-- 
2.32.0

