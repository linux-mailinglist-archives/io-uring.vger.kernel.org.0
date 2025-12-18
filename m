Return-Path: <io-uring+bounces-11215-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BFE2CCC5E4
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 16:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AE58E301EFCA
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 15:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E00280023;
	Thu, 18 Dec 2025 15:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GGRmRRuW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977A32C11F8
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 15:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766070087; cv=none; b=u0P8g97g5334CjK61PtGeE08879JdOQ9N5u8IOH80UdqjfTxxtVdUU/6nWtXDjmiJ8t3TgTyETDVsps4vP7N3li3VUi91vaC9SAEB3XdhQSPocefEbOQCM1GkhLE1BoV03ITEZ7zpY2iR222kdFdWN6hi63Mfk6azx+6piN5g8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766070087; c=relaxed/simple;
	bh=UFajhxek2FNDn9Py95rY2lNwEb+8A9xZgGln14cBtpM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f/d03MqPkiBrzNGfmJbbpD5FjYgTjFKwq9S2cVAQgJtpfDZLRGZwWyhSGQh1JjNXvjgBFKlv6msnCSIZomRFpBBQIefcVst6InrmtRHyTCjGMupVMtL8ySoi9ndobET1krZfP1g7BQWoqtZDJfo6eGLXfCGxuej1ubQu0WiIeOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GGRmRRuW; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-455bef556a8so460795b6e.1
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 07:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766070083; x=1766674883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nm9mnCL012TbnBQutLbQjHaN0bwArPqs3Yh4LZgZGB0=;
        b=GGRmRRuWt1uCnvw3sfYi2r5DHnq3xWxNDXMNJrBshCu1Itn7YQ9KSBB1NCd0xieRLK
         /aOtfEdlHUb20UmzI3jf4hlFObWZ0CApjrDy3lgTzUmIgfufDtSq5x4Jmp35Lk1rtgxc
         r8anUf0UR4L4GEuJ9xRbVSav9pFNJsJ/v+vQZNHd9M9r5kgfoxqNDPxSy2bm8gTdIHWw
         93D4cZRCuZ7Kp8wVYQ+yPr/bZJeDYD9DPeJJcCl1ShE+dAQ6BSTljm2iWq2JQyiS6bXr
         T31HqMOVlGUTgWV77VYNS4gI6BEMQufrh7LmpvR4NQ5+grTuHkwTXRB9v7QCmwiXYfKp
         JXzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766070083; x=1766674883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nm9mnCL012TbnBQutLbQjHaN0bwArPqs3Yh4LZgZGB0=;
        b=g7FLqgWXI+YoXTiAW7083t2qhbCbmUeGMdlIAdCAamYdVZPUMkgXw8sDUzxoVujSQ8
         dp9XvJEl5M+dGbBQJ3/3BgPZmp/tU+l8LjpKN0sb9FQqGRipIEmU6mgeKH5+64jfWzz7
         BR6IZH36SL8G0wFMsqJ8PuA+jDepuiYqe6Jxu4uwTJz3vQQjyqt1bCniwi8To8bMOmSy
         VvgtNKjuNiGzA81zoHDcshwlT7LGTbadph24xuafEQ1D3Prt9K3w/YAD6qvS8lqAyvMv
         hmi/Md9mV0QedR7NEkbef800LirP0U6qYMq4z9c4cIBLYmzhM0DMDvIZdgNBH5tk2Erg
         uzVw==
X-Gm-Message-State: AOJu0YxpP4kKepkw2m6xvLFldfIbhpoHcDdvvrjp7l2Pbbq/89sP45x+
	Rq5VnW6Feu9ups2/MyN1uYTZLfoDN8gzJci4eij7K7XpPECxFMQlUGlCHXsgoKVbRUM=
X-Gm-Gg: AY/fxX5vyEmBT8YirTJiLp1nzsTodKZ6xuHkz85MyHxpoQxpKTDtyGPXVz+gMGTFACI
	POWZrpv2aXv243GPr3ZSgE2qRNfA2vm5TgtWdlu4bdovC2hHLNrHfxGz49Gzgha8RsWKW2OeHFb
	eaHn08Ioyc20wRbEiHl9jkkf99RmjIrhJA/OA5pKywVWPV25S0KUxw2nfpNwrplhhd4+EjRQyNh
	43ZsJtS/5S0Q9D/ADqkdFyzNVEwRbXRqm9ML3KVtVL+3qovIPCLwCUEaAr/gOD2hmUCQyE5TDnB
	GGgeAZ4jGD5FCBhYJduRWxNxjKF1x058I2ELYQyWamZaVwP+PVQJNryDBbHEJ4otJaF1ebiXKGy
	qb2h2169LqR1PgfAKCSA5WSSL5Vohh8WY7cCcSJ8jbZ2BxUWnoBoM2Q5GbYuf826n6jb37A==
X-Google-Smtp-Source: AGHT+IHaxVcFzsenzhTzxazrs7CmBAY32htAAoIyiiMXh/5fzHQwNh74QD3UxZLzFB8Ki+UIJ80VWg==
X-Received: by 2002:a05:6808:1706:b0:450:3823:b5ef with SMTP id 5614622812f47-455ac91d0a3mr9726287b6e.34.1766070081101;
        Thu, 18 Dec 2025 07:01:21 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-457a42fe963sm1327816b6e.1.2025.12.18.07.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:01:19 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	kuba@kernel.org,
	kuniyu@google.com,
	willemb@google.com
Subject: [PATCHSET 0/2] Fix SO_INQ for af_unix
Date: Thu, 18 Dec 2025 07:59:12 -0700
Message-ID: <20251218150114.250048-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

We ran into an issue with the recently added SO_INQ support for
unix/stream sockets. First patch fixes the unconditional posting of
cmsg for io_uring cases, which it should not do, and the second patch
fixes the condition for when to post an SO_INQ cmsg in general (which
is only for the non-error case).

Please review and apply if you're happy with them, these patches fix
a regression introduced in 6.17 and newer kernels and hence are marked
for stable as well.

 net/unix/af_unix.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
Jens Axboe


