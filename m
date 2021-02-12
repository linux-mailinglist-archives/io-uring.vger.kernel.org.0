Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B63E31A4AF
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 19:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBLSqA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 13:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbhBLSp5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 13:45:57 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5CBC0613D6
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 10:45:17 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id j11so521999wmi.3
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 10:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EqXg+Z4OS40aRFez43bqjpJAXZfnCfPyNy1zQY4LOM0=;
        b=cX7MxlhV106VGPbktnI1rYuWITX8RjmuGRokkKAZ6Lt9Khei2VTNtVnpAEhmqxzl9F
         81wJzEESYhYcsNSFqW3tnMzL1aLwcpHo8reyHE+4E7dExYJ+E5I1t529wYNyNciYlaWW
         Y20T3BA6kZZl7NN4hQoJfeCONyJp3eNz1+VrLM7lNlEz5GZoZOCN2EbZdNMZ6Xh6TkwH
         aW3BfaazdzvCwCPEz/FuJWFkCoPyX7zyDyPmt9G6WpA8fZY0XcL9Zf1bN4LBRafM8rNX
         nPU+8282tLWp7U2I3dkUfiltLzDske4IcBXEFOVk9CfX/Yi/IX/1rcRgRYzGvJE2UflM
         oEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EqXg+Z4OS40aRFez43bqjpJAXZfnCfPyNy1zQY4LOM0=;
        b=fU9x/rdkYRAwePBc7CLBeK7dL8Jwkl2VK3Ciw4WUlY8q4An/r+I2FP8w1UGaDRd6NX
         +eIGyDSid/gO1x+4ZFJRzGdXgfm5GeoT6TSAQCU8f+QoimMoYR456I8j848gsz64Ijlz
         kKVyBCs27TnH3qlp2wEqQQIRVvDlMeSTLsr7ca5G6OQTFRKYAGjkIWZ1R6H3FsLSMRoT
         TmG0klZoQx+7L+VTNBlQpheOxI/+d3Kb6YhLchFEDQt6NdnnpGOad+wOa5m24RIjz2Lp
         pAMm4jMscfuLKVhKQ3/YYj7HRkt0dcvVW5IXyj1rdzeRmZmzOfPapzP5ZuPZE1ftTLoc
         kIig==
X-Gm-Message-State: AOAM533XZLlx0OsDsgIKr+Q8aVLnQLYLOsKcWg2vtN4UKxT5pKde99IQ
        D1nkDQ5b1Df7VxSshFWXPZve+vo4ieFDCA==
X-Google-Smtp-Source: ABdhPJy7KddWrF2aidj73EHCqnS8nJqq9VCL0w5v3mSi8dnIH39MCXDU/Q1Gc41petkfeyoO+U5nOA==
X-Received: by 2002:a1c:408a:: with SMTP id n132mr3866284wma.86.1613155515890;
        Fri, 12 Feb 2021 10:45:15 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id e16sm13452830wrt.36.2021.02.12.10.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 10:45:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: clean io_req_find_next() fast check
Date:   Fri, 12 Feb 2021 18:41:16 +0000
Message-Id: <08fc9313442ea39051c4314904da8f7889cbfd99.1613154861.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613154861.git.asml.silence@gmail.com>
References: <cover.1613154861.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Indirectly io_req_find_next() is called for every request, optimise the
check by testing flags as it was long before -- __io_req_find_next()
tolerates false-positives well (i.e. link==NULL), and those should be
really rare.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 66bbb0dc50af..776531f6e18b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2172,7 +2172,7 @@ static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 
 static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 {
-	if (likely(!(req->link) && !(req->flags & REQ_F_LINK_TIMEOUT)))
+	if (likely(!(req->flags & (REQ_F_LINK|REQ_F_HARDLINK))))
 		return NULL;
 	return __io_req_find_next(req);
 }
-- 
2.24.0

