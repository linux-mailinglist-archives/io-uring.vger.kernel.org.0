Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9CC5ABAF7
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 01:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiIBXBC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 19:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIBXBA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 19:01:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BEAE8301
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 16:00:59 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id i5-20020a17090a2a0500b001fd8708ffdfso6845049pjd.2
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 16:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=18eCieYHftePoeUXpDXqQ+Nzo96yLavK1iKazpHfrQc=;
        b=i9MgTEVrtQyizhn15yR3MU5wi122psE0tFbhUHxxn+JQ4xROCtWxqwSaeiRs91lRod
         h6y3gb9HeCZr3sUlvjk7p3YM1IfN04P6AlzbKu0/mR9WBHBAcIzLs9dQ2BtUJdmhSY0y
         u1a5qjYPMSak0A9ZdQR5R87P+SlgQHVBo91Wmk/WzMMf1DQB5gRxfhc4HAdHKgF5eZUg
         34W+yp976J7M44WlcmmNfnxaJsS+7q8BD+yPTtQozKS8++REkfwVJiIVPLkL6N9MfFbG
         2AYpDKsQXDkd1IIf6kFPUOmbYG4huycszqO4INGVGGVQVcPyPkuzj8LLUUBvreHmeyEU
         YKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=18eCieYHftePoeUXpDXqQ+Nzo96yLavK1iKazpHfrQc=;
        b=BIoa4/wv67YHIUzthEoHdiSJ4iA1prWL0VH0vG6smQlB/E1/Il8Sqo8hMDHvI2TPER
         /8AFVtEc7dm5Hi60ZpwB1eMENNcZOOXY2U+e6X9ORu2hyttBXybflX0GuUQDC/Zp2ZQ9
         8rMnIJ7rT1DZlLG8XtGrEi0YOnAFqh3qOz2297g/bYENhT6P/vNukEBTkVQI1VXTRoDd
         2pYvlqmxSA5kYK9ZW1SuES8Pf8WCy4AwuPUJf1jlF2yt6sQmB3b1rHJEAjUXkc1lY8Cl
         ApoKNC/rGkfkHxOJBhbN/pQ/8U2oYO3THVm+0kaZ1LBXNrroU6oWXLk7DoWKOopGDSSW
         kt/w==
X-Gm-Message-State: ACgBeo3Sv8VSYU8KbZBfrk2KeXT3IwS64pLfGsESlxQJgpjeIkjl4ur1
        6JyABVaMLyFecn2oOTgD2sNZEPuWm91vlg==
X-Google-Smtp-Source: AA6agR5F+ZmGQL+vJT1QE74EP8MG0cxsfzRKuyMTDRF1kq9mFzxwGHwDzT8MjsffbqabpQhyfELgzQ==
X-Received: by 2002:a17:902:f54b:b0:174:f4a3:767c with SMTP id h11-20020a170902f54b00b00174f4a3767cmr22664370plf.4.1662159658665;
        Fri, 02 Sep 2022 16:00:58 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c10c00b0016c5306917fsm2202104pli.53.2022.09.02.16.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 16:00:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] fs: add batch and poll flags to the uring_cmd_iopoll() handler
Date:   Fri,  2 Sep 2022 17:00:52 -0600
Message-Id: <20220902230052.275835-4-axboe@kernel.dk>
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
index f34abe95821e..7a0b12ef49ae 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -637,7 +637,9 @@ int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
 	return nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
 }
 
-int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
+int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
+				 struct io_comp_batch *iob,
+				 unsigned int poll_flags)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -650,7 +652,7 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
 			struct nvme_ns, cdev);
 	q = ns->queue;
 	if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
-		ret = bio_poll(bio, NULL, 0);
+		ret = bio_poll(bio, iob, poll_flags);
 	rcu_read_unlock();
 	return ret;
 }
@@ -736,7 +738,9 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 	return ret;
 }
 
-int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
+int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
+				      struct io_comp_batch *iob,
+				      unsigned int poll_flags)
 {
 	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
 	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
@@ -752,7 +756,7 @@ int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
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
index 3f03b6d2a5a3..4a061326c664 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1009,7 +1009,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			struct io_uring_cmd *ioucmd;
 
 			ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-			ret = file->f_op->uring_cmd_iopoll(ioucmd, poll_flags);
+			ret = file->f_op->uring_cmd_iopoll(ioucmd, &iob,
+								poll_flags);
 		} else {
 			struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
-- 
2.35.1

