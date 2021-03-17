Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C596F33FACD
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhCQWLA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhCQWKg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:10:36 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645E6C06175F
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:35 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id r8so3022920ilo.8
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KXdzUFLUCDHdfDsIznvuoA0uu3nl8FyVDRpspxY/atM=;
        b=bavdqq7XIp3pvZBn+YGZ+l1AbkOZRJEEntcltWtut2UyLeOPfi0w6q2ExCTse7hO7I
         Uf7ga26zRUjvYYX+BKtNT8xq5mF0zsZHKlip48MKpUGDOtwhj4Q9ZBzVNJoR/EJA9Wqo
         GUW+UyN3tr4Rkbx5cJ6f5+WaLnBxPKRo1LPNSSj9Ml1BkGJ+bfMduCPR2tnW87pQSr34
         pBjCkxsOu2AOGvWI//vVKLG8tEVRToSmtJ1yyZaivic+CPLWK14h9gsmpjPfwq9EwXd/
         9lCRMR3oRJyP5ZPibUzsUHHlvN8jnHi/2RosIcQfZKIbjLAwZyA/5grxUCM0fpzBmBBF
         p62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KXdzUFLUCDHdfDsIznvuoA0uu3nl8FyVDRpspxY/atM=;
        b=fhOQ1/QUkO2CljhX9IaRCYeE1U2R5d3Vu0oGm4ukjUABYXEyK2NAGCsGTPZybr5pbi
         nhXHCUmxjp00TvNL7zD+D6uxl8mxFkAxqi55Anutwkj0ibHAwENam77kR9ApOYfLZzST
         rpCyO9USdSBI1iB1W4Ap+PSvw5K811jEWkAqhXdulB3PG5uD258nRJo+jEXI7JsTnAWO
         H4+aVqRvdTtHXLZzbUvYWLtUS1NRMv+uE4O5R8M4IoDW8RObWRODn28U+u+LSHoB1g8n
         svntRgQTzwoV148YKstcmJkCbjq7sZ66XZR+swfLsS/jgfK2xjkHGiTD2q4rSnwtWl93
         26TQ==
X-Gm-Message-State: AOAM5324cQiynuFqOFzQBePqYvFgnP6/QiVvZPolZR+JkZY91PYF7q73
        UiV7Pm3SHhMX8VAlmPdngn4PcZIbf1sTMg==
X-Google-Smtp-Source: ABdhPJxVzW0VPqqNQcW5cqznbA86x9///BL+YHxNMkwD/g26zMUYALWyNB/jFbw5bvCzR2mMn2fDEQ==
X-Received: by 2002:a92:6f0b:: with SMTP id k11mr9346052ilc.53.1616019034619;
        Wed, 17 Mar 2021 15:10:34 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm160700ilq.42.2021.03.17.15.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:10:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, hch@lst.de, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] fs: add file_operations->uring_cmd()
Date:   Wed, 17 Mar 2021 16:10:22 -0600
Message-Id: <20210317221027.366780-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317221027.366780-1-axboe@kernel.dk>
References: <20210317221027.366780-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a file private handler, similar to ioctls but hopefully a lot
more sane and useful.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c      |  5 -----
 include/linux/fs.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a4699b066172..fecf10e0625f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -188,11 +188,6 @@ struct io_rings {
 	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
 };
 
-enum io_uring_cmd_flags {
-	IO_URING_F_NONBLOCK		= 1,
-	IO_URING_F_COMPLETE_DEFER	= 2,
-};
-
 struct io_mapped_ubuf {
 	u64		ubuf;
 	size_t		len;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ec8f3ddf4a6a..009abc668987 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1884,6 +1884,15 @@ struct dir_context {
 #define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
 
 struct iov_iter;
+struct io_uring_cmd;
+
+/*
+ * f_op->uring_cmd() issue flags
+ */
+enum io_uring_cmd_flags {
+	IO_URING_F_NONBLOCK		= 1,
+	IO_URING_F_COMPLETE_DEFER	= 2,
+};
 
 struct file_operations {
 	struct module *owner;
@@ -1925,6 +1934,8 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+
+	int (*uring_cmd)(struct io_uring_cmd *, enum io_uring_cmd_flags);
 } __randomize_layout;
 
 struct inode_operations {
-- 
2.31.0

