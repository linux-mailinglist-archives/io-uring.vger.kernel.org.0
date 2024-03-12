Return-Path: <io-uring+bounces-894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B0F3879678
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 15:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75B1DB25388
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 14:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABEEE3D72;
	Tue, 12 Mar 2024 14:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="groIalZQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F55A33E5
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254084; cv=none; b=kT3urJdZSqvi9mriahCSaHJ/6ApmK9PleaZXg1GZZMHbuQKYTQp2LGl0vVXSy6SDFKPnRBcBOldrbjsLpNtAinwbSEUPLk25gR10pktTOFBvXCGxXmBl+wAdn2ESK3ASpiNUlhHZrgVESNRmqzgp1E67XDhFeaPnJe7gUKOVj6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254084; c=relaxed/simple;
	bh=cXh3uEsgWMI8iZusOPz9HdPAX+leG9wjwQ9vb4XC4vE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CY4nOzf+xLtqHd3OJJNMnrp5kgeE0d1xFPKtH4ZziMt7u83kWhXMjimqsgBLDEjmhq4z0fUqsgQJXsoUdg3mOjJaKmF+IQRlHEge1oCBnvCBll8GQ5uSowAh4QEGUprsA5w9Ba+nna7qAUBr2OhlXMqXMQ4mhUcowKJHDnbOSIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=groIalZQ; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e693adc8a2so273646b3a.1
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 07:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710254082; x=1710858882; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MzzmKMopoCRQwM8a7mNzAcigvxiHAg2EWip7lmqWvzY=;
        b=groIalZQcyiVJwNREciuCO+9Sq6vGaaFVANzHujV980JGPrKTOZIzhx0SsPBP7SpBk
         /G+WK/cBQO1i0AJveQtuzt/QfGvE7BqRExr6tIJHnh4kzqCqY/RzN1eNMbwsv80dU8oT
         jLjWD4SziWWQdKDgXL1KsFZ9KqazFOZbgRIgQlp9KLxe7gSxR4N7KQWgjQRVjpzcRuu4
         Q1Ffdtg7ifplLpDR0f2ezSLqjFEtBT0b5E8Y2Kz+bJpADkuWaPmcUjuKGiXhVlwasrDz
         FsGtSW91l2ue5yNSehfO8PjJvMvIITL3VgmI9xGVdZs5MzXAtcCx45SR81DGqgcsILLJ
         DNDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710254082; x=1710858882;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MzzmKMopoCRQwM8a7mNzAcigvxiHAg2EWip7lmqWvzY=;
        b=AUt7OcvXvwQUzXaR0+D0i73WHqaoVkyRTPPwcm7Y2YIwAkxvNQV5IvYI8BvmD5zEo8
         u8a6+Pcj969oLOLhndA7BlMYiuVuWkojripzv+LGXb8KcKW2gFOKbXL0m3TkHkFTK1t4
         LKo/rC00MkvBflE9FZA/DLLm+q1znp2fthIlw0NoypyW96YkoqHVJpWm08hMrBYg8PvE
         RQLZUBgMrYYtIUxP1S/yJM8Z3wCiqfbrB7fo73YPChxEXxzUtrSUKx3gY1L6A7oHiF7/
         TDgg4fuimrlFLpLBwgLmClqn0c59GSaUKZGjdU39+kNuw0iyPpyssUxnR3Ef+66rSdUE
         Y7Dg==
X-Forwarded-Encrypted: i=1; AJvYcCUoEeaj75ypAaLUbkLTKLW9rj3yuqAu2nGjwBj4OCictYEgYzXqV/e8Ct1a7QTWknJsKhTykL+O1394iVlbd5W4YId1I8MHVj8=
X-Gm-Message-State: AOJu0Yxj37K1R8tUuU6GC0iwyP6YMZCqLQKI52QiPfJld41kJJv97JEq
	JTF2P5S//nKlwLcwbFYu1c+YL3mW3e0XYw3yFI/GP/A2+a/jA0lgmPk7TO+ry8A=
X-Google-Smtp-Source: AGHT+IFDcI8mS2gs9NO0X5lrcuBm9Bmac4hHIKD3R57tXZnBo1tuk7q6bjTSHz+jRGAp0khnB4GNIQ==
X-Received: by 2002:a05:6a00:2384:b0:6e6:13ec:7170 with SMTP id f4-20020a056a00238400b006e613ec7170mr12480717pfc.0.1710254081762;
        Tue, 12 Mar 2024 07:34:41 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21d6::1197? ([2620:10d:c090:400::5:d2d7])
        by smtp.gmail.com with ESMTPSA id v129-20020a626187000000b006e6988c64a5sm3312432pfb.208.2024.03.12.07.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Mar 2024 07:34:41 -0700 (PDT)
Message-ID: <8a9993c7-fd4d-44ff-8971-af59c7f3052c@kernel.dk>
Date: Tue, 12 Mar 2024 08:34:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10/5.15] io_uring: fix registered files leak
Content-Language: en-US
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 Alexey Khoroshilov <khoroshilov@ispras.ru>, lvc-project@linuxtesting.org,
 Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
 Roman Belyaev <belyaevrd@yandex.ru>
References: <20240312142313.3436-1-pchelkin@ispras.ru>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240312142313.3436-1-pchelkin@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/12/24 8:23 AM, Fedor Pchelkin wrote:
> No upstream commit exists for this patch.
> 
> Backport of commit 705318a99a13 ("io_uring/af_unix: disable sending
> io_uring over sockets") introduced registered files leaks in 5.10/5.15
> stable branches when CONFIG_UNIX is enabled.
> 
> The 5.10/5.15 backports removed io_sqe_file_register() calls from
> io_install_fixed_file() and __io_sqe_files_update() so that newly added
> files aren't passed to UNIX-related skbs and thus can't be put during
> unregistering process. Skbs in the ring socket receive queue are released
> but there is no skb having reference to the newly updated file.
> 
> In other words, when CONFIG_UNIX is enabled there would be no fput() when
> files are unregistered for the corresponding fget() from
> io_install_fixed_file() and __io_sqe_files_update().
> 
> Drop several code paths related to SCM_RIGHTS as a partial change from
> commit 6e5e6d274956 ("io_uring: drop any code related to SCM_RIGHTS").
> This code is useless in stable branches now, too, but is causing leaks in
> 5.10/5.15.
> 
> As stated above, the affected code was removed in upstream by
> commit 6e5e6d274956 ("io_uring: drop any code related to SCM_RIGHTS").
> 
> Fresher stables from 6.1 have io_file_need_scm() stub function which
> usage is effectively equivalent to dropping most of SCM-related code.
> 
> 5.4 seems not to be affected with this problem since SCM-related
> functions have been dropped there by the backport-patch.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 705318a99a13 ("io_uring/af_unix: disable sending io_uring over sockets")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
> I feel io_uring-SCM related code should be dropped entirely from the
> stable branches as the backports already differ greatly between versions
> and some parts are still kept, some have been dropped in a non-consistent
> order. Though this might contradict with stable kernel rules or be
> inappropriate for some other reason.

Looks fine to me, and I agree, it makes much more sense to drop it all
from 5.10/5.15-stable as well to keep them in sync with upstream. And I
think this is fine for stable, dropping code is always a good thing.

-- 
Jens Axboe


