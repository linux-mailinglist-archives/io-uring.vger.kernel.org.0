Return-Path: <io-uring+bounces-9112-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3E3B2E4D4
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EB333B5896
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C645936CE0C;
	Wed, 20 Aug 2025 18:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="L/uDJtCq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9FE27AC32
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714056; cv=none; b=rKpdL4m9NOQpE5SBN7yCn1k5E/LwBvImqMw9gGAoc+Mzx+fYiAhJ/2a2psXEQqptvnaEVQYCNnv2UVbuz3oLkFnwP0ncECdhwWumkerWJkKTjdl55b3f1uKyKdSpW72vZeujm78JFlolUPlM3/Yo6mVXUGVFyEis5nXEdE1cYGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714056; c=relaxed/simple;
	bh=FxnhpskLZWtb7d3mreYVaRZ/S6py9BzMA9hwnYv5+8A=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KuH9LKOe/njySuxCX+hDyblYbN54Dk57B1KD3Gj4vRyBNYVvYXC8nWHo2Xi9VQvFZHdetB0xA3E4eq9CEHMgYnPGzHeoFCHDMSKIgfywSE3lAxL4SLCzddEzDxOOtpd91bagzyVnFPAxpYzVwIBQroj4CN0IgBlQ5nLPM/uxUFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=L/uDJtCq; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3e57003ee3fso631545ab.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714053; x=1756318853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uzOLLHgQjO5FpgH2MrpkC2HkSSbNnI17DtRRdKrL2OE=;
        b=L/uDJtCqwHUVfd9eKs7wbRx7MrZWwMsGYUH2KpFz8qkQuTWaqhx6Hr+lXteG94TqaY
         IY1weT5O1wfoNwkaNEZ2ADynI+ysP3K+23oMNSqPeFrdhfjC6+leaTWiYB5rSGm6y3pP
         F1tdi1tYB2pkyGIT51AWsRifgx+ZQHoSNZazSskJB+cDwL7qGbh78oqPFc0eEBN3kX9/
         Nro/MxtIE4sq8fi0/NNwo+ybzTPq1RPkPjDznfcRsSf+a9eEMbYTuhTcry5Jq2edgDJf
         LjWVyaEGsCpnO/RKvxu/7EprsgfBxOPWK38lXUkGgtCfvtC17Khc+Sl4J0zLX0Jz3M8n
         rwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714053; x=1756318853;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uzOLLHgQjO5FpgH2MrpkC2HkSSbNnI17DtRRdKrL2OE=;
        b=Hv1r9EQ0SZTL5CqqE34ky9ms2sRwSmm29ETpkYr5TFkmyVokpizQ1ClLFv2BI8/slI
         yi2P9YgsTglhh66g/Y7ubHsgxPYoh2efncbZl1lULHTE77ZEvY6rtsUalx8X3au2h2ao
         1ZJl+j5G7l5kfuXAwFIDcKgOv48AtWCN8cTOCfJoGvIDP1cGfY0wirBrHYpbVFZe1pGO
         KLIyTiJdWJHORuGBMbSl0COdVgvob3suLJ0GFUQMfRsLHEfsaTjj3FZkRFH2mNMfiVYy
         IKn7bkrDqCtklJieJyQhI6RuVL4tU3iqDH3wsbV8rT5OOgYq3dPcCWbPbQQevToWFegw
         A4WQ==
X-Gm-Message-State: AOJu0YzcHIdQQxiq0ScPjIu+bQ37kMb8qEmIotpxD1jGZerFRGw2Ko0a
	sKMrOB65bDLqJbA8rvyiZgoFoS43tSvvnBSKNSlNRYrEAbmbfedF9uNXL6/knBUjci2X8t3xq2l
	AVaQq
X-Gm-Gg: ASbGncto3E908AKPcqqyMiSz1IFd94oyUzTxtflh2KYKReOVkhu7i1gX2vkFIYZs9DQ
	Rf7ME6QlDq8eapr3jKedJJH9sAKCo+LbvUggTyNCQrXsmUf250lkaMhatLAyOol/VsfZLV+s5U3
	3AF1WEnTB0RAq8P35CVFYPK7d/jcH/aqO35XQ25dA25qtoPKv6pPZAJYOxmr4IgDmXZW9hlkJTS
	iagv0q4eAQVGeEtynIaVgQz0Vgv5pOsTkEu9ZfAypxbvtCOT4m7h89stIOEU/4N/u/X9V1m1Uwg
	/jLXDCA+TxaSDC1UCLVp4cUwoSS7q25Wtk9DsX4wkHIizktKyJLZLyRpI7zGzO5ZrMMJyObXlmT
	JO0r2Xl9aCE5idfHW7Ds128oN
X-Google-Smtp-Source: AGHT+IGMe6LeBU1CyHOYSi0MirO8a+Hieb4cbLE+kbxZd+GlTQJZH5Eo2Y3chDt+F3/SGatNdSFc/A==
X-Received: by 2002:a05:6e02:1746:b0:3e5:2df0:4b7e with SMTP id e9e14a558f8ab-3e67c9b6777mr68236675ab.7.1755714052560;
        Wed, 20 Aug 2025 11:20:52 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e58398cd34sm50335665ab.20.2025.08.20.11.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:20:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1755468077.git.asml.silence@gmail.com>
References: <cover.1755468077.git.asml.silence@gmail.com>
Subject: Re: [zcrx-next 0/2] add support for synchronous refill
Message-Id: <175571405086.442349.7150561067887044481.b4-ty@kernel.dk>
Date: Wed, 20 Aug 2025 12:20:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Sun, 17 Aug 2025 23:44:56 +0100, Pavel Begunkov wrote:
> Returning buffers via a ring is efficient but can cause problems
> when the ring doesn't have space. Add a way to return buffers
> synchronously via io_uring "register" syscall, which should serve
> as a slow fallback path.
> 
> For a full branch with all relevant dependencies see
> https://github.com/isilence/linux.git zcrx/for-next
> 
> [...]

Applied, thanks!

[1/2] io_uring/zcrx: introduce io_parse_rqe()
      commit: 55e5f6bb0ddfbb5912fec373ed99f9e02b19e3ea
[2/2] io_uring/zcrx: allow synchronous buffer return
      commit: ebbedae5b04f4f4a4d79d2d7329baab74b5a0564

Best regards,
-- 
Jens Axboe




