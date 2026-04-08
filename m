Return-Path: <io-uring+bounces-12994-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mBneEMlf1mkfEwgAu9opvQ
	(envelope-from <io-uring+bounces-12994-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:01:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 36CA13BD524
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 019A8301A098
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 14:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11683D3007;
	Wed,  8 Apr 2026 14:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="jTmfBXcp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842033D1CD4
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 14:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775656846; cv=none; b=r/KnK4HHwWZIwiBpjuOUR6kVz/GKr6vHLfjo6GAxtp43xpaOGFxr2fqKsTGnypb3W8G70/7DwmU7PlxbHusDJIDfww+TrCa7GVMPM5P5iSOcl8TkQ8x3nknwUMLgPr1OruyRsnsxJEqDuKTYyYjonZp+8yHg19guYXCcaKSmiFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775656846; c=relaxed/simple;
	bh=Ajh1kH0EH04xoJ5hb4yQC9k86L0NK6LiOGqekq+uiwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6YKZvwy/3M4G/wSkSgG8Oy3lm1xdzrFDrBFQhHPHysrhWIQTgcJihAPtcmW5L+qJ+aTL1pog3ya9ykWGapJ7g57zdfxnPZUeP312+ZbFoP8e+C9H1RJWQkaFrqOObm9NyG4jtKitlmkA3eJIQs8QNB+RmbMOmqNzUCvn+fYMOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=jTmfBXcp; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35d971fb6f1so5451150a91.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 07:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1775656845; x=1776261645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vErTInlxRjeWcngKnHXzSGF2rVJW9g4tJWcacgmMs4Q=;
        b=jTmfBXcpDpNuL1stKo2hJ3wVIm9/QCK9P9WSujueIn5z5NCxESIt13qTKp3iB2cPbP
         oD15rHnkkDux6JxGXdDnL9gkA8Y8/+ZhA0KCDWEPB28H5Clf+gpo4+y05LKKLbbHdfOG
         Pe7ttJzJgkmeW2T3W3DLH2Mw6ex7zmbA8VQyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775656845; x=1776261645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vErTInlxRjeWcngKnHXzSGF2rVJW9g4tJWcacgmMs4Q=;
        b=fRjYuhgq5jEaM/t1NupfU1gcNLDZ6PmPwJ4RjaAsf2Hk+41N2BrUqcxb7QQtAPIlOk
         mEuo4zcuYKdZSIzdGsGVibwxIqMq7qttnQEY/oR1dhb8tEumkXL/KK+XHLhBYBAFc1OL
         z6nidOH9g7t56dWz1YVbGIj14QFIgBdgwYzGcP6d/Sj0CHcCS+lm1ZnNBr6o8NHBtJ9F
         qS7L5bug2Y4PPURxGm3jlaPX2+B0J6j7N4gE9niCAZT243auIdHKGsy9boYlIMhGIi5d
         3Dt70PrAfuYaFDvWrycM6PWNJ2DVylUc+2Oxp4bQBXeagZElz20XtCZIagRng7wGh7DY
         zFXw==
X-Forwarded-Encrypted: i=1; AJvYcCWHGG0+0wlPzlnmW5hcuwBZdgYlcd7wvip7SA7tFO+Ev1oY7t9gGpfZXVWBSfdteHSu4P9afp1tZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNebkCIR3KRi1FnWYBRQrpPCat4aUN8N39c0KLXVASxDhwsEeC
	+sADnuIz1jVXZqFYexrRpfE7uE2pO8rF+EXYAYEDmu3z7+H6c57XPG760nzzxvwmR9Q=
X-Gm-Gg: AeBDietpLL9owowdojKvKmuPH6ZuypNJWgpaj+hGweIwwcgS5kQvVew1ADj+v1FMyLn
	MXxOeM4vLY8aV/OX3LEu9ahtpZnCFODGSFUgzXmSRWZ6L83SPemWCjqRibcVVuyvG/TuX3oj150
	d7CluBmGuKFYU5sSBTyM4Jtua3+8Bou0Z7RwDxqWazo/MwsOk1lnMnbYcEk9kKCNaaAsO4gUIH+
	xoDQyQrq4bj0NpPkfBWugCKEQiIviiXECd+KQEHObzOyICTeOLqF1rRJnsQGk+zGF/GtzMP3gxc
	g3q0V3TVn8tDphUSjtG+2O5xlvNi7FcG3eu/1x3r4cBWU7R5km2My7pYphUwv0xeBrkkSd+FVKY
	d3+hu82rPMcCwZOgN29/WthrDW4/YNB30yHiumAHHOdda4n8jXfW5H4XFyjB1W0IY0s0JbE7K6J
	92bcY0N4AJ56iXbszrvjwEPpfvVyRq1YOSLuDSTjvrhM7s3yZM5W8OFM7Dz7I=
X-Received: by 2002:a17:902:d2c8:b0:2b2:523f:50d with SMTP id d9443c01a7336-2b281802cacmr224321255ad.29.1775656844749;
        Wed, 08 Apr 2026 07:00:44 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2747612b7sm204465145ad.23.2026.04.08.07.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 07:00:44 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH v4 1/5] rust: bindings: add io_uring headers in bindings_helper.h
Date: Wed,  8 Apr 2026 13:59:58 +0000
Message-ID: <20260408140007.8401-2-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260408140007.8401-1-sidong.yang@furiosa.ai>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[furiosa.ai,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12994-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,furiosa.ai:dkim,furiosa.ai:email,furiosa.ai:mid]
X-Rspamd-Queue-Id: 36CA13BD524
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This patch adds two headers io_uring.h io_uring/cmd.h in bindings_helper
for implementing rust io_uring abstraction.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 rust/bindings/bindings_helper.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index faf3ee634ced..01f2c6044ae5 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -88,6 +88,8 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/xarray.h>
+#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 #include <trace/events/rust_sample.h>
 
 /*
-- 
2.43.0


