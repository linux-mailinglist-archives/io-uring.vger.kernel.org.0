Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0D83A5B66
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhFNBkH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:40:07 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:36588 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbhFNBkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:40:06 -0400
Received: by mail-wr1-f44.google.com with SMTP id n7so6462367wri.3
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ztRJARExWokzTuJETAZmQkm5xNoyJYYYWZzOL9dLec0=;
        b=B1KAQ7F9liGnPxjkk212m5cPPaLQ7/bFBxnkeoM39x2x66qRYoT8Yhqc7jG0/6x8Xu
         F+EpfL8ivrHioAIKcfm3CzcLXfEO0J5lQizXL9Gc3vZ4pk/RfzNmL4tXx1eXo/df/Z5e
         JcUlzZ5OW19MlU76g06kK/lL463bDGQBiAbzau6jdg2L24lrcSI/HxQ/I3eAd9W0CmBE
         MZxD7lw6ZQk/7WUMHDWRhJNxFyRFJfvIvrVGsLsQwviEdr8MLlBEXcpFAMOvUKGMMVsK
         Y5DItPRY98FJQlQwzlu3X+x5G8+YeAgC2uK1TdS4gZBtNN1rLhB/XqKL9SYFLdl8qnzA
         1/Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ztRJARExWokzTuJETAZmQkm5xNoyJYYYWZzOL9dLec0=;
        b=ihJKeQNScoMbzOIsu9XhF0YEhzgt2LV3g32OZZ3QtneK2WmSXQoX9fEuIs13DRZTIS
         NmoCSeOsHzvf3R3+/TSaWmRTdP6Yf6m8NJ/hAPJUXKzixjIBMobujlLwNGXfsR3W4cMV
         ZYYyC9u+zXiV4HrvTWM9XAehoMbZq26oc5TegQEzVZR3qo5mTOofObbo7bSdGzEiqzx0
         wPru3ddxx7TPCS0YYAQtHLpFteSJqfj0JTEfFUGBeXnKtXyHZ9st5UbfAA5Sjyz0XJWB
         48sWirmVhyabUZ5YgtOH8yWifNVDU4TJWwFPI1tefgAFYncL1BZACrIYYhwjH2qlsSd1
         Ymfw==
X-Gm-Message-State: AOAM530E896xhMPOU0wF2XW5o3I/HVIYntdiOtvm1RUXa9rofVwcmxC4
        9bhmQe3D7jKC7wQghK83gwE=
X-Google-Smtp-Source: ABdhPJxT6KyV6wpNFF2+524q3lwcxCqyhIcQoTVnOtO9XfAjoi+3W1bA+jhvkCmILkFIrEkYEF8cXA==
X-Received: by 2002:a5d:4e12:: with SMTP id p18mr14766021wrt.105.1623634608904;
        Sun, 13 Jun 2021 18:36:48 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/13] io-wq: don't repeat IO_WQ_BIT_EXIT check by worker
Date:   Mon, 14 Jun 2021 02:36:16 +0100
Message-Id: <d6af4a51c86523a527fb5417c9fbc775c4b26497.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_wqe_worker()'s main loop does check IO_WQ_BIT_EXIT flag, so no need
for a second test_bit at the end as it will immediately jump to the
first check afterwards.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index f058ea0bcae8..8c13e23d4a8a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -559,8 +559,7 @@ static int io_wqe_worker(void *data)
 		if (ret)
 			continue;
 		/* timed out, exit unless we're the fixed worker */
-		if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
-		    !(worker->flags & IO_WORKER_F_FIXED))
+		if (!(worker->flags & IO_WORKER_F_FIXED))
 			break;
 	}
 
-- 
2.31.1

