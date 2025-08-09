Return-Path: <io-uring+bounces-8925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 658B0B1F648
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 23:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80D8117F26F
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 21:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C69323F417;
	Sat,  9 Aug 2025 21:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="EBFrWwR3"
X-Original-To: io-uring@vger.kernel.org
Received: from sonic313-20.consmr.mail.sg3.yahoo.com (sonic313-20.consmr.mail.sg3.yahoo.com [106.10.240.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1AA238176
	for <io-uring@vger.kernel.org>; Sat,  9 Aug 2025 21:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.240.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754774095; cv=none; b=JUu6TvNJEAGoNTDZGTOK1k3xFuztLVXyu1pImZhMvsh1fBjZHNFdbNeKBRBqiXxey1z5kjmjvvuO7Rs2Hed/v5jOXDHPHgK1/UpY8h048yqVx3i+8/35nNt8okMBIDLPjTuWRYBREip/++xenXDEANj/yd85fbs4OXA/iWx6ZIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754774095; c=relaxed/simple;
	bh=d0Yjtt3IzlqKcHROs78kHofsMlGTuJ7ll+LtvZtLsjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urov9yXgkKlkm9UTk+M+HObqHCUbfumjRxUfvT8AS1/rYA6w4lCM82romjFMKAo66E4glPcAyAG2NrQzcSvRltqLhlhe3T2bHjD0kvtNzy928qHy2nN+sbNlPnWbkikKgpSmr3Lwft4PZjDhwCiVDDxdefB8kUPTJOniU44FEGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=EBFrWwR3; arc=none smtp.client-ip=106.10.240.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1754774085; bh=+ykyPREPuo21LV5KP7vBGJIecoZNQK65w4laRFBAxUo=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=EBFrWwR3eFJKcCMVuxYic1P7jbOpSiIdNOK5+KdLyAN7U64Qj6n/MadFYNrDA1DxLsm43xxaOt8GMi0tCpIsMBReCg18WPN+fGWz9ibJyBGBzIBOX59H55a7U2EoYC3Yg6xvGL5iuO83gV5QnZeZfoRIjc7XnAUEOFN+kCmB9OahBffuxvGCnLhkxqashm9bygnC+KXuvRCw0TU6+XdTN1fVYueAvYgO2ku/0ykDBDICcjGjcCtF6NoghgkKstXwmlcmWL/402DZwQysc11Hu9zapS1ywf5iw8ZgAidLXjW2h+UIVitATztCo38ZUKLKqDaztiUBuMzdaTmGPPBZxQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1754774085; bh=Xp6TUaWNIRXe1b2PyGGeDJBwBciovrzamPlRZ3VbFcI=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=lSVelbyHgiSBMazUE8RkNErvfKi4QPrQOaNm2tdAYRx5uEWB2Fwf3v8T6FYMisu8BrMjfcRxA5f6DVWO3SHUhjg6P6J9oboMxAhFVrxPeOyuvS9t9Z56ICM/2zzFH6khx1DAAD5YeonkFeRi4WxI5i6YzClJTcY1KZwRZSHKGldcxGmkC2GYTBvTr/ut+lZ62gJ0+7Ls9AANHIuplnbp+ClaCpWsnKIKDcRNLp7VjdNDLLZi6el41/bmzeZ4GnagV7E3JEh5nVoKxuOBrOmC/+kbJnIh5RYB3NivUZubrFnW5YbraQR7uFXkJbNP+fgvo/FV68AXq5G/+BYqnoBqYw==
X-YMail-OSG: .zwCfjgVM1mDn5NwRxL.9Geo041SjG.__aX.GjsF37GhlpoTanX6ltexlztkJtq
 XBYNvaqTp31Xqo4PqIoU9N0GLhr87k1qDOKlP94ULYs322_7N4CFcMYMPllbP1M3TjkHtg9piuFP
 v1LaqzexHlhHnngUmRDTy8X8SQEm_VRpEgIchawlevlyhmVeg5i0GGTWuV3eG7KrVEFEOsV8mTuy
 FwdRV1U7D.jHeWIXmJjzAxPkwEnOHUUM0zKrP8.MhXkwJBZRDcgC5mPHgHHbRci1sTcvLklW7neE
 gcsKhmujIE1z0KEt.oAseFux6xceP3gQH9aGQDgceJBCZ0m0r4q9u_n9cLgZAJhh6uQyzwrpEftf
 Edwu47ikKAGeW1uVIvi1JIwT4syjvG3YRBmMuO59n2OvOJSZq9aNBnVrCIRq2LY9pxI9aYB0B.n7
 Jh9doPGkmaN5n31rZNMtQ8GivPCFT2I1zOUgVAgVozRr0A205RKGKdw3tS3ReZF3rfM6TAuULTyj
 R5OvuwS7KBAxMscKF72qhF3LCbTDsa4nhMZZKS9rOxSIlcqAIpH0yls_FjW_kghsa.VB6aomtKtS
 chxgKlYlDxnZ4.bmRupiovD6SRruOod6PIQdBEuW47vlA3l6HgieXjKpCLAdpbSa0x1XcvbXKrkp
 vrNm1AF3IluKSppDKZ9SIi0ukMExD.6ybyvSR6dKrxEwEwrb7Uy3lqZ7NUM2h1u3VPz8H4aPmMsY
 2jDGuUvEXTRyMQSq2I125MgUFGDWGujiLrbunkSo72sXXvFx8uaG9W53N_DFO50WVxeqKZ4q9NZV
 z3cWzggSyAs2K8MOfaxyz2srarqsa0ijW7ViytBJa.gjRtVQD3kNytxJy7IRwBg1jkizPaO9Ir_F
 Gi3bqvoUrwpOEaj27_dC.uxt24lTB_RWtWTzYWwnxHbCZwo2d7O3PaSpdRT24ugFTwX6wbQWKgZ0
 n85d8X2Jq5KIs13J0J1DUuYueiXPBxwNwbgd_TvZinUY1GRtRTciDovqzirbADUt5QQyNDn5Bu8l
 _awokpjRaBSTxnxpzOCO0ApAw4XoLBHH24nfsvaKQ7lH5i_I.Zcz6fI3ry7R94EgBcIfnd10Um08
 vtj6h1eK7M8h4XpqdpdGQqiQyGsX7whxqWWv4dHWa2jeq0SZEThyb5oe_6n2pp.75Pdb4hMLJq97
 Gq5_E6qhk1jhxHoFGR4DJN9o28CTMHfV4aepUk8cpaz_jGg5sC4a9rsbNctKEImk.sgR8q5WWHZq
 848GOjpcd0FXEuxEzRIwB70KH83rYepJueW_4K32hkaCceh9Dsi5_X5DSE_59QmLbOT2y_EPOx.E
 Jw36O9cMd8a594DSxUQv8ONKzkuLVxxpM.rgEZz4ArKLE2U5L3t4jT8i8m6WYhF5Z359bR9SLlFP
 7u_K5WEzpkyZtUgp.CsZPTE7Gsmv59LL.e2oMO9aCNwPXLbnzp0gY3JGFAMAXgEtjJcSBnx2sChu
 L3pIHjRgHXi1ZtALZSH5VqlsoOOShGGL8c3rc4P22SSWMmpOuL7wikrsu5jlYOfOv_x93qfH5zQH
 pGKVvkmIVFvF4nw9dvXHi3n0gtqcFGU4OH0RQrGp.ru1v1WSVIbSZtK2a7b6F45jKv2irNI.9Hzy
 7ncJuvC_zCTvaxBLXDABOu0zKJJE2kenMVDZutPP3r2OarD795WSIquLYXAf2dQGjb7a7u1YXJ8H
 L08T2CBogJCY.1HJYAv4lxDscxYwb7Q0UYJiMTPkl5LB9WaTWDiU2hQU47uRNovkJiaRoKsWe7FK
 Hx8DVKBrngQ29_E63bwjpnVZyt41e_RWCW.NNl2IeNqISsxo2MhdlEOCUaZYv5kRO0mRp0DzQh8h
 04diF_T1adXMJtxzhM9x_CgsO1oIZCwzNc9VVBjbw1d2tjCumIkCBfIC2nIUGMPrdDzRKnNvzaAq
 UMqJmRYJfGBMGKSeGQUsn4_61dtq4Hl_FfKxPS3o6mM9h4EsSCT1veB9iL27ugMuZjWGPo1svtjA
 RHQgdMwSzwO1xOt28bv4.ZmJvsfbvusbzglAeesgWAKyUNaHu2a1sjnGmjmlixaWMHfJGGW6Y9WJ
 lMK668PiYVGaoxtE.gIzTmMcnv4s8ubop959ureaqFnTI53nSLmFpS80rPA9E10uPbz2Jiy1eseE
 aALM1Xwq93uIeq3DIuDQ7PsupFBcAirwMtYP4CXRRqMnI_B2AaY1PuZDhFBotvRznx7c0PNGO3UN
 OvTdV6lMucAKkCalUnYiKsZ8eJV10SUYurxtkL_wBvhsMigST0_jMocFU3ozU6taVV4h4Lqo6fgL
 bBrAjSsQL1h9pM_risZoSynbOWK8JRxAP_k1Tlw--
X-Sonic-MF: <sumanth.gavini@yahoo.com>
X-Sonic-ID: a3d1a8a2-68b3-4579-8586-96106a1df016
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.sg3.yahoo.com with HTTP; Sat, 9 Aug 2025 21:14:45 +0000
Received: by hermes--production-ne1-9495dc4d7-psbrp (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID ad8551e2f6b02f307823b0a83dc795a2;
          Sat, 09 Aug 2025 20:54:25 +0000 (UTC)
From: Sumanth Gavini <sumanth.gavini@yahoo.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	lkp@intel.com
Cc: Sumanth Gavini <sumanth.gavini@yahoo.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	oe-kbuild-all@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 6.6] io_uring/rw: ensure reissue path is correctly handled for IOPOLL
Date: Sat,  9 Aug 2025 15:54:18 -0500
Message-ID: <20250809205420.214099-1-sumanth.gavini@yahoo.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aJeVj4yXt4F01nPb@f5c43a121a53>
References: <aJeVj4yXt4F01nPb@f5c43a121a53>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit bcb0fda3c2da9fe4721d3e73d80e778c038e7d27 upstream.

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
Changes in v2:
- Removed the extra space before commit-id in message, No codes changes
- Link to v1:https://lore.kernel.org/all/20250809182636.209767-1-sumanth.gavini@yahoo.com/

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


