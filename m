Return-Path: <io-uring+bounces-958-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3D187D052
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E60A1C21404
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DBAE3F9FB;
	Fri, 15 Mar 2024 15:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lNdJ87nq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6A93FB8B;
	Fri, 15 Mar 2024 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516680; cv=none; b=Y1olo9I1GtVK0cOaLIGAEiZv+uWuO8jiT2ItbO7oz+kkyq5elQv9pyzBgiDUnjUJcTEI2jD63KhzP57eCVwpU4uKiwK9WOhiH57hyZejaZcZ5dA9a9BVLnJi6h6miYKYJvbov5iLC5v61ev1etXpTpqAev9LNKI/hyrG993GxS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516680; c=relaxed/simple;
	bh=m132cIT+AJFfgzdRRIrfI6J6BFJk9LRkNt+dDeqcOLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnUs36+PYo75bwcdgH+63iUWrhd/H+RasnbVM9PPtY8hyapXNY/bkpgaO6JdDqYvDyviqcbwntjlVnxgim2IO3N2nDOC6o2YJW2Xu8iz6a0r2iFzDKipDG7dSrJNoqYFbQM6LODbjo2yGfQmE0mTdv6cCjAbMm0Sy+k6aCx3DUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lNdJ87nq; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33e94c12f33so2010869f8f.3;
        Fri, 15 Mar 2024 08:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516676; x=1711121476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VXqszJfOgUziV1la4Q1uPQvBAycH5jxAJpYRpwbwMxw=;
        b=lNdJ87nqqAFN7pnBUIO9s9hfztp/5cDmb5zUzae9/pMwIEeeNTg+HLZk86xNvsrL5J
         A4WqXNQ0DjPBVK17f6MjD5pEjmlYowGHqvRGGdtpagq3ux0pswjxZbiHi9Kkc7je4CKD
         MxozrGxVgEN4sLqndseB/Rj7VHybwXKRCM1QIHn42BtUGOWU5NMrbEe6w/HPVWz3Y+I8
         YUCI7PoBH28WG2348BNoscdwAS0GGAAM1hfsF1FMKkqVjE43aYIN5vOQAedth6mKyJc7
         yKxrN2ufWK3uLY+DxwBIAX7GU5d5L0IPmV01p0PwfexFqfZV6bRkCAg+5ME62lvOES8v
         R/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516676; x=1711121476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VXqszJfOgUziV1la4Q1uPQvBAycH5jxAJpYRpwbwMxw=;
        b=WAq6VteD4o34NwxERjhtT3OBc3B0StrmjNoeRSvd78awuJsJF1tEep+pZvqlcEytbv
         tPGSJ057yaXbc5cX2Orj11HIPio4fl56rOM+S7G295mov5BWgRztRWDFwzq5j+986l1E
         UuoAVdAuEmYQjfU5PmNFvfaAHCVSSTVenZeFudgF7xq4m28zeF88CfRf8m7DtDoWMIk7
         A2q4dKChBEDWFFrXFuk/fdzsn1c6/+7EmSg+lkl9z3U0UeJGm+5cmn9Kx0h2CNk2lhPg
         Cd6p69NMa31k0sRfLlHSUuvB0HOUebOgzogefHU3Q+RhiqqlCb9CYuntCI6ZKtzElgN3
         uzeg==
X-Gm-Message-State: AOJu0Yy8zYWGJjZEIGwPPDc6VtYBcEJ0lj+/iM1OuIMKI6idGCrXwn4D
	W5/87ZiwGn88DRTrdDsoFWZBUaKJ6HQ9vvYkDH14B0c5h/Mtw3V4kB7psJQF
X-Google-Smtp-Source: AGHT+IFl30KyTVkxfCFaaFzBLjCH1fgF0JuRtqETr40GsyTlhNlAXQCR+lE6/d6/8kbeCgFCxY0vgA==
X-Received: by 2002:a5d:6384:0:b0:33e:c99a:ce5 with SMTP id p4-20020a5d6384000000b0033ec99a0ce5mr3586174wru.70.1710516676608;
        Fri, 15 Mar 2024 08:31:16 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 06/11] nvme/io_uring: don't hard code IO_URING_F_UNLOCKED
Date: Fri, 15 Mar 2024 15:29:56 +0000
Message-ID: <c661cc48f3dd4a09ace5f9d93f5d498cbf3de583.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uring_cmd implementations should not try to guess issue_flags, use a
freshly added helper io_uring_cmd_complete() instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/ioctl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 3dfd5ae99ae0..1a7b5af42dbc 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -426,10 +426,13 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	 * For iopoll, complete it directly.
 	 * Otherwise, move the completion to task work.
 	 */
-	if (blk_rq_is_poll(req))
-		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
-	else
+	if (blk_rq_is_poll(req)) {
+		if (pdu->bio)
+			blk_rq_unmap_user(pdu->bio);
+		io_uring_cmd_complete(ioucmd, pdu->status, pdu->result);
+	} else {
 		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
+	}
 
 	return RQ_END_IO_FREE;
 }
-- 
2.43.0


