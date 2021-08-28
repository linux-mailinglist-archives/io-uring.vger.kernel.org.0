Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD963FA727
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 20:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhH1ScQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 14:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhH1ScQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 14:32:16 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE78C061756
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 11:31:25 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v10so15758224wrd.4
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 11:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PnyXDFkjTc+vWvUBsQqp0LNyqggI5n6UJl6ue6yLhdk=;
        b=fPYP6kYDUlShykf0ikcx6N+g1xoS2E3eaBwVDlTF9HSLHM+xuEwkKWNtC+uf+ZnDN8
         bwAgWWPzDI0l1/bzECarqzd73mc2CgW8AmSoR45J1/N7gM3+Yc82lQBgP165k6SKprWR
         yjPY7T56Pj8k4S3DJ6kPZPQShjliRLzXcm1xwfdUrp/EKMSsQE8EXMBCerRRdpqEZAaw
         hkiHHpYaJ+WDh3WSbPBwx2mBj5Njmv/lM0xQNkOxsa0fbPdaK2w91drxXYbkV9sD1/Lq
         1QNvajEpCRQzRcC437lM3I/8Qx7QS/ky4O47ZyGeSJT/+5kjB8tkdpGMupp1prKPUmfm
         BwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PnyXDFkjTc+vWvUBsQqp0LNyqggI5n6UJl6ue6yLhdk=;
        b=F66PenIiwJyvJ23nOsXrRjgEWgsR84FfNCcnmsAfB6BOMuShtJ92dgezD573OHhD6k
         yU+5MJzGmRGOgAiIpnGTlqaBQb3u/hTgTd4Y6mgqdUjAbZaIyAPBrsQX3aoY8w1DE7LP
         chLL77K/9eO7HgcrSqmPiF9nxlIOUCWCQKJFdZLGxZ8ydGqkqGKzEe0FYlESBqA7pp8A
         zL43OGo8LUFcqveVzNICRzLz1OENUl5SRcA1yAN6gOmFsRkOCUB/ElR9ZlORF9ewzgEj
         LxmFBFQ6rbHebf/YBxcuws1ATS3sP8iGg6jpYnXdud6Mfjc2U9S0DLLRTtO1TyxE+M+C
         ziww==
X-Gm-Message-State: AOAM533C1qKpYZwqO42uSmt4Y9CJpbHbKtDkCD8W9OUK5lGrrV8xy/lF
        9R5203ePCBtbwXQOWR5a0HeBwoS7SBo=
X-Google-Smtp-Source: ABdhPJypX0K5qw18ah3WUe/Z3Ue1w5sZqg/bv3eFFrBFs8clar5Dm32SbZlfpeWk4RuxX/SVKQ+Tag==
X-Received: by 2002:adf:f7c2:: with SMTP id a2mr17309271wrq.58.1630175484220;
        Sat, 28 Aug 2021 11:31:24 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.102])
        by smtp.gmail.com with ESMTPSA id b4sm9939275wrp.33.2021.08.28.11.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 11:31:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] man: update notes on register quiesce
Date:   Sat, 28 Aug 2021 19:30:44 +0100
Message-Id: <9976eea690c26a86c5f02f7a9b99bd8b58548d3e.1630175370.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1630175370.git.asml.silence@gmail.com>
References: <cover.1630175370.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't quiesce rsrc registrations since 5.13, reflect it in the man.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_register.2 | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index 5326a87..a8479fd 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -88,9 +88,9 @@ then issuing a new call to
 .BR io_uring_register ()
 with the new buffers.
 
-Note that registering buffers will wait for the ring to idle. If the application
-currently has requests in-flight, the registration will wait for those to
-finish before proceeding.
+Note that before 5.13 registering buffers would wait for the ring to idle.
+If the application currently has requests in-flight, the registration will
+wait for those to finish before proceeding.
 
 An application need not unregister buffers explicitly before shutting
 down the io_uring instance. Available since 5.1.
@@ -128,9 +128,9 @@ See
 .B IORING_REGISTER_FILES_UPDATE
 for how to update files in place.
 
-Note that registering files will wait for the ring to idle. If the application
-currently has requests in-flight, the registration will wait for those to
-finish before proceeding. See
+Note that before 5.13 registering files would wait for the ring to idle.
+If the application currently has requests in-flight, the registration will
+wait for those to finish before proceeding. See
 .B IORING_REGISTER_FILES_UPDATE
 for how to update an existing set without that limitation.
 
-- 
2.33.0

