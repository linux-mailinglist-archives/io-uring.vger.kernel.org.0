Return-Path: <io-uring+bounces-13280-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gEgVGHoBA2rdzQEAu9opvQ
	(envelope-from <io-uring+bounces-13280-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 12:31:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C57051E981
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 12:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B813E308C8F6
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 10:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E68349CFD;
	Tue, 12 May 2026 10:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcRliuqS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F94D349CF7
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 10:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778581535; cv=none; b=R5nqAyhJX8emWbOVrNAQeQqfhHcvz+DmJ+utUXiPw/y3Ao7MCF7ccTAoprkklPH9S/4dtcRVQlyaHfLj1o4xrpliW0IqbX/+DKsPbngmVf/Ew9EDeKd3NnJmTuy2PRfHhBPkjrMp+YUIv16pvi+aeR0ZMJpe6ZLV1dyFJpfMx4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778581535; c=relaxed/simple;
	bh=l1Uthq/vfgdP5vHKOjjfQmtBOx+cd8qn/5iG5Ms4y2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEiiCE+a30G/2pBn/qYF+Pn3SjSek5bVyGq+Qz4ZWKhGnuwoeuJj0VkdEN+iokjNMEMiv8ZiFtC/cUKbTJZmVDv1sU3DORvvk3JzJ191WiD2NEwRaw51XZC9Whw48hDWLEFyaLwEDTwY2nWhlPNTufXDykLSt9r1eWduvOZ9gTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mcRliuqS; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso61926745e9.0
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 03:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778581532; x=1779186332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rTHH+DyX35BmTbzRWkLeoC5HB2tKe6Kngykm47H2oVI=;
        b=mcRliuqSpuQZtpFUjwt48ybIq40gGcgBSaQhzcayd56iv9bi2BWnOB8BJUud2i1BzC
         s9RymANeLjBrhA1tGv9aSJ71bDRhCSsGn/0K/lnXrHmgjr7lvhEujSP44WhT6KBxyNKo
         0oBF6yKDH837rmoHmF+ZOB8bBeyNm4otlTdssfr+7gFUG4lZWnBLnMBZ7ULNsaMfZvHc
         aPNkPSSq53yY0kP5ZfYiACvukZXb6KU6tucdynEKH16AOmDpswWajZWPLa3o4TKhkr8k
         YeBMduY5c3wBNmwX7633cYOfGCX3V9KO9TjvZsPyhJRuJtxy/23MSyU/lPC5K5D6fNTI
         R/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778581532; x=1779186332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rTHH+DyX35BmTbzRWkLeoC5HB2tKe6Kngykm47H2oVI=;
        b=EHq0MrNI7DbMzhWBadv65txln+b6bcVHH/glba1x4E3gKRpLr+ywlhC0uJ815h5TW7
         +pIMOT6u+hfiVG71CPPH1n3TGGVYV83tHzNpzjXNtKhcXkzIsU+7gFSjzKYtL9S9BirM
         KIWjeS9rEcSuYkw1Df+UkNfR1uhDia1c1jHOr1JlnWGqksVMoWUWXaCntkmOdAl49b2Z
         NvQdBPT+MMl05gXbL3O0JOCjx6T/1v+/09MPifE8KZS8+2Gg0nETt6oyYI+gCuJQVDAP
         IBPUOmZMbgyHSyQOy1n8FhELhssfBBW52d4uFaCn6qX7kRhI/UULjiIFJX00HXzsyDJQ
         ig6Q==
X-Gm-Message-State: AOJu0YylPnboFM7zkQauUZ3TgTralmndej5Y3HkZF10jPRsiHw0riE/S
	cUWUASYywmbV7DmPFhhqedIMLCB4jRhhCtG6Y5FMN7Fv7AMSRBojNkFx9WWW3A==
X-Gm-Gg: Acq92OEKOJ8lPk32CNyCes6MYKcJkEu52nesBi9MSXuFvoFP+m2ZHKS+/j7+wBYMHn0
	ZFkRJQ1vE+AYHRchMWOzaEVGDvN8wDqGPEtm3L6Fwp6GR2rScKFbVtHs8bcO6j7GbFSkuuawQY7
	Iv+at4RRhdp6HboF3f5jKNsaNZG6pzDMX39dsLYpkCUmdIsnmdPPVFsuaLvlblnUfN5LTFIUgyq
	zEpgFgXHUUOfO/7dql44gZoU3Zh9sZ5vs+C+P2D6kUptrHb9CJWoX//xXQqVCe3tR2Qexya4hEA
	4YoPyUYQVpV6JqIbfIAPUEINGvDkrg8JSj0LHJMZ061bnYCFdx77pXDmHeIxPxvJN0fz2IPvZcC
	0hgi/31J2sJALj2mN5DyHOmgycZzqsbQOc8oacOgVrCQ6rxy1xkKKZMuQ+st8/vSI74Bp/Xawhf
	Jt8Xch6Klhgmm9y5hBtuSsV7aImBPlssYGFoIQTjZNrOIRizcvISjpFQYYQalH5vqUCRHgzuqvW
	XauAruL5g==
X-Received: by 2002:a05:600d:18:b0:488:b811:51c4 with SMTP id 5b1f17b1804b1-48e51f3c4f4mr366926825e9.25.1778581531175;
        Tue, 12 May 2026 03:25:31 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:8c90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e9052c9fesm74352255e9.1.2026.05.12.03.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 03:25:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [RFC 5/6] io_uring/zcrx: split append from area creation
Date: Tue, 12 May 2026 11:25:05 +0100
Message-ID: <1778e7ae4bccaaca9a42a6fc668bc04fc283a101.1778581283.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778581283.git.asml.silence@gmail.com>
References: <cover.1778581283.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0C57051E981
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-13280-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

A preparation patch, move appending an area from __zcrx_create_area()
to the caller.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0551b05d53ee..5fb81bb6f819 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -468,6 +468,7 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 
 static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_uring_zcrx_area_reg *area_reg,
+			       struct io_zcrx_area **res_area,
 			       u32 rx_buf_len)
 {
 	int buf_size_shift = PAGE_SHIFT;
@@ -541,10 +542,8 @@ static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 	/* we're only supporting one area per ifq for now */
 	area->area_id = 0;
 	area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
-
-	ret = io_zcrx_append_area(ifq, area);
-	if (!ret)
-		return 0;
+	*res_area = area;
+	return 0;
 err:
 	if (area)
 		io_zcrx_free_area(ifq, area);
@@ -555,7 +554,19 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_uring_zcrx_area_reg *area_reg,
 			       struct io_uring_zcrx_ifq_reg *reg)
 {
-	return __zcrx_create_area(ifq, area_reg, reg->rx_buf_len);
+	struct io_zcrx_area *area;
+	int ret;
+
+	ret = __zcrx_create_area(ifq, area_reg, &area, reg->rx_buf_len);
+	if (ret)
+		return ret;
+
+	ret = io_zcrx_append_area(ifq, area);
+	if (ret) {
+		io_zcrx_free_area(ifq, area);
+		return ret;
+	}
+	return 0;
 }
 
 static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
-- 
2.53.0


