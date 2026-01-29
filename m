Return-Path: <io-uring+bounces-11973-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cIKpDqi/e2mnIAIAu9opvQ
	(envelope-from <io-uring+bounces-11973-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:14:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E3334B4310
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:14:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5EA8230158BA
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 20:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E204333C53B;
	Thu, 29 Jan 2026 20:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LmV+caMx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208D1336EE9
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 20:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769717666; cv=none; b=Dz2/bAiM7smSUYuNr8Qe37UxLffHElrcHVrDE5syNcOpic3YXHwuLHryC20hQoeYLBVi3xvmsdeSGM2EkiJwWNt6zLmyhWqSglEn1EO8sl+O8ID4Osnf2tfBojIOQR8D5uIB9mG5IcDiYRvjLwHIbkKHm+0dG/YxaGIU1zgTcHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769717666; c=relaxed/simple;
	bh=Vv55xAOarrhHgaHJ1FmvETv6V8HnjH8gXVjOOEXfX5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVHsZuaBDxhtDU2CzDymisJCKPs/Xbr/fKEGPH14rCLpebpMczn2jwqd5hmwck1T1ngjvqk3pZaHHY4um+I7Nv9BFzFhDOjv1v4Q5JmpLokDCPWacsV+8JGAS2hleJJu9ShVxob6ocIW8zX3JRWQUqIwrrFSERHRS34ZuxmRbSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LmV+caMx; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2b7381d2d95so824001eec.0
        for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 12:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769717664; x=1770322464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otDq9I4fRqizsUlW3G3qAV/fLDOiN4Onc8BT7sPAqIU=;
        b=LmV+caMx7DxJY/c6T69Sqjwo4gnY19DhJrjUrpIuOqKs+fZGKQIJOPXPQ2Z0/haGjv
         Ems02wBpwXx4TXjUVl2J0E1g4ugTBQXuVIPezZYIFD4jXkezqayogOW2byjZEKbX1hUE
         Pt8g7XR/RdkJAsle0albB6PdlPInWnBi+0mT0mSVjLTq1diz8k7w/uyZBLkOzyoJ6Jmj
         LnYZseDsNIcvT9s5VjA52JzqkvEQdilro80dvSHl4E3w8AZjzMnZwTkEPddJVuPy/nUy
         6CvfKVmNKo9ehK3w0DlWilPOLvXENMQvpzAfreOjFJ28R2X3lWXjHzGvh36zZrzRe75T
         MGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769717664; x=1770322464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=otDq9I4fRqizsUlW3G3qAV/fLDOiN4Onc8BT7sPAqIU=;
        b=hOPYLSZgTAN5IkGZKB+KdIR4DeTohtrmFOlvtw0s6gZ1+EMJPfcK1o6rAdr50fhVyn
         gBSViKmA0wK7CVNDHzi4UnYDH9ZE2+1jz825affwnx80LcUD4XAKBtw0pz3T7O2noxYQ
         MKjIdCu8a66yW3sZ33Veprinj7x6Q/MgUAKgydJDKrwlrKU22C+TzMXWRbXEo2YExYjI
         62uayvhJ7P7RgEqXU6fNC9qlV/H5ub/+NzENNbkZ64YqcL1+hoCsnGrvTFnLzBz4H7c+
         fcBfblmDGQXkQ25D2z6uKhoJWkS4p4S6wYX2O0o4zucR2oM1u0kYp7G6XzeLuOXdLT5q
         4INg==
X-Gm-Message-State: AOJu0YwFjS1JRKVL2jDu/MzL01MAb4MT6OV4C8vkweASbjkcUNXD9NUl
	cavfxWTfA3wQN8tbTI6pJD1kTY208/Uny1qIfvZiGUoVyfVA5eZ7FYAy7QtCvw==
X-Gm-Gg: AZuq6aKktZC9v9kh5F3CrgojAJcu+LS+yKBXxIA/k+DbjEgdN3eLXPv239+ezS4N5VI
	D1vx+va0m7bzqiueJNvFeo6fLUWG5cxMTRcb8q47J3yzfS94S5otr68OwVkEjvgd0seVL3zrVmw
	IQiuQ2x9Hso4nuQi/34op0f8MB3iscsIAW5k0qlH5B/y+gKSaev5YyVgv7iJgbi9x+trbYcwP2t
	bRZ8c9607KyJhuGSM5AKCG/guRwb4eQMEUHHubPYAoy/NEFtM1xaTJtJxFLzbs/8Df9BfmXPPez
	1YsWUWxmHrwl5tliITRLYxxZxm21Ggnih5xClQOSx/t0L51cmGpe3s+MSuqo5dQabELLOI+2C2S
	KIJpg3YUU9ftUIRJ8hD88vp+V3/UT4/I5rsNWYYlyOCNYd7T+cmUrAHaf/tK6msyVTKVdyn57EE
	UrcOZsmN6EWPCfchIFlTydO1lH+A==
X-Received: by 2002:a05:7301:e86:b0:2ae:5076:b61 with SMTP id 5a478bee46e88-2b7b178aademr1695015eec.3.1769717663677;
        Thu, 29 Jan 2026 12:14:23 -0800 (PST)
Received: from localhost ([2601:646:8100:f8:a787:ffd3:9020:3716])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-2b7a1abe938sm8657106eec.16.2026.01.29.12.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 12:14:23 -0800 (PST)
From: Govindarajulu Varadarajan <govind.varadar@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk
Cc: ming.lei@redhat.com,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	miklos@szeredi.hu,
	Govindarajulu Varadarajan <govind.varadar@gmail.com>
Subject: [PATCH 2/2] block/ublk_drv: Validate SQE128 flag before accessing the cmd
Date: Thu, 29 Jan 2026 12:13:47 -0800
Message-ID: <20260129201347.411015-3-govind.varadar@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129201347.411015-1-govind.varadar@gmail.com>
References: <20260129201347.411015-1-govind.varadar@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,lst.de,grimberg.me,szeredi.hu,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11973-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[govindvaradar@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E3334B4310
X-Rspamd-Action: no action

ublk_ctrl_cmd_dump() accesses (header *)sqe->cmd before
IO_URING_F_SQE128 flag check. This could cause out of boundary memory
access.

Move the SQE128 flag check earlier in ublk_ctrl_uring_cmd() to return
-EINVAL immediately if the flag is not set.

Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
---
 drivers/block/ublk_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 7c8a23709efa..adeed0af1dee 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -5163,10 +5163,10 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	    issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
-	ublk_ctrl_cmd_dump(cmd);
-
 	if (!(issue_flags & IO_URING_F_SQE128))
-		goto out;
+		return -EINVAL;
+
+	ublk_ctrl_cmd_dump(cmd);
 
 	ret = ublk_check_cmd_op(cmd_op);
 	if (ret)
-- 
2.52.0


