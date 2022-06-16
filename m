Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B96254DE19
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376598AbiFPJW4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376331AbiFPJWy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:54 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCCC17057
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:53 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o8so1054025wro.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Mn1I3qJJuXoCLtaTkB3ey7V/NeeqbASVSbKJNj/gRM=;
        b=Z7+mUXTNB35OQnpsqRPaI5dS+t/mgptcxWtGmZhp4NgBLVvWddQfCUU4oSRQuVuNJD
         I9GqF2pzLSbTwTUtMj3z35bT9s8zbgm8Sw3ETvjSMn+YGcI3oTFt+If0arwQ3i6G/dEa
         UpVDKkTrskuZACf0S8JtvIU9iU3Et+zmpmscPiBWSSuvnOjuOETDrxmVAtpRHDAaQu6a
         1pe2r0QF8WiVWNuxgE2eU/ClKQGXx6b7NbCU5XQn6GCSb9HWq7bM5f7Vp7HBE0uwI5YF
         QyGjomPsLfy32sneKlpwoj1cBiFaRlrT6RMW1KNc5Z1PL9Wp9caEmveSi3LL7iVVRvWb
         KCUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Mn1I3qJJuXoCLtaTkB3ey7V/NeeqbASVSbKJNj/gRM=;
        b=mSVp4oYwmKG6I3jWLIkHAEKQWd2+BTyBww0DRALpM8oqOIEbxAP/b1r8+Rh/UAUR/7
         b3D5MIsCxCuzqjDpwu9ZUbHK1ujfJ/lOx6fR1Lk5TV6Hx5PyfOl4N85qQBXEZJm851Tz
         behQrjcs6WoxATfivbj9Kd49hjZQ3aQ0B9KePX3x2IsXYuWBoF65HaRpmXHw47fcN+8u
         IcCsK08C4ROOJLxZQ9BTRi6BY69cudG5UXnAOspkSYeghUl2fuvGZh51xlRou5H5Z6pn
         JcCqWALc0Is7kjzUQKKNnCrpveUxDJ942PhrTFBWE5415ly2k1LvwSQOgU+DJatLXtGw
         ElZA==
X-Gm-Message-State: AJIora+x9O+7NKNzP2wXdBgDlejykPGgDkiSm0XVW+0wrr+MKAuO6OMz
        SNk6x72WBaEYsvzs9BtPmsRbNdUMTSFs6Q==
X-Google-Smtp-Source: AGRyM1t3o6SPPi10wZfI+Y5jjR6hpPLZRxLt8ZGyf68AadoyLyrVSoLnVhVPLpELcpovPby/NHgj2A==
X-Received: by 2002:a5d:4108:0:b0:213:b585:66c7 with SMTP id l8-20020a5d4108000000b00213b58566c7mr3644926wrp.335.1655371371587;
        Thu, 16 Jun 2022 02:22:51 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 08/16] io_uring: clean up io_try_cancel
Date:   Thu, 16 Jun 2022 10:22:04 +0100
Message-Id: <48cf5417b43a8386c6c364dba1ad9b4c7382d158.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
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

Get rid of an unnecessary extra goto in io_try_cancel() and simplify the
function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/cancel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 6f2888388a40..a253e2ad22eb 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -95,12 +95,12 @@ int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 
 	ret = io_poll_cancel(ctx, cd);
 	if (ret != -ENOENT)
-		goto out;
+		return ret;
+
 	spin_lock(&ctx->completion_lock);
 	if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
 		ret = io_timeout_cancel(ctx, cd);
 	spin_unlock(&ctx->completion_lock);
-out:
 	return ret;
 }
 
-- 
2.36.1

