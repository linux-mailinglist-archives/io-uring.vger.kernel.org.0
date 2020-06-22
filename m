Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650CA204367
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 00:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbgFVWSW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 18:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730832AbgFVWSV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 18:18:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D57BC061573;
        Mon, 22 Jun 2020 15:18:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id mb16so19614296ejb.4;
        Mon, 22 Jun 2020 15:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MFsWP2CoxlGaT4tcqPsf9CLk6g/qtxlZndI2BGlIXaM=;
        b=E1nm3tErVJzuWxTyN0k5zN7Rv3cA8xKb587dfOpeJFGoFPzTXsolGQy40zPT+YaaxG
         OPVLdKea70YlfV5m5pJ24WgDYSM9iUdccUMAOwvQxFUwwvtYOdUxklUEW97LfmHpfBDX
         OgpLnfXXCUsqUmQp36WVpzZcE54n+R0aSdaCSGGZUxlBhzc0dCv4Hfsmd4o0aC1vK+dA
         BaZKPkbQ55tBSIEawKqcZ8L9InPm4Evjzp2V+B+O1JlGVzt3UyPBNxNvgfSy4xxIMG3P
         LxUAwTaIhw0Ptd5Q4KM83vGobgFEMr8mN3g5h7Uv1+WnBA6rOl4XT0OJx2fouZZ5zq2k
         4b2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFsWP2CoxlGaT4tcqPsf9CLk6g/qtxlZndI2BGlIXaM=;
        b=MERFrs1cZE7aiTY5vQjjQmZFxDi9V4DIccpFHJvTodKEH/rrOWxFvPoBShWICZA0+v
         QjFgFTYGlvBgYkXCE29Psv2KEgM6BSBgUixybUAerg6oc4r0cDNEO5SXcQ2qL1K86mRv
         KdY7lv5ducFXv1P3qOPHRuM8JQwiVYq9tLNGIXWX/KC7t8EaGiB0GNbZI698fR9uNbwi
         XJYYDZv6GmcfdSVwQmH/WgD3s/ugwl8q540jRabgrxm/Wot3YgulW+lrMDRzcNNBYJJl
         xkgKhsvOuYEn2FgAh7jgmS57ELVxgI1ar69/JM6oPJNIHUQ96Ka8DLUhJqs1a3WrBBae
         O8Zg==
X-Gm-Message-State: AOAM533VwkHuL5QVRs3oLvP24fyS65PBqw65MyuUCz+AvhtJ4uIrfOob
        B0w0Mr6PLK55LoeyXBtgYfM=
X-Google-Smtp-Source: ABdhPJw66W4Y1Eb1h+64F9r+nAkEkWbq82A+vmvloHgt3CCLPmacJhRYZ7L+Wnzwdk/MWfNtZZyZsw==
X-Received: by 2002:a17:906:4c42:: with SMTP id d2mr18356834ejw.474.1592864299004;
        Mon, 22 Jun 2020 15:18:19 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id dm1sm13314421ejc.99.2020.06.22.15.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 15:18:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] io-wq: compact io-wq flags numbers
Date:   Tue, 23 Jun 2020 01:16:34 +0300
Message-Id: <a07c3937d318a9f89744ce23c804f9bb0e69d380.1592863245.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592863245.git.asml.silence@gmail.com>
References: <cover.1592863245.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Renumerate IO_WQ flags, so they take adjacent bits

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 071f1a997800..04239dfb12b0 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -5,10 +5,10 @@ struct io_wq;
 
 enum {
 	IO_WQ_WORK_CANCEL	= 1,
-	IO_WQ_WORK_HASHED	= 4,
-	IO_WQ_WORK_UNBOUND	= 32,
-	IO_WQ_WORK_NO_CANCEL	= 256,
-	IO_WQ_WORK_CONCURRENT	= 512,
+	IO_WQ_WORK_HASHED	= 2,
+	IO_WQ_WORK_UNBOUND	= 4,
+	IO_WQ_WORK_NO_CANCEL	= 8,
+	IO_WQ_WORK_CONCURRENT	= 16,
 
 	IO_WQ_HASH_SHIFT	= 24,	/* upper 8 bits are used for hash key */
 };
-- 
2.24.0

