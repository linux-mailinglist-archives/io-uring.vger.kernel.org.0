Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E30870997F
	for <lists+io-uring@lfdr.de>; Fri, 19 May 2023 16:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjESOW1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 May 2023 10:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjESOWZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 May 2023 10:22:25 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4977613D
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 07:22:23 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-96f588bc322so177079666b.1
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 07:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684506141; x=1687098141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lgURY89Fx0z/Cx9R9EMlWQYP9/j2r6d2eG1DnxBkWwE=;
        b=eC7QpmOSmK8p4IJ8Hcep0Th6K6f5piqlplxBQp0sc8WKrjalFCxAvgoqW4txInEnef
         dVqCm2ar4RI7h0LCYhy/vnNFTe66asWQ66crOomZGcbXAOgt2Kx4dbXdV6R21t+KkpZE
         LDBbyfYoInqo5XJGISFvBt1Y+iU1UlQWvVnllATWmigQMdCD3EftSFwvWhfrLqwTFFvw
         TSIoVqy1ZbRsriNsEPfu6i1jDoHIs1hBEMem15wbbv+JEyabnpUFtFMKUQhykdD2uEkn
         jWCRxfFSw5nBvkl4oTHjdfCUTTxQfC/IXuXOc3M2EPHj8hX0NFtDWz2dyc6+kuPHg7+B
         v0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684506141; x=1687098141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lgURY89Fx0z/Cx9R9EMlWQYP9/j2r6d2eG1DnxBkWwE=;
        b=B4JnmuDLdVBj5Kzrnkj3UIyFN7ebHi/btyALKQCchEnURm+djvrYB1rPxEMrZqUX37
         7GyzM0Oz6UzRj+oIOju8D039QkVhwAC9nvgu1FWLiYoiynTodpDL0M7sGOGM0xf5iSyd
         UvefRjp+tMTIbnFpjMxqZB20Q95J7zzqhwaU3a/y6OZGnluTrv1fgo4QtpbMj/9inxA6
         x+ngCkQiCbLj3oArw7kbvzkdCuSAhPQWNY4MZnt8vg6Nf+QQWTT9ltEhKlL70IFgEZ50
         rXZfNkBp8TlsNm8X0O+Iv92i8xeqPcb0tdnjcaoBkoQsMtYX41tJlDKZnxcyxTola6wf
         MpEw==
X-Gm-Message-State: AC+VfDy97y1W11yJG4hP7JGD3vEGJITMQu5ePHxlwraDMvVyKz4Bgs1H
        FZK20lbN/D4eeFreWXZWccJ42k6x1nc=
X-Google-Smtp-Source: ACHHUZ4Je+3rQ812TdDNV40yDsp2CjcSP7C+j6mrJYVvZpXhvapbCfzamx4Nj11FGEzUvv8Jgp6vLA==
X-Received: by 2002:a17:907:a0c9:b0:961:be96:b0e7 with SMTP id hw9-20020a170907a0c900b00961be96b0e7mr1737317ejc.48.1684506141404;
        Fri, 19 May 2023 07:22:21 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:e979])
        by smtp.gmail.com with ESMTPSA id d6-20020a170906c20600b0096599bf7029sm2364103ejz.145.2023.05.19.07.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 07:22:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com
Subject: [PATCH 1/1] io_uring: annotate offset timeout races
Date:   Fri, 19 May 2023 15:21:16 +0100
Message-Id: <4de3685e185832a92a572df2be2c735d2e21a83d.1684506056.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
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

It's racy to read ->cached_cq_tail without taking proper measures
(usually grabbing ->completion_lock) as timeout requests with CQE
offsets do, however they have never had a good semantics for from
when they start counting. Annotate racy reads with data_race().

Reported-by: syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index fc950177e2e1..350eb830b485 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -594,7 +594,7 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 	timeout->target_seq = tail + off;
 
 	/* Update the last seq here in case io_flush_timeouts() hasn't.
-- 
2.40.0

