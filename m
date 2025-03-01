Return-Path: <io-uring+bounces-6893-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B40CAA4A810
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79FAB7AA00F
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2BD1BD01F;
	Sat,  1 Mar 2025 02:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gD4T4Vuf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31F41B4145
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795824; cv=none; b=kpiqFxLaTURWfZxi3LIIEgKTGIWM1kGyq4kmRWCjl+63qyL2X/8h4swmDIS3EdQz1aX5epOgjx5ccelu022g5PlekTOjcDW5OsTQUcWatOgGneKxqYNx+KqkU7medRYxiKedaSjI8D/gzuh8MHzPJHHTfKxLODr1b5inIb90ppg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795824; c=relaxed/simple;
	bh=pKwkVTSQJ0aAuAlftXppJmht0Kot7MxlbY6yGzg7bVs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NqfWWVoF8j8UFLxVjatgL9mKyfmQxNV8gS66YFBLkq72KVFd/sVrqZyyRh/mIA490cAlArib9aozPOVGG0tnKz5zalXt5I0HEyAXFvfr7hgqE4tJowu7VRrtByslImMFKtnix1BNu4yTpS1AsNNpDYDpNss2Y3AgwCsvkdpeJR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gD4T4Vuf; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6efe4e3d698so25047137b3.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740795821; x=1741400621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9BLBwQOwrrYQIN7raxU+No/2e8DfV51qZaSaJee9wDc=;
        b=gD4T4VufIzLXAfDpNNrVvusy4WZ9Vu4BbV7h18EDY/Pq7V27AuxzScRtJPvDQTZYRQ
         vJc3SD8IAUYnXO9/whnJC5v13Ue7pdLhAI97/RCSEzpTFX4wPkuopZ86Q7YuseS4OI6t
         XrnkI74oSNTWzx3NTz4j6gOX2iFgTc1mt9PbE+19m6dLNHbhmGqKdpHiNeA313z3eAki
         n3Bvk6R1RFULa2KBpxxaBXGXpWTY9EDJMz2xgDm9uNstRn0LyhRISkvWWyj2EiaVnfnl
         T4KX9kyx9GZCUuKIXT0i5/ZDl7T6YsqRwLQ4Fqf6d9XsimiPTkfW0HcvRnmeWCMfrhSI
         9Vsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795821; x=1741400621;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9BLBwQOwrrYQIN7raxU+No/2e8DfV51qZaSaJee9wDc=;
        b=N4IbXd36iqUb59H6tZw/eaqCYYSBjI5iDvfX7iC6DT5WZhYQIbLTryhdwQn4Kt61a1
         3MHRhPh6CmVZXudlItuIyxVscDFd1QDT/F6gQVWX1B0D6zqhWuXDe/yVyWOeyAqo8W8G
         Lc4wUWn1gkBUIYnY2avfA1f+KjnoxJpUbZiyWC4JJIzMPxScrBzEUNSDxJyE9J5raflJ
         gF1J363mrxkcbD/ydZvkZxF1idP5QZqzUxiWqoxshV0x4jAL1pRKQoIUaA9CosLzuBDo
         FwWgv5cQ79iBROOA5+oGt5HDqNPD5c3ZOBGpmJ5gaSxv0+/frxMea1q5U1kbZqNT1DO9
         KJyg==
X-Forwarded-Encrypted: i=1; AJvYcCWK+d76JXBXab1/73wyOyUMyawWx9j5J8a4FyzW/Fs7wbthkVNJvvJ6jGA2R5QMR1lSML+odF1dNg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbWQ4ZYKm2pSUcEPp5NSZJG7LXJ1Eoff/U7N6Dd49O/eo/R1DY
	KOevs4raCOb2IzcaKgwwhHPWJipkUZQsXlaRHF1y8c45ERxuovnSPZK7DHBkRl8=
X-Gm-Gg: ASbGnctDRDE2VskW/La2zmAT69EAuNcQRb/zXtxIx/4fLSd4MIzuQpYoC7968omF9+z
	6w3SpDqYxNfdw+xG0BzJtD9gaUOXI/LmpatFcCcnRlhg+kUTQtOvUdszhPslZTOSAREoioOF8My
	FK46hfKfO2xOMYNv2RMYlmr35daHnPJNniQJmHXJinjGNQIXyS5FxUnU1rarNDeU9XWSmnC4Rx5
	SPCrt6pfDm4TvRPsXtwT0Wj0g6T3VUCkrPp8tL/s/k/8eaiXP10LFZrai7KJdVjvAlmeAQuwCx0
	gPM7XUJ9vpE/aCf5p7gDiqvGXxkz35QbTkXb0Ok=
X-Google-Smtp-Source: AGHT+IEAfgFEonGI7v81NxkPZsf+pVyxnn3pBYJKAcjf3ha9OznoVu7uywfX2gEhdr3ETKKz7Ff3pQ==
X-Received: by 2002:a05:690c:5719:b0:6fd:3ff9:ad96 with SMTP id 00721157ae682-6fd4a16d0aemr55511127b3.37.1740795820960;
        Fri, 28 Feb 2025 18:23:40 -0800 (PST)
Received: from [127.0.0.1] ([207.222.175.10])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6fd3cb7e02dsm10175307b3.84.2025.02.28.18.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 18:23:40 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>, Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 io-uring@vger.kernel.org
In-Reply-To: <20250228231432.642417-1-csander@purestorage.com>
References: <20250228231432.642417-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/ublk: report error when unregister operation
 fails
Message-Id: <174079581972.2596794.14825315582480664341.b4-ty@kernel.dk>
Date: Fri, 28 Feb 2025 19:23:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Fri, 28 Feb 2025 16:14:31 -0700, Caleb Sander Mateos wrote:
> Indicate to userspace applications if a UBLK_IO_UNREGISTER_IO_BUF
> command specifies an invalid buffer index by returning an error code.
> Return -EINVAL if no buffer is registered with the given index, and
> -EBUSY if the registered buffer is not a kernel bvec.
> 
> 

Applied, thanks!

[1/1] io_uring/ublk: report error when unregister operation fails
      commit: e6ea7ec494881bcf61b8f0f77f7cb3542f717ff2

Best regards,
-- 
Jens Axboe




