Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4027416FC
	for <lists+io-uring@lfdr.de>; Wed, 28 Jun 2023 19:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjF1RKE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 13:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjF1RJ7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 13:09:59 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B451BE4
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 10:09:58 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-34577a22c7cso17525ab.0
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 10:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687972197; x=1690564197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OL1cH5hY2ffD4MiWMhFB84qVLfZbKF6cTgZjlJaLuyU=;
        b=gD9DvBm30YTqwg1YjHwEH5WNCKWdzVKvPb3Hp7AQVDWFneGCx9zP+VV3pjtU/tL9LJ
         dZzhlJzL0R3AjvtKBKy6zP4i86Ej3pH7AKliEP+1/T71H+lW1OkHAoxxHm+m3sBMubFb
         z/dBDTNRDl4JWi+JXM9MgAHvOtWWyYZvrvn1bEvbCrI2QbLogq2hvzYa3nG3LPhQQbIV
         yF3BQ1a8A8pRjvUDcJ7jxjjYy4eZnViJurX2ujMM0FROcECZNYOkottfqO5NHAZSgwcj
         YZuAB4/VebiFdm1KEKg94zQwVSdqcbbSsAYSIpJnKnXTvKTlpi6gARBX6kBZlD8AvaPc
         TzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687972197; x=1690564197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OL1cH5hY2ffD4MiWMhFB84qVLfZbKF6cTgZjlJaLuyU=;
        b=mH0GLlVf4sdm/HIzAT2fFQmn3qDhBv9OugIbeDIa1U0hqMXE6hX8pACHthQmAtrEbQ
         ZZrNxwLcx/Qydp4xB0Wt+i+0BUtFYz8KCh11BzBj6MQBnbeqZGI9iHYhWhmn1eGVQqsk
         2HAPb0JomjV+1TKGh3QBgJ41mQXxIVASZ8CfcSh8etWRz3w0hkAfaNisM5hW/jrOgqIl
         yw+eii8ZUl8kLH7VQUsC8iNKaKwl/BnCrdCHv464V8vCJbJLSGmjc/oyrszO5abxkasf
         AV3WbXxjCG47RKGsATXNoeGnG8gkgj4FT5G4C8ZordpfGs4zkNWP9eyRKmei4BG9N6ak
         +aZw==
X-Gm-Message-State: AC+VfDwXq9uVu2Jb21hAvZmnIYjeeZ58yhBCguQE9P3PTiznJlNF/gOH
        6hrN9cnaGP/0UA5PBEZWI4nDfCPb26F9TFdzf2g=
X-Google-Smtp-Source: ACHHUZ4IWPfniJiDW8gBctXWmRmSUCygt+EfVEd4/1QsZdHg2RvguQmgmbmZHpdhLbZh8Le37fLLxg==
X-Received: by 2002:a5d:9da6:0:b0:783:617c:a8f0 with SMTP id ay38-20020a5d9da6000000b00783617ca8f0mr13357221iob.2.1687972197397;
        Wed, 28 Jun 2023 10:09:57 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t11-20020a02c48b000000b0042aecf02051sm708342jam.51.2023.06.28.10.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 10:09:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/3] io_uring/net: use proper value for msg_inq
Date:   Wed, 28 Jun 2023 11:09:51 -0600
Message-Id: <20230628170953.952923-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230628170953.952923-1-axboe@kernel.dk>
References: <20230628170953.952923-1-axboe@kernel.dk>
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

struct msghdr->msg_inq is a signed type, yet we attempt to store what
is essentially an unsigned bitmask in there. We only really need to know
if the field was stored or not, but let's use the proper type to avoid
any misunderstandings on what is being attempted here.

Link: https://lore.kernel.org/io-uring/CAHk-=wjKb24aSe6fE4zDH-eh8hr-FB9BbukObUVSMGOrsBHCRQ@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a8e303796f16..be2d153e39d2 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -630,7 +630,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	unsigned int cflags;
 
 	cflags = io_put_kbuf(req, issue_flags);
-	if (msg->msg_inq && msg->msg_inq != -1U)
+	if (msg->msg_inq && msg->msg_inq != -1)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
@@ -645,7 +645,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			io_recv_prep_retry(req);
 			/* Known not-empty or unknown state, retry */
 			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
-			    msg->msg_inq == -1U)
+			    msg->msg_inq == -1)
 				return false;
 			if (issue_flags & IO_URING_F_MULTISHOT)
 				*ret = IOU_ISSUE_SKIP_COMPLETE;
@@ -804,7 +804,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		flags |= MSG_DONTWAIT;
 
 	kmsg->msg.msg_get_inq = 1;
-	kmsg->msg.msg_inq = -1U;
+	kmsg->msg.msg_inq = -1;
 	if (req->flags & REQ_F_APOLL_MULTISHOT) {
 		ret = io_recvmsg_multishot(sock, sr, kmsg, flags,
 					   &mshot_finished);
@@ -902,7 +902,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		goto out_free;
 
-	msg.msg_inq = -1U;
+	msg.msg_inq = -1;
 	msg.msg_flags = 0;
 
 	flags = sr->msg_flags;
-- 
2.40.1

