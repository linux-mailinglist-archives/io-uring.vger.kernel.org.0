Return-Path: <io-uring+bounces-9010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50CA8B29595
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F06FD4E19A5
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B841621147B;
	Sun, 17 Aug 2025 22:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nffEEuDo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1550712DDA1
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470631; cv=none; b=GGKMMl0wJJUvP3h0pgZ+wqH87rTLDZ88msnpbL0dNJwod8H33qy97nMHRFXFW5j4uZk6gE8c41G/dfWQkn2rJv50zyN5sUk3IeTmbziKwtcfORG++AltViImb/fVOQfeMwpYb4nJ4lIuDR3wahmpIn4dhMgaH+vWPAX2+pTxulw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470631; c=relaxed/simple;
	bh=eNhOT8nqgqEw4O4qRR4eOfJfWpIVufPr2w2fblHUqw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sj68Qusc5ZegkVtXYb8LBJiCkxndqoQcIWInqTtheCz+Tw0g7AI1srdjwQwAC2H7nM591ArZGXp6+8rI7D4SLIu0b+8FBqvPUeXvZ3mmyB6oH1Dh0BNIdrRLanzcyyNJ64UhVsQxGp3V65JPqQOB4e7V3kvcP4wMzcwETaDkUcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nffEEuDo; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45a1b05a59fso26179655e9.1
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470628; x=1756075428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JKhZNDoA0xlzrLvvvq8p9Nj7OpPxsJzTTgKvDMugPfE=;
        b=nffEEuDoX+QsbY9U3RQ+sgtMKLQHw5CZcaab2TbgspVn2+B1ZMRzTj5HIMnmp5hpf8
         SYrs77Pb5x3nNslt0yeGaKlzJ1wHL+cdn2lEM3IJc+OA1TMtow845rJAA8ePjVs/JSal
         Y1Pn5KY/xdS8VKaLs2mSOHt15iOsbGin99mpSSj5NQZyyOatR/eJ346jx3wd0Pu0loH+
         PcFKbrhyMk1dWK2mT5FtNulCW/C0fy99fOpl87V/cRrlfkVVzRLoA+DwuuHURKk6h/qq
         sBa1GbCdOFe+Iql11vRcwXqUZBJa2zKk7EDWtktQuKviHDNp2yo8WUDWK42qesYTo0EW
         cPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470628; x=1756075428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JKhZNDoA0xlzrLvvvq8p9Nj7OpPxsJzTTgKvDMugPfE=;
        b=D3LOwJQMSq3SaB/L0ttMT2V8iRX38wNUTguWgAR9SSa+q27YTBmH2kB4AVTKJU4T79
         TpMMoWt1KYxcE7a/uUEMHG/gT+soOpugg2ytu0bU9sd0E48LDLKo7sdK7l3UeaSjL4jI
         bf3GzQEeyrysAD3lx3IXLnwGc2UDIfIpwAlUFH9qP8TUFciCesp4QRLYITwfwJO6kXjp
         TeCLdXk3s6vs0NmHo8ax4HvlaGKnPoRZIrep7y5H3sqF3uvFPMi/ev83Egb8Q4RTtqyT
         RPwS/moLBe4LlVoo9GRvE+6+t9Q+rXZ2dtB0CObmJ0HgSYPSONlg77qgELcsxRU+HALy
         Q06g==
X-Gm-Message-State: AOJu0YxFKf6Te8snmyv+u1bhZDq5he6/DB9p2l0td14fqOmcmVGPyvjF
	B0uaDR/G5M3RmxiW05ut85xvGBoGAp94Ke8CACwTe+wRMgFv+XppXga3b+MPVg==
X-Gm-Gg: ASbGnctygqNNSreTu0iUliLdIWtuyC/U70J3A0/zqShTXDXnOke1iR5iuMLTUwKqEDe
	vKZNUQEkHxxYtTfjn8bXKi+cIU1KqfGJ/D9fnzt+U88xvMwoJE/8uwzyizpBspc/2E5yPImcxhJ
	Rjp+dPoqT6IkRpPirzioJP4xNJBwSkM7gnSRy77YoAmmnY3vhCo/vjj69ZIUOomX4FFss1+R4pa
	tS9oe4+NzZZY4Xu/ndvQGe555QpdKGw+vs4tW5TmRoMNPIdieavwX/BbWK8+7C4YguQfzq287k4
	1pqNPDZnuU4zxfrYZrK+7ttA2xtoSZtXTCAkBhWLnwY2HDGzT/UvV+qCTMpXe04lmSK1MHP7/Dq
	wqGPeWFrPHgKZzFgso2DZgY5WDTfRZ3yqFA==
X-Google-Smtp-Source: AGHT+IHnTULOur6GIkCEkjb4SON8UgKbdp3BHtkdwfIk4AdrkLZ0Gpg847NQE2XVuIkew7UpfV7f5A==
X-Received: by 2002:a05:600c:c0d1:20b0:458:bfe1:4a91 with SMTP id 5b1f17b1804b1-45a292426aemr18566285e9.20.1755470627973;
        Sun, 17 Aug 2025 15:43:47 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231a67asm104759135e9.11.2025.08.17.15.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 0/2] add support for synchronous refill
Date: Sun, 17 Aug 2025 23:44:56 +0100
Message-ID: <cover.1755468077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Returning buffers via a ring is efficient but can cause problems
when the ring doesn't have space. Add a way to return buffers
synchronously via io_uring "register" syscall, which should serve
as a slow fallback path.

For a full branch with all relevant dependencies see
https://github.com/isilence/linux.git zcrx/for-next

Pavel Begunkov (2):
  io_uring/zcrx: introduce io_parse_rqe()
  io_uring/zcrx: allow synchronous buffer return

 include/uapi/linux/io_uring.h |  10 ++++
 io_uring/register.c           |   3 +
 io_uring/zcrx.c               | 100 +++++++++++++++++++++++++++++-----
 io_uring/zcrx.h               |   7 +++
 4 files changed, 107 insertions(+), 13 deletions(-)

-- 
2.49.0


