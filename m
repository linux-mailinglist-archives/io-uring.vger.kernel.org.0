Return-Path: <io-uring+bounces-12907-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJSFJK44zGn7RQYAu9opvQ
	(envelope-from <io-uring+bounces-12907-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 23:12:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D7BC3716FC
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 23:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9AD10304E70D
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 21:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBE345106F;
	Tue, 31 Mar 2026 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FGz9sz+a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B5F4508F4
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 21:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774991262; cv=none; b=dklUVQ+jCaj41Ls0tDl1fSE3U96DhKCVr9LeU9OWco9epIfjpZOPNXuL+hi/u7KdTZA50lPJGZst145+KZMaJsArignlgJFx5bWXNqOFRhVKtvmhqlL84Yq32MTbHzrngxWNRSd4y1RiCjq/TUZYggHnVLsIbHT/AH9BAIMHKiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774991262; c=relaxed/simple;
	bh=1HxAxGz21Z+mV4nQVkIRzMQr3cqtoOeT3hoEcNfGYlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krMfNl754AWlCqOyMOIWfYxHtVk2iwN2dgMIkwUFTFp/exxBUnWW8CbEzBsoeLGoMakJh1YW99rEFdc8g3jO+u6v0AJW6idrM1ZRpybWn08Uz/6pbezZ1fO29NirgMXzV+NDNNhr8FngCdFe3QLuab3Y7rGHy2wmwvrEOBHXp/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FGz9sz+a; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d0deb7ad5so890922f8f.2
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 14:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774991259; x=1775596059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9E8cpgSiBnzd/+76DItta3KLSsX/PyTBe1odLIcto+8=;
        b=FGz9sz+a3qrC4rH69SrjtdPGV4y0y+hsv3n0ypRg8tfMEj8WiHWhLkasqhFRMaJlee
         9tipIm9LkQTdmI4FqWS6ipumGfUX38VoSfXT7DUgHFakvcF1a6vqCkZh50FdP6P8oLgh
         +IYScxuMxrjsWMInb4Z4X4mPXxnDFYug1EekhjG/eUE6pmuAU3AqZP+XU3z4VDI7GuES
         YEeOky/e+ranekmp1Mg4Qunhl6H9Uf+arqL03p0qzexlclHtDfbeUCxA+IqVnzeQT37l
         qtJFaK8NonjZv6MIRVSAsa8Z3zJ2LPqJ7oEjRbNA3djG4hZ4M7TROxIVvfaG40wWRqb7
         79Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774991259; x=1775596059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9E8cpgSiBnzd/+76DItta3KLSsX/PyTBe1odLIcto+8=;
        b=j3t0vAmoKwD2CI0TkDJg1CZVWBxzrjhjXjfsEho30+rI6DDjoRJ6S2aP3nnzABJL8j
         KeDub9IKRjrhCtkm7ObtlKg4F/VXy8GVVWtd9dvr9UbHWC8pILxZikqQGHBVDF3uMOxs
         5GueUK0A0QVeV6mTDEnFYqr3F59zae2iuwOHcPiqN/Rdu2L72TkzpOCswcR95rarGiVt
         5XM2qNepk9a7TsBQ9+fxfOV6F6HvXdY4bdaAwyQbsGlt2kgm7TivtHhkiKJIQj9IOSw3
         9Ys5Hre5N/G0gG1CDIkRCPO4OmDG5TjpYGjZ5DpO3BG07vVE2WPl6R/tPeAitT/cH17Y
         tF6Q==
X-Gm-Message-State: AOJu0Yxp2XQuSEeVlMpwJkGcC6mUr2e7y4UJgPV4b4QRHRfxCnnl9g+n
	LLYtE/o+k6rZiT4dHZOZmL1KvLMYHwcfs8YHBlIlgb1V2O8SrJosA+CH4Eg3Xg==
X-Gm-Gg: ATEYQzwtcO/dutIaKgN0WuiVJbhqVLtLSqP6IW9/e/bxTXk18/J2CLkv+wZiXJmdPPt
	kpJN6rtBAx6+CNedmtbHnblX5mtbFiIXSVYVDjZJKvvrImuzDVYj+iPFS0i+cBwdKlhS0HZTmtL
	9wVhwzHSHpa1Q5GJUEuTtfl7CL1nTPHzWA/HazZwt+TNtNGwqbYCJb3C0D2j/lcWSoELuOfEKW2
	WNSXJRlo8VR+XmZX1DNZDpGLJT/GbvwGCBnUUzKtB8W03IbCoYfQWAY3cVdaoHUmS24iKgG4190
	4a/SzgQYiV0Xj7GYHwj91zSZucjksx44NSonvnQDTWf9zdH84deTWGvC6EjFJ1FjIDNpIEkAG4K
	Bu7yhR9205PsoL5RIaaM5Mndnq3cNSp6Pa0Io2xleK81HGjguzXsttvCz3B3xfQflXYdsykNrnj
	SMgUU4R8mhtQkX0VnjfrifCvP/ZAcCb5U/LKxdK/FceIAGrRT/v7XfeGsnMbTPdR9CrL5keaHTO
	zX1m7ELHqDUr8H98YcaB1b/hnYdcw==
X-Received: by 2002:a05:6000:4205:b0:43c:f737:a3fa with SMTP id ffacd0b85a97d-43d150e7f47mr2017516f8f.30.1774991259283;
        Tue, 31 Mar 2026 14:07:39 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf2570b18sm32431393f8f.31.2026.03.31.14.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 14:07:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 v3 6/6] io_uring/zcrx: use correct mmap off constants
Date: Tue, 31 Mar 2026 22:07:43 +0100
Message-ID: <fe16ebe9ba4048a7e12f9b3b50880bd175b1ce03.1774780198.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774780198.git.asml.silence@gmail.com>
References: <cover.1774780198.git.asml.silence@gmail.com>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12907-lists,io-uring=lfdr.de];
	URIBL_MULTI_FAIL(0.00)[sin.lore.kernel.org:server fail];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 9D7BC3716FC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

zcrx was using IORING_OFF_PBUF_SHIFT during first iterations, but there
is now a separate constant it should use. Both are 16 so it doesn't
change anything, but improve it for the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 3bf800426fd2..bd970fb084c1 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -386,7 +386,7 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	mmap_offset = IORING_MAP_OFF_ZCRX_REGION;
-	mmap_offset += (u64)id << IORING_OFF_PBUF_SHIFT;
+	mmap_offset += (u64)id << IORING_OFF_ZCRX_SHIFT;
 
 	ret = io_create_region(ctx, &ifq->rq_region, rd, mmap_offset);
 	if (ret < 0)
-- 
2.53.0


