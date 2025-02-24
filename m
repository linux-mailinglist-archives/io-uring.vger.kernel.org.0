Return-Path: <io-uring+bounces-6685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC115A42765
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D19467A8DC2
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2BB826158D;
	Mon, 24 Feb 2025 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k9FX35e0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D6A261591
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740413202; cv=none; b=SQgLHxfopy5kaXoErGJAw+J/fROkXAWoPzCAID3aBCwfJGXkzBBhnaTlC2YitgZEJ7jJtby9j6mNbeCfmv/FL4hUBUq4mm9foRm0BGi6/Ppuncp4aoYVyF5iIORe8K2Ynu36zGcUOWkR9zSTDVN8Ca3UZ3qw4MqdNxS7xfzBFVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740413202; c=relaxed/simple;
	bh=iyEeXQ7xsxxrWsm1X4Rszb9X10yIS5n63SBfynG342A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQOKSRgr7dZsyVwOE2t0WhF6A5NCBjUUbhT/v3pyg91T48mZ6ULqSQbGNJwszxV9/LQfcmohdbJYck0qukjqi+KCk8qfb5dlfhpzbOc8mimerwZnN8xOU6jyraarW0W3S8QVKzxqLaLq6D0EiVS5pvfRjHm1Dy19iRmlbwsBRO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k9FX35e0; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab7483b9bf7so750697166b.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 08:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740413199; x=1741017999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=33bFwdlXi6q1zIThWD9p1qAnKpNPjhHJq3izUsokAd4=;
        b=k9FX35e0nxdvUi3s4R8pdgCeRKCdYZdbrh5AH8Pm81VDs8gVBb6Yb5cu2qfNZDCLyS
         di+kcli3JkDLS5Uxo2FOsEKQv6xj3oU4uuvMCTJ4yY+Q3vafLCW5KAbBvRQaJsYxBDeG
         dTZK0MQhC55uj/Ukrxh6YmN7jOTOpwyYCl/lYk00SfFTOQ71BmPM1tyG24dIrKZlMyKA
         6EeO5v37+EfIJjFdVvd5rMxwRvyQXFM2uO+gu54mbRMg9PDSeb6C6Z802Y0+t35wzV8d
         CdsaUetS/6DhqdDptwzEFFkYFoJA4OdAM84hc8arhA/bpEk4V2P4GjDFNmvqyzbXP16h
         w6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740413199; x=1741017999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=33bFwdlXi6q1zIThWD9p1qAnKpNPjhHJq3izUsokAd4=;
        b=pUG15Gu0e9bYrP2VPeRR81atIev3nhaF2Bz0cz2BtzHCWpaR0mAVRgTfiTwgD9EmDC
         KLs8IIYcHQMcF+hwag0q4kRKKv7kYzEiikE5rkwObfvku0YzoFGRrvWIrvDHIcjFnBdj
         hEXgkVibRARxP9uBFkQuDftiJlsgExoVA6RVEGMth59y2i+dYW9BA74Uuba+zCGqih0R
         QeMKsoCGc2EOLWYxLpjVC+wvs+P3gtYQve/PdfMvppjvn80Rvt0FUPHwLqSG6/P1B9yt
         hvzQGJ85qn0E8XSRMfdcPzgMzpHUvePW1ws4yJriq0DI2Mr6mOW0zyDAP0plMzP9nDLY
         nygg==
X-Gm-Message-State: AOJu0YzPbKemkf78YZ5N7cvoiPKDFu0jYWCW7mt1qEV5MGzgLsIbZ+y9
	kBOBwjCiTZX52QzSsSJLFaUw+Jo37FAcg71fgfjd+4XDN3UtRY/gFeAoEg==
X-Gm-Gg: ASbGncsb1A/mwGU16U4HXZAWBJg26Y6snVf96E2fEG3ABIr2gDazeAZamHZKA12u0Cr
	epISj3Zu5G4Bw/nuXrAgsp8n7m0J0aFrvdLzPD8D5spcEUjqSYKH/kjnBAglz7XJHoI5kR78Vcs
	VPXgra8bpJlBeynYEoeJvLOKlFWX2H0pMCkTFwvl8g6es/BIGVjW8d34JDJjDGBVPYU1m0BYkTK
	vyNOvr2UAiwG1lUh1aGdh5LsWTfSP1W0gSGx5sef0o2wGo+wd53k6+ysIR4REJ4k4iVzRw7aIG5
	FhuhIpVVIw==
X-Google-Smtp-Source: AGHT+IE7EF03dQx6L3t51xHutNk3Y+/C7khygHix/MgWo57O/dFPpAHV/wl3KtNk09RryyYF/UjYyA==
X-Received: by 2002:a17:907:da7:b0:abb:33ff:c5f5 with SMTP id a640c23a62f3a-abc09c27017mr1513633166b.48.1740413198603;
        Mon, 24 Feb 2025 08:06:38 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb95cc7451sm1664684566b.92.2025.02.24.08.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 08:06:38 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring/rw: open code io_prep_rw_setup()
Date: Mon, 24 Feb 2025 16:07:25 +0000
Message-ID: <60470a586db34ed3a5d9c992564acf29aa846c9c.1740412523.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740412523.git.asml.silence@gmail.com>
References: <cover.1740412523.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Open code io_prep_rw_setup() into its only caller, it doesn't provide
any meaningful abstraction anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0e0d2a19f21d..2e35e7e68ff8 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -204,17 +204,6 @@ static int io_rw_alloc_async(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
-{
-	struct io_async_rw *rw;
-
-	if (!do_import || io_do_buffer_select(req))
-		return 0;
-
-	rw = req->async_data;
-	return io_import_rw_buffer(ddir, req, rw, 0);
-}
-
 static inline void io_meta_save_state(struct io_async_rw *io)
 {
 	io->meta_state.seed = io->meta.seed;
@@ -287,10 +276,14 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
-	ret = io_prep_rw_setup(req, ddir, do_import);
 
-	if (unlikely(ret))
-		return ret;
+	if (do_import && !io_do_buffer_select(req)) {
+		struct io_async_rw *io = req->async_data;
+
+		ret = io_import_rw_buffer(ddir, req, io, 0);
+		if (unlikely(ret))
+			return ret;
+	}
 
 	attr_type_mask = READ_ONCE(sqe->attr_type_mask);
 	if (attr_type_mask) {
-- 
2.48.1


