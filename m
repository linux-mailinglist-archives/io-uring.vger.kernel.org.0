Return-Path: <io-uring+bounces-6538-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BE0DA3AEF7
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB6827A45B6
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 01:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E411128FD;
	Wed, 19 Feb 2025 01:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbplu9Pj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACAF24B34
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 01:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928764; cv=none; b=kxvTo4qxr5VfZC64bvUsbHy9WSjyA7+h8LWU8xajRNdfYp837e8GJiKolwVNCY4QBWqDunl1I5bqzEsDXdLJJUizMwt96q1aADcbL4rYzlpQN7rKUZTx6ITWkFujwV387QNbPlY44xEi38h20fu0HJE3jEiXYo3+N8kxmfn9Dlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928764; c=relaxed/simple;
	bh=6s2hVJ8wvr2md9K8eAxv/uluJXGgzC69/1QijFmCvOY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cArvSVvgt7i15paD0wOGS4yyMeI0Rc1LnY2c7GQ3o1h/IVUrnYeY8yb2NKx1GF+Lak8wD5IeyGEE2SgVV9MnJLnuBUeYtFkHt0QkdJwYY8whzewC+x9Knd8cmP61QvVeeVooOwlxq7D9Hs0Kwk0zWR+mbEtxAdJCi5a5d8MvcsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbplu9Pj; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38de1a5f039so5997670f8f.2
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739928761; x=1740533561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eVPfCL9fxSGW/uSR9VwXrqLS/qxNKkmPQkxdCoYTrdg=;
        b=jbplu9PjkPG+EC/5e+rHfYA7f84dD42CdD34Lu4W7hHiA2glWzpwguHXKiHAKK8CKv
         kxOuXKIP4bCQGQ1mjazgzJSTD5UPQWysVraFx+S77bQq8xQDyaBvdUMl6JY552n1IpuJ
         qz3jVkyVVjVFl8Jl711mIY479hiMIui3M7BBt8QdO78KT4qsyqD5fIddpKAaD5b2qM3H
         j47ck25UDKpmSGUR6cGic1hN+XsZudqK2893+2Q4QeD8OE/jFHNc2MDYDMkAZULpxQCN
         AJQoPgmV1BUoTsTFJK7j/SH6XKzGHUCcmzc0/jBAGtunGDhOzKSiEFCNHmTaRQ22UN4y
         rRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928761; x=1740533561;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eVPfCL9fxSGW/uSR9VwXrqLS/qxNKkmPQkxdCoYTrdg=;
        b=osqFrYBliTpmp4qZhz2rS1LpS/HO1GelusQdnvMdl8cFRZjCvsUKQteVpLB1Ki1I4r
         fauz50Rr8W7Cg3Uyfy5uMppMpKEtfBf2OE1XNxaYmfJWyI5UCW3Rc8V8MT8VIJqcm5zs
         mMJCjVhOuNqAtpord3iIw5uqpIr1lli1/oie9hrRc+H6E988+FF+Cs0tEN3qZjAsi3ny
         IrsPuDA0IxLORpW87o4tGOQVK8Scm7wSempNT8myDQcgTsiyAFiRtxs6rv7T3f9Jy5Sz
         l6Z6znXf7q99zDYDKIM+hz+MF6VoFU8jQSUqFr65ZBoHpTLNs/7E7S+aqypd8I3DIRvb
         D0xg==
X-Gm-Message-State: AOJu0YwkyfNcfRvWM2oVBnh6Gp/hdGTa6jnzMabt/b9PaFaKWpt7Y5E8
	TGyeD2TTyhk9a99NJ0J8wUT1p+okJDZ5518kOGtWF2z0E37LR4JLFvqhiQ==
X-Gm-Gg: ASbGncvwUxhRgvOevDb20/aIrLl/sWX/WuFX4QdZY6zF6jKAp/jIpEacoxgZTwMyeyP
	aLOo9rqE8hO2jVEiptFsmT9t7gNG6+VvpxGybpuKANNOqbnm4d/Gmb+wuSqxWBDPkMmKS0BL7UR
	aH60m9EHJI1sJCouMgUtKCHhu8PqiQ8uxIMIeVdcZEUaSC1MHkr7u8glmrlUf9QTWbiU642mL4D
	YJLOmIdAqtLLqhhIe3q4Dq15KHpJ/H7yQOl2HOwofUCqnbtrdph/mEhdGChv78YQfjRPa1iT/if
	LofL1LEqM1SqJckLwikZQQKratsE
X-Google-Smtp-Source: AGHT+IE+aY+cs08Gl1nsJ53Bi8bMq6TpsXruXXRn0cH1Fe4E3PLRRWksrTg37PKTqahWaxdkoVUz+Q==
X-Received: by 2002:a5d:6547:0:b0:38f:2073:14a7 with SMTP id ffacd0b85a97d-38f33f56437mr11148432f8f.47.1739928760878;
        Tue, 18 Feb 2025 17:32:40 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d8f1csm16617752f8f.69.2025.02.18.17.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 17:32:40 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 0/4] forced sync mshot read + cleanups
Date: Wed, 19 Feb 2025 01:33:36 +0000
Message-ID: <cover.1739919038.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A respin of the patch forcing mshot reads to be executed synchornously
with cleanups on top. Let me know if you want me to separate the set,
as ideally patches should target different versions.

v2: clarified commit message
    + patches 2-4

Pavel Begunkov (4):
  io_uring/rw: forbid multishot async reads
  io_uring/rw: don't directly use ki_complete
  io_uring/rw: move ki_complete init into prep
  io_uring/rw: clean up mshot forced sync mode

 io_uring/rw.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

-- 
2.48.1


