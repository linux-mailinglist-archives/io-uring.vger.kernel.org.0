Return-Path: <io-uring+bounces-6481-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B280EA3834F
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 13:46:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3A463A96A5
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 12:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20E921B8FE;
	Mon, 17 Feb 2025 12:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pvfESW+j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81F321ADA0
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 12:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739796372; cv=none; b=XKfV4HpcBheKjG1vb+2L2CoOWifECfMnRFkoLfFvEDpruPoboZWYtWh9yKLf41MQ7Miul1x1i6pvrodXd4vVvxV9jZkvOF3ehSIuDDkFoKR11unWEaVTF1MmUKczUWLT3hpi9AWQuZSNPkOIzbD7PjRbR6K1qYw/UbcOTzjQ8t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739796372; c=relaxed/simple;
	bh=OKyVddpfzq6J5MZuiHsnrNWTLGHm9r5FfbDv9UjwuDU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LdHp30uD1zoFF7YBz/EBC/8OzPvpRfKCTi4apI8SSGTAWX/NKaNbPS2jSFQQxSepe5iNDtZZsVxi8wxkoblodJA/4luhwQ6FALD/AWJNh0iwzNRcAHWu4mxfAGprngnX35EWLHX/nwLicgyfu9/WrPeY+sM64mKB/tYExOiSTs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pvfESW+j; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-8558a6ce0acso29870739f.3
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 04:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739796369; x=1740401169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y63/9QE/uFB5mV8manNhYs6WWs7kN5JgLdRnQ9vVGgU=;
        b=pvfESW+jSnr9Xs5HqcjPEi0NIBDh49Xvt/Zp++aT42GFP6Az0OIGxPCisqfEJW3F3d
         Dydn5UNxS9l/wyZfqqq23n/N8v9sNUaD1aZJx2NANGKZFmRO94WrCl1HkPL6ujDpt2Mm
         4tU6s3nh+0CSC/0o8dRoU1hbFnIYhQ/aS1hdfcOrjKHyv7LAdwhddCD7j5ZE9APxIybj
         PK8cc+gv7kHrRodrofQspvAXlBz7U6ngNpb5RTbMPLMxwn2CnomnAxJhxWZosAehaOEy
         THojlQmpuuk1dZdxHnr1o0FAapVShra1WuSdEijRgnNal4hMBvSVYanEz6K9qQAocr+Q
         tD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739796369; x=1740401169;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y63/9QE/uFB5mV8manNhYs6WWs7kN5JgLdRnQ9vVGgU=;
        b=nUpZ/awUBvDfMzOl+ThpE8dOHoXeR7whdj/wXLWCa+WMiJmyEgx3Fr6wMnPKrFngUL
         LREgq8dbfyGN67Rs5QEzke7GSDIxKNlyZ8yXFLQO13cO0T3l+Ytuy0Yevhnfkf7gItYL
         YpIqmnnAX/QotFi4QJ8j8nmQLz1q+BL1cMICMwODl5GvCl+KxkrOP1c1W3cnzldpAJXR
         oK/XZrLdWGwwGBn7UiNLDeUZ36GAgA8r5AiGJBzF4WnY2tYTisxB7SvgyXIB1n/Jw/RT
         U+e0PJrY9VR9fnT5eaTL1lM/PNbovdwEEgSh0vXrUm6wsf6Z0pxYkOBypjXTlfaXNY2l
         Hf7w==
X-Gm-Message-State: AOJu0Yw/mPZalfvtBYGdRlEaQMh5Rpa3sQUcU/R/HYJN2xt7CZd3pjbi
	SbSeMTzZ8IkFmHJELLkRJt/KK3QpIatbsuve6srcdIh2Knwx+O6vJv5EcpsIhmP7cBuWnGfIWDi
	H
X-Gm-Gg: ASbGncuvD7/kF30MGBNStlG+CDuDUy7LoLHVBp4Rtqo6qC35v34OEjOiaP8gO9Fgtii
	fcw4FathscWkMlf0a1yxXGjeB+dsxgEPg6/nG2EUM9jxPRWnahrGzY6PPuibEZKqZvIbnECyBX6
	zoctXJD+BlDBKK1gw3WMeLOCdB4gyE6IXahdN1FzWJx4zqsK06WdukfIeTSiiYVxTzqEiQZlXa8
	9OOab/qF4+MZt2/Vl8Mtla5aYek06aas7T/qVYDqqqtURiph/RZOwf9eJ+CeJ1KGBaL0r8UMsd4
	ChNn5HA=
X-Google-Smtp-Source: AGHT+IGEDg7u3KsXfy/iTIcoq5+KTCNmFv9bFZ1Lj3LHC6ibcTWOosE8CCxUMPtVbeSoXZYlgZ2IGA==
X-Received: by 2002:a05:6e02:3042:b0:3cf:bc71:94ee with SMTP id e9e14a558f8ab-3d2809df962mr77765605ab.14.1739796369401;
        Mon, 17 Feb 2025 04:46:09 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee81857773sm1247159173.66.2025.02.17.04.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 04:46:08 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250217022511.1150145-1-csander@purestorage.com>
References: <20250217022511.1150145-1-csander@purestorage.com>
Subject: Re: [PATCH v2 1/2] io_uring: introduce type alias for io_tw_state
Message-Id: <173979636811.644986.8851861360440313307.b4-ty@kernel.dk>
Date: Mon, 17 Feb 2025 05:46:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Sun, 16 Feb 2025 19:25:04 -0700, Caleb Sander Mateos wrote:
> In preparation for changing how io_tw_state is passed, introduce a type
> alias io_tw_token_t for struct io_tw_state *. This allows for changing
> the representation in one place, without having to update the many
> functions that just forward their struct io_tw_state * argument.
> 
> Also add a comment to struct io_tw_state to explain its purpose.
> 
> [...]

Applied, thanks!

[1/2] io_uring: introduce type alias for io_tw_state
      commit: bcf8a0293a019bb0c4aebafdebe9a1e7a923249a
[2/2] io_uring: pass struct io_tw_state by value
      commit: 94a4274bb6ebc5b4293559304d0f00928de0d8c0

Best regards,
-- 
Jens Axboe




