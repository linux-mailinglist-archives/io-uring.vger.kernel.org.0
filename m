Return-Path: <io-uring+bounces-2851-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F410959002
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 23:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF879284DEC
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 21:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0CC154C10;
	Tue, 20 Aug 2024 21:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BcpA+aiN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E221C57A6
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 21:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724190811; cv=none; b=nfjWJUdt50vnY29njlWS+c0CUpMmY/o/Ggo4q9koybPLTiwQk6RR729DJ5g+i7iHxM13iP5NcGA8XbOny0kT4gNcXXCU5y920SuHrp9WhTXjKvuN16PsQ8bER8U3ZDV5oVqMbGWioYPST2g/SdgY5Se5nitaqxmejJ+pjvoJAjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724190811; c=relaxed/simple;
	bh=RhNYw7mAdhZfgeamA68hm+Y7EGtxUNCyPl9DsESkuk0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pQl6pIRpxMknnqJ5Bk+WH+FDz5nDoTaY2ivnF5r95LEyyzRIXFvlWnLkdfLoPr/yK830fq7OeMcKWGQAJSxFZR6yBzi6J8XVnPzbeYGaVZKYEMVUorF+jImJohNndNW9kOpQAZevDaDW/Ktni4Mh+FrJLjbJ+64bm8nMAMqu6ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BcpA+aiN; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a7d26c2297eso691890866b.2
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 14:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724190808; x=1724795608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zPiuOc0Ds4TXOsTSymRy71QH64OUPsa/XwqfFqjnNV8=;
        b=BcpA+aiNA5VQOEKkGXRT/DnrLTXlwr9tfMQONdC3ucnv+//4w1EQvYgg0E1NqgRsBR
         w+UaobaYPQOjJ54AOSmhADc+r8pibONpp6zojwXlTcQxbeKutzPc1dA3Yfvh7wN2EbZy
         Oja+AebNJcnMtOeVKYmHnOD9yWtMrRKsSKmuujFFO5nl517d3+0If/UNBbpb37WUHU27
         zFvlrSXhcf9u2cDbTTAYdYMX1x7O6ERiiwoblMIcHTZu2tDQbDZ9JK/oZQ/DNYVK3G4n
         IYhm5VcaHaNHns0+XIfs1KfoeTlBCUB9kjmglNrg6s+PM3uIFBxXdGPP26jMHO7yRQTU
         LJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724190808; x=1724795608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zPiuOc0Ds4TXOsTSymRy71QH64OUPsa/XwqfFqjnNV8=;
        b=YJlQrCDyzrdemyo2b9TacmcEEFAlPIERA6EG3jFxRdYLB6u/ltEa08Az3rLOeZs1x2
         IqhDEOLnCa/WEnKGRyhhVBqQD0RLt9WgFR0J3++8NOJWYpL8L297tOAhzGywsMPoe5Jq
         UrWdJHMsAql7ZV/IVwJm/Ae7HQgCRoiHKMKOJsTez+OBh/gDP+Euq2awufWEGjwun4uq
         WpFc2fRPZChVCVVY7t2Y6nvhgRZfbx912OeMZYNAgYLt6YswtbapbW0Uz0U5YxcypGEQ
         AJzG3eLruMqRx+Z24avnGT2JB32bxxi+/hLE4HRYdB68icqv3XvhEif1w5yiS3uVnQDD
         qWrQ==
X-Gm-Message-State: AOJu0YzKV8ef5E5gNoTCiTPOauVz6yzGnZ9azkzKzh0dNxex4YFCmAu6
	24jMrxjbX3eKrwX3j9kO/7aI9Xf+FQwSvgYzHcAyIRanhN1//FZfAWGZXA==
X-Google-Smtp-Source: AGHT+IEe+hKCa9LjjC53wELNdIvtrPY51TIlOuZmFZqTCLTulQ3TdtOvPQ1CV1W45dsygmNRb+7+IA==
X-Received: by 2002:a17:907:7f17:b0:a86:7513:4f9b with SMTP id a640c23a62f3a-a867513629fmr5517966b.44.1724190807225;
        Tue, 20 Aug 2024 14:53:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838cf2b7sm808850766b.55.2024.08.20.14.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 14:53:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 1/1] test/send-zerocopy: test fix datagrams over UDP limit
Date: Tue, 20 Aug 2024 22:53:39 +0100
Message-ID: <285eca872bd46640ed209c0b09628f53744cb3ab.1724110909.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 8796974..597ecf1 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -646,7 +646,8 @@ static int test_inet_send(struct io_uring *ring)
 
 				if (!buffers_iov[buf_index].iov_base)
 					continue;
-				if (!tcp && len > 4 * page_sz)
+				/* UDP IPv4 max datagram size is under 64K */
+				if (!tcp && len > (1U << 15))
 					continue;
 
 				conf.buf_index = buf_index;
-- 
2.45.2


