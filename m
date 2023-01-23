Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66BB677E40
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjAWOmN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjAWOmM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:42:12 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA7B1B55F
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:11 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id n7so11025893wrx.5
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dETK0oJbLNqgIFPxwRAQ4aNmg0XogJEIkBO9gXrECaY=;
        b=Ot4n5WWsoSpB+k3J5C/UhBjEpVwi6VwHRs/cjR/PmkNpFSRRD/Z4oQbPfIo/9R1yzr
         X1/YZP4dvCOLJNlJNx/T3ottHuGlRy62HyM8PthnQezojYBsqPF9KZpPLgWTw3Y4WT8Z
         4rOPOGj5CvLE1E7gzk9NWxzXAprE/nLaK7K0Ity3wKmWnNAteJ4RJDarGczt1aUWvoev
         2vvVZGPfzJJnLFwZlpT757F9+dxM0nD17Jl4kPceIzNPjY2T6yWxUt59sMYC8afKNcqg
         QAPhSI2Ic4ZOdQT3MPrXzOEtzwMZDpL923YYxb7FKzD3ABNTxyboxgAPicvF15eOaroR
         lSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dETK0oJbLNqgIFPxwRAQ4aNmg0XogJEIkBO9gXrECaY=;
        b=IDOWGylwv/5zfWTREbV8kh1M3Rcr7jHAu4j4/jyddvWygl90fQ4bEYzfTru44GyPEY
         ohH3ykjVE69IQCP3kDa5LJjXSAnssDnNElyIWcyLCjcFy81m5Y59L2PIxBWBKPWcpfxw
         Y19leH3aMVNaK9th88wfacSL8UU0y0Q0Mg2zubYUC2OWZ2FlcwqKFNUmFcWDIT5M7HS/
         MNrkzTaEB8jM6122RScZjY489ilN4tpXUbNUJmSW7IompWgkw1U3qBWqytgBRHDSOoK9
         LtENM7fGv/cD8gVgdJCXdqbBk9gLYVsUlKVgSooSZ8E1rggv2wns1pvfVFP1EUzZWxMg
         frhQ==
X-Gm-Message-State: AFqh2kpIKidUZ67E52D7QRRnrAaOiaIUDedSkUgMbLDUYqUjIfaV4WGh
        mJ01jm3WkfQaBrV4AM42cFhVU4H2yPs=
X-Google-Smtp-Source: AMrXdXvB54vDJq3rWDuh5euvjjk5S4abQj90Z48zgLOqDeYq7gkjHY/RGJufHeAT8Z4VlKzv59Ep4A==
X-Received: by 2002:a5d:6b09:0:b0:2be:110d:5d59 with SMTP id v9-20020a5d6b09000000b002be110d5d59mr20422996wrw.51.1674484930091;
        Mon, 23 Jan 2023 06:42:10 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa358000000b00236883f2f5csm3250534wrb.94.2023.01.23.06.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 06:42:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/7] io_uring: kill outdated comment about overflow flush
Date:   Mon, 23 Jan 2023 14:37:14 +0000
Message-Id: <4ce2bcbb17eac80cdf883fd1459d5ee6586e238c.1674484266.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674484266.git.asml.silence@gmail.com>
References: <cover.1674484266.git.asml.silence@gmail.com>
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

__io_cqring_overflow_flush() doesn't return anything anymore, remove
outdate comment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c42c1124ad5c..118b2fe254ba 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -666,7 +666,6 @@ static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
 	}
 }
 
-/* Returns true if there are no backlogged entries after the flush */
 static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 {
 	size_t cqe_size = sizeof(struct io_uring_cqe);
-- 
2.38.1

