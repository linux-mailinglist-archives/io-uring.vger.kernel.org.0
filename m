Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DBE5ABFE4
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 18:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiICQwq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Sep 2022 12:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiICQwo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Sep 2022 12:52:44 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46884C634
        for <io-uring@vger.kernel.org>; Sat,  3 Sep 2022 09:52:42 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c2so4771375plo.3
        for <io-uring@vger.kernel.org>; Sat, 03 Sep 2022 09:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=+qBjgowB2IPvEXh4hW2qqFOwv1S2VSWIvC4vev06Ra8=;
        b=QzIg28DvPM+fCOL5TfyvCb7+EnlWmrEFjAgNFrlq2b+xGnzi7e63MT96vewPf6nAo+
         HM+45I/WEM9dRSPL+H1RakHW6gu+bUFZSMXLs24+A7k0/jlmFJSbjkmGT5IZ2bXYPfPl
         7j6X4wB3iw14ve2AUiKnn7IrqozDkF1JMg/+TD9pXicfT6lQPCLvpnpkgkM4nKYLY3BX
         jhfxBcpddxiatlADyW1SaoX17q8qZkvIeUDksZ8/oycmujkGvHOn73k9+0yRiOC+7h6l
         3RsVODceZYF1CqP/r5n9MWcpdqWYhnqYzobSoYGeslsjGB6hH/aJpkjblekrF8jFKapy
         nxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+qBjgowB2IPvEXh4hW2qqFOwv1S2VSWIvC4vev06Ra8=;
        b=rxInCMK2K2Bq48qUpGQKO23oAg6FgVaIouEPi41d63ONLXNWLfiFQ1mudnWiZSv7g5
         H7L3CXMSGXLaO9y++ikWqWAjoL1w6nPpNZVdgTzKVBbnkfzVaR4M/R5dFymzQ18aze3p
         6cSpsISYQfc8I/U4N2d/ghfR902IegPCRdS15k2th1KRE+ULSU/08Ir+B3jchdRlYvnt
         bvg5pkECgKWi+iNO5stDjwkQebSyok+ArrRW3vc8vGknN20BtG43qN7FNDEjN3tB+37b
         2IL4VeoOIXNWilnsADOC5aEtuEjOAHmntPvpSppJCMAoeBMcM2z7305ibZWrBxgqffBV
         m94A==
X-Gm-Message-State: ACgBeo1n8xjEQ5o2bGbz5FJo55Y7EU9etaCRkt9nCVKjRqlyfDwsvM/0
        HGNpOtO5jb0z4HRrQ7u1L9CEwuThRPJh2g==
X-Google-Smtp-Source: AA6agR6uKVwtAq8GHasdajTfSpsWgJJzeFRlpg4F5PgvaqDyT/bqDpNUreszfB9NM18GtLxrUducVg==
X-Received: by 2002:a17:90b:4b4a:b0:1fd:d452:884d with SMTP id mi10-20020a17090b4b4a00b001fdd452884dmr11005257pjb.131.1662223961981;
        Sat, 03 Sep 2022 09:52:41 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w185-20020a6262c2000000b005289a50e4c2sm4187296pfb.23.2022.09.03.09.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 09:52:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] fs: add batch and poll flags to the uring_cmd_iopoll() handler
Date:   Sat,  3 Sep 2022 10:52:34 -0600
Message-Id: <20220903165234.210547-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220903165234.210547-1-axboe@kernel.dk>
References: <20220903165234.210547-1-axboe@kernel.dk>
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

We need the poll_flags to know how to poll for the IO, and we should
have the batch structure in preparation for supporting batched
completions with iopoll.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/ioctl.c | 12 ++++++++----
 drivers/nvme/host/nvme.h  |  6 ++++--
 include/linux/fs.h        |  3 ++-
 io_uring/rw.c             |  3 ++-
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 7756b439a688..548aca8b5b9f 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -623,7 +623,9 @@ int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
 	return nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
 }
 
-int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
+int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
+				 struct io_comp_batch *iob,
+				 unsigned int poll_flags)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -636,7 +638,7 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
 			struct nvme_ns, cdev);
 	q = ns->queue;
 	if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
-		ret = bio_poll(bio, NULL, 0);
+		ret = bio_poll(bio, iob, poll_flags);
 	rcu_read_unlock();
 	return ret;
 }
@@ -722,7 +724,9 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 	return ret;
 }
 
-int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
+int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
+				      struct io_comp_batch *iob,
+				      unsigned int poll_flags)
 {
 	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
 	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
@@ -738,7 +742,7 @@ int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
 		q = ns->queue;
 		if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio
 				&& bio->bi_bdev)
-			ret = bio_poll(bio, NULL, 0);
+			ret = bio_poll(bio, iob, poll_flags);
 		rcu_read_unlock();
 	}
 	srcu_read_unlock(&head->srcu, srcu_idx);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index fdcbc93dea21..216acbe953b3 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -821,8 +821,10 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
-int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd);
-int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd);
+int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
+		struct io_comp_batch *iob, unsigned int poll_flags);
+int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
+		struct io_comp_batch *iob, unsigned int poll_flags);
 int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
 int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d6badd19784f..01681d061a6a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2132,7 +2132,8 @@ struct file_operations {
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
-	int (*uring_cmd_iopoll)(struct io_uring_cmd *ioucmd);
+	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
+				unsigned int poll_flags);
 } __randomize_layout;
 
 struct inode_operations {
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 966c923bc0be..4a061326c664 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1009,7 +1009,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			struct io_uring_cmd *ioucmd;
 
 			ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-			ret = file->f_op->uring_cmd_iopoll(ioucmd);
+			ret = file->f_op->uring_cmd_iopoll(ioucmd, &iob,
+								poll_flags);
 		} else {
 			struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
-- 
2.35.1

