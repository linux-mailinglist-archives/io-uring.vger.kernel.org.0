Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7915B6CC5
	for <lists+io-uring@lfdr.de>; Tue, 13 Sep 2022 14:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiIMMIf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Sep 2022 08:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiIMMIf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Sep 2022 08:08:35 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6435F113
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 05:08:34 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b5so20417095wrr.5
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 05:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Aot8Hw6nod/XTpCOr/9CQK6hngdU8bW4zeLaXvI3jYY=;
        b=cVQ2KlWpo8dAC7O60zg/FdESDhpCNCxv7KvaUuNdsuJhRg8Zp4J00Cw6GT5IpIuyOZ
         VQ+fkCvUeUxkltoQK2nxorHT+8mjQvF4N55jDNbp3c2ILuk9XhQzkgfLrgHgnD+DOP6J
         c30pO1w0UagA18fslezOL3cbXmwfLnbvWmDMeBzE42eIXbUF4NhsKBf/dI+PHT3Ut0qu
         HxwJu03CZuCuav1dp3W1LXapDDLmrD0ffLV+MPowJnqPS2F323Mmp5lzq2EMxixGdERR
         1G59vmpdgGOKb7/E130XjmIsGPnabrUj9F9ECtgYpk8+VMcLRfDfRkw4b6CsY1AAYrWN
         7wtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Aot8Hw6nod/XTpCOr/9CQK6hngdU8bW4zeLaXvI3jYY=;
        b=LjT0PGxwoKlbr1Eju2B0E9JGbpSz/BZF1qKnjzoWD3MpAI+P6r5g361gABUTFRi1OS
         4980OvtoiZkS7p99C4gRibr3brb50pEj0VcTfc+BOcOVC1qjB9YbwVhHiEF6QEql6icJ
         VNA1vD/wvt6eC2L38qnVP/zTikfA5iXOlQ0pskfNEZ75mvO+7egiswtuEVgDgm45DB3s
         rBgIQJ7OKcFUqbf54isy9PIYpI1VqfykRVci9ciDKF6U3hBr96AXsistT6x6Di4aXdSt
         Qu3iwhMCYVExYCB4wP88Xjwx79xgEsXFu/a6mhAEYSuxFmeFAEBSulpvqg4EYLqCOEES
         x9ag==
X-Gm-Message-State: ACgBeo108EkDG9ieqQ5A8ctOVzU2TThE34QSzw5Rflh65Zwv7rljYFF5
        1RUrrrVdWKTpZJB+VUh/1YmFjnA1kH87yg==
X-Google-Smtp-Source: AA6agR7wm7B9JJ1mceIQCB4pVwfaHtCgGs0g7noLGfe+fkyvkCkozzlN9vDMr+x9RWMUKPAHuCek8g==
X-Received: by 2002:a05:6000:1888:b0:22a:4868:6048 with SMTP id a8-20020a056000188800b0022a48686048mr10125717wri.32.1663070912131;
        Tue, 13 Sep 2022 05:08:32 -0700 (PDT)
Received: from 127.0.0.network ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id d10-20020a056000114a00b002253604bbefsm10664971wrx.75.2022.09.13.05.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 05:08:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests: fixup defer-taskrun.c after api change
Date:   Tue, 13 Sep 2022 13:07:11 +0100
Message-Id: <2ed8db2b22f7840977bdc58b6d282be750c878bb.1662900803.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/defer-taskrun.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/test/defer-taskrun.c b/test/defer-taskrun.c
index aec8c5d..c6e0ea0 100644
--- a/test/defer-taskrun.c
+++ b/test/defer-taskrun.c
@@ -142,8 +142,7 @@ static int test_thread_shutdown(void)
 	if (ret)
 		return ret;
 
-	/* check that even before submitting we don't get errors */
-	CHECK(io_uring_get_events(&td.ring) == 0);
+	CHECK(io_uring_get_events(&td.ring) == -EEXIST);
 
 	td.efd = eventfd(0, 0);
 	CHECK(td.efd >= 0);
-- 
2.37.2

