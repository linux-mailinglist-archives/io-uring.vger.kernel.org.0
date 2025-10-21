Return-Path: <io-uring+bounces-10092-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 932D3BF900A
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 00:08:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26DC6562C8F
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 22:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D61D227AC3A;
	Tue, 21 Oct 2025 22:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Anc3c4ig"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A557F269AEE
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 22:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761084489; cv=none; b=CkkKElL8vDO5Co4KUqqP8YBubpkATGznSrQwUgYmj3YHNfcIf5WYtfuymX3OYUcp6mNmlxRVk/LPmtM1C45kB4EyWh92++Temm+HhASpQascL1bQ8qR1dGqWPdFwYXSoxUICxE6RJ0nfsNXOy25FmBEDYJV5naf53AsdJGYeAbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761084489; c=relaxed/simple;
	bh=Dzs2iBYjfSANAFJiAzTvEE8O5R18hfDAFJcKHMEJ0Ks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=isiuSVcNZVJa79Ch/IGrKA/V/KOo1zavxxCJmaSMS8q/7Z+MhcjdpsmdYHs5JmO4XeJ4PjTvdSdNHooQCXbBYyUxnVegzni1QaMJMK7v6BUNg0TUafR3sFx52FbW0kt0tXnLzQaXLz9eWhZIc9q0RsvYWmUn+f35SFtFmqUxu/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Anc3c4ig; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-940dbb1e343so17912239f.0
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 15:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761084482; x=1761689282; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xkup9Km6rrC9gWntwRFUUAenwl8EUzZwijYNOVKfHgk=;
        b=Anc3c4igMiOu663whJiKJ3gSeX65Yk69CzSNEAHrtOVq6OYVJBffwCj9ttv7L5XMa6
         B34OKZ4si2Hw9WojY5p/UWCHaxr1Kp6AB+qeSxoIE4UiADMOALwtLxzGjhGjE30GC4MF
         1fWf36yaQ2ZaaGcmF63AM4iL7SKZu326wYk8ItS/mOF4mz4K0c+bmINjBCofPhx/74dz
         NRfzg+goyTKYiCRj6e/I/ubQwsFETliqB4anTQcoMNZ1szIMaQ3if83LdmAlGBraHy+5
         E1CYjGo1fR+MUr3ZCbR2kaPGr3HnHRTNZNIcNjRMhdk0EtehqST+JI3MiBRVm5LkDHo6
         J1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761084482; x=1761689282;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xkup9Km6rrC9gWntwRFUUAenwl8EUzZwijYNOVKfHgk=;
        b=onERL2Q+fF+PNHbBs9ELv4eSLJko+cLOVvc0f1BwXLnkbMM1ZZtW0igDRofmZddFAG
         LhDVqC5Jsg9R4iqa2VyZDcGQTkSzVqiwaG77Dlxj7/+9KjPfFPMJFC8VaH0d0EKUfBNF
         ArBXgv+P4USL3s3sAp/CuJmBr4T9MY3PLeMl4mAZWa38pdi+oFVRNqIGZWZRGQf5mBIG
         ckDnq0Aq9ORBulasYxLARUun88ocbgGK8siIT10l8Dox24EmtigZYBM6udiDCk/yYqA+
         NRXIqrfOTuXDhk7KhwH2pCQ2Ykn+CYXP/qhqEDHKe6pFk+ne8lHnrDgu8zhkh6c7l7s3
         IwxA==
X-Forwarded-Encrypted: i=1; AJvYcCW9YB4J7EAy9J+6k5xyxjgDo7SjVy5CDXau0fve3XFGWG877DvcD7bKD5TNjdA3jr4BVQDa8ct2HQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5oklIsi93z+t2y0T3Kn36ewJMn4GR7oOXXS8LJeDYSIXoU+nq
	K3dS6fcaG2bjmsmwMkaTchycgq0iUOTvzCefG4S2b8kZZUhh4/+w2KyeGG5bIuyP4q0=
X-Gm-Gg: ASbGncvwi9D5pKKOtv64koV7/EIPPZ8zznxOIeJP79hEFZgsb4RU/kWAWE7tU5ZNPvu
	WICI7UlcA10AlCl6zEMe+iPvP4xkrXzr3orrF4fHMqWKAkGM+nmCNDk1rso3d15UND3KMey0wOl
	yVxzgnuyEK7bgF1TWkGygHL0kB6zlCHqYemF3ZwKElwvQhIsuELEZBqs3sayczUDBjfR0lOgtSt
	15MkIvLOtbqkNjPOxJrgiI/jR1ULM47Sof0wkKQNOO5t6x1qnFlvTnCE9TAk6x8nbJ2U3xxJLRk
	IuXPKIqaSs2zAJRZram0wkrQM4WaQz/Ko/pQUvhYO8qQRe+Z+emH1prxl30r/hJpm5omR4CLyxf
	qHCasiFtrgqDA3E74DbLRAm8Ef1yklr6KZWIkzYLoSFhiDgiUDBh5twbhSDzbKsDTipwEvLWGar
	ARpyooV6M6
X-Google-Smtp-Source: AGHT+IHTKRHWv4hrG/WfGb4GvjwVfFxk9/2lRmk6VQCydGgLn6lsFRtT/UbNr1q5H43bdKcFdka6kg==
X-Received: by 2002:a05:6e02:338a:b0:431:d3d3:4771 with SMTP id e9e14a558f8ab-431d3d347b2mr10529305ab.7.1761084482577;
        Tue, 21 Oct 2025 15:08:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430d070a509sm46947865ab.11.2025.10.21.15.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 15:08:01 -0700 (PDT)
Message-ID: <86b62f75-835e-4634-8b56-ab716d17569f@kernel.dk>
Date: Tue, 21 Oct 2025 16:08:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 2/4] Add support IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@meta.com>, csander@purestorage.com,
 io-uring <io-uring@vger.kernel.org>
Cc: Keith Busch <kbusch@kernel.org>
References: <20251021213329.784558-1-kbusch@meta.com>
 <20251021213329.784558-3-kbusch@meta.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20251021213329.784558-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

(Adding right list)

On 10/21/25 3:33 PM, Keith Busch wrote:
> +/*
> + * Return a 128B sqe to fill. Applications must later call io_uring_submit()
> + * when it's ready to tell the kernel about it. The caller may call this
> + * function multiple times before calling io_uring_submit().
> + *
> + * Returns a vacant 128B sqe, or NULL if we're full. If the current tail is the
> + * last entry in the ring, this function will insert a nop + skip complete such
> + * that the 128b entry wraps back to the beginning of the queue for a
> + * contiguous big sq entry. It's up to the caller to use a 128b opcode in order
> + * for the kernel to know how to advance its sq head pointer.
> + */
> +IOURINGINLINE struct io_uring_sqe *io_uring_get_sqe128_mixed(struct io_uring *ring)
> +	LIBURING_NOEXCEPT
> +{

I would probably just name this io_uring_get_sqe128() and have it work
for both MIXED and SQE128. That would make for a cleaner API for the
application.

> +	struct io_uring_sq *sq = &ring->sq;
> +	unsigned head = io_uring_load_sq_head(ring), tail = sq->sqe_tail;
> +	struct io_uring_sqe *sqe;
> +
> +	if (!(ring->flags & IORING_SETUP_SQE_MIXED))
> +		return NULL;
> +
> +	if (((tail + 1) & sq->ring_mask) == 0) {
> +		if ((tail + 2) - head >= sq->ring_entries)
> +			return NULL;
> +
> +		sqe = _io_uring_get_sqe(ring);
> +		io_uring_prep_nop(sqe);
> +		sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
> +		tail = sq->sqe_tail;
> +	} else if ((tail + 1) - head >= sq->ring_entries) {
> +		return NULL;
> +	}
> +
> +	sqe = &sq->sqes[tail & sq->ring_mask];
> +	sq->sqe_tail = tail + 2;
> +	io_uring_initialize_sqe(sqe);
> +
> +	return sqe;
> +}

Spurious newline before turn, just group them.

-- 
Jens Axboe

