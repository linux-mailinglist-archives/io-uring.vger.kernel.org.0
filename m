Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AAD174E4F
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgCAQUA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:20:00 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44241 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgCAQTq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:19:46 -0500
Received: by mail-wr1-f67.google.com with SMTP id n7so1495797wrt.11;
        Sun, 01 Mar 2020 08:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OOYs+WLgec0RjFGhiKnTQ7j8jE0py2/hwE7Xwuc9Btk=;
        b=k0Mqe2kBcn6d+F/2TBWQABIIoT9v1Uke/ZPxOeNpMvibzgQaBWQdy9Rq1l1SL8hgw8
         eUtIOzX+IxcWNDKDipPnMrWRrGJlodtKtom7Kqp58Dvk8GIv3rcJkULdZBSvNmb96T4K
         js0mGqKJBcxzbsGyj/V0BTiUZTeQTXZ2wh/BwAknOdijDCfZHM/kTclm8APx78Tpuy5l
         4MQ3bXbOL/KAW144iVigHOGtG8cAmpSUrkZbMjsH5mT3Ba6NHeaCkiCY9cS99zNy43Fs
         cLWnzW7mY5dkaJ80jHQ3jLpm3SUad/hgZK/Eu+wTfJbRMWR91y3P8VdesczHW8TgRlfA
         Wc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOYs+WLgec0RjFGhiKnTQ7j8jE0py2/hwE7Xwuc9Btk=;
        b=GZqKYzvZx9Zvvu+Nhp6DRFbaWEKl6izgUTJHQILz+RIEFbbkXx2xwoeFNCgheiHk8d
         qAJPGsqrCisjlmyzJyoOMvgvuF7pwDjgWFfQ0xDF+ZO4923biLGzbOzSxVPa0t3gexIL
         MfkX1NY5pBQN/yJk25HbaAQo96I/k2Pm0RNQFtTRONRli65qcj8laJPTg0A0x9OAGzzi
         vU+Rcb5qeUg/6fSF6cj+JippAXDHMhAz4I1wLtKtsR5uyLixcfELSLbshV/cUp6DyDSE
         wzKWQPs1bH2pqo+wys1xLOBSRLG5r5T2rsi7do3uGibP32CPTenXpkUnTs4LOEKzAsRT
         LoyA==
X-Gm-Message-State: APjAAAXFYxB8yHNLn4+Z2QaiY9lXGoLQ6Id3bX7b/ilRlLx2R7CrpNFK
        3uC+9jK2VMSH/QOrUvRaG5tOAjx5
X-Google-Smtp-Source: APXvYqzDFO09eF9HLEoMOvTv1co6+Pjh6b3nTxsGuMwVuYXRnRQRpw5T9vm0zA72I3UvBSFM0k1uhw==
X-Received: by 2002:adf:ea42:: with SMTP id j2mr16312289wrn.377.1583079585610;
        Sun, 01 Mar 2020 08:19:45 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q9sm15864741wrn.8.2020.03.01.08.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:19:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] io-wq: optimise double lock for io_get_next_work()
Date:   Sun,  1 Mar 2020 19:18:25 +0300
Message-Id: <4f51449ca995ba60d78e7ba55e8bc9876328605c.1583078091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583078091.git.asml.silence@gmail.com>
References: <cover.1583078091.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When executing non-linked hashed work, io_worker_handle_work()
will lock-unlock wqe->lock to update hash, and then immediately
lock-unlock to get next work. Optimise this case and lock/unlock
only once.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index da67c931db79..f9b18c16ebd8 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -474,11 +474,11 @@ static void io_worker_handle_work(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
+	unsigned hash = -1U;
 
 	do {
 		struct io_wq_work *work;
-		unsigned hash = -1U;
-
+get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
 		 * the list isn't empty, it means we stalled on hashed work.
@@ -528,6 +528,9 @@ static void io_worker_handle_work(struct io_worker *worker)
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
 				/* dependent work is not hashed */
 				hash = -1U;
+				/* skip unnecessary unlock-lock wqe->lock */
+				if (!work)
+					goto get_next;
 				spin_unlock_irq(&wqe->lock);
 			}
 		} while (work);
-- 
2.24.0

