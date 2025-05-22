Return-Path: <io-uring+bounces-8088-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C238AC10BB
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 18:07:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 600401C0086B
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 16:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F674299ABC;
	Thu, 22 May 2025 16:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Xn94l8CY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4BC299A89
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 16:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747930049; cv=none; b=ZT+Fn5WJMZ49nwICShFLksnZa1dGuJBCRL3tRXIkD5b70RH7byf7WlHCNk5Bo0SzkJzWjuLRatVRhFan2uvSq98hPL4vdjn9NCSv7LX8liuOx4KMUZUXeZ1RKrG+diwoxa4tCgSDdkgxFVfORCt01KVJ0V22R0lTSXw7idPLpvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747930049; c=relaxed/simple;
	bh=p/U6VOTW/azHouLmqcSjYx7qgUKFf06gfhUbHM38Ao0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=na+MI83o0TtqtfEtCMgnYkrDRxd/YJN+jCspHaHJUUlwhwgnbKkSv/fciLwyPsJuLlIdavo/EC6Q2OgJgc3GD/klBT6izMWpO5qNMDygbO7euEsImMvSu1aexc1krj7azOCDGBgstY4q6pmh+DmrHgNcGMfwEKHvcYairdjRmjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Xn94l8CY; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-86dc3482b3dso21400241.0
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 09:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747930046; x=1748534846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4x+RXCY/HLgDGiI7Cyjre7lyCRm6+YIlJTbpoVC+jZg=;
        b=Xn94l8CYVXG8G8Zd2Nk7zOQTiK70u0AvJ1ND5tCerzYCQESc8Jq9DUAOojlDIu1OLE
         BJOe23EMVNl+/uqkcHcD4NSgEVY6TulzP84W5IglEhE2NhM7BFrPfveXOR12lFQMROTI
         jlYxL8WmKBySm2lUsyROJn7nTSa/xWDuHBPYVgDcANEsWbX7DX0oWRACN7gB0qboStoI
         E6joZYLjNPmg29oylz5dtI8NoFluX689BwDnwDrMwUCMk2yCqWodF/CFRruOaO42Mczx
         4ke5NMSdP0Wbfr+p4BX8Yls0FPMt8LMA2M+kZYWeuahfsIAsD1Vmw5yI8GSn7Cj7Oh4z
         btGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747930046; x=1748534846;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4x+RXCY/HLgDGiI7Cyjre7lyCRm6+YIlJTbpoVC+jZg=;
        b=I7MqknEknogYUe6guG01nkGwj4TbSe+I161Jb5npNqa6+qyCStA1PfrcVQt6ProP+b
         +geBBV/XFlBneZWCdseSlQ/LznY0OR0MLb9EyRzRj1q5Bbfzx1kbljgtF0K2pg5gabHd
         zQbtnYr18Hh5tX1v45+o+fxj/zbwG7fwsPaYabL++ke7Vcfoo0bxAeBUe2HGsYk8clHM
         5XTLKhJvaxkw54mppIy5jjaYRxIHOqnmcIhTcM7V17fOLmYaJBBhEhXvW7/FbaH4AC/N
         bIaPBxAkzqGW+1komG6nHAHSXC/oYns9PGkAUolmhraHETp2qiU1X7sf8Ovh4E9/Oqsz
         6mMQ==
X-Gm-Message-State: AOJu0YxR37qHjqABlMazZPtOYu6MmOZyUEyEqfhe/DDO9Bk7S1lMN+1z
	sKsbwxx3bQnP2jJPjTWF3e27dzfPzZQKoFIjo3Ati48vxY8MLDxI3ejc3PNMIF7V4oQfnXKjTuU
	NdUhY
X-Gm-Gg: ASbGncu0Aq6qvDXTbCYgv8LyKPi9C6tll/7j8lFom9ZP69ZCWDjAvmZSUeU9kQW58V5
	bsCjH2tsHs1gHST+qjByWmapV/UHr7XwBpeEFVB5CWoZJl700e3MnwoU5tyd/GbPpwuC8bWfo/V
	wrpw0NftfSp6HD1sqNqqpteG9D7P6DGU9Nz1cbK40CkaiqqtQ4xCwdv411wuV4VVUKGyW8SRl2P
	DPdBeU6alTHCtBSJHeRkKbWK6Dx1HRGbGLLFJYZ6j9poqU3fVdJKUgSB9lEZnxNfWzxWaQfDD/P
	yTRbNz+XhYLwk8yMwQXoomCKzjFLFBmBmT7+brveEUDCF+LaJR9o
X-Google-Smtp-Source: AGHT+IGhru2oNP+5EeA6gOqBJxKKM+1jVuKrNy0BtG35es6msNt6tc+Vg7xZvUnt+T7GWNDan14YSQ==
X-Received: by 2002:a05:6e02:543:b0:3db:800d:6edb with SMTP id e9e14a558f8ab-3dc92bb10f4mr362435ab.2.1747930030330;
        Thu, 22 May 2025 09:07:10 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ea64bsm3148729173.139.2025.05.22.09.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 09:07:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, anuj1072538@gmail.com, asml.silence@gmail.com, 
 Anuj Gupta <anuj20.g@samsung.com>
Cc: joshi.k@samsung.com
In-Reply-To: <20250522112948.2386-1-anuj20.g@samsung.com>
References: <CGME20250522114649epcas5p26e8ab0fef3ff0d39a64345c3d63f64a2@epcas5p2.samsung.com>
 <20250522112948.2386-1-anuj20.g@samsung.com>
Subject: Re: [PATCH liburing] test/io_uring_passthrough: enhance vectored
 I/O test coverage
Message-Id: <174793002948.1177667.12828826245226088851.b4-ty@kernel.dk>
Date: Thu, 22 May 2025 10:07:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 22 May 2025 16:59:48 +0530, Anuj Gupta wrote:
> This patch improves the vectored io test coverage by ensuring that we
> exercise all three kinds of iovec imports:
> 1. Single segment iovec
> 2. Multi segment iovec, below dynamic allocation threshold
> 3. Multi segment iovec, above dynamic allocation threshold
> 
> To support this we adjust the test logic to vary iovcnt appropriately
> across submissions. For fixed vectored I/O support (case 2 and 3), we
> register a single large buffer and slice it into vecs[]. This ensures
> that all iovecs map to valid regions within the registered fixed buffer.
> Additionally buffer allocation is adjusted accordingly, while
> maintaining compatibility with existing non-vectored  tests.
> 
> [...]

Applied, thanks!

[1/1] test/io_uring_passthrough: enhance vectored I/O test coverage
      commit: 296dd55813bb91656752a91dd333825eb759b35e

Best regards,
-- 
Jens Axboe




