Return-Path: <io-uring+bounces-7003-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A31C9A56D68
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9904164E86
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1765023A98B;
	Fri,  7 Mar 2025 16:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YCg3Uw0r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C888A23817D
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364317; cv=none; b=Tf/gbZrKv2OQlg08AM9ZYVh0r9O/9GazacPBASnNUrnjO9vn7jET8hvl1BjpnQ3NNae+YrSReO7cG3hT3SEAzG1OuktkovsQTLtWRbn3xpGH7Ms/7UdGaEZsLQKNrKxfoHvVBpDeDqvYkg+9v1S/sG/TBOyY3SaG4OA9CAuxhbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364317; c=relaxed/simple;
	bh=Q7P4hSefpkC1UbSfbt+doLOOOpwGC3N9h0F6ojYSWWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ThwWwFQVPn3xmehOqcqrPW7770KtvlHg9DEnhW34cHSApeCFokeMkQAnm/tUTzj3cIJUL2pJ77AZeQQfethrU9zPz3LLjJZpyINBjC2tJH/Tp10yLMHNIf2BFy9PLhrffnARVTeqcRanmRO+0z4YwRsa0YuKPKx2CL3jDyhv7uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YCg3Uw0r; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d03ac846a7so6466425ab.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 08:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741364314; x=1741969114; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=In9PPY40Mgr5yyZmxf6kZQr/QlJ7nuj8M0fwjZ4i/fs=;
        b=YCg3Uw0rWDiMXhs+4gxJ3CqU7x3VRb7hkgp2qae0pBtq+uEomJJNb/jkA270xjZ+aj
         5iMtwRJrkV6j3UwwVZA+xLSQ0UL2LcKyCA/Mg1QXXaLf96jTtj8EJI6Hoz+X33vcSuh8
         3C30N694aKe5AuQ1KeNdfW2Swuo/565rcvfuL6yg+wm8Ey3hbbUYxcazmXpMepsAYgsO
         wSKR3UNgCbKNKFMaeD33MS4pFwOCaYnbEqyabsG3tnWAllX7M97zaRH8FllLahhIyp9O
         VeBEHU+f4X4XumMkPD9CDn4R0EEhPop0Wv0S4B/docHIUOW6vPFevSmthMmU9GXaQ/Yf
         U8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364314; x=1741969114;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=In9PPY40Mgr5yyZmxf6kZQr/QlJ7nuj8M0fwjZ4i/fs=;
        b=FR2e18C5bwZ2JigvKpfdAj77pvKtCs1D7QLCvypiPHPY/Lermt203hWadXMDE6B7K9
         QWVL/nO4h8RJYzVFHCIOu3pg39t3cO498SJCCIqoU7pZo3h3cD55HfAv3CaCgK8O7rKV
         xZEx19GhODcLNVMyZJArVsqqAw1WuU8sViLeogc+/fUj8PrGjcmFBOPIrW6kg8UrQkv/
         WdaB3UfwWKLijaW2d+y7uOhgAjGuxHuhvtGUzd/CJQq3y0t8lOHB7JfhL+XbtEdi0/Og
         pZjvmm7gw3HEgxyH01TsUyP+biZWTOlWO79IJD9AvWz27qZ7o7YRgQFU16ruLIKjS5bJ
         BN3A==
X-Forwarded-Encrypted: i=1; AJvYcCVKYAjvlD5y612YlBG+4un2/T3W8atyOBIEqsJCLqZNZHaVtBQMpbS65SdU8rkxPpHS+3WgYYH1fA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yycvl68uWwsaPg1kjOzWx9SabR/YIv/xRmf1RTFdxlrIQJMdhfo
	blWbhv7TdyAycEbqjT2VWdvOVySxEqPAqB1W+2EGJQK8kB+h0lgKxuZT03KGZAY=
X-Gm-Gg: ASbGncseHLuL1/dFjTSMILYuKTrv6KHGnDe3DAY/Wb+iSZ7VLQMbPR+Luh/CQh8JSkd
	T1YxnePJjVJXeRwMWQwzzvbrTtXsv6D73Svvv7EoCM7lpolL+Ti9BB4f5jGcMZ5sWXmIWEfRoEj
	Jf4GwAPjGW7UQhflLFSVUw9WESK1a9zmp1kpqlTIk9LZO1do+brAdTU0lht3CT9PrQl6WJ+ohiJ
	mr6fnhTb9fswDY3WuhiX9CMOS1b+bRq7SD+0fUiKl0pMh8+j1waDvcJtS5vVohi6Jzl/5Ra71we
	NTYrHn9a2Bhkc9ZkynliqAM/iS+Fw8vGtTnYp1/O
X-Google-Smtp-Source: AGHT+IEZIL6kjCDQac+J10FL30HMzY4rLD57DIbTTax5qwBe0pYmXJaCKIsBu5zSRoGSQEaVsikMCQ==
X-Received: by 2002:a05:6e02:1a05:b0:3d4:3ab3:daf5 with SMTP id e9e14a558f8ab-3d4418dcc7amr47772725ab.6.1741364313935;
        Fri, 07 Mar 2025 08:18:33 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f20a06b059sm1005242173.136.2025.03.07.08.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 08:18:33 -0800 (PST)
Message-ID: <fa3bbf2c-8079-4bdf-b106-a0641069080b@kernel.dk>
Date: Fri, 7 Mar 2025 09:18:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: support filename refcount without atomics
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 audit@vger.kernel.org
References: <20250307161155.760949-1-mjguzik@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250307161155.760949-1-mjguzik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> +static inline void makeatomicname(struct filename *name)
> +{
> +	VFS_BUG_ON(IS_ERR_OR_NULL(name));
> +	/*
> +	 * The name can legitimately already be atomic if it was cached by audit.
> +	 * If switching the refcount to atomic, we need not to know we are the
> +	 * only non-atomic user.
> +	 */
> +	VFS_BUG_ON(name->owner != current && !name->is_atomic);
> +	/*
> +	 * Don't bother branching, this is a store to an already dirtied cacheline.
> +	 */
> +	name->is_atomic = true;
> +}

Should this not depend on audit being enabled? io_uring without audit is
fine.

-- 
Jens Axboe

