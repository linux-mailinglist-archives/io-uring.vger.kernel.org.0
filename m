Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FE635198C
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhDARyF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbhDARs7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:48:59 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6AEC0045FA
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:27 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o16so2130108wrn.0
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UhsWuqfw4VDtKKO8jzSawtu49M/qoG+jQwiny1gupm0=;
        b=ncOX/bjgWa/XJLlS2loI+MnDQ0VTJd6ls58ODa7dOWL9lyE77RmPWekNsacx3fnMJv
         wkY86XxNWIljsMs3fiR2/k/mFpIpF8ESiqO23HAFcH82JeXY4XO4AB9EM4S0I25+NdbG
         yCmhW/TGTop4SYgGfcrJJWGm37icp4z2ZDcwXKwLPPDcJbPLILnIteAqU4E30TCIa6xF
         4Vky3HM7+yiLGZXwEnDRvaXKJmhjUwczCRETFvylWn5ifEUHUWN0fIuwSRK+FIYGXoAA
         iKw8vJftdV1R5/pYNHcxD4oiflhJHnsDO/Q5J8rbWFP8CnB+umB/R7QRCMzFyRajM97m
         7ubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UhsWuqfw4VDtKKO8jzSawtu49M/qoG+jQwiny1gupm0=;
        b=NM3iYygMLH1G+yFf0KNr8aPJ6dp0DhL9tGLUKCiAfM9ZLH71w/1qEaGVLqZta6Rpbq
         +ezbpf8JCSkvLKc9ByMDp+RWlo4wFDn11MM0cDB3zB6Zm057ysQh9kt09XbJ/oIj6A92
         3FbvV7IGUaNAKlccvNaxUusR1sQPyEpRQp+jPmQdz2wN2qLLy23++mp0ConfrlaliKxD
         IFO+WSb3t9yTMVH87s0pKGkM/hHIFbwFB6nw0AbpvJ5m+wyA7qpvvI694D0DOumRJWnD
         OnWHxWBm3dqRTwD/Deo8o+nrOLoycdm84I4I2U3aXbs0l1joUGeopXLtSUywTYlora/5
         T+JA==
X-Gm-Message-State: AOAM5304LKM1czzYyDdkvj/49J3J3nXhW83cCh/RLXSDM9KEpq98A23a
        YjUiyc3B1XXp2kjvm4inr5A=
X-Google-Smtp-Source: ABdhPJwfgU1RGoYArVRoLx8H5Sl9zpuqavG8dFAPI2SbHmHaxdZIwpdsJhYR28kBV2tGfURE2rSRIg==
X-Received: by 2002:adf:d851:: with SMTP id k17mr10368054wrl.254.1617288506159;
        Thu, 01 Apr 2021 07:48:26 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 09/26] io_uring: remove useless is_dying check on quiesce
Date:   Thu,  1 Apr 2021 15:43:48 +0100
Message-Id: <bf97055e1748ee3a382e66daf384a469eb90b931.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

rsrc_data refs should always be valid for potential submitters,
io_rsrc_ref_quiesce() restores it before unlocking, so
percpu_ref_is_dying() check in io_sqe_files_unregister() does nothing
and misleading. Concurrent quiesce is prevented with
struct io_rsrc_data::quiesce.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 17e7bed2e945..e8d95feed75f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7117,6 +7117,7 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 {
 	int ret;
 
+	/* As we may drop ->uring_lock, other task may have started quiesce */
 	if (data->quiesce)
 		return -ENXIO;
 
@@ -7179,12 +7180,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	unsigned nr_tables, i;
 	int ret;
 
-	/*
-	 * percpu_ref_is_dying() is to stop parallel files unregister
-	 * Since we possibly drop uring lock later in this function to
-	 * run task work.
-	 */
-	if (!data || percpu_ref_is_dying(&data->refs))
+	if (!data)
 		return -ENXIO;
 	ret = io_rsrc_ref_quiesce(data, ctx);
 	if (ret)
-- 
2.24.0

