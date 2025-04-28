Return-Path: <io-uring+bounces-7759-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A3CA9F1E2
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 15:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC07F5A636F
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 13:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228D826AA83;
	Mon, 28 Apr 2025 13:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJ1YcfhY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6278526B96E
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745845667; cv=none; b=Nj1dKDPqJqHn7JLZxP7Gj1MInfPYDXcf52OXlJi3VfjaAPKY+T0afMBPZcqPb2YerJl7+y7KdjthWygj8Su2now5aHkpYQODkNIm5TDtxulm4c1/SyqA8yeYqssF4KM7t+ZfdGSmLEKWKfwYSPApG1YxgKsFTjR2IUfhmSE+xRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745845667; c=relaxed/simple;
	bh=zPJI0jQOp9iJM1WGOqPlqw/nk8Holp0iwwX8pvR72jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HeuNx2Dmccivh2n2dQ3RQc6+xBpz1Wa2qBw+u5JjMsLsq5qzbXjaMnabVhvaBuqzwqZ02mqGaBhkZbre92FvAwtXeDNSo1amKapnVO4bH8kPKEd0A7a5Z2zkcsNkaHyyVjiN6SLGF5ly1pXBEhUzRKj7lbvmjIqeVmiFbJMczPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eJ1YcfhY; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5f6fb95f431so6414989a12.0
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 06:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745845663; x=1746450463; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MfDHcDnwsLcKa+L1Wj7n7tDZ9XF4eBtvcRiPQBqH4iE=;
        b=eJ1YcfhY0Llg+oT591o/Fatnnuj2fWC7RBHFO8/MK+dBBsbmZDoR8HeSRRHYKYU+VI
         G2Pv5lCh7hKbN+Eyv0cqDmCMf6OXFFvdFVAOdiMmt67894FGcxH6cMzhATU3S8EDmcAr
         RDYIM/jLwe/S0yrLlvzSYI/43UK8c3TrvsF5nMyj/2gCBtPQR97h2sQJG0dB7Gx5jnLn
         Ea/mAY+C383ptL4gcRipFZSbGUico0jGQDBawtK8VNnsArnbF86IFeYdRF8EUHcsbBgn
         GHsl3TKSio6fRUVHrhXaOKpWcYZFbzBjokvJxxGugrmH//9JEzju3srSfQgRYS7QQhaR
         vFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745845663; x=1746450463;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MfDHcDnwsLcKa+L1Wj7n7tDZ9XF4eBtvcRiPQBqH4iE=;
        b=gcIHTSr5zSj8hlz4BCL6mfHI8SaxBtTWu/sItVw5NhKt/HAmdIXx6j6EA3PMJ58Il6
         eo4qc/S3qrMzg43X66+nQ1+VgVuGgGrZ2LWsEh3aZwa6pZkbFP1oaUJVhSyUzGuzcD7y
         S+2fuehiNGQSGJoCG2oCIr+3TSv1suOJYapN1vv27npS6DrEt7WXZO3RnUk1d6BylNt8
         Hg820/0zIn6R69pMsXgPUQ+HBpAyeIndGE6Vt1NlCkWhf5/UDUwH/WIe8kbAJcOOoapW
         SH2U2dLybvRaYP+D+OujaTC+ZiFwOabhy9v2xZsE2xy+xpQfeH/fk68jRcAm5xtRbOAN
         Zg+Q==
X-Gm-Message-State: AOJu0YyXoNuVc5rD47bzkyR89ek+Yzf5hK0mTsIELFFk/Kkrc1TAinLA
	kOMpccmTbzc2GNw3I+hyGhTv0MAy/QWBvApWDvGKoPrqEW1VdzGq01RY6w==
X-Gm-Gg: ASbGncubUzR4RGwcN+YdLbOoGYXtWtt4ooAhDT9VNbD/X4FHQdaD0w0HYR8aNWa/ocP
	mXZw0zqvFSpYVwLXjtNZOATagcLyHqMGZxAk9g85d6BcUE2Mmuj5unHhxcl5v6Mr8p+ASZmkllp
	y87dSdTtHmJOkE2n89h4P4Vlztj0OUuNF5rhgjMFgsLiIITUqBuvrCTO/077fTTqRNxj2ebbVXV
	OZ+1udUPSD3Bo7qG5VTDIqkMrRW64AmEOtoNsWGtWpnpjdkk/DUQnQHc7CqIjZ1MuNT+I8hVcCs
	N9bcjSOMgxb36E9iFiSumOHizJBS1Ij5IcwADuzEOUa/mXDHl8uKGY/CUtikSjiR
X-Google-Smtp-Source: AGHT+IEPJkULgAwFswW6i/S57H9/JSAL5Ozt3h/aM/ynIwCXIvLY1f8USJPKtHwuSGoXsPvqRivsWQ==
X-Received: by 2002:a05:6402:354c:b0:5f6:4a5b:930d with SMTP id 4fb4d7f45d1cf-5f726752eb7mr10392954a12.11.1745845662807;
        Mon, 28 Apr 2025 06:07:42 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::3ef? ([2620:10d:c092:600::1:c92c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7016f6770sm5963519a12.43.2025.04.28.06.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Apr 2025 06:07:42 -0700 (PDT)
Message-ID: <79a18c98-31dc-4ef4-8bd1-b0578b27c6bb@gmail.com>
Date: Mon, 28 Apr 2025 14:08:52 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/7] tx timestamp io_uring commands
To: io-uring@vger.kernel.org
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>
References: <cover.1745843119.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1745843119.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/25 13:52, Pavel Begunkov wrote:
> Vadim expressed interest in having an io_uring API for tx timestamping,
> and the series implements a rough prototype to support that. It
> introduces a new socket command, which works in a multishot polling
> mode, i.e. it polls the socket and posts CQEs when a timestamp arrives.
> It reuses most of the bits on the networking side by grabbing timestamp
> skbs from the socket's error queue.

A branch for convenience:

https://github.com/isilence/linux.git tx-tstamp

> The ABI and net bits like skb parsing will need to be discussed and
> ironed before posting a non-RFC version.

FWIW, I'm not spamming net list just yet, not before figuring out
io_uring bits and other basic requirements.

Also, Jens, please consider taking first two patches if you're
happy with that.

-- 
Pavel Begunkov


