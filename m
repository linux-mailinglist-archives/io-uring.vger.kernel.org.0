Return-Path: <io-uring+bounces-8760-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1140BB0C466
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 14:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 440E817E0A2
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 12:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4332D46A2;
	Mon, 21 Jul 2025 12:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rLG4dNiK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223BC2D46A5
	for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 12:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753102127; cv=none; b=rFw8TQtLoLeoZg71NsqIFFqQjN2C/eXrLJrXbSZlDKjq6qWFxaFVAxtkWGOyNQ5juo2zD06sSMp3m1PwStHLd0Xspxj2jRS0qzrk9/OIDyea3R77bUZxS5f0lxvuZ+n+MZ1n9xNoZcPWYONRHZKDQsw5orF8Bs3JDnr99TcbgTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753102127; c=relaxed/simple;
	bh=9OjWszQfpEhkxHmklt0aYmA4DKvVQD4sEUEzDYz0M+I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Y4LlOMCxLybWpUzYDP2KyVINYLyIS7S1/0WQzzQfb/aZekwrLT4BV0//5JhleE2iehdZCfoLZs6J7h5u0aZBOEFM9IfJAailP8a4rR8PSo4+cT+JMK5/6WO+cqPit/5Xos4HK82sMHX7NYXy3R43hCRDrS3/Bu/Mnirx7E/mDIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rLG4dNiK; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-87c26c9e8d5so153890939f.0
        for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 05:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753102124; x=1753706924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h0bXRUoxm18DlhVU/AuovW/qI/q6IuvSC0tYAIIkXQY=;
        b=rLG4dNiKMljcViRSNZeVc9vqLjaUvBXKahiVknJcKl83ne1EeY8/69YgzNFH1m9EtN
         XSsFuChQ2tH1Nl+SW3QnfhX6l4ssQqCvpwaZM9/ocMhSgRrr7S+dImRijlAlyMINCDXe
         wCuxZT95ElESk9A4xZp/+mbIcrhciuTvl+4vRAYU9QLhDIChJ01PnktozPaiJXMHlsR0
         Whr+AXIG6+y3e4eGU+Hy/UspuvlLrCY006r9WTjo97Wzk4+dGp5G75WXZ5OO6YJ0MWgw
         JhxavIaHi2WaBRW6/RsCSeTOB4Q9Dn7PS5mKadwFT0ILnXS/Vh81dKMrf9+VQg8+a3eV
         VDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753102124; x=1753706924;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h0bXRUoxm18DlhVU/AuovW/qI/q6IuvSC0tYAIIkXQY=;
        b=ZMW2VQgaLwYu9NB/f6jj9ZTYAj2xjK36XYCTwLgCV1zClX2KjhdTJoa1q7H/XWXtG/
         t+rblOok07fvTMB9IxuK+01jVgPI2ZmS8cODPDbLaucaN+byG5S4eRUEAEMX4+vqb6/d
         IykApkJtNQtgSNBuL+U1aolhTXSspxhbx2Q+iFFY7mOKRsxOw96UqFLC0LpF/VV+CFG7
         b9Z9whKIhPSXrRuHkzcLNxIXgBHLh7zZKgHhbwL0HduAdcgPCoWy91o5m4H/TbOiwfuG
         4ko5jEWjqBBVikvjQUuBIFzG0uTEixZXQeH22rgidyEoCrFRLB9uXpO0cg8R3+pBSZxc
         7mRg==
X-Gm-Message-State: AOJu0Yy+NbKG6PwKw2FFSZ7D3d/K7gQW4/HkDai3g3wHh9JfJISoXv7m
	/TmTvLzgnFB28I46Ok4jnzhrV82c1Sv6zJeJyWIs4Wj1kfL/RjeBGXXoXQzUU/g4idk=
X-Gm-Gg: ASbGnctWDCE5iInyyKJmTaJZRweVDlePEGScJfIPs7DHeGtEfP/K1QsxVhPBzj3j8lh
	g9A0SOnQPofeXYFrZXe86Bn7+eMBlVaVfOZBFCe9/OqYTnHHkP6DohEyP1CzHBPCY+df+IPgFyo
	J/ICOo9M5hnNih6hDHJKXlkxG342YBxNvAGlgGDk3Ave4WEhW7qlVRJb3rORAT6ySBE7+o0yJyo
	RQ8dAFEamZoRQQ/W5IZnCa0KPitb9I0xbvzMQNd6t5cR0qtDjMcsHG2p9Wetop/8VX2u7abcJTX
	V5e7gds/FiSomCzdZLjuBnEAhvuSWZb7i/OKUe3EZY7wGt9Q0UaeJPFqjYYJuXzPqmo1qNltlAZ
	PZBj1TckBW76wQw==
X-Google-Smtp-Source: AGHT+IGFDVNOFgHH4oCrdKmkiQvGS1rVmwHXtf8uJdP/CrDGQImqRIeo6SXgiqDpDexbIWC+Iod5Aw==
X-Received: by 2002:a05:6602:4894:b0:873:1cc3:29d6 with SMTP id ca18e2360f4ac-879c294fc6cmr2774986439f.8.1753102123847;
        Mon, 21 Jul 2025 05:48:43 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87c0e74d059sm205787639f.39.2025.07.21.05.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 05:48:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: dw@davidwei.uk
In-Reply-To: <cover.1753091564.git.asml.silence@gmail.com>
References: <cover.1753091564.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/3] zcrx accounting fixes
Message-Id: <175310212193.555365.4862164036707301228.b4-ty@kernel.dk>
Date: Mon, 21 Jul 2025 06:48:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Mon, 21 Jul 2025 10:56:19 +0100, Pavel Begunkov wrote:
> A follow up on Dan's report + patch up possible page leaks
> in io_zcrx_free_area().
> 
> Pavel Begunkov (3):
>   io_uring/zcrx: fix null ifq on area destruction
>   io_uring/zcrx: don't leak pages on account failure
>   io_uring/zcrx: fix leaking pages on sg init fail
> 
> [...]

Applied, thanks!

[1/3] io_uring/zcrx: fix null ifq on area destruction
      commit: 720df2310b89cf76c1dc1a05902536282506f8bf
[2/3] io_uring/zcrx: don't leak pages on account failure
      commit: 6bbd3411ff87df1ca38ff32d36eb5dc673ca8021
[3/3] io_uring/zcrx: fix leaking pages on sg init fail
      commit: d9f595b9a65e9c9eb03e21f3db98fde158d128db

Best regards,
-- 
Jens Axboe




