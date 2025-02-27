Return-Path: <io-uring+bounces-6850-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C6BA48CF8
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 00:50:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 097827A2A51
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 23:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91DA1AA1E4;
	Thu, 27 Feb 2025 23:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nFTUKvGc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300512C6A3
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 23:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740700237; cv=none; b=UIJNOuSwKPS00IJNaLdbNJ9SNbsyLk6XjZdhurEsLZpmBMdyOIOiAcr3D0tnCwNrw3chCgY2ZoijaSUO4Lf+YBZlRM2wFutQVovf87y8rIMg1TkNHwAiImeBGOGqECqyLne4wnkNMAjztmuZf6QltO/BqwzIBOLo9euna14sBTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740700237; c=relaxed/simple;
	bh=5+iXgmLlQmW2LmSgyiBuDpzfwEE+8yVTlBsst65W1zM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AYT7JOeywJPCLu3pgkey9yDQDxWH3yeAcpv8DoIFYFKbdn5BfnqUfFgJ7cxVi7OCpgK2uDBjtvygPPyr3siF5JYdu0cscnzsMqO1y3h2x1RifU2uSoE5EC7Nmn4Ao8EVcwJoaQa15ggInf+VWrKvdfvCjfm5rAdQoWL46evmza8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nFTUKvGc; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-855a7e3be3fso115471339f.2
        for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 15:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740700232; x=1741305032; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/MrW9oYu7MINLs/fTPWfiPiv9Pd0BlSPYSGo4GMsrr0=;
        b=nFTUKvGci2j1kLgKouJhNafbr9llxWfbrrdlFg/UI4BIZkcQMfWJHkUOQN5OOya43B
         14gW8Y+9a9kSDaAq/jKbah8t0KpTfmOq1hJ8c8WZFY/rBKlQtuNX09+rjSKANLwUkeyD
         6xi1EQdqTn/Kzg+fTmidVqsMjI7Tn1WWkkqVtEMrnaokI/77t1JG9mrB5FjX7OzAVO58
         LvVjWUAZ68wIfpPY1qhvRgz6e+1J3ugfoGTWRWBr1SbqOLMZKeOaYXM9cQyQ9oB9rFBY
         yjcJBGG7zv0k46ho3HzXovPcpiF9zXDg9g2DfkB/LlgTAYdDWogir261aPkeneobj7mA
         Jszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740700232; x=1741305032;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/MrW9oYu7MINLs/fTPWfiPiv9Pd0BlSPYSGo4GMsrr0=;
        b=dte2/lAXvSyQNZpcwsLv91GHSlRNxbOnDxIkvrVkOTvMI2hZhs3KiCVlRAUspB0lOM
         SUP5kjHyQjRgVyAYrN0oFyRGnZcbxCmAx4SCO6uwzKgT5+mS+z5i01VyfRtO4A9KJ73h
         zzuJif+wH8GWDQJsRnthdKna8ncCw+//z1L5wbAAegK0iUGZu3u7ueNbBY4zgKJuv9/Q
         1VTpIfhmV3fIgIR3iqQyzoCAzIigEdLTBt9GZBXvLKjQzwjuWcgNbDmyhfHQm8NTvl3/
         vcojed9qOzyUfWroXQG722H9sHtDZTcddvJUIcbMT3sTkaFrIKNZCAweBsNiqaHKwmqM
         JTfA==
X-Forwarded-Encrypted: i=1; AJvYcCXymtfHWRQxjzQtwTamKw6gUkGdyjjgnzyTl62/KGwfenMzMbCe8CHK2p52CE1lDtZjoP7L5ahP/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFFA0+n/4O3EG/LYC1CZYwFcJF00rKE30C40PKtKhgNDfOpdAH
	m1ESNEjX6cLPfsmODhZ56jil8cMenOp0+BUINStkT8U3uiZRAdn+MSoHjQzQHfbXqMzF7mAkVPV
	T
X-Gm-Gg: ASbGncsDEKD4AJvyYxYAtrbxCA2R2LL5V9vqs+81ceYdHn3LaIzbs08THSRoYfI3JL2
	ipopUx615+0FW20LK+uQxYVgejnnGk8pwaaIkpAnuWt4zq92VSBHTIx9BG2EIHwHo7kivOcl5fu
	g5g1ojXvwGxzT8P0DXNQO+ocWmOJ6Lau+ZH15dPXByolTvV5oZadys1e5OHSXBQMRY+hjNxJgdZ
	UUg4p4vSq/NjqAN+LF0OQK3fOGs8SHl+HVGhjMFilvtvXtmT3wTY/Vuf/NVUODfMSoyjeb40Pxo
	6QJC0vqiChoXnnR6OVO9I1A=
X-Google-Smtp-Source: AGHT+IHSRlM3w45VHLLMK6HPiygexZv4dV4SqmsXYaIZxGsowPQTTGBfz1MH1pCv0maLCVB8fNpkuw==
X-Received: by 2002:a05:6e02:1a6b:b0:3d0:405d:e94f with SMTP id e9e14a558f8ab-3d3e6f51b7fmr14092215ab.17.1740700232541;
        Thu, 27 Feb 2025 15:50:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061c5053bsm601823173.38.2025.02.27.15.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 15:50:31 -0800 (PST)
Message-ID: <1855c57b-13c9-49fe-b7af-a277f8c8b2c6@kernel.dk>
Date: Thu, 27 Feb 2025 16:50:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 6/6] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
 asml.silence@gmail.com, linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: linux-nvme@lists.infradead.org, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250227223916.143006-1-kbusch@meta.com>
 <20250227223916.143006-7-kbusch@meta.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250227223916.143006-7-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/27/25 3:39 PM, Keith Busch wrote:
> @@ -119,22 +137,44 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
>  	if (imu->acct_pages)
>  		io_unaccount_mem(ctx, imu->acct_pages);
>  	imu->release(imu->priv);
> -	kvfree(imu);
>  }

io_free_imu(ctx, imu);

?

-- 
Jens Axboe

