Return-Path: <io-uring+bounces-7231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8079CA701E5
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 14:32:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58A383AAE53
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61B1265626;
	Tue, 25 Mar 2025 12:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hQa4vGIY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34298256C75
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 12:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742907178; cv=none; b=ZYI6uhK0mxaD60e0tQK5FFI8GSwHHNqyaBeO+I66nhnwaTST9FCZlQcdvzkE93Uzu0GzFvSUom2dOu3fQHI467cOG+7c53aNDs7Px/ptmkmMbnwa7YvO6+sfToGrRSRTkeouCocUTu+muh7jOcyYzmXplC+xRNzWQCGmnwMs1d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742907178; c=relaxed/simple;
	bh=hbjFWc/M1u0JtUeGDfraCyEfZ1LuYrMt6ic+SN3g7Vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CupRkQxwEVB/Yc5owR837vN9SWmIopTAyS/dK2uL+o7dmawMJrTn//qsyCNhLkUeU01iWPORDwJBh4G5iBmP4cH0Hhmdwz0Zn9xVAOwab3jUABVTvqAG4TL/qKZTF7N5xT11bXX7Vaeo5Q5fBTXvcUvqOgfuel+JkXIxYTGh6cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hQa4vGIY; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7c592764e24so488631785a.0
        for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 05:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742907176; x=1743511976; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=hQa4vGIYgLdyUaF3FHuYkxrOS+WFv1QM16ozK09RJAz1+05+r0sfUiNL3e9fjSrFvz
         2G+k8sE4DvYi3RU6y3x3tdz+SmkdWI+GLx2hROIPqXPhv5cU3atH0X0r6AvFQurFUp+c
         3IBUtLDlWoaV0lM2aRtIWn29NrvBP0PyvLStiGhg9o9q4munhaRJzxFQAKueX2NiUnCe
         k2LiMC3b7KuU0+etcLWLEUUgXQj5W0ORk+QJwH/9jauNsAVZxvvdLRSIzM4xqiqdlhZq
         69SnhY1QPSlPGW2J/mDQ/+vv1nf7gBnbhaJS21fQ/4alZaxfdazR7aBjCpB07Zyqnh9u
         UNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742907176; x=1743511976;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=V//K0gNzhUfGQA2P3kwoaiP1eJNUPjgKznDHwZInd67xRQ9ewqkE4weDqjhg/+p+ID
         tfjTkJlJ94ykA9xNkAAF4vrrSOLV0C2yhXPtj5/twACTmLMuWol1l9bgBwgpsaB/tl5d
         nDWKOpXBInyfwVzN1WVURLEbN1C4JCDWOiez/qaztbfCmitEXB0Y2N2pWqkT791Dam+w
         F1v7hC6gjqgGsHTKVVHv2KjPPjvX4a+BXQMb0EYu+2MWLkJOKYl/MiRlqnM9U6/ZmgQi
         WuYVe7NkRrccxkEADlN9M9QZR3IYGaRp3lDgJDvMkLJZ9rmUpEAGhKYmFTVS4Q+hyt9w
         859Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRjt+v8fuX6Dbn6MJV5HJ2UUNjoklOrUSIoLdOXvKDBBXQhA6ml+v3/FKfnJXjdCanWVySFuUYdg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkDyrA8FraN3wsLHBqSg/Gl3D61hWrLFoTmIJecOVcQLqCcoga
	8AwycNaUXXxP9QFYwNGdnGhdB2DudBJ7j//L7a3OtWoWD9lwTaMt0rT6gF5e7Y4=
X-Gm-Gg: ASbGncuvlGa8xrmZO/1tESqGDm2a2Nhp5w2fb4tru3m7pzrlqdgX5tBR9l1gE8Eiauf
	M9p98I0gCEq5+wlHWDEdW7LZ2Ih8FB/1lgHxhTNUr93gwcTbTrJumAYbedpY7MAqh3GEKF5J8Hu
	2BwgUJqOn1GUYlFT0fFJNNvKm1S0T77D3lWTqBrF/6KM9rXCgtLbEvZoQ/RvQBjIM0+Cl0IJwt5
	+MwgDjzNGMq8lMCWHm7w6dYI6GWtyoHEI7ewkrXXRAXjAKuYull+2zs85Taq6eu9Qd6d22d0ZDv
	4LKYcHIMVJWT8PUdFRs418Nk857V8T9LLTAtV9FRnw==
X-Google-Smtp-Source: AGHT+IGuzAh1m+3Da8HMyPjo4cS8BnNgDmCwUc/FwsVtlsCsRku7PH5rlGDzAZSOlfFgYFdymsUcNQ==
X-Received: by 2002:a05:620a:4554:b0:7c3:b7c2:acf6 with SMTP id af79cd13be357-7c5b05296cfmr3274590385a.15.1742907176053;
        Tue, 25 Mar 2025 05:52:56 -0700 (PDT)
Received: from [172.22.32.183] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5d7eb96fesm144992485a.90.2025.03.25.05.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 05:52:55 -0700 (PDT)
Message-ID: <846fb871-c171-4f31-9097-5396aa9376e7@kernel.dk>
Date: Tue, 25 Mar 2025 06:52:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] nvme/ioctl: move fixed buffer lookup to
 nvme_uring_cmd_io()
To: Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Pavel Begunkov <asml.silence@gmail.com>
Cc: Xinyu Zhang <xizhang@purestorage.com>, linux-nvme@lists.infradead.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250324200540.910962-1-csander@purestorage.com>
 <20250324200540.910962-4-csander@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250324200540.910962-4-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

