Return-Path: <io-uring+bounces-2828-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2FA1955EC0
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 21:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 843F31F20C3A
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 19:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D84F9463;
	Sun, 18 Aug 2024 19:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CGGZhiiw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0498D2581
	for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 19:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724009985; cv=none; b=RFQqRIhSTpoJdoCv+O45TlxqEZ8pZKlnuRHeHBqfSSEEzhETnP565Ib/xMcxPUmB9RkZaXeKqUG/mGKrPBxwWaaE86XSyCqp1WQcLIT8z5Q+z5jlrUNncyxixMU/Jr+lIpCIGnuFujp1nPDITGGpqqlOBUOeJm01p0sNhbLJtwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724009985; c=relaxed/simple;
	bh=ubKhn7GJElNL5W8GQTV9T7pykDUIkt29ZCj7T4XRyIE=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bxk76XJV8vwGWm9BkFJFErq6sosNoT/WRO3dspDFcsDq3mK0kwy3pxFHEU8ZU4LVaj+jYbp88YJ4vLkW140p33VkdoMcKgNFppEhs1PSkjPA1sl6lnk+BGzQIX4e9ibX/GfRt68HDcPNGpSpItfPn0mXxwPoVPs2uqDGFUxKkpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CGGZhiiw; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2d3d486d8bdso495020a91.3
        for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 12:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724009981; x=1724614781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wE+8uA61I+qdUQosJfCKvDWUdeL9wW0bhIM6jOMDWbM=;
        b=CGGZhiiwrfxhr6SzrsizTl+CiI3RT/5S0Z9OZXQutbZ22gtx/tdYy4dBUopcdeeZPV
         JX6gRFv+X6zYXh5FoGNMGHay1hV+tMdWifF5b//NdBn48nxiqS2q/NN3U0kdQIITI0TX
         7qhBP8l7+Q/RFCwLgm0iUlvidUQVVvyIawRBIp3WC8fkVQ1E15D1jlDGQZBlgIw/TuMZ
         4a1daBAIs4KftrZTf6AkvkNjeSbvSzVJz7mb2KjYOI/GCJXKNLJmRFiO1S8Srl0Hly2u
         OfK8DMRsYykog+o3qcjvToMy2+xT59WYQcNQER7s4aVWL1NQRtgx67tlUeEsZcA0H16Q
         1WYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724009981; x=1724614781;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wE+8uA61I+qdUQosJfCKvDWUdeL9wW0bhIM6jOMDWbM=;
        b=dGD2GCv1RBauy7XbJhUrvNQLDAinwSuU5TiMc6j0iS76cMHVDcqPpfruTSljCGYgrL
         rVCQZkv+Ualcwb+0UToYouIrz9iax16F88ROyuaUs8xezSIU/Mtt3/OaTkHFpsq2HUat
         LIqRYpcwsjshRByUJdKgllmIfgWn8/24m18aeJnkbIkqj4s8+ydPbiG0wC3gzvRWzmCg
         T8W/nRc5HXITzsCR22rkul7Fw//YCa2ENLL2e1eZjvWlHzkHLy7S9drROim20X/O4rsp
         fAWtk6cmo9RLqkBWyj0kF6Kzm7JlaVx05HO+jbtkxnEvj654dYmQzqnljg5HIUqk1U7X
         Fg4g==
X-Gm-Message-State: AOJu0YxltZyriRD/Y8+DDU3Ic+fSnjPsmc3rC0NQMU/2/YzWtW0K8tZ9
	GPCh/22yXFFCSDxELcOR+3JRVNrZRddFO6J3iCFAWeqKD50iw9qeoCD45NLUis0DgtxoiEBCW1c
	1
X-Google-Smtp-Source: AGHT+IEyOoC+2yIkYfPPvyEVE/UhSOq++Ks0iq4FMvqD/2iLcGJMl9xBk/qk1JsJcQ5ST66NKKJfkg==
X-Received: by 2002:a17:90a:9a9:b0:2c4:cd15:3e4b with SMTP id 98e67ed59e1d1-2d3e086417amr6178094a91.4.1724009980546;
        Sun, 18 Aug 2024 12:39:40 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d4361f4338sm1330148a91.27.2024.08.18.12.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 12:39:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1724007045.git.asml.silence@gmail.com>
References: <cover.1724007045.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/4] Tests for absolute timeouts and clockids
Message-Id: <172400997966.150043.7034346479530681337.b4-ty@kernel.dk>
Date: Sun, 18 Aug 2024 13:39:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Sun, 18 Aug 2024 19:55:40 +0100, Pavel Begunkov wrote:
> Add definitions, tests and documentation for IORING_ENTER_ABS_TIMER
> and IORING_REGISTER_CLOCK.
> 
> It also adds helpers for registering clocks but not for absolute
> timeouts. Currently, liburing does't provide a way to pass custom
> enter flags.
> 
> [...]

Applied, thanks!

[1/4] Sync kernel headers
      commit: 2fce7b7067a2443dcba8c94254efc3b1c6f84235
[2/4] src/register: add clock id registration helper
      commit: eed5cab0138531ff308c975825d01654644f0b42
[3/4] test: test clockids and abs timeouts
      commit: 050dd942acd02362299bde09ba794681052e1ebe
[4/4] man: document clock id and IORING_ENTER_ABS_TIMER
      commit: fa347092fac1b28bd9100e617974708af379ac44

Best regards,
-- 
Jens Axboe




