Return-Path: <io-uring+bounces-6690-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52640A42976
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 18:23:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F12AF16651D
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288DB2641EF;
	Mon, 24 Feb 2025 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="VTBupOZ1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f98.google.com (mail-io1-f98.google.com [209.85.166.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E91C2627E6
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 17:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417824; cv=none; b=hfcMLZeui/T0I0jm4/YHiIkUqflTzqbUuxUi066piPxNVdi5KkhliOobGPKGuhMkb0s2v3Aw9lcDZrPId1K6JWVfWjueDv1scSdSUvBw4QTZL8+28mh/m9J6QOG98tvFIqtRJzfYuaKYfYUtsVewMtArgvpd76nBw1WIHOCT4Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417824; c=relaxed/simple;
	bh=4Rv+qso5EosFUpf/IhEJ3R0luVIjkQtyWVZSNnagglA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L01gUdCax+z174si34QcKRf5TY9orK8mff5VMeTgUGh1kwf+LS1lMvDsu//N9HdYRYypTBfg7N8Tyz79VpuGc0rerspFdfIpRwA4FILGRVCR04DA82ijxgOE2ergUt9CEh27h+MiD0+wkJXLJhveWh3AZO59RZuWY2DNB9ST5IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=VTBupOZ1; arc=none smtp.client-ip=209.85.166.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f98.google.com with SMTP id ca18e2360f4ac-844c0d5934fso12898939f.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 09:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740417821; x=1741022621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p2UgCWe2nVWlOHQP1unFoHEREXqq14l2rqeEiZsuv8s=;
        b=VTBupOZ1/S/wyEcw3ek8A+Wb+zBo/B1M+7s1u0G1xHgt1ID3dHse5XaeWJqRXzVDKw
         yrFnh4kNbUjpx3/p0iR6RzEa1yFCM/noCuuR+x5+dgD281/BeVUB2CB8Vbvr8FpRh0E8
         Bxgm1kHr+GVX88zNKVuatH8XZUAIndyUi1w4KJnDKdg3ZtUEkHKJ0qnxZ+LtwFrXkZky
         uyCzl3+4CgXjobvul9kNfyfSa6Q6BKWqnattoMhKl0zg7eCZv06m5Rl1TkN9UTiVJydn
         7JPDzaQFu7EjUCUu/TTaCeduAUiSx9sIdLl7w2TkdtFyw0fl5YNUdVOjEzluHMntHoGN
         m11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417821; x=1741022621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p2UgCWe2nVWlOHQP1unFoHEREXqq14l2rqeEiZsuv8s=;
        b=o/jCeGDIoE0KCBamnG2BbdHLEwaiO7FONK32cs9394C5mnB66a4TBrBcLEdc9nOIC4
         nH5pbkdIhafG2ZPG7ZdeCWzl/o3c51Z8U1bA65OGi0AlNn8VynjrZH7ONTOYKhh/I6O4
         WwpsaQRv5dNKb1R4VDECKEtbMcgZokmdG8dRpEQIXSe8Yo0HGetoNzfYvAf52RvxRw8Z
         mULRiq4cB9JqLlZKkUmU5TwlTnlqemXQoFvelrqpGbMwqLGzwd4g8cLEkstusipIvM33
         G+TPw+gYnhGT8tW5wZGLgvQz4lK/IB9fDnnojXhCYu/OSoNHME2bxCu5S3lexdOsPCxK
         olEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlEl8W3GI9OImzJ1hRnMR+XgJ2IalKdAaJvLZdekhox0ZiDkRSJKsF/hXJvxOMYHM+QJNFxEri8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNQph0dlaDsytqz5bneV1noOEk/9GQuplXAlaEVuajkvVsAb50
	zkl+jcWK9RU44g219bamlTVv3MdTU9sm9uVc10wAbqon7f3S6vtZuvZSoDTih6kh7PEQmS2xfbC
	M8oFQRYsFVib3+1WRcY3uFOAIINE9bFEr
X-Gm-Gg: ASbGnctRwhAjxK9j823cHMbZZv62Ak2nu101ggBifLDh7kRFam+3MznVdTov+1+Wsw8
	sZHmjkWZhRwRQxni1tvaxhfgS2HpsUTfU8HG+/NugeZPHjQ6PzKE/RUbVvrjKSCWtCqlsxYuLw3
	sugN2k1nlgZYNvvImR420MFkGe9lpHpvVBDARuXfIBRgoXj0PDcw6aW7ZQA/ldWVxe3Sa6RPols
	W8hDIXP/YPlpvXMGGKbSYJsg9gszCAskW3CdFd/uh+61vS7xV0a3m+rrzv+C3fFul0uaQ0TceDc
	xsAtRbo/bpSB5Iuewgz1rSuAbj2DegEup8WVlnJiWyCqmvxz
X-Google-Smtp-Source: AGHT+IGFqhhLEKvt8578AEoTows5+TiUaWB2QXQN9GVzloVyiOnLjkpFAvTONnfScTuh/yBGXSPSHTLcLQYd
X-Received: by 2002:a05:6602:140c:b0:855:d60d:1104 with SMTP id ca18e2360f4ac-855da9cf953mr395841639f.2.1740417821269;
        Mon, 24 Feb 2025 09:23:41 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id ca18e2360f4ac-855a2ae2fc3sm69797339f.2.2025.02.24.09.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 09:23:41 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 2F9473400EA;
	Mon, 24 Feb 2025 10:23:40 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 2D7E5E40F7C; Mon, 24 Feb 2025 10:23:40 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/waitid: remove #ifdef CONFIG_COMPAT
Date: Mon, 24 Feb 2025 10:23:36 -0700
Message-ID: <20250224172337.2009871-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_is_compat() is already defined to return false if CONFIG_COMPAT is
disabled. So remove the additional #ifdef CONFIG_COMPAT guards. Let the
compiler optimize out the dead code when CONFIG_COMPAT is disabled.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/waitid.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 4034b7e3026f..54e69984cd8a 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -40,11 +40,10 @@ static void io_waitid_free(struct io_kiocb *req)
 	kfree(req->async_data);
 	req->async_data = NULL;
 	req->flags &= ~REQ_F_ASYNC_DATA;
 }
 
-#ifdef CONFIG_COMPAT
 static bool io_waitid_compat_copy_si(struct io_waitid *iw, int signo)
 {
 	struct compat_siginfo __user *infop;
 	bool ret;
 
@@ -65,24 +64,21 @@ static bool io_waitid_compat_copy_si(struct io_waitid *iw, int signo)
 	return ret;
 Efault:
 	ret = false;
 	goto done;
 }
-#endif
 
 static bool io_waitid_copy_si(struct io_kiocb *req, int signo)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 	bool ret;
 
 	if (!iw->infop)
 		return true;
 
-#ifdef CONFIG_COMPAT
 	if (io_is_compat(req->ctx))
 		return io_waitid_compat_copy_si(iw, signo);
-#endif
 
 	if (!user_write_access_begin(iw->infop, sizeof(*iw->infop)))
 		return false;
 
 	unsafe_put_user(signo, &iw->infop->si_signo, Efault);
-- 
2.45.2


