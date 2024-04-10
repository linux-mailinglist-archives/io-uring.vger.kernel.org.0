Return-Path: <io-uring+bounces-1490-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2385889E840
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 04:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C661F1F26056
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 02:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE7CF443D;
	Wed, 10 Apr 2024 02:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BsmWbr4Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E80138C
	for <io-uring@vger.kernel.org>; Wed, 10 Apr 2024 02:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712716759; cv=none; b=FhUa7zzkQnhZ01j1tGGEdofNcqEG7LtduwI86ZI8QDzNHd1UQ/F+uBonGMttI+73r9X0drZ9MwAP8J0XAm/TDp45za/04GHWnBKSTnlzz1XlvZfLcT0L5WqJTGsv0DYrcHRPO8ancof6IjbMhNZ7bX5iqSVCc9r0sKWsVmF2u2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712716759; c=relaxed/simple;
	bh=urgIXFOZZjpQO4FMst0jZyorJSNjvu75X0yuzN7Xc8Q=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mLRNJ7Z9YwFLfJztSRNwOeXQVL6hnBxf6gLWPTmoIuiITPrZqRwuERnUv4pWd7hDLiZ7QId4mmnI4UyQDo+3Eey2i3D4zGlne5LdNjgQtdOPORSPOcfaxiCBF3TREjRPOcKcT63Qf07/OIoKf1as91gSsCXTok9+7GGifSrH0Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BsmWbr4Z; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-58962bf3f89so1290638a12.0
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 19:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712716757; x=1713321557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFgv+GqSS9I+pC8MNT1ul97qs+v75z8vHqHy3/tmPOs=;
        b=BsmWbr4Z3fxKZDRYLr4+B3xMe/NYOz/J1AbgEnMwYGzxP39MaGTQNWX2dCukPrwurH
         2bbMSk7jcfblQ4ykcDyCn4TxSjaEbQ8NCqxsOLQsPrXVFHQhX6m0HHg3atj2kpqc6QK4
         CZg1OUzQhkv2eCM5wACSjdHdkWJ2JPgb3/LWWNl/PZVI+yA+5WFjlZKKakcVAFDVJ9K2
         OT/t1wFSihNcwlc0aSqsdLJKf8G/TY+kP3FbYu5UX+KdRsgcEE05VXA7F/lz8ILMLdsG
         Xzlc6rBKwJHJaLnT7lVxBG+tNk6dhTjPl1lTngPkS9XaCwnZ15v+p8jUSAFpL6vSnFCu
         F3gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712716757; x=1713321557;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gFgv+GqSS9I+pC8MNT1ul97qs+v75z8vHqHy3/tmPOs=;
        b=NBqaeMR/mfj6jj835c0QsgmQWVUIDjxAsCLq9LnvaMHtb29IKP/QTgx9YXE5n6vEN9
         Dwcxq6AjIBO5tsECOmiEBI+Wt06wGfzJK8OOW4b7ugMnHtjxyos5WbrG0IpYaN/D4WSP
         Pvfq2A8gixdzerL4ectAc/O8Vs/6LBzy4k7WOmJobBS7ag0qS9UNHLkSFB1xXtSAodGJ
         how66znrhftzjIwtKznn4nulln6lSjOipg+wKBElkKk3RH16G+0q8v3DFBLgXuP6LW61
         RxRAMWCeK22UF16uMYNf1OnoaiS+zTFnLIWG951lMeJIrUupj+CAHOVA0ZPs3dR7d7gp
         GgNQ==
X-Gm-Message-State: AOJu0YwL9UnsGgBUx1IXpAjC/ZT08dfNUNddddnolDooVJL+3fSXfdTo
	l4qhxKlVVxVDPYjS0BuWPAxR56dOpX7rShoVeex4+N2YaslXA2gRQM0LBd0JyU8U+LjH1QJRxPN
	E
X-Google-Smtp-Source: AGHT+IGrMvSapwatTtxAuZMrkbhoI4ZQmzWUy5T7bdQ5PGQibBvMO4N6RaAN7AoyrkAoK3hyogdX2w==
X-Received: by 2002:a05:6a20:3c89:b0:1a7:9b9a:757b with SMTP id b9-20020a056a203c8900b001a79b9a757bmr1837967pzj.1.1712716756769;
        Tue, 09 Apr 2024 19:39:16 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902f28c00b001dcc2951c02sm9658372plc.286.2024.04.09.19.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 19:39:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1712708261.git.asml.silence@gmail.com>
References: <cover.1712708261.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/5] overflow CQE cleanups
Message-Id: <171271675486.91809.12754695642759304524.b4-ty@kernel.dk>
Date: Tue, 09 Apr 2024 20:39:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 10 Apr 2024 02:26:50 +0100, Pavel Begunkov wrote:
> Refactoring for overflow CQE flushing and posting. The next related
> problem would be to make io_cqring_event_overflow()'s locking saner.
> 
> Pavel Begunkov (5):
>   io_uring: unexport io_req_cqe_overflow()
>   io_uring: remove extra SQPOLL overflow flush
>   io_uring: open code io_cqring_overflow_flush()
>   io_uring: always lock __io_cqring_overflow_flush
>   io_uring: consolidate overflow flushing
> 
> [...]

Applied, thanks!

[1/5] io_uring: unexport io_req_cqe_overflow()
      commit: 3de3cc01f18fc7f6c9a5f8f28d97c5e36912e78b
[2/5] io_uring: remove extra SQPOLL overflow flush
      commit: 2aa2ddefbe584264ee618e15b1a0d1183e8e37b8
[3/5] io_uring: open code io_cqring_overflow_flush()
      commit: bd08cb7a6f5b05bc1b122117a922da21c081c58e
[4/5] io_uring: always lock __io_cqring_overflow_flush
      commit: 678b1aa58dffc01d9359a3fc093192746350f137
[5/5] io_uring: consolidate overflow flushing
      commit: ed50ebf24b391a6a3b17a7f6bf968303f0277bb7

Best regards,
-- 
Jens Axboe




