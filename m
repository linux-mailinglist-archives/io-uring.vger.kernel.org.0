Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FD0202A04
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 12:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbgFUKLp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 06:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729787AbgFUKLd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 06:11:33 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C20C061797;
        Sun, 21 Jun 2020 03:11:32 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a1so878624ejg.12;
        Sun, 21 Jun 2020 03:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9kHXcDCGApwkqj7YR7sl1xVeCbFuJErIvk3ogUF1w5k=;
        b=VXBPYJyH7d+CMYKRnbArMtUk4ZOwzU3W+00ax4AKY4qFqsBt34N0Xi8NqjlqB54VS9
         z9J0y92Dqa/iWvgu613l6vpI6eLsuAD6mB2xmVfz/LXokfYbVwjf5dY++3jHdGZlvv4B
         GvrmmiKXRh7ARUAJ33C/5qNdLsunn6iO9GSPgo21Z6+jueVFWVrnKjUd4cILVji0lyZl
         1DGruBdgCADQX/nNiXS27ijdXs6TBnHOn2Cj9D/ShZX0w9JCHglwDkOg+/o80/1QzVDg
         1GawoiQ7ocpTFfxfGbKxn54n2Ej5kGnTmH12MmLFnT+PERZWDN9HUuzMuNCGk3gocXzD
         /uqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9kHXcDCGApwkqj7YR7sl1xVeCbFuJErIvk3ogUF1w5k=;
        b=YAtxuRYCubZUb15SpzgjBiBopVbh5M8qFJY0Kbyf3paqOtRhIq8Jp8NO5ZWNcy48Op
         1lR+mooIpb58kKuicCrurQ5Sq86lSEDc/7IFIT/fVDf+FLlBEZ6+mxFPztE/hW4cHYFQ
         ZbW7udR1LvG21Els4Hz77/cLGu9mxlweyBwcmE48B5NbHluWPfoMLNl7L0JcscdVED3Y
         SrJTSroUAdoaSLRygR7M3Eoo8IKsInHDW94x+YwGVNH3NHAhcF/tdrr3FhJ4rTJS/2BD
         vcVQjQOjfzrZEYEcn4gqNEi8OBZRdKoiItZHuUuam/CHM4PoL6hchGz9bOLvkX9mPl5j
         1a2A==
X-Gm-Message-State: AOAM532nSVhsjuwwQ0Zf0iQ0b6nTetY6vzpETXRwdyca71Ylswlfroii
        l6S0KuezSzj9AQ2/P1bg/ls=
X-Google-Smtp-Source: ABdhPJy56eVRXVUpB3NMDGcjsHjLeGs8lKV4gIcnGC4Nv4bsJzy6gBSebeVrXdceF/sSKSGYlAhsRA==
X-Received: by 2002:a17:906:9243:: with SMTP id c3mr11123675ejx.400.1592734291428;
        Sun, 21 Jun 2020 03:11:31 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id y26sm9717201edv.91.2020.06.21.03.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 03:11:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] io_uring: set @poll->file after @poll init
Date:   Sun, 21 Jun 2020 13:09:52 +0300
Message-Id: <663d6d6c6f3d1c8ddde158f7c171d3a2034c5453.1592733956.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592733956.git.asml.silence@gmail.com>
References: <cover.1592733956.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's a good practice to modify fields of a struct after but not before
it was initialised. Even though io_init_poll_iocb() doesn't touch
poll->file, call it first.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 84b39109bc30..676911260f60 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4585,8 +4585,8 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 	struct io_ring_ctx *ctx = req->ctx;
 	bool cancel = false;
 
-	poll->file = req->file;
 	io_init_poll_iocb(poll, mask, wake_func);
+	poll->file = req->file;
 	poll->wait.private = req;
 
 	ipt->pt._key = mask;
-- 
2.24.0

