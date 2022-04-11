Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CC94FC7FB
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 01:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiDKXLl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Apr 2022 19:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiDKXLj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Apr 2022 19:11:39 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE65613F44
        for <io-uring@vger.kernel.org>; Mon, 11 Apr 2022 16:09:24 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b15so15882392pfm.5
        for <io-uring@vger.kernel.org>; Mon, 11 Apr 2022 16:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xi5s0e9xoOUREsa5jqScFRp1yJNOTdNlXN4YW3CI+Ss=;
        b=XyC7GJvxBwWhPZ/XglaqZBdhV3pkM78Tk3M/lXKBIE5FO2rGT3QomYFdkrkC0JA8ag
         UiWTBrgUZ/ahDbl23fKqXLFO42fw1ZHhe9WZG9YLUyr4Kqz9nFJftJvOsMOmEDYVF5rt
         Y2ohCXgNuefGubHNaM6tgAn7svlNPytTqRbLqBPSGiTdQTOFPEKFXrn9A7iTUOAzDkPg
         4bNsbIM7JOAAUgYPeJun9czOpwVDVly0UAcXLycF01jbtWlbertl6gRsaGUi/VdBMfcU
         N9GEjXDmKs9wgHTNEUGs57QZ6deZ5Zba0frMunTFFjWZ5u8TPKR0nhH/vTpNLpjEslO1
         tKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xi5s0e9xoOUREsa5jqScFRp1yJNOTdNlXN4YW3CI+Ss=;
        b=KB0Rx8gsJk364BhH/UuPfPvZr7LoPgTKtYk/npy9C3ikxnLwsxq8GmfAzmWYS2b0uO
         EKLD7TOrShM9PmgpWtLF1sJtRGgfGSCoSqrS+Z4AZ+RdnUaJnFte0xiUKENdo+XjYdKc
         n9+kKMYX0wSKJLSPB+JVKfLKyUNHHCz5MURSbh5xDXennFyqH8JQGJ9wao1YSKfaF07d
         A8KA9vKsQEFW9JLM7/8BkyXTLld3WP+mooowk4+uavaGYRL6tPVxqlxKMykdTlQIOPBq
         Ie4nY0sSmpGjuaK1fhxe7rCfArWofllmwgjb220gszu9jEyEjxB7v2jlr9FO5I6xfy1U
         fEyQ==
X-Gm-Message-State: AOAM532UkkM91VWzME/sI42PefiO8+TPzLPmj9WmQdc5wWMr4Hg1xG5B
        +17IGA1SmBdu5BLvFRMzzPuNKk5M/w0jBg==
X-Google-Smtp-Source: ABdhPJzeRFhX/Uhl1U7+AgazeG31k4kou2/H+5MecuGq3r7TXrbWLC5OJkyq0dzlKvX5Y2ICb/wliw==
X-Received: by 2002:a63:4d66:0:b0:399:14fa:2acc with SMTP id n38-20020a634d66000000b0039914fa2accmr28709341pgl.558.1649718563957;
        Mon, 11 Apr 2022 16:09:23 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5-20020a631045000000b0039d942d18f0sm191614pgq.48.2022.04.11.16.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 16:09:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: flag the fact that linked file assignment is sane
Date:   Mon, 11 Apr 2022 17:09:12 -0600
Message-Id: <20220411230915.252477-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411230915.252477-1-axboe@kernel.dk>
References: <20220411230915.252477-1-axboe@kernel.dk>
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

Give applications a way to tell if the kernel supports sane linked files,
as in files being assigned at the right time to be able to reliably
do <open file direct into slot X><read file from slot X> while using
IOSQE_IO_LINK to order them.

Not really a bug fix, but flag it as such so that it gets pulled in with
backports of the deferred file assignment.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 3 ++-
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 659f8ecba5b7..f060ad018ba4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11178,7 +11178,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
-			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP;
+			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
+			IORING_FEAT_LINKED_FILE;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 784adc6f6ed2..1845cf7c80ba 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -296,6 +296,7 @@ struct io_uring_params {
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
 #define IORING_FEAT_RSRC_TAGS		(1U << 10)
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
+#define IORING_FEAT_LINKED_FILE		(1U << 12)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.35.1

