Return-Path: <io-uring+bounces-12857-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAHCFjfhw2kgugQAu9opvQ
	(envelope-from <io-uring+bounces-12857-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:20:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 326103259C2
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8E045309CD4A
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C95F3D9DD1;
	Wed, 25 Mar 2026 13:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="paKvKIOp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AA03D7D8A
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444164; cv=none; b=VPyqcv5N+1C2jOupV6cJB1ipr3Rf4cWZ2BCGqzUm7QTBg5X1R2yt8lnIppfaBs0ABOKZCRMj+MLVdEmp2Aosfki76S/AhIHINuPc9gW+LXSXNbwV+WcUw+cPLlLhx4A9ZXpdCrfseRBy8d297ztSHbvmlePWEsTB+s0CckRiDA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444164; c=relaxed/simple;
	bh=E59SEGkEvMpf0SZUngF9Buw91DKUnMF4DL+PgLNi+TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqxIhy7PxFljh08iEaZ2+RC/Wrm50K37Ix3UbAtUnkLesLEerFgrUTtCQOT3OrU4T8UJQOepjF0JiF0AmKYcAJdDQm+LbygBSIbLaB1Ya8mBVFR6m7yXAt56+o+mRokUec2QmRB4q0c/A7mVu1vSHX/oxc9u3OT/8qFu9S1rPag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=paKvKIOp; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso46042655e9.3
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 06:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774444161; x=1775048961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SyGd2XK8X1Eqms0MZ3BDjWaLlSB+PkGJ9dviavg1aug=;
        b=paKvKIOp9yCLuikJkoRXRh2yYY2z++5dAd96ck3X6iiq2yAcF1IPcmcZQb6Z9O9uCU
         2ipBkZMLrwCcnAd+VftS8d5aFmZVrm2XtqStHRyvYlZRUmRu3gb+WrMYMUMCTxdB58LS
         l2IIPtteqZIseTQef1UpEOelmxd79zY0ENq7bzravCdm3hpel86U2niU9pATQMYBCZCK
         lD7CD1iYINOZfDrMdbPam9RgVzVyOvTeOKfRaufmHQwvL4mnkNRwKHrjX0CietI7cFCG
         r9Z01o/+dMpJVgqGZXirRXeu8TDrRDui4p71HZSa4dJ1HERtrWr2niUJRj3g+zl2HAED
         I6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774444161; x=1775048961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SyGd2XK8X1Eqms0MZ3BDjWaLlSB+PkGJ9dviavg1aug=;
        b=FIe3jhj0YlSSdQ4M9gdS+BRoMHPQGjQ68e8EZVBHvLl6pjKK7hf4HnM6t9KqCSibXc
         hK21HmLatPz6hu8bfC1oDD5fUPXWVSAJXRbZjekNdKAozn1LEbXKA7fVA2QIiSC0PPTx
         3In+NUQHNe+zwm22LAEYgoBxS2NEkjQj7VEtODmyCDLa1IM9qjMtBxAwy26P0ajFvHue
         27uZuR0EcfjFLKzJD3i20ix8QCkY1UAk9vqopjPhcC5TpuIWGvYQ2Cbltiv1GfPdrs+/
         FcRa2yLDATvc7mfW1sMDRiaOdnVVn7vtPVNj9yFeiDDlN7dBnj5isDsK9iFy8ROhiHeu
         yjEg==
X-Gm-Message-State: AOJu0YyC7BCZ1GefIk9NFDDN1ZL4O+j3HUfD1gnGvS4Tj5QUsmr0C3sU
	W8zi51ILhluQ6ICY7nP2rega+vdK39siiZ0DNSpSKvBgPAaCvjZQaZfkEOLVHg==
X-Gm-Gg: ATEYQzyNosZiEgisG59SJ8qMWt8ybleXQratqQ2aDz1MABjAbAxcEJq4Nfixwp3baUx
	whME4zNuBWZJOVWSobiNhzxHOt+6jkrGScRFn8nh0uPV7BIl2j3OqdbO66cb8rfEACRemWqW5dF
	MDMw+QxWv3J6jveHpDjg3aDgRnWd/gDyKse9OthtE0Ouj3HFvrDPBgxVQ+UXLdHUgYjH5lfLwTl
	A7VzBuoBIlygUXys0rxY4rhsYht20aBpq7dCBEQReKJVs04DzVJge8I3W8ixWRrSE8DrfLc3GAt
	DFpKaXACmaZ9NMVdcvnEcU0eoK+ARKY7ulU2BR+i8rlwdTJsV6+P3+UdLc0NTsP5ECyHtSQZ14I
	tbO5hFmRYLVhMea8maWYXgmUTg+5hb5OSm1jafk7h1C+8dZbJluAf8NN3T0xmljb8+NN7uauH41
	ExzTvew8tYc3RhkmAcWep/mDYuR6YQB5TBi5Z30cKAHPuLpPGDhWrH9PeTQwqXVZw6IPO5ThZly
	wSZ/4MrTYellql/Wg2K
X-Received: by 2002:a05:600c:c490:b0:485:3ff1:d5ed with SMTP id 5b1f17b1804b1-48715fc7437mr51061535e9.1.1774444160812;
        Wed, 25 Mar 2026 06:09:20 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bd923sm54062611f8f.12.2026.03.25.06.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 06:09:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 v2 3/5] io_uring/zcrx: don't clear not allocated niovs
Date: Wed, 25 Mar 2026 13:09:20 +0000
Message-ID: <c4545dfc1bf4778355b02732d0c5ddaf34b9c675.1774444007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774444007.git.asml.silence@gmail.com>
References: <cover.1774444007.git.asml.silence@gmail.com>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12857-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 326103259C2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Now that area->is_mapped is set earlier before niovs array is allocated,
io_zcrx_free_area -> io_zcrx_unmap_area in an error path can try to
clear dma addresses for unallocated niovs, fix it.

Fixes: 8c0cab0b7bf76 ("always dma map in advance")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index dede892bdda9..d9174cb31a44 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -289,8 +289,10 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 		return;
 	area->is_mapped = false;
 
-	for (i = 0; i < area->nia.num_niovs; i++)
-		net_mp_niov_set_dma_addr(&area->nia.niovs[i], 0);
+	if (area->nia.niovs) {
+		for (i = 0; i < area->nia.num_niovs; i++)
+			net_mp_niov_set_dma_addr(&area->nia.niovs[i], 0);
+	}
 
 	if (area->mem.is_dmabuf) {
 		io_release_dmabuf(&area->mem);
-- 
2.53.0


