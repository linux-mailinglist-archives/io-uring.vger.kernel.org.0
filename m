Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276B86D33A9
	for <lists+io-uring@lfdr.de>; Sat,  1 Apr 2023 21:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjDATxk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Apr 2023 15:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDATxj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Apr 2023 15:53:39 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709E81A963
        for <io-uring@vger.kernel.org>; Sat,  1 Apr 2023 12:53:38 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id l27so25597971wrb.2
        for <io-uring@vger.kernel.org>; Sat, 01 Apr 2023 12:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680378817;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WMw1tuoSE4kOg3GZdJOFnnZh74OrKtHHIzNTbfASF4k=;
        b=H2adczrCrO7GypWPoI/7d6xI9rc+TdKV3ELBFBWCa/8+iEXNF18ebZ59PHmu7OfyWr
         +RZ6y4hHEz4W5h0cTbp1lBOIB9AWuj8ZQHX1d0vH8aHzGtCjixrUc4Eiw9GUR4PsD/Gt
         4aSrHWTbg8zKDG8JDvcci8iBM1niDMZxoA/l8EDN7XuDvASxuZa8I39WGVgWS4T1cyRu
         VrxOyg5STYVrEIT+SjniDdrZTzQ4dT5KOs+8aMcG9NU6mDbzK47ZL3pd6BqNV2zGKoKM
         jZSkD0hvlfDNEHNJ8R6w617Iz0bdZu3pHP/pYzp1dNrK1tB+d6CevpUoG2A2WqxcG1AF
         HARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680378817;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WMw1tuoSE4kOg3GZdJOFnnZh74OrKtHHIzNTbfASF4k=;
        b=j02GF4PlKSSkOuz0Ks6Nek/ZHV5n3xZEAbhIt5GkaE2Mdc+AGETIuBTj9jue5pIPqs
         EPqqj98Tcv4raPHOAjR4VzGSbaP39X9U1/OH+5iYKaA0wtKEy/1uA1O2JDaNcJdLpaEm
         2CQjFc2OeNImAYC4I7pP2/ZHK59KCVzguOSELG4l2CzDrc37bisgTl4odTPGkCU26GVN
         lzIesSvkta/OW4aeRz+wh0v3FRTJb4Ew6+gvlxV7f22E027aw1JRTAFr0bWQcsYBQHdG
         K+0i9/3+weszhnwIUCizKLgj14G2siyfaI4ZK9LoiPMesbHYVdh5NFTRTRzF0SI3a1O4
         OoNg==
X-Gm-Message-State: AAQBX9dvhITEfvymGUsjXnbhzuSbb0GhJe6Amp98JJdAlIf/VoxtHwWa
        6rH/zyQsMP5UoF/ofr+EIJGS5K6xc1c=
X-Google-Smtp-Source: AKy350Z/vXmg0ny+f4J5rkOQERIDOakwt+DOplvmzwXZtOLpCXbqqwkv6yrW7Z7uiuO/gajx+83vgg==
X-Received: by 2002:adf:df0b:0:b0:2e6:423c:b21a with SMTP id y11-20020adfdf0b000000b002e6423cb21amr4259617wrl.33.1680378816974;
        Sat, 01 Apr 2023 12:53:36 -0700 (PDT)
Received: from localhost.localdomain ([152.37.82.41])
        by smtp.gmail.com with ESMTPSA id c2-20020adfe702000000b002d6f285c0a2sm5636644wrm.42.2023.04.01.12.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 12:53:36 -0700 (PDT)
From:   Wojciech Lukowicz <wlukowicz01@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Wojciech Lukowicz <wlukowicz01@gmail.com>
Subject: [PATCH liburing] test/read-write: add test for CQE res when removing buffers
Date:   Sat,  1 Apr 2023 20:52:59 +0100
Message-Id: <20230401195259.404967-1-wlukowicz01@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When removing provided buffers, CQE res should contain the number of
removed buffers. However, in certain kernel versions, if SQE requests
removal of more buffers than available, then res will contain the number
of removed buffers + 1.

Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
---
This is a failing test, needs the patch I sent earlier.

 test/read-write.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/test/read-write.c b/test/read-write.c
index 3764f6aef47e..6f24ec919de3 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -637,6 +637,53 @@ static int test_rem_buf(int batch, int sqe_flags)
 	return ret;
 }
 
+static int test_rem_buf_single(int to_rem)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int ret, expected;
+	int bgid = 1;
+
+	if (no_buf_select)
+		return 0;
+
+	ret = io_uring_queue_init(64, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = provide_buffers_iovec(&ring, bgid);
+	if (ret)
+		return ret;
+
+	expected = (to_rem > BUFFERS) ? BUFFERS : to_rem;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_remove_buffers(sqe, to_rem, bgid);
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return -1;
+	}
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe=%d\n", ret);
+		return 1;
+	}
+	if (cqe->res != expected) {
+		fprintf(stderr, "cqe->res=%d, expected=%d\n", cqe->res, expected);
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
 static int test_io_link(const char *file)
 {
 	const int nr_links = 100;
@@ -950,6 +997,12 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	ret = test_rem_buf_single(BUFFERS + 1);
+	if (ret) {
+		fprintf(stderr, "test_rem_buf_single(BUFFERS + 1) failed\n");
+		goto err;
+	}
+
 	if (fname != argv[1])
 		unlink(fname);
 	return 0;
-- 
2.30.2

