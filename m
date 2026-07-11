Return-Path: <io-uring+bounces-13936-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 0zrgHMUJUmrULQMAu9opvQ
	(envelope-from <io-uring+bounces-13936-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:15:49 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2B5741006
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:15:49 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gsWo+rfU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13936-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13936-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 733D5304ED67
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FDDB3019DC;
	Sat, 11 Jul 2026 09:12:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9572A3859EF
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:33 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761155; cv=none; b=L5EY1Roki4y5yl8SpSMWgBDxxqmb2DfRyKiR1YKp8/MEVlJp+IscBZ8xA/P3mLMRgc49otOKT3MbfLjfxkRArjSgLAa+k/gEBXZaKrQR0OOBqA6I8XhN5lkVrACnXp0p4VUBymsiaPVkIajZ2dXU0UmObx8tydanUt2zA8Bte8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761155; c=relaxed/simple;
	bh=j/5GZEQZbF38L9JaQiUk3YKk/MPhOlWpLdjb7h/aMHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTgYFOqpko1+vMUyqZ8q70zk6EzhzB0mj9Kk4mDFT9WYgEnaFJcB2E7bgEDkm3PDUSEY+l++Z1x/fZXwA1YqpbQC7uwsJKbFLlmAQzMGaTH4MMIdh93JuROxtYxyj/kDvAqeABjsKhvjMinXRZ1nbEYGBNq2kyJpghHy99BFhpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gsWo+rfU; arc=none smtp.client-ip=209.85.208.53
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6989c0ec3c5so3229045a12.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761152; x=1784365952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SN7mHS7hqYCVkOLfVfbV8OTyhnbG54L9cTrZjvi9uwY=;
        b=gsWo+rfUmYCnQj8dadtyJecKJEtCI2n9ILhshUtMwZ131pC+x34jIgqovtS2yYHdJb
         M1Tdrn40oQO5JpLtbk8R6BmL5Dwe0NpcA0Np/twypmVXZXjLkKYCOUHjL7ftiy+Nly2k
         9/pE7wrtVL0Qjev6nzhqiiJOFOxX4o/Oe8wOq/Nt2KiAizNqAvnoDKkYMghQZVSdS6nx
         Yu+5wvrstFMZpkTSNriJD/mqpfVD5tv9pzOFEEChGcC7QBLsIxjPEiMONj5LgUSHtNRi
         4lneRvNLpxy8xbAL584cOnGVZGCft/AP6N6vLzvNQWvaVUvBUMrBwU91AqGG4BP0YHrw
         JceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761152; x=1784365952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SN7mHS7hqYCVkOLfVfbV8OTyhnbG54L9cTrZjvi9uwY=;
        b=sHIz6vou/nIsZfutZbI3j6ndyU/ua16IHJ2C4FXCS2aDj1x0UeHnzfKAlfQ1Ph5pAo
         omIfwwWtVW1P7nwjXZnTmlv624n44/eBJbDjNwMUUJYVUBHkjAgYNiBegeXathqhXZub
         tw2WEUxse3Vbqz4EJvgw6zovxgki82NgsAGZ4u9+c+ceJPysmz4BFICq3aG/tBZzMpf9
         KHtG9ntpx4b9ySGS5Q3ug38CbwVGRCoDCnCWeLHhlEXZFk9cl+3muhRfAFz+kMB4n7MW
         5G05wsRDyyL+dPmHpbpQcJa1nBQDlt2Uq5KHH98D9gh92NKoOJyO3MJpUopl6seuxxY+
         2iTA==
X-Gm-Message-State: AOJu0Yy/LZx1PP5VhHmrWmnJtYMyOIGteT8gAO5NIocn1VG47eAiqRgc
	2jXXlSotMhVw+y0Yhef/Borz7+smmWadIIlk00cRtBPmXXfI/tbbBRHnXkYu8Q==
X-Gm-Gg: AfdE7ckUyakRcTy0imaa6zgafbDv27/sCy9UHfy66DYss/feo1jmrHIIjQX2AckCjqu
	NP/o3n+0YztPH4dmfHGWddJ1ygXllJi4gS7InHlUuvUxRbBm84T2qzEYg+XHNCpH4QP+yHHxq4X
	/YXOksciZveFdL/pMsM+JVfLej29eQ5IPs7IY8QBQJU7Jb74Rc13/hfCtwf7DzSj/aHF6jg80KF
	g9EAb33B07P7d0zfKwY+MKm8pu5hjf56JoiFg3/WJeMH7wCewkfV903YW/pgL5c1ICE3BpaHEO1
	pMB3QHK5znjScLwQA+oTUNTC+TshCD83k5bJsAa941Wv9BaGMWiLFmw/hzVvJgRlh7l2+Xcq3WB
	cF517hz8kVR0Csx4djd7ZXTbNX3jxJWrk3bx7A33QfH9K+W8JRTQKMiZVDoQsIS53ekaxvJ80xD
	Ce5MHGvMqOL8FbiGyVYca6Nkwbq1HSR+E6M9CtAcVIpWTGIVKVD/9/wzCE+58HRJ04XCXwB1qMT
	G7RD2+iyNkhOO0wFNsZDOVm1UqoGmmug99nVMUxoeaOoEq4753t6NkQ8Q==
X-Received: by 2002:a05:6402:1cc9:b0:695:822c:1083 with SMTP id 4fb4d7f45d1cf-69c5f124c51mr1053684a12.28.1783761151896;
        Sat, 11 Jul 2026 02:12:31 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 08/17] io_uring/zcrx: don't pass ifq_reg to area creation
Date: Sat, 11 Jul 2026 10:11:31 +0100
Message-ID: <843ae4982c9e590713ac23ebb470dc0731b4da7f.1783616211.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783616211.git.asml.silence@gmail.com>
References: <cover.1783616211.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13936-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:netdev@vger.kernel.org,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0B2B5741006

We might want to create an area without having an instance of struct
io_uring_zcrx_ifq_reg. Extract a helper that doesn't have the ifq
registration structure as an argument but takes the buf length
explicitly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index cfbfbd262f90..79099a78f8cd 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -460,21 +460,22 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 	return 0;
 }
 
-static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
+static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_uring_zcrx_area_reg *area_reg,
-			       struct io_uring_zcrx_ifq_reg *reg)
+			       u32 rx_buf_len)
 {
 	int buf_size_shift = PAGE_SHIFT;
 	struct io_zcrx_area *area;
 	unsigned nr_iovs;
 	int i, ret;
 
-	if (reg->rx_buf_len) {
-		if (!is_power_of_2(reg->rx_buf_len) ||
-		     reg->rx_buf_len < PAGE_SIZE)
+	if (rx_buf_len) {
+		if (!is_power_of_2(rx_buf_len) || rx_buf_len < PAGE_SIZE)
 			return -EINVAL;
-		buf_size_shift = ilog2(reg->rx_buf_len);
+		buf_size_shift = ilog2(rx_buf_len);
 	}
+	if (WARN_ON_ONCE(ifq->niov_shift))
+		return -EINVAL;
 	if (!ifq->dev && buf_size_shift != PAGE_SHIFT)
 		return -EOPNOTSUPP;
 
@@ -544,6 +545,13 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	return ret;
 }
 
+static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
+			       struct io_uring_zcrx_area_reg *area_reg,
+			       struct io_uring_zcrx_ifq_reg *reg)
+{
+	return __zcrx_create_area(ifq, area_reg, reg->rx_buf_len);
+}
+
 static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
-- 
2.54.0


