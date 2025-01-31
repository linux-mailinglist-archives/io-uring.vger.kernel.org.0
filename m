Return-Path: <io-uring+bounces-6209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5D91A245C0
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2025 00:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB1493A7A54
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 23:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42EA1B0424;
	Fri, 31 Jan 2025 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f22m/RUA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D0B199223
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 23:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738367811; cv=none; b=BkE2+cOHsm6QUyS8yZVFGMhHwjSLsm86ET46Di5qhevwhyDw4qrNQOecDFCA1g0zH24iv7TvTKZp5nmIHP4ZiL9gbTBbOj3LXtBxot+28xcSNkCCH+/e6ZLAvnZzKA3757CJ+FdqJYYM0YNad1XqPD93prMycVdOgcWXEOeChFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738367811; c=relaxed/simple;
	bh=keZ04NZwH5vqAaBSquzIGX6HK8sfbk4PBFOUHk6zhu0=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dy4OrcbWepL0pHNA96PyefSyhXkxEUSIsM4oRkhGGekNm042a7PobMls0KRdrN8mpfYLNM3cIWH6nNMoQDUgB6O/r9cngHwj8oFGZct3aEBu0SsWXJ+m1XlrXYv03EJRGOXeAe+THXWOF8n351M5LFaZyG/8WAuITRVZXalZ2JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f22m/RUA; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-844ef6275c5so64630439f.0
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 15:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738367806; x=1738972606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XwHunotkbu2jrDVeXzlM6ZCQqY4//plAMr0i+7HN9nc=;
        b=f22m/RUASk4LqtpP2/6Kbcq8KJIxAo0ccFmULmb0Dn5zhexo6VAGxoXc6u0d00JpWZ
         vgUqTirKWTtrk73SF1GawSDBi6f2Ittcx3Wk6JWt92gA7FIthZIwxZMMYq7b6xnRbEFy
         hgKyq9t2m7z5eOnbu2wck9Bk/KjFyyY6mJFKgxYQsotz2QiwLjNXObefTKM3eQEOskYB
         Axae69xl3IcvojN3vfEvRYhullMv8zlo/2lkHs6obEPm1l2I6uCOB68lgyC+9Kur09GU
         u/oUydCOU+HVy/nmIVB/iwsp30ZwaA7kTQmpoVt/sZD8eeRuwszVG3RsMGwTyxJzbpD6
         DRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738367806; x=1738972606;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XwHunotkbu2jrDVeXzlM6ZCQqY4//plAMr0i+7HN9nc=;
        b=pdnfzygQXUwadq/f3t7LYyIOmkeDore69IcbSxhF9oBEV/Yl4Z44wWaQbrT6wKpYUG
         k6Zym0+7gEiR3Eff3t8J/n0/g5VPegifeJxhNi38XfoiUmLkuAFmOiHF5D+R5TuV5D8Q
         4ov14cJetkX1Zlgq2YMrLnw+FaGmGa73bTbZ8aKwDZ6BIKEXFlVZ/tYFrdPdW6qdJoes
         VKpxP3r6XWlHLT5wGnJqiJq+j2hF4+aGJa7PIHfuTuu33LOFUDANEEjC0AS/afVagi5v
         W1oV/kReHK58ttkrdEsUIFndpeqptSTt+kSmy4jTgvQmQBB4V3o1pEKn8rr/SpwgZ25w
         yPfg==
X-Gm-Message-State: AOJu0Yxawy2jNYenGOfZxlLWh5ghvBH6HIHBMgVsEQU1HPiyafvI287q
	/SrLi52GgEXCjmRYF3gpYRg7GZ7hhXxl8a2SHeXKaOm1CU9dRpj8MdIwEBA7OVLIQ+0vKDPuCi2
	B
X-Gm-Gg: ASbGncsWaiEl33ikL6ApUpR300tZTwKftFERKU7uFmMX8o3/iO/BRFJzL51S3D9E8UQ
	YO16zqWCpDwP6GC/oi4RG62++gh0FkYf/fgu762e6lyhXn9W4qQKLkCTdiJbWeA7mxFGISi8w2+
	SER5niuX6Sg9DlimwzycKIYrSXirzlL2bHcxLNe53rtrGFYr76a4BDeTjh4Lt+fo2GDmzhi/1bT
	Aut2wEn0X7c1WLvqcMr01znVdxQibKnr0pPEu9cNBvqxGoQidEnH16e3NzzM64ZSfyJ8DAvcPrV
	fKlkalE=
X-Google-Smtp-Source: AGHT+IHVmrgMTuEcd0H7MHB6I1xCRFgZ8RqRms5l7FATRkpFxN8gJmLECoWlLoovdmR7qZvj0fkU0g==
X-Received: by 2002:a05:6602:1413:b0:844:cf31:622f with SMTP id ca18e2360f4ac-85411100b70mr1174717739f.2.1738367806192;
        Fri, 31 Jan 2025 15:56:46 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c914bsm1051363173.126.2025.01.31.15.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 15:56:45 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b6b0125677c58bdff99eda91ab320137406e8562.1738342562.git.asml.silence@gmail.com>
References: <b6b0125677c58bdff99eda91ab320137406e8562.1738342562.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: deduplicate caches deallocation
Message-Id: <173836780528.549412.8349577250816134309.b4-ty@kernel.dk>
Date: Fri, 31 Jan 2025 16:56:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 31 Jan 2025 17:27:02 +0000, Pavel Begunkov wrote:
> Add a function that frees all ring caches since we already have two
> spots repeating the same thing and it's easy to miss it and change only
> one of them.
> 
> 

Applied, thanks!

[1/1] io_uring: deduplicate caches deallocation
      commit: 851266f05c24c3f804d9d5771ec62ad74e0bdc67

Best regards,
-- 
Jens Axboe




