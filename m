Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5664120A1C9
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 17:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405502AbgFYPXL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 11:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405253AbgFYPXL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 11:23:11 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBB3C08C5C1;
        Thu, 25 Jun 2020 08:23:10 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id j18so5964765wmi.3;
        Thu, 25 Jun 2020 08:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MFsWP2CoxlGaT4tcqPsf9CLk6g/qtxlZndI2BGlIXaM=;
        b=LtvuZSfMtdEk92pgtiCi2GlzvvBr2UN24cusNA4BHxVcY+zGWCECr5gP54u3Tr9Ilf
         +n6aOqLruWMomyNVfEraaAH7FbaUzf7y8l4wmlOkw5lfaCYUMj0azCDd31VxoP5BCeiR
         WYN0Ia6dkghmiGAhcM0z+6iUNmAF1KQky/fr11duSezetKTLN+omoY/uGZ10lznd4P/n
         Re8zvYZlCAoWNbK7k+4lnfAhtNaF0+JroR6Qm8jJEr/E6cfVDtNHgsbhcnT3KWGXN6gs
         0BwJ9uF8zqSWK05lVJQEpiilY2dGQhB66ByqOMZdylEfhnvAq0Fl64Ks9CkjTTmULCf5
         JmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFsWP2CoxlGaT4tcqPsf9CLk6g/qtxlZndI2BGlIXaM=;
        b=pntJBRydjgYrKR8DPGvNAsuUvWxaa9b22FJG8PhWFBb0qfZmxd/zNQNeKU0pXRUHAI
         5NnHPg2butIXRYL/kEPgySlSSb/afo3Y9rmZrgCGW+cmT6C/cIm+6v1/bec/OrM6Ej66
         kG56aMggfQwochpqZ/OmIcAQGR0H0vcsayyD4lM3W98zvgV9g5EU2Qp7fDsbWN5FW/KF
         OBGfHpzxPEg1MxiEsYVmMIRHVThRRzgzcXTKuknz8paXuf08l726zUCu/xXVYjglorzY
         Otb03Ip1iuF1rX69o0b9+cfT4xbDgm+OXAs4BVXB4HPEsicWYS4ID4TDGZ3kSWun62uf
         yERQ==
X-Gm-Message-State: AOAM530VY91s1tD2ZnTLafMtMx1/+tAuaODvU5lAW9irR6MHhvF8s7hL
        Mc1DNRoQKpx/fvJStO5ieac=
X-Google-Smtp-Source: ABdhPJzm0KLKIftp0YBXaTlyB25sQQjJydC77qHH+bVEdOkHIDvHFIHLCdYzqOU9KNyTmNqRTbIW4w==
X-Received: by 2002:a05:600c:4408:: with SMTP id u8mr4084958wmn.183.1593098589208;
        Thu, 25 Jun 2020 08:23:09 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id r1sm31560403wrn.29.2020.06.25.08.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:23:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io-wq: compact io-wq flags numbers
Date:   Thu, 25 Jun 2020 18:20:53 +0300
Message-Id: <03b97523fd6821a0e9cc4306e04d4a5ad1530de5.1593095572.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593095572.git.asml.silence@gmail.com>
References: <cover.1593095572.git.asml.silence@gmail.com>
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

