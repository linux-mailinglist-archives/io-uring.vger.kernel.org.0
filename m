Return-Path: <io-uring+bounces-1592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC918AAD65
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 13:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F71C1C21410
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 11:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B509D80BEC;
	Fri, 19 Apr 2024 11:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VuaqpEZ8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095DB81AC1;
	Fri, 19 Apr 2024 11:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713524929; cv=none; b=L/b5ycQ573+DrCCSDHZm8n/wo6y9uBN9bR75hTFwZoGg3ufs/TavFkgUlFNh43zT18HEIqgsmrQ2nVylZx9Q9EqX8sQ/zYoFrfSBBAdz/WeGAiwMgU6KIbzgz5fsq0lPjjMidNd+fpyJCrEKaMbkXt/xfw7ScEifA9fy+Kt5nYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713524929; c=relaxed/simple;
	bh=5Ihm49/gOZVBFXJiRL0zEQqhoh6Us3hM99ueJay4DGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEI4hmHNilJ9kNQEwXUMPxDh58dPlITmh4XCS+vUGES37Oc8ccEvea0QMCTjZDbTRWLKU46cHRcHI8fqqwEI3PMSxE6ElwQr8CDHNrdUmizsQ1KyuXgVOy+ra1hTklsObbFoenMbENvNuWvHfH5iIquFvM/Ggfli2MyIzQsUsdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VuaqpEZ8; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a5557e3ebcaso316023066b.1;
        Fri, 19 Apr 2024 04:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713524926; x=1714129726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vg0pL2CVxV49Fgeqn+qahTZ1Z4PbsN7awrFUvCLM+ng=;
        b=VuaqpEZ8By+fANp/BNjRokpJtCpAz4TtawQ/iMeLOE5fxrhr94wW5ho4qdgc5vkUke
         b+tqUmnGBYZFmcKdkBN/okc007d6Rt2yc/T72pzmtEiEfVR+izzfy7+0iQBkVjGZc4ev
         xlbrSyJnVSX4m/XpPaL1NwyJsMlKOMxor8bH3l/fHx0Cl+JhkDKfVlnPkKpMgJE/iG5H
         kfJxFrOOs2wNX1DJFZuNNwYajUqJ2eBfl83jY8mHBXDvSUVjGCHGLGaSxEv3mIEC1oIX
         9zsONMf2zRgz1nEykpT+gNum2jPf2Q4OxZRD0Badm02WFsE046SRBjeHbhLJTZHNS9gf
         FGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713524926; x=1714129726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vg0pL2CVxV49Fgeqn+qahTZ1Z4PbsN7awrFUvCLM+ng=;
        b=h/DDq6k4BCyh1DmJ2j9Ben6Fc9iykijJyGGV9H6JuoaBKk4TD31eHx6ADvgcdOC9gK
         8dBcdHD4QmFGsn31gj/CcM5RUvFQ/e5Bys7xE9tsGh+c5h2Aocl+WwVrnYCy62XbEYIM
         Q7SK1ALy0Z+akI4tlDljalPMcB/e54QNR2RqdNAZWgNGg1517+e/fNb4ZByRLkO+JCRA
         Ms2998mfZU7W21ZjOvn6zoSJielIFlUivCZMAoh+abGIMIaPmQAqeNoSzhMzasGgrxed
         2CMXGbTqTB6MUYl3OT80q+Mf8S1PDotKUDEpEQf+ZO+I+I+oT3aolY61BU+W3uMfwlB/
         w6rA==
X-Forwarded-Encrypted: i=1; AJvYcCW4ghVD1kmHJHibObWPQmpRx6WxkzAv8TaH1cHHhkwKgLNmyt6HJReN2p6tgzxWdqFiVsWEGTTjfQt4RZyH3+okkpC/CczI22X6z+LZCYhV0ls7Z8jwHIabY+nv
X-Gm-Message-State: AOJu0YzSHwAz9nSDOZm+touhx3v+hyGECrJY50wM2Xxrb33AwuqIdjVF
	dqTI+8PrirUvFsmYi14PkxOG6X2C6rojvlo1jP+e55lJi/dSQm38WV4mcg==
X-Google-Smtp-Source: AGHT+IGlNNpKG3wGDzOQc1RYm8RL9LY87wF61Oxy7BMYiyIn9QMexWxwwOK9pfN0OrWYDJl4d93LDw==
X-Received: by 2002:a17:907:7215:b0:a55:75f7:42fb with SMTP id dr21-20020a170907721500b00a5575f742fbmr4895587ejc.24.1713524926172;
        Fri, 19 Apr 2024 04:08:46 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id z13-20020a17090655cd00b00a4739efd7cesm2082525ejp.60.2024.04.19.04.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 04:08:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Wei Liu <wei.liu@kernel.org>,
	Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	"Michael S . Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH io_uring-next/net-next v2 3/4] io_uring/notif: simplify io_notif_flush()
Date: Fri, 19 Apr 2024 12:08:41 +0100
Message-ID: <19e41652c16718b946a5c80d2ad409df7682e47e.1713369317.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1713369317.git.asml.silence@gmail.com>
References: <cover.1713369317.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_notif_flush() is partially duplicating io_tx_ubuf_complete(), so
instead of duplicating it, make the flush call io_tx_ubuf_complete.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 6 +++---
 io_uring/notif.h | 9 +++------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 53532d78a947..26680176335f 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -9,7 +9,7 @@
 #include "notif.h"
 #include "rsrc.h"
 
-void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
+static void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
@@ -23,8 +23,8 @@ void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
 	io_req_task_complete(notif, ts);
 }
 
-static void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
-				bool success)
+void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
+			 bool success)
 {
 	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
 	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 2e25a2fc77d1..2cf9ff6abd7a 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -21,7 +21,8 @@ struct io_notif_data {
 };
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx);
-void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts);
+void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
+			 bool success);
 
 static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
 {
@@ -33,11 +34,7 @@ static inline void io_notif_flush(struct io_kiocb *notif)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
-	/* drop slot's master ref */
-	if (refcount_dec_and_test(&nd->uarg.refcnt)) {
-		notif->io_task_work.func = io_notif_tw_complete;
-		__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
-	}
+	io_tx_ubuf_complete(NULL, &nd->uarg, true);
 }
 
 static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
-- 
2.44.0


