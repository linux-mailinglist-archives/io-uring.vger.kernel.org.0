Return-Path: <io-uring+bounces-7832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B16AA882E
	for <lists+io-uring@lfdr.de>; Sun,  4 May 2025 18:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 094DC1739CB
	for <lists+io-uring@lfdr.de>; Sun,  4 May 2025 16:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B4D1DBB2E;
	Sun,  4 May 2025 16:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BA1J6Eal"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE328F7D
	for <io-uring@vger.kernel.org>; Sun,  4 May 2025 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746377590; cv=none; b=QqVpTMFmpERL4VfayXXOuRGQXVmPqpjEtsSeebP0dbkTfzEy4cOE9DwXs1e2kl21XMCF5Aafh3Me1nv3dkWtsZzUXYXfiWfJNvEVgN7waI0IXfiZSalkZBL6v1wjWsSMXFv0d0xQmNyFi+G8hu7Cko1z2I/r2Dtu5xJjsDTEglk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746377590; c=relaxed/simple;
	bh=8ulGSzzvEHM1r3sRVUi8HZB6KO/5K3wUWXb9gVV08CQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pYjgViwSeLwQ43cv538TgBw9Ru7YpG0MkCSr1vZfREEQFwq3o0+T/2LkIdU/WQjk2rNXSzN/pAcYZWfDJEz0xw4zUDr3ps0u/XsFmiTFJcowi+dDRUNYWhU/LbxwWX5ZxxVEeJ5w4fGDruZ1HLOIPPWoWQG4ncd0W2rUbU1wXUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BA1J6Eal; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85e15dc801aso368767639f.2
        for <io-uring@vger.kernel.org>; Sun, 04 May 2025 09:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746377586; x=1746982386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8QyUxzH+YwTKYApE9rgYYdEuoprlvASizlfIdBVPVr8=;
        b=BA1J6EalInUC5T6Ciriqc1yyFcYalgf8Kbfzf77/w+VVMpS9VmbdvqKqMHVv2h6zyR
         4aDKzMbzyUyynVO0ybC2CRCVnFcOW9A3eiun8m+uM/zvGuWZdumwfL5PqtMm0Wwe2j8o
         9g1excFcrQHBs3ZESLZXCCoU6ejqFb/kWfkWodAGyKSZH6PK3UXX1eMl6QSbukuJLrpW
         /psyIBw186LbSVJvVq2BnSwSq+h0noWB8U1dPteGbhihkR7dvcaUpIGeIS5SU9FvO17D
         oTsqWlNT/5e5uWA0jwSNmrtzPCguB2FgE5J0MxFXA6Eh+K+uuuUeYRcgidu3TrL/wD4L
         Gc7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746377586; x=1746982386;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8QyUxzH+YwTKYApE9rgYYdEuoprlvASizlfIdBVPVr8=;
        b=iclhZTe+H5xjfpG3CaPxsvByTrlN7Kt3leIEKe5vs4CWKVVFZKz65ifEh/2LTvuJks
         DLV3Ic447sMOL1lU2dTuKUhcEIXhzvwRs+vorGXqfMfM0ybmCflEBDldugM1fRHAle8x
         qWPminzHFvcDTpRjPn1yZkpWF+0am8+fmmQYDh/mkY4Q8cCl8OKn7recaSUygy1VxELG
         bACIpMt4gyW/w/QvlSFZs9uPgF5+2rG7turhpII5rUBkWTVDQd5kMQs2Cy06cpSNFvfd
         z1Mgvb1Adn2Dw6eJBv1BzSXtYV1wICAD14yh3x3gPmDb/Aa8EZ7PAitnuIChXPeO5APE
         hCLA==
X-Gm-Message-State: AOJu0YxDJIZOUSPbRTnPBpxFGVdkwkU7TqqqxIyYdX1+DsyCM6yaAY8+
	uFmb6Z011DzwhbkMq0FmAh99yGpOgIobmPgchb3qp09EjMw3nxf/4zzPdAUof8Yp1xw2PWnDv80
	8
X-Gm-Gg: ASbGnctzUgbUIAbGwV1Bj93VOE7FEFldHGi2QWW9BTCE/5Cmbu+mqQlxHQHobNMk+co
	eqf0rfRRKqAloAkOb99voR6NhfGNfh/r1L3Jwu6dk3GbHnSCae2DbR7BepQokAVPO7A7v5Qsib9
	sMh62sOQPf/PFgc8OVUoUFcozQNpiMPD0emqyN3Ro7vNzjiroWXc3azsuSoVXq0+y8+MCxY1nBR
	NQVG1ef/6dbhGu/mD8DDOK6Qrm645ExpPNYgXHcz0SsLqsgTsYZ1fQhkQtgT3UH8xDTn65Nx7mv
	WLTi4Sd1jycPNpsHLpPEyy2ssO07vVhOfxx8MkTwVVw=
X-Google-Smtp-Source: AGHT+IEJ/7euz2uqK7TPCNE2nK84yDFpwXLAeticaRLnGGZmyn5WuV+sQzcKBlH3K4rziaafs/OPkQ==
X-Received: by 2002:a05:6602:4899:b0:85d:f316:fabc with SMTP id ca18e2360f4ac-8669f9be1f6mr1101764839f.8.1746377586396;
        Sun, 04 May 2025 09:53:06 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-864aa2bc9d7sm148247639f.6.2025.05.04.09.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 09:53:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1746204705.git.asml.silence@gmail.com>
References: <cover.1746204705.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/5] enchance zc benchmarks
Message-Id: <174637758527.1147560.18052685966804007003.b4-ty@kernel.dk>
Date: Sun, 04 May 2025 10:53:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 02 May 2025 17:53:57 +0100, Pavel Begunkov wrote:
> The patchset adds options for binding to a device and for filling with
> a pattern for data verification. Also, improve warning and error
> messages.
> 
> v2: add patch 4
>     fix ghost variable build errors
> 
> [...]

Applied, thanks!

[1/5] examples/send-zc: warn about data reordering
      commit: 4dca51bbabda1453a2ed2d9fb1276ed0df0629a4
[2/5] examples/send-zc: option to bind socket to device
      commit: 78d0ed571c1314d9506b446c72839800c21d873b
[3/5] examples/send-zc: optionally fill data with a pattern
      commit: 1c6ed372b015bf237c03fba1f72b5cd06b1aa4b1
[4/5] examples/send-zc: record time on disconnect
      commit: fb7248c4bae46eabef651367f43d13944c3cf8bb
[5/5] examples/zcrx: be more verbose on verification failure
      commit: 7fd79781a239e403e182220a77dd0758d93d3ca0

Best regards,
-- 
Jens Axboe




