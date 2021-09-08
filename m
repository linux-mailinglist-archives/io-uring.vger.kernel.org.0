Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1F2403CAE
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 17:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344874AbhIHPmo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 11:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240206AbhIHPmo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 11:42:44 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0316C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 08:41:35 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id k5-20020a05600c1c8500b002f76c42214bso1966347wms.3
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 08:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pHH4tGwG3p7Gd0Vn+FKW57OBmFbOt/wAYubRvHTK5Uc=;
        b=ATEc+vvIEV2m388gZu3o2eujBznfduDArkvNqc3QyM+4GHM57dBoGezuTXT/PajLJe
         a3TJGrOFrkWWd+rxaTle4tdQpUFX3oBNkoNzIArikwIISFw7GgKnt4PezGuiLcxlFRy8
         cKxyBQcBEYWpSMLGDkAiY3WLlrcRbgazzAZhuTGwFPezW4GrCO7uphRlTDeX5n6DJ48L
         C+0i4DDPuKprVakD1zx5a7TNsQSHvIVPcz3uFbR6G4IEtde4ocJs637+lDF90Ox/egrL
         Gn9gOCkeYKYd7khAmjhhDF7e3xLm8jEyXdeoWA49HaDi1Z4jC7GogoF/AfwIIsR5ihUw
         kZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pHH4tGwG3p7Gd0Vn+FKW57OBmFbOt/wAYubRvHTK5Uc=;
        b=yeT1w7+fGLtjcWt4JQwekrC06zD0mfzn54axzEOAWP29uNMV236yOPmwHMEGgTy8y7
         foSn+d5j3iVP3jAK3a+2GPwGqXTW3o87xvRn8KD7oVzdgSrhk8KkVab+qR7MMujneUsI
         FaMJXAQOfpP97sY31Mba+l5DP5fMSQKnybor4wdWzoxYcgZo+vxLF8aczDkYXUCUUvTG
         RHsLV36UPI7ho7CcrG4L0ts3QQonJTRFVKabs5QJlPvh4AKLwKoYjHMAlC1j2jXXf7rK
         W5S/pEpW1Qg4WK+3Kj8mvukq704lSVw9YX5G2Gi6ue3PbqCND03G2NKBUv6wSi16C5bE
         2S9w==
X-Gm-Message-State: AOAM533ndECIXCuV5I7d4wpI/IBb4JiWarwSjNXgzD3W6YFPfx4wYVET
        HgbRjBDY9PcXtYTHuE7q8CV0o307+c4=
X-Google-Smtp-Source: ABdhPJwoQ14Lz4adoc3+Zw+iZfUA8NWQwekHjFu02+j+u568LpP5ixlU5C43pjjZkcTaYkWfaqkOOw==
X-Received: by 2002:a1c:4a:: with SMTP id 71mr4348380wma.87.1631115694557;
        Wed, 08 Sep 2021 08:41:34 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id s10sm2580979wrg.42.2021.09.08.08.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 08:41:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: inline io_dismantle_req
Date:   Wed,  8 Sep 2021 16:40:50 +0100
Message-Id: <bdd2dc30716cac270c2403e99bccd6286e4ae201.1631115443.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631115443.git.asml.silence@gmail.com>
References: <cover.1631115443.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_dismantle_req() is hot, and not _too_ huge. Inline it, there are 3
call sites, which hopefully will turn into 2 in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 849e1cb9fba4..1dc21f7ec666 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1959,7 +1959,7 @@ static inline void io_put_file(struct file *file)
 		fput(file);
 }
 
-static void io_dismantle_req(struct io_kiocb *req)
+static inline void io_dismantle_req(struct io_kiocb *req)
 {
 	unsigned int flags = req->flags;
 
-- 
2.33.0

