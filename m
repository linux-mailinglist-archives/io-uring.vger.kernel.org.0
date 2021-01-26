Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16AD303F6B
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 14:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405588AbhAZNzt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 08:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405581AbhAZNzm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 08:55:42 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AD9C0611C2
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 05:54:59 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id g3so23050969ejb.6
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 05:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=APGlL6T85+0VR4qByBLzBXWNAptDIgl4KVlo2Jb0oCU=;
        b=tc55LvKkJ3KyvOWoGzIvVr/mC0hoshmXLVOQpKdQoDkipqKiXqBVXmUHCztr0eCKtI
         kKIQN5giRSylJWYXixTWuKgQwHprV+uFmMa81dKPFgpAvJ4Ap7NVUvWsfprRSkMiuC5O
         +TgKI10RMnu6iBgWCMK8O8nle80Ux/nbdutICKlkRbrc8QOo+o/Fna4Frbib4ZZnebzu
         ndmeKju++1sOJ4tyeJgo5Yxq6M/v96vnJ4gk+lVdOoqGOg5nhnJNp1iuM0Dl2VDrkr+x
         VZESW1XVDDVEk6thN+JHlNguNY4NnJKwlQ0A52LyC8g3wQ+cnDIiRnD815gVM1BG129/
         p/ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=APGlL6T85+0VR4qByBLzBXWNAptDIgl4KVlo2Jb0oCU=;
        b=QdWNThclO0h6ZaXZWS16BHwRjzVA5ludAKulGQT9Uj4/rpSOaApuoInKbmjnZhDuG3
         odiQjBjKq6F50/DrS3xDfFu+LEcJVsGtZfaALuzTD2HHHdstBdfegs7hFokDbaTzcnzJ
         EGnWwl5bPdw4HVstD9aXENGpw+MnvQBR6oBK/zMjjoftU3UotGQyg8x/5Kn75UAfORMt
         fC6vFeP6OnGAZd3NZGXRsHxAJGiGl4bgRjOzNUgLoQ3ZtDt+2rPvEZp6EdEAXwQ1lMdH
         p9pJXrLLJtIqF072slLEUd6wYFF52n2qK5A8S//dUnVBixKh7myHgnZeREitO8dUguWy
         OA8w==
X-Gm-Message-State: AOAM532jyWsFxlBUSZQNBFLU8zFwftqIBKTpxH8t3NXXDIYeASX+N6PJ
        2+QeMbD9PsWNXoEap5RE6m8=
X-Google-Smtp-Source: ABdhPJxRS6IWX6VeiKzcm2r2g/lxkWBpCv8/30yrnsihb5FbHGV4RHUrsNfFQj7lGbaWV/jjUMkraA==
X-Received: by 2002:a17:906:1f03:: with SMTP id w3mr3508001ejj.463.1611669298198;
        Tue, 26 Jan 2021 05:54:58 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id di28sm12538684edb.71.2021.01.26.05.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 05:54:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/1] io_uring: cleanup files_update looping
Date:   Tue, 26 Jan 2021 13:51:09 +0000
Message-Id: <5998587a14bb4deff29beae622ff5a59a5bbedc4.1611668970.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace a while with a simple for loop, that looks way more natural, and
enables us to use "contiune" as indexes are no more updated by hand in
the end of the loop.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: rebased onto for-5.12/io_uring

 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7a17c947e64b..783b3b7406ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8011,9 +8011,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -ENOMEM;
 	init_fixed_file_ref_node(ctx, ref_node);
 
-	done = 0;
 	fds = u64_to_user_ptr(up->data);
-	while (nr_args) {
+	for (done = 0; done < nr_args; done++) {
 		struct fixed_rsrc_table *table;
 		unsigned index;
 
@@ -8022,7 +8021,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
-		i = array_index_nospec(up->offset, ctx->nr_user_files);
+		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
 		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
 		index = i & IORING_FILE_TABLE_MASK;
 		if (table->files[index]) {
@@ -8060,9 +8059,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				break;
 			}
 		}
-		nr_args--;
-		done++;
-		up->offset++;
 	}
 
 	if (needs_switch) {
-- 
2.24.0

