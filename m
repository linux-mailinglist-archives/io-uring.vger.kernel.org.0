Return-Path: <io-uring+bounces-7295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D5D1A752D1
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:11:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1680816D471
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E10FF1EFF84;
	Fri, 28 Mar 2025 23:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QLhVpml3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4668284E1C
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203471; cv=none; b=FmrZiL7C6hkuuwnKD+tHEQvnnb8exDucE9JDE8YID7Ioht5kPeLkvW9UOS63/tW8DuQGvV3WOdSVEdTCfuchWq1tWo1dW8mSaBwwZlojewUbCNdq+G9MPdLu01VckP4FLkOwQvfTLBYx6hSgHPjnKC4nJAngbboQXAgPv9By9f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203471; c=relaxed/simple;
	bh=ztUHws4Vj8qEWgl290wlU7L1u/YDFTHmPGGh37h/Ies=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A7hIpK7/aRSOUlLDOmvlvaDLNXLt0IG4XV47/Xnib6WcoTE5r7k3hVRZ56LsS5/L3fhXDvqfBKY+DhSguZy8wDKlidcN15QgCzAAGJKEZvC+klRVP+0XjIs2QAjx6dSI53Lq9KixDVrX1LVo8QRw8aPytBq9KzluSA9Pj2Vb2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QLhVpml3; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aaecf50578eso456378666b.2
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203468; x=1743808268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XJpdAkkuYep8SDtXyxEaC923NunGAkOTXc/IF9cpdDs=;
        b=QLhVpml3ENor5r9ig0Q77RXEjqA92vHyP+tsbReLYme/cnNDtzCJlI+1WSBm+GDH8B
         QyFSS5I52p4ZXYa6tZ4eYU2KQLGPX14fX/9cbUxBwhwVAhx8+RkPu/4MjhIDvBLecN8z
         /A9W3kp2T9Ov4YFrufyNgld6ZIAvEBhWBQsqP6BGAu8mcwCJccoHbe8mAa+aYFuJ/Tde
         UaRXbx3RABmqHxBCIzVeghdKmPu/KrG8nfVhec92U+sOvFsdaNhpoaN8LG7bsUhAJVJK
         U/zs9yJaFVm7cVWyaqC/2SiGeZGmP54OsOihdIEedWm+YrYid4pSCH805yqC8bMNpkVG
         nJiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203468; x=1743808268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XJpdAkkuYep8SDtXyxEaC923NunGAkOTXc/IF9cpdDs=;
        b=nNCtLvvtQ5QYqulwCOUB3UwaN1jhluq67uhloUs34U4gHlxBr1SsoqI9IvYCNeh5/G
         YxRWvG2ZNIAhR6TdCqGzoOsz8wH+MkJN9rjsNuIyEzFAOPKhqzvoxFeuK8ZtzgcQ4QK9
         PQsvfjpPHmRNbt1xFrs/AuVDtR7m7YUX0pMOL3Yyef8/feJKEYCWjoVnmR+p7eDDPqRf
         DN84znyX8cFn92cgVvf7Z92fRwRp9NtBJr9rioFITZ3h8XKCoVcd3vEDQMNvovbUwszF
         BUQryyc8rnLFsJag1P1SVQZxQgIzQkYZy700CpC+pJ6yXYZFa56hjdSpC3x++uN1+E10
         fe6g==
X-Gm-Message-State: AOJu0YzQuH/ZOixlJTXCWfXjjehgxLlOCTc3Tmx7v63zf8y5Cet1blmN
	koictLv7PdhjC5aHSrYnwJr8NKZwZtjVMGHwZNRl/CspzZ8nIZAY9CPFgQ==
X-Gm-Gg: ASbGnctMUENxstp3J2K9Miszk3XdCwPvuExFSRBF0i0Ykhd+NuD/SqJw1iy7QQ9Zsvl
	PUUL6+QlZg99vCau8CF+IlSqbGTlLrvjPa+EEJ4XbgtafRUcqKsUxtERBGuVDmVT6XZ2SDEi8m6
	VsjEdRw9frRK6fdXrSsJRR0QtRrbNJ6iY4NhZY76JbOcL5KYF1gMrvLAJalQSe7YRs2NhTvkFaG
	OvoS/6A7ZvSeYZTJ3sg1Vu8ubKXbKJqHDP/cXBLID0g0pf4/Lyq9jaGzLLGQbQWCpdx5pLsIsDr
	bO4LptaggRx/iTzeRLloWgmm8BD6PHxk1WmztkW+iZev1TJSZW0Kdbae7mk=
X-Google-Smtp-Source: AGHT+IGUJthVHOrCX62YyVtmfTo5lJup/f1xRy1cG6dlBL9dI8FSe+R0k3UqcXFtRXZCKlUhPIU5CQ==
X-Received: by 2002:a17:907:940d:b0:ac2:d6d1:fe65 with SMTP id a640c23a62f3a-ac738be07demr72422066b.41.1743203468111;
        Fri, 28 Mar 2025 16:11:08 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71966df80sm222838166b.125.2025.03.28.16.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:11:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/3] msg-ring clean ups
Date: Fri, 28 Mar 2025 23:11:48 +0000
Message-ID: <cover.1743190078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Random cleanups I've got for msg_ring while doing some other feature.
The confusion from Patch 1 reminded about itself the hard way.

Pavel Begunkov (3):
  io_uring/msg: rename io_double_lock_ctx()
  io_uring/msg: initialise msg request opcode
  io_uring: don't pass ctx to tw add remote helper

 io_uring/io_uring.c | 14 ++++++--------
 io_uring/io_uring.h |  3 +--
 io_uring/msg_ring.c | 11 ++++++-----
 3 files changed, 13 insertions(+), 15 deletions(-)

-- 
2.48.1


