Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F128E3FF420
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 21:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347238AbhIBT00 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 15:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347257AbhIBT00 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 15:26:26 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D309C061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 12:25:27 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id u7so2951408ilk.7
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 12:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A/RIpE3O3urWkW2hCRdUQJt6fEFKkjFwd8lupy+qfvo=;
        b=W50lHFrP11kudL9vwLGlNnvLlVM46L83QN1qRmF2DkRT5gJPMbX/3kTxjLOC12RMB/
         uvZ+8TczzbepXUdFvN80h3ytimXJKn4OFEjcP830PDr8pzLzaeDfe3H7TzmDeSGdx2g/
         UEgcsPg+cLTRa7IJ3xuxYOtJJll7kCUqGOt/Z1TK7UrCFoPFo178nXd5hXERxzsaIHKn
         wbEtHk26wImNHHB2idrbezKz8wl6w86OU4zIZvAqGB/VQrXnzvTXTltPO6ljNRmcNx5t
         VHSeJ4GbVpYN9VmelH1hPDGpX5yTSGlaIHCWOBeVkaY13rjuOJ5MH2asoRSkkd5ha7z4
         hynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A/RIpE3O3urWkW2hCRdUQJt6fEFKkjFwd8lupy+qfvo=;
        b=ANhMMstZ9KJWdvsosJh5OAs7WeOtk6+wa2jLGygYahJ3Akph2cpUwzbPJ+v+6bf5wJ
         tUnS+y74jM/VAGczsuVwTN4obZkreYMVsBfOYcVd25gxKMVsNR2BuNFSK6mtF1YTKKvo
         B6bVHhZTaD2yXrxzkAbxOvcdLcE5p1w66cWJm57JjVJ7RtW1tDVe73J3xdayreeJ6gmi
         /tJqPYoKlR4+IAIshS5gVTxDEBI/qCgy6LvCpJ8QZ0yuZKu1WwP/s5d8kdV9C9kiLy6A
         nKx6ZGGcmYC+NmVN24SDQuh8Ool0kc9iLgxbGkHn5WMRR60NLMmZZneA7nyoTbjTk539
         jYmA==
X-Gm-Message-State: AOAM533zKt1e/M2Unvh2lmSxiT26Sw7UJ+dwiKIgbwZGrHtXSLcznmWL
        fnDxjyaJYk1HfOk0Kfj44SZ5fPVxXpd/sw==
X-Google-Smtp-Source: ABdhPJxpcRpb9UOSoRly264iFLNO+/MDqmhFMa3pzD6bw8/sKHo/jokFEB9/HSqZuaOJLp/4yMdQiQ==
X-Received: by 2002:a05:6e02:12a3:: with SMTP id f3mr3384325ilr.46.1630610726766;
        Thu, 02 Sep 2021 12:25:26 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g12sm1399406iok.32.2021.09.02.12.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:25:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io-wq: only exit on fatal signals
Date:   Thu,  2 Sep 2021 13:25:18 -0600
Message-Id: <20210902192520.326283-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210902192520.326283-1-axboe@kernel.dk>
References: <20210902192520.326283-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the application uses io_uring and also relies heavily on signals
for communication, that can cause io-wq workers to spuriously exit
just because the parent has a signal pending. Just ignore signals
unless they are fatal.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8cba77a937a1..027eb4e13e3b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -575,7 +575,9 @@ static int io_wqe_worker(void *data)
 
 			if (!get_signal(&ksig))
 				continue;
-			break;
+			if (fatal_signal_pending(current))
+				break;
+			continue;
 		}
 		if (ret)
 			continue;
-- 
2.33.0

