Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533D045FC3A
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 03:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbhK0C6O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 21:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240415AbhK0C4O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 21:56:14 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4D2C07E5F6
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 17:51:06 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x15so45569590edv.1
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 17:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KY3v76vJAGWXxYiiVuMw8B/ERRQFpA6uxH7HrE6j2qI=;
        b=VARv6h72XPdwFC+sI7sYBmYBQLg2uGdJqqftxoT5rw8ad75UhV3Ibb/y85o1b4EXfH
         G1L1DhTMtVXwajrDW+QAJkvLV6xE34mpISf+7pQB6n8zZNbXWy6Kz1MD2w+sAs+Q/pNQ
         Bom7IQWdvpm8hhV+8JRqRYJgK7TRwKw0kzZhjL+c+RwVnu2H9rWGUg4L7n2mAXSpG2G6
         cvS72/uFYeDswvjRV7ZT7Gv33wbeiZ/pO1TdZCtArsKHCoGa5x0dO6sDMtPjhQ13SijZ
         VcaHdRq/T+DXHSzfZUsKn55grEfQPxkjIsd4ZE32542tAHhVzYOF/SxF4pOc1QbFTYAl
         GA0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KY3v76vJAGWXxYiiVuMw8B/ERRQFpA6uxH7HrE6j2qI=;
        b=y5mybrc53Ake8igUxSmWD0ArIZr0op2BHuR4ETHBq94ustK+7sWZXE1hifYuhBCTdv
         la1hunxQDwD3269AbufHkt5aofKTUmScQIP+xGCqDfJBQmML5H7Rc1e2VGE4og80GPhl
         PjL2Oo2dEY4G79vgfGfMCF36tcAE4gz7cqNR+uRXhCJQn6Tu7QURLA9X874p2RzdoPRB
         IAbfWBPNZwppHYeyscCGUy5O++yzkb5VcVOvlyQ7sWPoPJfbn+bST+qQ2DyRHrRNBQKK
         HNSTfh4kRbO91w1ULsG6FkpHUSospxqUt7bhpeAAwdCeWm+/nviknZVy3Tq0mVz52C14
         OBpg==
X-Gm-Message-State: AOAM531F/uzxsq+pfYkgiUW6TrMlMBAS0sF5FQZ4PQTyV8LiBtU/q353
        1Hb8ow2lwfh7wq5sH9/+5wPnshAoCq8=
X-Google-Smtp-Source: ABdhPJxrN3sdQZEzcMksMCSm7AsH8NuLFJ/jYCotBhdKdsqjJPLMjcPxk7zyhrxIWz/Gu02nwVXyCQ==
X-Received: by 2002:a05:6402:4396:: with SMTP id o22mr50871576edc.263.1637977865079;
        Fri, 26 Nov 2021 17:51:05 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id u23sm4806644edi.88.2021.11.26.17.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 17:51:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH liburing] man/io_uring_enter.2: document IOSQE_CQE_SKIP_SUCCESS
Date:   Sat, 27 Nov 2021 01:50:25 +0000
Message-Id: <381237725f0f09a2668ea7f38b804d5733595b1f.1637977800.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a section about IOSQE_CQE_SKIP_SUCCESS describing the behaviour and
use cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_enter.2 | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 93b97e6..710e84e 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1094,6 +1094,30 @@ are available and this flag is set, then the request will fail with
 as the error code. Once a buffer has been used, it is no longer available in
 the kernel pool. The application must re-register the given buffer again when
 it is ready to recycle it (eg has completed using it). Available since 5.7.
+.TP
+.B IOSQE_CQE_SKIP_SUCCESS
+Instruct to not generate a CQE if the request completes successfully. If the
+request fails an appropriate CQE will be posted as usual and if there is no
+.B IOSQE_IO_HARDLINK,
+CQEs for all linked requests will be omitted. The notion
+of failure/success is opcode specific and is the same as with breaking chains
+of
+.B IOSQE_IO_LINK.
+One special case is when the request has a linked timeout, then the CQE
+generation for the linked timeout is decided solely by whether it has
+.B IOSQE_CQE_SKIP_SUCCESS
+set, regardless whether it timed out or
+was cancelled. In other words, if a linked timeout has the flag set, it's
+guaranteed to not post a CQE.
+
+The semantics is chosen to accommodate several use cases. First, when all but
+last requests of a normal link without linked timeouts are marked with the flag,
+it guarantees to post only one CQE per link. Also, it makes possible to suppress
+CQEs in cases where side effects of a successfully executed operation will be
+enough for the userspace to know the state of the system, e.g. writing to
+a synchronisation file.
+
+Available since 5.17.
 
 .PP
 .I ioprio
-- 
2.34.0

