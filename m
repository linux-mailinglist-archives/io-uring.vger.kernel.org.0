Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C96424D4F
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 08:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhJGGeT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 02:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhJGGeQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 02:34:16 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F33C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 23:32:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so4297471pjb.3
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 23:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g8AEnOsY7X6XIqarxReNH7aVjytVbPvZu4IUxSDUasQ=;
        b=Rd/Yx4bnP8uWcKZGEnJociw8F3vziZegJ/EqoAhpZvE9GLW5NK+oDYqPpVUNtGFvOj
         6syhImNkmn7GkWLXGpm1ubeIj2s/nv9CEA/ndSsV+uKFkHeQpx9KHHHqUVftBBX+oi5e
         S8/5A6vs7KzQe7bADW9zShWEbqkkOoSPS86hWx7CQmFocnmUrQo1ybyiAQuh+LUvq8yE
         uuxfkgL3mLvdRfxvz/QDJfioKlit/2UybJpsp5sTW12ZpYHDeOc9k9jOvXOjJDQc+WgM
         UrsZLWalKlaMwOb8SW72BJLC0Jq76283K+rFos58uafRjAQkIB2iZi60xEXB/AhTM+72
         GIpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g8AEnOsY7X6XIqarxReNH7aVjytVbPvZu4IUxSDUasQ=;
        b=pVCzfci+jkJGyU6BxHMShtIS1TAzN+2t8JPatZoAHsvVI5Ynhdr8xx0SpYrOQByEDI
         WyHBOKhCARH+0JWuLmBORGq5s3IFdlw6hjG8WotRr0QybU+hrmjpYGFTFvKxYkkSsCv3
         MZ6jlcZRzJtl2Djv5fc6o6LR00UeurvtAs91Arkla1k+HKuPm7xWAb7CBZM4JjjfvJ+R
         /JVaF3B/hmeqCzOrXFIHr8bTfIgy36xnasaX1SO46H7Nu9TYh2B1zZL1ytHQzr5n2U1D
         XT/Cg2MNw4bBNww+uU1CZVMW8RFrZ+6YphFSbxuoWn/3lkF9jY6NsCGLq/IKo3eobsxP
         AIrw==
X-Gm-Message-State: AOAM532BheCgP9qTGTQBW+9tT06zJU4JfpwKx4ChdRHOGyzzLBZY0Cdf
        MTEFCSj/bkTvZmsGmRbqfwp/bw==
X-Google-Smtp-Source: ABdhPJys41cUpcgsoy3rg4Mh2z9dnpkwcsBBA7WXZxRDi24ClQvnNJIUH/BxQXi2Z5dLnj5FEwgkyA==
X-Received: by 2002:a17:90a:ba0e:: with SMTP id s14mr3476911pjr.213.1633588340754;
        Wed, 06 Oct 2021 23:32:20 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id k35sm7103919pjc.53.2021.10.06.23.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 23:32:20 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v2 RFC liburing 1/5] test/{iopoll,read-write}: Use `io_uring_free_probe()` instead of `free()`
Date:   Thu,  7 Oct 2021 13:31:53 +0700
Message-Id: <20211007063157.1311033-2-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
References: <a8a96675-91c2-5566-4ac1-4b60bbafd94e@kernel.dk>
 <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

`io_uring_free_probe()` should really be used to free the return value
of `io_uring_get_probe_ring()`. As we may not always allocate it with
`malloc()`. For example, to support no libc build [1].

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

