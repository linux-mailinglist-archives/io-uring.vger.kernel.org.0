Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8FC69D7DD
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 02:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBUBHG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 20:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbjBUBHF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 20:07:05 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE05021969
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:02 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o14so2424291wms.1
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rhrr1oicBaGJb+5NjdEr++Wc9UTuIi4g2aMijxtMqn8=;
        b=kFPpIxOdFTc+FVitCgobA3fEv+Th38Yu+vK2R7Ex76ikWweop+M2BtC359dp5uQD9Y
         2hKG7tGGS2Xe4jK4/NmJsyPyaz4l8QfmiGQYvDOnqBoUNVmw7A4C/Eyex2QyOaP69HVL
         81NNI1hJtVZDa2UZHOwGUDPZ7gxHVirOrG42O07qqcduJBzWpZ/Wr95BZ7+UIxQbUqFU
         VWv1Rm3wYrDbFl2eAUWMzlFwXhTI53MvE/p4jyDF34hMbDEJ9HXseJWObMHpGOIy2Cpe
         zAAU6Av45Qo31P18SQh3DjqgnWKKct0K1rh9MPrYUYxi5SaOsBiCKEP+zOJCIFwyNc9Y
         BevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rhrr1oicBaGJb+5NjdEr++Wc9UTuIi4g2aMijxtMqn8=;
        b=Zcns53rLIv8D5tf/JomL10R2BYUK0FwkS2LyE4hjag/EUyTo+i+m2sYlUDWdKCbfrU
         Dab1ywFjhoJjCqloUuQpeM5NigJmMCGO/OBE0yLORxr4ni1YHGyhgx2cysxOfxMaXksB
         nB/FHSUiDKWRN0Mw5HhfWJ53IpmRPW9hcT288Akyqrl5V3aZi8SVMb+kz25/dP7j8b8w
         HpvqlAMvLA65blPgglSn0PgLpVn+ig6zL8xMKY3cqVAuWnW3MQamaEpW6fuGI/vqtzS2
         +rZeGC6Fi1R1WP7CwLRtUSBYAFCOa1NZEL4pD4kiw+TLXRqP/8VRc1dvcg4xyFFO6kZ6
         fZvw==
X-Gm-Message-State: AO0yUKVc/77D7AR17dPUJUyr9vgM43e/lF7cgRewcmJXHAGqyTg6W2jq
        Jj6AIoMmpHGmQsfkJcImnL0d21BzPgM=
X-Google-Smtp-Source: AK7set8uggAldBCb+TDqlsp0IgIdsbyJPqgMweKDDHFoWPZ9AD89WoadNksXEGUJr86mYJQGlwCFoQ==
X-Received: by 2002:a05:600c:3088:b0:3df:ed95:d757 with SMTP id g8-20020a05600c308800b003dfed95d757mr7752811wmn.34.1676941621152;
        Mon, 20 Feb 2023 17:07:01 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id k17-20020a7bc411000000b003dfee43863fsm2092469wmi.26.2023.02.20.17.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 17:07:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/7] tests/send: don't use a constant for page size
Date:   Tue, 21 Feb 2023 01:05:52 +0000
Message-Id: <e5807646ba3ad5a315630fc3dbc363fa6c8c4e0a.1676941370.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676941370.git.asml.silence@gmail.com>
References: <cover.1676941370.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 86a31cd..2e30e49 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -58,6 +58,10 @@ enum {
 	BUF_T_LARGE,
 };
 
+/* 32MB, should be enough to trigger a short send */
+#define LARGE_BUF_SIZE		(1U << 25)
+
+static size_t page_sz;
 static char *tx_buffer, *rx_buffer;
 static struct iovec buffers_iov[4];
 static bool has_sendmsg;
@@ -706,6 +710,8 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return T_EXIT_SKIP;
 
+	page_sz = sysconf(_SC_PAGESIZE);
+
 	/* create TCP IPv6 pair */
 	ret = create_socketpair_ip(&addr, &sp[0], &sp[1], true, true, false, true);
 	if (ret) {
@@ -713,30 +719,35 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
-	len = 1U << 25; /* 32MB, should be enough to trigger a short send */
-	tx_buffer = aligned_alloc(4096, len);
-	rx_buffer = aligned_alloc(4096, len);
+	len = LARGE_BUF_SIZE;
+	tx_buffer = aligned_alloc(page_sz, len);
+	rx_buffer = aligned_alloc(page_sz, len);
 	if (tx_buffer && rx_buffer) {
 		buffers_iov[BUF_T_LARGE].iov_base = tx_buffer;
 		buffers_iov[BUF_T_LARGE].iov_len = len;
 	} else {
+		if (tx_buffer)
+			free(tx_buffer);
+		if (rx_buffer)
+			free(rx_buffer);
+
 		printf("skip large buffer tests, can't alloc\n");
 
-		len = 8192;
-		tx_buffer = aligned_alloc(4096, len);
-		rx_buffer = aligned_alloc(4096, len);
+		len = 2 * page_sz;
+		tx_buffer = aligned_alloc(page_sz, len);
+		rx_buffer = aligned_alloc(page_sz, len);
 	}
 	if (!tx_buffer || !rx_buffer) {
 		fprintf(stderr, "can't allocate buffers\n");
 		return T_EXIT_FAIL;
 	}
 
-	buffers_iov[BUF_T_NORMAL].iov_base = tx_buffer + 4096;
-	buffers_iov[BUF_T_NORMAL].iov_len = 4096;
+	buffers_iov[BUF_T_NORMAL].iov_base = tx_buffer + page_sz;
+	buffers_iov[BUF_T_NORMAL].iov_len = page_sz;
 	buffers_iov[BUF_T_SMALL].iov_base = tx_buffer;
 	buffers_iov[BUF_T_SMALL].iov_len = 137;
 	buffers_iov[BUF_T_NONALIGNED].iov_base = tx_buffer + BUFFER_OFFSET;
-	buffers_iov[BUF_T_NONALIGNED].iov_len = 8192 - BUFFER_OFFSET - 13;
+	buffers_iov[BUF_T_NONALIGNED].iov_len = 2 * page_sz - BUFFER_OFFSET - 13;
 
 	ret = io_uring_queue_init(32, &ring, 0);
 	if (ret) {
-- 
2.39.1

