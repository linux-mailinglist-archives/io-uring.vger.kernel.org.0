Return-Path: <io-uring+bounces-1471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA74589D14A
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 05:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1588EB21807
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 03:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E686254BFD;
	Tue,  9 Apr 2024 03:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Mx0jKwvK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FC554BEF
	for <io-uring@vger.kernel.org>; Tue,  9 Apr 2024 03:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712634377; cv=none; b=ShORVt0gtafSe8T7qDjTFH30ZLuMdc9s/l8TRgT40E4I2tEsmBwjyNm3zNU1IcIpo/htcRKHpA7IOIr+Fak6yXv5yuTAADIyjmP9DfNbd18dYxePMoW6h0x+mMNEMAk2X/SGN00KhnfJjsd85DNz7MGuem+4vT12mnou7X3Z1Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712634377; c=relaxed/simple;
	bh=4P1b2TRJEnbsBTFXYqlaRL7mCmwPAJSlhgTKM5SvJRg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gCGVyZBuW8MrNH4fOZZNCZgc2Lu70/TBTFCryPMHFSlSGCHbJxMwo07PYDpuEjQ6LEo5Qr+Oxyyy3ZHlMKyZvHvFYwk/R7h++a9tgv2s0JorEXlkP8WeeVZNeIfzn4LdtWFOiQc2cJKBq36N9Ssogp0+LVTJxOnPEp3FP86aQEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Mx0jKwvK; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3c5f468a2faso468379b6e.1
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 20:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712634373; x=1713239173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LRH3ffgKjF66BWSM4Q+sATAJOZf0v6Bv0uynWzded7M=;
        b=Mx0jKwvKY8+6wtKx5pvNlPsG1+xClDRLLTc4cL33cSV2SD7R8CViPTSlSVtz17XcPd
         2PgtZIthWMwnbqPT92ILFIrzCQ23HxFSTElkKRROIYQRPezoWphiPX9e4Zef+bIchzOc
         SbKSFy7OOzCs6L9AakUlOOWqJ2Ge8nFLRj/Tw2vZuHpU6FxS1RRInIepchuSBvcUbHOZ
         AF5IcRcwpL/6Z8u172JA0Li24rlxKVaDnNO0yn2wAbCfzzDlQPCrgQz/fpsdNO16Xj++
         Eu0KgZ4tK3hFC5IKALVMmG21QvkRJSUD/EBpOTyMXGbsLct1bo5Iv14G1QCCgi5MYviL
         u/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712634373; x=1713239173;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LRH3ffgKjF66BWSM4Q+sATAJOZf0v6Bv0uynWzded7M=;
        b=N1h4H9C7XmQU0O7gYTcwUWiUNoZIOzckCAr9zK26YA5cUi32Lp/l7718ut3aGqCtk4
         dlel8+vNXmkioE3zNT24CQfBt4Z/9a0+XoCIjZliRAklVwr2H/CnQiwFa3zKfm7De+DK
         FtKvfPUDxTbwaKL5sfwHL61rDkSzU22tshAk6eekRvzsUMzz3as8oWbz59wh+VG36PGY
         Rrz80HzgteIUg8KVbGhY4e1d9newTpNciZpFFEDvZA7zcn+/EDBFUHhObUILqO+6iWXT
         5SxyyZUNi4pmhpBZPZuPjhKyXcPxCLYT86lOGlJcEZmCgYTpWonlehAC90h48sGZ7PJE
         mxiw==
X-Gm-Message-State: AOJu0Yxw3X74wXdBmceW6XLYNhLk3kmfri/EeqxAQib/5dC1y0hk9Yr4
	bB8Yg+SCImHCeG2Pk+Jd+qrGeCwXU2EK0o2cN3R6nEg2agFyr/eEyssDhqFiP5BpML2v+oT+kyY
	O
X-Google-Smtp-Source: AGHT+IFD/HA7vcFG2tBwffIm4erT7YfenoY3UZPYd9v6pmWHzy3a+Q82TIEbjjfRcHlEuOcbhoigbQ==
X-Received: by 2002:a05:6870:968b:b0:22e:6e96:ed41 with SMTP id o11-20020a056870968b00b0022e6e96ed41mr10906339oaq.2.1712634373522;
        Mon, 08 Apr 2024 20:46:13 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id fb39-20020a056a002da700b006ecfc3a8d6csm7307229pfb.124.2024.04.08.20.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 20:46:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <152a9e0773920d0affd675d1e75983271bcd6732.1712535205.git.asml.silence@gmail.com>
References: <152a9e0773920d0affd675d1e75983271bcd6732.1712535205.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] examples/sendzc: test background polling
Message-Id: <171263437149.2851211.2159143227133433710.b4-ty@kernel.dk>
Date: Mon, 08 Apr 2024 21:46:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Mon, 08 Apr 2024 01:14:00 +0100, Pavel Begunkov wrote:
> There are some performance effects depending on whether the sock is
> polled or not even when it never actually triggers. That applies to
> non-zerocopy as well. Add a flag to test it.
> 
> 

Applied, thanks!

[1/1] examples/sendzc: test background polling
      commit: f1dfb94bdaf1de14281030e28dd64f4d23d615a3

Best regards,
-- 
Jens Axboe




