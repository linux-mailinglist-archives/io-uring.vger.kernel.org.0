Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2E1EBBC3
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 14:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgFBMfg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 08:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgFBMfc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 08:35:32 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79239C061A0E;
        Tue,  2 Jun 2020 05:35:32 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r7so3269415wro.1;
        Tue, 02 Jun 2020 05:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MZ+SfmaDuBgDxZYvmgf/8bhSHRwuWaBRuxxG7F7E8UQ=;
        b=LkMlikUYAj1UQ5B2ip812ImnfJ1gykTsF3+mP1o35yGTBCgPMvvawBoZuB1IXzCiDE
         OTeDx0fXmt4rvqNZAu/oQsa3auJ7pSdDl8OP75cpTL0YNrUtidZYvTsmjQOEve+nco61
         ABfCdRONbWmP/tbDowgEDsISmluWBSJl4DlZ7Hi92J0xW+BxunIlUxzNDbsSaNinEMJe
         cBXQ+oX1H7y/7a/39I87v1vmLn2jQzklLuhr+43xksCArKHKv/+foRCXjU4VgfZKZBk/
         xTdzMq6mzULuLfgxd72Sr+6SDmKVN/NBUzHMXV2RUGhTSJjhXjtXyBkATU9HbxkLKNen
         D01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MZ+SfmaDuBgDxZYvmgf/8bhSHRwuWaBRuxxG7F7E8UQ=;
        b=onLEH3GV213bFf9nfjXHapVR/bM0iUMIka8KGZd/B+y4nguCQlLfwgqyosSNfdVr6M
         UxM+zCx2f5lb0it/B4HNPFdtj69mtCDuw3PHordA226vK8ZRuAYRgbKMA7lh2/jOWTyv
         BPEc5+6u1CjL8d9TqmFymEaPF2+R5vPdfaUhRXL+PEk/wyDoU0gfMApSd1qkXoKm6QZI
         A7fF7iJNYi5tH3LVW+wF+7pxXld2nrz5zFsvlt1bS6IVIKnW6hFOi5LUXY6M2RFNBfdE
         uLl97ihbXn5vObI7EFRLxWztQUPvKYH6UNs9SCEEO7Tt+dgA2VKFRrB0EX+YzK58Xzig
         435Q==
X-Gm-Message-State: AOAM530tFA7sMpcbWS8DXuD4Rev13iPU8ykXkiQgubUv+J6RX+KnbFr4
        fiCiaWjSQEvCledke6uFS7M2Smky
X-Google-Smtp-Source: ABdhPJzoU14uMSUjA9P27tGATyt+BVsUxhyQO8fN1fmq0xTbar8usTaMgb3aG2L6A25COIUBE4lnQg==
X-Received: by 2002:a5d:5585:: with SMTP id i5mr25766725wrv.112.1591101331168;
        Tue, 02 Jun 2020 05:35:31 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id z22sm3347711wmf.9.2020.06.02.05.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 05:35:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] io_uring: do build_open_how() only once
Date:   Tue,  2 Jun 2020 15:34:02 +0300
Message-Id: <ec55440d6593cde5700ef27e6fee8807168826ef.1591100205.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591100205.git.asml.silence@gmail.com>
References: <cover.1591100205.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

build_open_how() is just adjusting open_flags/mode. Do it once during
prep. It looks better than storing raw values for the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7208f91e9e77..cdfffc23e10a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2988,6 +2988,7 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	const char __user *fname;
+	u64 flags, mode;
 	int ret;
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
@@ -2999,13 +3000,14 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
-	req->open.dfd = READ_ONCE(sqe->fd);
-	req->open.how.mode = READ_ONCE(sqe->len);
-	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	req->open.how.flags = READ_ONCE(sqe->open_flags);
+	mode = READ_ONCE(sqe->len);
+	flags = READ_ONCE(sqe->open_flags);
 	if (force_o_largefile())
-		req->open.how.flags |= O_LARGEFILE;
+		flags |= O_LARGEFILE;
+	req->open.how = build_open_how(flags, mode);
 
+	req->open.dfd = READ_ONCE(sqe->fd);
+	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->open.filename = getname(fname);
 	if (IS_ERR(req->open.filename)) {
 		ret = PTR_ERR(req->open.filename);
@@ -3099,7 +3101,6 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 
 static int io_openat(struct io_kiocb *req, bool force_nonblock)
 {
-	req->open.how = build_open_how(req->open.how.flags, req->open.how.mode);
 	return io_openat2(req, force_nonblock);
 }
 
-- 
2.24.0

