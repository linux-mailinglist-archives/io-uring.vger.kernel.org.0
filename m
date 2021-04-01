Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0D835181E
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhDARoD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbhDARiC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:38:02 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDD8C004593
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:41 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o16so2130908wrn.0
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=751Gqch0rT59Zvg6aVoR1Vgc/ywvQ75X0+XYDNYxxRI=;
        b=vHqdCJH/jAkInnTbMEGNEZZTbT+kaq8ut4d6Pwh2RkU4EPzoKkunfRRSbXbUaaq4B0
         o9snBOERCaSKzexNm+MH7rLt/upd073FNGxclGRc/mPhYcFcBscPKXinpvZiydsoP/Qx
         2PDidcf8LY34rEfflGgwT7aChed2jKBpXUfLFzwHhdIMRGgLr1Ka0r9rJxPwF23lhaVY
         kFOXPJlgxqU37LWGh2C4dav0v6tsSrgM+9IWY0WnXKX8nZAJiQDaMedu0zRnsKIbkuKZ
         U4l/9g9FZhxoWmbW/X/qkv2MRHqkuhW2Slnm3TZF7Aqam3NaqcdduRF7U1WqD55EQDNp
         MPYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=751Gqch0rT59Zvg6aVoR1Vgc/ywvQ75X0+XYDNYxxRI=;
        b=e4XivhWQedIXSjAg6MxVZnWCQsy/yrfUOZunZHzHOk9qV6s+5Ugl87lv1COSots5Hw
         vmgd+b5F7Ws4xe5NXN3/jtdQM0TvypB9rWH2OykLbFrj1Aoz4IuZFlqnQV+i5J2etYMz
         VoZ4uR8/L5b8FZcGAUnMqdldeKdlviVRjd4M3T/BNq59zfVK/UOFf4A+e3uCfVZwWge2
         xg7LPlxlWSo03Ns9gIHJVHGfTtalV/549Q8iBFan3PYA9VW7wpRrhX3vZu1Jb28DNrzx
         ZZFKgY5l1joO/4+0PWOJ7ka6nge/EKj/mqXhRS2FpzgXLSxfsBF1n8dqO8YaNgTeR86M
         2cSg==
X-Gm-Message-State: AOAM533NnWaw9oiFze5y7SRtm9oAtHiGlcIgW2GoBNWvWipzCPeNWv+P
        v5UL0ctF9DONcHXIZNApicY=
X-Google-Smtp-Source: ABdhPJyTC/Kbc0TmdhtdafwnqVOzkuzr8Jh5XzAPpnPJTBTGPkY0bcK+qCk11bvUssr6U1Xa+nubBQ==
X-Received: by 2002:a5d:6b84:: with SMTP id n4mr10150603wrx.258.1617288520424;
        Thu, 01 Apr 2021 07:48:40 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 23/26] io_uring: don't quiesce intial files register
Date:   Thu,  1 Apr 2021 15:44:02 +0100
Message-Id: <563bb8060bb2d3efbc32fce6101678281c574d2a.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no reason why we would want to fully quiesce ring on
IORING_REGISTER_FILES, if it's already registered we fail.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c5dd00babf59..2b8496f76baa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9790,6 +9790,7 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
+	case IORING_REGISTER_FILES:
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
 	case IORING_REGISTER_PROBE:
-- 
2.24.0

