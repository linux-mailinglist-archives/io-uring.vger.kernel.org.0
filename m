Return-Path: <io-uring+bounces-7351-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 708FCA78254
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 20:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E20A03B04FB
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 18:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89EC1DDC28;
	Tue,  1 Apr 2025 18:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="tnvEoZUm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B4053AC
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 18:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743532097; cv=none; b=PQIlGBERUURDTjLGd0HE2ZM7W6QLBsYSgsPt6gPly3AA+VWkNBN4or4reERJYPreZ53xjaEKLnjfgamDn4DzJHDkK0Z4bMqWM3ntQKII4v6Le5brAfazZUKRdhbpgCWT6uKFcjGKQvR3I5XcuuN5NisXAtpymHc1w6+OBgrvEPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743532097; c=relaxed/simple;
	bh=Vb6m1haOVdLUQDC28cbQ7vtY9ObQc9KxpRb2aRg3AsI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uzsX6RtJ9NSV5w3Dl/KBiCd5fj/wLSd4420mYklzy7jag6dclXHCGwdisyRDoONn8wKJQTDa1HbMYNchiqLNa0WnTX5mg20qEM2C4pHoTE89fNm0dVnh2vZYTfbrQJXbA95PSDDLI/ClAA3W1tfYEmp/zQFuz+06qZ8TGOQ8DsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=tnvEoZUm; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2264aefc45dso147124825ad.0
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 11:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1743532095; x=1744136895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eRkj6RUzeTj23+/IVRtkfKCPvZ39BiLFkXmJnfC4LMw=;
        b=tnvEoZUmTbAVwjdlews7KrYWvDthGYEvtIGkwk4ck56uZYH5raZWsFmtm2id8pfSLR
         QeyC1fWIJiAWr8yZXC7DXk1iC/jpLaQSPKDTsW97SmD3GXm9lLdTgWPuKdE5jjZPMJGl
         o1rR6qQqIu/ftqtAHVq+Vxblzb22/5vbxEwsgiwpJGuo+pMJcaXl7asMzSOcNigsXUqw
         v+kOY3YxFNIKWoX0OEexbSrKy1sIg/wfcQSGEy4MKiU6l7nin1P+SISM1Hpe4NfNXjQG
         FP5791sL7O7jwhxUYqvRnhuC1SVo8dnR1s2GSnbCkCdsmTpayeKtOSYUWa16t1yw17cB
         Wrrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743532095; x=1744136895;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eRkj6RUzeTj23+/IVRtkfKCPvZ39BiLFkXmJnfC4LMw=;
        b=loBZcWhm2bAepCvjwx45+Q1OF6Dk9djGUG0JDJkTVMaGl3hCZHOtatpwKozNaACCHT
         BwwlMEZr+An4VgYwYtDzZcHCZVCKwoQ/x/cVk3bdayiaGmqccLGajF7sFyQmy/PcWFCZ
         1m2/qdMyVRP3Vpy4uVqHkrC2eGbs0KTZhEGS4nH1k4Y8gg4Qc1W8EAbw5d+ycjFgN5NQ
         z/Rvvg6ACf7pwTPrYt9e0Lf5UQ8MINDV55Y6fLmGuDRrzwBDP0dwXO2hTBsaYcVM+i/0
         alinknIbo5zZrrwJw/1kDLeksX7zE0PXjOKXjSPEvMWnIer4mwtzOPUdjJNAoEnBRb4N
         oiFA==
X-Gm-Message-State: AOJu0YzwDR8sxep7pCKchBkp5XwjKtO4PauAhn5e9OuJ0gRMt9o60Muf
	Jak0ij1YrlemYi5aNUzubhtJJLlEnUywOp5P+ca4t3Wb4tGJ1vzbXYDK4ztuUjIvzLNKSLLqesU
	5vOo=
X-Gm-Gg: ASbGncuFS5qWDOvIuLO3HxlaacxrubWFu15OSBeH9q209TAOGDBAkXpfCGfUIbrzFv+
	2UWWteKEVmrzgto/DIvB7QXPtRiT1BbYjv3Blrix+Mq+vohg77b0tc/WLp8mtl58Efj1enWZjAs
	9F7LwlAAa3kr1MOUZe7oLWTqoRIPzFhOITMtqon2aeDK18XhoLMI3rX6KURmVQLpozLVD5289gK
	tdgUyuYBv9OTzmjShH36LKFuJ839MREXXgaJrgMulR0HVn/HFP83GH4FrqVTLFwX36kv9OIxKsI
	+REZ8i/nyCnDl5UNYJe7qFffz7DTew==
X-Google-Smtp-Source: AGHT+IE5a9eHC4pPdYHqOAMbtSXQVw2XFVqnJqoXYy8+4ztXHU+UyMnvRa8WeIHSCXeadzLUJxkOeQ==
X-Received: by 2002:a05:6a00:4b14:b0:736:692e:129 with SMTP id d2e1a72fcca58-739804886camr24768218b3a.24.1743532095403;
        Tue, 01 Apr 2025 11:28:15 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:4::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739710acd6esm9555740b3a.145.2025.04.01.11.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 11:28:15 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] io_uring/zcrx: return early from io_zcrx_recv_skb if readlen is 0
Date: Tue,  1 Apr 2025 11:28:13 -0700
Message-ID: <20250401182813.1115909-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When readlen is set for a recvzc request, tcp_read_sock() will call
io_zcrx_recv_skb() one final time with len == desc->count == 0. This is
caused by the !desc->count check happening too late. The offset + 1 !=
skb->len happens earlier and causes the while loop to continue.

Fix this in io_zcrx_recv_skb() instead of tcp_read_sock(). Return early
if len is 0 i.e. the read is done.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 9c95b5b6ec4e..d1dd25e7cf4a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -818,6 +818,8 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int ret = 0;
 
 	len = min_t(size_t, len, desc->count);
+	if (!len)
+		goto out;
 	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
 		return -EAGAIN;
 
-- 
2.47.1


