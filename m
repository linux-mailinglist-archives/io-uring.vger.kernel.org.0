Return-Path: <io-uring+bounces-13073-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gAaGB5w552no5QEAu9opvQ
	(envelope-from <io-uring+bounces-13073-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 10:47:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B3734385A3
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 10:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 45DCF3025A7D
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 08:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21848331203;
	Tue, 21 Apr 2026 08:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hb+AbxVq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3ED39F162
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 08:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776761199; cv=none; b=Mh773RiTWtnF7W/8tDS5etfihJ18I2wVOI7QdrKC1ZYEptl/vws5Hxefp3wZL7pB2jo2LIp9gesLz7FMRXcw8CWbRfp9G2mRVtBQz3bvJr2UaVABVC6YlRHmACZUqPtxVn6II06/MG1IPEtX4UflD+XsxPcg98WE5ckvZa95Ebc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776761199; c=relaxed/simple;
	bh=yVzKSHrANehfDCDinh6d+1e0pJuxqNrZJzOMT0E0RD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UYXK3wkztfSMAcPJb516xmKniFyS8gj03X9gZP06L9517inJjaT6ICD7Bdmx5shBy28Rfft5dxAWMOFhPMlT5Jq2Z62A5IMBWJnZgsM8Sbly5p1INo0OQ/0c8Zl+GEfWEGfhUYgQO3fWQvRyzNyXMxKU9NF+5k+2twAvRslBlJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hb+AbxVq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso45038975e9.2
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 01:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776761195; x=1777365995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8BymWAUd08dVn3S+UEnNA1e+mRY/CNs2bFzH3MHHZGw=;
        b=Hb+AbxVqs/bPxTz/IuMqK/VJRYwBNkLzDxgnFKGTZYxoi9f3VHZOiYWV/NrhyZU5rW
         DsIsgQJ5hTCjnwZr//bIEzHLgK856495ai8Sn8X8Lgfz5Kvs+44L+eroyqBtk0M0L83C
         mmO5rPt+eTjyYpXmymdFUGgmRjr86klwqu1YLlXS/YyYHT32L6wjfItuFV49IvytpNvK
         gyXhNJGVLjikhf/OO/UjKkC/wkUFDjH3uDcVjCB4irx/7ZHFCYJMAxDgR35EAQme47+a
         5sznFFwUjFAo4L5PwxK4UZXzfM+X3yK/IhLyoOPDR5BdFkLce4y/7XIQXUAF4Ajhp1c+
         sraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776761195; x=1777365995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BymWAUd08dVn3S+UEnNA1e+mRY/CNs2bFzH3MHHZGw=;
        b=TsnHc26zp6QQvkxzrxWakchqVOdpcelnXuJQe8NYnhR64wq7oHQ1giu76/FIweaj8q
         ut7/tlTgq760hTWajde3S5dWYT6mpZsOoy/h6W8UBOfrruq4mRhfCElnSMx1pD6uH2G/
         qlEBe219SGGYcgKVxwFPejHHVnLMOuOoZ9ei7nUbfANDMMc1Pc4iqts8JxKRu1ktpSaI
         zkZctZ6AXm2jvsSDCceM3E4SV3QVinCJE+oCZzZ7gWxMELvEcrbDPgf6mdjmM2Dc5bPZ
         DDDWweZlVqpd/9htd96vpp/uvMCghHX6jORy4HS8mM1XMs5JyC44sJGjRoODRUATLPGW
         3MWQ==
X-Gm-Message-State: AOJu0YwBIcr3rnEtIZCQIKhCgncy9GXiXT+XOFc4kh12B2a10/ZOemn9
	+bzUJCHuO4RYCSv5naLmfo30WLlq9WpKBjo3PicnVu4RFzFmfaQLBEphtLThFw==
X-Gm-Gg: AeBDieu3BoPqLBWUsoiyjm39tpW+1wkHrGBRF7PHGJNtOSYU9vprUSOLko+Y2tmYDMi
	X4fVCyzrE1pUUcfYP651uG8ebT+9vKLPiZ3RDQhMdQ/vMFJ4O/NmYz4w8Sw233hAlTVHtF+svSp
	aYq5MG4NHHQmR28VctRAoDYDYEua3RKxVj5KTZbcQDmpR9BAWrEEyDx7DMYfTggxmSCD6xOa1fb
	LYjRKYQjozrItdEuRQxkqqIRCJ2rFf2Lco82T6BzYoSHgo6syXy+TMfJ4C+0ElUQ6Gi6qjWYvku
	/NkSDMNbXe6yg7l4Uwv0X/elaeUBaqvv6rrPiY+03wyj9MR5wuY6IkdgRKbkhuM76tr1votrI5w
	c+MYLxOUF6aJE5Uuhliolm49Jf+KvJstT4wLoGmO+aZtqS3Q+wXfTlIhGLdpWN+2Xw5n0ed1C7N
	kN6hwVB7t4jb0WVWbLaTmJ+JV/UIkX9F8ewS94tFuSQX3dJmUBFL3mJZEjpKS0kBCJP58A5wPPP
	uM2rrjDruHVbAtUA3UV
X-Received: by 2002:a05:600c:4fd1:b0:488:a824:fdff with SMTP id 5b1f17b1804b1-488fb782a04mr245724595e9.22.1776761195432;
        Tue, 21 Apr 2026 01:46:35 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:e3a7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a575d531esm2745735e9.13.2026.04.21.01.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 01:46:34 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: clear RQ headers on init
Date: Tue, 21 Apr 2026 09:46:44 +0100
Message-ID: <331f94663c3e8f021ffa3cb770ca2844a07d4855.1776760911.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13073-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8B3734385A3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

It might be unexpected to users if the RQ head/tail after a ring
creation are not zeroed, fix that.

Cc: stable@vger.kernel.org
Fixes: 6f377873cb239 ("io_uring/zcrx: add interface queue and refill queue")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index fab3693ecb0d..2eb09219f0a0 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -396,6 +396,7 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 	ifq->rq.ring = (struct io_uring *)ptr;
 	ifq->rq.rqes = (struct io_uring_zcrx_rqe *)(ptr + off);
 
+	memset(ifq->rq.ring, 0, sizeof(*ifq->rq.ring));
 	return 0;
 }
 
-- 
2.53.0


