Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7E8528A29
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbiEPQV1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiEPQV1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:21:27 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE1A28E3A
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:21:26 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id i15so934278ilk.5
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PL8Xkxu/ZO7M2bLR0lcQSkJMPlLpIMSJhXTPvR/nzfY=;
        b=z9hJRSzEGvMDrky9VGqkv6PdhAAEBSyrtH0NMagCpTgIg3SOJyKHlQsQzotov2c09+
         VU5DgoRzUz5mYYs7A1YH3sfUvy5yTxqkOysfzXHqe8p1V7ZeF+LGVoEtsoEgrGrfR4YM
         whBCwztBLmY10yxxV0iexLV2Vxan4BD0wlsoO5H6ngHi4AHAjNcWD62KX9N3I58pAM+s
         rp5ohw5kFmMg+Ib/YJjpFZ8+r9K2fh2c/QICDENY4S/gk+M0dAzdoxz+gY4QdtHX4CDQ
         QkkBwgieJZjtUrVgHsi5izHUYPcoqerDzCmVSfRaYm6fWrycPDGiuG3O/xHGATnS7hJf
         hx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PL8Xkxu/ZO7M2bLR0lcQSkJMPlLpIMSJhXTPvR/nzfY=;
        b=LIatM0v5HNg01NmUL1zZddeJ9j4lYVZOeXMrqAjPNAIpq5JJpRT2SlsvhQQdozkgOF
         MVsyVDeSgGrc4RbwSslz8dOZODTLTzTl0417jlFEvZXv+y/IAT0AYl6MWMaKKGjZRoJq
         b9B4RAx5oa2bCftil6jI4x+zwSrFedyXoORr2JM05dwyv4Eeq1sMH+R/HwBXmttKXU1d
         sucDPHP570/kykUKg5kLyRZrcwHfneZnNpkdEFL9jev0S4KntkahwBhJUBQqtvijvBfm
         PYEe1aJEk6hFMN0llW5iVzwnfyZlp8wsJOikJcXndlEsKDE0/1gqhMiesE3pXy1VkulX
         +gqw==
X-Gm-Message-State: AOAM532jauZoXupsndCKGeL0185OtaS9ecGo1zjhrw7q+AewL1cEkF5+
        6zZWXSzXyjCY4PBY6ivyjf1BRaTs1x4xsg==
X-Google-Smtp-Source: ABdhPJzungeyOuELReH6Ys3+eRuStLaPjvV5eg61uNXuj28Fk7bOHaeL85B6lGSG4fuoQ/cKAJWg4Q==
X-Received: by 2002:a92:ce91:0:b0:2d1:1d8e:4021 with SMTP id r17-20020a92ce91000000b002d11d8e4021mr3230305ilo.151.1652718085135;
        Mon, 16 May 2022 09:21:25 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l9-20020a92d8c9000000b002d0ebe7c14asm2740ilo.21.2022.05.16.09.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 09:21:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: add buffer selection support to IORING_OP_NOP
Date:   Mon, 16 May 2022 10:21:16 -0600
Message-Id: <20220516162118.155763-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220516162118.155763-1-axboe@kernel.dk>
References: <20220516162118.155763-1-axboe@kernel.dk>
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

Obviously not really useful since it's not transferring data, but it
is helpful in benchmarking overhead of provided buffers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 64450af959ff..7a458a7b3280 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1058,6 +1058,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_NOP] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
+		.buffer_select		= 1,
 	},
 	[IORING_OP_READV] = {
 		.needs_file		= 1,
@@ -4538,7 +4539,17 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
  */
 static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 {
-	__io_req_complete(req, issue_flags, 0, 0);
+	void __user *buf;
+
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		size_t len = 1;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+	}
+
+	__io_req_complete(req, issue_flags, 0, io_put_kbuf(req, issue_flags));
 	return 0;
 }
 
-- 
2.35.1

