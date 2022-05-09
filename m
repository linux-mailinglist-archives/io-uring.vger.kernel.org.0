Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D5052019B
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbiEIPy4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 11:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238650AbiEIPyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 11:54:55 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BBD1BE86
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 08:51:00 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z18so15795740iob.5
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 08:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VG5vLL/04UnPLZ/OCtmWLjxskAgYNDh0vrTWjImivq0=;
        b=e+2Sn395tPOKnE0xy3xZVcbi5xkHM6VKGY1jADoadNJYPgRS0SZdPfxJfWjfcnnSD8
         PZuxai4oR7Z8+dJOJQosrXeFJcQlPYa5JrqBR3XgjBmX2sGq/EItaVccE3B1eS9SfKl2
         OVy5miNWJaK+tuu9DTWaYT1A14PoVnOT7YJbQArufg8z2BnmB2W9VWjVqmbNoFjS/zVU
         4b8FvzO1BzelTX3P8eGOHSkrIPNlW8he/jU9j61en4MqZu3kxTi6QlJAmiTu9JSQd1NL
         e+osu1BQK9VVsYm/41aSMPz/z9ZPiUBK2peujBSMt4haEqxLZmuIiLzv0zHq1OaQp26K
         Ig/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VG5vLL/04UnPLZ/OCtmWLjxskAgYNDh0vrTWjImivq0=;
        b=guyuLqzwQScFQvzaCI4RjvX2egADVm4gGwreacUUJHqrwY3koNC3wcHHwXYt7hP0gl
         WEdn6xpf4Gr3UU/Wq0Lffcxpt3CV7rxDDiksBYZRmiIcTaxAWCAh63sqrjGOR1jSJv/+
         HCnjmXvCCys0dB9Yo9NBgIUOEjTKB9OlveRVAUyilu1OAHZKlhiYvuf5tNMo2MhXXTZb
         89GGy4jKgZEBq8btEI6AXDMRCmsnvz0rtgB9x08A6oDiqqHghw/0wR14aK5Zz2TteZk2
         P9Mu6go2/a+zYXKlMOne1tgerkjUoUJVjEACoJPA9Jv6jsAwK3FekQi9JW8Ep4w/abGN
         Lj0Q==
X-Gm-Message-State: AOAM532WRJlJFDUbLfkJmpSvA5jiEzTsCl+kWBNgA7tGVGv152Y5Ttd0
        tEvBMnJHpktRokwn8SvKYokgMUUlUF6Mjg==
X-Google-Smtp-Source: ABdhPJwK+kkVGwsiBSoNuKi/oJQCdFNIQ7Sft/yN0PFraWqgqt3Al6WXRTvOJqHTJR7hN2XSALW8bw==
X-Received: by 2002:a5d:9d83:0:b0:65a:9ffb:a80f with SMTP id ay3-20020a5d9d83000000b0065a9ffba80fmr6506229iob.116.1652111459773;
        Mon, 09 May 2022 08:50:59 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a1-20020a056638004100b0032b3a78177esm3696499jap.66.2022.05.09.08.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:50:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring: add basic fixed file allocator
Date:   Mon,  9 May 2022 09:50:51 -0600
Message-Id: <20220509155055.72735-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509155055.72735-1-axboe@kernel.dk>
References: <20220509155055.72735-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Applications currently always pick where they want fixed files to go.
In preparation for allowing these types of commands with multishot
support, add a basic allocator in the fixed file table.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f8a685cc0363..8c40411a7e78 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -258,6 +258,7 @@ struct io_rsrc_put {
 struct io_file_table {
 	struct io_fixed_file *files;
 	unsigned long *bitmap;
+	unsigned int alloc_hint;
 };
 
 struct io_rsrc_node {
@@ -4696,6 +4697,31 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_openat_prep(req, sqe);
 }
 
+static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
+{
+	struct io_file_table *table = &ctx->file_table;
+	unsigned long nr = ctx->nr_user_files;
+	int ret;
+
+	if (table->alloc_hint >= nr)
+		table->alloc_hint = 0;
+
+	do {
+		ret = find_next_zero_bit(table->bitmap, nr, table->alloc_hint);
+		if (ret != nr) {
+			table->alloc_hint = ret + 1;
+			return ret;
+		}
+		if (!table->alloc_hint)
+			break;
+
+		nr = table->alloc_hint;
+		table->alloc_hint = 0;
+	} while (1);
+
+	return -ENFILE;
+}
+
 static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct open_flags op;
@@ -8664,11 +8690,14 @@ static inline void io_file_bitmap_set(struct io_file_table *table, int bit)
 {
 	WARN_ON_ONCE(test_bit(bit, table->bitmap));
 	__set_bit(bit, table->bitmap);
+	if (bit == table->alloc_hint)
+		table->alloc_hint++;
 }
 
 static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
 {
 	__clear_bit(bit, table->bitmap);
+	table->alloc_hint = bit;
 }
 
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
-- 
2.35.1

