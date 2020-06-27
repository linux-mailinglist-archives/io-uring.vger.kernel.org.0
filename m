Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B6E20C0F0
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 13:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgF0LGs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 07:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgF0LGs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 07:06:48 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA16C03E979
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 04:06:47 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h5so11875808wrc.7
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 04:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YBAt5N/oga1tv8imvLQp6b/ILSwSeYxYXuEpAzzeIPM=;
        b=NoG3CbXcz6xn7KDAK5GqnV8w24rEnV7GGHPk7fGbZE6AKxkLVROghzbIB4D2QH428L
         iuR28EEEixtjCq7SeTO2XzD91Mp/GT6ZD0o66QWoIBjNxky3FOMKu+a9Y6ZhR0xvaJeq
         vtDbrU9cbpV5l7uSk6jIdQ8MQVzDhSpuyXUY18NVqCkufcdxe0i8kdwryVhv/s8xGBws
         6gnkvwdjUccK/rwa0XZ2RxfIqPuftdGqeTEhZyAe044InXRArpSe3K1+syjordXJ4oWc
         tiIl+EhqJfFAeC5LwaJOiysi7ITBrJeW1jgZm0Ay5SwkDrG6/8DGadUAMHJDssDQ6ymx
         pXIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YBAt5N/oga1tv8imvLQp6b/ILSwSeYxYXuEpAzzeIPM=;
        b=bD5/UgjvqZksvE3o+HGmEDyH7D7y+hiDHUhEXRJEOCfnOWUCkxhDZGd1EEvba0ny35
         WMKURQNYcF19cruY6W26zc6n7CHnH5nP7ybmplmrRRCYngAeLJYZ71d2FZqKQ/3HQ1su
         A4VFtoXLVSi5Dnzmy7IvZgldZsqdzdbNWWiV9Ntgm6h6lN7tRRrUDmvkvU5KE4SL2stQ
         NB151dg1etQZK/WO6eZN0Is1MM6u/BwgCl9dLD0Y0WGuD8MTbToJ4JfmOpnf9Dpxo8ED
         QPTacRwqepgT3zkVhd8KtCQl5jrXKwQdDRUp4Z8Yl+4fMtkROIImiHon3m9QpnhDQX3f
         UUbQ==
X-Gm-Message-State: AOAM5315MWbxUJTo/2NctLC4iCepy9gvpmtQFhU5e5ficCk8bEnyAX4q
        NBQsGsnK9hvDzm+T2UC/P30AujaT
X-Google-Smtp-Source: ABdhPJw7YyQPJyi5IQFa2FdrDLuTOrfAakLBGcy7+94fG5e3ZUtEYzU0rryCaWX4cq2XELCTgV1tlQ==
X-Received: by 2002:adf:df03:: with SMTP id y3mr7763968wrl.376.1593256006551;
        Sat, 27 Jun 2020 04:06:46 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id x1sm14706721wrp.10.2020.06.27.04.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 04:06:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/5] io_uring: fix missing io_grab_files()
Date:   Sat, 27 Jun 2020 14:04:58 +0300
Message-Id: <8fce0fed05a0b077cbf420f99a76487bbad5b315.1593253742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593253742.git.asml.silence@gmail.com>
References: <cover.1593253742.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We won't have valid ring_fd, ring_file in task work,
Grab files early.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca486bb5444a..e2b5f51ebb30 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5264,15 +5264,15 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	if (!sqe)
 		return 0;
 
-	if (for_async || (req->flags & REQ_F_WORK_INITIALIZED)) {
+	if (io_op_defs[req->opcode].file_table) {
 		io_req_init_async(req);
+		ret = io_grab_files(req);
+		if (unlikely(ret))
+			return ret;
+	}
 
-		if (io_op_defs[req->opcode].file_table) {
-			ret = io_grab_files(req);
-			if (unlikely(ret))
-				return ret;
-		}
-
+	if (for_async || (req->flags & REQ_F_WORK_INITIALIZED)) {
+		io_req_init_async(req);
 		io_req_work_grab_env(req, &io_op_defs[req->opcode]);
 	}
 
-- 
2.24.0

