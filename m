Return-Path: <io-uring+bounces-6062-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD402A1A5B0
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:23:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B0E01884337
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41FB20F96B;
	Thu, 23 Jan 2025 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yQFdtmZT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23DD13212A
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737642191; cv=none; b=BizQMECF5D+WwZ86Vl3nK0ZGzW7kuHOhEXpsdtRe+DqQl9ET5wPvZEupHGyWi5BqyqGnPxAFLA0P18y2dnMIDiANjtUaAssxjCNaFAiq8DeasOiTlC0xl9SJywaApRY2P94OrVSnkvohMP/T6FP3rjHnuV/YN9Su0Lvfj3L1Ffs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737642191; c=relaxed/simple;
	bh=Xns51Vz6Rh7C1fPVD7AYCURfsXegQLXtQCL8ZmomcTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Njp0zcPEFcsp0lRA0cAB0KnkhS0vh4pxXKYLuLFaKjh4ltDkZ7tjr4J3+yfwQ/ZddCC9Dtr5buo9dl2VemnzACIcEb3r4wVJDbLr9etfq8b4UWTJJnR6eZ0EdKvdrQNXVw3OaakT5dvoWxjVe+jGItogabbWM2bRutlO8/4O+kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yQFdtmZT; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-844e61f3902so71047239f.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737642187; x=1738246987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nsc4bN2nBFss96MyL7dPMTjUepgDcEWleenTGlQx2Lk=;
        b=yQFdtmZT4o9Hx0no1gdAbcEXPpzF7Z/iUl7lPG+kt1nqkdhL0+8M6uyyKOq/2aeM8H
         MAB1RlGPJ17bf+nWc3wpdWrehbKbK1GTdZuFVhcNQPvLXevGgnGZdaLMzRuAl6ri2uBe
         K33fEWjoPoxzssvCrsFaUZkvMc3DDI+XQiwxrFGCKe672MV+U2Thm8xFuo28a5V0ZX88
         FvWtFVvzh0xySScZYNAetxBrIvLhm4HQ0aDKaP6E7fAgPV1sjCui0e3V/NJPro9WHxpD
         KZZ6QLQyn6jW/J9202+UZe0ARlBEGzkAO8qO2H4vLAu57Q2AbHUemXbhsYAUK3G7ug7X
         MsBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737642187; x=1738246987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nsc4bN2nBFss96MyL7dPMTjUepgDcEWleenTGlQx2Lk=;
        b=SrkBm9MwQh2i06z2N5/rs+lfDU6FSIWrCOAq1M+faTEg5h9Lxh6SMjhNBhtsLqs0gR
         K+wZgMYetfc5C+trtN/Iesl7HGYMG2SS+yJ5VIHv4jPdnMu22KMT6komGNlgC0JUadKL
         J9P+PsNGr3e+/VukHDBBChdQfe1J/LZQthDk4Cef0qFFFgjk4NRR2WCTBrhlZPVJ6ay9
         t4gefAj48LgrZ702+l7cm7zSDkPNgkbx2i1r7fLk6i1aBXDb5qbTHk99sshTAOu2Bc+4
         JvnBgl/4DsXj33I/gn4iV2ibUaGQ6gyX7gh5WTM5baCX9c+gUpv/tjQ/+BqOoefijFev
         43zQ==
X-Gm-Message-State: AOJu0YwzX2lkMYqOBljMr7YOKZLnPr0EIr20c1+0OHCrkCTBMoWIXqjE
	2l9t6D0i8l6cgUgBoh/k77l26vVinCFuKwUZejQ99kD2FT/MYt7m3hc4kl1O8LNdFfJLuJB92DE
	x
X-Gm-Gg: ASbGncskhCi3UdniMAGAbq9SpAjBQEeAlrgSZOC4gI5YLd5y3tQ2aql9JyUBRzRdCbg
	cp3HctR79HN8sp8rQiuaOAy238Vkh4+WM1jm9ZO0uSOpCwILW+96wTUgcSp8FofApOKfx8BH3dk
	6FGVJzkfAPXqAFYpsMt3cAzASMUXSAb4XHDwqVwsL5lfKEXdxptj6l4lOilC0RiOGEixji0zer+
	UDTGoGb2VBVvqf2ZBmxoYuZ1tMMSjFzODybqPBKca/QGM8NXScJ2e95M0yVB8jyGzzJzUpE2o7H
	h+P6dgjd
X-Google-Smtp-Source: AGHT+IGQrmQuHxtPJskKyPa1GSb7L+4uAfcvjHt+ZetbG0kvm7Ei7Bsz7oylpaWC7hh2bXVdAnmj3g==
X-Received: by 2002:a05:6602:36cc:b0:849:c82e:c084 with SMTP id ca18e2360f4ac-851b6192ea6mr2255098439f.6.1737642187549;
        Thu, 23 Jan 2025 06:23:07 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-851b01f2690sm446847339f.18.2025.01.23.06.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 06:23:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/uring_cmd: cleanup struct io_uring_cmd_data layout
Date: Thu, 23 Jan 2025 07:21:11 -0700
Message-ID: <20250123142301.409846-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250123142301.409846-1-axboe@kernel.dk>
References: <20250123142301.409846-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A few spots in uring_cmd assume that the SQEs copied are always at the
start of the structure, and hence mix req->async_data and the struct
itself.

Clean that up and use the proper indices.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/uring_cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 3993c9339ac7..6a63ec4b5445 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -192,8 +192,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 		return 0;
 	}
 
-	memcpy(req->async_data, sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = req->async_data;
+	memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = cache->sqes;
 	return 0;
 }
 
@@ -260,7 +260,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		struct io_uring_cmd_data *cache = req->async_data;
 
 		if (ioucmd->sqe != (void *) cache)
-			memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ctx));
+			memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
 		return -EAGAIN;
 	} else if (ret == -EIOCBQUEUED) {
 		return -EIOCBQUEUED;
-- 
2.47.2


