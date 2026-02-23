Return-Path: <io-uring+bounces-12373-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOTrLCJgnGnsFQQAu9opvQ
	(envelope-from <io-uring+bounces-12373-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:11:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 44BE0177D11
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:11:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B1DC8307E863
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9055927F749;
	Mon, 23 Feb 2026 14:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMkO3VCg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D279281530
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771855852; cv=none; b=ACfkVB+m4wu5B1LFNlvUMpeuv2A7LrwOKFA2r+cjYKmpYRL4RLZzoyk/hVeEMQ6onAQJD+XFLwpAxrDbY2yFKuAsKdnNu0KjV5iv9ISFAQuwM7zom7g+fwJtFtKrzxBhdycRAWJB6paRvo/pRd895RPoV5QrViJ33mIVrBfcjOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771855852; c=relaxed/simple;
	bh=sDzcjQkzAWw7X5rlfIzEibzN2rOuTI+BfzLbseUS4II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyH5vR6ik83Cxv+cgbJ7l3egSO2bfWCYAexodUB/wZESGfK7Yij54k4iDbdJ0n9LFuhHapsule4RFAqqwjhWiXzFFB+JFKS954YCagkR1w0flGGOq3IVwaRHTRTLe3ofNNHjTJYgGdufBVOC38u9tNt9cpHFRjmQarNHW1xsUwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CMkO3VCg; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43638a3330dso3728253f8f.0
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771855849; x=1772460649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjRrv3KM8xQowe6y2+mGh/Bq1IBsIN9ajRwFWDh4DBw=;
        b=CMkO3VCgMa4XMujbXbwYm0lhMhUPX/d9p/ypJA37gG4oQgthM3vHaT35cdcA9vdFv1
         8J4p45gjCRiU+tF/hWfHI4rVZB19HniUrlBGzzujWpETMxUFqnB2covHDJGMprrVu4Om
         U7qM7vNj1UjI1t/R2yNfq8G0eobjk4Z3nvUhHezvHF44GaZg3MahpIPOySm7FG5bexof
         REOLUMmyK2RQ1NU/SaITAfhj1fT3vBsR+LAttmVdJSH3vhHMmry+ZhZc0s2es9iuJ5gu
         nqGa6ITplJZAuaSBDadHFu8X1pKRROXnxPBJJj4x3KNgQleRFl7S7b5KSlIEYJEiJNIV
         6b0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771855849; x=1772460649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xjRrv3KM8xQowe6y2+mGh/Bq1IBsIN9ajRwFWDh4DBw=;
        b=W24PcCy3RCz3JnnxMoxUdxIRRlNjn/pZxRcDEC8C++kZoQgtVrnTIdTFWtzv1y43M/
         Ks+E/vZzRZMQcJTGr2txUQDn1G0Pb/EtZnTNTZAndBGJRrq4H45JGwwtRVcIjLd8K+pP
         x6fxx9YNDWFuAtI/Ozbx2EFqtO7UjdMgvNBh6XuL9bFlbdalCJswFs6jDQwKhhRPQ6qo
         w1uNG/COi0R4IrzHcoQKlA8iu3I3prGY0TAA2SoWMFUdkE/PM/rEfNWti+U71+xjv3z3
         IRpoQ14cqOvCwczY6ggmdNFcvoRtL74G6bF7HkG90uJ93UUh9xqSwHzHgvMAe934r8yt
         s+Lw==
X-Gm-Message-State: AOJu0Yx1bc6+p+b7g2KTcKNhs1E0qgZh3fzxWBQYMgoIL5BZByj41adY
	C5S2DsDc5tr3GbQPZV7Lsvv5R4ph3Nk9Os2ggs9QFCxmfmqEGN7035Ai5kUn9g==
X-Gm-Gg: ATEYQzyd3JYlJoPQU8jijg+fRGcjKaNgGA+Y1zN5+Pl3iZ+dt8DB+NNUwMIBSiM4B6u
	iddCCJIsPkckyaiql6oDTk3S804Ehzrp3Dl4J5ntVPLQfmkm+0fa0PKNQcnSZ1gy3kxuGRVNUjA
	v4YvFQ6l0bzoX0z4eBiL5BP29etfYvH8UlJKW2zRkqj5Y8idpS22X5FDc7PNjOeU6hlOLRTLrOL
	z5ggsS6/OaxOKdMFBBqtePhDS5ZKslsM8Ei2329RyuAUJHZWRzopYhF3nCZWQ4ATozYuy7og9Qf
	y0e3RJPKjvJAYscUPGjTkj8MrfXgKCYGPRxL5Zh3daqi0FtHyjjP3SZhJ6SM/jI33vEegCv/HxR
	9rRpkm278HbxcuNSl9hd+PpXvjvQ5F86y8qJso5U30sdwknR8xSZolRg0wWEnggzLBd6uzqlasO
	snFUroeOmD16a2pyrJCQiqwzmFwmE0LFpMyPPNDilDh2XMfmA81FGA+DaJNlhFgmXPAJbCXyvDD
	3jG7gGkng==
X-Received: by 2002:a05:6000:4026:b0:436:173c:b8e3 with SMTP id ffacd0b85a97d-4396f178732mr15944711f8f.29.1771855849129;
        Mon, 23 Feb 2026 06:10:49 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:36ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970bf9feasm19464640f8f.6.2026.02.23.06.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 06:10:47 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v9 06/10] io_uring/mini_liburing: add include guards
Date: Mon, 23 Feb 2026 14:10:17 +0000
Message-ID: <9ff4284f5819ac7bec25e88e8909073058626435.1771855761.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1771855760.git.asml.silence@gmail.com>
References: <cover.1771855760.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12373-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 44BE0177D11
X-Rspamd-Action: no action

Add include guards, it makes it easier to write tests with multiple
headers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/include/io_uring/mini_liburing.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/include/io_uring/mini_liburing.h b/tools/include/io_uring/mini_liburing.h
index 44be4446feda..81513b82433a 100644
--- a/tools/include/io_uring/mini_liburing.h
+++ b/tools/include/io_uring/mini_liburing.h
@@ -1,5 +1,8 @@
 /* SPDX-License-Identifier: MIT */
 
+#ifndef IOU_TOOLS_MINI_LIBURING_H
+#define IOU_TOOLS_MINI_LIBURING_H
+
 #include <linux/io_uring.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
@@ -309,3 +312,5 @@ static inline void io_uring_cqe_seen(struct io_uring *ring)
 	*(&ring->cq)->khead += 1;
 	write_barrier();
 }
+
+#endif /* IOU_TOOLS_MINI_LIBURING_H */
-- 
2.53.0


