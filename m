Return-Path: <io-uring+bounces-8220-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C95ACE299
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 18:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FE8E164DE3
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 16:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C92A18E1F;
	Wed,  4 Jun 2025 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ds5xzmVB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A981BEF8C
	for <io-uring@vger.kernel.org>; Wed,  4 Jun 2025 16:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749056216; cv=none; b=ETHAwxM73NOCcewh/3JUnB4Ewv2GWRCULH34XsQRjgLKNz1xbf6IMrNjwFnkaVbWUfi8So4TYiKx5sFJRiOyyzaNueFMeLtCZ76DF05RaIODRvBkoNYqmMif+z+VgLDwHoM6R//P43HBky0NF+SQslPz3TAvYtvFCXkT5z2RH2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749056216; c=relaxed/simple;
	bh=dUD5U/NXrpnliY1Hynt3ERy7INH8eyWJX3K/03S3WJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvHnBwbupEeJv4ayJLvytlQuCYf38m5/roFP8hHG4gjHBui/4N6w1Ms59rTz+2nGyeU2Ufoh+PKBeIhgcXYVTqVc4F18kyeTJ6O/BhNACInlOeiX+X39rEQWTvcHaYfDgi/53ub/G1OO0eCDNKlFsGNHeFPBjniMveanJ7OHzPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ds5xzmVB; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-86cf9f46b06so41539f.2
        for <io-uring@vger.kernel.org>; Wed, 04 Jun 2025 09:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749056212; x=1749661012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d6dl/v+6k0qOoBi/BkhmMcuUcNEQsiVrr5nJb6X2HI4=;
        b=ds5xzmVBSGBBmhqJLtE5N8xEaNNH3h89pRvRJtXJrSg8WHoPeP+urdj2sqlauWQJ+B
         L7f9IEwijbKbYgNBM7xLuhs3X8gbYkv90LsHGvvODloZmMAakWrPqtpYbHhcrYzD17uU
         NLpoyxriA/Ww6A3wK5B6uxXaWbhnxfk24BeWYc8/TwWreu3WoMXePAU5/3d1aDU1md4G
         As/HEzP89jV+bnDOZtAmFbMaIe+KIf9JPx81g4y1TYwKMo4EFEUS70B8Dd3gxkgDtLaZ
         rg17fLRVNuqKSbQmqxB0P/1Id4bartQi7bSh+GV23om2StJ36iFz3yhrTy26sQvn4BFe
         AoNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749056212; x=1749661012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d6dl/v+6k0qOoBi/BkhmMcuUcNEQsiVrr5nJb6X2HI4=;
        b=Pc2zwskAXhMNWxzM3KqFm77fTpfMcxhxxX3wu1XO2UJiZ2eErYJjkHJ6NJw+X0QQMn
         WQJLL7d1YMOvN312vupygx777CNJ203XnIVKyRNCa+rC2NSoPGAXspXZc8a434VYZSkh
         2eYPFe16IYD4soJubr+5kbV58m+f0leXSO1VPavN74JiNGFu38tldZ6aKxfKgtmFYw9z
         4HZYvb5zxC/7CM/FpSu/74tbkCRpNkvJyqD2LEn+CBJwX61CojkEyipvJrqMkcMubeA2
         hYmMw+saNmCsFgYXLGQ3F+BZQapVpi60QtRjmfSUHO3BhjpHs4TIavHrKwOCA+HAcVPu
         1O+Q==
X-Gm-Message-State: AOJu0YxH2Bv/M88cIvQy37KLT1/Gu9G/iL7T8cG9H9Dixe2aY5fH7vtZ
	S5Ufgp9VqzJCP3xeMlmsF9EnlrOM/61FC+vkjmSaI3dBLtcpDGyODBdzhE+o5b/T2BbAuU/NMr2
	IWI/9
X-Gm-Gg: ASbGncuYKqkklq4s7nPG0Jt1RWJoz6Cr/GNhq4Cb8YS9NLhegA+mYlh07Vp9qkiFVOG
	/bXy+Yx8ArVUYGylJhA1niVvqeRntYBhZSNlHUZw3ZjgeIlke83303pwKq3CVkHLNwMKRcZE7ZK
	JZP4/dkwRB1U8SlEv6po5GOnLGp0z+hmaLxyvYf58NT9sfPQ8HQpFim6zEO8wizLwUt7sduj6Ak
	X/vS0X6cl7CAuOIJi4jXotj6o4UPAutWr3e0B1rCj65uPn4KvsOpbGlOLuChoxOz0pxOfI/RxIm
	krtjz+STjBjuWIIaqZltaB+1+DrEggoDf/TgZPdVl8nzJdUtHhtc0t4=
X-Google-Smtp-Source: AGHT+IEkDED3T8HpWLEKX9hbvXTV0ezuPpNzIrBoWszFHepwgRGdp6/MOdFZnRm/q4uc2TtlcA/QwQ==
X-Received: by 2002:a05:6602:4a0e:b0:864:a2e4:5fff with SMTP id ca18e2360f4ac-8731c544816mr537252439f.4.1749056212220;
        Wed, 04 Jun 2025 09:56:52 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7e3c18dsm2751391173.69.2025.06.04.09.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 09:56:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: rtm@csail.mit.edu,
	asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/futex: get rid of struct io_futex addr union
Date: Wed,  4 Jun 2025 10:53:34 -0600
Message-ID: <20250604165647.293646-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250604165647.293646-1-axboe@kernel.dk>
References: <20250604165647.293646-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than use a union of a u32 and struct futex_waitv user address,
consolidate it into a single void __user pointer instead. This also
makes prep easier to use as the store happens to the member that will
be used.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/futex.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index fa374afbaa51..5a3991b0d1a7 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -14,10 +14,7 @@
 
 struct io_futex {
 	struct file	*file;
-	union {
-		u32 __user			*uaddr;
-		struct futex_waitv __user	*uwaitv;
-	};
+	void __user	*uaddr;
 	unsigned long	futex_val;
 	unsigned long	futex_mask;
 	unsigned long	futexv_owned;
@@ -186,7 +183,7 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!futexv)
 		return -ENOMEM;
 
-	ret = futex_parse_waitv(futexv, iof->uwaitv, iof->futex_nr,
+	ret = futex_parse_waitv(futexv, iof->uaddr, iof->futex_nr,
 				io_futex_wakev_fn, req);
 	if (ret) {
 		kfree(futexv);
-- 
2.49.0


