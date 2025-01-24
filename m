Return-Path: <io-uring+bounces-6119-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F40C4A1BD99
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 21:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AEF016C968
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 20:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C54CF1DA63D;
	Fri, 24 Jan 2025 20:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JphXKevz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12B213C67E
	for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 20:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737751637; cv=none; b=m0RAmaa+shqU5BSxEzUaJwfJ9/EPBaisMfuNUtxgeyEdpXca1k316ogkC8wCw913cOE4VTWp0fODL1uFMnfZl93Nd0KZh508kqQSfQxTzHdMWFcHOFY38H51LKmWGKcYsKc5p8rjsiNdXlN9nnfUuHF1Cr5hmnb8nNnllePIUL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737751637; c=relaxed/simple;
	bh=tpL/TsUXCd7sfV5n5avBkyJe0b5ilPtT/vNnXnDgFp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QDx8A5P+Wk487DYr5xK/uMkx8qdYB/VdAvEIFwesr7xvAFaxRfIeiRyzl68p59z/6fzKlojfA2ddwQcKj87rDp5Qmj8vSA/iY/266XR3X+GZs4q+TRoY6gu6l7biGhxUtxMlchIA399YJy8V/cfRJcUNiIobZAosFoC46YAVQz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JphXKevz; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-844e39439abso68662239f.1
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 12:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737751634; x=1738356434; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DaJqWcsK9tZSSa1bedlEwird8dsdxNAvQOMECXsQVDM=;
        b=JphXKevzDnvBkm6EeIp8rLMZxC+mTYbXsbjpDPz5An0hzpGiXLWxcfF9cISQ1a05PT
         nTouR7unYQm7Ew3uu7mml3gytB0fTlqfKfIgEEe0U5MzE1YB+oLhdrZZBWkTctM1OsjH
         Ly+nH9cXJFLdLFu6xsZlCklvsjAhgfIKf48ZDCW81C0Gvyhv7m4dAW9MLFdU5+CsHzqq
         MM4ZNA96t9bqMN2/Blt5ndj3fmuJz3hv3bBitkiG+x/xHq2ewBw804f0Kq3ubo9PygBl
         TEDklNvi7i+Mnk2En1Nfi+Yd0fMl7auFMWjFl9VThfYmEqZ+tDPlDr1nV88ca5BMLtTL
         2rGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737751634; x=1738356434;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DaJqWcsK9tZSSa1bedlEwird8dsdxNAvQOMECXsQVDM=;
        b=arz1lD/4WO1oDoR9m8KBkvMdJLuAcr5UzvxlefJXzbXcNcI1xY1r5TKc1T2ZDR+Rhc
         MgIlbE5XcorW7eVwauYIYGk7vJ/PeGKOpqGMxbMFWQhSWoHtr5K4zydst66mJ5dqEw5H
         +FNmd9nPTjc61s35w2TWweaTGlEN/H+GudO46ujfPWGhszVNDudWyj09qLeNJLEOkErt
         RsKBoRmbirwOBoNCkYaMxDYDmjc7V3ZsTCm7/19ULO7YyumwgYBS4XAbpMZ1z0BspMHQ
         Ex5sDdQN+soGiV24WrKiOi227kFQJsn6A42nahBmqZ+3HeQNj/1z7eb0x17E0YLQU4BZ
         N47Q==
X-Forwarded-Encrypted: i=1; AJvYcCX0u8DJ7kLevOa3lVYgs1iHO4nvgLlWaASlW+5LHnTrXJdN0pz+gC1W5UYlJ1DfACnLVe2OUQO9fg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9Wq17GzWmMFa+zsaTDH2k23tnKubiBshSsmZKcQXH82a3r9l4
	bqXwx0NQHMQmF/xNlzsxlp00ethsdul8D4pef6ws1vTCZlZukDcD2/6A9nTbBZE=
X-Gm-Gg: ASbGnctJ1eWn34VmNYKDzvWxaflW8Izb9bn0bqcWGi6zFY7mMLKFPj0XpbVHbhpOHgM
	eh5dNArwHFSv/ZyPe/wEM7eLbrLZlBAy3Q36i23LhesJf5Mkc0nAchEYPuTEQDMiYlKOk2xg9Yu
	BIPeeI7mf0OyfjfkNUW31NmFXGacXA4o6wovBY1qTqRYRLwxIF2xefW1AYf9lsmOzwaLZjTGHPG
	g29PC2bf9H8ezr9NKwN3Sr3GSuWq2OPCJWlIgPwwZiqmGhRJ90U9XISCIkVPePmMWmTSQuis42i
	xA==
X-Google-Smtp-Source: AGHT+IGa85kSO/T2HDmDdm/vU4Hoj1ggyeLKawatGyavTHXo/cgFo8f8QAYHdaFPxfLDH5S6Q+Hu0Q==
X-Received: by 2002:a05:6602:6b12:b0:84a:5133:9cd8 with SMTP id ca18e2360f4ac-851b62835afmr2228437839f.10.1737751633707;
        Fri, 24 Jan 2025 12:47:13 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8521df2ce32sm89978739f.18.2025.01.24.12.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 12:47:12 -0800 (PST)
Message-ID: <721da692-bd23-4a73-94df-1170e3d379be@kernel.dk>
Date: Fri, 24 Jan 2025 13:47:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH stable-6.1 1/1] io_uring: fix waiters missing wake ups
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 stable@vger.kernel.org
Cc: Xan Charbonnet <xan@charbonnet.com>,
 Salvatore Bonaccorso <carnil@debian.org>
References: <760086647776a5aebfa77cfff728837d476a4fd8.1737718881.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <760086647776a5aebfa77cfff728837d476a4fd8.1737718881.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/24/25 11:53 AM, Pavel Begunkov wrote:
> [ upstream commit 3181e22fb79910c7071e84a43af93ac89e8a7106 ]
> 
> There are reports of mariadb hangs, which is caused by a missing
> barrier in the waking code resulting in waiters losing events.
> 
> The problem was introduced in a backport
> 3ab9326f93ec4 ("io_uring: wake up optimisations"),
> and the change restores the barrier present in the original commit
> 3ab9326f93ec4 ("io_uring: wake up optimisations")
> 
> Reported by: Xan Charbonnet <xan@charbonnet.com>
> Fixes: 3ab9326f93ec4 ("io_uring: wake up optimisations")
> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1093243#99
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/io_uring.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 9b58ba4616d40..e5a8ee944ef59 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
>  	io_commit_cqring(ctx);
>  	spin_unlock(&ctx->completion_lock);
>  	io_commit_cqring_flush(ctx);
> -	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
> +		smp_mb();
>  		__io_cqring_wake(ctx);
> +	}
>  }

We could probably just s/__io_cqring_wake/io_cqring_wake here to get
the same effect. Not that it really matters, it's just simpler.

-- 
Jens Axboe


