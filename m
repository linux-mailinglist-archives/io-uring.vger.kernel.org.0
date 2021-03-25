Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FB4349996
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 19:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhCYShA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhCYSg5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 14:36:57 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CD0C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:36:57 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j18so3324829wra.2
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yVZ9YPcWYbzndmp3jHoqC1lWCogMH94rRPe7wXv70vs=;
        b=VLMWm8/yA9VmPV6Y5vTMhcUcUlFtHj5TqI8j56OXwFa2THcH6Fsxi80NEWS+MHpGrZ
         /me61mN4NkjS9zBZc4/VrGyHrSU8jthjIt65+/Tj6R2yyEHcBWOeWog/QzKw1U7uvsgF
         m74dEkK2rS0thk6W63p5h0FPzs+prULPjAiMKbkFnVpwWfBw+bw2tizS+7mpnZZS1d8N
         rIO3unFT1BBPWfMhGf9g5FhQSkP8sSBa4AiEDAbbh/Ml+rmakInR/0xubRON72b4lroH
         RSncxwojjZzYu4V/F9+jw4WIRGB2ihZdJBf1s5vjtBXTFhx7GmJaIdY6PDmLewZEQxyj
         pYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yVZ9YPcWYbzndmp3jHoqC1lWCogMH94rRPe7wXv70vs=;
        b=mK503dkr1VYyRK6druZNEksxtbsndDuuDDyblPrlyHqjxNK4j+2sgq7EAUwrE5RoyW
         EwQwGgvRQ8I5qFCFL0qBsMHrSglSNIi6fXfC9pJ+wjUUUGOO9exObk9eJPBAUHpiwTPt
         lWSAgysGERcOlCaUN81Za/6vUhF/rXiArrsRXqYfhHyjwYU2bGeM085Q+VxYbOtyzxoZ
         MchDaiY37zzm3vqCzDwJCmoVMh98isV7cDQqRaOY++WtJU/qtgscntmgCSkWegPyBFjw
         cHEbFdrHkPE4WpP0syERvQzgWzOFTHfOUFl62ZBarM3179Qxh7Psdg/+pzcVYKMh/zJ/
         s0Pw==
X-Gm-Message-State: AOAM533rCznp9krhYrSXgImVslyIQonxn9ypSVDcZ5AjMshMIWwoLJ5W
        fseEmgBV8j/U8USxHwmTjR99Sp9h+zYkpw==
X-Google-Smtp-Source: ABdhPJz26kLF7/N/aKNXmm70LUI7BtHjG38cbBua1698JuVpUcjlgk1+8sPrKjiGzzGbRt4T9xuVsA==
X-Received: by 2002:adf:eec9:: with SMTP id a9mr10515770wrp.252.1616697416243;
        Thu, 25 Mar 2021 11:36:56 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id p27sm7876828wmi.12.2021.03.25.11.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:36:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: don't cancel extra on files match
Date:   Thu, 25 Mar 2021 18:32:45 +0000
Message-Id: <0566c1de9b9dd417f5de345c817ca953580e0e2e.1616696997.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616696997.git.asml.silence@gmail.com>
References: <cover.1616696997.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As tasks always wait and kill their io-wq on exec/exit, files are of no
more concern to us, so we don't need to specifically cancel them by hand
in those cases. Moreover we should not, because io_match_task() looks at
req->task->files now, which is always true and so leads to extra
cancellations, that wasn't a case before per-task io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fabaf49fefa3..f8df982017fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1095,8 +1095,6 @@ static bool io_match_task(struct io_kiocb *head,
 	io_for_each_link(req, head) {
 		if (req->flags & REQ_F_INFLIGHT)
 			return true;
-		if (req->task->files == files)
-			return true;
 	}
 	return false;
 }
-- 
2.24.0

