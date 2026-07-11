Return-Path: <io-uring+bounces-13965-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id mjOaGtIdUmqUMAMAu9opvQ
	(envelope-from <io-uring+bounces-13965-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44553741413
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:22 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pjjQuvlU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13965-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13965-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8B858300F754
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980CB3BB12C;
	Sat, 11 Jul 2026 10:40:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC95374198
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:40:53 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766455; cv=none; b=tmB6+yLiKMumrgnmhE1TTBYRJmN/Vd0fevrMo7AHEDIUXWU3jIaJMGeialEeJ8II6DhMq83PIcQ6jwOXOYo+oMHoqnmxfUzG1AmHRINim/b8KUWibuO2z3K97Wn+f/ixgiIAALPouDiNpZyCKTmuwwwNqPsBsr/D6pP/4oWXtTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766455; c=relaxed/simple;
	bh=j/5GZEQZbF38L9JaQiUk3YKk/MPhOlWpLdjb7h/aMHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVDPt2Fvw+TlH7vn/x9OFNSFSgk7jfmExlDLXsGI3vyTecb0FZuZVVZmSlbK88qxntYIlNkKH+elTP4X95T4jwkZWJfqdHUn43EYxg9WXbdIlmKq0AQEauRf/JrJCZqLrWyzt43cQWOdaQic6k/oFWKQykD+R0ut6ZeEvSlagFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pjjQuvlU; arc=none smtp.client-ip=209.85.208.49
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6984169c126so3041576a12.1
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766452; x=1784371252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SN7mHS7hqYCVkOLfVfbV8OTyhnbG54L9cTrZjvi9uwY=;
        b=pjjQuvlUZQ6j00w+ftYnnxyGoy3DqIrqNDM50HkWt2I0uuYfwcZjAc1kjP9t1TDs1U
         CSPiZJ2WvJsEdNSIBkee3I0i1Q3lFCzRCl8unLVvL8S3oDgkmMtjlNSELzON8KRok8wU
         Jn4rgSsk6Ay0AMBi+Yx7UT8AtsOFd7TJOxN8tND2uWDO+hJo0y/s9XkMRH+2V5O9eatW
         t7BJOx9IvideCLSI0e7E7gONOUwRUV8IgMF9Y+BXuq/+c8aHOUd3dF7HdkSPGEMMVtJO
         XO9iUVGIRJQxQqsVil5ieSXtyLhPEzEaF+LRn1pKnWCSyQrDf9yUsXHS3L0aky4Xa+uY
         4f1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766452; x=1784371252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SN7mHS7hqYCVkOLfVfbV8OTyhnbG54L9cTrZjvi9uwY=;
        b=jEwwsa/2r76mU8H1V6E4YyHdAVJTGRJV8uUdPk6Y8jwZMB8PwlIwG3zLzsekRvY9LC
         49vBHABM08EF/ulZNzcK7ip3iMXQGfJ98X1gZDGYSHDKtwMAKTTw7yWI4XBtBhVEVUoi
         txLxq0sOwTnW1nnvdbegPOH3kv7+fEve2JEZoAQqIuv0sxu9Xc6pqCrww3qylXeiaYyz
         4ZqkBBgUz+NsWlYoffcRixd2dOj4uCLo1mfAgpeK9U1NDzrljlLDKPv5CAXokBq0KTQu
         vge3pVXluBFw9jnXp789P1e5QAeWiCuhxs7AQKAY9jEsWgYBhLZFxy4zSy6R8bASzM9M
         l1+A==
X-Gm-Message-State: AOJu0YzQ57C8Sikgdqqr78Z9bgJrBDIvSBpipTcdpWVUmhEPVlDmisF9
	rxoo2ZrQYqOvbogsfW0etBBmr0uaGaD024rVzcG0pdekWERPUGhoyZ9XsCY9cw==
X-Gm-Gg: AfdE7cm1FeBt5XFIBjshNJcllJqjKfurgmMl1MX5omDt+WepaG9z5fIAwnZ+s7/tds2
	yTNeVlwlxFdyA/g7jh63WgEVBmWCJ1hOoeosbRpbKsKoxksZBi1mipmuQYGQ7IIPO03Ud05TKWr
	DUIFfBbxPstUcHRCW3V+/5/MLt1YZejP5Q4ieH6HRd7xCmKrX6RYz869jlNCdcEE86VZlh7KzFk
	3mWVeYyS2TUAK40gTVyL3ILocwvgwyvsCufN/GSVCJaB3op7dgouLuUSdmaMEauAgj9NL8bggVx
	Z0KXaU4Da42XjvXdAA1IWoC5+z/jmOSSga+Yz/b8tAUgzpYTVCnRHq1E04141BdkS++6ea3sxM9
	m83g6WjphVKIwkm/tyjlrGm8AD8Uf/+IUdWEKTEyWTZaB3vOwIpMNZXYPy4+/lbJpOmQ6biHjuZ
	eFpx/90mY9AvGqFYJ06kD/9GE2lrEmsMY2O+ymg9y0z2eo2E7ChXexUzEoX86v9f1cf0l6GFgRT
	knfqtboCxUrkApwOi+ARuEzg6I1zcaFleYihWaR9ArsthjJKzsR4XfwYibC
X-Received: by 2002:a17:907:a0c:b0:c12:58ac:9869 with SMTP id a640c23a62f3a-c161e84c5d7mr94603566b.9.1783766452409;
        Sat, 11 Jul 2026 03:40:52 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:40:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 08/17] io_uring/zcrx: don't pass ifq_reg to area creation
Date: Sat, 11 Jul 2026 11:40:01 +0100
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13965-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 44553741413

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


