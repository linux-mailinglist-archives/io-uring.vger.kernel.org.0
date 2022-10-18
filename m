Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC68F603384
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJRTwm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 15:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJRTwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:52:40 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934E185ABC;
        Tue, 18 Oct 2022 12:52:30 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id d26so34897700ejc.8;
        Tue, 18 Oct 2022 12:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OEXvp1IreEp3SXV31DiUhQRIjvrLdojheHeDjSM1+mQ=;
        b=abLxG+/ldgxPagEwF9tCeQMuX/Sr0ari2v1LSWCKV7wRCeCTavT4vCjimyaqVnuvuE
         s9yHzyLcX+1aZvlmgl53O8AaqbepqqC84VuZagLgvYjxj2nSwGgfcmCgga/xfcc1yRVS
         YKAdqIf5ZDK7VgNxWJKl1MSTSRUnYNNPOs+RRplyPXyHIi02Nk2Idz+s631Lt+NhH0/5
         qRuMoDqYbuFSuMXUNqu+dBLhMOL2er65Wl8fQXFJqRhnYzRZBcz60yqBdnkCkSyqf+MC
         svfstqhORWDNg41Uzqb0gjxQ3lVVMn9DFS8aNyFMJn4eqDv0QHCgr8auIvWxAkzxIjFm
         q2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OEXvp1IreEp3SXV31DiUhQRIjvrLdojheHeDjSM1+mQ=;
        b=bw0GoEY51WqystaQVYSMUkeTK10yIv0eL0dfTPHrTz6Uy5bOw68IF0llD5I+i3rkKs
         Na+25ubFVmrPpk/wzrrSo1sjYm7QbC8sT4+aS9P/ShEB+777H00XQy+Naar5gSAOSDTU
         MaC2bAD/RvXxtAV6QjuNJQHw7ETKNGaQQNJjVWHhpX8YVPErvd2GBGNBUYLshPTR74/y
         o5tMlIwqFyxoAcZ8JW9ml5ArLM8MSkLt3cSzw5oCxAIqjwRhq0ofGeLQNbFYJdSwbGSo
         havG1sAdnzkx5R9l+2qgkxTyMWkOLiwUoJHniP+VmIx1+a8xgMtBXhGuIsK4NAyu9JOk
         iZbQ==
X-Gm-Message-State: ACrzQf0HHJQSKlKomBVSmU78DICdQ6OXC+ftZeEJXQKJK9qw3fmTwevV
        M1aB7OMPv0jaqd2lnddShqI=
X-Google-Smtp-Source: AMsMyM6GRe01/gzUNqYl0qBi83MJXbgcRA7kWwqcS6QpySglmmTLqgbs8KPzXOENcnWaNdqiTyWLNg==
X-Received: by 2002:a17:907:3186:b0:777:3fe7:4659 with SMTP id xe6-20020a170907318600b007773fe74659mr3747536ejb.336.1666122729204;
        Tue, 18 Oct 2022 12:52:09 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id r1-20020a1709061ba100b0072a881b21d8sm7945858ejg.119.2022.10.18.12.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 12:52:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC for-next v2 4/4] io_uring/rw: enable bio caches for IRQ rw
Date:   Tue, 18 Oct 2022 20:50:58 +0100
Message-Id: <f43faaa420b95066bdc7679aee411cb4edd160d4.1666122465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666122465.git.asml.silence@gmail.com>
References: <cover.1666122465.git.asml.silence@gmail.com>
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

Now we can use IOCB_ALLOC_CACHE not only for iopoll'ed reads/write but
also for normal IRQ driven I/O.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 100de2626e47..ff609b762742 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -667,6 +667,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	ret = kiocb_set_rw_flags(kiocb, rw->flags);
 	if (unlikely(ret))
 		return ret;
+	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
 
 	/*
 	 * If the file is marked O_NONBLOCK, still allow retry for it if it
@@ -682,7 +683,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 			return -EOPNOTSUPP;
 
 		kiocb->private = NULL;
-		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
+		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
 	} else {
-- 
2.38.0

