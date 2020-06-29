Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA81520E1E1
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 23:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388290AbgF2VAd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 17:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731219AbgF2TM7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:12:59 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2193FC008647
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:01:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k6so15914591wrn.3
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jYiqsBcTaPhVIZel9cCd93c5KGa6W2zWMrFlxTxb1Ko=;
        b=ujRRSFLhgHpSIRo0h6DaHLFsH8hnQq9keSRstfucMwl1wKciJ2ClBkbqP+6aEZJs/y
         GOIiGdcnFfuAuhLVySFNfpquf6FTdutRCn+PNBkU+2CGN6ZwpVSqx9i/SRs6A1/pqeFB
         ViwWWD4Pi9UNK9p/75bcrZIzBadhftgdCH2X2RdtsOJbc7PNtfPULWGFLN+Gej/nbo7o
         SB6PoMIbhB0n6y1O5RwRT5ZHuJtnUHl0o73oJ8yOvnSX1gx7Nn5rafDGvxrOJ4KfIioS
         EY6AE3QMrl0ZbXQI28NAI7xZcYAAsmjHN1HvBpx3/q50eEbL34M0ZtCPBruEeWPADuff
         h2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jYiqsBcTaPhVIZel9cCd93c5KGa6W2zWMrFlxTxb1Ko=;
        b=FsPRGwJOgFIx0sLv6vZ1od0rAypQn9JAYQQs2sTRD5gO4IsqxY0jiP1USymjfS7/OY
         YufPQo364O7YuGCSAjRanRz1YXxY7SvA9lqby7vcbRlYXlIxObwq5mMY2srYoTEPNNr7
         Tr6hiDgSn7VpzBuKwckOCPb5oy2rI6yuWLJshTmdnnkPMNqdxq50dY368sqQLKc9x3nr
         pRrfws1NYGc5jihyibXjEupZA21HAUtAUC8sK7FKRcR942CLGrQvk05GR2naHXOYyXRg
         URMlnILZwn2cVzRg/HXtwNVaKZW/4L6nCHanm5wTorqyE4FVtUtBUPw4Ri7Ul/cgmCs6
         4Xqw==
X-Gm-Message-State: AOAM532BnL4jCTHIVDvVhMOD3CGhRsTDBni4Sp17CI8sI5HEx2iPtv6h
        zaTtQu3isMcdBcbXX8BHTieLNjyy
X-Google-Smtp-Source: ABdhPJwKuKBVcpZHKA6nYsh5KaSLNRrDgsFs2I3YiiHI+kJEm/ZMdMPahR+zENUQ4quMcHJMFgBWcg==
X-Received: by 2002:adf:8501:: with SMTP id 1mr17876467wrh.153.1593424891674;
        Mon, 29 Jun 2020 03:01:31 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id n5sm24054855wmi.34.2020.06.29.03.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 03:01:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2] io_uring: fix missing wake_up io_rw_reissue()
Date:   Mon, 29 Jun 2020 12:59:48 +0300
Message-Id: <b455c5ffdc7398eb61460669c4a19301320258f6.1593424638.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
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

v2: wake on success path not fail (Jens)

 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3bbadc3247b4..6710097564de 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2168,8 +2168,10 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 	tsk = req->task;
 	init_task_work(&req->task_work, io_rw_resubmit);
 	ret = task_work_add(tsk, &req->task_work, true);
-	if (!ret)
+	if (!ret) {
+		wake_up_process(tsk);
 		return true;
+	}
 #endif
 	return false;
 }
-- 
2.24.0

