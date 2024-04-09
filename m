Return-Path: <io-uring+bounces-1480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0FE689E4B9
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 23:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 371A51C218A7
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 21:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E40158868;
	Tue,  9 Apr 2024 21:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="24A2Fepq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB3A158863
	for <io-uring@vger.kernel.org>; Tue,  9 Apr 2024 21:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712696460; cv=none; b=lZJO917VRdBcT6w/M0EMsDp4Y+/Ww1WEPuwTv6hpJKUH9rD8RG+LBW0a2EcCdPR5Dk81GUvdBqmYisw5TZB4R8ZfEZTxiwZoSi72IwCsUvDIGWxnmsjQKF1U1vxfCX7d8a2uanEK6Mk5fq0gn4uD/NXXhXrq5Uh0P5o1Kz9uxJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712696460; c=relaxed/simple;
	bh=d5n1Nx1fa4kaN4tn/G0rTgx2GHxjm7KEqpPsFZNRVuo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Vzhu4hIBfIhEq2FSY1WB40WSgrG9V+jtplg2gHZsEKdjrukEutyQqPSXH71uKEd1iXXTjN9DqiidSvIDZca55i1yPxjw0+2qoCJnky133ec4GoAVfzNaKseXl+rL2g+MKjkvGr1LQuhWe77WxHl8U4B4k0GQJ6P8c98FCsMsTI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=24A2Fepq; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ecee443c79so780118b3a.0
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 14:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712696458; x=1713301258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MSeblQpMmEmKAPTGb7hx+lE/X06JRWrmyfzB4eQJt78=;
        b=24A2FepqdreJAAdr4NzdLjKltxHJGXsrsciCos98jNA3jsoZKUAIiN6xo/MtU0aKPx
         GAlAjQYFjLzPKnVp3pZRQXGQ2QQ3kbNTRZM/X7cdyBCQ9wxtCfMe8/HHADAktiXt+0jq
         PkY9R1eJhll0opxKJ6zaJR/UoJSjEDLoahAldyLVeBIjUwIe10Y8HQ3cNqmuwIQJwuXx
         lefZXpAWmZ3LYicxGZV57qHWTCW5bV2J4NhoRP6vBFSB1yC0mw4Q8WSZa0nYxWZQDfwv
         aMEjggk7awr/i6rjGW5+UESb5uyLPLCZO5uKgWLvpAuOJvSRFKOesAHG225tNb0kdZF8
         oxRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712696458; x=1713301258;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSeblQpMmEmKAPTGb7hx+lE/X06JRWrmyfzB4eQJt78=;
        b=weQgSr4K7SY1BjI+wFBvSv2Scl+IGRE513ohdeHHz0FtyT6mCeEPYApGmooER/RnE5
         G2H4j1Qi3DJf1NMWIFML63M4Oa1/9PSg6rUrBvM13OsvIGPBUchERhHcXQlrNTTtvRwM
         XgPGVp6TLja7+/e/z7xUwnd8g4WqKRXGsaLzSnWaCXjq4DLAWQ3YLXznsQNX2IwXMLoG
         M8nw6YDcKxs00HTX85VEsDBpKDS0rtNz/ozhbKApINCtVdPOkG7m9a4mC9uXrTfLHLt2
         cBLVBGzq9jjA440e/K+qjVLOFPbg+oi3c0/3HZD6RP41HAN9cwkew41x01+KL3o1tXtT
         uWiQ==
X-Gm-Message-State: AOJu0Yzrlx8tN3q+eNfa8AOuMhqiUr4IUAylxKkk6ymwPmEbYMqvUC8N
	ehMTpBMK+EGe+CtmS98h1l6SDWDWJT2yw2lNfRymcY4N6NUsrpkihvvMHWzjqIkoitmo+AWDiYb
	Z
X-Google-Smtp-Source: AGHT+IFn1ZvBEGFVXFuA1Mk/F6k8FDzHVTMykwFfnyfcKEZIcQNDOO2rPEIiEfJ50TYtc/cA1pQd8w==
X-Received: by 2002:a05:6a00:8911:b0:6ec:f406:ab17 with SMTP id hw17-20020a056a00891100b006ecf406ab17mr786063pfb.0.1712696457076;
        Tue, 09 Apr 2024 14:00:57 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id e11-20020aa7980b000000b006ece5ad143esm8780219pfl.127.2024.04.09.14.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 14:00:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cc1d5d9df0576fa66ddad4420d240a98a020b267.1712596179.git.asml.silence@gmail.com>
References: <cc1d5d9df0576fa66ddad4420d240a98a020b267.1712596179.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.9] io_uring/net: restore msg_control on sendzc
 retry
Message-Id: <171269645526.133225.6025357789083970042.b4-ty@kernel.dk>
Date: Tue, 09 Apr 2024 15:00:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Mon, 08 Apr 2024 18:11:09 +0100, Pavel Begunkov wrote:
> cac9e4418f4cb ("io_uring/net: save msghdr->msg_control for retries")
> reinstatiates msg_control before every __sys_sendmsg_sock(), since the
> function can overwrite the value in msghdr. We need to do same for
> zerocopy sendmsg.
> 
> 

Applied, thanks!

[1/1] io_uring/net: restore msg_control on sendzc retry
      commit: 4fe82aedeb8a8cb09bfa60f55ab57b5c10a74ac4

Best regards,
-- 
Jens Axboe




