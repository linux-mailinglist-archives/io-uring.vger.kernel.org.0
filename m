Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C352E66CAB8
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 18:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjAPRGS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 12:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjAPRFu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 12:05:50 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7444842BD5
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:47:16 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j16-20020a05600c1c1000b003d9ef8c274bso18258322wms.0
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/Wr/ipByodLycxvyQUAhnWW/NedGrHZEzxbsid/aLE=;
        b=CBWyMnBFag8UBRrFfFuqrl1qiSMc2PlCT8ZcTMDoQh4aelF/4bzznyd3Ogp2ieNd2q
         75QRNJOguB0UJ9aSCWjbla58o/7lqsnXfMY38As83zPzUGcAXDNiKI+k5rbKd3C9ZUZG
         rX+YARamMsYg20e2s17L6SlDpP6fxLJ7YfpC+gX9zbb/MAKLVTOlh55ZR0PhWmkPye8A
         3Scyr849awk9WcNDuROperTTbJOXWZynUyzDeoODXKoLBCCclpPADLzHusUwLZOJCI5g
         weqALgD5tn2kWeB6+J6WxLxWvYHIMJLtau9HJd0rXbGqN5oqxlI+6KiXDDCVefhUlel+
         YpDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/Wr/ipByodLycxvyQUAhnWW/NedGrHZEzxbsid/aLE=;
        b=mvnb6k3BzSIMpGHN8XE0j5xVmDj+MeZy9ZMUSPcBsx4yPz/UvAC52RrB5RD9HNje7g
         Jl9nmjn6OTFtHvtylt85i2+vTujpwgiqb8Qd7CVqmWpUdIy+8Lj9Be0mu/lyrirnLLry
         t57HC76hUeZOrOJJ/SHJqJjfahCBm23ZqS2WHiiGA4bXzNOvh8UbHiyfqs6QyUMLTbL5
         iVEPg57crix5Cgh1zfNMJwOqL4pSDEtPTQX9MHnwaTcBt2iwodKpFWZh0yP33kVZz3VF
         UIkE6pPg2NT7uTJuqiq2x21QbYcm1MQHQLMCIZgufJI0CSYBEI87EUz44gojaPtx9ivy
         HjmA==
X-Gm-Message-State: AFqh2kpkVNbzg3mp+BtQ/CkGpQL0f6cOQ5J2x5O37ds4+vnyiG87KRZd
        +q/7eKRCpBg7TiyvUXYYqGdVeBIkpPY=
X-Google-Smtp-Source: AMrXdXvgwO3tgUYwK+MArDtOm1y8TfusPQFwi8EHPA1SFrwmTrIDZcrWY828FPiZ15tAZjNpx7iZQw==
X-Received: by 2002:a05:600c:1c1b:b0:3d9:ebf9:7004 with SMTP id j27-20020a05600c1c1b00b003d9ebf97004mr112961wms.29.1673887634703;
        Mon, 16 Jan 2023 08:47:14 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c444a00b003d998412db6sm42012397wmn.28.2023.01.16.08.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:47:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/3] tests: test DEFER_TASKRUN in poll-many
Date:   Mon, 16 Jan 2023 16:46:08 +0000
Message-Id: <ab0dd0f1f8d656ad7e647027c5040d0e99dd8828.1673886955.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673886955.git.asml.silence@gmail.com>
References: <cover.1673886955.git.asml.silence@gmail.com>
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

We want to extend DEFER_TASKRUN test coverage for polling, so
make poll-many.c to test it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/poll-many.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/test/poll-many.c b/test/poll-many.c
index ebf22e8..da3da21 100644
--- a/test/poll-many.c
+++ b/test/poll-many.c
@@ -208,6 +208,20 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 	io_uring_queue_exit(&ring);
+
+	if (t_probe_defer_taskrun()) {
+		params.flags |= IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN;
+		ret = io_uring_queue_init_params(RING_SIZE, &ring, &params);
+		if (ret) {
+			fprintf(stderr, "ring DEFER setup failed: %d\n", ret);
+			return T_EXIT_FAIL;
+		}
+		if (do_test(&ring)) {
+			fprintf(stderr, "test (DEFER) failed\n");
+			return T_EXIT_FAIL;
+		}
+		io_uring_queue_exit(&ring);
+	}
 	return 0;
 err_nofail:
 	fprintf(stderr, "poll-many: not enough files available (and not root), "
-- 
2.38.1

