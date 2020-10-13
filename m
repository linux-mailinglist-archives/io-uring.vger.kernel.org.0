Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083F228CA76
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 10:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403969AbgJMIq7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 04:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403952AbgJMIq6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 04:46:58 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967B0C0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:46:58 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h5so12904113wrv.7
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wvnDTQK6ZDofTL6LojkkivNmgT9SKG+cQgS4JqsmbDg=;
        b=IqsHms/Xvwv1T1NSfPb8EUGUzntAVvkf6tRZ9dizOenVGMeh+DNez92adnMXP6uMtI
         rjz8Jw4O9zveo5sx0ldp/uHItsfcgrygufNnFH67TylzpDyYUBaqA2poEGtSLkM9BdzJ
         D5Z0WuSxcg7y2D5dqElV5O6GXSw4MC03gmtHAUrq7ZUZwF5Yggwn7lO9NVU9wFpgmkBb
         uMfjvLPm0Hj2fELyimB/2v/UI/3p77cHzvdmRkca2SSGiWJRa+FTU5RDk5cjL1V5XMEL
         9fA2KTLYs2rau79/K7qYchIsMMnfwNNsMbXgYcNG0lDPnaUe/yuNcd5phxStvGnYCOOc
         vAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wvnDTQK6ZDofTL6LojkkivNmgT9SKG+cQgS4JqsmbDg=;
        b=Hon8jtfuv9goFzanAPnfoP4jQTgu7lGHSLtXsHtpNHjWg0ySsQPv+I/tdbplac7OJg
         Ux3NlR9ZQmyR26QpyvVZuRNL6Oee1Tct5MVjrGtzZnkJYzxe+cbdSuW466KXRkxv73/T
         PGgiyzn0dxuRNdzXbZ6s3YnAviscwzq6XbS5DPKOPfVhHvLTr8fhhFEVK7lsJ9OrW+Vl
         0Hlek+dlhSqIyDHsXb4LTSNECGzbV4p/3iQrjS6/9ZeE2O5AASjiEnKzEooS0Afa3jV7
         35mgd4LWSIq4d73SQl0xR4r3wdyHSIGIh+7e7DNDcaU4HWpU6aKXUt7VxbYXU6bFLf7n
         1Bhw==
X-Gm-Message-State: AOAM532wTXzqYRzS/aKLLtkbSNz4ljbnv3/P9U61G7/3fXE9o1eMjBDa
        m2oHdfp54+WQ4Bl61RKdsKg=
X-Google-Smtp-Source: ABdhPJw/EaFVR8gx9SaMb5QbB2BTY/VHMXl+1LEI3JpUzeKKTmw74Rnw0i3y8xU73F7boM+G+7jxQw==
X-Received: by 2002:a5d:4ac1:: with SMTP id y1mr25483861wrs.303.1602578817383;
        Tue, 13 Oct 2020 01:46:57 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id p67sm26445168wmp.11.2020.10.13.01.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 01:46:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: don't set COMP_LOCKED if won't put
Date:   Tue, 13 Oct 2020 09:43:56 +0100
Message-Id: <afbaf7d6b575eab0ddf76ad26e82feeeb46205c7.1602577875.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602577875.git.asml.silence@gmail.com>
References: <cover.1602577875.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_kill_linked_timeout() sets REQ_F_COMP_LOCKED for a linked timeout
even if it can't cancel it, e.g. it's already running. It not only races
with io_link_timeout_fn() for ->flags field, but also leaves the flag
set and so io_link_timeout_fn() may find it and decide that it holds the
lock. Hopefully, the second problem is potential.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bbac9a40f42c..e73f63b57e0b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1778,6 +1778,7 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 
 	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret != -1) {
+		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(ctx);
 		req->flags &= ~REQ_F_LINK_HEAD;
@@ -1800,7 +1801,6 @@ static bool __io_kill_linked_timeout(struct io_kiocb *req)
 		return false;
 
 	list_del_init(&link->link_list);
-	link->flags |= REQ_F_COMP_LOCKED;
 	wake_ev = io_link_cancel_timeout(link);
 	req->flags &= ~REQ_F_LINK_TIMEOUT;
 	return wake_ev;
-- 
2.24.0

