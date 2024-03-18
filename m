Return-Path: <io-uring+bounces-1068-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C14287E152
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36ECD28304E
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F8F1EB2B;
	Mon, 18 Mar 2024 00:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fPssFLjh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A261E879;
	Mon, 18 Mar 2024 00:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722627; cv=none; b=Kul9MXyhGETSOEt+m5IWVrgur8bbXj/79l3VebzxEUJXFSFnN4UcAe3Gox8zzTwEMvecthItjHN7lTFl9zaPUwVfai4lzWcEI3CXr8G/3Zlu8LZuObNRKGnKLmD0dT4aegmBO7ImreKIV0zzrRGUs/sGaf4n2Qflz/XmZDBWnP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722627; c=relaxed/simple;
	bh=UbiTyPTYYZh3urZ8adZCwTIZvRvXSzAJm3mJtdK9Ehw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZLZOgf7jDc7lzr9lDT32uLl90kTcPYTh6ktMSgi9q5IFjURHSOHqSQrH3eo2917WbfaH3enP4HnuQ3Q/2D8StcspUas9DJ8GTkzo84whcWvyqnKZdli4cBhjtafyb5afsiHwOGSquHWXI1PreuNdvWOGrMc7++hYebqKppPLT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fPssFLjh; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a466a1f9ea0so279713566b.1;
        Sun, 17 Mar 2024 17:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722624; x=1711327424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XhKP8/ntiNtXJNW1YgeAv+tpjW8wxFfpi5StwH3GfS8=;
        b=fPssFLjhrjvtejrDB6PklYx5rF5MDROuCnPXWShncm6E69ZE0ZWzCkROANJGHve2ec
         n3m4QqO4ZXbMDd+EzsPsZWNhvloAb8a/+D/xhG661cihKCMfhzlGUcal8ZpfLBv2gHdq
         VzP/L0OHA1uzkn2HOGF3B4Hrr7OUcDp9WJytbn0moehFyM1+f66Do2EzwSjpQciUBbjC
         sDbaDF2ew7XKMAAX/ZBL4EVp/45+UvEuWBGqmOa6lehE1WO4rB1X9XmxpDNAbLNS4a2O
         ovAm6r5kUcOXP0fKhT8AtpFHRzfxiaWsFBPLWVGvDCDQT0XpmN7d5iAJwmsIgjwv9Jko
         NESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722624; x=1711327424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XhKP8/ntiNtXJNW1YgeAv+tpjW8wxFfpi5StwH3GfS8=;
        b=QOFn8D9kOEwsZRTErSzJ32MpQfgP4CN6B9RJfE/iDGUfcyLQ8LSCIxhcrbF/tqCiU2
         rI0rKpEGqL7HlcrEACbXzEFMQkN9/ms0VW34QA3/n8a504a/K23BcZO/rl2fbAVBKzzt
         MxoXSLl5oVxiDblRY9vYCBPuB+RwVXCXvdxXc3VRl7Qkm+Sgq/CdlIhLtmfkuiPcl/1B
         ZHeDmercYsSHz//94wV9qnLFRzMzPKNFn/MyW7fiC89MiWN1RM0FDdcd09r7RXODIOuR
         hcwFcqdO85BaS7BUfdRGFyare9QuccAjgJP+72huiKgptPr2F7HKk4fz+b6PkDXsrUI/
         a52g==
X-Gm-Message-State: AOJu0Ywbl00AO27Yr8mCQ8ApHsjjrBK/IvXudQK3tr+YLbF90HUs/g8B
	a16B9b4H3EgNauFroRN+93fvwe87Nlp7VVxFklBQ4lMtUWmjg7JsM3+MkwCh
X-Google-Smtp-Source: AGHT+IHdQQEJxd/Ppa+IK/WPyTkY66l1gkV86eRmXnUotAPJ4/TROqh6EkJrdUfLI7aFyKnuvu3HbA==
X-Received: by 2002:a05:6402:3786:b0:566:ab2b:e1ce with SMTP id et6-20020a056402378600b00566ab2be1cemr3741482edb.18.1710722623917;
        Sun, 17 Mar 2024 17:43:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 06/14] nvme/io_uring: don't hard code IO_URING_F_UNLOCKED
Date: Mon, 18 Mar 2024 00:41:51 +0000
Message-ID: <e2939a17b63f9347ba3c1c193c4a9306c3ba0845.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uring_cmd implementations should not try to guess issue_flags, use a
freshly added helper io_uring_cmd_complete() instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c661cc48f3dd4a09ace5f9d93f5d498cbf3de583.1710514702.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/ioctl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 3dfd5ae99ae0..1a7b5af42dbc 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -426,10 +426,13 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	 * For iopoll, complete it directly.
 	 * Otherwise, move the completion to task work.
 	 */
-	if (blk_rq_is_poll(req))
-		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
-	else
+	if (blk_rq_is_poll(req)) {
+		if (pdu->bio)
+			blk_rq_unmap_user(pdu->bio);
+		io_uring_cmd_complete(ioucmd, pdu->status, pdu->result);
+	} else {
 		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
+	}
 
 	return RQ_END_IO_FREE;
 }
-- 
2.44.0


