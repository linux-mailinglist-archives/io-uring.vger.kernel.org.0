Return-Path: <io-uring+bounces-8923-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A39B1F5D0
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 20:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97A56189EDFC
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 18:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3266263C9F;
	Sat,  9 Aug 2025 18:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="e5yTUTeL"
X-Original-To: io-uring@vger.kernel.org
Received: from sonic312-20.consmr.mail.sg3.yahoo.com (sonic312-20.consmr.mail.sg3.yahoo.com [106.10.244.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00612E36F1
	for <io-uring@vger.kernel.org>; Sat,  9 Aug 2025 18:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.244.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754764615; cv=none; b=P6IWi6fMyKWHLn4fRSLXhSYXNTDw9Vwn/bzYmsQtOQjyk7kLQEZAUVSPABHumG3Ie2xhfrhmRMCkHzYflpgScj1wF70/upHlGEshMKPC/lkvNOhxwjnMDrA/UqkKCeASIC94mScOcLhRmtjR0g1SKu1azFJxulPReDhOfGbchm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754764615; c=relaxed/simple;
	bh=LDjkT1zwXIRkMra4k9nZUSPZ4E8ndCV1PzaRhePEstI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:References; b=WzUa/7g+yZDpkMR09zl10XfWr8Nn8OugobakXj5XjjHwcXsahIbtkelSH6QvyUgb6OrgIAmqRxk2k6wUQuHMuP9A6/O2ThLO+EZcnrLYoZzkJUh7ompmX/DNwuKHiCiCJZqZyXzGtexeOFQNV8v+A+E7r9tj3Tk6hIZRyG6E+Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=e5yTUTeL; arc=none smtp.client-ip=106.10.244.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1754764611; bh=RSTd33FBgXJ3khA8jcI1u6Fz9T/+9TZQ+RFk4Bta1ZI=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=e5yTUTeL75RWyHCzD+SNJDDwj5pE5EupjRCvFztfW8ddvSEigxXxldWuR/T1tDY/xPclyw4Dwpv0ahORt89hyv5YnkpT6wr1G1qTdnmFYUOKLRUDSNHSMj054KWwdUK43E/uJ0YICphr02x8Yxh++pUshV367BKYWFh+ysqVsfhoOb1UV9/b6eF5fFeKBS28uuHnrsdBJl8CRQEDwPw+ghJnoDL+/+QlYq6z4gyWwgHq+K1KcSfYMBuFFgO7ZqixVi+1zAzmrUMM83s7rnU0KSXbu2BKt/6wQKDF4VmGQ5UNU39/Chok4dTY5ZSchaBAR8nhrfM0fCixdfbzXIKhjg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1754764611; bh=WQssXlE9wr8kexpuUrhewEBaxOxNey577dLi9ZIEQ3p=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=biOKDKayevX/TLGIdP4v+/dmpwXYOU2O5/jsnc9CgmcMq+n0u5EUZiqxKywm+UWsOaTxQc0DkwSjMs+UcNPeLJinOKx5191WqXXNk8a8PHosWoPltlsYa874nhowE2WAYpQXWIbYZyafXev4NGUBIqURlYaCo4Hd4nCIezFpPh8eT0UaSkB1qKbC2VkHUoAOEgkEO7GTfNqd5eTVhdjWMe+/Uzi0Z/MIrQAMv51CgiuYPUKJ0U+D4Zvmpl0t8nNfxjj8QhtjtuLNjqlh5FY9kAEuwQFhgqLL1WQfQRsMVzq49CdwcpyAfmfRz0MflkJXeqhbcjf0nArg4/gK6T7N+w==
X-YMail-OSG: UQDvST8VM1nKCjwsPQu7806zJw04TsWNuN8kSDOrRnMTe_HgaoyNFe8lIjHrdtH
 5oLsFtOBJ69D75cB_.V6t2uH723PQ9IMBWHd9BEDfOIHuGUBJBKf1nZZJwYenkdNJkfn9hP2Hqn8
 Wor9MPRtmjw8rYhddCMfba3ZUzTbcBKDbUGfaJsGpDdeF4KIeNvEakHXSNzh8Vj58qlg4Aput3OG
 LJvBxmTZGFI7NX.mir.Kk287G9v5OakAwzeft3gqbRF5tB4TZTMuhYip6CosFxw62ipxBaiUy8Fu
 XAVfiAE1_leIQPlEBHNODiuFI.bsgDdTvX.I8g_nzC9lNKYL..S7SoJTpBSQSc0I.lNsJA4Rp9TY
 CFfG.4LrmxTE2mbDXYVS2S1QPru7vh5QuuPPgB8QbGDW4gWexCS5liRUDx_RPO3fW8wLX4LNzT3U
 Cnkjh83hYPWTLO543CeFfQgQmhUpl07JlzBYYOGGDivQSrfzet.sWtHODkH5Nhhs1u9Kw96.V9Pe
 BvRls9a5LZmddr62CcrcTyFqjZwP8wUqda89TsdTUlBASVftSekQLlg.9rCJM25uRgj.jODTUEN6
 qdJPXrnKS2A98yz.sWs28yxMOnn39iJXNdiK1McRgLqZrbWtz4tvRLjPxx8UvOEi.zT6EDbkfUBY
 ERZUPB2vokthsggEd9dulZArXR7iho_DefGPPqBg1SAXLmq23LNql3tgzOGBthzrkU0guLtOu1Ze
 iM1br7s63d05MAk8GBiGYdim5szPLtUChWarFFHWt8SeEMYABuvF9XRJ2CDgoi9DtlnGOll8DOVg
 6Yayus8IK4qNBsz6ItktRkw965mDZ2m371hzDV3nDtfkapolIBVxaGbrttJdj96v7FHblbkRSiY.
 PK05moYOAsRBBuKnSI44ptlnpd7SRhJENLjDUTl93uWAhyfm9Uyw3uvK.T86mWFIq1c_xwm7xysW
 U9lDRbFHOpFfbUZ8aM1pUo6BHjlhBazxkKunf06yCIQniOdrD45M3ohMP6iFEHJjdsgY2Hh3JRky
 CpHbqnJO4lYJjPjTroNM_DoSN5LtFF1VDLxTp2R2.c.EgOGiZlQRp7pwgyj12T3fuTmbuq.uUgAi
 nQzRhLo_CVnob0Wmcxayq7Sdc87DrtLRz202Bu4MLmrkQoTvB1QWTzgp2VIoqDPEK_QbK8urV.B4
 7cIwPXdLQ908_bWSS3HBYJPkVbO4_fmfXdWvVyMrx2fAtTzf49X0OGvvGgrhco2I_AQXwiefwAm4
 64.NxCqte2dL2Z5UGQRNlUjKa76W3bz6PZZiwA4sTeZlC8bkC.RaLeqHmPYt_ED82l8O7ABFQ0Kd
 kiVW865fjK13UvKBtoBsxC5xmLYQO75o.DzpadkDqQLWfGJplHhhHtCt7tA6gZPHieehZmVvAasJ
 gwOGD5SS_BryYVQx_Rbl0rAVhQc_CZmFEcIYAN9EqWrOUIY91GgzyeouEh1MWju.21toYR.5H7vG
 dPUjsCBpGGyFGp7QkWeKreADCSnrN0OivEhydf4QwM_nTfo9CkjLMSn6RHMy4ft_KsmZgaqiIF0a
 tSgbnuCpkY_2M0IIhQtvtRzhsKpnHaVeHQiUiE4KXSIb6awX0RGpvX3nLMBygdSweorJrWWOfwRa
 OTwiakNPicYPz51LHZAEwF2kbZZsx0nIkGqxwqYUXVf3r4Y.MHd4bFKD7HaY.Rx8MK2HmlAs9kJK
 JJ5Vaxjz.S0grm0MBehLr4t5Zyzs.rhy0aqBubsJ7..ICGg.sVOb9FbtfIib3FW_28oZXpFmGKfe
 FMzXUMZmDYefmNdXoZ.mdMZnKBMylc_LErjTK9m6pEZYcRkEDITkBdmX9sYyCQ.GdFUqM4HDG_Kf
 PNwASxQVq1I15BLH2L6mtfFbY6hgXBmOSUbpWDyh0ZFQvSFpnLb5Ln8hME9Z0czlSuejIFrCwl7p
 ObA71m5l2AD3rLjstPtXb4ORr949WXRySQYfJOfpFPZz_vMBYn.kZvWa_9bQHwpUz_edZXyfdS9t
 UgXSfuLJ_HbIeQKQqWcvKRgu..M1sbZVRYDkJBcR5i2.7ttQW96DtSnZcoZX56KRt7O.WocOC29x
 bFpBKoYJktHfK1pkXifX4THg6dRmLsek9Cgk1rmavyUFArV0eWtZsSKvmeAMHVcmWt_HzQdmqCAu
 2_8hVH3jYEvZtz9URf3nPXHEk3APeHcmmmniQN5.4m9Vv70PKSi5iKU9XM75mmOFJgjYpFAlNNjg
 TjTlxw2tTfdQBdk1_ovSgDtdHxh3TKq3ZbLodyga2vbwcdPv7inTTcIPaXAapBJI.EPZmjLOI0Dx
 kDN.O8JqCqUYG11f1m0Vgw.A46AvZw6ZGur0-
X-Sonic-MF: <sumanth.gavini@yahoo.com>
X-Sonic-ID: a4a2046e-5582-4fe6-9124-bbf98711291d
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.sg3.yahoo.com with HTTP; Sat, 9 Aug 2025 18:36:51 +0000
Received: by hermes--production-ne1-9495dc4d7-jrxzs (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 5c010f19b0315d31cd33bbeceec8f515;
          Sat, 09 Aug 2025 18:26:40 +0000 (UTC)
From: Sumanth Gavini <sumanth.gavini@yahoo.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: Sumanth Gavini <sumanth.gavini@yahoo.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH 6.6] io_uring/rw: ensure reissue path is correctly handled for IOPOLL
Date: Sat,  9 Aug 2025 13:26:35 -0500
Message-ID: <20250809182636.209767-1-sumanth.gavini@yahoo.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20250809182636.209767-1-sumanth.gavini.ref@yahoo.com>

commit 	bcb0fda3c2da9fe4721d3e73d80e778c038e7d27 upstream.

The IOPOLL path posts CQEs when the io_kiocb is marked as completed,
so it cannot rely on the usual retry that non-IOPOLL requests do for
read/write requests.

If -EAGAIN is received and the request should be retried, go through
the normal completion path and let the normal flush logic catch it and
reissue it, like what is done for !IOPOLL reads or writes.

Fixes: d803d123948f ("io_uring/rw: handle -EAGAIN retry at IO completion time")
Reported-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/io-uring/2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sumanth Gavini <sumanth.gavini@yahoo.com>
---
 io_uring/rw.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4ff3442ac2ee..6a84c4a39ce9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -326,11 +326,10 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		io_req_end_write(req);
 	if (unlikely(res != req->cqe.res)) {
-		if (res == -EAGAIN && io_rw_should_reissue(req)) {
+		if (res == -EAGAIN && io_rw_should_reissue(req))
 			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
-			return;
-		}
-		req->cqe.res = res;
+		else
+			req->cqe.res = res;
 	}
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */
-- 
2.43.0


