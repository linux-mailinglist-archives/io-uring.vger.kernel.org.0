Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB5A5E8089
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 19:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiIWRNm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 13:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiIWRNe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 13:13:34 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6207114D48C
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 10:13:32 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id e18so634449wmq.3
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 10:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Afgq/8hrwSjfATuD87XUQ87eakFpcMAjx2lu4k2X3Fg=;
        b=XtCwltkvbPO7VrJCE6gLjGuC05m5RM3c+ZmdxBmGlh5BRVb6p5oWixCF1QOfzy2rK/
         zbumg2iynKc2BxAsjEAIllq3nRqJCw8zKuVMGUoEYuKymtuZmb98FRe3gNrX903LMENT
         gclXhg8/7L24AIMCmhyRqOjLqw7ymVFe/w/u0GJdfwaATAbf3aAshRiQBnwO71jhe4GC
         +3u4IE7qVQFEIbKtPJVaKHJwEVz12XoFzNNAbxhHYFZUUb9u05Fcj1Nd028zw1yFyFFA
         Ekwk8gM98UJiCS6RdCJiUS4NI4KtUbbg9oYKz2THt5wQTzmNj9J+leCWT/RtLq5necM5
         Mpqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Afgq/8hrwSjfATuD87XUQ87eakFpcMAjx2lu4k2X3Fg=;
        b=CcnNmg2ymIXIzFGRz8ddXm1zShSUF7semsRUuyJioHXgkuNScN5gytdDDPm4CoMhId
         Ue7UELq3Up6fUdgrIf/L1dnoEtBpzhpuxdrsnBsUbifZ03dK+blY84yLk2tKFK3vSt3C
         B+7MMgVrHK0IuMHTFcFGHlmXVQh+dP7xqSZAGuZ/vFTZyoHkatKaPLQpI1RPzIcc663g
         YEITx8btADPEs1z1jgLOT/sLdhAwDD8p5vst9UjCP1xEcXru2V5jd6OUZAsioN51lQxw
         xCrJkW/jSxOqdwQUxdmEhNx3hTBclIabOMXifm3Xe5xQZ5Cv14djz2Q+y9U3TI1/Cbm8
         qSzA==
X-Gm-Message-State: ACrzQf2MMJj1X+u+YLcPhYEvhwxwMqIY+7TqpvzMlfKj8MrT1CEAtrmJ
        eDKVY4SczxOE8HXWnTJKknp5mPDnpnI=
X-Google-Smtp-Source: AMsMyM72xSYM3QLxwdpxnQTe3Vnj+hD4S5yQuLhIaAVM9fCzbHEClFBi8j4Hk0NG1IvZEFZwF6HpRQ==
X-Received: by 2002:a05:600c:4f01:b0:3b4:a8c8:2523 with SMTP id l1-20020a05600c4f0100b003b4a8c82523mr13406069wmq.199.1663953210322;
        Fri, 23 Sep 2022 10:13:30 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id s15-20020adfdb0f000000b0022863395912sm7774702wri.53.2022.09.23.10.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 10:13:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/1] selftest/net: adjust io_uring sendzc notif handling
Date:   Fri, 23 Sep 2022 18:12:09 +0100
Message-Id: <aac948ea753a8bfe1fa3b82fe45debcb54586369.1663953085.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

It's not currently possible but in the future we may get
IORING_CQE_F_MORE and so a notification even for a failed request, i.e.
when cqe->res <= 0. That's precisely what the documentation says, so
adjust the test and do IORING_CQE_F_MORE checks regardless of the main
completion cqe->res.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 .../selftests/net/io_uring_zerocopy_tx.c      | 22 +++++++++++--------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.c b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
index 8ce48aca8321..154287740172 100644
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.c
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
@@ -400,7 +400,6 @@ static void do_tx(int domain, int type, int protocol)
 						   cfg_payload_len, msg_flags);
 				sqe->user_data = NONZC_TAG;
 			} else {
-				compl_cqes++;
 				io_uring_prep_sendzc(sqe, fd, payload,
 						     cfg_payload_len,
 						     msg_flags, zc_flags);
@@ -430,18 +429,23 @@ static void do_tx(int domain, int type, int protocol)
 			if (cqe->flags & IORING_CQE_F_NOTIF) {
 				if (cqe->flags & IORING_CQE_F_MORE)
 					error(1, -EINVAL, "invalid notif flags");
+				if (compl_cqes <= 0)
+					error(1, -EINVAL, "notification mismatch");
 				compl_cqes--;
 				i--;
-			} else if (cqe->res <= 0) {
-				if (cqe->flags & IORING_CQE_F_MORE)
-					error(1, cqe->res, "more with a failed send");
-				error(1, cqe->res, "send failed");
-			} else {
-				if (cqe->user_data == ZC_TAG &&
-				    !(cqe->flags & IORING_CQE_F_MORE))
-					error(1, cqe->res, "missing more flag");
+				io_uring_cqe_seen(&ring);
+				continue;
+			}
+			if (cqe->flags & IORING_CQE_F_MORE) {
+				if (cqe->user_data != ZC_TAG)
+					error(1, cqe->res, "unexpected F_MORE");
+				compl_cqes++;
+			}
+			if (cqe->res >= 0) {
 				packets++;
 				bytes += cqe->res;
+			} else if (cqe->res != -EAGAIN) {
+				error(1, cqe->res, "send failed");
 			}
 			io_uring_cqe_seen(&ring);
 		}
-- 
2.37.2

