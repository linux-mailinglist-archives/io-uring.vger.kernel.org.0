Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876483922D3
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 00:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhEZWgk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 18:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbhEZWgj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 18:36:39 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE1AC061574
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 15:35:05 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id n3-20020a9d74030000b029035e65d0a0b8so2551719otk.9
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 15:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RiTRNHS1ejuygpTt5xXgXCB+d0rqEUKIB0Nj1i+xQDY=;
        b=IsEjAVpJPCM9sAw6G1yIlOtxfdXTrw3mEXlgtLrpEO16mJ1mnI86/pKL+M2F3nMY3g
         PmbmlE5R7fCMARFpTVFmYXEZISShFHh93XtIlZrKwCAhQfpTbTgKIZdNnfe3fpIxTkIR
         dfQIeLEd6QUpWEd+81Q4N26SOr5GJqxKocK/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=RiTRNHS1ejuygpTt5xXgXCB+d0rqEUKIB0Nj1i+xQDY=;
        b=YuF+7bIWpo2d6eGHcCeX+6N5DfK0JXDcQvvnFNDzZRXpgpD/pWXlrM0bxgI0XehLW+
         2caWJbmr07iTB5SSmtplU6bWY4ZM+sDSKrRwLolkzyt89Bst3m4lqhfYAbK3XF60AB5n
         pDDzmheuGzfPAgBHxDPyV/+wwHhnHptS3QUza5XwdfkEgl1f6boYUour1Wy1tLBi9tXw
         yWVUxxME6lH6dvsruvQMFCMJHFhpXde8di7uVkwEuqqmIahNLqL8Jh86cruQHplX41VT
         BVk4rcwMZWYdoWQNftNtHfJjLBlDjyaSeKcB+Xyx5491SHoRKUsncwmERHRsybC7Wd2r
         9AlA==
X-Gm-Message-State: AOAM5301vPtEraQFMzl2rIkH+dYV2/YkGV9rxEevrHTt055BGGBHPeHt
        QSo5BZC7ibZjHwTkgyqH6Kwo+A==
X-Google-Smtp-Source: ABdhPJwCmyUAdh5K+OT1BNb62Luj9O/u2ZkZDzDbqrX7BpjoaY69yIVhnw4dYOuaGbi7xo/egfSr3w==
X-Received: by 2002:a05:6830:2093:: with SMTP id y19mr442231otq.128.1622068505101;
        Wed, 26 May 2021 15:35:05 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id v22sm116487oic.37.2021.05.26.15.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 15:35:04 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
From:   "Justin M. Forbes" <jforbes@fedoraproject.org>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Justin M. Forbes" <jforbes@fedoraproject.org>
Subject: [PATCH] io_uring: Remove CONFIG_EXPERT
Date:   Wed, 26 May 2021 17:34:45 -0500
Message-Id: <20210526223445.317749-1-jforbes@fedoraproject.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While IO_URING has been in fairly heavy development, it is hidden behind
CONFIG_EXPERT with a default of on.  It has been long enough now that I
think we should remove EXPERT and allow users and distros to decide how
they want this config option set without jumping through hoops.

Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 1ea12c64e4c9..0decca696bf7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1621,7 +1621,7 @@ config AIO
 	  this option saves about 7k.

 config IO_URING
-	bool "Enable IO uring support" if EXPERT
+	bool "Enable IO uring support"
 	select IO_WQ
 	default y
 	help
-- 
2.31.1

