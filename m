Return-Path: <io-uring+bounces-4503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10EDE9BF0BD
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:53:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CACC4281ABB
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67DF31CC14B;
	Wed,  6 Nov 2024 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dykX8oSh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF70E185B54
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730904789; cv=none; b=d9SQ0vSRJjIY2ZBnChygog+tfG7orcHEFJolIubP0aU567GVWMxmOWCfdZL14O0/7+xzcgI/4uogDfFsA5b46ey94oLdxCkWZVuD74Zv/0z3MLDBwCuLlavMFNr7Ih8Ykd35AqUfEOeh4Br/1Hnyd76TVOcOvnU9E89DA3f2Z88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730904789; c=relaxed/simple;
	bh=SkEpGSk9J8VZ0O4sBW+FoMCz92yea12tE6TTNGeSVGU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WemMGypgMU/53aSuIb0ktAqQHRhKNAjr147sKO9r4yc4JAr307v5cdcftZQC5EbybAMH3e09luLfjfnI1cdapcce/x57QhGDWSyASbCJGtEhbx66UooGOHgRbMhgSGiohKv+IViHzJFilZhdYVNk/k41Mf9vuntHD2+XAPegMxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dykX8oSh; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a6bba54722so18061685ab.2
        for <io-uring@vger.kernel.org>; Wed, 06 Nov 2024 06:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730904786; x=1731509586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=14X0tic3ya6tdgeGWokTZ1WeZ+HyOrl7EG5XHAc1WSQ=;
        b=dykX8oShUTLv/PlYCzL0kvIRH3pSNvAZyS9QIkL5Rx5lIkmgxqoa8d/tNdxO0NUiVY
         rsEDxeuXf5tlLyyDHXmHjgB9aUcRPbs9yCmLeThuwvqhBRqXtmeCMOCeqCn8u0CukOp2
         vqlCZPGvnT17rJA4DDpHtwtxp73MisIEdkWCzSGmPAz6Ug4gkXQvqQauHD4htrk3ogFz
         KayGvvMHJuRMgm0nslxyniAfPlf6eysWR+mLOye3gXmHD0Tt1xpcKAky/2V8W37vmyMr
         61sGxtnvDaiK3VzPGg/g5BjVnAliCmlpWYawZHrr10IIbv3cakHWRUEMqJEtQ/qH83WH
         V5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730904786; x=1731509586;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=14X0tic3ya6tdgeGWokTZ1WeZ+HyOrl7EG5XHAc1WSQ=;
        b=APGk3Zv9WwhLRAHdw6yrW2ArmTQLkJjF006CQb7SlxF4/iJXfrfF1zMYQ9oBRBdwDr
         RGoIebJktaqDVTZWIPHPHkemj4/ivCRgfcGb24BpB22+5SoBhsJA3fcWY13spmRi9UPj
         ta5jlCQwWODQ+3E8xfD6sYi433CIKU7Ef3F474fPIQIDW+VthhotvKprUiflJBHdCNjN
         kDG9lHOvHDRXk9Z4uWPBIxMZo2oaeT23cDrOUQP25f5jNPAbNA4wtNQEeacFAyhcuiPP
         M3hQKQGpemd3/yMJnKuKIaptMzvl+qo8BcAlZpVCZ7dJbChK64a8TbsfLDDc3j3Nupha
         suVg==
X-Gm-Message-State: AOJu0YwUpSu+PJ44FZwzReKqJB5UwYP+OVt/uJcnnI5FnCtFCaIjHbVF
	BVs9UGx/l5NkmohJx2ChqwYZj6ps8Y6YnJRvsnLzdIBTdyAiuVC/H/Eg2pJ+mGogwctXMCDqMmw
	KB0E=
X-Google-Smtp-Source: AGHT+IEWOcl03ADF2NrjMzBwhdxWmrmJDavcbtqqgvyg0OZOycS4aLryV4sZojczI9TN0fRb/JV8tQ==
X-Received: by 2002:a05:6e02:188d:b0:3a6:b360:c6e5 with SMTP id e9e14a558f8ab-3a6b360c89amr201532215ab.16.1730904786314;
        Wed, 06 Nov 2024 06:53:06 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6a97b0137sm34117025ab.3.2024.11.06.06.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 06:53:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <20241106144545.6476-1-haiyuewa@163.com>
References: <20241106144545.6476-1-haiyuewa@163.com>
Subject: Re: [PATCH liburing v1 1/2] .gitignore: Add `examples/reg-wait`
Message-Id: <173090478528.102328.15211722428340936493.b4-ty@kernel.dk>
Date: Wed, 06 Nov 2024 07:53:05 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Wed, 06 Nov 2024 22:45:27 +0800, Haiyue Wang wrote:
> Add the built binary file name from the commit for clean git track:
> abe992c56178 ("examples/reg-wait: add registered wait example")
> 
> 

Applied, thanks!

[1/2] .gitignore: Add `examples/reg-wait`
      commit: f8375148e1a58f11b10030d1fa593aa369041b90
[2/2] .gitignore: Add compilation database file and directory
      commit: a27cad82c6c1ffb4a387967ff4b088509e10303f

Best regards,
-- 
Jens Axboe




