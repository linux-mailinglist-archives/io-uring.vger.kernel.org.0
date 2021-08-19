Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950F83F1ACF
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 15:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240060AbhHSNnj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 09:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238463AbhHSNni (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 09:43:38 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABC3C061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 06:43:02 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id f5so9152510wrm.13
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 06:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=F2fHlHTxlzc3wMhkK3ijam2ItPfxBrpTqa07mv4p1yg=;
        b=n+4cUVqFgWcER+3dDg/aB4qBlWuJm2qdtiegoY51JsCoWeL1PzfWGmNRKxDqegVm7b
         gLQYeS71kSSuMY4EpI3R5XkPFALqPEIQNZ6oMZnBiRX3bKp7hht7mqBuyEYjCXvgxTeV
         V9cyp3MscTnyxMOSjDqDuPaDpXnUZ/dEzb+4RoLF/4e9k3l/upfwTsvkJmzi5FWdPrh2
         xCmDvXPhe72VF04cMmqN6XS1ICgOd0J55gGDV3QApGaTo3FKk6zbfz/wTNz4z3UFmnqc
         DV/pveZADmTQlGDhdVyd0Ko6YXEr+OK4iSi1WK0/l0xrpuUeLOBGWKS1lJkRtTcrxXkC
         z+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F2fHlHTxlzc3wMhkK3ijam2ItPfxBrpTqa07mv4p1yg=;
        b=b30wtQTDELGCl9R35E0jtWPNXz7fqgatoQYm6enW2Ngvx123jmo0evRwPB0KZ4cWrS
         KkvH++6bp5r2H81zFbfWt/pbqVbbTExgEBNoa5tXhGTqN8TUDTCk4dFUbwAslB/aZ11d
         XKqvjrTzWAXCWeMPBSGVNUc6+A6DjTU8dV50zLULW09WWJpD0QPmVTYiBxuyKouuEwcU
         gSl9Eud4jYIrNqbxm0GLfBoKqYTDXaRi94bmjLeYI5ZJHrYXgImAL9nGSdM3sz7upglV
         Mbw7WsTu6Nj4VdU7mQcCKa70Hc87ahL8fwf0HkBDHfruxOc8L/PIFMvs5PdTITGFoYOG
         V3dw==
X-Gm-Message-State: AOAM530gg7VprC7laMNd2j3yVUZ29FCNOtDWTMuJapZTyUDF8Q62K5s2
        MvC4hGAMwkRxRlao1X5JabM=
X-Google-Smtp-Source: ABdhPJzNjd7oeM4qE+KyJd1Ip74FPa85N67oqzx5QsHmBeRE9nSvzU0L1MQYG0GSB9k1Lcnv23DknA==
X-Received: by 2002:a5d:4b46:: with SMTP id w6mr4097479wrs.260.1629380581277;
        Thu, 19 Aug 2021 06:43:01 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.21])
        by smtp.gmail.com with ESMTPSA id z13sm2939459wrs.71.2021.08.19.06.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:43:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] tests: rename iopoll test variables
Date:   Thu, 19 Aug 2021 14:42:22 +0100
Message-Id: <66e749793b37a702c1ac37556c1e354e9dff3298.1629380408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629380408.git.asml.silence@gmail.com>
References: <cover.1629380408.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rename v1-v4 variables into something more descriptive, makes debugging
easier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/iopoll.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/test/iopoll.c b/test/iopoll.c
index 1adee7f..b450618 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -347,15 +347,15 @@ int main(int argc, char *argv[])
 	if (no_buf_select)
 		nr = 8;
 	for (i = 0; i < nr; i++) {
-		int v1, v2, v3, v4;
+		int write = (i & 1) != 0;
+		int sqthread = (i & 2) != 0;
+		int fixed = (i & 4) != 0;
+		int buf_select = (i & 8) != 0;
 
-		v1 = (i & 1) != 0;
-		v2 = (i & 2) != 0;
-		v3 = (i & 4) != 0;
-		v4 = (i & 8) != 0;
-		ret = test_io(fname, v1, v2, v3, v4);
+		ret = test_io(fname, write, sqthread, fixed, buf_select);
 		if (ret) {
-			fprintf(stderr, "test_io failed %d/%d/%d/%d\n", v1, v2, v3, v4);
+			fprintf(stderr, "test_io failed %d/%d/%d/%d\n",
+				write, sqthread, fixed, buf_select);
 			goto err;
 		}
 		if (no_iopoll)
-- 
2.32.0

