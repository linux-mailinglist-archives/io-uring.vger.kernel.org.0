Return-Path: <io-uring+bounces-10122-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B467FBFD7E8
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 65F45563B9C
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D94861B7F4;
	Wed, 22 Oct 2025 17:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O0zjeIQ0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529062749C4
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761152666; cv=none; b=e55CDolnaXJxQUaJjW7GEzy0AR9V5EoxjdZiU1rcMZ7Boil2NTEiK65cMTV8sYP2KxAVw6Nwmu2Z+iJuWqeNfusYo8H65bm2JbNLxHJ5jUdF4xkzCQKJM0bbocsXRMSxSTVrRRG6woKkLG7EH6XZRZ6KlEBdmdkrIY+QYN8+4mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761152666; c=relaxed/simple;
	bh=nrkRa93fSCg019oCWqu1On1c9RPlmFRHWuKDM/1dW7g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q6MzRTIhuK8vSlor1Ump/cnegCzUxj8PIskKYEGAvagKwrYJFHWGmmqpfzamSl2nhC0f9wgj9PEQ/WB45V91fKVR8XED0tZZWKqaSdaGR9aFjzlzLljTQaubq9PNs2dtRCLa8a7YvV9mYN4i7Hxq98Li40vtUZ6+HZq4EL5KjFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O0zjeIQ0; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-9379a062ca8so306043139f.2
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761152664; x=1761757464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hl7SoL/Aj4d8pBeRGHrKsUFa0hwIa+5REjt6BwD/dCk=;
        b=O0zjeIQ0dku81oh+ngsZflpUbvyGb6Rvf2eo7zbKUW2hoYG0QiwnxB1pzmFr8Hvgpr
         zESo90FaBW44UBbs+lJe/YuyvzKFZoUltTY1p62fys8+YReR2O2gruqER7LXAxR/8XxA
         MKMc6z2A1jkHLzWkEb4uo8njiDjFIJ/Dt+JsohtJaOBYLe8dnGGKSDJtlJMFiqUVQw8y
         bRreAFuUwrZVxivTHe2JA4/v4+NB/1sk6HWtsuwhap3RJC1DM8lbT2mrJwZtMa7GWdLf
         vGSV5DbiPAg5LdPE67yIttnMoFyDU4uVU3114J/WloZEq5+9bQNNqbWHxbGMMJJACEh6
         YqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761152664; x=1761757464;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hl7SoL/Aj4d8pBeRGHrKsUFa0hwIa+5REjt6BwD/dCk=;
        b=kYcurjQKvuyFiE7/WZB7a2S1RCRetg94IaCtz6fR1yifQWmTREGP6ZrrDHzg4119xF
         6tzVvvGTWM0QQD6Sm7o6xxnnDjZ/6OZBvWL54XQwdeyYpVEk3NlWC5yWd4G71flPr9Mg
         riyIE3A2ZC8jJGLLX0NzMst7f9GswXdEt0d64GtLeuozHx64LuIr/RZq8fiyDaR9CzDy
         Mmo9b+oKXTsxp6om/Za4i3M1HFvkdkBzpTP3k1t8+Tt79OUkN7EG5rNY0ITabgvNEVhk
         HdLKi75khqIj4ryNbhJQjrwDO/2KsWxQa5xik3MmUr0VaqeVX+YUgXIWn9y1J5f0F24d
         5E+w==
X-Gm-Message-State: AOJu0Yy3AsbqvbND6C/Rgg6+NbPAAr4HHoT3uiqCVtZALaVvPJEb6b1V
	DPRg618kTfsaTDXYxbWM6WgQQGh2sl2tq9lclZBA33gqprgFnnqqRUt2XTENFXMPMvOcRI1ELMl
	Xwf1XNx8=
X-Gm-Gg: ASbGnctAEJAmVXVIZz4WsAaJ03LZkUFbNd2pDUc+PxeV6bIM3Yu4PCcbERtxpHWLy8H
	9Xyl1JFg0TUiW35gPWtX7LLpfs6YnCr1DWeI//co82GGAO8wg+w7gsCGYCM4lEgzkw9j+bxBDpK
	80KJsASruXNNCCReFG8ar4fXvU+iZKGHL99e639ohm+H1PiamjoCYT+MIkaj26sMyCzsSlhK7PK
	Atqs53IHIIYwHnyVQ8mVWP92JjSuzP5I6FMtDFQGcKVWh/53yuTQaMBDyQcU4w5DRSqfutR486l
	chSBMQkKH3eIDHlW1rPOd24CkUl9aa+HTYMbK3quQdaDqomLKHw4MpjYprFjWM8SJ5fzpfQiHgc
	GwQo51OLb7DWkTHhiKXPr4R5K/aEJZlBuYkkl+dqvic0M3RRvj0+gTu0UOryCE+5KCqC5HyMjSN
	y72nQ4
X-Google-Smtp-Source: AGHT+IGXexC9VUoqUJzSIRPDbNx41BXxwmxwnGdsDXOSQTbzHu1nhQPD9WTY3RHzCcFTYLNiutmfLg==
X-Received: by 2002:a05:6e02:148d:b0:42d:bb9d:5358 with SMTP id e9e14a558f8ab-430c527f7a5mr311765945ab.27.1761152659259;
        Wed, 22 Oct 2025 10:04:19 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a95fede6sm5352995173.12.2025.10.22.10.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 10:04:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: changfengnan@bytedance.com,
	xiaobing.li@samsung.com,
	lidiangang@bytedance.com,
	krisman@suse.de
Subject: [PATCHSET v2 0/2] Fix crazy CPU accounting usage for SQPOLL
Date: Wed, 22 Oct 2025 11:02:46 -0600
Message-ID: <20251022170416.116554-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Fengnan Chang reports [1] excessive CPU usage from the SQPOLL work vs
total time accounting, and that indeed does look like a problem. The
issue seems to be just eager time querying, and using essentially the
wrong interface. Patch 1 gets rid of getrusage() for this, and patch 2
attempts to be a bit smarter in how often the time needs to get
queried. Profile results in patch 2 as well.

Since v1:
- Store time in usec rather than convert between nsec and timespec64.

 io_uring/fdinfo.c |  8 +++----
 io_uring/sqpoll.c | 65 ++++++++++++++++++++++++++++++++++++++-----------------
 io_uring/sqpoll.h |  1 +
 3 files changed, 50 insertions(+), 24 deletions(-)

-- 
Jens Axboe


