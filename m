Return-Path: <io-uring+bounces-1692-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF3F8B7C00
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 17:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7C22B21691
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 15:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD75A174ED7;
	Tue, 30 Apr 2024 15:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9AKRESS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF47E172BCB
	for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 15:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491744; cv=none; b=V9jp1JSBRFeJzoglVHFzv7U9RTNi2LukiBml+a++5ZffTpZFMs7AJjYUS2/A4zD+Cn0Ypb25XnNTJzP5JFlTM0UusmpPDVQ/kYT7ECIee89vqYOvj3GtovMi+g0WN6/edRF0vMOhg/c2IUpQ2eaQI7RwA5bLDcb+GN2/tKprmWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491744; c=relaxed/simple;
	bh=ZttkBGki6C1Q+1L6cVzTyiOuJ3gTmtwinljrHov8e68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZE83LYdTyQdHr62o0ncGE2logsb+BxVOzQvy9z57bBEz4rUQnu5LbCsazpS67oHsitWQGNK4/+n2xFWrKWvd/lr1ESSZQz/0EE+S8Co3y9jjRkvbXIxTcjdEj+6tjDs7vTZllAa6REFUSafh33kjeidUn2407TCpPQ6bRpOSgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9AKRESS; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a5557e3ebcaso960003766b.1
        for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 08:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714491740; x=1715096540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1E9ZQrnTua7PupSaGNnoA+t7rPGTpUcCkl5h0oAn1eU=;
        b=Z9AKRESSaDIOlmcHmA0gJe9zGJ2EFZcmz16G0ih/KzBIwpbfpJuHKZWbcaksk79OvV
         yR0U8WXI9A/PfeaGRKkK3EzvlLjgexen4FqWEzAWgeU6xG9vuXXykN9O1P/XG1UupA4W
         avCugx9QFyM6a1UAlbRnLODWvx2heGqVtSNf+88Yk9Xq1F7cBhXijZgfAXlbdzMRVZTj
         FE2dIB5j08OoKtzqoxTZfY3md6HS7ZGo0+aeMS4Fsm7Dt+tIWzViUz+Le/op1CdKmk2H
         boA8qdBKb3PDtlXH6wy66EdmTy+hhsGse8tPqanYpLq99pqx0W22lrrg9gjRApMX2q3l
         RN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714491740; x=1715096540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1E9ZQrnTua7PupSaGNnoA+t7rPGTpUcCkl5h0oAn1eU=;
        b=XJL54vI2knp1gf9sa8cfQrcfPm+zR/rM31ZJIQHAwKD7qPbqunp7RSWMMPvk9EjvlO
         LPgPis+CEWYziLTf95vN6yeiBS2UHJbOroub+DhJz0OBoJYXUL++ZDmXKnh8tExtIq6f
         peh1GiM6uryAn5Q9BKLSMsDqBSP3QQ3ROp+0YLfDJHpFtjh2OnZ5iFD/a4bbQCW8dR9v
         J5UDxj3TsFoTAtu6cM6E766WCWPXo/27LmXG25P1pBLpKweGUiNhfz2S9KnFrDIx7Tno
         cve++hMQr+Xb59pTpFKTeoE54w7xPjJlsYKDRx/9UfgP4ZYo321EzkTpQRzpTjezehvS
         L5Cg==
X-Gm-Message-State: AOJu0YxNQ9emCR5Z8uMafVxCkDjN87kLRWuFa2LHSyXOypxMr+rcJ1Oy
	AUaWzixzHqNsvVwVUvJTg+yAAJbb+3JpgJlxhSWNq1hBzOYNe7wnUfDSr+OA
X-Google-Smtp-Source: AGHT+IFYExnPhK0l1XtmfE3sIaXNy9ttIwAvFDwmsF4/B5i8/EjcE7rjaf89Wi/53QNYw8HGGlErmA==
X-Received: by 2002:a17:906:af94:b0:a52:71d6:d605 with SMTP id mj20-20020a170906af9400b00a5271d6d605mr94723ejb.23.1714491740181;
        Tue, 30 Apr 2024 08:42:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id p8-20020a17090653c800b00a51a259fa60sm15201465ejo.118.2024.04.30.08.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 08:42:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring/notif: disable LAZY_WAKE for linked notifs
Date: Tue, 30 Apr 2024 16:42:31 +0100
Message-ID: <0a5accdb7d2d0d27ebec14f8106e14e0192fae17.1714488419.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1714488419.git.asml.silence@gmail.com>
References: <cover.1714488419.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Notifications may now be linked and thus a single tw can post multiple
CQEs, it's not safe to use LAZY_WAKE with them. Disable LAZY_WAKE for
now, if that'd prove to be a problem we can count them and pass the
expected number of CQEs into __io_req_task_work_add().

Fixes: 6fe4220912d19 ("io_uring/notif: implement notification stacking")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index d58cdc01e691..28859ae3ee6e 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -38,6 +38,7 @@ void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
 {
 	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
 	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
+	unsigned tw_flags;
 
 	if (nd->zc_report) {
 		if (success && !nd->zc_used && skb)
@@ -53,8 +54,10 @@ void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
 		io_tx_ubuf_complete(skb, &nd->head->uarg, success);
 		return;
 	}
+
+	tw_flags = nd->next ? 0 : IOU_F_TWQ_LAZY_WAKE;
 	notif->io_task_work.func = io_notif_tw_complete;
-	__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
+	__io_req_task_work_add(notif, tw_flags);
 }
 
 static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
-- 
2.44.0


