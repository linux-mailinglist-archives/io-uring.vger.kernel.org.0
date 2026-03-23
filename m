Return-Path: <io-uring+bounces-12799-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +F+DAc02wWm7RQQAu9opvQ
	(envelope-from <io-uring+bounces-12799-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:49:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D262F2339
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3648D30209B6
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8E83AC0F0;
	Mon, 23 Mar 2026 12:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GHAHMo8T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554E13AC0DF
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269863; cv=none; b=Qd8rhkfSNBpfa3Z7nGEmFskd9bfcRllzZGvmu5ZilISY6f2iK3LVCb1uFfPWlruEGROl7bhb0DeduMaGsqZrtLv17KeFi5XijvbUiVa6qbYsOutOh6o0Cgi//dfmrFJtE3CQ3OTRcHo3IcaxJKE8+g1sHoLhJ9NpFlBvChcjgDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269863; c=relaxed/simple;
	bh=6Bc6cKgO/2CXMucSxQTnwkEyi7Rt4xkq/7FhXfOzrWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca8P8wLsO0zif3akX4PefdLioqAuIF/EiVm2pNx26IIxkVg2x5J5TUOkzt9bhBMrNXu+tydHPDfGcM6dZgxP7ypz0JxgUSjpxgmYCx6G5XvHMw0prVOIW1vXX/2oer+YybJX88GJUNYY1VfA6MNpX0gqFNaFFeHbnQjrxP4Ofkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GHAHMo8T; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43b49819938so1676332f8f.0
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269860; x=1774874660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vuf43jNWxSVPbNjOcURurdJPUaOrCnD61oUU8FfllWQ=;
        b=GHAHMo8TIRqkGhbsaXA5btiV5T8uJaFEWL+EtyKL5FNOSlqq1uR7RCtm4elUBI7shS
         GQhKWSHCy+t/HUII9MNaOm9xH/XDptOAxzPaoZgEX6rEtfjmMoxnNUq/Cs18V0FTDW5B
         9QPWo6sIrYTURjQxwPpqfYN+pcwXihx7PFRyedHjNUM1KxcS2BteL+n3bPlAsfIlMRjd
         XC1uDOFf2uIi6vS51oPQ/5C++jcJoFp+oxWjPp+AAPkDEizU8OHUu/CxWBe43y3jka5O
         RJ04JLf69FiduzuHoLkG1PeSf9Fdo0VI84yFyiw/Q/A06tLM8/J8p1o5ZsRFLLicpTco
         zrAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269860; x=1774874660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vuf43jNWxSVPbNjOcURurdJPUaOrCnD61oUU8FfllWQ=;
        b=LTcrrpGJVaJIezg+eMIgYoUMsqAFo9rP7hMeNpE7uJKXJfa7c+McwuvR4OmDygRaCS
         qkJyuomsFFkSOVQDz9DAZ2ztlU3cFNjZj6rKjDGV6fXc66KbS0U5qTkiD9XegpQ8FQIx
         4XZpOp9lDHnnZKyMaI62OmHqSGIi+LpV9dHXkT5IBUYHN5OuCJeVMIkwtbil7La9V6Vz
         HxRi3K6H2zwVrMxKDStxqKhWfS7UCiZqxkJSusVOH0gQvjcgWZBRRBiYCGFujTrMFKuJ
         pP2+NbhD0fzFk4KN2lIImKth+sYC/fUrXhrW6dji8fb7727TxzK2jTDmAvHrfmtpTq3A
         aYcw==
X-Gm-Message-State: AOJu0YxhwM0t+rc68XGD6EJ25GDu2XdaKsct5zv8fcbtp4myII31W7Bk
	SwyQ2QRVxsiLQ7bXOb8UKDDZT1mtpNWvHhO1zT+Dug/cXLOF4OlaRr+mxYr+tQ==
X-Gm-Gg: ATEYQzyWE00MfurHeZMbXXNuH/B3AeYTIcQwRRlJ2sUDf1Kja1OrAcqBZgWPuJV6a/v
	KAzmq0ahcHXESRSbCkp10SfIVB4j59cdv1FYAQZZXoTtpnYTOvC3h7jVaSpbD4DCaFVKCNTATTC
	LSQBBJPznDKVQlrPn/yLCQeuJpUpaF/Il2H6VEJz0lN3fGYWwMOcOsonQU2BX12LupbPYQ9/Xdh
	vLC63KxN6h4ia1VPKSs04At3aN9x8ZvuDrY+9vFupftxdZERx5eUj0zIy30+wNslrBwHxOD/Fc3
	ppqt5BWjWRrvX4jtPEjezm3TTOlAIeVQLCQJIBE9wRctUrp1Em2r3EyqyjIevBdnYyJ+dGp1YB4
	IYIQO1FjuN7JXsmy60ZhHwT6BLaeZSJ7XENtmdBjoicwtzrtMY2lnVxypB/iHTyrMvdJkIp6J6e
	9a+gSKYM/kx+CjHXDfh2rtuQWTWtpXUVG+r/j2Wt+xR2fr14d3j4udliB2kBRe9nS9raZi+00TK
	YGx8q/2kg==
X-Received: by 2002:a05:6000:601:b0:43b:634d:1a9e with SMTP id ffacd0b85a97d-43b64244c2amr18949459f8f.15.1774269860229;
        Mon, 23 Mar 2026 05:44:20 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 15/16] io_uring/zcrx: check ctrl op payload struct sizes
Date: Mon, 23 Mar 2026 12:44:04 +0000
Message-ID: <af66caf9776d18e9ff880ab828eb159a6a03caf5.1774261953.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12799-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 00D262F2339
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a build check that ctrl payloads are of the same size and don't grow
struct zcrx_ctrl.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index d6475f95b815..620482cdb083 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1251,6 +1251,8 @@ int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 	struct zcrx_ctrl ctrl;
 	struct io_zcrx_ifq *zcrx;
 
+	BUILD_BUG_ON(sizeof(ctrl.zc_export) != sizeof(ctrl.zc_flush));
+
 	if (nr_args)
 		return -EINVAL;
 	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
-- 
2.53.0


