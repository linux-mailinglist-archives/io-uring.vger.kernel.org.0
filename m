Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213EE29090F
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410472AbgJPQCc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410471AbgJPQCc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:32 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8636CC0613D3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:30 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p11so1517607pld.5
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ldylofHobC03T1x9fe6iv3zjOCG2DP0TztfKAAN6kT0=;
        b=JkttXFSX6O3L+frN3x9rhedrSxW2nWRfxnjZW3f5IamtoopzrgDwfJRx5VSoh7aYOW
         ZA4Sn5N80lGjXqDN3N6saA/uBmQ8fgJcyc1cMeiMXQBwCJcfylRvkbBU+mfDXatdGcX/
         TaJArk8KfwYrSwXx2gOnldVB62H9iUy4tUkuu/EGbUJaGIU6r8anLsduT8Y6Xsz3a5pE
         Ew6eDyjb2iPLUYMnpECc6hkGNKhEg6LBuNF9iy8xiauFQ/cBQWC37vER+J0stlAcGe31
         L2wfSiSwWOfkydQrXdMs7NhngAE21fJqUbifGisnr5H5HPFnYsF3NrD0w3V95S/GOOes
         6fCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ldylofHobC03T1x9fe6iv3zjOCG2DP0TztfKAAN6kT0=;
        b=Cw8d+JJ+GFgLZmky6JhpCRYajy9pdWSIl1E7WDVfb+Bm4GIl/oMQvmJp/+WLye7D0m
         pn92zthmJCmNQN8nspkh1zP4OQQEBJxsLKrjsmjWywYuUFSzKfWjVHVCXJ44y01IsIaS
         AkJ319PaJf2YGOnuN/IqBgDPPRTIkEdvNE7w3bMx9AI6lJX0zOr6VH7l6R2corXsL29G
         wwaizjGsvgEOTcrGMMgHX7Kwkq7P0qDvWSnIaCq5UdceXl1ow4iGMPzD3fpAOMgmIlGF
         7AedXiK0tl7gRgE1f3WpFYP3EPwRgyoZprBHAodRUHZgYVYxkNvUH7SglngGx4QjnyGf
         koNA==
X-Gm-Message-State: AOAM5309LgWqJSKmizW/xBpEkHYUtCUncMxG4GWqhS1c067z7sccDMCP
        ex+ii3SQlIJ+rRM5xfqtu4bPR69WkhtUGR7W
X-Google-Smtp-Source: ABdhPJxWhoHhbBdVcBUfL3fn+zQCta1TJgpnu5wse+9xi74Nn8MqwUXWhcbDy3+graXr6hmpeGbnrQ==
X-Received: by 2002:a17:90b:1490:: with SMTP id js16mr4684728pjb.184.1602864149714;
        Fri, 16 Oct 2020 09:02:29 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/18] io_uring: Fix sizeof() mismatch
Date:   Fri, 16 Oct 2020 10:02:07 -0600
Message-Id: <20201016160224.1575329-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

An incorrect sizeof() is being used, sizeof(file_data->table) is not
correct, it should be sizeof(*file_data->table).

Fixes: 5398ae698525 ("io_uring: clean file_data access in files_register")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Addresses-Coverity: ("Sizeof not portable (SIZEOF_MISMATCH)")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc6de6b4784e..eede54be500d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7300,7 +7300,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	spin_lock_init(&file_data->lock);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
-	file_data->table = kcalloc(nr_tables, sizeof(file_data->table),
+	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
 				   GFP_KERNEL);
 	if (!file_data->table)
 		goto out_free;
-- 
2.28.0

