Return-Path: <io-uring+bounces-7232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C09F3A701BE
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 14:29:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CCDB16B4AC
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8761C27;
	Tue, 25 Mar 2025 13:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HroWWBN6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642A5254B1B
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 13:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742908001; cv=none; b=PilOL3+etb8YKzZJLjNXnmZ2Wk0q4s1416PGnrhRbNFo1P7qZU4higmVL9I7ys3klm8EHeMTuIG8CylZCAXIKAy6Svg12AL/X26z+6Xe9CqC5r6na0YH45vgB8fCydsesMWQKp9w5WkshHHt/6LnUwkKiX3KO6JNsOPGDVtE8tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742908001; c=relaxed/simple;
	bh=dRyyc6Cb4AswVhQUPc++crML5PPGLhT3MF77o6C+5L0=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cgnj3a9Najcbsr37tQQ8FYnlWR4vnX3gxb5EaI6iDzpdb/zY7SxsrtPKL7GL9Ar8oe7pBAo93fx9Bm7AGXxyO1tquBnZO8aciLbyGML7xjb3wdJOwUuEHX06mQKfdKNvZ/0rzHOnbP667nNc/96fog6FeoEQ2zF2UDgSwd4wu/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HroWWBN6; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6ecfc2cb1aaso18917906d6.3
        for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 06:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742907997; x=1743512797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wWi/TnUNBaqQVy6xvx+r8IZ9/jhjWig4geoGF00BZ5M=;
        b=HroWWBN6wfcQ4w2nSXdagpFjaY7yFtxa5d/GrEbvCW5HwonS07q8qFYylpzsiUeUU3
         NWsbkve25dM2VvL93k76cl/dgngUKVcOVgYL5Byx/QSjN39rcpcu6Fxupuf7X5FBTQp3
         aa3SDurNdiaqHTC6FBromVDdc0Pop/b36NCI7eyzSuswMZ0tEC2gdAMbB8M6SEHRf9gv
         pUMCIFGCh4I6+y8dooAMtoXHvVNOqTDFzDO11tHPizvgbtv+P8m0LcniDXMtvHgEOaKE
         cV1dr6Kh8U1Ns9q+PrH0mfbEvu/eFDfKUZWFxRWXCPnXYaA6jCXNf5//aHvxA/xRCx7D
         Srrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742907997; x=1743512797;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wWi/TnUNBaqQVy6xvx+r8IZ9/jhjWig4geoGF00BZ5M=;
        b=H9Kyc4fkjBIm69uKZhr3enK1YP/YEHrKUsZhNg2QIu7xZPGOSgtci/8sjOSkO5XwSE
         4mJil8WEbyUoeySSfc8Uoa2lo9EhQKlvlkaJ/7FgBHTiK5Lw6/rxNQZkAwAz8nhZbPPH
         bhf0wY5BXcKV55tTupwNBRf9EoBIco5vUguZTk2FSyjK9Bff3abuEaYfv4W+IpiDQmt6
         O4rgExJYOX9fkD+rcpKHXgZ8XYNTgEIFLChazHDZ1Z/q3ttf0LN6DV0rk2EnrbM6fBUs
         ry1gSepcJfN9rTO96duDGhUErgpXzq1eSUo/qpFTqwXhxxSZ/6kwJnsbQJ+ZepLY+Lyx
         voeg==
X-Gm-Message-State: AOJu0Yy//K8Y36xiAZVZ7NFMhAle2Ys7mBEHt78Fmas5fwp1FjzzH0Ps
	vRbEqtX5CNa6fp9eSRjcActShiZDkNPa0fI6vqFFxFmDH4hh2juQBuNSachpk00=
X-Gm-Gg: ASbGnctDn7JdQu++5+XrefKgH5cJoXOyfykkG2RTcAisXb5eQNwhzDJ2BypSLhfVQUA
	EPJ5iTPiY/J0sDeTM5EFQQ/zsJvbChBWcQf3IjYyJ1eEeOekLeHvWFkatlKjlUNGRoIwLZs1ImV
	yFvU5lCIbFXX/yH+jB8qJPPba5ucmrsu4UsBleW/RMmXHswdKWTcqC1Y5ZhNazemVEyheto5cFd
	dXGohduj5B3c2jHzZLdf+qqYxQZaC54BLizoqLBW5hOZ4wUSTTSou331192PSMgkejzSLv6RCiK
	5KjyHxTc54vZ7imlB6GZ+PNs3SZ0YJW42/Ih
X-Google-Smtp-Source: AGHT+IFLrD7256IkIArfxGLoJFHrRw1S42PRD1DrC2Oq5EHfggHNZJTAqeedJ0kz8jPHyk3uyYD/gA==
X-Received: by 2002:a05:6214:194b:b0:6e6:61a5:aa4c with SMTP id 6a1803df08f44-6eb3f33d24fmr248691736d6.31.1742907995662;
        Tue, 25 Mar 2025 06:06:35 -0700 (PDT)
Received: from [127.0.0.1] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eb3efdc37bsm56408306d6.118.2025.03.25.06.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 06:06:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1742829388.git.asml.silence@gmail.com>
References: <cover.1742829388.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/5] reissue fix and various cleanups
Message-Id: <174290799488.1078424.12950821979628194756.b4-ty@kernel.dk>
Date: Tue, 25 Mar 2025 07:06:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 24 Mar 2025 15:32:31 +0000, Pavel Begunkov wrote:
> Patch 1 handle REQ_F_REISSUE off the iowq path, The rest are
> random cleanups.
> 
> Pavel Begunkov (5):
>   io_uring: fix retry handling off iowq
>   io_uring: defer iowq cqe overflow via task_work
>   io_uring: open code __io_post_aux_cqe()
>   io_uring: rename "min" arg in io_iopoll_check()
>   io_uring: move min_events sanitisation
> 
> [...]

Applied, thanks!

[1/5] io_uring: fix retry handling off iowq
      (no commit info)
[2/5] io_uring: defer iowq cqe overflow via task_work
      (no commit info)
[3/5] io_uring: open code __io_post_aux_cqe()
      (no commit info)
[4/5] io_uring: rename "min" arg in io_iopoll_check()
      (no commit info)
[5/5] io_uring: move min_events sanitisation
      (no commit info)

Best regards,
-- 
Jens Axboe




