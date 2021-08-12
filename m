Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB173EA7C9
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbhHLPmT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238168AbhHLPmS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:42:18 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8370FC0613D9
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:53 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so8335948oti.0
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mwde66FBJEayMjWLFoOXKXeLTWGiokZGl4UEeh431cU=;
        b=X+OAoTNalGpdjv+G+zkze8hvEjnVKfAX2xQiw6waJIXyUSRk333/Pz8Sl37J0t+2Hk
         a6obqFMEOhEhjPzvFgVKWnqd3DeCm4xQdgRJz8b27KbtbEYi9v2jWUqQKR2HMccD/MVP
         xKMz1EqyaHCnoih7URWAdTrH8cSmaF4uMwh/kGqhybTAa8CURx3NuFbYLcO/FZh2y+4i
         daIB9Ks2N7cVuuh26dPDjROvoexIyAjQw7DUzQLEDFmvNUsjgJzXNIaH3IDjPfYE8ywb
         EniSPSCbS5Vyv2tsi6D/ahIPtRgaOjT0AcmDC/0zGuPOSMWRP7k8bKmF2oLQWqWqrSPV
         lc+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mwde66FBJEayMjWLFoOXKXeLTWGiokZGl4UEeh431cU=;
        b=QQ5sklo+tWbxqEAVTjyr54LWggb9MONFhKuyIjZ/Dsu4t1kpnZv6vBJ7W0XcZP7cOF
         X5xDx51nM8IQcsJAVZ+cOplIj4ZuS29o5hSSwTZ/nXfyXCNRFb/zWtjHieS6OTLH6kDn
         B6ObjWQgyzRosxzlTA+c58GCST1I1Lxy4/3050Bi5mJb8+r0NlVMeJFuFDtwHt4N+K3G
         /+uHVjC7w0GDH5NEIHAsdmrA+TKuIBlwARIYPCTsVnm3GvhfAIvaTtpya4ZOHaboTVC+
         HsPUQD6e99ZayrmTGX46SLiOyveWU7LUtZUi/17usgBNmrvSV+sKPfryF8stAWNtkJUM
         K/0A==
X-Gm-Message-State: AOAM530vJxWY7hdf5daigL/hj+N9gxt3yBDa/nVLZDmO1R405rs/Lj/i
        IJPH5XiWVuJWqnrIKk7ms8tL2qRxKB+sDo9w
X-Google-Smtp-Source: ABdhPJxIWJhHum+jAgMMJAb5jKpUBzhFTmpVFoJzX3tyoiY7z63wOlsHDp9NX8kLw/HQvJ3ouWQVPw==
X-Received: by 2002:a9d:2de1:: with SMTP id g88mr4022908otb.84.1628782912735;
        Thu, 12 Aug 2021 08:41:52 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w16sm690973oih.19.2021.08.12.08.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:41:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] bio: optimize initialization of a bio
Date:   Thu, 12 Aug 2021 09:41:44 -0600
Message-Id: <20210812154149.1061502-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210812154149.1061502-1-axboe@kernel.dk>
References: <20210812154149.1061502-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The memset() used is measurably slower in targeted benchmarks, wasting
about 1% of the total runtime, or 50% of the (later) hot path cached
bio alloc. Get rid of it and fill in the bio manually.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/bio.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 1fab762e079b..9bf98b877aba 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -246,7 +246,34 @@ static void bio_free(struct bio *bio)
 void bio_init(struct bio *bio, struct bio_vec *table,
 	      unsigned short max_vecs)
 {
-	memset(bio, 0, sizeof(*bio));
+	bio->bi_next = NULL;
+	bio->bi_bdev = NULL;
+	bio->bi_opf = 0;
+	bio->bi_flags = 0;
+	bio->bi_ioprio = 0;
+	bio->bi_write_hint = 0;
+	bio->bi_status = 0;
+	bio->bi_iter.bi_sector = 0;
+	bio->bi_iter.bi_size = 0;
+	bio->bi_iter.bi_idx = 0;
+	bio->bi_iter.bi_bvec_done = 0;
+	bio->bi_end_io = NULL;
+	bio->bi_private = NULL;
+#ifdef CONFIG_BLK_CGROUP
+	bio->bi_blkg = NULL;
+	bio->bi_issue.value = 0;
+#ifdef CONFIG_BLK_CGROUP_IOCOST
+	bio->bi_iocost_cost = 0;
+#endif
+#endif
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	bio->bi_crypt_context = NULL;
+#endif
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+	bio->bi_integrity = NULL;
+#endif
+	bio->bi_vcnt = 0;
+
 	atomic_set(&bio->__bi_remaining, 1);
 	atomic_set(&bio->__bi_cnt, 1);
 
-- 
2.32.0

