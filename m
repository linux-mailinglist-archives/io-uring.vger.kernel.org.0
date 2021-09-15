Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62D640CA19
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhIOQbH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 12:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhIOQbE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 12:31:04 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BF3C061766
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:29:45 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id q3so4215382iot.3
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7aCyMA3VxhptRQuh2ttvtkXb5nYxSvlQb9n4PnL14HE=;
        b=TnxV6azM337V7+EQTc7tgqg4h6BabFLlrm1nMP2mWqq8fSWZedsXCiezxxZ748yuKD
         wNULwyCPFMzWQB1vJzp+gUlivZ9dzJ0LMSn8jCMznBpWqAJN0LIjOjPZI0ETiRXij0Im
         QWJoA6KOSX3xX/6dhfU2LFCur0alTcWJbEIbm7lEEuBBrEFVIfuf2q2Hx+4HvKSG7zPG
         jqaoXY61iFg7gdTjWu5KKt6NjWeECajEru5Nsf3+4ny/iiJDWZSKPs/yaszkqV+e2RtX
         rXfXCmUrR6TCMLxDgxhuRVQC6npdvqo0ADcQSvcLjJqI3h8SXQeQw1dLK77yYGk3+WNn
         U6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7aCyMA3VxhptRQuh2ttvtkXb5nYxSvlQb9n4PnL14HE=;
        b=B9FURPJDOwPXVzPXa+qa9PZTRaUHZHR2mf1YLS2cVj9U1G0IJkNqYTeMe+9szXNKNt
         HiV4xL0jhHNHzrtJM7fvSUbkITUYlqsXeMGfQRwaDawuf6tWm3saNWj6xc9uwNu9QD/C
         ynOO2SXH3CiX43hq8qAYWd1CKmtara4o018KjXGMRDT2y05Z8/TuvEbUJW0U/1+IhpHT
         vr7GemwhTrTLNGLvisN3eO/rnhIJLWKcI9gaz6Ism7kr5d2gCHXKfteyj0AN5wRbr+w9
         9wzUMgb0KIuEfQkJFyA/ur2vp2AW25Hy89b6ndeIU8xjT0znlVHI+LQ39eGXbOmYsYDV
         SaLg==
X-Gm-Message-State: AOAM530W96Vpa/qUWJnh1irWDYTawZpfvoztONfmXStsBurbb88sZvMy
        QhmHnPRtyJtCVru4URbopna7F9KalMaZoq7ojdY=
X-Google-Smtp-Source: ABdhPJw0rEUbTlqPzEJ0gkbfI5nR+gnP7QBSpN/3+6wbIEL9EW781xjzD2XmKlZ/N2ckNBw8lUjbXw==
X-Received: by 2002:a05:6638:1347:: with SMTP id u7mr754174jad.34.1631723385002;
        Wed, 15 Sep 2021 09:29:45 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t15sm227160ioi.7.2021.09.15.09.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:29:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] Revert "iov_iter: track truncated size"
Date:   Wed, 15 Sep 2021 10:29:37 -0600
Message-Id: <20210915162937.777002-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915162937.777002-1-axboe@kernel.dk>
References: <20210915162937.777002-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 2112ff5ce0c1128fe7b4d19cfe7f2b8ce5b595fa.

We no longer need to track the truncation count, the one user that did
need it has been converted to using iov_iter_restore() instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/uio.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 984c4ab74859..207101a9c5c3 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -53,7 +53,6 @@ struct iov_iter {
 		};
 		loff_t xarray_start;
 	};
-	size_t truncated;
 };
 
 static inline enum iter_type iov_iter_type(const struct iov_iter *i)
@@ -270,10 +269,8 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
 	 * conversion in assignement is by definition greater than all
 	 * values of size_t, including old i->count.
 	 */
-	if (i->count > count) {
-		i->truncated += i->count - count;
+	if (i->count > count)
 		i->count = count;
-	}
 }
 
 /*
@@ -282,7 +279,6 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
  */
 static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
 {
-	i->truncated -= count - i->count;
 	i->count = count;
 }
 
-- 
2.33.0

