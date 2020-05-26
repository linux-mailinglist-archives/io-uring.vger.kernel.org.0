Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C071E2F54
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390170AbgEZTva (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390039AbgEZTv3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:51:29 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A65C03E96F
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:29 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x11so8123577plv.9
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TvoN8a3WZmoogVlnFEo2G3/jPQNtfJ5pQXb6VgaLeNI=;
        b=EEzkohF3SUyIeVc607D1E79iz7OYkD/uy0I4GSnchfP+t2/8/jBtqFox0ipMXW7gmS
         ofFyzP3GFe0yYbASDLZaxrNNYrAZioS6+qyZzi3BNWoxV7sx7HqmGaPk0jbEdJvgnKeB
         LS9UwziDdS5h+5MFwXcOepQDNcjfOPRuuNqKL+56cp6TcQw3V1rzfELuJiMDiQxFYBUv
         vodgm8HTVNcfKt1cQ9mCuLi6iS5R/Q8g3QwtsGY6bO7P1eejUGE4Bg2SUpBDQd14zfM1
         K3pATJ3oH3ooIkQY7kB2SG6VI0b8+IfGy1HVnsFn7Li+LHrtGMCLBa+H3phkx45yiFvC
         NeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TvoN8a3WZmoogVlnFEo2G3/jPQNtfJ5pQXb6VgaLeNI=;
        b=LHz42H2Pn7Zm/cQVKZ1ew3gJIgNrRRzTN/XD199pOpOkGfaCJNtZjbPPJDTqC8Z1+2
         gLVIWuetGFzfqw42bUNdU5mHqKveBwodFm3jcVZxyliqKJ9knLlUmvO4zxFeLxYpo5Fg
         mSy8GKlWVZusJYaMlg2idnJ/WfP0dqQJkrLQrkZ35cE/AVWZf3NYbJ5gJE8kLmdoh02m
         MDEBgkPSJtzwyi6CAiTNVUd7L1wa/SCmv7mn/1Zdxa0BxZN9Wwkg18io7qqJ7TFSDeZF
         zoUk0hbhYeO0De5J3R3FQEtfJsGcqaJ87f6Cf7x3iO/wiSg2QqfL3ouf9mT0wm55b83c
         URcg==
X-Gm-Message-State: AOAM533VkEBtugtfdI5nfgUHqq13R+ZvoEB4XGORHN1aoVZN+myanmQB
        jUTTO0btyOcMUCIgM4fW9hOrBN3pBeilrw==
X-Google-Smtp-Source: ABdhPJzlKhcLATAMmx3CWvH61LMiVxHHoRlGG4C3q4JS7w38d9LDkh0jn/mRK3Wz+nSKoQ/Hn6XBsQ==
X-Received: by 2002:a17:90a:1b25:: with SMTP id q34mr920742pjq.12.1590522688801;
        Tue, 26 May 2020 12:51:28 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id c184sm313943pfc.57.2020.05.26.12.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 12:51:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/12] mm: allow read-ahead with IOCB_NOWAIT set
Date:   Tue, 26 May 2020 13:51:13 -0600
Message-Id: <20200526195123.29053-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526195123.29053-1-axboe@kernel.dk>
References: <20200526195123.29053-1-axboe@kernel.dk>
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

