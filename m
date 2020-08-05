Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA6823CECA
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 21:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgHETFL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Aug 2020 15:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728445AbgHETEa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Aug 2020 15:04:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D5CC0617A0
        for <io-uring@vger.kernel.org>; Wed,  5 Aug 2020 12:04:29 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mt12so5143507pjb.4
        for <io-uring@vger.kernel.org>; Wed, 05 Aug 2020 12:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cWBD0QiEpQVn0P/IDPHGnUYjfhi47k2QaaTMr3OG8s4=;
        b=yKAPq+33idFSZT8+JxNG3aZD1V9EAmAAGitlwQBadp/vUTOEjluu7Z4yKhojqBr1yW
         RwiZpgeYVLjmYGD57z2a/DgStOpujDAoB4MHSEozB5wZn/9bQhqbgyQyO6SUPEZJEz+3
         pzyrGZiieUdQGpxcyE74Ap1ltsr01KgKjIN8U60DDoMotXwi0D7dehGSrdZToVlSmu2T
         da8j2YBkRyJg3wykDbhiIL1HGtqhIYoDzmN3aoI1CrYCFkxXK4qq2E8iBhV710X/0Gz3
         fGgo3VxEBbN6gDMbg5ggb75HXD017JBjcYXHLzxoqi3YN17RJ4iPrSX1pEa6uAVeKAbf
         eq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cWBD0QiEpQVn0P/IDPHGnUYjfhi47k2QaaTMr3OG8s4=;
        b=BWkEUBkIY+s5V4HFbgrUZC2Kt8WZ60OKaiuQuQiR7zhc/uVzAYZoqZlY4UZoqmGBUh
         5ibzjh0fItjYPKwykNblOoSNhHnqdZyPHW2kEiGk9NRj/1mZULc5GEjNlKU3D06eRZt4
         HyZkmmIKstVWkHTWxlrrwniwkoKWjUFxrSKPzrDJVKHbVDNWkUByD6V64lfFLJX28azL
         K0mM8tYIvlnboWNAkHuVLj7uXfpi6ECBn/4xkRBd0MMNSwe3OLv4nvmy9Uosyp4Ky9jz
         YuixE8LyzMwi9LXlpiAWGRAlaPMKPyPvGB4VEXqSAhErQEDdgoUoccXfMW1Ol4DRjmGa
         apFQ==
X-Gm-Message-State: AOAM530u5rIvY1zXIGwVEyda487iconcE9VwHqpFyJpagftqpDn6w+vD
        HQXqIOQoIj3oegKosAUb+L7ODZMiqoc=
X-Google-Smtp-Source: ABdhPJw4g2A98zCLpO81jyKWhIqIC1hF/ruVb/ReHX4/dUYQhCoUmVUalHAK2BPy/MmRHSovwhcPLg==
X-Received: by 2002:a17:902:bd84:: with SMTP id q4mr4537741pls.29.1596654268805;
        Wed, 05 Aug 2020 12:04:28 -0700 (PDT)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b15sm4071881pgk.14.2020.08.05.12.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 12:04:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: set ctx sq/cq entry count earlier
Date:   Wed,  5 Aug 2020 13:02:23 -0600
Message-Id: <20200805190224.401962-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805190224.401962-1-axboe@kernel.dk>
References: <20200805190224.401962-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we hit an earlier error path in io_uring_create(), then we will have
accounted memory, but not set ctx->{sq,cq}_entries yet. Then when the
ring is torn down in error, we use those values to unaccount the memory.

Ensure we set the ctx entries before we're able to hit a potential error
path.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8f96566603f3..0d857f7ca507 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8193,6 +8193,10 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
 
+	/* make sure these are sane, as we already accounted them */
+	ctx->sq_entries = p->sq_entries;
+	ctx->cq_entries = p->cq_entries;
+
 	size = rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
 	if (size == SIZE_MAX)
 		return -EOVERFLOW;
@@ -8209,8 +8213,6 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	rings->cq_ring_entries = p->cq_entries;
 	ctx->sq_mask = rings->sq_ring_mask;
 	ctx->cq_mask = rings->cq_ring_mask;
-	ctx->sq_entries = rings->sq_ring_entries;
-	ctx->cq_entries = rings->cq_ring_entries;
 
 	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
 	if (size == SIZE_MAX) {
-- 
2.28.0

