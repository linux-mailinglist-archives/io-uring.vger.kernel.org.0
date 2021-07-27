Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095B13D7B73
	for <lists+io-uring@lfdr.de>; Tue, 27 Jul 2021 18:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhG0Q6Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jul 2021 12:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhG0Q6Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jul 2021 12:58:16 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F123C061760
        for <io-uring@vger.kernel.org>; Tue, 27 Jul 2021 09:58:15 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id u10so73150oiw.4
        for <io-uring@vger.kernel.org>; Tue, 27 Jul 2021 09:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FTFh77M6ju5U9mrJmgOpaSUpgC6d1Fi0E51HprqJ5eM=;
        b=Q6+Er6ZMPVCyLSc0TlS8PBCjcUL1YzvNLP+xtXCxMRuxNzRsu1YrwvAlHUnNl49rLe
         +xxhZXP5asUIAutGsCybPXCqdDlDqxU3UE5veA9xPTeuUav6Xklrivv4AmuJo9E8f7BM
         lDLeVj5GHg5Hqy0VOp8T6sKD9cuX8gDoh5Yo1A9OpL65/p6DXtD9Y7at0ZAL4MBVAr7v
         089VdXVFx9DWTXkySaWqAvzIID3sZSOV7yngzhotZxwEiYCKP4fa1O8emPFBd8sLwO1i
         5cQ+wUfIlx864j3wwJf5zeLr4vNElSts4ifT/AZbR+WKGl6ygIEMSHV4izvGy5nDfOkH
         Verg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FTFh77M6ju5U9mrJmgOpaSUpgC6d1Fi0E51HprqJ5eM=;
        b=dfrjtLdPjF/ivB1zn24uGm4NJ1ctcoN2PZBINOd/G/McBH0WQT92tTLfGVPWknbXym
         2Gbf3HmiTOIHe4xy0xV/kjfV74Dg90tPTi1K+c3UqAUd+0OWoL1LV97ZW0plv4gcLKTL
         arP4LndSUu10+D0ShebjH5dUWNA6jLmU6meG4LL8R/OSHSC4fOMDoI+J/qcbEB02U7x5
         GMD655gC6F/OZ/i98GcLTZzSdSydnmhUGUxNFBCTXZNM8sgSZrLmqddVOijHh/lw+O+Z
         iF0E55qSv4HxqrYGWsPObhBmdmDprQEt04uK+KrVG7U0dGM3xPXtbJU/Pmt1714ardrT
         I9jg==
X-Gm-Message-State: AOAM531RVpDeNx550250u0nybP3UmKCBkfE3pDgua9ehIK4PP4MHVzfO
        P7eY8vtxcyb9HgavRCRrFZeDBvac4utAM3DQ
X-Google-Smtp-Source: ABdhPJwd+jtNw0W//RsGaySyyDYP9umxEyN6vJV6JiS0YdwYRr4NSSkVgureby7y0XNa8k7rs4jZMg==
X-Received: by 2002:a54:4d8f:: with SMTP id y15mr3745333oix.32.1627405094499;
        Tue, 27 Jul 2021 09:58:14 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c21sm637922oiw.16.2021.07.27.09.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:58:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     f.ebner@proxmox.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: always reissue from task_work context
Date:   Tue, 27 Jul 2021 10:58:10 -0600
Message-Id: <20210727165811.284510-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210727165811.284510-1-axboe@kernel.dk>
References: <20210727165811.284510-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As a safeguard, if we're going to queue async work, do it from task_work
from the original task. This ensures that we can always sanely create
threads, regards of what the reissue context may be.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a4331deb0427..6ba101cd4661 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2060,6 +2060,12 @@ static void io_req_task_queue(struct io_kiocb *req)
 	io_req_task_work_add(req);
 }
 
+static void io_req_task_queue_reissue(struct io_kiocb *req)
+{
+	req->io_task_work.func = io_queue_async_work;
+	io_req_task_work_add(req);
+}
+
 static inline void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = io_req_find_next(req);
@@ -2248,7 +2254,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
 			req_ref_get(req);
-			io_queue_async_work(req);
+			io_req_task_queue_reissue(req);
 			continue;
 		}
 
@@ -2771,7 +2777,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
 			req_ref_get(req);
-			io_queue_async_work(req);
+			io_req_task_queue_reissue(req);
 		} else {
 			int cflags = 0;
 
-- 
2.32.0

