Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD54657FE6E
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 13:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbiGYLem (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 07:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbiGYLel (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 07:34:41 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159181A388
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:34:40 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bn9so4656188wrb.9
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3fRqgGexTRcYFg1H2mRbhlYvOErjVoWfCFVYXAkfVkw=;
        b=c9+opSRw09ekgYS/LMHn/ERTejMeTU9B2b4z0tk3IZMdbDumKBXUk+2y9TyztoV7gB
         ot66+AMSDYwFk6F6zpP0lUSpjvTQHAHz91K/CQmKn03NN+xWwBEAx/LiZmX1eF3F89hy
         lCPvl5y9YmJNoJDUN8GYbe+hpRqcpeoAhcuroT+9WppZfoyImsoLbZ3OGq2cAij9k1g9
         iabITYwJFOxRogeGcgraDIWw0sh/tQiZ+LK8VPS6P57LhOZfzfAZpJg5QFKZipOGXsP9
         c7pnwOB7jq4r5p9dzOTt5mDlTV9H4nCw2i1+hcyRnR730qCFYXIdvrclzsGEGH1Ln1OU
         sDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3fRqgGexTRcYFg1H2mRbhlYvOErjVoWfCFVYXAkfVkw=;
        b=NIEUF43vwEXPP8NtjSeRqpmItUPeeJ/WaRU9lO426PkasXg52wsR8prqx8YYW9B/EG
         OdVGzsE3X8+vbSbo8mvwIPR0tC2kzGiZL9wl/hEZQQ2ryO6NcXSjzd/WQywwq/yrJn0B
         9/vRkiKDpYhM/4G/IOxrwxuH6PX4+Lg9zQNWYKR7R3eO8d3ihgYYiTpmXUfNjRm9Tn/w
         F/6tr2HpW2SfTdwNp6EdmRSjvOx9dXNtHhYEgL6kaq03lX2ROGF2cYj12gFrXe5tgcvJ
         5EXnIA4T995jzTd+GAsCBiu7rn40WoXdFkZXmmvLl8UfWq/7mCJadN+E5QtHKEoFtdD4
         uvOA==
X-Gm-Message-State: AJIora8rrL8oWwouqHLO2BrG72YO8BzI2nRcBQGIfwoic92+K3Cog/n5
        UQfeHE3vK5XU75T2NVHsBrImqTUG8pzKLw==
X-Google-Smtp-Source: AGRyM1t2iIjqvgB1+etACdjo3JY7g+yotEXuFnMsKmGU21jTZG8iNjJFXkr4H0feX5P723LP/uKuXA==
X-Received: by 2002:adf:e54a:0:b0:21e:61f3:de49 with SMTP id z10-20020adfe54a000000b0021e61f3de49mr7528509wrm.25.1658748878405;
        Mon, 25 Jul 2022 04:34:38 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:9f35])
        by smtp.gmail.com with ESMTPSA id e29-20020a5d595d000000b0021e501519d3sm11659991wri.67.2022.07.25.04.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 04:34:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v2 5/5] liburing: improve fallocate typecasting
Date:   Mon, 25 Jul 2022 12:33:22 +0100
Message-Id: <bbcd93f438c60073bb06ae7ab02f6ebd770ecdcb.1658748624.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658748623.git.asml.silence@gmail.com>
References: <cover.1658748623.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't double cast int -> ptr -> int in io_uring_prep_fallocate(), assign
len directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 20cd308..cffdabd 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -601,10 +601,9 @@ static inline void io_uring_prep_files_update(struct io_uring_sqe *sqe,
 static inline void io_uring_prep_fallocate(struct io_uring_sqe *sqe, int fd,
 					   int mode, off_t offset, off_t len)
 {
-
 	io_uring_prep_rw(IORING_OP_FALLOCATE, sqe, fd,
-			(const uintptr_t *) (unsigned long) len,
-			(unsigned int) mode, (__u64) offset);
+			0, (unsigned int) mode, (__u64) offset);
+	sqe->addr = (__u64) len;
 }
 
 static inline void io_uring_prep_openat(struct io_uring_sqe *sqe, int dfd,
-- 
2.37.0

