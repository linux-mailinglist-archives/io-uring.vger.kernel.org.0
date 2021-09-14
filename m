Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12ACD40B072
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbhINOUP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbhINOTR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:19:17 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5333EC0613CF
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:17:58 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id v16so9386897ilg.3
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7aCyMA3VxhptRQuh2ttvtkXb5nYxSvlQb9n4PnL14HE=;
        b=bwE/2/tK2n1UYEGcn7p4EO23vPC1et3DKrZqIRlb0ERou43Q2SvnNa+LgCzk3oN1Ns
         vfSTHXNoybsZ3qJitqsVHVy4RRYNMuqHmdPn2AdjQoouunmLYKskG1aYWL0/xU1ZskVD
         r1vZDSzz5PxlDNXczWAs1lm4eR8XESGIslPTDWIQABxKz1QrBoVm+McKh40xyz3E3weO
         D5A6HVm41Nfno/Cewagz61s56582gqO4jhc3/kuG6WSKoKo8fH3hV0HhQfYL9hgnpUoM
         8Yp3b9IkQJ+LWLZLc7CO+1L9hwQEDKJDXJjnkJ/qDrKNPOUkvdfocf9yZb5hKAo8dk1o
         ccOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7aCyMA3VxhptRQuh2ttvtkXb5nYxSvlQb9n4PnL14HE=;
        b=q3saO4tbFnslX3j+W7Y/3H8ALDMbAZlmTdZstuoRlW8uTtzl5ahH+cV1BnY++d3EOO
         RkvseeDtGwUhfft+42bgLb64WQ1j/gwp6zh17JP8ggeAbNonIZqsQh1SSjZUiE8P5pb6
         Tvgx7ZIyQjXiBsHEifgWtMWWb+kVastYa6KXYMTBI7GevOh9fzoM4QskOL7+63qv/5KP
         Gn1d9L+VSMKZo3hriqIHdj0pEdGtPbR8qHptjiDcIrGPlr8fyYTaFOou/R8mBhXZoA9M
         D4hQMr+K5rW0ZerSGo1OxqNmB07uc1IdiFmOU/Gv+N/gmOMsnb5pONtvsCfgG8/w6hhv
         zzlg==
X-Gm-Message-State: AOAM531QOe6Lrn+vLhJx2IAqA6gOGiBTRHLtqJwh+6hOlzHAPSSmmL4I
        CxQSleJgSKpJQsGUBFoHch2z2Qglx/Ns/lK5BWk=
X-Google-Smtp-Source: ABdhPJwUFL7j7IrHbZjylmb2vw1tz5jvS/34hnWnm/Nfk2WoRkDcgbycQlBs74N5ui4q0mrqU31lBA==
X-Received: by 2002:a92:6802:: with SMTP id d2mr12086283ilc.40.1631629077503;
        Tue, 14 Sep 2021 07:17:57 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p135sm6673803iod.26.2021.09.14.07.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 07:17:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] Revert "iov_iter: track truncated size"
Date:   Tue, 14 Sep 2021 08:17:50 -0600
Message-Id: <20210914141750.261568-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914141750.261568-1-axboe@kernel.dk>
References: <20210914141750.261568-1-axboe@kernel.dk>
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

