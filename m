Return-Path: <io-uring+bounces-7515-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A66A91C3D
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 14:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EED8519E2EF5
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 12:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D541C27;
	Thu, 17 Apr 2025 12:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hiOjNziJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9F31F949
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 12:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744893101; cv=none; b=CJsEi4uZBlUGB2CJvxpIVuTrcySm2Pt9yM0yue2mCacEv8AZBxc1baucvMYi1NQ2lggJq563wdV66sr1QxLFh/VPC7KTnaxdf7jD3aDJH9FnC0DiO41pd1Lcn527XNR+eTV7jdCU3xhO4+pmZ0lTJlzaLDnuaNWGNBFzC2NsY9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744893101; c=relaxed/simple;
	bh=xRuSZtVbTypZbpZsidqwam2Cf6Ow3TvHYXBjFPzdOJw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KducrMw4iSuHLAkxq+0pZEq7mY79q8j9X6rVPJkQRV8azMGzluec6KvJ8XAZ9/++xlfs957MwS2cS3kkxDE1ygbm1FiaJos9hOFUGsyk6dhLFeVOth0/J+nIyydTiznISU2bCA9S3Cg34KZglEDlaLF6Sepv14jXMW6Dyz4PrWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hiOjNziJ; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d80bbf3aefso1693235ab.1
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 05:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744893098; x=1745497898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5TU3kkCxCJDJn3nVGJCqr1uYfrRaI7MOE0+iQ5mg6eQ=;
        b=hiOjNziJyIaFp5clNPhuO75e5RDHdUUzJwY3rwKKoJMkFSpBVfrRVbjo1Ivu1zi9vJ
         sHJRVPOwXf+/hjOO4DHKKm9x2woQdKeaPyysTm4xYipkFErUkoBrGMHe8uqjiG5qq5bj
         dw5b13gAFUYNtE7i7IO2zqVqRcDoyIo0SRLX5n8FGWNMNrF+rXp7/uPuuKFVJxMJgvMr
         5klaFJGYvrC9I/DiF3Gg1kKUCy8/HfO0U0JAWdhVt1MSvZqTXVlc9996JWT3x8rj6kDj
         sKHtBpghWJKUQCxZODa0R2x8U4RA92NkqbnJFn6FM767Az5XL6cwGZwyVucUgaaWPZn6
         450w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744893098; x=1745497898;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5TU3kkCxCJDJn3nVGJCqr1uYfrRaI7MOE0+iQ5mg6eQ=;
        b=Znbop4FauFCNZX6Ws6ycl7/SUhap379ouEFiqKsRg3trRgByGbdI7q5f1k+Ttp35o5
         BIjPYHW5xY8fTtlsHhn88vTEQSk0/N+pklt/ESV4tL1nTki/T4CnDYdiqhA+AT6DonbN
         vDzJszYFy2qjRo+xi31tnBP+JI+DnnVqgmn1cm98iAHDiUjmcaNspPTC5ADTgYfy2Z5x
         ZkT708IsZIa/b8oQayyT+85ZaGz6trDJYZ4ohBKdtABYI5CAKp5YMZeKt/zX0NCc33Ug
         XHq/rJRDsOBva+XrDDOpZXwGU5MLf/aoCmRCrdeM8B63/y6cHs+IneBt7zDXuR3l60xO
         yDnw==
X-Gm-Message-State: AOJu0YzxvpRIEIP2K+C7McKuny01ACRlnOwKZZ5HUuPNd8kJ0H857pSW
	IDLb/Qk5zH48W15jNT+Qat5go9hN/Zno1VBUH/7yuPJ73sER/jVrBRTDNsuvSJ0=
X-Gm-Gg: ASbGncsh7MBg5AVidsXvc5hrEtJ0JHw5iZZ+tIsLcAPmoxzJGroKmIUbMgNCJRzOwFe
	bfJly0Ta+k5a4+DXLLZeq/1z0Z8wgq2q9MyehHy9Y6o+ovG1SgS1URDxn0Mii3gbgUWeGa+EOwn
	GpEtz2l0vKBwFg1U9GUAPVMKcgevUC83HV/4ktbjBcUt9wKBYtuPloI/DprBHMxbLsCWzifFTvc
	ZN0iVWQCFpfH6GIBM4yX28jrnIdmT+RPqmzevhQGBEAUll9n4LwfBMMFLHvadQE8HFc7O9Q8sKj
	+hcd8+wFmy0DEl98t0K6HPUF6LiZjZoA
X-Google-Smtp-Source: AGHT+IFFyTJ833tyK5IBv+3LDBsObG47d/4Apdl9ujKXRuQE1OfsAh8iy/Z8CwIwKK64A+u9Oqwpcg==
X-Received: by 2002:a05:6e02:1905:b0:3d0:21aa:a752 with SMTP id e9e14a558f8ab-3d815af7f23mr54635395ab.2.1744893098373;
        Thu, 17 Apr 2025 05:31:38 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e0155fsm3990668173.77.2025.04.17.05.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 05:31:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Nitesh Shetty <nj.shetty@samsung.com>
In-Reply-To: <cover.1744882081.git.asml.silence@gmail.com>
References: <cover.1744882081.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/4] io_import_fixed cleanups and optimisation
Message-Id: <174489309759.518785.7848466794591666791.b4-ty@kernel.dk>
Date: Thu, 17 Apr 2025 06:31:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 17 Apr 2025 10:32:30 +0100, Pavel Begunkov wrote:
> io_import_fixed() cleanups topped with the nr segs optimisation
> patch from Nitesh. Doesn't have the kbuf part, assuming Jens will
> add it on top.
> 
> Based on io_uring-6.15
> 
> Nitesh Shetty (1):
>   io_uring/rsrc: send exact nr_segs for fixed buffer
> 
> [...]

Applied, thanks!

[1/4] io_uring/rsrc: don't skip offset calculation
      commit: 1ac571288822253db32196c49f240739148417e3
[2/4] io_uring/rsrc: separate kbuf offset adjustments
      commit: 50169d07548441e3033b9bbaa06e573e7224f140
[3/4] io_uring/rsrc: refactor io_import_fixed
      commit: 59852ebad954c8a3ac8b746930c2ea60febe797a
[4/4] io_uring/rsrc: send exact nr_segs for fixed buffer
      commit: c5a173d9864a597288c6acd091315cfc3b32ca1c

Best regards,
-- 
Jens Axboe




