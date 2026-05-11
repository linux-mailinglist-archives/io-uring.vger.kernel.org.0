Return-Path: <io-uring+bounces-13268-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CB3EB7gfAmrAoAEAu9opvQ
	(envelope-from <io-uring+bounces-13268-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 20:28:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 227D651470F
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 20:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B3AB53009F05
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 18:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36A9472784;
	Mon, 11 May 2026 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="BQRt35fn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25364472774
	for <io-uring@vger.kernel.org>; Mon, 11 May 2026 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778523745; cv=none; b=lJpDdfqH9SqZOS90xcb3IdG4XhBh+iU2nAsBLr0nRFGm1oE9KAvGtsubet1TyrmGtd/3CeE+Y5d9QFLrfpjIf8811+mDwlUFA7Yo2Os2d93Tz6X3PBhRJhks9kGZkBpeOgveay4Tpfjfokys9ec8BCymiKslstIS+n0U2hygm5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778523745; c=relaxed/simple;
	bh=Uy7O924Mu5EkBmehO5YQ+Zwk8wVNbQq3rWczihUPw+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbbugyrcQv8Tb035LsIAsckWdFVB1TgV7stcVRmWWhPMfUssoEuOwT+Qq37L5MdnxpoUO96fkJRsJZ1cVueIX+Oxkg6m+g5V9kniEV4ZMiHNubhFX1szhBKHCf8yHp8k5+tgFImPs7GHauPnrayxyGpt39Zn2rbWEa3V78ly95A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=BQRt35fn; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-41576c5c01cso2844089fac.3
        for <io-uring@vger.kernel.org>; Mon, 11 May 2026 11:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778523743; x=1779128543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2b21n3Mm+nClyF88V0mpEnnFmYJEnXXznAvFmS7Qt3Q=;
        b=BQRt35fnYhx+eIfK+OrfdJowwjyTfx4Vb9Fi765AHMfQ3pVP/weRMPeVJ8LJ068Y2U
         ypEeesdDBEy1a3i5K1NWCRMv4L65gVYPTYkXm16B1Xj0gsVpXVMYx/i0BYn7rME7WBxS
         zQMUsfsZ13FFdIpagaGEt0W53jvkpNwPWFUyC1Gi75VNNSbu2iMCXf4sv+axQyjELOZL
         9A3LZd7gyt3gZT/Aaz+4l6So8IevHeQDzXil//+uxOzKKOqfYn66HkWXeUKvS5i/4YS1
         YokwzE3iBCpNiDjl0WVYcm9eH+Dhrqidb6o1RQavnYDYJy+F+VCApmh8AC+r5flDdrHP
         yeqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778523743; x=1779128543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2b21n3Mm+nClyF88V0mpEnnFmYJEnXXznAvFmS7Qt3Q=;
        b=k9frBDIOLQgXz/ssixBSJe9Kf2VsE2x8lZ4xqFOQ7+LLHz/a9TfbGSUVGh7yb2YlX6
         vsdzAaIuGYiJTKtN0/HLmfYJdmIhPEl+FE7RjdiFUCJNTqDSwBtvPm7eKS13eJxiUXzJ
         YLNz+YtGlZ9b54/K8vLNRcnwC6bNxRwtfsM2E4gTvHEQevlLu1TNfSI5Rn9UI+7JdgY7
         o9Q0DIAa8oDaFQuqCtSHVpPMS6pLU9TXdu5E12XyKcdNelLtVpVTfaj5uSUDhMq6lYv8
         NaNXEzCxfBvbqDkQYufY50vddxsIC8q0c9DnFwlEJhQNJarp15t0Akjt85VJ44H9PqSj
         VgcQ==
X-Gm-Message-State: AOJu0YzGfNPcGbM6Qkz1c5WMRcFmcs23ew8VDbJM7I7ozr+NGgdCJjjo
	qB29fcTZNH0JSF05H5ElMD4x74xffFeRW/rnoOMNJ7z/NOXn7cGSKC5vszVVnGay5Lj1MnLbT4J
	PFKel
X-Gm-Gg: Acq92OGBL6abOo64WUDcheXJXdwGZgRh+HSsCvi23NS5OmmZfO8OrSzZJtu3uieHCok
	/B7ZB4ALnKGf6Zh4CfTnKfF4M8RFF6YIoWRThmNH/b5UXjppShrIV0yCWC4R8NqaIkkNi3lj3Ca
	/VH20ptKHr8CoTmv8G10nnTiqa7Lvc/snyhKt/wcN8Z6kRoJeEjubmyCuQi8TRXEXNLbP0tKGP8
	tO7fsey4gg1h4CJIIIRIc0LZ2Xr2yZdu60qsmHFYyck2qa/cii2L3iReTQy0CFYauEjH0SeWfUn
	WNxgtl05HgIymq7vaLWi6QQ0djawYyZK9nz2gwhFUCcoQpqGPBMxN8svitP964m08k4+gwFWVKT
	ziz225cuMDsptf2ON1r6gbJCRQXwu2+Z+ujyegB0k6jE8vHqNCwd6t074MTxjMR4Jl6Q1rTwVsZ
	S+LR39VnelZGaCnhtIwV5jSsCT1+UFMus/qS9RW34lSNvUrWXGryGvXBeZxUeQQH7bvek=
X-Received: by 2002:a05:6808:350b:b0:467:3f4:907c with SMTP id 5614622812f47-4804252f32cmr15486201b6e.47.1778523742619;
        Mon, 11 May 2026 11:22:22 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c769c9b12sm20749141b6e.17.2026.05.11.11.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 11:22:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: hold uring_lock when walking link chain in io_wq_free_work()
Date: Mon, 11 May 2026 12:21:02 -0600
Message-ID: <20260511182217.226763-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511182217.226763-1-axboe@kernel.dk>
References: <20260511182217.226763-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 227D651470F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13268-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

io_wq_free_work() calls io_req_find_next() from io-wq worker context,
which reads and clears req->link without holding any lock. This can
potentially race with other paths that mutate the same chain under
ctx->uring_lock.

Take ctx->uring_lock around the io_req_find_next() call. Only requests
with IO_REQ_LINK_FLAGS reach this path, which is not the hot path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ed998d60c09..2ebb0ba37c4f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1452,8 +1452,13 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	struct io_kiocb *nxt = NULL;
 
 	if (req_ref_put_and_test_atomic(req)) {
-		if (req->flags & IO_REQ_LINK_FLAGS)
+		if (req->flags & IO_REQ_LINK_FLAGS) {
+			struct io_ring_ctx *ctx = req->ctx;
+
+			mutex_lock(&ctx->uring_lock);
 			nxt = io_req_find_next(req);
+			mutex_unlock(&ctx->uring_lock);
+		}
 		io_free_req(req);
 	}
 	return nxt ? &nxt->work : NULL;
-- 
2.53.0


