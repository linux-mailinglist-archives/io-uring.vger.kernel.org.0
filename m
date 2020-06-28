Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333C920C754
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgF1Jy2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1Jy1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:27 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CBDC061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:27 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id z17so10191291edr.9
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=G7Z2ehbO8oEEnrv6PhhTCF+FaQnavb4knwBpN7TjVYI=;
        b=DjtzQehn/3Dpc7dsBWEnGrDckUONLzPjKQtVlraUBYWEQEindB5coopOiobNiKlyXU
         oyiYsWBe1DA2bqQREO4QbPxuMG/sRgcjWqG9LlHQSAqpnedtL1Zj7EjrN5M3pHbsk3/2
         2323EeYrllb0gMuWO2eaBTArmIlU7BPjdJ+sTfnf0G+3zOwqwUyPrgNWikc+cM/B1S/w
         6CA4Fvywpo3RHBjKZpT5SAargl850n5JX2RGXc21w3y2rIl7dgLodwYy4ksiQmOJVQba
         6y1ljjG+1DZqwL2yHrL+OX75u6N2yCWRHypJOIj1biXv5ev+22Z1Gf6uwSwn0O4VBzId
         R4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G7Z2ehbO8oEEnrv6PhhTCF+FaQnavb4knwBpN7TjVYI=;
        b=W8MjZ4jXuGQ04yLOTxF14JkEQeZ1H3RBctxxX5NZsezeu7zaBws35e/u35o3IH5FlC
         RtOUcPQiXMlBWt4o5GwymC5lqYIPLce1mizyGixjW2M+WiCtan+KxfOwOro1zsSoZ6rh
         Cj0vWUw/AZcKbTAlyD7IiEd7WWoSHMAk337BfzJCOdtqgrh/H4B6XWHyEsUO4DzQrSzr
         9FVu6ifkI2vHdUc8WN/vKPA1xzKQprrOIe4CIfAsPVlF3uOqWUDqOiPtdXUk9LcOII9+
         AJh6fZkisIniaxhRhgZcyhf4GvzfpFsLb0bgFj1BzXlotaotsV1If5Em5tP0j6bN0PM1
         WZkQ==
X-Gm-Message-State: AOAM533ToDrljTFUNiWVgaJR3koxXYqMkYfnKKO8hu4hQCsIRX6YkVD3
        mL79GhUg6A0BD3xR4Ie2EMPVE7Nv
X-Google-Smtp-Source: ABdhPJzT4xaZG7jAfhqnoWh2BUwnVRpRp3Ec03mIdc1TsT0+wnCCneKyvtg6tGBzhqCVRjNME39PAQ==
X-Received: by 2002:a05:6402:1558:: with SMTP id p24mr11781721edx.193.1593338066034;
        Sun, 28 Jun 2020 02:54:26 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/10] io_uring: fix missing wake_up io_rw_reissue()
Date:   Sun, 28 Jun 2020 12:52:36 +0300
Message-Id: <6a4a9caabaf6b74de7cd852d263c9eb284cd014b.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
References: <cover.1593337097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't forget to wake up a process to which io_rw_reissue() added
task_work.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5e0196393c4f..79d5680219d1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2172,6 +2172,7 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 	ret = task_work_add(tsk, &req->task_work, true);
 	if (!ret)
 		return true;
+	wake_up_process(tsk);
 #endif
 	return false;
 }
-- 
2.24.0

