Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD35E5ABAF6
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 01:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiIBXBB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 19:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIBXA7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 19:00:59 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B207AE8316
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 16:00:58 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d12so3233156plr.6
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 16:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=yb5YyAK5cbnH0R7fDCajHHKBEKXm4i5C7knOCXRRYOs=;
        b=xhh6MdL5L1er6DEOGvep5rcoYXNjyU0Y4GBZOzpf5LGfjzCBVS8knq3HVgjyS5FGyG
         EdZxczd2faKhoRzEPRR0/4l3FNT1tFu8EHPjAsmhCJPQpPDlXngO+NMl5ikHSC5UZVsp
         VIAjW90MrIkdvaJx5MspGygFiau+o6FipBmylwp5Mc2DJCxLFWGi54m+R3hIcvwWLEaC
         9ZfTwW6PqGeC8np9uUkv+PXO3TiGUxG9Dq5Dv4H/UclD9+cZgkwQC2LRft2c41ThaQ2I
         o9FjZEh06RjZ4FYj9+igyi6tdhaKZh01M9N1FuuVOodISQ285DWxjch5AP6u83lTmfbp
         XAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yb5YyAK5cbnH0R7fDCajHHKBEKXm4i5C7knOCXRRYOs=;
        b=Z2/JXUvYXaoEXcaDkHJ2ZFviZhP+tUxu0PfQs6JFAyquEY6Q0O+cMTVQ6FJmtO0QPE
         b3bo+2/npN+ca4sMSVn8DsbOb2tO0C04q0h51LfiWRF9vS3hNBntTR+YnZBVx1rhB+O5
         o+8DgOxef/oCRsgINqZlGrND5ulD0CKnVSO1lgnXPpcRlgvYa20HHh4IKewx4vyflZUs
         3Bdk31bXNFmVevx0VJfsLKeHeLCnOxG6C4k0EY9MAKMKdqci8AcW3rwecuhHUJf0rQtf
         PTocXcAd3aCVagxawxwffvMTZ68QssfFdmprnXqQ3rKrCtd5DplT/Y4Z1gLogmASk+K7
         c9YQ==
X-Gm-Message-State: ACgBeo3ar/5kkiuj8j1bH1UhzHLG20r2OCCzMRybm7OEDm5G+L996CEZ
        Ek5U4UzvdIy39ROaAkRnH+77ZxbONcdcew==
X-Google-Smtp-Source: AA6agR5VohaI+160NaSIDDOnusrfhq8Pm1CzaWfb82c2zK9JTMRrYJnmZ9Hah5CVg4nALqaIh55HIQ==
X-Received: by 2002:a17:90b:3142:b0:1f7:338a:1d38 with SMTP id ip2-20020a17090b314200b001f7338a1d38mr6868031pjb.223.1662159657687;
        Fri, 02 Sep 2022 16:00:57 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c10c00b0016c5306917fsm2202104pli.53.2022.09.02.16.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 16:00:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] nvme: use separate end IO handler for IOPOLL
Date:   Fri,  2 Sep 2022 17:00:51 -0600
Message-Id: <20220902230052.275835-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220902230052.275835-1-axboe@kernel.dk>
References: <20220902230052.275835-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't need to rely on the cookie or request type, set the right handler
based on how we're handling the IO.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/ioctl.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 7756b439a688..f34abe95821e 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -385,25 +385,36 @@ static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
 	io_uring_cmd_done(ioucmd, status, result);
 }
 
-static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
+static void nvme_uring_iopoll_cmd_end_io(struct request *req, blk_status_t err)
 {
 	struct io_uring_cmd *ioucmd = req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	/* extract bio before reusing the same field for request */
 	struct bio *bio = pdu->bio;
-	void *cookie = READ_ONCE(ioucmd->cookie);
 
 	pdu->req = req;
 	req->bio = bio;
 
 	/*
 	 * For iopoll, complete it directly.
-	 * Otherwise, move the completion to task work.
 	 */
-	if (cookie != NULL && blk_rq_is_poll(req))
-		nvme_uring_task_cb(ioucmd);
-	else
-		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
+	nvme_uring_task_cb(ioucmd);
+}
+
+static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
+{
+	struct io_uring_cmd *ioucmd = req->end_io_data;
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+	/* extract bio before reusing the same field for request */
+	struct bio *bio = pdu->bio;
+
+	pdu->req = req;
+	req->bio = bio;
+
+	/*
+	 * Move the completion to task work.
+	 */
+	io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 }
 
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
@@ -464,7 +475,10 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 			blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
-	req->end_io = nvme_uring_cmd_end_io;
+	if (issue_flags & IO_URING_F_IOPOLL)
+		req->end_io = nvme_uring_iopoll_cmd_end_io;
+	else
+		req->end_io = nvme_uring_cmd_end_io;
 	req->end_io_data = ioucmd;
 
 	if (issue_flags & IO_URING_F_IOPOLL && rq_flags & REQ_POLLED) {
-- 
2.35.1

