Return-Path: <io-uring+bounces-723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B49866F1E
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 10:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB08B286FC5
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 09:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAEE18663C;
	Mon, 26 Feb 2024 09:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U7mFYZa5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCBA8595D;
	Mon, 26 Feb 2024 09:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708938812; cv=none; b=LA0oId/eqIJkrFqggjxECQ1CEs1YG1GueEpG7tZvhku/Ti2ouP9HBMbazkETWwbkTiDjzK9TEMutzEjkuAktYCT+m6XCDnXZz4ISgwt9vczi2n/u40NVMx6efK2yzwsCz7m/cALLleL/9JyYroFvLR6s4/TWDjht6f7JYGfE9/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708938812; c=relaxed/simple;
	bh=pBx7QtVTQeysuDVR/d9EaEwj6txM0TCtiMfoxBmnmgw=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=hmR0E4MQDLNGjnD14lA6BQizbFziD6k1FBlQHBIKHBQHqrfxUuhIOQ2bhYhTYbdrEhqcBwo/BeY0yiHFahe+OinpW5/jGPf0/lPtwMsZvZDTOruKRNXgGM1/HEU8iyy65TW0VHSR6y197NsdUlgIWQMlUQhyq+RFjCPXJiUcRZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U7mFYZa5; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5cedfc32250so2753635a12.0;
        Mon, 26 Feb 2024 01:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708938810; x=1709543610; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bkZF/uhLnyt4FCiUuL6SqgUagZoNjH2YpVQluDRw2FI=;
        b=U7mFYZa56jx+0arU0VPd/7I9FWm0bVpjTD3Bl2xUnmZrBnfVFX8gPYc0YOQ5FSxZYe
         XQmZI07fCaimsye7JQnLu6bk0dbFCESLlp+Fyo0uec4tpxe4G6d71LKsu9L//w30x/O4
         +7z7iAwgvTiP4PxHcg1u7JnTEEIyAQzhtMv4DkED5/zCVHxDQ1nZVrVZzwXasdoL8pZB
         AcP7D1JOw5HpQkatu8zA8QBo1xGdjXZcLjRF68M2QXj2eQEuQWLv/67rcZ+zIpUP2lvG
         xp9TPJAyOXbEWeKmofSDGFP/qIwxXXPew/kLAtji/QT8hhZC8rRVAGBP5JWJxrkNJN/O
         hioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708938810; x=1709543610;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bkZF/uhLnyt4FCiUuL6SqgUagZoNjH2YpVQluDRw2FI=;
        b=Yu94GRuJjGF54FMbWQEMkqbAkqidXyApgn0kVZMCovu9G78NMEfYK9yR0/YHRArCS0
         jPRS3LgNHP2et+kTu2NjQqScxhizdEyhmEmeiNMPcHwekf0fLTn8rGMbpT5yHbmSPhy+
         5NtQn7DAWeiToexUra4MLaHnCSGWP7kIlSqYoMrXIDjIRChv186I0CZzCEqvx+3O05IQ
         PnP4OyL3NnpYVixSTYw+mbwfI1/v+lnQ+bIA0wpwSO6j7YpnwxmaTVM7i2gRPsLHZlwM
         c8fleIR2xXgcjwDqxmSIR9rKaz8R+PAxyC1AdBOzk0I/VFNlK6uqnzlsP2+THTJeU7kT
         WxQA==
X-Forwarded-Encrypted: i=1; AJvYcCVhNwMxxoYF+Z9m/caDQ0UY8nP5aYjPllXi8a7Rzt7eXmGahoFabq+wLLz8gBWF4XiVZsWUT/LvwHQ3Ax88ct9WLKkCv/UuFF7VUewOeucH/YFyXGvyH+3pE2UF+8AYBe7MHjM3L/rDFDWXrFRdLySDVye013RgM3vCveH5ag9fiLTn+YUFYSSseivnTTxo+Qrbd2O2eNZ1HRNx0LESRcVO7vhFoemZk+lqvMtVabspq9xSro/B6uQG8QppX0mw
X-Gm-Message-State: AOJu0YzbID3Y0jIwmBie/snANu8eTabg9QFQfVwTRbYKzO5yvCIWjsjv
	titGk0PMvSQbvM+uglBxmm+mgCwu+tx/R1leVPaCYX1mtLQHf0G8
X-Google-Smtp-Source: AGHT+IFgXhWF9MbgjGJkxXDKVwsDxRx81p91HlsItwhw0tBZDu43SLV4vOCp4BHWcv/zSvBpEWa16w==
X-Received: by 2002:a17:90a:6f01:b0:299:75aa:8949 with SMTP id d1-20020a17090a6f0100b0029975aa8949mr3725385pjk.22.1708938810286;
        Mon, 26 Feb 2024 01:13:30 -0800 (PST)
Received: from dw-tp ([129.41.58.19])
        by smtp.gmail.com with ESMTPSA id r2-20020a170902c60200b001dc8f8730f3sm2491163plr.285.2024.02.26.01.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 01:13:29 -0800 (PST)
Date: Mon, 26 Feb 2024 14:43:21 +0530
Message-Id: <878r371tce.fsf@doe.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, nilay@linux.ibm.com, Prasad Singamsetty <prasad.singamsetty@oracle.com>
Subject: Re: [PATCH v4 03/11] fs: Initial atomic write support
In-Reply-To: <07537871-ab4e-4629-86ff-5559aa88ad17@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

John Garry <john.g.garry@oracle.com> writes:

> On 24/02/2024 18:20, Ritesh Harjani (IBM) wrote:
>>>> Helper function atomic_write_valid() can be used by FSes to verify
>>>> compliant writes.
>> Minor nit.
>> maybe generic_atomic_write_valid()?
>
> Having "generic" in the name implies that there are other ways in which 
> we can check if an atomic write is valid, but really this function 
> should be good to use in scenarios so far considered.

It means individual FS can call in a generic atomic write validation
helper instead of implementing of their own. Hence generic_atomic_write_valid(). 

So for e.g. blkdev_atomic_write_valid() function and maybe iomap (or
ext4 or xfs) can use a generic_atomic_write_valid() helper routine to
validate an atomic write request.

-ritesh

