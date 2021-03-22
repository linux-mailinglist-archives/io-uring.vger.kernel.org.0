Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04865343679
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhCVCDQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhCVCCp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:45 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94055C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:44 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j18so15011874wra.2
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3RwD8YETc1smZeKZNC6FG4o/MT3oJk5Dn15un9qg1zE=;
        b=OyZ05B9RggcpTcUxtmVyyspg74X4S1qF3ChW4Pg1kwZgNXa1uVMK286WuDfcLHeM1W
         nUCM4RVgnlntL72K9E4RGdXmNLD4FaUQTEfqB3jFASCFS6AiTDxQ/Y9trl3yPf7HDoph
         K7VFwpxkKfH232MfuEeuzOqYwkJipVGo+YkT/nBm/C+A4+m7UpdbnFjcM42pjgxjWaSF
         h0BoIGawu+sYf7QfI56aJzhgY45Pw6FIFeTDTGmfi/7bDvwpWm1O2u+cXDKsigWA0u0F
         szyr5qfUjVrgtpAVNK9pGO2Vt4aWEZrLRVcLutDTmqoicOH9BJiRqH09L+OGxEiFxsdg
         mIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3RwD8YETc1smZeKZNC6FG4o/MT3oJk5Dn15un9qg1zE=;
        b=h4OPDUl1R1DgYD5iFwM5jJ2fTL8UOsRYYcI4w+ZhGZEzn969U9EkNHkXVC5GVDA8yy
         1BzvkDWx2nropLbTGHcgJX1msA48xibqZMGiXyzlBuys9t7ZsbqXOK+V2ScXW/JuPoZh
         uQ7rn5rvzFZK7MlZrjOY4dEdH0PyBRnHTDqjc73LQCM1XN2hjHYzVhZmYQ4GO2cn6Foz
         TtArC+NiUSGeEfMr4mpMKpWjzQsykvxrOykSo905++6P4Vq0bPa/mQPMRfvpaN2uF6bR
         jsipMaD2rzTHcuPolYR++ZdG3d7as023btOLcb0ihHrKHJeecvZxrEdUaTvm5MaJEY1u
         d9GQ==
X-Gm-Message-State: AOAM531rjDyNCVKA5NVMaTtEdNOUpbq+HE2Qjahm64qTiQvicU3VLUu8
        yODpSSlirakzM5C5PSl1Jb9KHHyJReoV2Q==
X-Google-Smtp-Source: ABdhPJxIkP3Gj7HoZ1d08gcns1OfjD/TrikK7PAuByE2CUsIb88Vdi2xz0MYcxMmAX8bB7iCqUDQLQ==
X-Received: by 2002:a5d:5487:: with SMTP id h7mr16059611wrv.348.1616378563367;
        Sun, 21 Mar 2021 19:02:43 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/11] io_uring: don't clear REQ_F_LINK_TIMEOUT
Date:   Mon, 22 Mar 2021 01:58:24 +0000
Message-Id: <4b31a0e4bc06400c79402cd22be3218d5535036f.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

REQ_F_LINK_TIMEOUT is a hint that to look for linked timeouts to cancel,
we're leaving it even when it's already fired. Hence don't care to clear
it in io_kill_linked_timeout(), it's safe and is called only once.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 67a463f1ccdb..5cba23347092 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1786,7 +1786,6 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
 	struct io_kiocb *link = req->link;
-	bool cancelled = false;
 
 	/*
 	 * Can happen if a linked timeout fired and link had been like
@@ -1802,11 +1801,10 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		if (ret != -1) {
 			io_cqring_fill_event(link, -ECANCELED);
 			io_put_req_deferred(link, 1);
-			cancelled = true;
+			return true;
 		}
 	}
-	req->flags &= ~REQ_F_LINK_TIMEOUT;
-	return cancelled;
+	return false;
 }
 
 static void io_fail_links(struct io_kiocb *req)
-- 
2.24.0

