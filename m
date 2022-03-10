Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3FC4D4FD5
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiCJRAO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 12:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiCJRAN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 12:00:13 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9172B5623
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:59:12 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id i1so4165165ila.7
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XP1/ZQ1xExAZz6k/xoGJlaFNxxXVrC4Ya/J0S/FniNM=;
        b=x+yvN41cqt7n+JyoaT9LMcktqxj2Yk1im7I07mqRD9TRvyzOtFPu2q5BXUhhzO32AV
         usQzbquUWhIdiaZJ18opKILBgHYQ/fSiF1z3VRcNzfkfnFF87568BW5ttRjUcVcqm3ia
         /LPvMDprwpvgegDN6hgSs7m0DELY9GKLLfUMrilftP7wURVXr5k/riMp7h7lKHUrrWqX
         32vlpMuEOOQfzqpNGM+vXP6aVwq82ozmaEu07TQpGSX80/1cfUDPrXiccgXw2zBr0/h4
         Q3d01+qMlWrzJyclyGR/nG8tAoJtKgKuYHE7xydW1Vz7Lewi7fSwbrcjwRMSAF5tr1MD
         WZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XP1/ZQ1xExAZz6k/xoGJlaFNxxXVrC4Ya/J0S/FniNM=;
        b=eu9nJeVCpnMlLGiVwCpX52G9D9xnpikZBA+rdzwYtFyqmSomVQWmJfHrNW68ROyno0
         Z6j3gw08zB3mrfYGt6q8yJLOn0BLFtaCIDVLhbgohYNWynq2ZfkiT5Ux5GyhDRfnU9rk
         ixpEr2W2GiEiu3PzX7QuRjQzPwSLpb7Qanbs0RP1h08ZCKkzXAeXesCFMYnAeTrtWtsq
         4FNeeBAlOIla8ssKU7GXONyat/C2rBR53vw9DmS/wI7Vs/HgZ9QikpnjcuwJEKvGnP+h
         BMndb1VdslrRVoN6Jwv0QqkEjZep33vPCI2aCIsfK5eFY0wVFgVKE7UlLb+EibwMA5lY
         JIOA==
X-Gm-Message-State: AOAM531DU7y5RU4rPBt2Qrcx/+/fw21VvWCzb65cAD18gB3fHi8QZSi8
        wFzbPH6zZWB/cPOf8crni35u98zwmLYRGtsV
X-Google-Smtp-Source: ABdhPJzlw/yCWNdPk6if4m/STkfRrr31wcD1PjD7K/kjLXRxb+jEgzHj+YYZtRI0r6hDJSrSdIVMHg==
X-Received: by 2002:a05:6e02:20ec:b0:2c6:158a:cb33 with SMTP id q12-20020a056e0220ec00b002c6158acb33mr4320152ilv.113.1646931551757;
        Thu, 10 Mar 2022 08:59:11 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i8-20020a056e020ec800b002c7724b83cbsm86865ilk.55.2022.03.10.08.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:59:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: retry early for reads if we can poll
Date:   Thu, 10 Mar 2022 09:59:05 -0700
Message-Id: <20220310165907.180671-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310165907.180671-1-axboe@kernel.dk>
References: <20220310165907.180671-1-axboe@kernel.dk>
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

Most of the logic in io_read() deals with regular files, and in some ways
it would make sense to split the handling into S_IFREG and others. But
at least for retry, we don't need to bother setting up a bunch of state
just to abort in the loop later. In particular, don't bother forcing
setup of async data for a normal non-vectored read when we don't need it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d30f7b07677..4d8366bc226f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3773,6 +3773,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
+		/* if we can poll, just do that */
+		if (req->opcode == IORING_OP_READ && file_can_poll(req->file))
+			return -EAGAIN;
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto done;
-- 
2.35.1

