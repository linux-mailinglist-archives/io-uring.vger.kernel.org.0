Return-Path: <io-uring+bounces-8452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07329AE47D0
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 17:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB41117CC4B
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 15:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C1A26D4F9;
	Mon, 23 Jun 2025 15:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P7wf07CI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A7F24BC09
	for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 15:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750690885; cv=none; b=NolOKrUkLywKbLZuC/mlUxYP6sYWziXadaW1PL+mNC/hbed13z+C6tTBAEW4+pV2e7BNeKCSTJoFqwKuzeuQYesBShkrwliNKrSs/5c+wweAzxL6L32kUU6TUH0R9Nq1rExrJss+OpmXTNle/Oo3pAMzngF2d62XUUJY6xTDthc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750690885; c=relaxed/simple;
	bh=oWGurdLLaATQUzuTwWzIpzQUAFQvFzDZgQR1mTaU0w8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cntGOER0Dy26cV9az9iWA4Ax2wYoRPFG5JRUiGXhMDzLOr6oxmi9xWWg0j1T0jQK4nCTJt6jf6uUSGoeKdNPozBxDTGXui9NJL+CkVaqIPnuRm+VSZbZAWPZ9vaGbRkpzWdR3yaQhNgmXLTYbzcF9cqJTV/G6ivtUMRnVeKiz8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P7wf07CI; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-235ea292956so45194945ad.1
        for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 08:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750690883; x=1751295683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e12FTwFtz4sV1UkZylA7otkUya2j0xykUDCjLjiczB0=;
        b=P7wf07CIcMAtYSPpO2nnQqKV5DX0b/0kgKOD5nkhmRMt7QV8iADHNUzt442kKaMj3n
         q/bqkud80N4RPzOnpcvdXCxpmEbvhJmBcsBXsWx7oEYmtv8s4SRdmK+3VvAG1YYyf3Wf
         ztIdqx+gBQ8xqJq/cUIWeBe74tTcn/LXrxYPUSLG6yyPKMIgKEUPKkP2WQY5m6pHu/5y
         dl4IQzHQQZ3DiRGb8Bp1krXJ/XRhX0muwjy/uVyXp8aLSy5hKlNor2E3wlPAvV6szyC6
         A7mVCZIV3GoRlRYKn55InUBUWC3YSNwMHCNuW/ScrRCFo/01fC5zgLfVQxuPl59IBMOp
         iVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750690883; x=1751295683;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e12FTwFtz4sV1UkZylA7otkUya2j0xykUDCjLjiczB0=;
        b=VVBOaTHmyDJ9FoqYvKjep+0+6doMWaCnPAbiNgW/zNuqQw4jos3xyaMRlM5hVjOllP
         AV/pkyPCEhmlCIGTEyLSwj0bVU/toFaHsua0ANmrJMvGhih9I6vd+eEJDax+9P0d+/Ha
         xpskvYBmmp2+JFZc11zBvNAJN/qkA4I0eD9D+wDwwAd07pfwTWtGKcZ05o8XJG4bBrqc
         pSWah5ACnFuj7L8/3FnOC9tQmu/Sma6FNUeVXWCsG2SriNDNXfkYA3E+PXeHX97vFhVJ
         IeFjW323LjfTEDvuK275VU1FxOJQreIEzl9nCW3ofrca2Czos+5r/xoRwCvUKo8i2Wey
         lvgQ==
X-Gm-Message-State: AOJu0YyajdXCshOwLLMATLrVy7dvtCYf+1X/hfO8H2pU6s2WCGUP29QG
	vxkR40yNSSJhb1ycQd9nhvwaL409VEagFe1SkExd4TGyJWTuAXyOFwpeRLFFr0f+YKQ=
X-Gm-Gg: ASbGncuSoD4nR4yvU3ud83wyJ/0GFeJHHIyF/E5I6g3dcQnK+JrJkTgSbv+tVgIwvjt
	vS+VRe/ZVpTtLRVD2OdsXYBXlbCbTDJNMry06nbmwVwMgkpZwNOfkc5UEYgn0Cdliaww/3l7Gt7
	nJWSxpHkkBNNoN3WXLo+44Vk/tB3J7PciI1q7agFaPgLzW9rJ9Yt6uwUMWOjQpwIovcynubmDyH
	opY1oqW0WGepZNH5/8QVbi9DYzgBwOA87lRF66w8mucsUOQ9JIagBH+1sNBFuKbkkYtPKGNney+
	PEJyIt/300PxeGSuAh26xzyCMfgxaGJKMj+23jUrNIE3gmBSi5uDJg==
X-Google-Smtp-Source: AGHT+IGi8tgAngjx8JCTmimwDLIle5eZHSxrUUJ6vtXCGMkHWEBUYNEJ+ETEzVSa87f+OYzrXIsSpQ==
X-Received: by 2002:a17:903:1988:b0:234:ed31:fc96 with SMTP id d9443c01a7336-237d9954d67mr198312765ad.26.1750690883317;
        Mon, 23 Jun 2025 08:01:23 -0700 (PDT)
Received: from [127.0.0.1] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d873b5d2sm86886405ad.246.2025.06.23.08.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 08:01:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
 Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, 
 Jason Xing <kerneljasonxing@gmail.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>
In-Reply-To: <cover.1750065793.git.asml.silence@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH v5 0/5] io_uring cmd for tx timestamps
Message-Id: <175069088204.49729.7974627770604664371.b4-ty@kernel.dk>
Date: Mon, 23 Jun 2025 09:01:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Mon, 16 Jun 2025 10:46:24 +0100, Pavel Begunkov wrote:
> Vadim Fedorenko suggested to add an alternative API for receiving
> tx timestamps through io_uring. The series introduces io_uring socket
> cmd for fetching tx timestamps, which is a polled multishot request,
> i.e. internally polling the socket for POLLERR and posts timestamps
> when they're arrives. For the API description see Patch 5.
> 
> It reuses existing timestamp infra and takes them from the socket's
> error queue. For networking people the important parts are Patch 1,
> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
> 
> [...]

Applied, thanks!

[2/5] io_uring/poll: introduce io_arm_apoll()
      commit: 162151889267089bb920609830c35f9272087c3f
[3/5] io_uring/cmd: allow multishot polled commands
      commit: b95575495948a81ac9b0110aa721ea061dd850d9
[4/5] io_uring: add mshot helper for posting CQE32
      commit: ac479eac22e81c0ff56c6bdb93fad787015149cc
[5/5] io_uring/netcmd: add tx timestamping cmd support
      commit: 9e4ed359b8efad0e8ad4510d8ad22bf0b060526a

Best regards,
-- 
Jens Axboe




