Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843A769D7E3
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 02:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbjBUBHL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 20:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbjBUBHJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 20:07:09 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AAC22DF7
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:06 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id bg28so2097229wmb.0
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmPGyA48xExHwZbJfO8OmSdVoAQXWZWG73WGeqnX5w4=;
        b=DV0jJcG76WMAAIoX4Zk98aR7ha2BrVbs36SMEyw/5Vzw2tR9ncN389DIiCiFWNq5m4
         OZVwMZs7pu4Gz4rpdGgqSS4y6Rn4bpvnj/lhH60MatHdodyFe8k0BVNvyOHxJvav1gjZ
         b/3Ka3ksplhWnSkqRgsXcSixJz9t1aNb/7iAT9PFxfcReUxxaaxG2fkadKjxEZ6ZWbRI
         jAswlH+VoVSprKtAok/b4sVmxkSs5Bg+VLktTrY3l90sOjOCvyMwhq/t3un/yrLTwFQ/
         YrtOFR04vjMywuVS6K5inmtrXzkpZ2M6HCsEdPGuEtzN581QZpVRBZZXkIT1BaWfBZ1p
         gr7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LmPGyA48xExHwZbJfO8OmSdVoAQXWZWG73WGeqnX5w4=;
        b=x5Xw3Os7IiJvW0gbDCXrGOP6BOvrtZGRI65Kqy7wCUUMqaxPZqIXu/rNgUy+0k3z2g
         75HrzFFHThXfdlrPo1DXAsuYVeiZ4xJ3MrB1ETdP0IrRZ+cQncKJwnElP0RQ3Z6eJVnb
         IS5A7+29KsTLU7UECue7YJi3MRt5MR1AMjVXB8ptpceTWlkih+bOTc/i51ZBWtDxLgBS
         dgjzrdAU5jYzmiUj9H/fns4/ixkNpGQo0QzStk2Jp8FWhMyHi+8ssm75svZQLcsztum/
         KmO/SrDHpRXKFgrBezlRwnDwHz37KUhX3bArMCl2d0rvXELWIgWFS2oiVQoiH1M3mTZ7
         Lg7A==
X-Gm-Message-State: AO0yUKXhpcgCEzlZeT43qfoRZHjvacuFcv8Zvhd9A6nAvBjnCPgW3MRI
        nhn/7mmtDyJeNU6WeoUiH9cGLqhvDqg=
X-Google-Smtp-Source: AK7set+ro4NYaatFkJz02dy6lk9E6S/tOZpSjXb2axACoo16pVI/GyDlEEXMctm71F6m2iUGUNmbpA==
X-Received: by 2002:a05:600c:3d8c:b0:3e0:c5e:ad78 with SMTP id bi12-20020a05600c3d8c00b003e00c5ead78mr1898394wmb.7.1676941625045;
        Mon, 20 Feb 2023 17:07:05 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id k17-20020a7bc411000000b003dfee43863fsm2092469wmi.26.2023.02.20.17.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 17:07:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 6/7] tests/send: improve error reporting
Date:   Tue, 21 Feb 2023 01:05:57 +0000
Message-Id: <077207aff1e31d30bdcdacbb6b0379d24798cea9.1676941370.git.asml.silence@gmail.com>
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
 test/send-zerocopy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 481aa28..8ddec39 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -447,7 +447,8 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		}
 		if (cqe->user_data == RX_TAG) {
 			if (cqe->res != send_size) {
-				fprintf(stderr, "rx failed %i\n", cqe->res);
+				fprintf(stderr, "rx failed res: %i, expected %i\n",
+						cqe->res, (int)send_size);
 				return 1;
 			}
 			io_uring_cqe_seen(ring, cqe);
-- 
2.39.1

