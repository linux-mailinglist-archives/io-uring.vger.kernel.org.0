Return-Path: <io-uring+bounces-4427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 160069BBA25
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94137B21F62
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8961C2432;
	Mon,  4 Nov 2024 16:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wg+mwzeF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B8A16D9AA
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 16:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730737161; cv=none; b=WKH4ulkLEQrS67Os4vR1Asw66+4Kww89HDQqo70CuuWz4yhRuAsdbs7FpqVD90asINe0UKWErff1UCFJhqbHnPbn6AG6YEU3dSjlwTfs5J8TAR626gkD+BWzCJnOqYdVFp/NB269t8gNJW13CHUPWVIKrPZZoWwh/pIjjw9mGzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730737161; c=relaxed/simple;
	bh=ECSKHgxIejsdIxBcf9CjgGTo9d3hMe4tRNonWGBWM4A=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ifvuNm/ALUA5lhjKiUR7RVODHjt5Ehu5d2VHvPZI7+gHaP3kxEpk8OxA40KKknbE+vMK8P5hjY15q17F/dh9TM+H5MVFRa/bqJZO61/tSA2jWRCqAEb8dLmKyj1R6dcCs+I5JftAtCZ1iNI1muCCXez+xGuuNL2t3+3lrdMp0ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wg+mwzeF; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-83b2a41b81cso176163939f.0
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 08:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730737157; x=1731341957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CDYQ7E7ZDEeGxxjUsJOPrxC4Cl48TsMateczArdvVgM=;
        b=wg+mwzeFMOujSaoknENWXD+AztZhW0+A6PKtX+FVGh3ehL1yREn+i5XtbsJZxYp/CW
         xio2JNbIUIpB5rgj4xPFQHR85thCfcY8g/yXRg9IAkZqv4Aa8cRrJ37NFNs6P7J+KLWa
         UnNkgkdsbda7Zr7tn51+KhUFxSXY9SsP7V+Lb1bDUs16ImsK0KWaQWh8sXkpsr4St7Rm
         6kyZXJq6YgaLMooaXn7S0r1HeTCf6tvpgLDgAhyWtvlzWPzfmiNu9blnBWHevIBIIfpm
         jYSjAgIbGSPsQJIrUYJLuUJhEGWS5fApfC/2p9sFrwyTMp/L69SacxwKOzDT0yLYdDJs
         7BDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730737157; x=1731341957;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CDYQ7E7ZDEeGxxjUsJOPrxC4Cl48TsMateczArdvVgM=;
        b=bG30XqeJLpWgrFHGFWBzrIbUNhU1rRPXSzip/EchYQXqRo/5AXwNiU5LCDhqyIOgUc
         eHtomCLPes7T+uXawPEBz9uNd3GCKwZ2SII7CbhfyeZOj3iKrW8DeWBE8oC8u/GJEGtc
         9ZQl/KVuIL8QT3ZmXolv7DFy1I06TvPmmAPzOIV4dDB8O1MjVZcuJYe3u82VNa7oOby6
         kK7CEE1iPO6pHBwmfMyxykqpCSLSwlNGuG6ZwPdwUzyaznxGB5Aa0yguBZLad5o+d/V6
         X3E2G9vHDNAK31BFY8W+unQHThvDIVIi1gQ/3Aj7gvJNxKyHJitKNHLwVyq5R948cICb
         K5UQ==
X-Gm-Message-State: AOJu0YwlIuhIQmKMIAbQE+seb+Wo0bX8Batdwl+lQaeuWLSvV+igFc5N
	7Fqn02/De9FPV1YlmBM9lV0mepkAv3VhL2Gv5tfO0r3Z++DjF7oww6NTPIN8M9+NfRpfu2hue5o
	11s4=
X-Google-Smtp-Source: AGHT+IH25ffzzQR4wII6PFiKqiPOvpX3cjjpjy+DbEgXWW9JdccXBD81ooOw5p8WslHJP+AnSaJPdA==
X-Received: by 2002:a05:6602:2dcb:b0:82a:a949:11e7 with SMTP id ca18e2360f4ac-83b7195fef4mr1360422539f.7.1730737157289;
        Mon, 04 Nov 2024 08:19:17 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de048c0034sm2006906173.61.2024.11.04.08.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 08:19:16 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c6c7a25962924a55869e317e4fdb682dfdc6b279.1730687889.git.asml.silence@gmail.com>
References: <c6c7a25962924a55869e317e4fdb682dfdc6b279.1730687889.git.asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: prevent speculating sq_array indexing
Message-Id: <173073715655.373322.5216435533915189395.b4-ty@kernel.dk>
Date: Mon, 04 Nov 2024 09:19:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Mon, 04 Nov 2024 12:02:47 +0000, Pavel Begunkov wrote:
> The SQ index array consists of user provided indexes, which io_uring
> then uses to index the SQ, and so it's susceptible to speculation. For
> all other queues io_uring tracks heads and tails in kernel, and they
> shouldn't need any special care.
> 
> 

Applied, thanks!

[1/1] io_uring: prevent speculating sq_array indexing
      commit: 16a6e0430fcfb38e80477a72079c84c612457e91

Best regards,
-- 
Jens Axboe




