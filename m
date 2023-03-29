Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492536CDB7E
	for <lists+io-uring@lfdr.de>; Wed, 29 Mar 2023 16:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjC2OFa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Mar 2023 10:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjC2OF3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Mar 2023 10:05:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907BC526D
        for <io-uring@vger.kernel.org>; Wed, 29 Mar 2023 07:04:34 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id eg48so63679106edb.13
        for <io-uring@vger.kernel.org>; Wed, 29 Mar 2023 07:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680098670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=76y9S1GMDUJUlohYYDeo4RFsCsUl9wbQU6yfdN/a+Ks=;
        b=H1A9etyDv1W+M7jXKW/o78fLp4MYw9EO7aca0NI9yHalzqdADX4X/6RdAXYzYYX8Kz
         l7EdzKR2XpA5xvBv1h2ogNWzU5gnB/7JgINsDtVG5ZGw+kJVlm0WI3e+bgPElwVv1FFS
         DwYT4BMqQ5+Fjs3XplgLjciSzAkW/OsIA0Kn3c4ddqP+90P3Msve4GlyX8U5wYeRjECn
         inwMn7iBoIdVSg++xMA0AUsCfbj7uWoZJc/3vIaHImRZi5D31THNFpJpCMVYSXz/C6qw
         wOYMBWDxLgdXIG/CPWnOAjVwLuzyph9Ikgcrpkez2hvEkDjFR9HWWP70kqO5PTnVXu1K
         WgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680098670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76y9S1GMDUJUlohYYDeo4RFsCsUl9wbQU6yfdN/a+Ks=;
        b=iDB22SgVI7ctcN/0/LyCkfpdENUXYvfPb2vTVIKNlKujIBovf0CgHyisHFjc92E2RL
         0jqfbKuLSfhYoF0bx5i5sb/Hx1x4UaCyYfhlw8asixwqPz3cKsntC2v2z9qtgXQrfwcc
         GMJlHMT8rGOF/4kNCpIAHiX/U9UZMgmd0cn8TwLeulr877Erjf42UTcbIFlVdxNgNVzH
         GS62yggYTYWjUKx+1kpBlJgWJJo3K6+ET3O3qZjo7OwfOhkd+92KA8R15YyMvFP1tDCU
         yD8qwyW3aobz307eY0nVsqrH1jnd4rNAG/jYLlvB7BJZowdJpAPGZzV0eDktBlrwdZJt
         iqSA==
X-Gm-Message-State: AAQBX9d6wsl78CQvIF2S/WXQMDzU+d1NiNmrcqUF4FDYuvEbkPSUM0TB
        TG4+C78HV01IlxEZ0q8ieim3C4iekSM=
X-Google-Smtp-Source: AKy350a+fcTBtmhpjHxVB06+Go/UqNOoO06BI3H9bDP130lFfAxVMBUgAdZ5jj/woFMIUO+5UebQDg==
X-Received: by 2002:a17:906:2bc9:b0:939:e870:2b37 with SMTP id n9-20020a1709062bc900b00939e8702b37mr20968810ejg.70.1680098669808;
        Wed, 29 Mar 2023 07:04:29 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:c196])
        by smtp.gmail.com with ESMTPSA id zc14-20020a170906988e00b00927f6c799e6sm16622527ejb.132.2023.03.29.07.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 07:04:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/rsrc: fix rogue rsrc node grabbing
Date:   Wed, 29 Mar 2023 15:03:43 +0100
Message-Id: <1202ede2d7bb90136e3482b2b84aad9ed483e5d6.1680098433.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should not be looking at ctx->rsrc_node and anyhow modifying the node
without holding uring_lock, grabbing references in such a way is not
safe either.

Cc: stable@vger.kernel.org
Fixes: 5106dd6e74ab6 ("io_uring: propagate issue_flags state down to file assignment")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 2b8743645efc..f27f4975217d 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -144,15 +144,13 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 					unsigned int issue_flags)
 {
 	if (!req->rsrc_node) {
-		req->rsrc_node = ctx->rsrc_node;
+		io_ring_submit_lock(ctx, issue_flags);
 
-		if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-			lockdep_assert_held(&ctx->uring_lock);
+		lockdep_assert_held(&ctx->uring_lock);
 
-			io_charge_rsrc_node(ctx);
-		} else {
-			percpu_ref_get(&req->rsrc_node->refs);
-		}
+		req->rsrc_node = ctx->rsrc_node;
+		io_charge_rsrc_node(ctx);
+		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }
 
-- 
2.39.1

