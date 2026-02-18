Return-Path: <io-uring+bounces-12309-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IcvAHoqlWm2MQIAu9opvQ
	(envelope-from <io-uring+bounces-12309-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B37E1152C3F
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 91768304435C
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14CE2DF6E9;
	Wed, 18 Feb 2026 02:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PC9WypkK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9CE2DEA89
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383411; cv=none; b=H+BTArwrcPYflyWZVOttz6xUDbDtpaGljwt/e8xZbhYQoE8Yw0GCugKr6fcjRvxQ8CvZY/ja5EQuXWULHR9TR07uhrMdPAXj5tPNY9Oi0MkbyimcqkVS/wsiwHCcqwjUpXhZZ4KBXTZC2tiXUv9lFFqYMPeRDNI8S++/np7I7Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383411; c=relaxed/simple;
	bh=YOKLjYb3aosVgKUH+3EKnfo2DuR5P/YMNSMFB5BVVSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2a0YQGAwSEaaEYP0jjEPR+4PTameW7xY4DPGh7WOOBXASP0+kGFNCxlB4PuWJDkhFtYEFm3cV8+RbHQCCGwFp8owwZM1MiIdMCFTdqeB/b212q+u/T+0TycKjcISohUlbxxwTcwOKU+pSnJGLzKd3sRONvuoMRHvUan4HSwUus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PC9WypkK; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a929245b6aso52922845ad.0
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771383410; x=1771988210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=35rUcLF1fMo1V5tT79EtOKmiA1OjiL0xPdfdOliHziY=;
        b=PC9WypkKrKVOCQO1WW+u3i2On6WFDYGU8CZErOjFFNLIgwtxXB41qSX5Q11citRYsp
         qoGMALD0vWm2rgUxmwFKPS3ZeHYwPhmtEYqtxl1sDx7i9etgZgZpKb1qVsOoCoNGAgKH
         +6oYNbcqTVuaL48Sf4CEMHGEH9Pq0YiQudxm7rLUYsdm6+V38pPkImBEqK0Hyk2bd6PG
         bIoJYcUyDq8DfY/m9NbAQ53QSzdNw5Tf6s7cpUySdUlMnsAnKwgGRxvLLPVmIvqrwFrO
         RPF8vGFA1+YR32515h0V6TBS1HUQAqmHGIHoWSDGEUGDW09OygkrD88JiAYFFzQW/+FF
         9nQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383410; x=1771988210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=35rUcLF1fMo1V5tT79EtOKmiA1OjiL0xPdfdOliHziY=;
        b=tv+jxch4P1ZbZM+cQ6Fg7o4O0WwSiwyHkOzLnAjKlAbMzvjivxD10QASLxIbFElYbq
         DWADScX6c2u1dBLwyWDWcCAnbIzRq2g20+WSmdZnCYu9kwcCNfYFj1nQ6QN2D4cCeYUp
         9u+wSub+RE03Av4jupNNyPRJ8Xlz4ZPRiY2Q0lOgf9RVjntUJmTn5vR8o4wX14T2ML8w
         n2nDzP5ZWryvdIlkTpVVbQpRntDd2qrIAoWcVgbtAgg/yYxfz2KVuXgv2k7XH50TaqOP
         RBLqsgYnnjYxKe52HCYnfbQ5zlI3/o4gCFXPZDPLhAtq8w+lgVNMCkGOSxKxdTpPhRRE
         0WRA==
X-Forwarded-Encrypted: i=1; AJvYcCXothWdVvgQFVa02zyPAY4ezw3hKTAkpcXuO3S/CKv0vd3WJilbZo7KC5hye77140wb4pqU92F86A==@vger.kernel.org
X-Gm-Message-State: AOJu0YylBV+otiN0apVWHOeCxVvXFoJLg64uThuL//oBQHPjjbGjrk1J
	WYlLoWKVeyKxlDTv3NMEqusDX/74hu1zNhCDzyQbBz0RmzJpjS218vvW
X-Gm-Gg: AZuq6aL2jh2J+6EhBU0RCL1J05kKS7xkoykE7mIouWwAhyVPNBEfL3fxZtWDImAVbEv
	oJ4t/vMgs3niiQ7Uiv7wzsZhSC14jcb7XimgOV3+XVAybP5tMs0cQkAoD99Rs8LDxhrAx7uBXpf
	r9y1k4YyPXiIbf2rX5KQFfeWM+bX6KH2HRJWmW9LMIrex9fRNrXBXT4IkrgVrMzv9k+l9Agsq5a
	T9XnhOcj5Ymj6ZRlFKSxR7fFEDgVf/Ov5PPzCeJgr2+s4WPiF70mXBJ1+emxg+3y8cjzi8nA4VF
	nm+9G9uWyedwpC6hDccG2rdZFwM28RGDoAjiktEPDKluGIb+YuXMBdeSszmFmOSFayJOkSL31qt
	9vL9JbDjAeh3GsKGgjqFU4g41hwlQHL9+7PL81duubwT8PiKxoJ4iR+QWi1j5FfETLr1VUiZtD4
	o8sj+GPpejlpl9pUyV
X-Received: by 2002:a17:903:15ce:b0:2a9:410:2413 with SMTP id d9443c01a7336-2ad175018a6mr129517845ad.29.1771383409822;
        Tue, 17 Feb 2026 18:56:49 -0800 (PST)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1aaddc33sm107859015ad.75.2026.02.17.18.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 18:56:49 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com
Subject: [PATCH v2 9/9] io_uring/cmd: set selected buffer index in __io_uring_cmd_done()
Date: Tue, 17 Feb 2026 18:52:07 -0800
Message-ID: <20260218025207.1425553-10-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260218025207.1425553-1-joannelkoong@gmail.com>
References: <20260218025207.1425553-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12309-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B37E1152C3F
X-Rspamd-Action: no action

When uring_cmd operations select a buffer, the completion queue entry
should indicate which buffer was selected.

Set IORING_CQE_F_BUFFER on the completed entry and encode the buffer
index if a buffer was selected.

This change is needed in order to relay to userspace which selected
buffer contains the data.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/uring_cmd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ee7b49f47cb5..6d38df1a812d 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -151,6 +151,7 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 		       unsigned issue_flags, bool is_cqe32)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	u32 cflags = 0;
 
 	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
 		return;
@@ -160,7 +161,10 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 	if (ret < 0)
 		req_set_fail(req);
 
-	io_req_set_res(req, ret, 0);
+	if (req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_BUFFER_RING))
+		cflags |= IORING_CQE_F_BUFFER |
+			(req->buf_index << IORING_CQE_BUFFER_SHIFT);
+	io_req_set_res(req, ret, cflags);
 	if (is_cqe32) {
 		if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
 			req->cqe.flags |= IORING_CQE_F_32;
-- 
2.47.3


