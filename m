Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410D941953D
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 15:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhI0NmN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 09:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234414AbhI0NmN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 09:42:13 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6556BC061575
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 06:40:35 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x8so8977654plv.8
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 06:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kNXcJD9dZ9uBmLELHo3wBGwZh7b6yKXjqpDxgN5Mq8=;
        b=chk8SU4nFy3VAzU2BS0UMxnbivtsOD/Znu1Qqyd5JkUfJ935MSCKR1gKtpquymvtBF
         obVE8SOOkXzkAFUu0ysXPWhmkzGRSaMN0JyqMbJeBoXDUGZx4fraabB/4kLzN6ggNDD1
         2CRu/fViHiFB6WU/sLFu3+pYg0qC/F+gUJalU0D+xA5yE55OU0bZE8M/IJexJ2nf60UB
         yL4c6Id/XfUXUfPnKY4Cj7Hlimh9FFCrUkpLVVxzM3lcUmpyQBEb371EQBgq54aHr44N
         blDfO99LA9H0J20hihDH/lVd+zrfV2qh6GZ7+OEZjsQmMnVoquTCIKJGbJ3incj+SR55
         fJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kNXcJD9dZ9uBmLELHo3wBGwZh7b6yKXjqpDxgN5Mq8=;
        b=mPmVyL0vcVmwoi9OYZCF7HvaaMAiTXVKQuOwO7j4XVU+41i1yA0Tp8zLenC/PrQ++B
         tPYyYIRfJjIxllC3HX/v4MkVxGDA2DMEKQESq2mlcMl5ivwp9LARklbwl+YhVpGwQV6Z
         QANnrDGa4JdJG5H9uDvVv4l1VU+LpqHJToo4e6T9in1k0EZnkSWXY8PN3jXxPbDd7yKm
         64czPJ/2eJBfhR8AtUPzJaTTT66IZf9v5ds74SV6mIAgbiry081lFt9J9LJMiK5x6LKc
         IPtZuSMxig5aFhyFnUMvs1bLVtfMmAdFb1tDCtEFkO6wDuuQOgZrmWrUV+o7gzhDQckY
         A9Yg==
X-Gm-Message-State: AOAM531+GZsz+TlhiQdPe9wPssQvhs7tv/4pGBJ04KIcfv36CGiQYc9o
        xAWWhDpLRjS2Qjrwx2pa+jrG8O2ruLVutQ==
X-Google-Smtp-Source: ABdhPJzKfJ2BsnuowdaQTK+vY4PvDVYTmXgblSm0wuW+ceSyVyci/YAwsJC5kbzKydbWqwGj0nTK5g==
X-Received: by 2002:a17:90b:3ca:: with SMTP id go10mr5720496pjb.37.1632750034955;
        Mon, 27 Sep 2021 06:40:34 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id b21sm17306914pfv.96.2021.09.27.06.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 06:40:34 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io_uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v2 2/2] test/accept-link: Add `srand()` for better randomness
Date:   Mon, 27 Sep 2021 20:40:23 +0700
Message-Id: <20210927134023.294466-3-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210927134023.294466-1-ammarfaizi2@gmail.com>
References: <7e5e3e4c-5f42-8a17-a051-d7e6a5ced9c9@kernel.dk>
 <20210927134023.294466-1-ammarfaizi2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The use of `rand()` should be accompanied by `srand()`.

Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 test/accept-link.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/test/accept-link.c b/test/accept-link.c
index f111275..68db5be 100644
--- a/test/accept-link.c
+++ b/test/accept-link.c
@@ -240,6 +240,9 @@ int main(int argc, char *argv[])
 {
 	if (argc > 1)
 		return 0;
+
+	srand(getpid());
+
 	if (test_accept_timeout(0, 200000000)) {
 		fprintf(stderr, "accept timeout 0 failed\n");
 		return 1;
-- 
2.30.2

