Return-Path: <io-uring+bounces-6947-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24B08A4EB1D
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 19:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36BE78A1FF3
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B547E294F03;
	Tue,  4 Mar 2025 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SP/m4BJx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A67A294F16
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 17:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741109780; cv=none; b=MpPVxqkR0qbU7dlXART/PJIPyE5orYnBmfj1mnZ7WRff79/SUPdOpvyK+rmqGl6ij4t0EjGHb8n9lRxrM404N/6fVv46m4oSV23DeG1ApRiOOiDu3pr2gIAu4CAmWEbH0H2MCd4uQq5PSYFLxeGd5o0vhFdAQg4uhBqWO2vrnn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741109780; c=relaxed/simple;
	bh=cGve03eM0mfVSh/dijJxn0ZZN3AFYvT2CAf0OZTk0ac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d8O3mzV7JGRfuQ4bCfwngvv3wvPi0mYlpxF3f/CYOMmBTRjpphldmImTbtFUQbE2t+Md4vlRCO2unUTVSglJwOIjFgOHfGmrJFVqT3AiVlX+sHMM2cCvJfO2qlXH950kcAcNZJ1BbhijUm2dvHZd7kKXZFJ0QeocKjQZEKZANsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SP/m4BJx; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-85ae9566c52so54708739f.1
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 09:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741109777; x=1741714577; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WTw0QZTXxBViPg+OztJZ1wyTVYMoQYR/h//Gd3FEvPk=;
        b=SP/m4BJxmPj2tQpIVxtGFMbfrkQsrvNx4G74kVcG9WUZ+FnKN7ZBsLv0mvksnJC2ih
         ndCxcUI+pW6qhjsbUm2tnVRlfmj17x7r3WtybwMy+g18tGGgwj6h6IPkZJmjzX07OAWD
         A1rRjUx20VbbJgaa1YCxQbFRgfuEOfxPzVM4Jv5THjg33V04nBvQXN93tFcJXeEw3b/Q
         /X3pGmcEVZ0vy3L4KKlN0dJQ+pmGxrYcxlJuxxi2DdKv2dptHeSGsuHloc0KI4gbDH9Q
         9iK0WApQJILLnl8lebaAPA0/ZRuE8LFI0BuXtA2XdQKXEQ6FAeb+iwA/VmW0x//rM9v4
         4z/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741109777; x=1741714577;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WTw0QZTXxBViPg+OztJZ1wyTVYMoQYR/h//Gd3FEvPk=;
        b=gdXji2fYQyiOYDeYqEd7C5zj/EcnCafTMbMtQLs+4xH71l0e3wdf9slzHm7tavnHcK
         w7bHXaOHksF/HsCvvLsqUb9pDaiWZptLFjocFY1K0kimlPlFFH92lhE4CnDVJs6NeiDb
         hcaQG+bzsT8ocyC+g9X+ZT/PIOIjzmPg/CM0Z+fmghR/mDbsKeRH37KqzKDXpwpcaT9q
         waTTVT7EUuOOTF5Kk+U6u0RN7jHM6wBtJl70MFuyPjZxtt85h2C40ryvCX0BIBPdI3xD
         PPYw9E/EmL7cpgLvjK/ukREYl7tsYgFLNGHQk4DvLRxOeoW9n8hZpN480TJAiVspNqd7
         1lBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOydW2B2ty6oa2YpRfn3vGiYpYmdP9553Q3e5x+2Q4A7VoHFXMWVOs03M0IXxUdin7IGUFhY7xqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5dQO3t+TNqRhpG/SrkIIqB2/tgjYVk1XxuciYTAH0upNQy00H
	7t5QcpYkIuSfUUYSkdA6DAIQWIPHNXmLru+aVzy2JU7MY2iVoT5+/XwSfuB1R2U=
X-Gm-Gg: ASbGnct5U+b3TYqT7FzyEoffqA0DqrxRLgUGXHTGGKkov0a86qwLZkPMbk7wNvUuhrs
	XMxoQSS+EtWBoIBPXyASWkVIvreGeuu/hECvklZTKAN9Db88SthlFOspDzY1ekU/eJXK8RU8ywc
	WpITTm/4THT1pnVUDDfs2n0IH+szHTM4gq1icunQywHlXS6t/x3Kipewv1xn0YiJY55gyJypcEs
	Hf4G5sxlXzNdtGpvp6qIHPqFkzxbprjL2cx15S9YePxzPWbkljgRfMzvRqBakumJNd197wncRlx
	mnzG8i2/2Y/G+61vPnl7v7yXGBE5l4iCIMz4GGc4
X-Google-Smtp-Source: AGHT+IEl/2lIWs82Nv24HzYA9GHvLqSrtH2R7AH+4lb9o2W0G/5k1g2vm+bZNB8ReCXdDLPCo54h1Q==
X-Received: by 2002:a05:6e02:194b:b0:3d1:78f1:8a9e with SMTP id e9e14a558f8ab-3d3e6f565b3mr167094265ab.20.1741109777525;
        Tue, 04 Mar 2025 09:36:17 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d3dee67953sm31940025ab.19.2025.03.04.09.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 09:36:16 -0800 (PST)
Message-ID: <1e7bbcdf-f677-43e4-b888-7a4614515c62@kernel.dk>
Date: Tue, 4 Mar 2025 10:36:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
To: Christoph Hellwig <hch@infradead.org>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 wu lei <uwydoc@gmail.com>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <Z8cxVLEEEwmUigjz@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z8cxVLEEEwmUigjz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/4/25 9:59 AM, Christoph Hellwig wrote:
> Stop whining.  Backporting does not matter for upstream development,
> and I'm pretty sure you'd qualify for a job where you don't have to do
> this if you actually care and don't just like to complain.

Sorry, but wtf is this? Can we please keep it factual.

You may not need to care about backporting, but those of us supporting
stable and actual production certainly do. Not that this should drive
upstream development in any way, it's entirely unrelated to the problem
at hand.

-- 
Jens Axboe

