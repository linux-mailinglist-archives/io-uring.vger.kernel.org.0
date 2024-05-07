Return-Path: <io-uring+bounces-1800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 573B58BE097
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 13:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CF68282BC3
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 11:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7112B14EC65;
	Tue,  7 May 2024 11:02:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7E2AD5D;
	Tue,  7 May 2024 11:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715079737; cv=none; b=I64ryCKd/sKa+gSwCq4nEbzkwGgCgotWwXjmTrznEidtTm9eIxoJNqKIt1Z3m0/ID4a+xYmnsWZ9ANrMGmOIbDCZMkPLHbeVj4hQpstYkzwurhISsoZE9a6jdJrGdSSmv3g2/xhTzDcdKl/xjzMCMLBYPx8Gd9+0YtmFGjwWZe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715079737; c=relaxed/simple;
	bh=OFNcKTuigThm88GXVq1hv46mjGok9ClesdDS/dpy9ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/7eNwd/JQRbPbmDH0Vwe6PrTwM9oYWB1xvRIybcZ695idfBWWIjiKbW8zZ4mVpFejQRbUQLiyBQcAOoAyVoCWZR1qD8uZVpIIFdSnzNiS0LDlQzma3m318/taIDHh8aeiRgBp4IohDmyKpER+8fA9Nw4Vk6CldqQITet4+H5AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2e0a0cc5e83so30632041fa.1;
        Tue, 07 May 2024 04:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715079734; x=1715684534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQjyvJrYO9MeA/kKQ7Uvlb2YTrpN42sO/TKimTs1Ssk=;
        b=JEEh6l0BlkErWofs6n0hekTYLJ5WzBQTb2yxOmTtHFdi8SJ8/kqdYZC+E18MOtJt64
         RjqWdhg9C2af1ujyVcQ7xj/X3bKKnWFkMqsKmbr45L4pN9+KkPxdynG+LSfz6GKnQ9e/
         /3i5B368TuBluOFvMQG5AmmbbkZGhXo+NUxyeMuy35eXvOBdmTl2e0qnptgsX0PfXrdW
         7mMrnWkiXSJ3NdZIvuAelJdRdJbgGdkkkuM8/NO0zLunRWpozGn+mrlV3eDo+f1DglN7
         XQojiLR7zFVhc960ylwVZSouF+4QA6cyuO2ojggNGqAOud0+D6JgRaa6PuepnlVwDMra
         NkuA==
X-Forwarded-Encrypted: i=1; AJvYcCVMYRyRkwFI2pF8IhDdw+Qb1AB/yia+XSHZkwgBvvW8NydUBEAat2xcvHI55KUdie03Si61m+5UCal2nd+4V/RE/P330a0FJDnLDa5A/E/inPut4jEUWVse0Kqldd0FGjEudGI5ppw=
X-Gm-Message-State: AOJu0YynVcYKmQebl/DGtt1mEjKFA0ol28JsAA3kAkNbU5LOKB7L3hLa
	+e2q8n6PLPLJn83jo7plG0M6/hZ/O2stTWogAWvN8bZ/lnbIc9HQ
X-Google-Smtp-Source: AGHT+IFYT/iaZRejWF2I0DRKTC3Z1oO+E4I6g+OD/MHtADua4dv89mWAstpYvQHoh1AArsFw7jimQg==
X-Received: by 2002:a19:5e1d:0:b0:51f:196:d217 with SMTP id s29-20020a195e1d000000b0051f0196d217mr8374014lfb.63.1715079733769;
        Tue, 07 May 2024 04:02:13 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-008.fbsv.net. [2a03:2880:30ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id c17-20020a50f611000000b00572b239c79esm6508496edn.31.2024.05.07.04.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 04:02:13 -0700 (PDT)
Date: Tue, 7 May 2024 04:02:11 -0700
From: Breno Leitao <leitao@debian.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, leit@meta.com,
	"open list:IO_URING" <io-uring@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/io-wq: Use set_bit() and test_bit() at
 worker->flags
Message-ID: <ZjoKM7ro0wDqsdWP@gmail.com>
References: <20240503173711.2211911-1-leitao@debian.org>
 <d05aa530-f0f5-4ec2-91ae-b193ae644395@kernel.dk>
 <ZjoGJH1CEk+f+U7n@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjoGJH1CEk+f+U7n@gmail.com>

On Tue, May 07, 2024 at 03:44:54AM -0700, Breno Leitao wrote:
> Since we are now using WRITE_ONCE() in io_wq_worker, I am wondering if
> this is what we want to do?
> 
> 	WRITE_ONCE(worker->flags, (IO_WORKER_F_UP| IO_WORKER_F_RUNNING) << 1);

In fact, we can't clear flags here, so, more correct approach will be:

	WRITE_ONCE(worker->flags, READ_ONCE(worker->flags) | (IO_WORKER_F_UP | IO_WORKER_F_RUNNING) << 1);

Does it sound reasonable?

Thanks

