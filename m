Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7FE5B1DD4
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 15:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiIHNDL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 09:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiIHNDK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 09:03:10 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA70D5715
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 06:03:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id z17so9783510eje.0
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 06:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=WHh7g2lyaDRtekZvnYczsesHgKRobTJTrXN7urs+nvs=;
        b=hkHQun1cyqHX2espChNuid+93bw7T7ugI5U8cWMgyv0m26dywzo996HyoFLBP580Ap
         ExKuJ03E7e+y04Wol5y3mCqDvSRbtxvc+W3KyHiCF1Tt/+n75KOdGAEP5aR+E0EGIRdD
         6H+9oYxbNdClKI+eYqb2L4Qou0fCesYR878z3wWWV+2bNvaXs2b2lITa+Y9kdu1LYLav
         aFPVCEkLgDd26T6GUoTZ/PqlXjKDfQzz/C9dbFySAtPFAGm5zuHPHjrbX4XVUnHtV6j/
         coFkuWDWivXy712p+bowx67cuvaHe8UMUii0jJsOkCfxXZ6guttQltOt/M4z4S+p/eNt
         ZfnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=WHh7g2lyaDRtekZvnYczsesHgKRobTJTrXN7urs+nvs=;
        b=o8ClXmVMkycAy+5qifcXXde81W4mc96Xd2G3t8v1jTP3F/PmVoHrAQ9dp8Pyf9vymf
         ZcJaUaAdwJTLXVUuw5qatjHzFEu6KKfFid0RLRpPcbcz+slL5t7DVFA9fDSwYTUnibr6
         lXfHeUjt67Fp/PPhR5em4JQU4n0UYxgUbK0DWo+WBQ3YUUjh61Ch9BlYJrSAVd8m8o/1
         SJnWTMshTppTab78QUwmU4X4UKRluvpjJHV34qf8ZzV67pZYjJMl4O0A5vG0OyEsQRSm
         6aPp96yRYSrWL6Rw06boOhUQ6zs1keQpDBFMocYhbJn1FGzfu3EppBXoRuXjaxoFl6ml
         0sbw==
X-Gm-Message-State: ACgBeo0WdrJcIjbbXp72LyUx3Nzymp8W7Z9opoST9Fv7PuJz9MAJfq/N
        7VYw+L14msNoY3LxmDOHLrv74EXSy2s=
X-Google-Smtp-Source: AA6agR4eT0pgvqqnwD6J5mKeCavHL9+9GI3Y7kMNPSRKANcb3f8sjaWyeYZH32lXCkrD3ySYmvwksA==
X-Received: by 2002:a17:907:6d1d:b0:741:5b1b:5c9a with SMTP id sa29-20020a1709076d1d00b007415b1b5c9amr5992832ejc.642.1662642187462;
        Thu, 08 Sep 2022 06:03:07 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id x68-20020a50baca000000b0044bfdbd8a33sm12462441ede.88.2022.09.08.06.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:03:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 6.0] io_uring/net: copy addr for zc on POLL_FIRST
Date:   Thu,  8 Sep 2022 14:01:10 +0100
Message-Id: <ab1d0657890d6721339c56d2e161a4bba06f85d0.1662642013.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Every time we return from an issue handler and expect the request to be
retried we should also setup it for async exec ourselves. Do that when
we return on IORING_RECVSEND_POLL_FIRST in io_sendzc(), otherwise it'll
re-read the address, which might be a surprise for the userspace.

Fixes: 092aeedb750a9 ("io_uring: allow to pass addr into sendzc")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 7047c1342541..e9efed40cf3d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1003,9 +1003,6 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	unsigned msg_flags, cflags;
 	int ret, min_ret = 0;
 
-	if (!(req->flags & REQ_F_POLLED) &&
-	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
-		return -EAGAIN;
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
@@ -1030,6 +1027,10 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		msg.msg_namelen = zc->addr_len;
 	}
 
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
+		return io_setup_async_addr(req, addr, issue_flags);
+
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		ret = io_import_fixed(WRITE, &msg.msg_iter, req->imu,
 					(u64)(uintptr_t)zc->buf, zc->len);
-- 
2.37.2

