Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9006469F6BB
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 15:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjBVOjX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 09:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjBVOjV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 09:39:21 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CE838030;
        Wed, 22 Feb 2023 06:39:20 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id t15so8067841wrz.7;
        Wed, 22 Feb 2023 06:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M22oHJnuucBcT6iKB9lxW+hMSBsBNFHqZcHQOuzIIKc=;
        b=ZykuQEKlBFq6ujC0ObdSGHbCSm/snEq4aV9KxuboP9EFXzEeY1U79ozyKgjFHHthmf
         0hFMSfi6beUjiDTigg8SpQXuJDjkABt+JdL4wJEEh9eQIHVkcc7S47IJNmsM7P+Pg4n4
         QDnxFwrpNzwPIKIEdFmw2BPWED5431FYF9tnIKllCgamReeOon8C+8hqImeyB5Of9dGK
         dM2Fu67Wb6NRVJGP3dLaWscF+0tEdqS0eebfY2uHxLgEdUahj9V19t+7P759MWEYrAqs
         ApjBt7YA37iJGalEGm2OI25QtjLMrC/rDcSSANiRzXnR4ku0lCFODiqWfW+u+udurx8+
         GjAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M22oHJnuucBcT6iKB9lxW+hMSBsBNFHqZcHQOuzIIKc=;
        b=x56e1uctdnxWxLNmlu4ChzRbT/OugZLTyiXrVvPHGK8gF8Y1SDUPGi0/qY7ZYIEyoQ
         IPaLwIoCHDGqlsvbF4I/Xe+Gpg5jfeJ+Qz3LPXLAgX0b13KThzWhkD2w5jf3UUqJCaPl
         zj6GsXa7jcYUiQ+E8K4bs0Og1wVMJYj6EkYIKJJp2H4JSZVfuDUBCMMC/WgB0Im+M28r
         Q1fGn6sv5UVM4oTARBV6NavGKrwFCQvL/x3Xt+sCG+RwKfbIkW/gpJWNw+2XVISXGYxM
         i4mqwYOOf/YXVeTyxqzB0lrizKJLckB6yfc/vgpT8epetSAPNUkQ0ia5Xd4+QBei8ppP
         RBaw==
X-Gm-Message-State: AO0yUKUiJTOlVz/4T4C5c6keldw5IkhWuXavLzC9yy3IWJN8Y5JSqC8c
        OD+yLskNd4GFmoU+QDtJ3F4Ip9bQkSI=
X-Google-Smtp-Source: AK7set+k5mgTDKfGeD1kAvandRiZgXbSjsP+KNmZB3LcQrQ94qDCi9l/6JGlG12oiZ0mFXG/9F8sxQ==
X-Received: by 2002:a5d:45cb:0:b0:2c5:4f04:c50d with SMTP id b11-20020a5d45cb000000b002c54f04c50dmr7554750wrs.48.1677076758850;
        Wed, 22 Feb 2023 06:39:18 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id o2-20020a5d4742000000b002c59c6abc10sm8151735wrs.115.2023.02.22.06.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:39:18 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-next 3/4] io_uring/rsrc: optimise single entry advance
Date:   Wed, 22 Feb 2023 14:36:50 +0000
Message-Id: <aca3d68af0a5e1e463c95ceb2d98202b3eb57025.1677041932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677041932.git.asml.silence@gmail.com>
References: <cover.1677041932.git.asml.silence@gmail.com>
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

Iterating within the first bvec entry should be essentially free, but we
use iov_iter_advance() for that, which shows up in benchmark profiles
taking up to 0.5% of CPU. Replace it with a hand coded version.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 53845e496881..ebbd2cea7582 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1364,7 +1364,10 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		const struct bio_vec *bvec = imu->bvec;
 
 		if (offset <= bvec->bv_len) {
-			iov_iter_advance(iter, offset);
+			iter->bvec = bvec;
+			iter->nr_segs = bvec->bv_len;
+			iter->count -= offset;
+			iter->iov_offset = offset;
 		} else {
 			unsigned long seg_skip;
 
-- 
2.39.1

