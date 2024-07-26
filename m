Return-Path: <io-uring+bounces-2589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 608CB93D5F6
	for <lists+io-uring@lfdr.de>; Fri, 26 Jul 2024 17:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0176B21B3C
	for <lists+io-uring@lfdr.de>; Fri, 26 Jul 2024 15:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F7317BB31;
	Fri, 26 Jul 2024 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LlmZeWHJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF1517BB24
	for <io-uring@vger.kernel.org>; Fri, 26 Jul 2024 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722007271; cv=none; b=Rb9WNAihbGjS5JaQT4PfOBlmdEEv0Rng+r5p54A9QFmfMCpX7YZuWvl+eNe97DQ9/dEWk189nq5ri/BW6AWQdJOm63jY8M2YbTL2F9FSgrSweUsJcNof5ie8aFGRRkrLQcGrzLZdX+/Hyn+n4c3WIDcr2Xy5srqHZOyZKmSsXKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722007271; c=relaxed/simple;
	bh=RO9xCRPCB1SabkSeHWvk1bP7L6CKd4bJUMeCII8ldZI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pYVZArH/zqYdF1s+2hb378E3mEXpGdXttCl5rKNRPA+3ROLfHa4ru6T0IbZF218f9lQOhH+w1cUZNLvSKxbjsyhkbVNhBKJKImExlppgxuI68EuCfwQny8SYc5WdNB5HwqsSTrv0Du3qSIQZvTd7YNYSRI94rVcCjpl3uWysr4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LlmZeWHJ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fd8f92d805so247835ad.0
        for <io-uring@vger.kernel.org>; Fri, 26 Jul 2024 08:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722007267; x=1722612067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=up9z6YrpcF4MMmbwI3I9ZnJkzDjEN/pOTrn87uP0KZw=;
        b=LlmZeWHJVjfnW6K/tcxGvc5T+9LyOwUwUo/Qo4qgHHWsO02Z+M8lMXGcHrDncOb/sJ
         ZMz47bHBrEUeXkP6t9FUiSAa+euuCcBSCqMEFA68AFnjnADi6YvIbQ+7W3RISdBcig52
         NQnfaJMBV1Nn8MmmrIfjeAzkRuMpo4alLKTISTmYjghYZLOnVSBE3wmfS4gvJgs/rDh5
         ukdXnF4lbAr6IhCc7aLUDDdl4sPvy3plZoWCz6uebVWZN+f884arJYxHcduJSf+LEjSI
         T381qIS+ivQZl0/dGH/qAQbggLQiTgaBM+1o1x3YPGlEV5Cei9GBeMu4rm1Kr4eGWop8
         DnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722007267; x=1722612067;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=up9z6YrpcF4MMmbwI3I9ZnJkzDjEN/pOTrn87uP0KZw=;
        b=mSfCEwUx0JoiWkAM+EzFI0zcWb7jTiZnEHhWqxSNzzj02oedmHpH/0I+6HppRP989N
         7kKaK0S4dFTDXRhwiTK8Xf1kmi0M3Zk58dG1vKJ/EK+42vc6RELEvbnujl3KV3XcKd/j
         fyGm9K16NL/acu2viFxcKxP1mVH8DSqczn1BGdSod2yXs0jJR566RA8Z03FjYRUBnFtF
         P3a3JD3JDLVGJDgZf1+T14hw8nr0abvQ8TbIehr4tyYDyv0XD2h7CgeU+IRguQD61+DO
         /U/EHDnxMDNVbCu6N/t+mm/PRabQxmeEOMXBrgGG3/ub+jYptPak8377mP+iVbuffh32
         hl4Q==
X-Gm-Message-State: AOJu0YzHnU68x6WQ3dh5BB7W7Bqkx+H4cHi65GrBSbNxxdDHgcp6yNXH
	gQXt2y0y3iz27CVDfgkClVyA80CiS0y1mLn16A5jshMfwLlIQFI/rT6qc43c4GFe+Jlylzys1KH
	A
X-Google-Smtp-Source: AGHT+IHtdJp09/kwCHcRTS94v+5UbT3TORDJTlaLs7Mrm8Id2SW7f6yZVIPeK4jp6NJbrDMLs/2t0A==
X-Received: by 2002:a17:902:fa86:b0:1fb:1d7:5a89 with SMTP id d9443c01a7336-1fed6c5f9a7mr39346115ad.5.1722007266979;
        Fri, 26 Jul 2024 08:21:06 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee3f68sm33811755ad.171.2024.07.26.08.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 08:21:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1722003776.git.asml.silence@gmail.com>
References: <cover.1722003776.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] improve net busy polling time conversion
Message-Id: <172200726622.221426.14352754139341862116.b4-ty@kernel.dk>
Date: Fri, 26 Jul 2024 09:21:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Fri, 26 Jul 2024 15:24:29 +0100, Pavel Begunkov wrote:
> Time conversions in io_uring/napi.* is a mess, clean it up, get rid of
> intermediate conversions to timespec and keep everything as ktime.
> Better than before, but still can use some extra changes in net/.
> 
> Pavel Begunkov (2):
>   io_uring/napi: use ktime in busy polling
>   io_uring/napi: pass ktime to io_napi_adjust_timeout
> 
> [...]

Applied, thanks!

[1/2] io_uring/napi: use ktime in busy polling
      commit: 342b2e395d5f34c9f111a818556e617939f83a8c
[2/2] io_uring/napi: pass ktime to io_napi_adjust_timeout
      commit: 358169617602f6f71b31e5c9532a09b95a34b043

Best regards,
-- 
Jens Axboe




