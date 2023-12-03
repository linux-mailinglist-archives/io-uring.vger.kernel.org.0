Return-Path: <io-uring+bounces-209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 57DD580251E
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 16:22:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D64F6B209CB
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 15:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E843156D0;
	Sun,  3 Dec 2023 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BbGlJ4T0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F405BC2
	for <io-uring@vger.kernel.org>; Sun,  3 Dec 2023 07:22:19 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1cc13149621so11059475ad.1
        for <io-uring@vger.kernel.org>; Sun, 03 Dec 2023 07:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701616939; x=1702221739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ltqu6n8l3WKocwM/M0wD3YTMb2P/CPKoS1bfRX1uIE=;
        b=BbGlJ4T0uWYmGZiyt2NbcsXZTmTe242qzmDAi+Dmia/4Kjp/hY1jossHPR4/A6Kx5t
         imCrKXIJe2L+9P+aQdE+KQaL1WZRZm1bmFTPRe2P5JCC5vZ0Qz9TBhsZLA0rjEepxFXQ
         aqVZMHgZonE0pNBg2c+0Z/oZoeUxHIZO2fxE+jUL3/yDRbBugfFON2RQbjtNLckePWSr
         qHFUvRHij6VHIJAS+tUEh/x/pewr0T1FS0n49PBIlu4GimEn83zjA7jwY/LNr9G1b+Du
         pYn0vP7xJc2jTHwOH5obcRr73rwNyNTJk2ApGmQQOEGSGlx2AJ3qZbN7WTpr2Nf1Brp4
         CZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701616939; x=1702221739;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ltqu6n8l3WKocwM/M0wD3YTMb2P/CPKoS1bfRX1uIE=;
        b=DmgxJ5G6LH0zQ2TRQba3X6UFKwUKvfa08fCXMZ6z5OSZ2rTb0117Mj5iuzIBHAxz7r
         CM/ahhVFExXKsLc1nPy68T3udACRS+X+Q7sFl7X6gBadhxshgEEiau3dELIycg1bTr4j
         QrLRIUuMhyouLKEUOrrSDIJMk24DFhVJ94vyqhuR3JNTKE8efGN/ZoN+4euEvyAdS0SQ
         Lh79J/6zaUK3ems1HHZQBsUfJClF8W/zDhMtUR0/Cj0EsP5+firdmzdX3Ylipx679Lfm
         miTLArVLAC7vIoGVZM9xIhfKxz7dZ9VXSePqX5403ck8Yt3GArKEfaR2RdjCbqufy59A
         jeDw==
X-Gm-Message-State: AOJu0Yx4XwE961STvMgxPbwBepdiF6EtZxjZomtQb80AdRdZuHxWdAi6
	dmkJNfIjhqsUUCU8AQ4vZvnXsovyFIbcKX67Emn+Rg==
X-Google-Smtp-Source: AGHT+IEwwV+kBEUAgRzMQkvMgSmCcTKyF90e5ihnzUw7hjWwimHNDyfV+eKgDqmIT90RRqiMf8MX+g==
X-Received: by 2002:a17:902:d4cb:b0:1cf:70a2:c26d with SMTP id o11-20020a170902d4cb00b001cf70a2c26dmr36246968plg.5.1701616938968;
        Sun, 03 Dec 2023 07:22:18 -0800 (PST)
Received: from [127.0.0.1] (50-255-6-74-static.hfc.comcastbusiness.net. [50.255.6.74])
        by smtp.gmail.com with ESMTPSA id s24-20020a170902b19800b001d08dc3913fsm1196389plr.115.2023.12.03.07.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 07:22:18 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1701390926.git.asml.silence@gmail.com>
References: <cover.1701390926.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/2] inline execution ltimeout optimisation
Message-Id: <170161693776.938596.9769381596057904599.b4-ty@kernel.dk>
Date: Sun, 03 Dec 2023 08:22:17 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Fri, 01 Dec 2023 00:38:51 +0000, Pavel Begunkov wrote:
> Patches are not related but put touch adjacent lines. First we improve
> a little bit on post issue iopoll checks, and then return back a long
> lost linked timeout optimisation.
> 
> Pavel Begunkov (2):
>   io_uring: don't check iopoll if request completes
>   io_uring: optimise ltimeout for inline execution
> 
> [...]

Applied, thanks!

[1/2] io_uring: don't check iopoll if request completes
      (no commit info)
[2/2] io_uring: optimise ltimeout for inline execution
      (no commit info)

Best regards,
-- 
Jens Axboe




