Return-Path: <io-uring+bounces-5848-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C6FBA0C3D3
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 22:34:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A646716197B
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 21:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA18C1D2F42;
	Mon, 13 Jan 2025 21:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dMl0U/zb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358F51C8FD4;
	Mon, 13 Jan 2025 21:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736804049; cv=none; b=CknVUDIjNTvElJj/s/enpoT5GY6XC41kFjNfHaqcI+D7cJKfv5yxWm1asxjkYVJJuBaesWAD2xZ2HaPk9T/mPJDFidfQ8UXCq48CfA6biQ3C38eeNdOgLp+QLn85ji1E6LUea/wDATXNtbEnMkI+cQV7pXCJN+qVlMEEhqfiKsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736804049; c=relaxed/simple;
	bh=jhhN0jPMcNUiuSD+ojKOnfUL+3CmnZQNj0cx5yAjRng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IVfL2MWTW6xLVTXlm4SCy0+XuTpAst9B0SBiXAgtsV0LQGMhpPL56mDepKM7w3S6sByeOfDOVg1lplSMHQROBSpqEY7Egr4Grl/yrw+tt7dbtwkqmXvk4BrROucW9hU+D8vb2jXxvzawEvZnVmYpHQYjtEHSehTFwIATvfaw0O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dMl0U/zb; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa67333f7d2so735203566b.0;
        Mon, 13 Jan 2025 13:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736804046; x=1737408846; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wn5PiGDMRHL3obexVx5xGt37YBdMlSBj/q8mI20QHj4=;
        b=dMl0U/zb+dcVXvR3zkILyStEgFmA90y+COzsliF4UMT7c1mEZBnkLIsTESseGA1FPy
         DhM7Di5k0W8l9jLlaPWvdri0lXx5gpWJDqgklMqm/4tshPDjGM7s0OWMoYSEZGudvA0D
         /goeQC5Qq5NIivwkj1csDJNAQBvWXubb0ydHTpsfJJMnXpsza8KqD+6UOyAVgk32zkaR
         3xgnp44fkeCm1sI4j3ZuSJTW2piPvZ9yua6rY9qXS9YVA2ZNFg4XIzdthCXZMo85E13m
         oMwSxBv2HLu6+ypeKW7QnnkI/ufW9LJ0fOz3mkK1wk7Bgg/R0s/dv4E5CsLmCCHhT8z3
         7szw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736804046; x=1737408846;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wn5PiGDMRHL3obexVx5xGt37YBdMlSBj/q8mI20QHj4=;
        b=vAzDx600hC8FOaicrU1l1EyWC+xrNc1Eu9kRwXNqqgpfdPvBZHxO4A/wYA8I6d4Zey
         /fCmKdUxrFCWKhlTm7s8WVXrvg6uocVJvYhAeTES+sQDmGA2lanIireFMQpY0dImkIiU
         y4NzWAQUBT5Au1TG7lCJuGuMoxksdyRxaw4jCDccrBt5Wi2ucZOq1HGpOGN/G51mO0gP
         zyjlSNms6q6NhVvWEaL0xA+K+s5WeudONRvbJhh7XMzs71cASfJ0frQzG/FXadQMqdF0
         exQkyF0iQ3egUi4iOsXqXjp5puy8SB7yE5dvNCwsgLZzEexIszQ+x2ooYIhtlWKpuNqR
         OIiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhsxo67f/xP+vLDqGmvDK/pXcM7MwwMrQxLvDAacGn4ksemkIoxNN8JPx8RSEHkQcyfCELwAMVAw==@vger.kernel.org, AJvYcCWwMJ6RaKsQjGfuSRUkIxYMIb+sWGM5e47GcBiQgyWcFEz3x72B0p0n0sxoCQpmz6otBviOC692D0fus5RI@vger.kernel.org
X-Gm-Message-State: AOJu0YwjzfO2Jd1ppP9aR6H5FmqRygur8H7+Gt6YwShP4bPs4NaqRvK1
	NoIcLhS1Py+NX5cLL+G6bpTYITNrR4h2b9DrJo3k43zVwMxMzVQpa5KYD70Z
X-Gm-Gg: ASbGnct6qPRyVqbDGCZVODMbhKrLZd9v64X5ui1JESg/ppxQ1WawSct7Hvyud5QdOIZ
	uLpTp7dBeVd/OUx1T+uJP3Ei9b+9DH19NcOPTgswVczuOTMCzPVMYg5a81e+V3jFupG4n743jMm
	Mwyku5ei9rFmiylJNrkFN3/mTAg5UrQ7APBLFcqP+ZU4JNCLepVFHbKB/EU/qFKofPmJ72qqGMm
	SJ2W2w2atQlDetnRCT1ZCvseTC/8qOYrgO6qfzglk1B0al7J6OkoLeNHcSxrU7OPgg=
X-Google-Smtp-Source: AGHT+IFsgFwYwfKfY6Ix2/iLBkRp2j7EtYZwnZkn7jRZttkGZIWyoZGG+UTOY/PeCdjtrzyQd+Hlkg==
X-Received: by 2002:a17:907:7f90:b0:aaf:300b:d1f7 with SMTP id a640c23a62f3a-ab2ab709c82mr1750075666b.13.1736804046391;
        Mon, 13 Jan 2025 13:34:06 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.152])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905cd15sm547298666b.5.2025.01.13.13.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 13:34:05 -0800 (PST)
Message-ID: <a5910007-017c-4b80-b0ae-e36569c88b15@gmail.com>
Date: Mon, 13 Jan 2025 21:34:56 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: simplify the SQPOLL thread check when
 cancelling requests
To: Bui Quang Minh <minhquangbui99@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com,
 Li Zetao <lizetao1@huawei.com>
References: <20250113160331.44057-1-minhquangbui99@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250113160331.44057-1-minhquangbui99@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/25 16:03, Bui Quang Minh wrote:
> In io_uring_try_cancel_requests, we check whether sq_data->thread ==
> current to determine if the function is called by the SQPOLL thread to do
> iopoll when IORING_SETUP_SQPOLL is set. This check can race with the SQPOLL
> thread termination.
> 
> io_uring_cancel_generic is used in 2 places: io_uring_cancel_generic and
> io_ring_exit_work. In io_uring_cancel_generic, we have the information
> whether the current is SQPOLL thread already. And the SQPOLL thread never
> reaches io_ring_exit_work.
> 
> So to avoid the racy check, this commit adds a boolean flag to
> io_uring_try_cancel_requests to determine if the caller is SQPOLL thread.

I think the comment is excessive, but let's leave it at that if
you don't want to respin it.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


