Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA54A28A23A
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 00:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389435AbgJJWzl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731268AbgJJTFU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:05:20 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD629C08EADE
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:15 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id n15so13713852wrq.2
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IxpkwJtnqn/yziQLGDl4BkLksGzKW/jKmTc8RlEK4ac=;
        b=rcsee6nmAsMOYdeMDbAPJQFIx+F64wOKrLjTAUl+SkwmbgHIFHzDFQwVxZIDTawLzV
         I93T7zvIltICSIHMdmBmLQXpQeovnr0/5HFXI3TkgW5yGn62TwvttB+UpbCgGh6B+cMc
         9TJ+KuluNSCF0i7ZP5qNUOS9rPWAc9UfLRnRhMiiJKtH+A3JzNQCXxMQwSPjs0JD9HWA
         KbBgZFL4Xl/iOb0fHJchN/zbJEkzIBbqXJkOze1dI9u70GoiRXOT8JjJO89bZww9HP3O
         F0EP6WtdwuY1zAYkYwNXT4zTmBvNEkDMXHyZHGHqVO/fYTkPCpx7JKM7LiLDbGReRDiZ
         LI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IxpkwJtnqn/yziQLGDl4BkLksGzKW/jKmTc8RlEK4ac=;
        b=e0RvCLdxYftVJJVvxFBYldZfUWTr1jj8e/gSfJb4lC+cvcpVhdvj6QeNoib65h2Img
         jqALKcNeekXPc/f5kDV7XY17GP6gq0SWinVCKfWyjrhoLy95lGkzrgdGn8a8CQIaIU+2
         VyrvkBiM9+z4p1nznYNHDiX4U0tMntgqAXLBb6reUMfUR/ff4VP5NT4vNjxrn4Q0ho97
         5GBC8SB6CXrpTVwN+7WVqa5yFq7vNDT1ogOBRadX7yG6H5E5FA/gzA7p+gG4nkF3jZew
         feQeNjgpUVD48GxuqR24FbaCg2w6LIZn/1XFza99/v/CMlYddICHiJAm6SZMq5/yp9Bx
         48ng==
X-Gm-Message-State: AOAM530O2CtGNKHV3LZHXfIGmV7R2ooceFfbPVm4ZeBShMqx400UAhsS
        3IySCZhgs/eQLuCcnRVMIRI=
X-Google-Smtp-Source: ABdhPJz39EbS30r1ZJgRaYx889RmuYjcHZjs9s2P2N30ankZbAWaRpguHVgV0NuZjiHfelqopi4i9A==
X-Received: by 2002:adf:ec0e:: with SMTP id x14mr22700917wrn.204.1602351434376;
        Sat, 10 Oct 2020 10:37:14 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/12] io_uring: kill extra check in fixed io_file_get()
Date:   Sat, 10 Oct 2020 18:34:07 +0100
Message-Id: <4c89fbf604cd9eb92bfeabd726b84c86ac37df6e.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ctx->nr_user_files == 0 IFF ctx->file_data == NULL and there fixed files
are not used. Hence, verifying fds only against ctx->nr_user_files is
enough. Remove the other check from hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3a65bcba5a7b..39c37cef9ce0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5987,8 +5987,7 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 	struct file *file;
 
 	if (fixed) {
-		if (unlikely(!ctx->file_data ||
-		    (unsigned) fd >= ctx->nr_user_files))
+		if (unlikely((unsigned int)fd >= ctx->nr_user_files))
 			return -EBADF;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
-- 
2.24.0

