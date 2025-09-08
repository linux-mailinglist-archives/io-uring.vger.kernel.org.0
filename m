Return-Path: <io-uring+bounces-9643-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C01B490B7
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 16:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22ED41646C7
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 14:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CBD830CD9C;
	Mon,  8 Sep 2025 14:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QtzE8V0S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B7130C63B
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 14:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757340443; cv=none; b=sr2ySk8vmIe10FFigmEx8+wiZ2yhROG7mCIfpFz8I/KVW3zCQ6mckg4KeoAyyXL7I+6xxYTt6o2PLrkM2NzgON69gdwO3vbPQGiKtBfaTTpZHJ1LRUGPaIqAJIpCTMf4/QBOA7m9ow2bdMRrzusPabAzbDYYRpzcdmpkRg0npcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757340443; c=relaxed/simple;
	bh=J6y5WbI4XXS+8V8fZtMz5/R6zSzIM1EDSeLOve2Re/c=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nBMEy+eh7zQ/qd97PLoOzgya9Bn8jrXYdvGnh4p6loPsXtksBwf+SwQIn18HDURTphszLNr5xL5+g8A4S4anb11HgEuO8O9Hbso1NKNogZQbLF2uguu23EoM6vhz2+b0KXy7PFfanRGeWKl2n6It+E++p+K8vH5Oy+AZz1AeHKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QtzE8V0S; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b52196e8464so1742893a12.3
        for <io-uring@vger.kernel.org>; Mon, 08 Sep 2025 07:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757340440; x=1757945240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fDr5DFnoFr9OM+R0E9JAqvaXUs6JWo6vy98cQksyAUQ=;
        b=QtzE8V0SFB28tlOq3RVamjcVh35w1A/cgWX2v3FFqtPI3aVgCLwingpZ0mSURbcfFY
         R11oy1DH6wmPUy/l5sk0ahxlLn1zgvcajvCx7cHsrZ9SGeewS5uPsg3gLaT3UxY+L9/u
         LTgovQ3HrDsajPn8ux4jwKgTE2TFM6cVp2HUARV4H7+gGWZeoeX3nAqV0hhOnC8XrCkR
         CP5xVDTBtvIpjtSxhBThUjGzQW6nLXDFXetm+U16he1kXYm/dmEUbPuCV7v54PzzW5KG
         8bkK+p/3dsKSd9xAPhNEXNss65Kh9H37Nw7Gv/uno7gnehSJepz3y5ii2BVG4rkCQPFK
         hX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757340440; x=1757945240;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDr5DFnoFr9OM+R0E9JAqvaXUs6JWo6vy98cQksyAUQ=;
        b=n6GZ/r+mfe9AsjKhDzMFXSKsCU4WRQ8cmKGxF2/bfnFYvEeVAl/SZdrwh9Gs+h9eb8
         LZzhEl0KM5ZO78qLBeaRqsNv/w0IgU8iSxd3CpKUyPDIrTc4ovU6uBkq18t1G9DnxZz6
         gaybwcycnAL1IfPHi2j8A4xYNQlw1N5nbSX+NOClz5hN5tYSOqpMvZOGpbIdYLv1FgM7
         k8EQY2z5ZyhX8XlzFmXqBiXr5oyuxAoTzfySTK5HobMKElWBoL6IMqmXvX6eiVpxhc7Q
         ifcm0BT8McwaYFi2CcxLkLHbXyWJ3XSjhAqLpBIcJ/qwQTtpwfSbxDK0dpOYsyx4dPDr
         a2wA==
X-Gm-Message-State: AOJu0Yyd0W25oCARj5XWikVg38HVIN7tQa4fgNLHD954NkiK6Bl4/d+c
	+kk4y32Y7VJ2vcza9axm6B9MLL35OTRcDGNCSyM3/IK8xeYwgOWgk88eErVCY/gGrzy0pXBXL8w
	NEZPi
X-Gm-Gg: ASbGncvse9G0nzW8WUXNVtwekVd7VNOSo8SqdDnPdKSQxES7yoBoMvobptdvBp4+5U0
	86eH4ho4jCbOeYhw6HfT6qoS0LWUb6eGChjpdSsq799fAUdLLkwXVv0dTWq0MIl0TP/eVVZvasU
	3EyQWAayftxCsq0EpswXgJHKzs1jgL85dRyndRBDoY9qvIZjIwUg6uroAf+T+Y8U6oVkIb8iRX/
	pu7trMU2/GpBYoGLK38BlzKFgX715Xyd6VzvUpnDh9vFzx/iAOldjtwwAaROyFtGHaWL5QHdJES
	yZGd02Br/eXLFn5KaUEfk+vTgOkS5BcGGe1+30YPrrcPF1eC/4TJUiCotLaymnBSkLB0+N1D5FB
	MSSuGT44rH83UY4w=
X-Google-Smtp-Source: AGHT+IH2Jmd6gju083zklmlQBksyqqCd+hq6OIFfDLey6fK1v8mBVj2rcEXKpl/IAz55qHkypo6raw==
X-Received: by 2002:a17:902:ebca:b0:24c:cf58:c5c3 with SMTP id d9443c01a7336-2516f05046amr110924745ad.23.1757340439604;
        Mon, 08 Sep 2025 07:07:19 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24c7ecd9cafsm154811625ad.83.2025.09.08.07.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 07:07:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1757286089.git.asml.silence@gmail.com>
References: <cover.1757286089.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 0/3] introduce io_uring querying
Message-Id: <175734043878.530489.13742910441104568812.b4-ty@kernel.dk>
Date: Mon, 08 Sep 2025 08:07:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Mon, 08 Sep 2025 00:02:57 +0100, Pavel Begunkov wrote:
> Introduce a versatile interface to query auxilary io_uring parameters.
> It will be used to close a couple of API gaps, but in this series can
> only tell what request and register opcodes, features and setup flags
> are available. It'll replace IORING_REGISTER_PROBE  but with a much
> more convenient interface. Patch 3 for API description.
> 
> Can be tested with:
> 
> [...]

Applied, thanks!

[1/3] io_uring: add helper for *REGISTER_SEND_MSG_RING
      commit: da8bc3c81c71eb8906dafca805db1a2639665116
[2/3] io_uring: add macros for avaliable flags
      commit: 63805d0a9b9670ade00c4f49e4fe093668b31ba5
[3/3] io_uring: introduce io_uring querying
      commit: c265ae75f900cea4e415230a77b5d152377627dd

Best regards,
-- 
Jens Axboe




