Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B0428A3E3
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389460AbgJJWzn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731282AbgJJTFY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:05:24 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87EAC08EADC
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 13so12920051wmf.0
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O8fDSJ70wgo3Mr+LQoWYabR2my3aJ9qk8Jc4CeClxl4=;
        b=Q+2adaqAhxu0/2Tj19Bgbz8At2U0h1Br0adz5z2z0FWMZ8az9BzyejApxQuxaogDMo
         z84PfBD/r+fRPp4LwdMNwS2GUOy64qe1hRDIS5VPtP4GkthDcwDf6xuLGsi+LxXO0KX8
         ODRDIk/fVkQxeKeJpTJD+HaLu8jizqOF1GbSs8Bdl52cEav2QLlnInno6pjM0VeLvbtO
         ii4VibLy/FuRCYXXO+UoqCt9xq9sgNiTw0hPzgE7fub/N0MLCAb3w9s4JLqyyXgQIH/e
         dExFIHFT/Tbx6og5bqmZpLC3d1zyaKHfOUPh4F/Dtafl/8Mg0TAv3Bgexl0tNgKvnRw4
         GpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O8fDSJ70wgo3Mr+LQoWYabR2my3aJ9qk8Jc4CeClxl4=;
        b=g3PhDwyoxiCu87msqjjuSpWJW+QJjVId6fairfYCWIH/HrvmHLAKDcOEA4+JJJwj3/
         DNxHr31wumeq4Tf09GK9d3WYY7mY0IAuJnH4pByFZMx0D3Du7JGJclGdND9uibjxe8R2
         1QIiDr0Is37+RiYcR3D9pi/ZmH1lUuZXQoeTJPQgPpi5WvSjBR6R8RTfQ75eG9XkE5ls
         IQjvPchHdM28XJSV9hjhp25z5cncCiEzpLjX05d0aeU5uT6zwCF7S3i08eysEsdPENbF
         HJVB87eMnbtEsAy7SwXbtfmgjkrrTa6duF3Ek5anOATNGQNCLOugt4Cim8etAl+Y5h5H
         Ly2g==
X-Gm-Message-State: AOAM530sVVzvQCBxqLG7Fi5XJklDr0/CCq2VhVGHgA4bp986/c+hwQGT
        zk5E0A+W6juAEpZ25d1wL3Y=
X-Google-Smtp-Source: ABdhPJzT9SIUbPAPODIRmdNPG1WPOe+u5MERlrfOxtk1WTEHcX+lE2lr44Vz9ydam9kp3Mx/AH5UjA==
X-Received: by 2002:a7b:c7d5:: with SMTP id z21mr3491779wmk.73.1602351432431;
        Sat, 10 Oct 2020 10:37:12 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     "Reported-by : Roman Gershman" <romger@amazon.com>
Subject: [PATCH 01/12] io_uring: don't io_prep_async_work() linked reqs
Date:   Sat, 10 Oct 2020 18:34:05 +0100
Message-Id: <26fb33734fee5294f3d20b8be9cf52848056a630.1602350805.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no real reason left for preparing io-wq work context for linked
requests in advance, remove it as this might become a bottleneck in some
cases.

Reported-by: Reported-by: Roman Gershman <romger@amazon.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 09494ca1b990..272abe03a79e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5672,9 +5672,6 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	ret = io_prep_work_files(req);
 	if (unlikely(ret))
 		return ret;
-
-	io_prep_async_work(req);
-
 	return io_req_prep(req, sqe);
 }
 
-- 
2.24.0

