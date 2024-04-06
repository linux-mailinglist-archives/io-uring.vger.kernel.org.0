Return-Path: <io-uring+bounces-1420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E122389A85A
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 04:07:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B921B21952
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 02:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 809313C00;
	Sat,  6 Apr 2024 02:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BgezEi2a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965B0F4FB
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 02:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712369224; cv=none; b=A1oLJYt1admz4kXtCyVsdnjWTqGwbqhqclqg6BfrSsZJxCvymgHJzd/pZJPAyxg8LCdl4Gglk8IiOQ+5JGHnrA4vH6pvGKINANApG+P/TyfhJ5xHPcCbIEXVjEFEWJbL4DIFqKfqrx5BRJEYzqNqQoiCvXFVZ1IANud0BpIp1rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712369224; c=relaxed/simple;
	bh=BV0Y+AtDRViqydh2rktwDpNoS9xWAAF8Ek9cJCIvYgA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ByrgHRJAK+2NHNbAwxkoWk4VBznFjdF9CSrr+PDgtMgZRrBs+OzbsQFdnMxnilQzRkikyc8MwbT0qFY4wWGxMlqVZE4W5Vzdg81e8e8Nh4279YnsoChZryCVF7dqLDFYDbzzbOHX3ebFNtRoHdXYpziFh61ZQe7rANxpNcS/yP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BgezEi2a; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-36a11328dfeso1380865ab.1
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 19:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712369221; x=1712974021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0k6qmZKEIP6UtdeoEAZUyO7V+ZRIrvuU0XVK7a3cEBE=;
        b=BgezEi2aFmwMjZIrWHcQqO1/kYL51l+JL7CAJ7Ra74Lr6ouR1ZErSbMkkhPkcHeBI/
         bUQ1+HDGTKi8HbW0PIqVdY5ytvpJPrIz6+anV+cX3FxyfpSlt++5cWZ8asIp4lFLHpKQ
         ktJnNPmGbx3J3jKYUpom96d1W8QTG68iDSxH29lZTNiUkBCpYe5mngGmGbjaKT6xfeVF
         NCR8B5c5fHEtHkYoWBQmfX8d0rjGa5ApUr+2aX8CuFkRdDhFJMNwchOwPQ/6HussYT54
         wewKce3rt49bBLSpvwt2RYlF90z6gNXgP/9yFrC1sYjPig7Dxr65J1Qz3SH1BWco0LPo
         Zmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712369221; x=1712974021;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0k6qmZKEIP6UtdeoEAZUyO7V+ZRIrvuU0XVK7a3cEBE=;
        b=OLjPLTLmYK18zU0oKr1UIs5cdL7z4mra897U2Nyct94uzkc/70TNLZ59kfawBEq9dL
         YKdB/tbaP5Zog0gw6jJuaJ7UvoUMPt9TcJPlAOxeAFKC6AXafkfR2EoEsJScBB4shOSd
         O2t9ms8HeyvIRKnE3pL985ftKEns7svBpjCYu9PtFqU1AKEdEkpCPv8qxZaOcUM/Lgl3
         oh76EAMUsvLIRAbmK5GOUZbKDw727KtfWCFCTL53HhPpoEVSWXkntRYT/fcz+cRNYnNt
         CLOb0TE/Xq/GqNTjpeZQLZEWQHMU9nTh0J5jWsm8vs7h9LbWctgpUUE5rnf7RuqUtdDE
         I5/g==
X-Gm-Message-State: AOJu0YwGAqrp0xk1xJ5lkp5cHSWelZ2qUSbyo3p0qjNHHaJxUEfjYx5M
	DWfzD0xu/XF7rtA3YS7cVe4YZ+lhzi3g7QIL8kRvg3YuSvDLp8zmRyZ7B7W4SMw=
X-Google-Smtp-Source: AGHT+IF0zPKs1kQfxweINKb3BjyBCXM5rDoPYN0YUpyY8X/iAnDWb0eVpTpvKpL41/Fh8SQ7WkWpJA==
X-Received: by 2002:a92:612:0:b0:368:80b8:36fa with SMTP id x18-20020a920612000000b0036880b836famr2902753ilg.2.1712369221530;
        Fri, 05 Apr 2024 19:07:01 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.135.167])
        by smtp.gmail.com with ESMTPSA id c13-20020a92cf0d000000b00368b9c86edasm721411ilo.46.2024.04.05.19.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 19:07:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Olivier Langlois <olivier@trillion01.com>, 
 Alexey Izbyshev <izbyshev@ispras.ru>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240405125551.237142-1-izbyshev@ispras.ru>
References: <20240405125551.237142-1-izbyshev@ispras.ru>
Subject: Re: [PATCH] io_uring: Fix io_cqring_wait() not restoring sigmask
 on get_timespec64() failure
Message-Id: <171236921462.2449875.3413725711123541167.b4-ty@kernel.dk>
Date: Fri, 05 Apr 2024 20:06:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 05 Apr 2024 15:55:51 +0300, Alexey Izbyshev wrote:
> This bug was introduced in commit 950e79dd7313 ("io_uring: minor
> io_cqring_wait() optimization"), which was made in preparation for
> adc8682ec690 ("io_uring: Add support for napi_busy_poll"). The latter
> got reverted in cb3182167325 ("Revert "io_uring: Add support for
> napi_busy_poll""), so simply undo the former as well.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: Fix io_cqring_wait() not restoring sigmask on get_timespec64() failure
      commit: 978e5c19dfefc271e5550efba92fcef0d3f62864

Best regards,
-- 
Jens Axboe




