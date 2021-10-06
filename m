Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B348B424078
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 16:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbhJFOxP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 10:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239051AbhJFOxP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 10:53:15 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29194C061753
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 07:51:23 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id s16so2630430pfk.0
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 07:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2zXgVUGMRD1cV9q9lrCfkouTsJSs3F5AVXAojz6Q10Q=;
        b=PoMz5aAP6ADHZgOR9ZjAm3WPiWg647yTwoHHu/KANivnFoCUDvIwbtp643/MN6aD/N
         CISWTOXUpUD961xOH6jEQYQhaMe2UpTwS+5DoGFiXdqGm//GiCEGnvbGQkxsmludQ2s0
         kxX5ksxl5QZk24QDugHQDtmtWSBCiKXuDu29iESS/BhULebRBR/u5lM5yPP6FjgXgIcU
         j1sLL6HKeQKr/9fV33FP/6fbrevzeuTi2hHtU+6+LTJzVsH4tyH9IKhtfZWYE90iKBlx
         EMc0PxmackMa5tdUgjFCWB0VYTVXXuU/N3pXEmBpxyhaV0PKeJnWObwSe5yz/HOEiwlV
         4r3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2zXgVUGMRD1cV9q9lrCfkouTsJSs3F5AVXAojz6Q10Q=;
        b=IJDxmbBpb6J8Ttr42WPy86O7YY5aDs9+YuWpiS3CVo6pHMcuH5PELm8EulB5FWWbcw
         nh0S4cO8wnLn3tpPH4QknVQGfymH8Iv61TGYdfNVLZxpL7XOnYvSuVWtwChlyFHXBs3g
         476mjkg5JRFLEwJLQP7iSZKoYc09kunaLFOLUlIBO8WaMcTt2T2LriNcFsnB+A2DJFsY
         zC9jaZAM24e5nQoSZlIINXDB8jAP7JkXGwp5KSAVISwq7iKYTpEj2CRcIhibJAjoRqne
         hvv/15Y5xD88tX39Rg38LhUcoIYAbu9TrZXmdNNMrLyQ7FNwXuNkCM2HlTOSpHIo8VLG
         HUlg==
X-Gm-Message-State: AOAM5322UEJVr6F0C0BWHQgyCX4w1TShf8JTKHQLbE9O5A/Hw5n6gMX6
        j5oN6y/lrkC56fSPeMDllQc5Xg==
X-Google-Smtp-Source: ABdhPJwglqw5dFIaVA1LoTRPjRnLf/LuFnwzrJPSEv7/awyNry1tPFIaOZ5C46b3xuQ3bb4O4XYoRw==
X-Received: by 2002:a65:538e:: with SMTP id x14mr9634142pgq.364.1633531882781;
        Wed, 06 Oct 2021 07:51:22 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id y197sm19155429pfc.56.2021.10.06.07.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 07:51:22 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v1 RFC liburing 5/6] test/{iopoll,read-write}: Use `io_uring_free_probe()` instead of `free()`
Date:   Wed,  6 Oct 2021 21:49:11 +0700
Message-Id: <20211006144911.1181674-6-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
References: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

`io_uring_free_probe()` should really be used to free the return value
of `io_uring_get_probe_ring()`. As we may not always allocate it with
`malloc()`. For example, to support no libc build [1].

Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Cc: Louvian Lyndal <louvianlyndal@gmail.com>
Link: https://github.com/axboe/liburing/issues/443 [1]
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 test/iopoll.c     | 2 +-
 test/read-write.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/iopoll.c b/test/iopoll.c
index de36473..4bfc26a 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -306,7 +306,7 @@ static int probe_buf_select(void)
 		fprintf(stdout, "Buffer select not supported, skipping\n");
 		return 0;
 	}
-	free(p);
+	io_uring_free_probe(p);
 	return 0;
 }
 
diff --git a/test/read-write.c b/test/read-write.c
index 885905b..d54ad0e 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -480,7 +480,7 @@ static int test_buf_select(const char *filename, int nonvec)
 		fprintf(stdout, "Buffer select not supported, skipping\n");
 		return 0;
 	}
-	free(p);
+	io_uring_free_probe(p);
 
 	/*
 	 * Write out data with known pattern
-- 
2.30.2

