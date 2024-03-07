Return-Path: <io-uring+bounces-850-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25774875001
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 14:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD2A51F236D9
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 13:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433BC12C7EC;
	Thu,  7 Mar 2024 13:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oRMVTu8c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE51212C553
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709818301; cv=none; b=U9vi5rzCdBujKrysbuLB2sh8jHRdGDxl7Z8U0oXs1YZdEOv2kE3A3oA1dkOmInlPWFNGGSMPM9fY0WxgeBQuCfB97Si96tNf9fRAVIsafk+U+j/4fyBC+xivEPH3fww63FxrpamUU6nbEE/DwEXgCVmnK6o/ZumolOcbTdIV2XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709818301; c=relaxed/simple;
	bh=Kt/ZI0LJxDSGiY/2wJZwfdXFpBKRSnsnGjkeO7MfVKY=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=V45Fh5kqUk0ancEYq16BPmrPsB0b/4PoyRHVhowMUHIqGeEqpiDhJIw4RM1RkDJnc1XPT3c0Z/o9HARoCk1Lc/xYqb87wG0IvzU7RUnxHb/NFpI9C3X9U+7+upHCYP/RxQ9ijnogFoI+y2MhIDABkLCLaHYoVAKnDDeL80rSh20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oRMVTu8c; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dcfe6e26c9so2227775ad.0
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 05:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709818296; x=1710423096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IpXJeZUCgU5yCj/7nQ8IN7PysxmKpJ/nT8NFaOVBOF0=;
        b=oRMVTu8cpHOp4aiE0a8jzCk/6MTys+IM8nHQjRV6zMnRbxk1BEFmmUVWtdrKA/eTAf
         JPpINMnwS57n3OxZ+meuSMwQgEHQCKtVMITmKwZU994VpRDKNXapZ3T9ZVK6QQYzsbOz
         Pt2os2phfgWH9YNrNY/IiRm8ExnzpT9/HBTICaAmC8DKhMkE1DJ2LrGq6AgKgmme5OO8
         tWCZQfpIgV9YIKP1RxrvOGz5TunNZzdatcdmxRW8LZuX/FOdCLDpBRH1bfdj/BZyONsb
         JcrnRIOu132lzzmMZvMlczO49fV11Svpj5c61AuAHlxJmrs+jVekV5/oR0vpccJA7XH5
         lNrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709818296; x=1710423096;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IpXJeZUCgU5yCj/7nQ8IN7PysxmKpJ/nT8NFaOVBOF0=;
        b=QFvOQ2SutWFL2anrKhEUhSdhzOWGtjVIqHuAnsTfaF+tZC0YsJFIIEF2VaBaHHI0YS
         qHrMF3LVObFUS6VgAbmtpy7/Nsg0WjTSKLx7xtgRSAT9vzHT7tsT22DcEBJoJAFeg2fU
         Zgd7T0Cx4TjeVArXGQhIGKdVbEq63dkX58nu7Prkc2xbSOGWdbu33IyfLJiVihmlG/2P
         EeXj558CSAGT6Ig4OiwQ4HgcUvH91fdbBaoPsdAeczldTiblDI1xLf7GCX0fR5RDyShw
         Z3UkNEs/S+GjUJXb8o3eaLsz+JzTu3A64+Fgr1t0htovEsLzbYfX/zx5tEnbTuW/v0Eo
         LJOg==
X-Gm-Message-State: AOJu0Yy//6rwWbmQeBCJvrPAbxiW7QBKQFdPZ7NZaqNLuOV2Vbw0/FAi
	E2639lMX3PVuhZ4/sSswhCrLdHuFMNnuSXw7S+M8pCpyqAT/98A066nNaUNwjvjKrWqw8vQES/5
	J
X-Google-Smtp-Source: AGHT+IEcBNx9bn3GO0AbuRtzJMf13ph4jBTu3gCihX/Vip/JrpGxbB2HBDkPvLQe3khXjEbHBmPR1A==
X-Received: by 2002:a17:902:f551:b0:1dc:c28e:2236 with SMTP id h17-20020a170902f55100b001dcc28e2236mr2042592plf.2.1709818296413;
        Thu, 07 Mar 2024 05:31:36 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id j6-20020a170903024600b001d8d1a2e5fesm14580172plh.196.2024.03.07.05.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 05:31:35 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6fb7cba6f5366da25f4d3eb95273f062309d97fa.1709740837.git.asml.silence@gmail.com>
References: <6fb7cba6f5366da25f4d3eb95273f062309d97fa.1709740837.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix mshot read defer taskrun cqe posting
Message-Id: <170981829438.340408.14929361979032309343.b4-ty@kernel.dk>
Date: Thu, 07 Mar 2024 06:31:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 06 Mar 2024 16:02:25 +0000, Pavel Begunkov wrote:
> We can't post CQEs from io-wq with DEFER_TASKRUN set, normal completions
> are handled but aux should be explicitly disallowed by opcode handlers.
> 
> 

Applied, thanks!

[1/1] io_uring: fix mshot read defer taskrun cqe posting
      (no commit info)

Best regards,
-- 
Jens Axboe




