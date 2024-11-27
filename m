Return-Path: <io-uring+bounces-5103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F4B9DAF29
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 23:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78CD9281E9B
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 22:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F9A155759;
	Wed, 27 Nov 2024 22:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="c8ECDbTb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943C7146019
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 22:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732745130; cv=none; b=ghGZGnUDg8TxygWtTEWrQwE2ihMmTahs2Y0CRC8ISqDrLLyz+fG9YuYzo07YF802419uv7emTze+AFD3vqM3g37SQjrv4IRw3OigPoanPTrezIp/iGWzcxr3b0XtO2Wqi9jtSjb1vFdP+D3wNl2538B83O3T+SeNnrlfMcuqODI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732745130; c=relaxed/simple;
	bh=zckSI3nJLvAJ2cxUViEKRz49tpP+dL1arcyZt3aLByA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jwUM2dOwEOLOM3tj0kFrz94nwQKYrmkmxJv+C5qPgD2Oxzv2tYDMxka+m5v3rOY/5rxeOZgTJ5ZEtJTL23Yom9bwX7iZZ99Zxzrz7d0mA0WmpzAdQAzI0Wmu0pYEuc+/ugSGqntLEgZ77nBFP9My7kBpdbkJUKtgXcIarCMWFmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=c8ECDbTb; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-29645a83b1bso159610fac.1
        for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 14:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732745127; x=1733349927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pkgl9dM9ZcrQO1Ad3xdmjaikhbCFD4aH3LV3ooKMgTQ=;
        b=c8ECDbTbs4wCZjyPRkH/n2gnKdtn4g1JKFalng05gpH7aVFDHbqaD+8MSbryKw7kO0
         qYWQrdq+S6OUiwZwzIPIDunMKXrkGWcP8BujnwD735kUU6iBEX9b1ijMvEysKvwlJEMT
         GFqj/WwSXeU36pczswAKi7dC92n4cuiyyd1T62uZWm6TmzHVCkTcp765P6AbkUICznbO
         P75y2UecBECh138c4Q1pPgw0v6NLWxRjCaDBxpmrAYLfOhhwiMVz3UlKFZEUMrYDE/R7
         B0xo7NtQIlMe3sVW7cjKhQV4i6o600ON8B8wbw8JGdKANM9qU3aPcmPQu5shFUVYT4hn
         q1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732745127; x=1733349927;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pkgl9dM9ZcrQO1Ad3xdmjaikhbCFD4aH3LV3ooKMgTQ=;
        b=pDfPW/AA2vzU83NFWLA6yDbT3I9m1EdcbBg3jNA/MDnosjHbhoRqNDK1B1r7pqQRUd
         wx4U2HWvzvsX1azwO0Z9VQOXjWKr2xVj3q6n5+WtJy8MPmkjW7sSiftdHahAQfoDw5GM
         xr5fLWCEjmBLMXeA/LXOoj/1MACw8htLrnQX9+fGTnX7cqUZvkQw/Qn6ZNjxDI3I23V+
         L8BnL2WDcNuLyC6F6qAuemXbNZLT4tttE8PWyKeovHrbiwx8fBG4GMgnDvYm5Vo6W1X/
         S/rSPnjQ65nSN1YmhTWVKfTfQ8cEbTPfvj6W82V7M9leY69TjsaKmDdK6YMd/KmgzLlD
         Yc6g==
X-Gm-Message-State: AOJu0Yx2qEEWjFAsnWjjuDeIKrnsNMnMuEWhbBU67rddTI4gKtZC1Z3N
	UtG7xPtCVnlnv9C9HIgFnIbm+XxBaOjF5p+oToAjJcsxVOZsIrYS6nl/4C4f4lCmPajEHjOrma6
	IvD4=
X-Gm-Gg: ASbGncv2VdB/TGxhqDV636GGaYoPunKrk1DoL2GO2qiwnCP4UsQqSPgjIeAnjRQpy03
	QNuzv6kUNIaEHlEsFsyoN3PKQ7ySihfRplxZug7GAVbpT8EGg8cVuw7RA8y5OXraSTXQmE8+um3
	n1+i4L52+wUCWXbQTwBxk3P61OAhLCnNvYEt90FQttUEVlc0Y6IbZARKHBVep4OcSPXVe/hvxED
	Avj5Q/dR4fwDC3PaXX1WC0lqQ1t6VUBRLx9IRRM
X-Google-Smtp-Source: AGHT+IHC/mpdDFXYPF1/tm4uSgD9KD80ZsylVfa/X8ADzu5V/dPeksJH9VXVfEx7EebQFXIa9WPlPg==
X-Received: by 2002:a05:6871:8790:b0:295:eb68:fad9 with SMTP id 586e51a60fabf-29dc42f5d98mr4126234fac.26.1732745127745;
        Wed, 27 Nov 2024 14:05:27 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29de92d8246sm49660fac.25.2024.11.27.14.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 14:05:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <477e75a3907a2fe83249e49c0a92cd480b2c60e0.1732569842.git.asml.silence@gmail.com>
References: <477e75a3907a2fe83249e49c0a92cd480b2c60e0.1732569842.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix corner case forgetting to vunmap
Message-Id: <173274512676.579859.5626643774955881812.b4-ty@kernel.dk>
Date: Wed, 27 Nov 2024 15:05:26 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 25 Nov 2024 23:10:31 +0000, Pavel Begunkov wrote:
> io_pages_unmap() is a bit tricky in trying to figure whether the pages
> were previously vmap'ed or not. In particular If there is juts one page
> it belives there is no need to vunmap. Paired io_pages_map(), however,
> could've failed io_mem_alloc_compound() and attempted to
> io_mem_alloc_single(), which does vmap, and that leads to unpaired vmap.
> 
> The solution is to fail if io_mem_alloc_compound() can't allocate a
> single page. That's the easiest way to deal with it, and those two
> functions are getting removed soon, so no need to overcomplicate it.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix corner case forgetting to vunmap
      commit: 43eef70e7e2ac74e7767731dd806720c7fb5e010

Best regards,
-- 
Jens Axboe




