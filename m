Return-Path: <io-uring+bounces-12797-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFkhEA42wWm7RQQAu9opvQ
	(envelope-from <io-uring+bounces-12797-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:46:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 11A012F227F
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:46:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9FA2A301946A
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08CA93AC0D0;
	Mon, 23 Mar 2026 12:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gr1S8NXI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE073AB276
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269860; cv=none; b=cGAXtavGUi6mDNSzxzWH6GNZXKX48UpyyClBso4nrvSHiHXyBcD+meG+4e8sicaLGtZA71YvZ253yu4wEWKFIEtWSxF59egNeUqA3A+5y/Xd2MdMm5lexgFziya2r5V359/Q/8QvWlHJJLOgJPOkfUtU9t3rVg/rjc8gQYh/dwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269860; c=relaxed/simple;
	bh=YvFfpu0cuPKpW4kEi3UTWKISmEL4Rzrrzs+1a6/PrR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+q3sFW+kDA9wY+Rj+2tM0jbMAZ9dpsomIp9eUOKLqsX/80JAYn18hqaODqtEBIizxWb+3vMu4HhHriUnJXJeqOhVF5o8Biv2+f8jIQRNq3jUo3PNH1b57ECofXsN4R1+gxUrsnKgyUWsqmzvUVZY10+vv3JBeJtZs5kSNECYUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gr1S8NXI; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b44c0bcdbso4418667f8f.1
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269858; x=1774874658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EhDZL/FEmed9ML3cHb7wLCvxYEZQp1frpGLjKPfKgpE=;
        b=Gr1S8NXISrDBJkRp+vztFLp6abbi787AQpHKerPpJC9bd/M1i42L/2dhAHeckbt91s
         SpNVWThXdr9kAU8h7Vnh0pDNtK45mmrkDhJAxDT9fxOlDgum4LAwVs8to3J0KnX+Ydri
         R4/ha+d2RO+4V67Nb9tCITB9ZAU0vGzHr3r+TAq0kBEvcg2Md4KoRiS5WjmPynE5RsgR
         X9D85FkS1HN9QqYnc1jvvSfh2YbBJmmB2WGmSmXB7+0jnM5BpI8m5BIJAsYBXKXXuq7P
         L+byAMxb/BEk3M2ifO56fDrPfQf3cbvG+azlMMPsouyP6llaFWqdVzyfRbPHwEzDwEtO
         j36g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269858; x=1774874658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EhDZL/FEmed9ML3cHb7wLCvxYEZQp1frpGLjKPfKgpE=;
        b=AHN8icXN0N2LIm9aISpx4fVMexjLUMErcpQdd25ZDMCNUtYOM2Uuof+CrUYTDw7htY
         nrPc/RQNT9VoL9MwStmyxx/R6S7IcgaZb2fYTPb4wzbqH+afMOvwkU1btmGo3J355z+a
         RUyPjO7Tpw6jPRkjF4YKbPDQIgZYZEznRNLF3X2bezRxSHA12p5znQ4qW0iA6H28RRtu
         nIlFmQaNINRIf/n/96wcRZMUKJSyjBYCJa07iWRtIvZqx0TarTW/vZd9SCJQGLY2+rXZ
         VLE6mxro2qswVKN6K+tTNGGD2mkc7JOWOWNSotfPbt2eFP0kxgFYqqNon0wo9eYHHO3h
         cmVQ==
X-Gm-Message-State: AOJu0YwHSPH3pMxBfuQZ4zv4mIHXCIB1r6hSyvEwZ2djgQNsNduN9pKN
	XjzhSUB8dyJ2cHXRtlJ4vqTNVByf0NeL85H45rnyiRq8nXb8kRY8eXWt2jcU2g==
X-Gm-Gg: ATEYQzzP6HIRC2BcgLGixpq0EN2ZtmRC9UVaYFZPknLvC/Jvkj5JmTNRVqsV3SOAOWW
	P3ZQdeIposdFusT4E+pgMcwMfzFgpiAlHzQhUYES3U/0obZS4PBM5CxeiaVu4CB450gRa7lPrTk
	tu7T8x2Hm32t1K+Z5+HF4XB3m8gThnmnwyQI1NTh0GRXc01cgbhl9BiI+sL9AOjqJVWKV2gV5RD
	fmoY1DdRAUgYQb5Brma78fNOsfXZvh1+ZK97leeWGk29yU25uBw4z9Fv/kA93d5i9nziW9MiUub
	BdwoZPU29UKXE5SOa7sByGLCHMR6MR6vrNw8epyZkINhzjn29PM+j6Rl7tWVW6yH6rZ6cH0ZKAi
	/5VXvV6opr4XF4PrsXIR+eO9TrqAuRAP2luDazVuZ56rtqN93ar4wxvz+BlBpH7ZniT9vAKN1IM
	D2Mxp0v264QqwGXvtIYBWq/h/6wx5QEJCa/RL8B1xI1Oj3hKYsFmwlG1uBaEsAWnm/cUrtsY5ON
	Chn236cUg==
X-Received: by 2002:a05:6000:2502:b0:439:d755:a895 with SMTP id ffacd0b85a97d-43b6426d7b8mr18136402f8f.42.1774269857520;
        Mon, 23 Mar 2026 05:44:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 13/16] io_uring/zcrx: warn on a repeated area append
Date: Mon, 23 Mar 2026 12:44:02 +0000
Message-ID: <28eb67fb8c48445584d7c247a36e1ad8800f0c8b.1774261953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774261953.git.asml.silence@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12797-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 11A012F227F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

We only support a single area, no path should be able to call
io_zcrx_append_area() twice. Warn if that happens instead of just
returning an error.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index bf3dd15678c9..265b3a744ac2 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -423,7 +423,7 @@ static void io_zcrx_free_area(struct io_zcrx_ifq *ifq,
 static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 				struct io_zcrx_area *area)
 {
-	if (ifq->area)
+	if (WARN_ON_ONCE(ifq->area))
 		return -EINVAL;
 	ifq->area = area;
 	return 0;
-- 
2.53.0


