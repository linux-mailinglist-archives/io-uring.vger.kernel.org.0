Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECF41DF07C
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 22:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbgEVUXY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 16:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731046AbgEVUXW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 16:23:22 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C4BC061A0E
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:21 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d3so4835381pln.1
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TvoN8a3WZmoogVlnFEo2G3/jPQNtfJ5pQXb6VgaLeNI=;
        b=BXbHdLw2u7+4v2OrPmYOPKCximguO5jiRJZaHaFHSVsvSvWUEzYysWoLSxdtoQAhVk
         HQyzWIFFRo/mFUpenrzA6F5+44ecTT/9T8gl76XCfW+c2eXcPrv0LOIa2RbwWHAjv/HG
         LlwUH90hb2MejF0kbDvRktH/1MKI00SlTe1zoChJciTQecxjsyBVAaG5NbzlfHNdSLJo
         YxLoC+8l2OyrR2oOB0j03phI7j7zHKNXpqoNl19DH0baMd93TstNiHmfuTzQF3eeeuAS
         2STt80Zor0RzeZK9zZbUp4rN1b+ryCJn37SAdistDxGmOl4mfgIIJQWGyWWE7PTGyUWw
         nDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TvoN8a3WZmoogVlnFEo2G3/jPQNtfJ5pQXb6VgaLeNI=;
        b=dBh4uSD/pANrhWpYg66m3l2+oMDyvS4LdNQX1VWJYdGMnskyhxnQyz1yQxLE0SEBOM
         J5YC1SNlylBiS7VLj0UwsNZlbdHuaEnpEg6xi+J5V5uF+UbMvHSSN0MAjp2Oxhce/vXI
         XnRUcuYYPXPVmFVIIwCTKlxZhaF8JyreCrwvEJALp/weAXS/QvGy9ZT7cHGypgkxcbTI
         ra67JjKZXtNHiq+H8b9yIPoR5U6Kt3BLkOcMlqOmBfvjeM/40ahEoPWvtHv98YTiOlMu
         RUsytd2g7NRpmnUt5HdjzWPVpitmXB1U9dPTc5y5ZfXDCmIaDMtYH6fyYGR0Wvmqu8kG
         iSzw==
X-Gm-Message-State: AOAM530oMe277Che0NkUqGdrS8ZBV9vFd9MEbZ1Mu28kvlGVl+5zWkNR
        6hSHuA57PQBDJ68EoLxRLkoICZlE0wo=
X-Google-Smtp-Source: ABdhPJyVyvEl6dSL6IOBsJmpnycz4H0kN8LpN+dJacQOGflvQ6nocjSVsWNNdSmRA8eHxZtEk7xEXQ==
X-Received: by 2002:a17:90a:6881:: with SMTP id a1mr6499268pjd.153.1590179000778;
        Fri, 22 May 2020 13:23:20 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id e19sm7295561pfn.17.2020.05.22.13.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 13:23:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/11] mm: allow read-ahead with IOCB_NOWAIT set
Date:   Fri, 22 May 2020 14:23:02 -0600
Message-Id: <20200522202311.10959-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522202311.10959-1-axboe@kernel.dk>
References: <20200522202311.10959-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The read-ahead shouldn't block, so allow it to be done even if
IOCB_NOWAIT is set in the kiocb.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 mm/filemap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 23a051a7ef0f..80747f1377d5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2031,8 +2031,6 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 
 		page = find_get_page(mapping, index);
 		if (!page) {
-			if (iocb->ki_flags & IOCB_NOWAIT)
-				goto would_block;
 			page_cache_sync_readahead(mapping,
 					ra, filp,
 					index, last_index - index);
-- 
2.26.2

