Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F5F61952B
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiKDLIB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiKDLHs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:07:48 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469FD2197
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:07:47 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id d26so12292267eje.10
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUnKgN9y5bbjKoQlksOPotWUAOB6t+mfVTCU+Adt/ZU=;
        b=ZB1A3YlN/buspGldexEx5wIBfnlFT6h/w4oMzO/fZika0bCEb+txSl9YZcC3W8nRpu
         eAtpgnLu77RCK2CKmsn0GfkesXlvuvB7dOLJvV6Og/mPBc1/0HPFIVdx0tZrsA3lHE8i
         hxxlvJDtdhy1jWiPORbl2mbAeUHp3xl5K07qfwpVtnf+rJ3afS3B7b5M9IkXUAuuZOgT
         eEDBwkZc0F8+xeLn40rL2d3jA9AD85XSFtUi9WyecljBxWTFyBCKFoY4654VSWelVwYR
         0vLGBD0ZUDvzCa4BTWOkMDDuHOlX00DBYvtfB0bxQMlJeP9omMMBNcDLc4kMaWX3kmW/
         wCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wUnKgN9y5bbjKoQlksOPotWUAOB6t+mfVTCU+Adt/ZU=;
        b=mc1iLJ0KPEjwoA4VbwAxzMJAXGSPdzFmOciX50lvsDKjnBrtX9Cbw2FMBuiLdpAL1p
         1oFAq4qj1RJPhc3XhUa/+bjBPsl3OGgVe1IHKvUVb3G/dyqVFk1ZV33T9hCpNpRXDXlR
         GgJjfZdzA8YrkeRFQRpvVUpVVjXMbupKaoXzb1jZtWfSj8iVtw13FtzwbqcwlCq94dlg
         iQWL5AfGJQavnhmoLRAJX/OurMKX9Rdz1EW0tnpyysPmknbHigi/APvYiexD7Rfc6OP6
         Vrd2wwjPWoukGDoQaNww0G2lK2S1DWz6tXIPEJ+qbpT5fz/irlGrD3p0reMcAkLXdjfm
         odoQ==
X-Gm-Message-State: ACrzQf0BRWY7hdCKRdNP/I1eKKonet4tdRaRfaLT1WOa/YOW5ObSwy4+
        Wm7X6OFzwdPC2YuxMNlMTVRuWlplDH8=
X-Google-Smtp-Source: AMsMyM6WRIW8ztzCu4PG5CtYtFZ5Jv4LIOEv8odD5FckSTff9d2PjMM1HxFpnTgNTMR74vsGet3WGg==
X-Received: by 2002:a17:907:2da6:b0:78d:3cf1:9132 with SMTP id gt38-20020a1709072da600b0078d3cf19132mr34237411ejc.299.1667560065538;
        Fri, 04 Nov 2022 04:07:45 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id bg19-20020a170906a05300b0078df26efb7dsm1665491ejb.107.2022.11.04.04.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:07:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/3] tests/zc: extra verification for notif completions
Date:   Fri,  4 Nov 2022 11:05:53 +0000
Message-Id: <a3149c7ca700ddb93ceceb2a32bdde1dd51d4d19.1667559818.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1667559818.git.asml.silence@gmail.com>
References: <cover.1667559818.git.asml.silence@gmail.com>
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
 test/send-zerocopy.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 6e637f4..16830df 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -172,6 +172,12 @@ static int test_send_faults(int sock_tx, int sock_rx)
 			}
 			if (cqe->flags & IORING_CQE_F_MORE)
 				nr_cqes++;
+		} else {
+			if (cqe->res != 0 || cqe->flags != IORING_CQE_F_NOTIF) {
+				fprintf(stderr, "invalid notif cqe %i %i\n",
+					cqe->res, cqe->flags);
+				return -1;
+			}
 		}
 		io_uring_cqe_seen(&ring, cqe);
 	}
-- 
2.38.0

