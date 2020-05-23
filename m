Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35CF1DFA85
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 20:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387543AbgEWS6y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 14:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387536AbgEWS6E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 14:58:04 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0063DC08C5C1
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:02 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so5757536plt.5
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TvoN8a3WZmoogVlnFEo2G3/jPQNtfJ5pQXb6VgaLeNI=;
        b=dlRhMk444r2/QEHuAZ++S1wyLJ84KnLxTEI64EuE4dN1pFxVgN8A9K0quOu7H4b4Kq
         sjwJUAUsTLCVCGcV3VQIysTW9HiVCJ7sH5euxBGtqJm15I6wEKH3mue/IQD6jbfOMSi7
         Ee6mlXKJeIhli6gCf6YjVyTShL+/w3Hnk2eTqSuVF+zoDvF1MfrGYqyMRFeDjw07L0cs
         Mpg8k135t1sCC7y9Xv6B4U4O7cl9wdgoiTFK8GtgUeb7Kc22w5q0VzvT/2c8RzsYEwH1
         Cn02kuIXs3ldFHF8OFsS7U3UbM4AjfKkDhyZ7OjtrO7ogq6UpJoIBqUQAGUK22qWlIRj
         o4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TvoN8a3WZmoogVlnFEo2G3/jPQNtfJ5pQXb6VgaLeNI=;
        b=d7IY+RD+fFwRdVN9nPHB8YP6waRdlqah1aSpUu70ri/Jx+I+nN8ja4cy0DLzI4U28I
         qALpLeZ89r17MhQ2htoVSpfh8epdza6XEOUWAKMX93HogcR9+0JeZGVsIGUejB5LTsMw
         VPYKT4HSyuYimYGHTpkD5FZipdCC8q+WhoGM0o592j2yYt2IL2y3UOsgO1KEKii2yWDq
         UVYh8UsEPaNtIOnK9HEVLrXioHTlJyAL4G57fVAwxVypBZLgJUE04RDd6QmFzkQDm/IE
         zewGS9RRxLp3OnSKI5bWPz//mMYCgi26kdlgW32c7d53r8fOJgl4oreR0cioEHGdSokT
         jqtg==
X-Gm-Message-State: AOAM532+99iTEUgPsp9ruCIrhsfDGYqUw2xLBJyjwKSimhvxgXTuDEa5
        OvAJ5AEznFuO6yEbDmfA4yLmthXVHBgjVA==
X-Google-Smtp-Source: ABdhPJx4dsrrORWefyOaJaBwml4HUm2oobE0QtXJHHyZSr21A+y8BNmhuTv3ioELhwbbDTv2OiGRNA==
X-Received: by 2002:a17:902:db82:: with SMTP id m2mr21720441pld.14.1590260282249;
        Sat, 23 May 2020 11:58:02 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c94:a67a:9209:cf5f])
        by smtp.gmail.com with ESMTPSA id 25sm9297319pjk.50.2020.05.23.11.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 11:58:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/12] mm: allow read-ahead with IOCB_NOWAIT set
Date:   Sat, 23 May 2020 12:57:45 -0600
Message-Id: <20200523185755.8494-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523185755.8494-1-axboe@kernel.dk>
References: <20200523185755.8494-1-axboe@kernel.dk>
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

