Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D8136C878
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 17:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhD0POw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 11:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237178AbhD0POw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 11:14:52 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2992C061574
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 08:14:07 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j5so58897070wrn.4
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 08:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=V6e3mgZHmNheg44eZDqS3FOa/hRYCV0y7GrKY0E5Yhw=;
        b=bxAkxPS+Sgxzh3eGhd+jo+YH/7wdReWdRCLgspO17zGoZ/YZE+fBgB6dEuYFvxkVqT
         gkR/CLFbT7yUwN9bhHq52HEvHCzl8yHFlRCmI6WuCEKjuGDwJxJ7WUBo2xPNXgobDJay
         wMspqQksad251uBdqZsnYUeg4AcQL8gE+ucXcuioBQWGu9KzelPVTW6TeeTHJ3DmpKOC
         eH5X+yjrYSrc4R6bt/Lif20fumW4l5KO+42zJpwrOoY6FV2RMvzBETjcITbeVSsfW2LA
         eWEJIx9pEh7KMnyDqjCWo6DlkNrn+6yeRTcWoWn/yybTYj6dmLmUrAxcu3QDZAojgq+v
         z/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V6e3mgZHmNheg44eZDqS3FOa/hRYCV0y7GrKY0E5Yhw=;
        b=QtyqROptbNOuEQVM9GXvOP3wcEr3MxvZlN54KuQk66cVFbCrgHpV6hZMuMKzYn5jjm
         Qe3vHNGcPHMRK8fA42UJR/91hJT6UqBhiYGk9INbCrkK7pWYMHZlSXr9iUbJ8dqbp8zl
         n/iXnRfQlisTH0CWiWREdQB97TOjg0oZxtdPsapjJL/5ckBsQrkFjb+U+gvX027/CtBJ
         fjGHEaMsXl5cYvQUIaFXMvV5cz/bVcyMw6qI5odGTDtTORNUSjDOdnjwF6RBuPXPba6J
         TUXrh76L1GeAKXcLpjMi1RMVBojakZZ0XLkLmQaZkSpubZsduIs6aQ7fIrBpAGoEQ6T0
         rstw==
X-Gm-Message-State: AOAM530WKLMM26vV0bS2H1fzNxlO7q+GGX8PlTY63fkfChfLHme0Y8L8
        DXSswIY/ywdzJF48v19UOi2z/thhHlM=
X-Google-Smtp-Source: ABdhPJyfCkX4Q9A2bFEipVbK2kMvVGRSDYmNiETUCU9AwJSFOqFeOBx48IyPDsAaNrEg1X1cqSvXxg==
X-Received: by 2002:a05:6000:1aca:: with SMTP id i10mr30039266wry.194.1619536446506;
        Tue, 27 Apr 2021 08:14:06 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id i2sm1629630wro.0.2021.04.27.08.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 08:14:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: add more build check for uapi
Date:   Tue, 27 Apr 2021 16:13:53 +0100
Message-Id: <ff960df4d5026b9fb5bfd80994b9d3667d3926da.1619536280.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619536280.git.asml.silence@gmail.com>
References: <cover.1619536280.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a couple of BUILD_BUG_ON() checking some rsrc uapi structs and SQE
flags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3419548ccaf5..a48b88b3e289 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10131,6 +10131,13 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 
+	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
+		     sizeof(struct io_uring_rsrc_update));
+	BUILD_BUG_ON(sizeof(struct io_uring_rsrc_update) >
+		     sizeof(struct io_uring_rsrc_update2));
+	/* should fit into one byte */
+	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
+
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
-- 
2.31.1

