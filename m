Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467E71DF414
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 03:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387539AbgEWBvz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 21:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387499AbgEWBu7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 21:50:59 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E9FC08C5C0
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:50:59 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x11so4125438plv.9
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DT9kV8IQxC/D+uhFJsefv+iJT3TxYB4ReZ7s4ZFOil0=;
        b=zbiGe0xN/5Eo+H2CF5xCbc37d8G9FUD+KwT1btc4sCr0MmxKKhWlYkpMFKsBDe+auM
         9Lo6glgxT0TpCX3WRGG2vn4VE4AX+1pfCRCyrummCo1lCgDdqbkeBEk6ijx9JZHEJeU6
         jRmvQq6kJzvuOmFc9w5apNTgM3Y6aWuEs/rQtJ0OKa8yDTfg0sKs6pnYpShqn12A0A9y
         J6Wc16rnzBpz+0lD/w43ca6v1fqIWEl8Vw2+W7mJDgRZMzxLokmiLxhG9yZLWNMkjrKX
         Hj5+zMmQhwgf39Gi5fHYe6g3ZGmPsA6EMMkh/9rZ+BCgVtl95AzUU9gmqRnnCNoVHzwK
         88yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DT9kV8IQxC/D+uhFJsefv+iJT3TxYB4ReZ7s4ZFOil0=;
        b=FHBtGh/p3mYWYqtZRbUqaDm2RSYPiDg/c9KpQzAFuBGd4KS8TqbHh+y9ipoB+2Jj5h
         VZsV5jNsH5NgnF7rI8UAmt3SvbU4fM9IDjJZvjRVX1GsNGMkHBb6K7pCXitiRaxHMAMX
         Of2A5Z7y9kngSF/NuVz3/GfSwc97Yi9ujX5vvfTuYpvF2WoWsdAr+fId8w2prhCAz+dE
         EfqaRSYogg8auGUKst27O8xrK5pqZ+EJcuWmAdm9zgMSFrl9r6jiyhj3uAcXCe4mOlYn
         tP8BKRoTTrSdOFTAT98HRd1dODRVxNw8p9lGlfC+Ob6LC4mMpRXm0epby9AS3uErCLPI
         T9OA==
X-Gm-Message-State: AOAM531Tdg1MIaVYj6ATN80LCsvoczlr6TR34PEmmTjzAIzVEwP6nz9D
        /kdsXxr2YQ0d9QNN1d6KuTKmzpl6Dy0=
X-Google-Smtp-Source: ABdhPJwBmDXlE+x5QTHM8T9DaQOh7Fl5EgB2+dvXN52teuRxNlg4WmYuq4kTmwFYa3fjjpSWpHNLKQ==
X-Received: by 2002:a17:90a:344c:: with SMTP id o70mr8104020pjb.23.1590198658974;
        Fri, 22 May 2020 18:50:58 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id a71sm8255477pje.0.2020.05.22.18.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 18:50:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/11] block: read-ahead submission should imply no-wait as well
Date:   Fri, 22 May 2020 19:50:39 -0600
Message-Id: <20200523015049.14808-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523015049.14808-1-axboe@kernel.dk>
References: <20200523015049.14808-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As read-ahead is opportunistic, don't block for request allocation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/blk_types.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ccb895f911b1..c296463c15eb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -374,7 +374,8 @@ enum req_flag_bits {
 #define REQ_INTEGRITY		(1ULL << __REQ_INTEGRITY)
 #define REQ_FUA			(1ULL << __REQ_FUA)
 #define REQ_PREFLUSH		(1ULL << __REQ_PREFLUSH)
-#define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
+#define REQ_RAHEAD		\
+	((1ULL << __REQ_RAHEAD) | (1ULL << __REQ_NOWAIT))
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
 #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
 #define REQ_CGROUP_PUNT		(1ULL << __REQ_CGROUP_PUNT)
-- 
2.26.2

