Return-Path: <io-uring+bounces-7275-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91EE7A74E06
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 16:47:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71AC817451B
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 15:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC621DA10C;
	Fri, 28 Mar 2025 15:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ayti3Y4A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA9C1C4A2D
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743176840; cv=none; b=nzD82WW+UF4XRTzLWHJ1SOWPutWzsmexyhVajADEMZk5EXE4CzGvHrAgVaxF6cOZvmJHhmemNPjmYhS3xgjWsBHrhfbO+12G75/ZyOE+RjxSMD62YX0VQXjHhUeTE0i0JB0GKIpqLQXaDXzuy4HsOhylzelLeKuQSZ/Osbf3pmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743176840; c=relaxed/simple;
	bh=fUXrNvezfQcUlckLuYQ/mreZHTic4EIPjfaDUroijsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ki5Y4Sbnbks0q2t0ljmwv4/sW74uCqlTUKSmwm/q7YHS7J/Xuyh/z+SbUwKLgvchFUTUxYGFHnyS7rQzJE2ozxXxGgcAghXkVOIGqLUavUoVXTfOt6B6P2fkQPRbo1OpcwcChxXfszskdkwfkQ6ZSKSB8xu97GP4xle3Ccitpj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ayti3Y4A; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-227c7e4d5feso6375875ad.2
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 08:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1743176837; x=1743781637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0mVM8AOP/uQwd1MDpgpJ58oiDfod93l3Y9l0W6NadbQ=;
        b=ayti3Y4AZ/Tmx5mEhS53XGb9xnP5Bj3IV/ePBkbyXJFa70JE2iOUO0bagfcfuU6xr4
         cKnbi2UlHNIoGvBTNnmWgEJjIJtuAokU7vECYf1wk/cnDgHcTu/yuffbYLrLhsmKiOvL
         yRN2XahA6kxEWA3OmexT05Lu4f4VmwvYwBhhpSsH3mYWRAUlhXpaBLuNyCpZxpxPb8oe
         +Nlux3f3shJwBaKHryYHLkP3CHY3PPpH/P9rwUIE991DuQjs3mWClnOZTns8o2mRgkYk
         KLXNY/MT2w1ar/Th0puIGWhFuwDphafG/asCQriz0zbkTIFXnF2a+li6mdx107AhzGof
         4+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743176837; x=1743781637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0mVM8AOP/uQwd1MDpgpJ58oiDfod93l3Y9l0W6NadbQ=;
        b=Q2LwsWToFf/79yt0NFRbMz553+U3DaFXw9vfPGP5lh4INAYIiW4K4U6apLSQLOC0cB
         c7LyIzkDW6AnNEFCxQIkhBLynuCjn6RikoNr2Yi1rTaJIcyD8HlXMyu/eu8S1mgqC+kg
         PLVOBtCfDIpgjmbkQS6FG4zr+MjDXLoScJyD5mzi4jpeh4WqXjY4CT7q9uu7yslYtfZl
         29Z1L6pf60S/hgLrykgdj1TPKa7uSROBW5HjT3sDBrwFXCM9yMcERrF6i5r/+EaFTVC6
         30ILqrQED2R3MdLma7fuZkY/LeTcqw+QZ4/8mv1pEtT/McgmS20CSCLPqNEvjKrGoGIf
         ZE2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSW84I2W/mUcTC4TUOiTmci+AKBY4MlxqqNS3Lh4urBMrVEni73R5FuWhEYGYBu8G17pTyhrxBFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzrVzTKcmQHOC7y71YMyzm+p6gNRPP8uBaMSbGwKPC++6j4SWAP
	/MO/ujVwEM8ACLm29y5uycetBKgl6pBiQrG0bCsraWejD8/FA/rBtKu8xKkkwsvNOqvLMTjsCMU
	BcEg2VKJdj4TrnVzU65grpc5g/fZZBRHpizQkns8jbk97lbWI
X-Gm-Gg: ASbGncs4k0d9vKO9w69WLGEpsCh4zFyHdHqx1occ8oF8ux3Py/mBJVT22/MJNje4h4q
	e8sD4O8ekG11vU7nENs07M658BlMlm0bw8yD7s9lfz9EjKhpsV9d2mM2hA398mPtcOhQ+9BQlNo
	1dviZ2cE49b0YJt43wsFLFZ9LWk2UIkfeojEONH0ekdmMBIh6I3E+rUt7bi9NOllvHzOXMnL+G1
	pOfNjHadaCvSwTq+/8ZfH/DsJqoLnV/yJg1s66H+NQZAmRGFxI12bDcT5PydJKpArtnng0dbHKD
	Vk9EfYVYpy7/eek9iZo6I0TDSIMjUs7Y6A==
X-Google-Smtp-Source: AGHT+IHcHduh5E0s2skNSV47XrUM4N9lgZTh46ndYiV2vIM8885gcd/Exi/meEMDt1hOO7Sm4si1VNwfTQYp
X-Received: by 2002:a17:903:985:b0:223:28a8:610b with SMTP id d9443c01a7336-229200f26damr22792405ad.14.1743176836796;
        Fri, 28 Mar 2025 08:47:16 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2291f1db993sm2730225ad.126.2025.03.28.08.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 08:47:16 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 31D4F34018F;
	Fri, 28 Mar 2025 09:47:16 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 2FA11E40A9F; Fri, 28 Mar 2025 09:47:16 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
	linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 2/3] nvme/ioctl: move blk_mq_free_request() out of nvme_map_user_request()
Date: Fri, 28 Mar 2025 09:46:46 -0600
Message-ID: <20250328154647.2590171-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250328154647.2590171-1-csander@purestorage.com>
References: <20250328154647.2590171-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The callers of nvme_map_user_request() (nvme_submit_user_cmd() and
nvme_uring_cmd_io()) allocate the request, so have them free it if
nvme_map_user_request() fails.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/ioctl.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 0634e24eac97..42dfd29ed39e 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -127,41 +127,39 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	int ret;
 
 	if (!nvme_ctrl_sgl_supported(ctrl))
 		dev_warn_once(ctrl->device, "using unchecked data buffer\n");
 	if (has_metadata) {
-		if (!supports_metadata) {
-			ret = -EINVAL;
-			goto out;
-		}
+		if (!supports_metadata)
+			return -EINVAL;
+
 		if (!nvme_ctrl_meta_sgl_supported(ctrl))
 			dev_warn_once(ctrl->device,
 				      "using unchecked metadata buffer\n");
 	}
 
 	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
 		struct iov_iter iter;
 
 		/* fixedbufs is only for non-vectored io */
-		if (flags & NVME_IOCTL_VEC) {
-			ret = -EINVAL;
-			goto out;
-		}
+		if (flags & NVME_IOCTL_VEC)
+			return -EINVAL;
+
 		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
 				rq_data_dir(req), &iter, ioucmd,
 				iou_issue_flags);
 		if (ret < 0)
-			goto out;
+			return ret;
 		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
 	} else {
 		ret = blk_rq_map_user_io(req, NULL, nvme_to_user_ptr(ubuffer),
 				bufflen, GFP_KERNEL, flags & NVME_IOCTL_VEC, 0,
 				0, rq_data_dir(req));
 	}
 
 	if (ret)
-		goto out;
+		return ret;
 
 	bio = req->bio;
 	if (bdev)
 		bio_set_dev(bio, bdev);
 
@@ -174,12 +172,10 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	return ret;
 
 out_unmap:
 	if (bio)
 		blk_rq_unmap_user(bio);
-out:
-	blk_mq_free_request(req);
 	return ret;
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, u64 ubuffer, unsigned bufflen,
@@ -200,11 +196,11 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	req->timeout = timeout;
 	if (ubuffer && bufflen) {
 		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
 				meta_len, NULL, flags, 0);
 		if (ret)
-			return ret;
+			goto out_free_req;
 	}
 
 	bio = req->bio;
 	ctrl = nvme_req(req)->ctrl;
 
@@ -216,11 +212,14 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		blk_rq_unmap_user(bio);
 	blk_mq_free_request(req);
 
 	if (effects)
 		nvme_passthru_end(ctrl, ns, effects, cmd, ret);
+	return ret;
 
+out_free_req:
+	blk_mq_free_request(req);
 	return ret;
 }
 
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 {
@@ -520,20 +519,24 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	if (d.data_len) {
 		ret = nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
 			d.metadata_len, ioucmd, vec, issue_flags);
 		if (ret)
-			return ret;
+			goto out_free_req;
 	}
 
 	/* to free bio on completion, as req->bio will be null at that time */
 	pdu->bio = req->bio;
 	pdu->req = req;
 	req->end_io_data = ioucmd;
 	req->end_io = nvme_uring_cmd_end_io;
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
+
+out_free_req:
+	blk_mq_free_request(req);
+	return ret;
 }
 
 static bool is_ctrl_ioctl(unsigned int cmd)
 {
 	if (cmd == NVME_IOCTL_ADMIN_CMD || cmd == NVME_IOCTL_ADMIN64_CMD)
-- 
2.45.2


