Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C193A7226
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhFNWlH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:41:07 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:35553 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhFNWlH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:41:07 -0400
Received: by mail-wm1-f42.google.com with SMTP id k5-20020a05600c1c85b02901affeec3ef8so447025wms.0
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dOvbfIO19y9/yQq+PjpvkFBMOVaJ39XXTgXMtuDt2rY=;
        b=ujUr/EBMl80oA225rgAM1cTjZlIst1leCbpI6vLV6t2osl5iF1LmxNUFhpt1O8BmJH
         R7uyAS8KaCo6H22/g8n0YaTBGjeREBMmAm+iDuJkbeWKGUis6kw3yrfDxnTDwwa/07lD
         Aden/uXsTR3liBvnBiwGFBBHllNLuNQZItw6J3sLp7wslB4Kd4coqQR5At5o5fdoLM2V
         nIwp7WugIeTv7kI7ncv1bdepeg61eaoTqOqHOZDPOTVEtWUMO0jpN2FX//gtZQil8KfO
         G3nWtBn6IfBjnDR15ihIVASgsYQQscXvl/55yYwO66Iuy7JHc6f1wDTYI6Uejha5VdQn
         0wCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dOvbfIO19y9/yQq+PjpvkFBMOVaJ39XXTgXMtuDt2rY=;
        b=Oppo6rQAqatar0D8hGM519AwonSuAafWm6n45u2+NDGXG+NTrKXLfrH56Tny77k91V
         rAqwiicB8YkynV2qE8TLzpAT0G7/nfSMGe2onFwSRSbMgw8owbATCEc1YzNbUh9bxEJe
         HWpdJg08cdwbUWi4SN+A1npN0U9OwvHrjaeP7HcYeJI2e9sY0fulf2dHQbo5OjXttKYt
         WtG1C8S46hLfci6IrZnetFi7ZBI8Vbe0zJzvupwhQk5mpPrafyLD183ojN7YW62oH5nY
         6ethPlgYTSJxnDSwoi05H/3n97OSDAirXU3ZYuhstJBlmeaOzMwiGKf6/uIAirGZApPF
         KU+A==
X-Gm-Message-State: AOAM531maq81L1gwAJGMQSnu7/S4jGXk/unxjd3MIiNc0RCoizTNMiM9
        PqdNXjFqloGh+QM6n0D3Qck=
X-Google-Smtp-Source: ABdhPJwsGe+KBN3BGHeA4hb8286s7rapWM12KGxemMChqLYemSPsDapQxyeC9eNB+JpxdNtlrAsExw==
X-Received: by 2002:a05:600c:3652:: with SMTP id y18mr18853272wmq.177.1623710274880;
        Mon, 14 Jun 2021 15:37:54 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:37:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/12] io_uring: refactor io_get_sqe()
Date:   Mon, 14 Jun 2021 23:37:23 +0100
Message-Id: <866ad6e4ef4851c7c61f6b0e08dbd0a8d1abce84.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The line of io_get_sqe() evaluating @head consists of too many
operations including READ_ONCE(), it's not convenient for probing.
Refactor it also improving readability.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5cc0c4dd2709..3baacfe2c9b7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6685,8 +6685,8 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
  */
 static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 {
-	u32 *sq_array = ctx->sq_array;
 	unsigned head, mask = ctx->sq_entries - 1;
+	unsigned sq_idx = ctx->cached_sq_head++ & mask;
 
 	/*
 	 * The cached sq head (or cq tail) serves two purposes:
@@ -6696,7 +6696,7 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 	 * 2) allows the kernel side to track the head on its own, even
 	 *    though the application is the one updating it.
 	 */
-	head = READ_ONCE(sq_array[ctx->cached_sq_head++ & mask]);
+	head = READ_ONCE(ctx->sq_array[sq_idx]);
 	if (likely(head < ctx->sq_entries))
 		return &ctx->sq_sqes[head];
 
-- 
2.31.1

