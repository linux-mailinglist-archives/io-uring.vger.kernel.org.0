Return-Path: <io-uring+bounces-7925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A25AB11ED
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF36D4E2767
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F34828F528;
	Fri,  9 May 2025 11:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVvfSMmp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF4C27AC2E
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789110; cv=none; b=s7ZMmfAMpdPAWrTo1xvcg4F52ztWad8LouPxRbttoS2EqHLwIquQBSdoN3lhqAukgTHp9VBT7OureAB35HDU+eMBRB5FI2yqp6cnYFVDQSke0VgYdkfPfW+qWvts2ZJWDNJYZWer9zfeHsXsrMnmktpQFQOPqP5i62obFMR3mH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789110; c=relaxed/simple;
	bh=XN0r0NyNlm/UAWa7ZakD5NZ8FRDoVwWIpWXb1+KuRZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9uQvrrscja+YUnhWI5Jzt0X6zJx5dZYON2K/fTfFBAgPtA7st3pz18q4xe4e+UT+ZhW3rPB8PgTWWv4p9Y8MaegItxVeeMm0RQTj3Y4t30cYl8vu4HIzQb5CgnoFV5hkpCZ8fEyDBhlMVv5UeVS2DmslqJEh7FLM9brjCyXxQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVvfSMmp; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so283679566b.1
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746789107; x=1747393907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9+6uuG5M9ij9pbEKhi63e1xiDU5FhwaeSPxU7wDmzo=;
        b=AVvfSMmpgTh842t/ecdkSN6PB6roNbxt7pVmSfQox34pbhLa8nFcQDQjG2SjN4Hhue
         YBzT4CdR4T/Pcesr6RC9Uf6/aZMyo6PgoyPIyHSrve/nMYctjEDrtAQd6Kf80PcD3v/h
         dDvNFBsXuj3IJvIuMUY38gu8g5V/vsMJRWXfn5fnB954bwvp0Pl3C2kEKrrFWl41RiES
         aE1WFEA91r6MhVX1l/ZquJvp5s1SAZ5flDrZNWGxymtjH1nCR4PzQSYhyy0aip9h17R+
         K8ZcEthNPygYw2PuO2FldmfD0YUD9J8yUoF+x5C0yDmQDvN0B0s3t9Zk8UdWpGfEUBeE
         f68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789107; x=1747393907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9+6uuG5M9ij9pbEKhi63e1xiDU5FhwaeSPxU7wDmzo=;
        b=r/tK6+nCBFdLiEttM8wsylEKS9DQlWdfFdbl05M/KoizOHtMjkj5Tpu1qYSDT88KSW
         0dpfmwG4HK9RQmDaSASPZFu9rdSchOHwcQfSKFATHs423esCr+usXck476EU6wSTt+BB
         jNE+lwdpntJsZlC9miRQt3Gsu7emd1S4gbRHuINIEZaRsA17bBuszvp4nHMTlgee6DMx
         khnBfKVxcbULdB/uLBRacQdojjaHXkUMsn8eSxCF/dnjn1VKZ2/CBRz09R+ECN1whSDq
         ZCCXuEOiKDh8aLaQFDYHyhMra4jsdZ/eBeJE7TQK4xs+H/ipcHvCz35NYiNHpN7vxS7V
         ELlQ==
X-Gm-Message-State: AOJu0YxMeMQeyCditt4wdh0DrS2ZJ3LkmcHI9lsuGzr+u1LYYbh3WhIA
	PrROZOmFE2IW/+8r/klyBrN7D5P4O5SlOTyB27ev8yDcLbdKzfOatrZorQ==
X-Gm-Gg: ASbGncvwTmcsTPS5K0MibLgpqH55L+3iJ64e3FuNar/S0mTLXMZM5GBevtMEE9uMgyS
	Qy4aSFdJffYEss4XlpbXNdUf7RNnOuzys5WgMT4rY0Xp2X9elHQ1h2X/3sCJgjZKpEk122DZaXh
	Ujx8pd1A01znr7If8mlPQZiXPeFlYAGdoHBn8dA+ZvyGEKuiYmCYaDjTuq6WXRQxgjuCELHHggx
	N1MgKIf2nYJjpnlnkpRMtMwvpKBLPxW4W1zkAEmZ66r2kzfIkXrqGs/l3f3oAIySonHYiUKN5ah
	j1jGHOxaTlaJt+y7bhWluOU5
X-Google-Smtp-Source: AGHT+IFqrnvjJ2X4Gc7h/dgGC/mOZ7JG1oorVMS0z+LYPxNxLrUaKUD+KtLlDUPuVHRLMbkSuPZjZw==
X-Received: by 2002:a17:907:d8c:b0:ad1:7db1:82be with SMTP id a640c23a62f3a-ad21916b042mr276748366b.50.1746789106435;
        Fri, 09 May 2025 04:11:46 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad219746dfasm132717066b.119.2025.05.09.04.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:11:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 2/8] io_uring: fix spurious drain flushing
Date: Fri,  9 May 2025 12:12:48 +0100
Message-ID: <972bde11b7d4ef25b3f5e3fd34f80e4d2aa345b8.1746788718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746788718.git.asml.silence@gmail.com>
References: <cover.1746788718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_queue_deferred() is not tolerant to spurious calls not completing
some requests. You can have an inflight drain-marked request and another
request that came after and got queued into the drain list. Now, if
io_queue_deferred() is called before the first request completes, it'll
check the 2nd req with req_need_defer(), find that there is no drain
flag set, and queue it for execution.

To make io_queue_deferred() work, it should at least check sequences for
the first request, and then we need also need to check if there is
another drain request creating another bubble.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 23e283e65eeb..add46ab19017 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -559,18 +559,30 @@ void io_req_queue_iowq(struct io_kiocb *req)
 	io_req_task_work_add(req);
 }
 
+static bool io_drain_defer_seq(struct io_kiocb *req, u32 seq)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
+}
+
 static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
 {
+	bool drain_seen = false, first = true;
+
 	spin_lock(&ctx->completion_lock);
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
 
-		if (req_need_defer(de->req, de->seq))
+		drain_seen |= de->req->flags & REQ_F_IO_DRAIN;
+		if ((drain_seen || first) && io_drain_defer_seq(de->req, de->seq))
 			break;
+
 		list_del_init(&de->list);
 		io_req_task_queue(de->req);
 		kfree(de);
+		first = false;
 	}
 	spin_unlock(&ctx->completion_lock);
 }
-- 
2.49.0


