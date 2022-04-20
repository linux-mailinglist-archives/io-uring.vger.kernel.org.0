Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78B0509294
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 00:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353906AbiDTWWy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 18:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353886AbiDTWWW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 18:22:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E12D3CFF6
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:19:34 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n18so3078414plg.5
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=NhdkOaqHmG0f6ksDD2AXz4byqWmxYrLVXLqEdgXYie4=;
        b=YTAzTus6eSKdfT6B3e27rcWoFbKH2c+5oy4+xJfHDFEloag5cMZIUZvEFN9VQ8Cagn
         hcbMcKtZSd8jZOgCu+/9h0QXYNoxb7w35U0KblXgqReyukNnv0U3UhMEAFkaUBO8xBK8
         jG6LfdkewrkWSFeR7fkdTLqPWRjOj5FZAkeAHNw9rFX6/AOFF9Q3eRrIXzme0L+BabDA
         wN6Gfx/30BpIBB7p1XIQiia4tW5i2nI7M2XryrmAHScK3fALP6iHslj4e4ka/SXYkkDR
         8/KFtLI+2m8z4Lh6Ej50NkhekI35GfvHUquW1gEO/ziRX1rIMFaJhtmd42LJl+safe9Y
         ZPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=NhdkOaqHmG0f6ksDD2AXz4byqWmxYrLVXLqEdgXYie4=;
        b=8HrNc0Ch3qN+55EmVdldAWzfqZ13UDqVpDJZv+cDLj4lK0er3BfS7e164kqXpu1x33
         Q/3480DEUOMewCeHB0l2H/rWJYbwmQgEL5QaZJMkSHAjMNxGz3iQMif6GrOsTWclK4xc
         3vp7VVyvHXpYkzR5qe3gFL4BckFe2sDAtCsUtCn2VLRTQDUks5cgfpOf5mxmhZlFO7r1
         2NePl6e4R26LfdMdMMThaDyZo5945tJPX14YwtvfNeh4sWyu5V0/yS5AAMzxpCxF2Odz
         Wh9AryZDtv8ZGj/AoSeajDhXAmvZOhJ7QRREKjXl3Eu721d4Kjh6/zXdxTjxD5/MspOS
         k+2A==
X-Gm-Message-State: AOAM532ow8Gb/ysHqdsb3caqW6UQNlWYIQJmZOpT/RbgyAuoEgKfABV/
        tDA00QW5zHAdZLYL1Q9DrMO+/asifBAJCg==
X-Google-Smtp-Source: ABdhPJxokykd63hA+EiECTIVFjWUbt5t2qL04NEj3WnJyLnTD4atJPWy9/0EK3mEgWsndxXnrtnZ/g==
X-Received: by 2002:a17:90a:e295:b0:1cb:8b15:1232 with SMTP id d21-20020a17090ae29500b001cb8b151232mr6844083pjz.172.1650493173286;
        Wed, 20 Apr 2022 15:19:33 -0700 (PDT)
Received: from ?IPV6:2600:380:4975:46c0:9a40:772a:e789:f8db? ([2600:380:4975:46c0:9a40:772a:e789:f8db])
        by smtp.gmail.com with ESMTPSA id o4-20020a625a04000000b004fdf5419e41sm21240026pfb.36.2022.04.20.15.19.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 15:19:32 -0700 (PDT)
Message-ID: <124d98d0-15d4-5144-bab5-009a2c00223c@kernel.dk>
Date:   Wed, 20 Apr 2022 16:19:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: store SCM state in io_fixed_file->file_ptr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A previous commit removed SCM accounting for non-unix sockets, as those
are the only ones that can cause a fixed file reference. While that is
true, it also means we're now dereferencing the file as part of the
workqueue driven __io_sqe_files_unregister() after the process has
exited. This isn't safe for SCM files, as unix gc may have already
reaped them when the process exited. KASAN complains about this:

[   12.307040] Freed by task 0:
[   12.307592]  kasan_save_stack+0x28/0x4c
[   12.308318]  kasan_set_track+0x28/0x38
[   12.309049]  kasan_set_free_info+0x24/0x44
[   12.309890]  ____kasan_slab_free+0x108/0x11c
[   12.310739]  __kasan_slab_free+0x14/0x1c
[   12.311482]  slab_free_freelist_hook+0xd4/0x164
[   12.312382]  kmem_cache_free+0x100/0x1dc
[   12.313178]  file_free_rcu+0x58/0x74
[   12.313864]  rcu_core+0x59c/0x7c0
[   12.314675]  rcu_core_si+0xc/0x14
[   12.315496]  _stext+0x30c/0x414
[   12.316287]
[   12.316687] Last potentially related work creation:
[   12.317885]  kasan_save_stack+0x28/0x4c
[   12.318845]  __kasan_record_aux_stack+0x9c/0xb0
[   12.319976]  kasan_record_aux_stack_noalloc+0x10/0x18
[   12.321268]  call_rcu+0x50/0x35c
[   12.322082]  __fput+0x2fc/0x324
[   12.322873]  ____fput+0xc/0x14
[   12.323644]  task_work_run+0xac/0x10c
[   12.324561]  do_notify_resume+0x37c/0xe74
[   12.325420]  el0_svc+0x5c/0x68
[   12.326050]  el0t_64_sync_handler+0xb0/0x12c
[   12.326918]  el0t_64_sync+0x164/0x168
[   12.327657]
[   12.327976] Second to last potentially related work creation:
[   12.329134]  kasan_save_stack+0x28/0x4c
[   12.329864]  __kasan_record_aux_stack+0x9c/0xb0
[   12.330735]  kasan_record_aux_stack+0x10/0x18
[   12.331576]  task_work_add+0x34/0xf0
[   12.332284]  fput_many+0x11c/0x134
[   12.332960]  fput+0x10/0x94
[   12.333524]  __scm_destroy+0x80/0x84
[   12.334213]  unix_destruct_scm+0xc4/0x144
[   12.334948]  skb_release_head_state+0x5c/0x6c
[   12.335696]  skb_release_all+0x14/0x38
[   12.336339]  __kfree_skb+0x14/0x28
[   12.336928]  kfree_skb_reason+0xf4/0x108
[   12.337604]  unix_gc+0x1e8/0x42c
[   12.338154]  unix_release_sock+0x25c/0x2dc
[   12.338895]  unix_release+0x58/0x78
[   12.339531]  __sock_release+0x68/0xec
[   12.340170]  sock_close+0x14/0x20
[   12.340729]  __fput+0x18c/0x324
[   12.341254]  ____fput+0xc/0x14
[   12.341763]  task_work_run+0xac/0x10c
[   12.342367]  do_notify_resume+0x37c/0xe74
[   12.343086]  el0_svc+0x5c/0x68
[   12.343510]  el0t_64_sync_handler+0xb0/0x12c
[   12.344086]  el0t_64_sync+0x164/0x168

We have an extra bit we can use in file_ptr on 64-bit, use that to store
whether this file is SCM'ed or not, avoiding the need to look at the
file contents itself. This does mean that 32-bit will be stuck with SCM
for all registered files, just like 64-bit did before the referenced
commit.

Fixes: 12beeef15d41 ("io_uring: don't scm-account for non af_unix sockets")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3905b3ec87b8..279848c73246 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -223,6 +223,23 @@ struct io_overflow_cqe {
 	struct list_head list;
 };
 
+/*
+ * FFS_SCM is only available on 64-bit archs, for 32-bit we just define it as 0
+ * and define IO_URING_SCM_ALL. For this case, we use SCM for all files as we
+ * can't safely always dereference the file when the task has exited and ring
+ * cleanup is done. If a file is tracked and part of SCM, then unix gc on
+ * process exit may reap it before __io_sqe_files_unregister() is run.
+ */
+#define FFS_NOWAIT		0x1UL
+#define FFS_ISREG		0x2UL
+#if defined(CONFIG_64BIT)
+#define FFS_SCM			0x4UL
+#else
+#define IO_URING_SCM_ALL
+#define FFS_SCM			0x0UL
+#endif
+#define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG|FFS_SCM)
+
 struct io_fixed_file {
 	/* file * with additional FFS_* flags */
 	unsigned long file_ptr;
@@ -1235,12 +1252,16 @@ EXPORT_SYMBOL(io_uring_get_socket);
 #if defined(CONFIG_UNIX)
 static inline bool io_file_need_scm(struct file *filp)
 {
+#if defined(IO_URING_SCM_ALL)
+	return true;
+#else
 	return !!unix_get_socket(filp);
+#endif
 }
 #else
 static inline bool io_file_need_scm(struct file *filp)
 {
-	return 0;
+	return false;
 }
 #endif
 
@@ -1650,10 +1671,6 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	return false;
 }
 
-#define FFS_NOWAIT		0x1UL
-#define FFS_ISREG		0x2UL
-#define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG)
-
 static inline bool io_req_ffs_set(struct io_kiocb *req)
 {
 	return req->flags & REQ_F_FIXED_FILE;
@@ -3184,6 +3201,8 @@ static unsigned int io_file_get_flags(struct file *file)
 		res |= FFS_ISREG;
 	if (__io_file_supports_nowait(file, mode))
 		res |= FFS_NOWAIT;
+	if (io_file_need_scm(file))
+		res |= FFS_SCM;
 	return res;
 }
 
@@ -8461,14 +8480,17 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	int i;
 
+#if !defined(IO_URING_SCM_ALL)
 	for (i = 0; i < ctx->nr_user_files; i++) {
 		struct file *file = io_file_from_index(ctx, i);
 
-		if (!file || io_file_need_scm(file))
+		if (!file)
+			continue;
+		if (io_fixed_file_slot(&ctx->file_table, i)->file_ptr & FFS_SCM)
 			continue;
-		io_fixed_file_slot(&ctx->file_table, i)->file_ptr = 0;
 		fput(file);
 	}
+#endif
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {

-- 
Jens Axboe

