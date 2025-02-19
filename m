Return-Path: <io-uring+bounces-6559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA487A3C35B
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 16:17:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF5057A5569
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 15:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF9B1EFFA7;
	Wed, 19 Feb 2025 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R75FE41T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D990D1DF25E
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 15:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739977681; cv=none; b=QyYqL65iqC2Gc3fIwDL0axrfqq8nAyYcbLhmD8SGjMJ97by3VQi1rZ8YJ2a1sb9e7i8jmd9QGt4MOVTF72CJt4Gx9JBbDPRfKEXmD7fR/ctcm+tM3gpMOZKQIvPaXVNSL8AVdL0KFX4DXF6qk9TBL4mMcB2bRaAK0NkgPxC8zE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739977681; c=relaxed/simple;
	bh=3lq41m++tDlGOU6Akz4gxc8tubDn99qSgM/jWGcMFyA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XRPW/KXulz2nuyvpio8QwnEhma+dbRWg5c71NnnMIda8sNfIlgz2rEwNTn4ZqT6PxopRIPFWtgPA2mi9drvFtqmN3UyYNGPm1g0h0iGy5B1HENBtM5R3aEn7P/v+cdsy/hZckmmI7zMeiAUMiNZ5oLMef4zbQt1fryTx85skMEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R75FE41T; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d03d2bd7d2so59817695ab.0
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 07:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739977678; x=1740582478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4wlZXQ29J0KLzfoFA/S4YOWGeZCzGqzVfgRPXH+FG0=;
        b=R75FE41TY46E184TFgoj/AWEsVD6spc+cMpAyw0/0EVXi5hYf2ZpXxZSqG+UltksdB
         6luTso+ipQ+MdOm/QaV81p/QXI4WtGSOQfU4Ncq0niPjgVGXybPPbUhsjrkuilDBTGZ7
         7NsxQtb6qaXGq1YmkTB4Q1TQ1abg0XzwEFsD19wyvEuIeJvckJ5sLXOGVIAudVj0DOJc
         xp5wkDqLsivS8dYtpSbPXjyO6n22qQJJ1Ir6bGseuSKE84M/k/QU6lnbgNK9xr5lGdtD
         v6Bz4sb0S3Ryvc/hLhlDUbL7rjfhiz1MiMpA4uzbVqoO5mnmoN5+YM1iJk01pBvdOtzv
         fMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739977678; x=1740582478;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4wlZXQ29J0KLzfoFA/S4YOWGeZCzGqzVfgRPXH+FG0=;
        b=vZ3VGfnxjbDf4as4FQGm7RcYf4egmixgyDkFdPIhpPkK/mWXx+PDVa/YlynlkmB26n
         Q3sJh62qtksQZLQQ+iy3rsNiqFO/5VGXhuYQTjfCU+ba1w89RfzvxCtRt9W/aQiWnOqJ
         cVtdmCoQRj7fYNCrsCWcaMMBurDEQqVqpaULMeiEmNKasSsmYsicleVeA+E8mGHYOJWL
         G8a01zW2k7VGZ1vUskALw2QbVt3WO4ZqYzNi7Pmb1Ax+y3tGO9GceJkd2P262ozj1KIV
         XASM8gB4So4he27nELt6xgf0ImAK+12ayHgSWQH0ZO+2DBs95bu7MFj94O/QMZMfrwVo
         iYlw==
X-Gm-Message-State: AOJu0YxzTWxJxb8HIcCPt5Ae6BgPfW+CttVN473xrFFVPsKQuiH2+o2N
	7uTa5eRfPBk/fbwDBzx/N76GDsTCQVRUYnW2KEuY7lo94xjIjb6UBc70jEkWERx50lb7LXGqV9H
	r
X-Gm-Gg: ASbGncuO+9Eaq4s8ZFjecR7FqdXJxLPyR9JoS5e5n2XdSs4/WXWqaN0D8XYhmq5F1cy
	pONmIHsHp5Twu4INtRqmm2T/F03+waf6c7kHodTSn3jmree16AvvqoxrgjE8RuhYxWQpuJKHGaq
	OOYqrQd6X8rGsj7oEMPfirp3AUUqeo+v7ESe54CUkwF4TfHhzt4ticmyLXs6W0jwIuaBL3XWYI4
	mCS/kZCV5T6pbFvVlQ3/yTrs5vx71VOWBZViWFAds7oDw3Z+qkwpBaT7y6ga0737PldSN+gAGm4
	CaHAnA==
X-Google-Smtp-Source: AGHT+IGVuowphwcXS+KD+EXWIOyLxmJD64RKMOLn6G6zgIwPTKs0zECin0ZCKXU9OYX+PHOv9jVXhQ==
X-Received: by 2002:a92:cd8b:0:b0:3cf:ceac:37e1 with SMTP id e9e14a558f8ab-3d2807b90afmr144434795ab.11.1739977678424;
        Wed, 19 Feb 2025 07:07:58 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d2af7f8371sm6678025ab.0.2025.02.19.07.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 07:07:57 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Kees Bakker <kees@ijzerbout.nl>
In-Reply-To: <905e55c47235ab26377a735294f939f31d00ae53.1739934175.git.asml.silence@gmail.com>
References: <905e55c47235ab26377a735294f939f31d00ae53.1739934175.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: recheck ifq on shutdown
Message-Id: <173997767736.1535694.13797040050002730545.b4-ty@kernel.dk>
Date: Wed, 19 Feb 2025 08:07:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Wed, 19 Feb 2025 10:08:01 +0000, Pavel Begunkov wrote:
> io_ring_exit_work() checks ifq before shutting it down and guarantees
> that the pointer is stable, but instead of relying on rather complicated
> synchronisation recheck the ifq pointer inside.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: recheck ifq on shutdown
      commit: bc674a04c47cc23ad7e12893cad6226ea8f7a8ec

Best regards,
-- 
Jens Axboe




