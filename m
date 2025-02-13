Return-Path: <io-uring+bounces-6422-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A9AA34D4B
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 19:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEE38188214B
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 18:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7223224290C;
	Thu, 13 Feb 2025 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ppBqSny8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D6124167C
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 18:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739470441; cv=none; b=uM0bKiwJfp2EuEwOjUD69VK8EbPCoIQQbXiFdTngBYs+Z38N46OD4FahSzq/1TJofPaxpdd/fAKpFx0tIP3QTs9E211KdkFErCbXImp1JC27SB6col2ZHSA4dqXB0GMEkTUfSfPR8ozpTqFRDt+sXnBD6aWLUHUNoE+f9561oxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739470441; c=relaxed/simple;
	bh=3c3bvXhfbs2+svQ03tljcwAk2+viKby+pacKrg4aujw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oQnzELw+YTV7K3h9LJXwBVMCbDOfZcI6DaudB0k9NMx8N0bTT1/RmrmY3x4Y5oqh5AgxWbwfjtZ+PQ4HqExQM2huBIlEw4Oz2hxegHR3tCju8NZk4iPuCc+nP4QsgM+G74sDIpV8cOSs2E2HKSlwDs4Xsr+RCic17Z56bEO2too=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ppBqSny8; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-854a68f5aeeso16575639f.0
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 10:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739470438; x=1740075238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0u10+02ANAVXQAI3H10nbzUVuUAZKGFVxn2w4OY09QY=;
        b=ppBqSny82ZfaZIN1zhPTUj/AekRMb9oHkoxaYbEKPeC28hCxE//kTTy5/h7fn8FEu1
         +IzJArl0WGrqisOk/nQIqbslafw3n6+Icts49wzZ17rSIl3AmYJNlXTfgNV5IrtXdMT0
         Zt0HIRKu4YJVZ5drRD4x78GU3HTsop0QtXBvRfFmhv0q7KcbI6nZaapoVeqH8QbOTUZZ
         ZkXrK2JjeU1VP1H/cwQoaDZrdXALU8SkZsM0Wn9Z5UwEucEXtKJFYUdVMBiuFoBthFpG
         u/RSBcd5CysUephuSuEinzjIlfKcS5UQEGKeRkQBhwWDJ3oPFLOFJMNZRA5EQehbjsOF
         QZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739470438; x=1740075238;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0u10+02ANAVXQAI3H10nbzUVuUAZKGFVxn2w4OY09QY=;
        b=qNcgN4D6cUh/fl7V2+x7BOUe5bzBiTIxGEE6e7kqA5zKhZH2/AeatNAGp+2+vrzNeH
         gBBN1/+TQMsjFZ0vaU6v6ZnJr/pPHT1PlqacewmzSItZLMjXE4nEaqthJ0UKtL+1Nalq
         7ifYmL/7UyPQu+qD80a7M6oJZfSyLcKPK3FGHNedxRv+5ygiBnmjthQ6Nig40dprWV5R
         SExoZiJM/fcU5/4/X3wxIc6cXHhm4NkpJ2rF4yh/t+VwIYb4rM5f2N8eAIHHkG4h8F1e
         1KC/P5MJO0GPOPdHsGlwHgtQJhlFlCsVmdzQbbOfBJKgmuqcofyNicU/JqmDFuoAF5li
         zWbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeDLQuh2j4cXxCPc0pG0Kz9Rh3SHyYVz/hLhv/MsiViu+o4Gt6mW3yupbF6LO9IsDujBn0enP2dg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/Ugn1iLyJWlMrq07ffiGO2RTuBfRMqRuTEmO1PXe6Xz9+n+kt
	8yzPjv5mh+GC/B8qbTvcRUfATMi7qHxsDotLH0MZVrvlNEDUbxXYsGsCb7s8BVo=
X-Gm-Gg: ASbGncsrZrJ1b25II/7CQRNatW3kvF+PjBZH1GVg/2Xm7PySaQ6WUm3naHBOLYSfMP0
	gMPKiAjmP5IcOOMShOa3XOJRYEeDq+xKLsVQcLYf45Ja7A7T/cxAgOKVGJPPD62CRRz4Roa7OVz
	nJmNSqrGXrqsds+GQmHOPORrCC/x2XI1QxDEALGVGFotvLSoSrjhphj6Ui6YcS5rRPC6iPYAflx
	ihtfMXaJkQXeZelzZjzMNv/DdJuM2xSSq7imQAAH2QW915DeLuK4aS/tIK2NhuSoH5HCel4ycLF
	KgGHlA==
X-Google-Smtp-Source: AGHT+IFXj4gYcC0ESqNc1PQEAesIl8kIS1EIqIyYi5yopDv1rS6HaXpMtky2M+iyueMbjQExv26KTQ==
X-Received: by 2002:a05:6e02:2186:b0:3d0:ca2:156d with SMTP id e9e14a558f8ab-3d18c2ef911mr31381195ab.14.1739470438223;
        Thu, 13 Feb 2025 10:13:58 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed282dd0ecsm420764173.125.2025.02.13.10.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 10:13:57 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <20250213154452.3474681-1-dmantipov@yandex.ru>
References: <20250213154452.3474681-1-dmantipov@yandex.ru>
Subject: Re: [PATCH] io_uring: do not assume that ktime_t is equal to
 nanoseconds
Message-Id: <173947043689.300246.1804473668286639556.b4-ty@kernel.dk>
Date: Thu, 13 Feb 2025 11:13:56 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Thu, 13 Feb 2025 18:44:52 +0300, Dmitry Antipov wrote:
> In 'io_cqring_schedule_timeout()', do not assume that 'ktime_t' is
> equal to nanoseconds and prefer 'ktime_add()' over 'ktime_add_ns()'
> to sum two 'ktime_t' values. Compile tested only.
> 
> 

Applied, thanks!

[1/1] io_uring: do not assume that ktime_t is equal to nanoseconds
      commit: 9bdc384a837b366c2a83bdcfbd97584ceba442c6

Best regards,
-- 
Jens Axboe




