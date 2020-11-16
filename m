Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94272B3C55
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 06:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgKPFKc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 00:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKPFKb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 00:10:31 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F9AC0613CF
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 21:10:31 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id u19so17155451lfr.7
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 21:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8rg0liC2axzX6ugokVuI61ZtCL+j00fYtHxx25sNojE=;
        b=mxEh/Hrb+Q7MZj3guiDPxc4UsDOSIhQvkD24XOTEnd6kWuuB5WW8fXs3p64JOw/7hF
         tAtCpdVViD4TquNpO50mqk/lgbCvAcjE/WLvpuYVo7hHvWRe10plgvIjrvivLwOQFMnG
         SOsa3L/WFq5D05YdM4RXGdmnMLKbO3MDhiZT29LiuIJSduRlC5tvfSkUPUVozCZ0ezS3
         GquwgzqjKsZJq36scQrT7UOPnb1OQ+Y+aj5V0k4NhMtYXs+jKEDstChcV/y8V6PkioJh
         MMW/PBWk7estk+Nmql6pzVMHlROzOQpoiU+/xSAI6DXeJCMqak+1uNOJP+phXAA3uYvk
         MLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8rg0liC2axzX6ugokVuI61ZtCL+j00fYtHxx25sNojE=;
        b=BGVC9KO5KgtAduRIBJrh0dBIoKcoJhvy93dYsHkZKsMi9l5DEWcgCw5YS7B4r+I973
         EK1IVil8QsaoOCNfql8BcIDkjivoc6qg1w4BXw8HqUFEezCv2DxJnFMDcfJvCM1IexTc
         6e+vfXBSvJtD2gldy/QXHBYduaykZIWYEmJNNfWLk5N2TuXICbDp5XgjQOSKn4wDec22
         TX3aeIoZY+oosg+/2wu3c9cDYqS4KH9DRPQ8BFSS3EDxR+ehEl4hh/q3B1dq2+WJnH18
         oTPpxiSK20HxxkOhMXhndu1SSIhq0QnYViA4jDszS01Kd1z+/NXux8KGH+r6Xl8wSgF+
         PldQ==
X-Gm-Message-State: AOAM531L0pP/mP5yIJw9MWadcUWoMAapgefMChNsbnnE9D+97reDVgdw
        Z5MRlvUU9VXtT54A03XF9Po4cxbJ0mYpeg==
X-Google-Smtp-Source: ABdhPJxwYAB8QKghSvAPCZ2SXIJSxNM7THCAVf1gpAipjfft/twnLv0QBDjCtmCfqquI6kPN1eGLDQ==
X-Received: by 2002:a05:6512:74e:: with SMTP id c14mr5106469lfs.463.1605503429635;
        Sun, 15 Nov 2020 21:10:29 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id b79sm2595909lfg.243.2020.11.15.21.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 21:10:29 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing 2/3] liburing.h: add mkdirat prep helpers
Date:   Mon, 16 Nov 2020 12:10:04 +0700
Message-Id: <20201116051005.1100302-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116051005.1100302-1-dkadashev@gmail.com>
References: <20201116051005.1100302-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 src/include/liburing.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index cc32232..f1b16dc 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -486,6 +486,12 @@ static inline void io_uring_prep_renameat(struct io_uring_sqe *sqe, int olddfd,
 	sqe->rename_flags = flags;
 }
 
+static inline void io_uring_prep_mkdirat(struct io_uring_sqe *sqe, int dfd,
+					const char *path, mode_t mode)
+{
+	io_uring_prep_rw(IORING_OP_MKDIRAT, sqe, dfd, path, mode, 0);
+}
+
 /*
  * Returns number of unconsumed (if SQPOLL) or unsubmitted entries exist in
  * the SQ ring
-- 
2.29.2

