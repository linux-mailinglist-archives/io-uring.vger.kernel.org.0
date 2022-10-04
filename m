Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E085F3B62
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 04:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJDC1X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Oct 2022 22:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJDC1V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Oct 2022 22:27:21 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75613DF0C
        for <io-uring@vger.kernel.org>; Mon,  3 Oct 2022 19:26:55 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id b7so11588555wrq.9
        for <io-uring@vger.kernel.org>; Mon, 03 Oct 2022 19:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=qjKXbgy884E4Ld0bEwyZ+YfW1H1MNcfT3u0lwRIjN74=;
        b=G3fmC1nN4V1ZBa3jGBh1j4QKqbGDH8g42r8gkVIfkwa4O6MQlpS03GD8CuKR2arkZE
         R1Jzv3W5IIixEyldEEtAAyEDEpsvZuO/B8C8n4dc91Ep35hMNmUldyKQhdXJLdj9TzRc
         bcoW/hmOpLEGgfnSOLqAklakacFBjn1dmsAp3rNajTZpfQ6w/uRhXqx9YvrXSHkJtpEx
         udYb1YB6JNRTwRBb5ut0u2WosahcLiKbeyZcqHKLg1N9tAHhj1yCDWatu1h1tpgwpBLa
         TDuIWUliMhsDAm87ysnrDuhEDbusfPEmh8hkvOilhsr58E55/tWo+0cfyo4kbQ+8lzb1
         wmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=qjKXbgy884E4Ld0bEwyZ+YfW1H1MNcfT3u0lwRIjN74=;
        b=Ly4tK91X4fbLIp0swYkI9n5on1GIniEkL7CShGuD0wEYRVCAN/coffkq+8avhcA+cJ
         /h5DPq9sovPK5ntLNYYQmaP4U22qt1P2tjFlzGZVhsPdKjk3WIrQ+Am8E+x3Cu9BhsCV
         3VdakdMqSwZXuurZI9aF+fe/1cbTlFt4N+N/pcF0YyfxnrC+wOxemSTdWEd2fvyMCrEk
         5Ra/XKKS/aQdPWKppWLROAMD80ajNyd0sgEOG6DBcSvCVzs79OHw4cWuWc3RTQWYXE9q
         5263kKW3Dxw82yxNgLOInR0BWSaa5wbj3Gus2kkhiLAE/eMuGCEflgqRZzhr5kS0GBZc
         PXyA==
X-Gm-Message-State: ACrzQf33sGF6Yvq5MLG95nkBuNwKxrHo7+PjfMtd1W29dx9v5dJsor9x
        jHNVhgIjy7tgMDDTFaoGNupKWt7pVGk=
X-Google-Smtp-Source: AMsMyM5Ks2y5D5AqrQHrSQq7TsD6upxgB2BId37S8cP1jCUPIv1QokXDmqBYj8VSjQdk3Z0Fi9v+Vg==
X-Received: by 2002:a5d:5a9e:0:b0:22a:498d:d2fd with SMTP id bp30-20020a5d5a9e000000b0022a498dd2fdmr14710798wrb.390.1664850026100;
        Mon, 03 Oct 2022 19:20:26 -0700 (PDT)
Received: from 127.0.0.1localhost (188.30.232.152.threembb.co.uk. [188.30.232.152])
        by smtp.gmail.com with ESMTPSA id j13-20020a5d452d000000b00228a6ce17b4sm11074665wra.37.2022.10.03.19.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 19:20:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 1/1] io_uring: remove notif leftovers
Date:   Tue,  4 Oct 2022 03:19:25 +0100
Message-Id: <8df8877d677be5a2b43afd936d600e60105ea960.1664849941.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Notifications were killed but there is a couple of fields and struct
declarations left, remove them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 5 -----
 io_uring/io_uring.c            | 1 -
 2 files changed, 6 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index aa4d90a53866..f5b687a787a3 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -34,9 +34,6 @@ struct io_file_table {
 	unsigned int alloc_hint;
 };
 
-struct io_notif;
-struct io_notif_slot;
-
 struct io_hash_bucket {
 	spinlock_t		lock;
 	struct hlist_head	list;
@@ -242,8 +239,6 @@ struct io_ring_ctx {
 		unsigned		nr_user_files;
 		unsigned		nr_user_bufs;
 		struct io_mapped_ubuf	**user_bufs;
-		struct io_notif_slot	*notif_slots;
-		unsigned		nr_notif_slots;
 
 		struct io_submit_state	submit_state;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 73b841d4cfd0..5e7c086685bf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2625,7 +2625,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
-	WARN_ON_ONCE(ctx->notif_slots || ctx->nr_notif_slots);
 
 	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
-- 
2.37.3

