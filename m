Return-Path: <io-uring+bounces-1964-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0386F8CF006
	for <lists+io-uring@lfdr.de>; Sat, 25 May 2024 18:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADD311F21113
	for <lists+io-uring@lfdr.de>; Sat, 25 May 2024 16:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730731DFFC;
	Sat, 25 May 2024 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZidY3Q5L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B6C86120
	for <io-uring@vger.kernel.org>; Sat, 25 May 2024 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716653388; cv=none; b=Q5eeKatTxvZ3LRKumYfoki3tU1ev/S9uY6kFRL6S9Byv8Slx862B8Dmm7gUwsGuMeRAAlekfmtmB8Mw6wyJ/jmPztWm4bwzX69sUAOOmkVfGvXaKv2AzvuU8eSma/Hu4iomsKrrRPTGukTBnNrl6rF55qXiApKtUrfLLIDnY7Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716653388; c=relaxed/simple;
	bh=+Jcn6YHZ4IJLpB9CyudGxBGdnzKl/HpajV4yS8/BpkM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=B7YiXj2FeAzlxQ3A+BFM2Gziu3LSD1OOPky3mjPzu+N1SGV8rsBcopm/tFT9xQXkjnRWFkrXMwiDAluzsLPluSgZctKUB+Zu6R5D1T8WE1Rytzm2INKUcCH4Y7tKV4bbtv1vrfZUPkRIAxcSJfr4SocfiH41XRfMtFNhBI5bZJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZidY3Q5L; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2bde4d15867so390931a91.3
        for <io-uring@vger.kernel.org>; Sat, 25 May 2024 09:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716653386; x=1717258186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DYA7VVYFCs5/nkFJ/87XciqihGyZSx8bXRybc2fht9M=;
        b=ZidY3Q5LIDOaxxw/wPFeQJm4JFzLc9baJEk9XJbwvSvX37juOJ5MeBV+45QV5NfPdT
         2U9/gPM0n2E6y7M9yRshPBE743civjGguKm2ZvsVSClngnUF4TDjgeqrVjT6mI6H3r5j
         bwAjctX5jMnr/MV879QbmFtzVBwysNrvoKV6hdCj7MwbMweuXNJrlmAYtZ0ui5DZZf8j
         4u1vSp3hXO6WtMAghuKo4aOSHbHnDVyc86gUNsBGTJKxLw9NVet1TZa49hoYrrj+YN1A
         SYHi9BO7scdPh1OE1BIhgJjLorzQvSPDESBUn6+Utxe3AvHcydCrCrvNtJ5ZFfZOX2fF
         JdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716653386; x=1717258186;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DYA7VVYFCs5/nkFJ/87XciqihGyZSx8bXRybc2fht9M=;
        b=GlmJAyYmD+9zEf+7MuhLJxeMF08uD1FgBrEknfSwhjdXYI13k8QWTJ1onelpXjcqoX
         yeQ2EcFQgUjv7shW29dQE2Lpheu571vOgOV+oI6aD94jQ9hTHPX8kJYNJJyN/OjYEt9K
         BDu81mNulGdFFgM6K24WFxXdTb5MLyXKrXX7RM0pBSbkdHXcYElCZHdQOKHcIsb8cQQp
         zolQteCE7sEPqzHodyD4Q9LKurNwgXCsBioSuBhgK7A5/HN2k1OhTkmjOcDs/n2Xm3Pc
         NdFjDzYe0f2Hrx4fgxdPwPhTwK+KdCtyaIPzSXZqX8eva64b6SsO/8ibAO2Yo/Mh1LAG
         lmbw==
X-Gm-Message-State: AOJu0YzobwbVCYsiQ+m0N2fvBOmf/p8+mCjRfi5rfJ3rYbyvgAebcd8J
	oMnkMnIzNzGCbVI4kSuEwGYKkZlSwHbG4DKQ1ue6NCwU8gO7QE2m32Sk7XD02ARbW37D5GvwlWc
	Z
X-Google-Smtp-Source: AGHT+IEWW1pKiLdBXRejYZdsukdhsmDRgT5G/26f8vuDdGDVLH98Zr/iW4hf4u4pFzby/G3ZPtXd6Q==
X-Received: by 2002:a17:903:41d0:b0:1f3:453:2c82 with SMTP id d9443c01a7336-1f4498f40c2mr59171675ad.4.1716653386037;
        Sat, 25 May 2024 09:09:46 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c96ccfasm31974765ad.147.2024.05.25.09.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 May 2024 09:09:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240523214517.31803-1-krisman@suse.de>
References: <20240523214517.31803-1-krisman@suse.de>
Subject: Re: [PATCH] io_uring: Drop per-ctx dummy_ubuf
Message-Id: <171665338223.160479.7062452829209024213.b4-ty@kernel.dk>
Date: Sat, 25 May 2024 10:09:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 23 May 2024 17:45:17 -0400, Gabriel Krisman Bertazi wrote:
> Commit 19a63c402170 ("io_uring/rsrc: keep one global dummy_ubuf")
> replaced it with a global static object but this stayed behind.
> 
> 

Applied, thanks!

[1/1] io_uring: Drop per-ctx dummy_ubuf
      commit: 9cbce593462f0839a321f8150e8a868f5c0d7985

Best regards,
-- 
Jens Axboe




