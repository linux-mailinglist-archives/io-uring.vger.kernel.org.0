Return-Path: <io-uring+bounces-1525-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8FF38A2EAC
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 14:56:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 265651C227ED
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 12:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03CB5C8E4;
	Fri, 12 Apr 2024 12:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RKXiFf2V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439FF5B694;
	Fri, 12 Apr 2024 12:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712926542; cv=none; b=r4OVGyw+rdsR/g2oSPz9dGD+3vWea4EwoPchFcm3ppIq/uiRr5mtt+AOLgm0Vnp34DROPwtRdNrKKuTy0TOkiIV+29c4K0ZeBG9rdWQ9U0q7JXDSB3eP8P/WUMYIbGAejcIM+nrBlPzHZVSQ/MUH66Yg/3qsbxF/MwdRArAotZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712926542; c=relaxed/simple;
	bh=pVOXkwinZJmVU9Lj8rrjvm7TE4CrfVtgro80Y4ih9XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueeOj4ocio5DVm4Mwh563j2eNURmomiJ5KXu92LhZp9NyWMAHlCGmRaq4n9s2RkafOI7c7EivVByP9BaQPmAfXVab5gMioGFIpbyVTqlXlOc5s8pxQr+IwCMKVAq8yNiVrRORvDtiNoNraVStxwUZXvbN8EIOcdf2WUpcK8HK7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RKXiFf2V; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-56e1f3462caso1045686a12.3;
        Fri, 12 Apr 2024 05:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712926539; x=1713531339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qQqp5Wk/zImF2BSrOJkJRMSM61A+Z72QenbLjcVFSpY=;
        b=RKXiFf2V9IgDtBmx1Gi7lOJJJ4zxm2g07dsxkd+SdmgAADuSuDt7zSPDTB1d9oQCd3
         QWUQ8XHyRwzARf7R6pmQQMP2C1tkIsybFQtPEAW/EZ5/tmHzQcV1uX/GOX+sn1oSVtix
         KIOxbsswyiGLly5jjZWLXVOolPESSnpN7ctBiXUzHQSMTmcmwXLzYFVzyzj5bgzghODD
         gmtdudKOLvJd1tiYcxKTGnSG6ue7MppuRICAq3FFgRhs8nb8KNTRc5BqXFAQUAjj/kap
         PxQSZXE/4ExoG76KmGs8Aviz75rFsueX7CzS2qZUFn4knn2fCiV0jvRIkKj16FpKosWR
         oH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712926539; x=1713531339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qQqp5Wk/zImF2BSrOJkJRMSM61A+Z72QenbLjcVFSpY=;
        b=rBMvLmG/KkbxS/uMYcOJS4iz9Xc2/cfAT9aYi4IrwG/vJsHrnXJ38OlG9fPJ6SMJbq
         eGbCWJQO5naTFyAC6LhbWhQMWN6Y8ye82F4cmFEcU5DuLbDz+88UuTWww1DIY9y065wR
         o0OgVN6rQxv3Lkpj6f4C6k4cqeilm0F6Pn71M+DjH/p7+6sbcTBdAAleC/VDtR+LZP4E
         /d84vvaqZ//QToFbAzFvx5X+eLGeGXHF1o0VSETQp8YuKqXfvLRuXqhOZikL0p3Aoarj
         7VWxcWq688upvSNVieKusvY3fHqMoz6iHIgNghE7rXPRy0vWoX/KDbHPuZBIhBewHcO8
         MJ9w==
X-Forwarded-Encrypted: i=1; AJvYcCUotfg407EOn964jlD1/QJcvXRjKaJ8ZLC/7FEsETa4BYnHhxa3xDCDr5qZUd+aO2ScDo6klCHtP6uptu0NyjuI+MIBFuOG
X-Gm-Message-State: AOJu0Ywhl0/zzHeHyE5WB3/5LoCgdyZlLEr5QZuiEvC6WQYRoUNqlF6q
	bx9sAEJX3wf3XgkDzdEpTD1mJrYKuUFcm8+mk4mkutgejD2NV6hu0KBYUA==
X-Google-Smtp-Source: AGHT+IG/5PNR3yIorzHwk2G8aSFu+OH9+dZdrWWXo1o8Ak7I10dAxVZUdUHqZaN9HeWj71SEpyd41Q==
X-Received: by 2002:a17:906:134f:b0:a51:d742:b390 with SMTP id x15-20020a170906134f00b00a51d742b390mr1912083ejb.30.1712926539452;
        Fri, 12 Apr 2024 05:55:39 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id qw17-20020a1709066a1100b00a473774b027sm1790903ejc.207.2024.04.12.05.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 05:55:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [RFC 5/6] io_uring/notif: simplify io_notif_flush()
Date: Fri, 12 Apr 2024 13:55:26 +0100
Message-ID: <3149fcf08c6143c7d809423c213c497deeb9a138.1712923998.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712923998.git.asml.silence@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_notif_flush() is partially duplicating io_tx_ubuf_complete(), so
instead of duplicating it, make the flush call io_tx_ubuf_complete.

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
index 52e124a9957c..394e1d33daa6 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -20,7 +20,8 @@ struct io_notif_data {
 };
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx);
-void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts);
+void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
+			 bool success);
 
 static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
 {
@@ -32,11 +33,7 @@ static inline void io_notif_flush(struct io_kiocb *notif)
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


