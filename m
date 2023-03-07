Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F5A6AE53D
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 16:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCGPp7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 10:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjCGPpm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 10:45:42 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E9187350
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 07:45:39 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id y2so13604088pjg.3
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 07:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678203939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZW6fujJ/+OHJpyfonUI5rmahS07cNEjMGMprwuHSNo0=;
        b=irWBtkfS3LSEDahgxgljq4io1ItWpnQrsw2kfyXX+bR+3P5OulkVUPdoQ5PGRhVO/x
         KZD5GO8zvEANwHKzU2FLHDcQvZciVjjxzv7dS80G/QbVHlSvjYgMyABneJSPesnQP2k2
         jM8dyP0QAOANJ+G9ycgMtN6IWAx9x2DNsB1mf4R3FE8nFNauMmr+wbPZpeY1oH4bmb1q
         n81Cf60nGmuN2qnmE4hg4ZXrsY1n5dMGNrufRjCKnwF/s3Ztt5vyGcJH+mP16WEI0Od6
         mv5Il9sWI9a0ZmAD3nS9H0Cr50qMCUhusKjyqEb0dWgTsfcmyOn+WV9fUlvX4stUx38Z
         gKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678203939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZW6fujJ/+OHJpyfonUI5rmahS07cNEjMGMprwuHSNo0=;
        b=SBXIepi7hi5FjsB3497+8J0gtGYCo2IluzDEyvrKz2LZgLsBqYLMeMvJ/yJpDVNGVT
         zVThzAjLC1RoOlM4nYL6cvwDFdffEpMDt9HmgZQXwsAVQGg4hqEt4DXspWgRo65kdeh0
         Oi7rllf0b9Txxzu55yNl5UzS5JM7ath3UvxRkuxmZyNa86YKJMdmZTh+46D3svkMOB2M
         9hcZwvYdlYovop29kSUbkolA1kIIAi4uGF7E9SmlTjyaJrow0gfWwH4x8NUJXzXl/FLO
         qt6rwsTElra+rNawpqYUBquWCzBxcnMaEdla4uQQ/N2Ls/qSkCT+QBpXQ43IBD2y8fOX
         yu9Q==
X-Gm-Message-State: AO0yUKX+CKEn0ODenoIgloxLDfxV4yGroC7hGhx7a6KFj1qQ3A1c4olO
        Qp9KTlNSxYnjl4nuu4ZtFBTXkmqGozFptO5pNwY=
X-Google-Smtp-Source: AK7set82dv0MR5CO+aHqvxJxoyEzsask01bmJ42Qn6bRx9I+WA7LgOcWAd9shmTqjOt/ilOM0gLowA==
X-Received: by 2002:a17:902:e744:b0:19a:7439:3e98 with SMTP id p4-20020a170902e74400b0019a74393e98mr15218409plf.4.1678203938681;
        Tue, 07 Mar 2023 07:45:38 -0800 (PST)
Received: from localhost.localdomain ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id kl15-20020a170903074f00b0019945535973sm8612359plb.63.2023.03.07.07.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 07:45:38 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     brauner@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] pipe: honor iocb IOCB_NOWAIT flag as well
Date:   Tue,  7 Mar 2023 08:45:32 -0700
Message-Id: <20230307154533.11164-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307154533.11164-1-axboe@kernel.dk>
References: <20230307154533.11164-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's not enough to just check the file O_NONBLOCK flag, we should also
check if the iocb being passed in has been flagged as non-blocking as
well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/pipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 42c7ff41c2db..58fee8816564 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -342,7 +342,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 			break;
 		if (ret)
 			break;
-		if (filp->f_flags & O_NONBLOCK) {
+		if (filp->f_flags & O_NONBLOCK || iocb->ki_flags & IOCB_NOWAIT) {
 			ret = -EAGAIN;
 			break;
 		}
@@ -547,7 +547,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 			continue;
 
 		/* Wait for buffer space to become available. */
-		if (filp->f_flags & O_NONBLOCK) {
+		if (filp->f_flags & O_NONBLOCK || iocb->ki_flags & IOCB_NOWAIT) {
 			if (!ret)
 				ret = -EAGAIN;
 			break;
-- 
2.39.2

