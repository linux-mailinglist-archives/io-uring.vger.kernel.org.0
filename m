Return-Path: <io-uring+bounces-10808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF93C87A1F
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 01:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F259C4E13F3
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 00:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D846B2F28F4;
	Wed, 26 Nov 2025 00:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="VGsyTPFr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5553C1F
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 00:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764118782; cv=none; b=FaKhEZjY5Ih80O7C+TVgh7txaKKk1RslOwXg+svUU9sH+3yd/OGLOF/VVY5I8vejf6OWo5vA/IqRLo6jjDZuH4w3OPZp1jUSwdPtDUEmGiH9324GxiiDNV/ARCpvpBSw/qK2GPNGaa4wN/Uc4sjEIk3++lUhBS3e19ZqLXybBuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764118782; c=relaxed/simple;
	bh=4c0qhkut76rH7l84paJua3p+DLZ8r2/gCaXlajcUJcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q2y/HnmEfjtZcdy7DM/Va/1qfHUMNwzRv8DAmvQqEseVHNg3lQ+itzTw45CnjQ6s6Y+yOxjPz6y9gDykrTF7zH/GdFV7DnKbzw67yuJhitR88ezsvFVifSRAnMZ9+ZVHCKkPErnyw7qBVa6UDoRVlIm63u+SwinjGYsgvHgC86Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=VGsyTPFr; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-7c7589281e9so846850a34.1
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 16:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764118780; x=1764723580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g0nvyTrvg8vglRmTZSeQks2gzaJL5Z1i8rE/Cy2tXmM=;
        b=VGsyTPFr86BL+R6ecfAUxF1knMsOORMucmZTTf/3/wM301dQ9lzQo49JlWYj5UAxyG
         BeXmpj50jMpcwCri7Wu1+algUokvrrhTX7ewQ9Ec4OhvdkJsJ2ZcEQFiaktIvBbyKG4k
         txf94Te87/qgXEoxtvab2U38vMc4O9rJUnMTDjXN0F5k6C/9hI03QFBQhT2u4IvNQlsN
         DwVdWbS9oG4bAib+DHKa2oJOfZ3ML8kanHe2AHpLO9JV+13BW9yggHln+YpMLtlFi9SW
         LpA5gwkfBTIotV/w91Ppu+We1BL+4SEfyg6euZf/Cc8sUWlpY1g0/TE7xIGzOrjBAj3n
         yQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764118780; x=1764723580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0nvyTrvg8vglRmTZSeQks2gzaJL5Z1i8rE/Cy2tXmM=;
        b=sCSXhl1s+wfCX7IdWySuLtyhmltLinQTQPRNr6lXkO+T7x1ZXszP9KnR98k7fc+WkQ
         dp0Ul2909miuUviQQYI9ycHxqtTmYIif0YQGRA9D5OkWrpuJO76eHR48ZWhxRfvcijFY
         id0goGPXf4G2d59R/qp24YCSf9Wa32KOTYxhqDavnCCxi05nH7KCN2Pf5upfQJfJQpjK
         MrtmBT2dvTpPg/POJTiTrXXrpt1oxmSSRIZTZqj9NimzbO6LkK4EAvoIN9kaS88QP8Qs
         VEpDl3ITgHwlyxlIqFNyphad5ikUd2US+I0LvKJSOBSy7lGpvGTmMkWSEnVy/85JBpPq
         Bm9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXNVtnPrZ3LuCi6vU0TvedrItK2/mgE4b/l9wZXIm2+fmEBtvM/Jl55fCbl9/VjGWjK+X0Oz6xq3g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwzZCM8YMQJcJfh+lsCVMbBJ/K/GRiHrLUijPPNSCdwwl0+GNTC
	3tSufujaDK6NoAUn9pGjAbBk3M3qbFNfWoWWzwiyihzfxE38NRNxfMkLF1F+BZRzz6Tz/JrbGP3
	na1euB+m6px6UUj1xUBv/4MWfClmA+uKOrs/P
X-Gm-Gg: ASbGncu78YARpbMH9StfY2UeC/NPPbVc/UYCFH6d/x/VFBsy22C+lPel4EM7JmLp3uZ
	F1lI3QDSLoHZpveMBMjt09I2QZS9/J/WZgGrTG++F6Y5rSvgKIrIypnQg1GBVt2AeFXZocsmzTD
	VAhPBY9jkTx6EKWjS62xQ6Xsoo5BsEF3Ku61zTpODcKMVzueXwQ3MWGW420EH6Sn3QZBuEryoPa
	qVSBkyd0XkDKh4rYDWJevM+Pr272uaIrsY1jkedu5ivLcV0xBnfmcdJCze4z5fmyZBlj1d7914I
	u6GDlPylPzD+N/najFnkkhREFz633jumIJ/+JE3J/Z/Q3xyzLX6mdrP5BDCBamIHXLqPRy/lIo+
	iWrjSGlOG2rK3qsakPkpYH8xIaudkI953or3d+5DYMw==
X-Google-Smtp-Source: AGHT+IHsZVQzOnoQr8TpI8lhkZ2cuoLfRghEBbrsW7bjqM59P5BC496qIxZFJtjepMeRUZih49Qn2mIOONcS
X-Received: by 2002:a05:6870:fba3:b0:3e8:4825:718 with SMTP id 586e51a60fabf-3ecbe585bb9mr4509945fac.5.1764118779991;
        Tue, 25 Nov 2025 16:59:39 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-3ec9dcdceacsm1698271fac.18.2025.11.25.16.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 16:59:39 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id DEB743400B6;
	Tue, 25 Nov 2025 17:59:38 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id DA921E418D3; Tue, 25 Nov 2025 17:59:38 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/query: drop unused io_handle_query_entry() ctx arg
Date: Tue, 25 Nov 2025 17:59:34 -0700
Message-ID: <20251126005936.3988966-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_handle_query_entry() doesn't use its struct io_ring_ctx *ctx
argument. So remove it from the function and its callers.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/query.c    | 7 +++----
 io_uring/query.h    | 2 +-
 io_uring/register.c | 4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/io_uring/query.c b/io_uring/query.c
index e61b6221f87f..abdd6f3e1223 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -51,12 +51,11 @@ static ssize_t io_query_scq(union io_query_data *data)
 	e->hdr_size = sizeof(struct io_rings);
 	e->hdr_alignment = SMP_CACHE_BYTES;
 	return sizeof(*e);
 }
 
-static int io_handle_query_entry(struct io_ring_ctx *ctx,
-				 union io_query_data *data, void __user *uhdr,
+static int io_handle_query_entry(union io_query_data *data, void __user *uhdr,
 				 u64 *next_entry)
 {
 	struct io_uring_query_hdr hdr;
 	size_t usize, res_size = 0;
 	ssize_t ret = -EINVAL;
@@ -105,11 +104,11 @@ static int io_handle_query_entry(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	*next_entry = hdr.next_entry;
 	return 0;
 }
 
-int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
+int io_query(void __user *arg, unsigned nr_args)
 {
 	union io_query_data entry_buffer;
 	void __user *uhdr = arg;
 	int ret, nr = 0;
 
@@ -119,11 +118,11 @@ int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 		return -EINVAL;
 
 	while (uhdr) {
 		u64 next_hdr;
 
-		ret = io_handle_query_entry(ctx, &entry_buffer, uhdr, &next_hdr);
+		ret = io_handle_query_entry(&entry_buffer, uhdr, &next_hdr);
 		if (ret)
 			return ret;
 		uhdr = u64_to_user_ptr(next_hdr);
 
 		/* Have some limit to avoid a potential cycle */
diff --git a/io_uring/query.h b/io_uring/query.h
index 171d47ccaaba..b35eb52f0ea8 100644
--- a/io_uring/query.h
+++ b/io_uring/query.h
@@ -2,8 +2,8 @@
 #ifndef IORING_QUERY_H
 #define IORING_QUERY_H
 
 #include <linux/io_uring_types.h>
 
-int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args);
+int io_query(void __user *arg, unsigned nr_args);
 
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index db42f98562c4..62d39b3ff317 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -811,11 +811,11 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		if (!arg || nr_args != 1)
 			break;
 		ret = io_register_mem_region(ctx, arg);
 		break;
 	case IORING_REGISTER_QUERY:
-		ret = io_query(ctx, arg, nr_args);
+		ret = io_query(arg, nr_args);
 		break;
 	case IORING_REGISTER_ZCRX_CTRL:
 		ret = io_zcrx_ctrl(ctx, arg, nr_args);
 		break;
 	default:
@@ -886,11 +886,11 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
 {
 	switch (opcode) {
 	case IORING_REGISTER_SEND_MSG_RING:
 		return io_uring_register_send_msg_ring(arg, nr_args);
 	case IORING_REGISTER_QUERY:
-		return io_query(NULL, arg, nr_args);
+		return io_query(arg, nr_args);
 	}
 	return -EINVAL;
 }
 
 SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
-- 
2.45.2


