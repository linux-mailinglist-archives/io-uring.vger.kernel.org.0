Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAFF4817B3
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 00:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhL2XYN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 18:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbhL2XYN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 18:24:13 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9A7C061574
        for <io-uring@vger.kernel.org>; Wed, 29 Dec 2021 15:24:13 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id t19so19776086pfg.9
        for <io-uring@vger.kernel.org>; Wed, 29 Dec 2021 15:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/RsEoAEnfxSOt9gWWHLaLVPshCO9nFwJ35IWu03k8A=;
        b=UvnpF0JXHYawVGO5uyv5HQ6pNYPFI7Qdb63I9o4Ky/VFQhdpsm24aT/umNzwG0iDsH
         Yo1bJ9gH8Czz2uTO3wElPkiVyEcoJ0pnIm9+Yd0roMFtQmVU1h5cL0SBwtWo93YFFf+W
         wnAymvevNUFxP59nGarwt0OkvpmzJ7GdPffxv/KucfDOzCJfCp/V64CZI8jTT1tMgc8e
         351vZ8irxVJ4hU8WIrL497wQe6QssUnjglnorfnCMcbN4aNNJUbBBxMhGue//rrYFkDj
         iPi1h5udvKclAxrhfadjzsJhinJKsk1uvTseaxmta6cnWiJTqefz5JdNqUvIzIE8UkQz
         TaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/RsEoAEnfxSOt9gWWHLaLVPshCO9nFwJ35IWu03k8A=;
        b=IgEKfa1YkpqPazfT/KPtIDNL55I0/pPf1ehgjEoVftb3CQ90qw2iKUlKgb/13TwUb9
         sZeEuc9qsIY1N9Op+PXMJFdBuQGSuhYNXam618upmX2397hj5XFKV19kCKtvlldsTL1I
         +06xReSf80/JiHoIpCOsSGVTmeBLRl9Jp8dzmkQK1863O3M1pGzBbM5EIFZRGO8Ylwvd
         G7dyzWgQx+IUioBQ5b5GrhlDXo2JWkopwhuu7G9rpUTO4mcluLiTwxWOH544rLtjF3Pz
         WlP69gPAUPGSJzy47RwoicFXLcZRGt5ytr9TMvwoJPzSeBJv0p1BGYX5hcWP00a7bAMn
         kwyg==
X-Gm-Message-State: AOAM530Isjk747BCMyg+JzAvlkAdB53KYqgfp4RaeGWI8Qn2Kdf4yqZ0
        aYGEWkv/SKy0KRRt2YBOlIU=
X-Google-Smtp-Source: ABdhPJxIgWCS3o/ti0L1+lunEPhRkWq1H5XDR/tlbVj3maJD6eD7si0tO+fuFBof7Us/zIli4FG5sA==
X-Received: by 2002:a62:e904:0:b0:4a4:b4e3:a712 with SMTP id j4-20020a62e904000000b004a4b4e3a712mr28910036pfh.25.1640820252897;
        Wed, 29 Dec 2021 15:24:12 -0800 (PST)
Received: from integral2.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id x33sm26431518pfh.212.2021.12.29.15.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 15:24:12 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gmail.com>, Stefan Roesch <shr@fb.com>
Subject: [PATCH liburing xattr-getdents64] test/xattr: Fix random failure due to undefined behavior
Date:   Thu, 30 Dec 2021 06:23:10 +0700
Message-Id: <20211229232131.60874-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Running `test/xattr` sometimes fails. When it fails, there are strange
characters at the end of the returned value:
```
  $ for i in {1..10}; do ./xattr; done;
  Error: fgetxattr expected value: value2-a-lot-longer, returned value: value2-a-lot-longer��
  Error: fgetxattr expected value: value2-a-lot-longer, returned value: value2-a-lot-longerg�
  Error: fgetxattr expected value: value2-a-lot-longer, returned value: value2-a-lot-longeri�
  Error: fgetxattr expected value: value2-a-lot-longer, returned value: value2-a-lot-longerp�
  Error: fgetxattr expected value: value2-a-lot-longer, returned value: value2-a-lot-longer��
  Error: fgetxattr expected value: value2-a-lot-longer, returned value: value2-a-lot-longer"�
  Error: fgetxattr expected value: value2-a-lot-longer, returned value: value2-a-lot-longer��
  Error: fgetxattr expected value: value2-a-lot-longer, returned value: value2-a-lot-longerQ�
```

Debugged it with valgrind, valgrind says:
```
  ==59962== Conditional jump or move depends on uninitialised value(s)
  ==59962==    at 0x4849C59: strlen (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
  ==59962==    by 0x1099E9: test_fxattr (xattr.c:213)
  ==59962==    by 0x109391: main (xattr.c:416)
```

It turned out that `char value[XATTR_SIZE]` may not be NUL
terminated, so the `strlen()` results in the wrong value and %s format
to the "returned value" shows strange characters.

Fix this by changing it to `char value[XATTR_SIZE + 1] = { }` so that
it is guaranteed to be NUL terminated.

Cc: Stefan Roesch <shr@fb.com>
Fixes: e194e24ff8721e67d8526737aa644b313bff3148 ("liburing: Add new test program to verify xattr support")
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 test/xattr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/xattr.c b/test/xattr.c
index d88059c..af7df5f 100644
--- a/test/xattr.c
+++ b/test/xattr.c
@@ -175,7 +175,7 @@ static int test_fxattr(void)
 	int rc = 0;
 	size_t value_len;
 	struct io_uring ring;
-	char value[XATTR_SIZE];
+	char value[XATTR_SIZE + 1] = { };

 	/* Init io-uring queue. */
 	int ret = io_uring_queue_init(QUEUE_DEPTH, &ring, 0);
@@ -239,7 +239,7 @@ static int test_xattr(void)
 	int rc = 0;
 	int value_len;
 	struct io_uring ring;
-	char value[XATTR_SIZE];
+	char value[XATTR_SIZE + 1] = { };

 	/* Init io-uring queue. */
 	int ret = io_uring_queue_init(QUEUE_DEPTH, &ring, 0);
@@ -292,7 +292,7 @@ static int test_failure_fxattr(void)
 {
 	int rc = 0;
 	struct io_uring ring;
-	char value[XATTR_SIZE];
+	char value[XATTR_SIZE + 1] = { };

 	/* Init io-uring queue. */
 	int ret = io_uring_queue_init(QUEUE_DEPTH, &ring, 0);
@@ -335,7 +335,7 @@ static int test_failure_xattr(void)
 {
 	int rc = 0;
 	struct io_uring ring;
-	char value[XATTR_SIZE];
+	char value[XATTR_SIZE + 1] = { };

 	/* Init io-uring queue. */
 	int ret = io_uring_queue_init(QUEUE_DEPTH, &ring, 0);
--
2.32.0

