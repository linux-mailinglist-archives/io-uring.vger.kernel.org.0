Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84141D6CB2
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 21:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgEQT6S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 15:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQT6S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 15:58:18 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63353C061A0C
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 12:58:17 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p21so3758369pgm.13
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 12:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Bv4OUlNsqPf2DmNWWvJ8TbQ+MeGHraz6/nKZYr1Ap9o=;
        b=Bf4zNZgfDtD7bfJORAost3k5/j5WAS3SppIeHb2ANc4CVGsLcl5GZE70eRxpFabvkW
         0XNsEvYofseHuGD0ltqAH/rM6jG7irOOH1AetXC/wdxF1RoiE3Xe/sqHf9yqF43X5Fuo
         mcJlA5ttWOHO5xqsbGtt/wVnjfx8YNRfXlHMPdPO/kcFF7afYNVkhtyvXE3ERQKuVcpl
         mYVmi96Mdw/8HNis9f5G1kGAE+V5kPJqu6FikuWNg9FF/Gy54ZMNuVM4rN7+EC9sNIid
         oGrS5YCwp0F5VbSuDk9+rzpKF7ksfNZK7sA9E7IaQMTziu6k9BrCnycz5rncD79za9yF
         IS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Bv4OUlNsqPf2DmNWWvJ8TbQ+MeGHraz6/nKZYr1Ap9o=;
        b=sK1uB8aOBd+xri3AO/MddaN6eTLICkxu+ou3ArMexS2CFD9/OFzKBv25cmJBe2qXwj
         G04TCvKIGAN8GG+Zm6WFysTwWyzAjTvh8J3JFTkrIgZ8C1WnGwnbJ0SoI1umINWbNPqf
         0VKrW+B1ef9qpEtOUoXeO5ML29Vj56BjocP+qX2Bz9DfFVnotEL1Y/QUF+yTLs6XoJnl
         eF6FQm7QIvycjRUDeW7nTMySKLhFiEa+uoeaTzIamK77k9eARYY1CHWseRDeoONdE/sr
         1Z9o1zzfrO6W6M+xvDYOEJCB+yq6B9IHc+7wNVT89KrBLxGBE0rdmU93gTiPHjpAQJOr
         Zokw==
X-Gm-Message-State: AOAM530/4zKyHYmqqUFktXuCuXWpfjHaFTxM6j8VrgI7SLn7Se29A7kG
        a06WbDL8dhYQ8hXeW3SJCBgFTBu0bLY=
X-Google-Smtp-Source: ABdhPJw8ZMf4DfEZqBOgAU0EaMx+GX2WH8ATmbxXmuGvnPvCnlWD0iGH/BltC4aiReSc7Eee6J42lQ==
X-Received: by 2002:a63:f14b:: with SMTP id o11mr12321325pgk.429.1589745496711;
        Sun, 17 May 2020 12:58:16 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:91d6:39a4:5ac7:f84a? ([2605:e000:100e:8c61:91d6:39a4:5ac7:f84a])
        by smtp.gmail.com with ESMTPSA id h9sm6802600pfo.129.2020.05.17.12.58.16
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 12:58:16 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: cleanup io_poll_remove_one() logic
Message-ID: <8330f268-7658-bfd2-64f5-d342845b9e3c@kernel.dk>
Date:   Sun, 17 May 2020 13:58:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We only need apoll in the one section, do the juggling with the work
restoration there. This removes a special case further down as well.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 93883a46ffb4..e2cd659f29ed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4476,30 +4476,29 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 
 static bool io_poll_remove_one(struct io_kiocb *req)
 {
-	struct async_poll *apoll = NULL;
 	bool do_complete;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
 		io_poll_remove_double(req);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
-		apoll = req->apoll;
+		struct async_poll *apoll = req->apoll;
+
 		/* non-poll requests have submit ref still */
-		do_complete = __io_poll_remove_one(req, &req->apoll->poll);
-		if (do_complete)
+		do_complete = __io_poll_remove_one(req, &apoll->poll);
+		if (do_complete) {
 			io_put_req(req);
+			/*
+			 * restore ->work because we will call
+			 * io_req_work_drop_env below when dropping the
+			 * final reference.
+			 */
+			memcpy(&req->work, &apoll->work, sizeof(req->work));
+			kfree(apoll);
 	}
 
 	hash_del(&req->hash_node);
 
-	if (do_complete && apoll) {
-		/*
-		 * restore ->work because we need to call io_req_work_drop_env.
-		 */
-		memcpy(&req->work, &apoll->work, sizeof(req->work));
-		kfree(apoll);
-	}
-
 	if (do_complete) {
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
-- 
2.26.2

-- 
Jens Axboe

