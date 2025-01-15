Return-Path: <io-uring+bounces-5896-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAAB6A12CB5
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 21:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56449188A568
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 20:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0217C1D63E6;
	Wed, 15 Jan 2025 20:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qvvwTUyI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A37119922A
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 20:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736973074; cv=none; b=MlvS/Ca1kybuHk3c+12LVGCB5AAL3IXC8dZnEhhrH+9YWhkfn5n7zLhnH/8jBE+E+MAOHqQB6vWLyMwWZafpd8MluobwS62D8OZHx5EwIi5CPtTDcaxzSuhiCf2wBwbF8xdoVwdwVAJf49YDxxz7WK+UQmSRfdouMusXNJsj4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736973074; c=relaxed/simple;
	bh=axI3C9pmiXVxd4d2Rend8Oo4A5UQKekDdVEH+Jwuj40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iznMXC1URVFAB02nBwZfGRxCG+NzGBMmbiRNSNcymc15rOf5unjESbtGXPjYsuaLBO1IZH8yQIPd4nmcQD7GglJ4au+xypC0GQpv4CaOMei5Q60lJel5ASTC4kxvfonpwsH723vrTZY8HRYHSiL/KNlH1BHZO1gsSAA1Oj7CktE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qvvwTUyI; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso579765ab.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 12:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736973072; x=1737577872; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g+moXg1+vM3j/lpmqYe65EkThZRDprziRZVRxiFDnN4=;
        b=qvvwTUyImCWRRyaVAT4Dq0YynvEKoXbMZO2OJvLpXjPVMnRNxky+Nq2eqodc0ZHmWE
         It6iClYOLbOuzirzEJ+rPeptOYxAjtr9FDAW3wmraRUrGsiatOrFCMhZJZbcdVwtKjS4
         ntBQjLoogmSkUNbgdKpE9iVLV4Htnf4kGMj5f3rqHwv9QvpA06HNfXSxdun2W5fIHHei
         8OBDdV4DwyaKP0yYizO7c3npAZo4jIE36UyaLv1cvt9dlzQLm261J+QGtTr95ayVLdLi
         +1kbn8S5m8hTEDJSeGhMSZ3Qus+RX0X5GWRZnKtERKqP1VkV8/EMZrKr0D1+mxY7oNtL
         0UMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736973072; x=1737577872;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+moXg1+vM3j/lpmqYe65EkThZRDprziRZVRxiFDnN4=;
        b=rMVtmsdHwiD7ZIG++VLZbKF9Q9GWY9pDGJAiwq9X57biE74LuB3kyYAOqLLFmcQz2s
         bha9zIs8HEAbXT1Omcsl9vbmpY99SOncOKOOdCU8eR//6cYsEDumNTkmMqYX8V5xJKYl
         UkSDJIygZome/Gq2IyspUljvDkMGOi4tuNG3OjKsiNquVxmQF7kBfkvXuCcYDgrJSUB9
         zcTEaH+uG3i5lwjjL1Ik9sVZEEkb6IB4VPFVfOlVTu0z1ZuQAJ5oJDa1OZ2hkeWAqEm0
         DIhmp+y5ifgMuwHDG9V11t4p2ony/V71SpRQZTCrtMYUwUG51LKZhFeIDcn6lkEwrzXE
         DpHA==
X-Gm-Message-State: AOJu0YzrePSMwQwZBzyaizw81HVG4NMgPYKf8xxyrf+ZSWlsjcjgG6DD
	Wcf1Nke99GwnRNbDCtFTlWn6spQFtREpPQz61zUbbkzhEZKEFWsBMGvdbnm+uAo=
X-Gm-Gg: ASbGnctsvFJpA/dkG0ejYtot2NmM3DqzqXIjm5qWaRbimD+KLgiMG/DDOv6YyORI03i
	VN4jWPHpZ/ZYKEprIrSiBjYdfgaTaC4hMXHVMiqUIdalxKQZNjCq7dv/53SdRfTTEVytjVGhNWH
	bEoYlWX5YoqK2uF5PL6LlFIS8dqS/wnMAnDOH9aSUKY9EMAlbsDy/S66UNY0yUO893OduxW0HEh
	P4kFIJVHiOpyjeaXniHKBJnrLa+SKXYmsTsNkxjrPmNb6qklh1R
X-Google-Smtp-Source: AGHT+IHGnIH+FlyQWwr0kweCQWipYOGWCzszdyeGZm3SMPNqsQ+l1eA/xCjgEDXafhxYcXvftyzhxQ==
X-Received: by 2002:a05:6e02:3cc5:b0:3ce:8031:31 with SMTP id e9e14a558f8ab-3ce803104aemr68382505ab.18.1736973072553;
        Wed, 15 Jan 2025 12:31:12 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce800908cfsm8555045ab.29.2025.01.15.12.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 12:31:12 -0800 (PST)
Message-ID: <a652b0a2-4ff6-487e-bc0e-2e3840a2abea@kernel.dk>
Date: Wed, 15 Jan 2025 13:31:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: Simplify buffer cloning by locking both
 rings
To: Jann Horn <jannh@google.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250115-uring-clone-refactor-v2-1-7289ba50776d@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250115-uring-clone-refactor-v2-1-7289ba50776d@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/25 1:26 PM, Jann Horn wrote:
> The locking in the buffer cloning code is somewhat complex because it goes
> back and forth between locking the source ring and the destination ring.
> 
> Make it easier to reason about by locking both rings at the same time.
> To avoid ABBA deadlocks, lock the rings in ascending kernel address order,
> just like in lock_two_nondirectories().

I'm going to let this one sit for review for a day or two, and since it
depends changes slated for 6.13, I'll queue it up in a post-merge branch
for 6.14 if all goes well.

Thanks!

-- 
Jens Axboe


