Return-Path: <io-uring+bounces-8481-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2E57AE74F5
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 04:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7DBF19214F2
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 02:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4681CB31D;
	Wed, 25 Jun 2025 02:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P0LCfBmw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1293410942
	for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 02:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750819961; cv=none; b=qS3Xm6WKGQqLL3PfHS4NucTAObAdBoL9G5DaCWd1Ubd1ItGwzkujWherNH6LDCAM+yXYS/GyYiZFgV3dUTzqn/s2/HKCXwULxIRhad8yL1xxkh6OxmKo/PCCzIAecN2VosUBLrJq8YLijN2ckCBByr/YDC6LYt6n7TSs03Vme8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750819961; c=relaxed/simple;
	bh=YdVZpyBTlnioe8VxnxVEcEY51rdDUymBtW2535ntmlo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=g9alOlv3zs00FOp9hLOnnNLcZwcjaYHLlu+fxBP99NLSbnKlb5++YtKmpF7c2x8O4uNa4FX6GayalGYfqEzurM6A3LQ9j97KvMNNk9leLvX8iCWiKsbqthfSfeVvXdYswxuRNeQeOocVBcvWdBDKdV7Ko3venq13Ccj+V4FsmBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P0LCfBmw; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b321bd36a41so2412564a12.2
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 19:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750819958; x=1751424758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dxITXr537i4MuNBal19cgrYAhT33xMINYxtPeGdumTU=;
        b=P0LCfBmw7OB3wUKF860imndITrX7FZHntbUuwSPkj6XI+1zLSxU6rl/0PglU/IX1HV
         FKzvc7TKGs1Do7o0IqvS5H/9kc8d8+Y0hljOfyDeRoizz8lQgE7VRnhDc9FUi1ew6lR/
         djQCdPPKoXupurkvfMkjscMZ0hdsJgrfhpV68vjNMG79xxQ1lEkbf+4pCCM1E8cjBk56
         kPci4KxnpilVAcgN0gip9zsTTP68sm/TaWepDOmWgPWPIc97r043LGKm8izufN5qzZNi
         fCi1e97gAK+zg7zAnonZF8RU1aO/5sYeS6soc0rZfUwE/17R6LFms9k+bFzlHDgZLayI
         60KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750819958; x=1751424758;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dxITXr537i4MuNBal19cgrYAhT33xMINYxtPeGdumTU=;
        b=mCl4c2A0H2A6yalimFNoZQ2qIvi3vnHJmqMED1d7BdtdaeeMIENky025IV3g79obTJ
         5O4Xgm5F9msGE9v0WwsPnPgF23BBJBENMY145cWynyVbIVDrtmUh7IA8qaB0eh4FYMJE
         ekbY/vffMAR2S9J4esCzBQ6ygar8ieMqY1kd0EeuRqQDeTGViAFxyvj2gp8lMuLAMxj5
         c5MjhIleAAwduYTS2JF2B3Al7l71ZAGNc/kUBBzNnMk8rdzI+tMQRo8SDNITHXR9uWZv
         bv/ywMP3QOYR1uYMkyPm+/rsXVdt/a2gnxHuKX7sG5+dQzpJN/y3PisuJaJyqGTDqr4f
         D2Bg==
X-Gm-Message-State: AOJu0YyxxFx+WVtqhZnSB3dldhMzhs3nblDIRluEsU+9mJzTy45V9/YJ
	cFvN2Md0FOWEt8ZujJ7zZYaqYqoFacCKiTRqyhtWHLBFyOEZm+3bhbpXwyFOdJOQcbbyqXXkb9m
	pSt8k
X-Gm-Gg: ASbGnctAI6aqdnN5ZOF65CbA1Q6+rwfFi8XJOQvVrdsGiITObp7WzuvmPRHfcjYOA1b
	1zBohuSdbbSZCK6DKI4E1UjC4BQVkH74DZSNhX1IA8uhJglw/UxTVQ7fT9mrphczF3UInPTIvqq
	B8qrJ1XgPdn7tMX24MChkgKxGkULaDtxQdosrFAK3kV0gEv2TG22l+aAc8xTYhu8PZYnHzARPfv
	ZJTDHYgZXcx7NMgjIcDrJSqlhBb8EPFwXFLM4LlfONya2MevFHbBdmOUFo4OH/A8UpH3vvkZCc+
	OZbBBs8ezngxpdzdLUIxEF0EZszPYdrg+/tDiVvyRX8v5mAySOckmg==
X-Google-Smtp-Source: AGHT+IFx54pa/n6P3o/R/xSVvVbzy3O1GcZ77PVFhLSM4m5XhmMWsEveO9rtalALvwI82u7kDfuYQw==
X-Received: by 2002:a17:90b:2709:b0:311:ff02:3fcc with SMTP id 98e67ed59e1d1-315f26265a6mr1970007a91.14.1750819958498;
        Tue, 24 Jun 2025 19:52:38 -0700 (PDT)
Received: from [127.0.0.1] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315f542e494sm462185a91.31.2025.06.24.19.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 19:52:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
In-Reply-To: <cover.1750771718.git.asml.silence@gmail.com>
References: <cover.1750771718.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/3] io_uring mm related abuses
Message-Id: <175081995765.91233.6216131995218316037.b4-ty@kernel.dk>
Date: Tue, 24 Jun 2025 20:52:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Tue, 24 Jun 2025 14:40:32 +0100, Pavel Begunkov wrote:
> Patch 1 uses unpin_user_folio instead of the page variant.
> Patches 2-3 make sure io_uring doesn't make any assumptions
> about user pointer alignments.
> 
> v2: change patch 1 tags
>     use folio_page_idx()
> 
> [...]

Applied, thanks!

[1/3] io_uring/rsrc: fix folio unpinning
      commit: 5afb4bf9fc62d828647647ec31745083637132e4
[2/3] io_uring/rsrc: don't rely on user vaddr alignment
      commit: 3a3c6d61577dbb23c09df3e21f6f9eda1ecd634b
[3/3] io_uring: don't assume uaddr alignment in io_vec_fill_bvec
      commit: e1d7727b73a1f78035316ac35ee184d477059f0b

Best regards,
-- 
Jens Axboe




