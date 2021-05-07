Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7618B37689A
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 18:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbhEGQYP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 12:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbhEGQYJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 12:24:09 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB15CC061761
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 09:23:08 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d11so9856911wrw.8
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 09:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=iqfpNdLRqC5STgS4hUdTosAZCjtcgdVjE08VEjYc3Qc=;
        b=RwUtFJKvRCqC4cP74a3LhhUJu+4kMjb5sCus3wbWtBnwmrll18bOJ0GmJKii9LyRzA
         TODVqjeh6Its2EnEfD0XnnmrkKkNMa3FmWtU3S+siUUdRHah1CChQcNaekUCd+YcHrR/
         sThKfK1rbh9KqJ2+SMoIat36CfdceYvoWcVLmTKgx63eU6IxOoHvZCRiv4mNcE6Mu5Wv
         V9dk+dtXYJ/DJwUQtbhcvnRi9C+G53nhihwvI7/O6lrBJEmgZVHNqa5c7JsLFQhWz+dQ
         imFNgRbg6ia3A6iMbWzb9qS2zTBwGmIP/V4bhL7HLiUleeMvl/F/4EdnCqml2fv8ZoaV
         WPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iqfpNdLRqC5STgS4hUdTosAZCjtcgdVjE08VEjYc3Qc=;
        b=mzLwgiBFaPZ811rZAxLyzFPjMNFcryHNomrEpGmIluo71MgdfurpC5yyHNWXrMnU7q
         0tYJ5HcJgZXIFry/ixs3uh99i0bNrBfIFV1jwhZxqATSwScqsL97ACKW1wCAgSXUSlYW
         GuWQMA9/s0FLEjk1MAPvlR7bfhG7EaDvdMr58+4KtfCNQEVjQXOK+ZU4UtUY2adittUj
         5Pq050zhN3541wxD+1RWTJg5xDkj3EG5Cocl0q5YtaWSiWTVk/RxTzU2GpsaI2H/NkDk
         N7S85YHdQ3y72xx8RUn1kD8lnZRXgIPqsiEum3nBj2MppGWP59u4pOWjNk4hU8IowWtH
         gULA==
X-Gm-Message-State: AOAM531UI8LTe/EKx0LMfRo3ZAO9yBgeymQTbK+BaFSrwIqLzuFlkLwP
        AiNIsSz0QLTQ9ml0nLkcpw5xJi3gQGg=
X-Google-Smtp-Source: ABdhPJzZeM/UNt+jthYz8wXNcd2St4fH49Ufo2QzPakzOe/4BhqDSStXt65QrraSAT/nBboLP2kHFQ==
X-Received: by 2002:adf:ee83:: with SMTP id b3mr13173546wro.329.1620404587581;
        Fri, 07 May 2021 09:23:07 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id w4sm8765630wrl.5.2021.05.07.09.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 09:23:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 3/4] tests: fix timeout-new for old kernels
Date:   Fri,  7 May 2021 17:22:50 +0100
Message-Id: <6f01055350de8dfb637a5c5475dee1cdd4e4494e.1620404433.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620404433.git.asml.silence@gmail.com>
References: <cover.1620404433.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Users report timeout-new fails. Don't return an error for older kernels
not supporting IORING_FEAT_EXT_ARG, just skip it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/timeout-new.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/timeout-new.c b/test/timeout-new.c
index 45b9a14..b0bb5ee 100644
--- a/test/timeout-new.c
+++ b/test/timeout-new.c
@@ -203,7 +203,7 @@ int main(int argc, char *argv[])
 	}
 	if (!(ring_normal.features & IORING_FEAT_EXT_ARG)) {
 		fprintf(stderr, "feature IORING_FEAT_EXT_ARG not supported.\n");
-		return 1;
+		return 0;
 	}
 
 	ret = test_return_before_timeout(&ring_normal);
-- 
2.31.1

