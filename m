Return-Path: <io-uring+bounces-6056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DAFEA1A22F
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 11:50:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA49D188478A
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 10:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC0320D516;
	Thu, 23 Jan 2025 10:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="IZF9DvGn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F482186A
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 10:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737629437; cv=none; b=iGSsiXT6b4EZzbxeTra3NRbEXsfT7BVomfB19b+fyg1IBsEhKp82YvPzTrzdMuiT0/qcm1623gvRlNeI4nTHXymJ0vNdLrraRrVuUn2Nb75ExS3GU3fAa68POiHp1ly5W2G0qXmXbldzd4vlMhT7hrphKUeAQpcByoKJBEJQxO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737629437; c=relaxed/simple;
	bh=PWfKn0KYQrXiqJx5IUkrtmZZQJRrp5mi5J+6Krn/VvE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ntiBx5mxmMSZhXSQdZaCwL7sNMs1luxTaomrblElTS6q4aI3lHzpY5o+RKmVEvFzUbQbBTyxDAa6pthkSCjAyXOoEUDjux5osJ+/m7YuY3k8oTNIAiBBzXElZcWdsr5Vx4smoDsnl6Ry3N1KSD0I3jI/BVHA0d3myfeAlDR6wkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=IZF9DvGn; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ee989553c1so1398299a91.3
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 02:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1737629435; x=1738234235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X/VqXJaz9or4hWgP78aP+9NgMAzHaQ4TkrVX0Qmfb70=;
        b=IZF9DvGnqLsfMeJG4L0uk6moSb0sMu3OFUH5+vc7hS1MuX4O3xvs/MdG/zPNBK+Bja
         JFW9Q0xqig/k3hrxt62gDqm104MLasVSFkwJJV30pqKvySHmdu5D+lTP1TYuau2JWMoy
         Qy/Zhw752ah61GkTPOumwRZj1AoCsQbYm4+WppZ9aNqao7hkc9ylW3aFZOJDnosJObFx
         NwE0IWwVTdvyUPsRlTNifWYcWylL2cysJ6gxnluzbeRqFFUSfkwimwD1bVJ2ophXGAnB
         FIWbFv0hzMrwO7ab6XtsIQq/gPkF5lvC+Ln6yK3Ohh2vzO9t6nmEbHQjx0hopWOcjLuQ
         k6Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737629435; x=1738234235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X/VqXJaz9or4hWgP78aP+9NgMAzHaQ4TkrVX0Qmfb70=;
        b=S8zQmxLeOUeFEveSROO9VBKvR9RFA9fBdwHUrHcuRdC3LNjElf+18XymzQS099erDj
         tz8B+frmtxN8+e4oSX2Osct1udqdw5KCHluBmDf33pcBHaJlUgbPt3ubPmxsZfcbPtcu
         zkjZ9tlM+CAvTyCc0fj7TI1DSfc79ol/BeKcPq2wgX1Mw+1xiKc1MqAnmoL6EgQ0hBS4
         Dg4kvKs8WuXCj1WKIRHLY+75lRUVe+CloozDBgZZVzs/aUIztXbU/0YXOhQSsiWkuWg4
         EY78JVbAiorcNa/PJPCeAIevAa0EowEEKixmIq7IeG7xafdRDWU7Vjx7HfpM+Qux3Boe
         +gWQ==
X-Gm-Message-State: AOJu0YxTBtAKQjgP7NGPjxOjV1whd9HRzxVwIavJarEzEdI6Sjf4TFl8
	d/E9bvYICwfowGKkSbF0vFQh5/YXUA3OoqdL0N34IlVZ0EOOgnKaU8oAYvHq3GhPHi5l3irj+Lt
	cIls=
X-Gm-Gg: ASbGnctNAd147SWS0y4p0/xmiDgV66S1AHl/lwjnB8Tn8RkY/wsDTzquP1X4m8HOuuC
	dJnjK6b6dIKsSBZfEy2WNK2Ntw+4F3lDsoXBnaO5yEZ8hMMsAprwqPzckCyItB4VWyMn0IY0me+
	RNZpAhcC2GRK+5wz4NBoK9Ask9L9StnzNimH1A9qtaoN2JHNLArbYRIK4YseMOnEAzYGbQdrxyG
	ppu8DvZ2PEZD3kRe/+WK8/eTYsTG+e9RJ2f1iWzfPAIl6vjCdHlIRYaqhRvHezfk6irDteFw4MQ
	gpsJVRE12MsR5t5gUQssnP3SVpQsNsDC75r0zACE
X-Google-Smtp-Source: AGHT+IFNoTnCS8DiO1R/80avG8u+u+2HY/x2kZ/OdJ/TPc8NrPclij1u7GC4TpqsJq04jYP8Mf7IPQ==
X-Received: by 2002:a17:90b:4a48:b0:2ee:863e:9fff with SMTP id 98e67ed59e1d1-2f782c701cfmr39762964a91.10.1737629435076;
        Thu, 23 Jan 2025 02:50:35 -0800 (PST)
Received: from sidong.sidong.yang.office.furiosa.vpn ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7e6a5e2b2sm3598317a91.3.2025.01.23.02.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 02:50:34 -0800 (PST)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: io-uring <io-uring@vger.kernel.org>
Cc: Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH] io-uring: futex: cache io_futex_data than kfree
Date: Thu, 23 Jan 2025 10:50:06 +0000
Message-ID: <20250123105008.212752-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If futex_wait_setup() fails in io_futex_wait(), Old code just releases
io_futex_data. This patch tries to cache io_futex_data before kfree.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 io_uring/futex.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index e29662f039e1..217a38498c36 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -262,6 +262,13 @@ static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
 	return kmalloc(sizeof(struct io_futex_data), GFP_NOWAIT);
 }
 
+static void io_free_ifd(struct io_ring_ctx *ctx, struct io_futex_data *ifd)
+{
+	if (!io_alloc_cache_put(&ctx->futex_cache, ifd)) {
+		kfree(ifd);
+	}
+}
+
 int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
@@ -353,13 +360,13 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
+	io_free_ifd(ctx, ifd);
 done_unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
 done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	kfree(ifd);
 	return IOU_OK;
 }
 
-- 
2.43.0


