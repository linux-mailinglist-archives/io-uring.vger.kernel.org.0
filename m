Return-Path: <io-uring+bounces-12855-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2MXDG1Lkw2lvugQAu9opvQ
	(envelope-from <io-uring+bounces-12855-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:34:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E1F325DBA
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F346A3104AFE
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2597E3D903E;
	Wed, 25 Mar 2026 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GrIslJOW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13213D88EB
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 13:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444162; cv=none; b=nXuPnEN3j/TXhATOHkTC3rc22iq3OGz1tavJfaSeHVggYbVSaLY33rHnWKykiwFl2XYXkA2/Lo08N9r99mOETzotU7cmxgvcTJuC28G6G00kmLr5nX8xI83bnnacN1V8oozBk4k4ajhoP1XUyeSN/yYZnQz+rfhY/nMHGEUQGeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444162; c=relaxed/simple;
	bh=4x8RsRYHSVJ6BDghnxivghnDNMxFRg7y5DdK7gpMJIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTNqb6tj+mPkdUEoJSu2AXJoIOsBvGeur8ryYFpsz/f060LuCX9qtGaQxDjXNGKJtAanMZCNd4AACcT+s331dfDR+dL1wrSA/lx91j/oDWqKYQuXboI/dXRnQy2P1WFK41G+zTILPq9PXJC+eGiBMgoT93i927/j7vvROJimaJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GrIslJOW; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48538c5956bso8655415e9.0
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 06:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774444159; x=1775048959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZY44Vz+RRtLvJFlfTuASn8GA5yb2+/RMxxe6l4LE5sw=;
        b=GrIslJOWVnJ84os9YCdqh/lybsaaUY5etpS387NFh0af7VAs0rzSwT2w4VpJD/ky6n
         9Yu0W/H3dLXDUVZk/hlGM4sb1cVWYjbJ9I6JyX35zRVml1bi9sZ2vkLI+74xsjX1FwMM
         /BRpp9wqu17uUx8qZPnLRIyC4TkA4V7UsHAF8x6gV0NcOWkRaTWjK+4dH0w3hTy99/K7
         pcIVbAaVXnbGZyu5cINVvCn+sxJskEIsSwsARBcXzxafjT9wQ/jagg/aVFuVVZuph3wf
         DYAqcmr/SmCsLtSnDUCCxHrsRRql0HM7dg0MDQmkfsjHpZRkRiWlcjuCf39g6uAc5p5J
         3pJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774444159; x=1775048959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZY44Vz+RRtLvJFlfTuASn8GA5yb2+/RMxxe6l4LE5sw=;
        b=lWljxb2QPOQJCo9BDz/4WgP7sSgjS9C2yUivCOvBGIXLsprIBldEnDe5lq37FwZyDk
         RyNYq4Bc6RX4SxtCkCy2s9UGiPIwQC7fUUlnl6mEK7Pk6DQdORgE/SVzktGzvxmpDCdP
         YYA731kS3FMsP11bj9xNkEbQBTYAgNlMYk7jc5+RJ1Vp5j6Z4r2evYbPy+xsfwYZTRLR
         lcou7bamr/d9jlXvclqtrBI+Ygyo3lImc8cEjPPn4e3FexUnUF7v4CzKACEaJyueL7pE
         AVvkLuzPW52+zzGStZGMbqv2PaHtt2CIWwB/ESkpsmd0Y3MaWmgsJWgu2caiwik7o24c
         Pi3w==
X-Gm-Message-State: AOJu0YxcaS8RNP7ykIq4h1ZlZgM5Mf8j0xBFC32giRjLKdeom1sRClJI
	+1mBrsX6VJ84VekCdHPO7QKw5p/cYWPFe9P7RMo7gUjDJDouUjcSszIiPb5ewQ==
X-Gm-Gg: ATEYQzx3hBqoJGXBe18hLpbsIoqisHo+tlgRlI1l8Pm253+SGQte8Y1SaW+caPwaC60
	iXKoF+AYTCCivUjs6NSk1SrDo6vUCUW7j1OJV0hWj1gLLZUJrUwZ8QWMiEjaHwpIpVwll71X/9n
	4Q6o3BPhgkPlBYj6Bz6WxB45YZlDkr+mj9av8Tj9snDlUnTdi9TGtzZ9ENB2Sed5kqhzwFUTq/o
	b//94/YkXfBq+Ae7FP5gpRUcVEQxrGuPWZRbe4TefUScZ/1/hiJp3kHdy+L1A9vELu5Jh3xbXyX
	F4VZWRHa+edrEgOIu3NXnskjsWjSdAVgTkxl2Zbd1b/Bg2byyA5HB8LxQUPLGa8ewN4m5X93iMe
	IOTZcM1/cT5UhlCF+Yk+fcuwXFFtXZEW9kGKuA3wbjBYmMDgiot1lE766K6DafEPQ94x2vHBaTz
	eIHigBRzKGEKiyCDIf2u5x0OP4+zSPa/svdleuUnuKZKUEgbNW26bqQpLt6r0gBRjOOz4GwQwx/
	6k54L9HESB2UYQZt0cs
X-Received: by 2002:a05:600c:a293:b0:47d:52ef:c572 with SMTP id 5b1f17b1804b1-4870f1eb16fmr73778285e9.1.1774444158538;
        Wed, 25 Mar 2026 06:09:18 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bd923sm54062611f8f.12.2026.03.25.06.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 06:09:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 v2 1/5] io_uring/zcrx: reject REG_NODEV with large rx_buf_size
Date: Wed, 25 Mar 2026 13:09:18 +0000
Message-ID: <3e7652d9c27f8ac5d2b141e3af47971f2771fb05.1774444007.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12855-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E0E1F325DBA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The copy fallback path doesn't care about the actual niov size and only
uses first PAGE_SIZE bytes, and any additional space will be wasted.
Since ZCRX_REG_NODEV solely relies on the copy path, it doesn't make
sense to support non-standard rx_buf_len. Reject it for now, and
re-enable once improved.

Fixes: c11728021d5cd ("io_uring/zcrx: implement device-less mode for zcrx")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f94f74d0f566..1ce867c68446 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -449,6 +449,8 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 			return -EINVAL;
 		buf_size_shift = ilog2(reg->rx_buf_len);
 	}
+	if (!ifq->dev && buf_size_shift != PAGE_SHIFT)
+		return -EOPNOTSUPP;
 
 	ret = -ENOMEM;
 	area = kzalloc_obj(*area);
@@ -462,7 +464,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (ifq->dev)
 		area->is_mapped = true;
 
-	if (buf_size_shift > io_area_max_shift(&area->mem)) {
+	if (ifq->dev && buf_size_shift > io_area_max_shift(&area->mem)) {
 		ret = -ERANGE;
 		goto err;
 	}
-- 
2.53.0


