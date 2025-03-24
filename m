Return-Path: <io-uring+bounces-7225-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2CBA6E3F1
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 21:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEF2E7A5DE3
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 20:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4257C1C7017;
	Mon, 24 Mar 2025 20:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="bv11I3vp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f225.google.com (mail-il1-f225.google.com [209.85.166.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE6C192D77
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 20:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742846786; cv=none; b=fimamsfG2HWh4s7SyNkqiqj6zxMpJItF+vtay3wszHv00rvhlTJctl1cZ4MZRP0s3cTy22ljgvySOakntoAnmRwMvsZB7uqwzsSU3B7wYxgw2cvcov08Amn/O5ulgDup9Qzno5JtfVAOxKOuvFTRtsnYIIVigpOEk/AONJfnfF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742846786; c=relaxed/simple;
	bh=1iS4mGcy0YW42yJZNnESJIZkw5XDhoB+d/oFC8PEVes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDJmD83+Oc6aYlbAGDbCiF6MBxOOvjPiyKB0cyC8/wQymVE5/FGWN0Zw0gWExb4KIW4nYNTkoznIVagGzsf7QE9Pt7kTnhjboYp2H7BoBOAJCD96J0cwhulyaoGpULu6SdhagZRjKPbrKJvz6s1SYuCNZSV5cogQfyoRk8qXeHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bv11I3vp; arc=none smtp.client-ip=209.85.166.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f225.google.com with SMTP id e9e14a558f8ab-3d441a4b283so1496605ab.1
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 13:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742846783; x=1743451583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PBv3iNMxv4+elhFyGCYrja1iq4HKQSGLUCy5fijhOxs=;
        b=bv11I3vp1V3iQBDBm58FK2aDobHabnlnKGlQaRY+8i7FCqj+qaC10f07PM6MSrRuIe
         8/iWK60x/PBKsd00BR3eWzL7LI9bI14Akeasgst/6D6u/LNB3PUwNf/kqzUJaCpOVnAH
         gw29xFfqH0Hgia/JRehpOCUgYWaRuNIpVpeOwFtmeJRQG3rUQKL6P9JA8ye/q8eCEL0h
         ioSsp3HLCVmPG3H1R+UoR3tbGPKRcKvi9xE6jYHM8ODWIWs9pXwviGcCWGF6uV+x8DvA
         DfeZN3yXsmi+Dr9/2AY39OmKH7lg334ul0lUD7HC5amaECkEh1f+UvBKL93lYvk3gJxC
         giIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742846783; x=1743451583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PBv3iNMxv4+elhFyGCYrja1iq4HKQSGLUCy5fijhOxs=;
        b=eawUnz/Hv0ohu6E1SX3Kb1oZtoC8/ZQ+gCwHbrCQsgMGJgXCBEgaa3ngcABPXSeGEF
         v1JTSn7eUV/Wy6Ayravzech9lIhrQCr+yclWOyihggAfbRAoxvAwVctd1n77QKt4Xg14
         T9h4vjZb47Pw4NjioQ4i8goMYgZEYGGXg4sHzPlz9qIFTJVUnFIr+UGotvi4qkRADt7+
         18wJfYsyfaIXt4BlAvWzijVzx76fmVtIp76hYqNPJDf+FmPi1DfU9crhVppvbT0j16xu
         cQ/wbz+8eFTLR7Krw+hrF2IqOazuDKg9fiZ0T3vRUbGnEyXCdmlFsel+TaeNeDJwgGw4
         AcsA==
X-Forwarded-Encrypted: i=1; AJvYcCWKNW+J+BLmdO70sJPwo7TK+JmORP4ergKzXYOoxk6/z/Lmou2BQZSQnUgmHji1+Bb0o/Nd6DnmPQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzL5hm9tDoe4iG0n4tr1HcfoewJYhhTTyEDkFwNHKAD/gIMcG7b
	oSanoIO2LVPOfOx1i7UE/1hKMnZPRknedNC2kTMGKoBcyx4W2e3WJLn9quKRoVZOSEG9G2vhRmW
	wv5aqcb6cHy88eWfin5RmZ/JVaMbC6uU1
X-Gm-Gg: ASbGncui7uVSZEnCaFMyRQixzmMJqyq0j8ldGYAVXOA8eN2EaddcnTuepyjD9xA/ht+
	87kZQnTGUVmZ7BrA0iE14gEgIq3vE2PWEqEarOskbS8CccEuC8zXViq99bGegHsZjrFCUYWawCe
	6TrjOD878U+YIpHJBZdfg/SObXQNAJqpsF4ClAyYTXGShC9dHShSI6QxHP+Ou7QJgrdxhFidvOJ
	zyb/GgHfuSbv0OijI7OzE4z1kDj9F5oqa3TA9PoEySIY6vw/UkuykRgj4Ql1Hj02raKPJZfylt/
	9x29omX25wyY8VvS3Hf9tbR6gQnRI05ZEc/cwUHCszlHVT4D
X-Google-Smtp-Source: AGHT+IEV+lCwII9GhQtPHGVDcjw8YXVvBkkja75sRJDPkHKdd3G9TROtFMPaXK5/0cUjj2j8hg6M5JXiMBNm
X-Received: by 2002:a05:6e02:1c2e:b0:3d3:fd18:4360 with SMTP id e9e14a558f8ab-3d5961854a9mr39970815ab.6.1742846783185;
        Mon, 24 Mar 2025 13:06:23 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d596095834sm3865285ab.40.2025.03.24.13.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 13:06:23 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 29F58340363;
	Mon, 24 Mar 2025 14:06:22 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 2180EE40ADF; Mon, 24 Mar 2025 14:05:52 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Xinyu Zhang <xizhang@purestorage.com>,
	linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 2/3] nvme/ioctl: move blk_mq_free_request() out of nvme_map_user_request()
Date: Mon, 24 Mar 2025 14:05:39 -0600
Message-ID: <20250324200540.910962-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250324200540.910962-1-csander@purestorage.com>
References: <20250324200540.910962-1-csander@purestorage.com>
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
---
 drivers/nvme/host/ioctl.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 0634e24eac97..f6576e7201c5 100644
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
 
@@ -212,15 +208,16 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	ret = nvme_execute_rq(req, false);
 	if (result)
 		*result = le64_to_cpu(nvme_req(req)->result.u64);
 	if (bio)
 		blk_rq_unmap_user(bio);
-	blk_mq_free_request(req);
 
 	if (effects)
 		nvme_passthru_end(ctrl, ns, effects, cmd, ret);
 
+out_free_req:
+	blk_mq_free_request(req);
 	return ret;
 }
 
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 {
@@ -520,20 +517,24 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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


