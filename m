Return-Path: <io-uring+bounces-13044-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CPPiA8BV32l1RwAAu9opvQ
	(envelope-from <io-uring+bounces-13044-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 11:09:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A1CB2402577
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 11:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EFDF8301D097
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 09:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3238324B22;
	Wed, 15 Apr 2026 09:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="M8ghO42Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BA83264EA
	for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 09:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244154; cv=none; b=CQKx+X6bbZ+ZoJNWuOMNxnjh77HQqUJZg41IcKizTO4KQw+ygF6sTSATqhxdqq1lTTtLuPrcD+Q4eqBzYfCsU3VOuLUnt7kLb1o6KTdWDoJXUF51AplzNCjx8SrH7TxqQ0rY6GE3pRkHThJ8iSjwg0qLN2mG+0j6yIYdDG4plA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244154; c=relaxed/simple;
	bh=p2j8Luk7W6yr0bxlOlpHiNO3IOJ/KtgqMq3H9b3ynRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPPRVcCDs7CdPWSxenJk7j8o7IQBOIywBrHZl0gwuAUa0W7hlsvT8lkopcO4o8gDWPtDVjHI5NXr7qmVafIr9wbQjXwCbssg2tGOpZbj7AWjgaDzLikGDxcNKXyjET3dvc2ZZu7TB+oMf2BATaG6Sko1GFO71MDKcYGelrGONN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=M8ghO42Q; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c79506f3c40so447804a12.1
        for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 02:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1776244153; x=1776848953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8CWG3OmkxNDqiNbb7KQHfaHwxQ5jJUOD3gTNZtX0NKo=;
        b=M8ghO42QTUxohxakaJXzdMZYl8H0I7sKlDVV/8f1utqRS6HUioiyzIyIfgUysqY0zh
         1y2WDp8UPeLR3K3r218Hg0qKiOmp+SskueuZwP/Q+rEkaja/IuE6TYLMGXyvAyTZNA74
         vs9rAG8eoBJwJj4zc3lUwEekr/YfSZ+NU9W0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776244153; x=1776848953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8CWG3OmkxNDqiNbb7KQHfaHwxQ5jJUOD3gTNZtX0NKo=;
        b=a3TNUKFffnT/6J4tFBDdyXO/B7PIWgXoe71sURS4Vm2iR6JSIwflru+H+np09ih4Yg
         eXARF4546HmeWj9iy6dvQa69/4hn6Lv/ru8+xuZ4mgu6anqpTp00f+AfZgVdDBEy4vU6
         w98pwb3+a63hmdhNoU1qey/oKTHHDSqUAErS/6hlVpCV6mWSMrkwFkUAR+zRADflOH3J
         MSbuRqohEGGI/8yEJZDsZZvgLwQcVwNnEtB9SkVkQLoiXsKiC0tLMx8bjLu69SOsR/Xb
         Xt3+gZpUbWwghMvRdlUIuLyzzCoMnZCYjlOOP+hWybdvje4wLqOcfdno8mUZr6sJ9IUu
         UlUQ==
X-Forwarded-Encrypted: i=1; AFNElJ/xGPGjw+WlkHq74GcDtl0si46oTeWf/xhDlEoD+62oBbXGKBCynZs9dwGq2XcV7InjrQvC8ynq6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMpV1HisIwZZSQfNrQaCtEEcEQZWZ83wCPhv5DpldsgRePgnUG
	w7Zjn37cdA5mQeEQR7h49nWe0lb4XRD8NwJb+pYY+TYJ2gmyNch6/uM+OaO3zwN7wTg=
X-Gm-Gg: AeBDievAEtCyJXu6cTz+KFPQLMSqSMcUe4rASJP6J1H5uRSN9js8izgCnJ9gZuXCZag
	wRyveST2hc6YLqyLstYiSm6srd4vCNMdZfmADDg1Gv6sI77r8pXkD101lsYI7CJUip+uwqunKT+
	GNEOIz7LWv1FUjDX5HEWheRJ/SBzHCT2pQ8fqS8P174tN7XPk+wkmSGRKFuf1GmwH9IjOR1zsH7
	vEcu4jvWnaLJT9OfIKJ47y3VNLPMPp+X/kfFJACU5BBJR4ylgh9IaWveEIYk7SeZ6lYgB5imNKI
	Y4f0PYKYLdr4u5J5Aqi6cDB4VsC8mUOzie88jhi4pYj3hS6vBUGwEQO902+pH3Kv2J84ciUdDZy
	NUOEgQhoaTE+VQTR4lMfOaex9OcJ1ANNrouausrDUFTYAhwYgiiQttmnwnpFTDXS7IFW9eJNyN6
	ypo4WboTH5USFZ+l1pvcYGGNyr8Gh7NRCATeAxlRBEER5vaLV2yCpxF2qCNuY=
X-Received: by 2002:a05:6a20:a122:b0:39c:787:f17a with SMTP id adf61e73a8af0-39fe3fae289mr22725946637.41.1776244152976;
        Wed, 15 Apr 2026 02:09:12 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7957ecee24sm1074619a12.1.2026.04.15.02.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 02:09:12 -0700 (PDT)
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
Subject: [PATCH v5 1/4] rust: bindings: add io_uring headers in bindings_helper.h
Date: Wed, 15 Apr 2026 09:02:12 +0000
Message-ID: <20260415090851.4897-2-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260415090851.4897-1-sidong.yang@furiosa.ai>
References: <20260415090851.4897-1-sidong.yang@furiosa.ai>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13044-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,furiosa.ai:email,furiosa.ai:dkim,furiosa.ai:mid]
X-Rspamd-Queue-Id: A1CB2402577
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add io_uring.h and io_uring/cmd.h to the Rust bindings header,
placed in alphabetical order, to provide access to the io_uring
command infrastructure from Rust.

These are needed by the Rust io_uring abstraction introduced in
a subsequent patch.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 rust/bindings/bindings_helper.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index faf3ee634ced..b7b0d549a061 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -60,6 +60,8 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/io-pgtable.h>
+#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 #include <linux/ioport.h>
 #include <linux/jiffies.h>
 #include <linux/jump_label.h>
-- 
2.43.0


