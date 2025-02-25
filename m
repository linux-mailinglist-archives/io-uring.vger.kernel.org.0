Return-Path: <io-uring+bounces-6763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F8CA44EC4
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 22:26:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41645170B6E
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 21:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D24120D4FC;
	Tue, 25 Feb 2025 21:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="LxGYy4od"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f100.google.com (mail-io1-f100.google.com [209.85.166.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4821120C002
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 21:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740518737; cv=none; b=PX/7kGTcjW0NLYracMNIDauG5t7G8bJySOl1S3/TsKu88uHGXhpIUvlpcGPcMqF4u6P8eAzuczqYL6BgsmxngoCQxo8vP2vfdD0kjXH6UvhyrST0Q+9yweMMZADSdfLZwkerVJqg0fKUC6d9LUHGOA4OAS+fT8DowMwF0bLYLis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740518737; c=relaxed/simple;
	bh=6GRv5GkkmkDW85ilHWxPO1Q+hLJLxbHbMJxp7x7FbEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IgU+Rm2JYb5B8+rAPsI9Eb6dCzocflmX3pFlZnOiNiKH7uKiMs1Kja+qMkWJ0fs2Baw2WNAIf4nHoSAO1QIwcraDtP7hjtWlwV8sfr8m+7eNpF2tcfXIFlkQrWaeL3GVj0aB5fVqDzoTJiLKCjNi5XOU5LWTUNr2sCaeKUvexEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=LxGYy4od; arc=none smtp.client-ip=209.85.166.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f100.google.com with SMTP id ca18e2360f4ac-855a8275737so18605939f.2
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 13:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740518734; x=1741123534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b9HhlrRcc1S9btnxpNw0XGFY9bznftGZITEbOrMrW6Q=;
        b=LxGYy4odxGdpSe2QcnA2MHBd6dOEtHKous/iy3PhvIuqR4dEgDHVnLinQJ/IaP964I
         sHravzzx6YjLTO8AIgj2aNxD6h+GTwpFakVwI3BAqOxEBqnE2bKAgMzbfpe7nWA7/CpN
         HjNcOvgTcn0gnpEX3moggoJLDIDgQFjyDIABPceg1QBUusRTnBW4f6DbjnC5EPCSX7L6
         YL19jXFF0gsueFzsgpEh87iQo2UjQ10zr8AOU6leiN1KgYJ7FtoIc4cGKNShzfAAh9Ge
         vcMsObQa4eZZtpjhTZ9GmNqlbg8p8LplTUD1yz51X8929fmncL8K7h/PkKMaYlbVUmIu
         F2Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740518734; x=1741123534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b9HhlrRcc1S9btnxpNw0XGFY9bznftGZITEbOrMrW6Q=;
        b=W7Xk9LIp7WeGZ5q/gWLrRtyv5TUXQL092Cv02J+40AHXJzZUk2wrREBEnu1crv8wWh
         cuTECmVz8e3Qon9Dox2Rk/eVRMazTJ+nmFpx5JWaJK+vZP4Q3k70/Cyre7UOwqqbKMQr
         GLgV5apWx1eZQ9f74A70HxDr+DfMm/U18r6Wx280WtnMRrZW3yB2zXUKyUNcYtn28vPu
         PPABJZxXQdsGTVUoVIBwuOnIFcA09JWukDkc0qD14fcijPdWRFtGb6BXOOwIjH2JcgE/
         0Mge6qOkkAMo/8UWLwqOpiUOMeXJDXTEw/83Tn1F5yb3/CQRMWk05C4vy6+z3vvQGsoF
         GNKA==
X-Gm-Message-State: AOJu0YxUAhh1j5em9PrmwGglgXhjJS9foz503yK8CsQ68WNScZY48ijU
	YoW0zPRDrgxpf6cnvNnBqyg/JisEg6hDal/zvCmEQ3lL+1fJ5ZsaECXfYZjQqyflLQ5ZrCx9dCy
	5pW494/ElnTVvbAj/ZnIMMVwYIaO/CYV6RIa20/hF5NPZPwbO
X-Gm-Gg: ASbGncu99/vTi8EBpU3pT4FdLenQFIPum7nsWEHty7W+adcEHOcayvJJ5mEPsBUBgi8
	EA4n+44uDppvsFslFHXB+rop2DHmB2gaEcfzNyuh5BXrYUVqv+fmYxI+9WKE48NMHJfzqIE/cBD
	gcdPFvUIqwOCR1NtAar/qr9rdAz8fJBh7+AhjZW6PD7IPmAQiq8Qpn1bAPSG7BL8vQZVmARHabJ
	uHrjuJ8Z6CcL+HpYQLT1qlXS5qtPqLFvzLeTI2SfnxdvMRP3eRBw4fJgUC2bx0f7kFcMIBznqy5
	YABa6Tpdtpu0iiOeAq6XZcGBQ6VL9qK+wg==
X-Google-Smtp-Source: AGHT+IF8UXXeus5YhJoPJknmXIZkIyvq5oCcWhAwt/3Kp6Y5QgdoVWzlq85YfoBZmVtowwISRWeJmt6k6Kb4
X-Received: by 2002:a05:6e02:1646:b0:3d0:4ae2:17b6 with SMTP id e9e14a558f8ab-3d2cad72c9fmr50961595ab.0.1740518734315;
        Tue, 25 Feb 2025 13:25:34 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d361652f36sm1306645ab.26.2025.02.25.13.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 13:25:34 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 676CA3400EA;
	Tue, 25 Feb 2025 14:25:33 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 62B3CE4144A; Tue, 25 Feb 2025 14:25:33 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ublk: complete command synchronously on error
Date: Tue, 25 Feb 2025 14:24:55 -0700
Message-ID: <20250225212456.2902549-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of an error, ublk's ->uring_cmd() functions currently return
-EIOCBQUEUED and immediately call io_uring_cmd_done(). -EIOCBQUEUED and
io_uring_cmd_done() are intended for asynchronous completions. For
synchronous completions, the ->uring_cmd() function can just return the
negative return code directly. This skips io_uring_cmd_del_cancelable(),
and deferring the completion to task work. So return the error code
directly from __ublk_ch_uring_cmd() and ublk_ctrl_uring_cmd().

Update ublk_ch_uring_cmd_cb(), which currently ignores the return value
from __ublk_ch_uring_cmd(), to call io_uring_cmd_done() for synchronous
completions.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 drivers/block/ublk_drv.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 529085181f35..ff648c6839c1 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1864,14 +1864,13 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 	}
 	ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 	return -EIOCBQUEUED;
 
  out:
-	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
 			__func__, cmd_op, tag, ret, io->flags);
-	return -EIOCBQUEUED;
+	return ret;
 }
 
 static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
 		struct ublk_queue *ubq, int tag, size_t offset)
 {
@@ -1923,11 +1922,14 @@ static inline int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 }
 
 static void ublk_ch_uring_cmd_cb(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
-	ublk_ch_uring_cmd_local(cmd, issue_flags);
+	int ret = ublk_ch_uring_cmd_local(cmd, issue_flags);
+
+	if (ret != -EIOCBQUEUED)
+		io_uring_cmd_done(cmd, ret, 0, issue_flags);
 }
 
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	if (unlikely(issue_flags & IO_URING_F_CANCEL)) {
@@ -3054,14 +3056,13 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 
  put_dev:
 	if (ub)
 		ublk_put_device(ub);
  out:
-	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: cmd done ret %d cmd_op %x, dev id %d qid %d\n",
 			__func__, ret, cmd->cmd_op, header->dev_id, header->queue_id);
-	return -EIOCBQUEUED;
+	return ret;
 }
 
 static const struct file_operations ublk_ctl_fops = {
 	.open		= nonseekable_open,
 	.uring_cmd      = ublk_ctrl_uring_cmd,
-- 
2.45.2


