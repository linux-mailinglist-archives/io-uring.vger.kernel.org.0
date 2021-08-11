Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4253E98DD
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 21:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhHKTgI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 15:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbhHKTgF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 15:36:05 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7BDC0613D3
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:35:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso11315430pjb.2
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3qJ0cLXPwzuYEK5Ou0Wuu6u7LZDeLGYslbPHi5c/pHk=;
        b=SfbYM3OkBemATUFedu3RcmN2KNt+PrN56St6aEdv1p2MLCaQbOwLIQA7l9X3Fp3/PL
         VNbtizRGhOpevgv9CFl9hmXh+McvLeafA3DvzphN/LRlEOuLOYpEDVxxfj4fqwICpaWL
         mFur6X+dISuCkMsVCvHSDO5q7U7nqlJUxDmjs9G068CVZJYIL9c3qvXeRsvt1FYvfm/t
         OQO43sqweqGWLQD8/M930uAPaGl3xd0fetGWLU9KJcDIxmizS6CWGqaoqkLYUl4Ch6LJ
         jTGMfGbY2Tn4zdnYOe28+MnGtHSvSDZx/4MseKVbTNkYJ0enGK37QbxyC2ZupUwzx/dZ
         /tNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3qJ0cLXPwzuYEK5Ou0Wuu6u7LZDeLGYslbPHi5c/pHk=;
        b=CO9F0wtzXarSqLQ1HEyFwJtmlNlx229Q1lVt+SdmFk5Rt2y8WZvFfCyrTDk34/Duea
         zGHS4P3SBfNZMUGq4KXwuQLJQnqUEXP1dJjfhGSql9sfQtFCoZ1rP5qDagLzytT5kAIT
         UKToJJkEhrDrJNPbEfOHx1Hd66BwqkcvVjeVBrhbI9p4YGId5c9MV7SCXG5lWxfh2Tbn
         YZpZf1kKZ/wYXPJbPA/X+uSX4EK4KdL/zG4GLNk5dE6ryZXzqEkaPn8SLOZD6QqiwDqi
         GM1YOtEe2N3Qk8+azw/wsmYwVFZYy0P40PNtMEvwwJOr0XukB9tz7AaMxYyK6Gh9ZgdT
         ZrOg==
X-Gm-Message-State: AOAM530WKLqFhM9SKIWO4j0Qswds03ZwDZ7olwyGn/M0VkxFurJgc6kM
        1I5ghZ+5cVlFoC/DzN85c0mlG0KJSFMzkXRV
X-Google-Smtp-Source: ABdhPJw+pjLBfJhRyRCDOoT+oXV+bgpnlxCfXS+YcKGx6KPwhG3u9kPWOt3xTeufIVtCKF26mC90rg==
X-Received: by 2002:a17:90b:f10:: with SMTP id br16mr3171552pjb.65.1628710540759;
        Wed, 11 Aug 2021 12:35:40 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u20sm286487pgm.4.2021.08.11.12.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:35:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] fs: add kiocb alloc cache flag
Date:   Wed, 11 Aug 2021 13:35:29 -0600
Message-Id: <20210811193533.766613-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811193533.766613-1-axboe@kernel.dk>
References: <20210811193533.766613-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If this kiocb can safely use the polled bio allocation cache, then this
flag must be set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 640574294216..0dcc5de779c9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -319,6 +319,8 @@ enum rw_hint {
 /* iocb->ki_waitq is valid */
 #define IOCB_WAITQ		(1 << 19)
 #define IOCB_NOIO		(1 << 20)
+/* can use bio alloc cache */
+#define IOCB_ALLOC_CACHE	(1 << 21)
 
 struct kiocb {
 	struct file		*ki_filp;
-- 
2.32.0

