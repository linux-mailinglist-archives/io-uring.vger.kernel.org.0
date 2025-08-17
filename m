Return-Path: <io-uring+bounces-8989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4BEB29580
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0671A20252F
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68C721767C;
	Sun, 17 Aug 2025 22:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+cnMxX0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4921C5D44
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470529; cv=none; b=hPqD1dtLfFkulvEgBVWWS275TwhW4QRp2SWWWFGy8yl5tXucHgrcuqJ0U/FbNJusSoPnp88PVH9AjT0HWWZBcG+hKQjH0eEmKiQiXz5zdcKAh2SmnRcRtnqrtr/eNYiudxdtFtHBPIxUU+ZZtIFvqU/j3lLXFmHX5czoGw6fRfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470529; c=relaxed/simple;
	bh=s2nnYj7ql82y9y+9DeiUSdG+v+ARPw+YkiUUN4AndGU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JmD9yyqB5ni298xK1GC6j6DQ32hk5mkT8UUzbvuyHNAdbZ8KZ6pX0VDi/i6/h1nCi+FN5/ngVKQEGovm2t4ZiARsPBV/WBy2cttabkfzNcrwPTss9d71kDs6d1K4ZCHzEjxkTrjWCcMHEbn+9CjStrPoWf2nBOzsQlYTnduz1Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h+cnMxX0; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b9e414ef53so3806967f8f.2
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470526; x=1756075326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AyVt1hvpDZ7DC0VILUac01KcEPGJt1iaw32KlqJygAw=;
        b=h+cnMxX0Ic5MJDn1pqdYDIKd729NBqsD/citkaROeeP63pdNYLvppBl6h7JC0Kakmy
         a4wtzJ7CmI8Xu+2BeVbxCdQI8o9xCoOUUCXSa2LoYWibr6M70kkJpiDKrL8ZLJ4YrhB+
         eAPL9lTRywqUAjUULmgxBF73AfRrgKneJi4XY9hBj5qIAKu5gm2p9y+tHcnVef5XorlP
         DrWKr5WdIk7j1eE66VzGf2Kpn97UEvzEmZP+1JlrlgGWwefbLzFvlHI3c4Rm9TwAmhpY
         JxtyHL+NAu/wIs4EZx82F6UFTqS4NZobtQqPdwRSi1bmDzj1jYMr8P6fuyunS7mYW2hW
         /beA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470526; x=1756075326;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AyVt1hvpDZ7DC0VILUac01KcEPGJt1iaw32KlqJygAw=;
        b=j/LrNxuHdAiiYN4rqK+6P2MTLqK749tCj7UBSno8lDSgkqo5w8zOIuap46yqkuqpfQ
         r4/9UxpggVBQbAhjUstjUp71Y+58CuXKBpAckPP/cFypJmr9vGheguwWbCjQXsjILRZ6
         eYPYFnavKxhfOL4L1bKbyOhKb7obNANF7zwpZiD5W4vukDSvwvjZhPAMmzUhcGh+DTvL
         RCMNfflqt6upjGjRuGKxNmEDz2wsCQZLNthd+WgXWedcTPCnBeLXvX0OuGBGRvdJrM3x
         IDRqLVvxz4U1yivB1YYHlvv0htxp97t8PCf2HnoE05GZ/T4sZMKOrblWl8aG4LaTm7//
         /79Q==
X-Gm-Message-State: AOJu0YzFql+Jb52fdAnu9AUFIOM7HSJVh6PWKudw0eyo2qXeRyMQFxPj
	HkmnvKmmk7iByqscRgVnaumSSrc8JNJfHXcPy/WCq4jLRiNkQ79m3IJDycQx/g==
X-Gm-Gg: ASbGncskSboPGu7Ob59BN0PFPJw99zvh6i3qIyu2DpPrsOVot4CrC0cDcy/YEWI2QBa
	e37yUiTjR0zdinkrBTP5JlJTBtvH8hjj21mKfIVyY3+TCvj4m1JvjzhHahiZad5pt4rYjGxDkYI
	qvBZ2XprSFrNNZHautBodjp2pM1cvlDJUqfMXmWR3aYJK6hcCUF7TDPVtez+6OykvKIr+ASKcm7
	ZCKAC6vDmSBNzBzxJpRaZeoNf9MU/RmyEtOTIMAtvGN9xOzr6mX9FZLhU2L54zH9gQ0sqAXzm1C
	+gbkHY/AVxyxe34MUhBs1N40gKvem2nbA/7nUFtluGfcm8USdn2UCN1F37nRt0NnI/obojiqSrm
	xbYg1zH3J25HGQdLF4kvWIRmHfNk+zzy8KQ==
X-Google-Smtp-Source: AGHT+IFZizPwTkaV03OQw8QFrlCY/ncQ6jdRBGD/AviZS7fKMy/VeNh62NNUMr7ITN2uDp7lCcO+bA==
X-Received: by 2002:a05:6000:2c02:b0:3b7:8b1b:a9d5 with SMTP id ffacd0b85a97d-3bb695a49c0mr7797355f8f.51.1755470525736;
        Sun, 17 Aug 2025 15:42:05 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c773e57sm153261345e9.23.2025.08.17.15.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: move zcrx into a separate branch
Date: Sun, 17 Aug 2025 23:43:14 +0100
Message-ID: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Keep zcrx next changes in a separate branch. It was more productive this
way past month and will simplify the workflow for already lined up
changes requiring cross tree patches, specifically netdev. The current
changes can still target the generic io_uring tree as there are no
strong reasons to keep it separate. It'll also be using the io_uring
mailing list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe168477caa4..d9e4ab173000 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12870,6 +12870,14 @@ F:	include/uapi/linux/io_uring.h
 F:	include/uapi/linux/io_uring/
 F:	io_uring/
 
+IO_URING ZCRX
+M:	Pavel Begunkov <asml.silence@gmail.com>
+L:	io-uring@vger.kernel.org
+T:	git https://github.com/isilence/linux.git zcrx/for-next
+T:	git git://git.kernel.dk/linux-block
+S:	Maintained
+F:	io_uring/zcrx.*
+
 IPMI SUBSYSTEM
 M:	Corey Minyard <corey@minyard.net>
 L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
-- 
2.49.0


