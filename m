Return-Path: <io-uring+bounces-6488-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22DC4A3858B
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 15:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4352A1884C48
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 14:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E94221CC7E;
	Mon, 17 Feb 2025 14:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FsMPZyT+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A05179BC
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 14:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739801263; cv=none; b=uTzHEPMN1uF6aDK2/cJc/KFgh0F/+qCULa+oyu8spnDuIYb/2mFjIALiQ9MsNmzn88gyRhqFs67f5CQrXkh6XB0UDKLpZRI90RFJup/LZY7msvIhLBwLWN0W//97JJwCaRmoSD2yHD3jKcrG1lzcEGhv0jrTEiXU4QqPo0ruMfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739801263; c=relaxed/simple;
	bh=SeIlgcxhmRDZlh/oqBdhf/L4QEqEpo1it3WFLoNrhi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aL/8QkCoXgLtK/922lCz7psBWbHPIvkOpyPJJkRliJ6S9Gj86egE55jkjTxgZ3/xVlwNl/Fjd60qOW6j+eGgHbIn65E18RsVwXMmJzqsLUuP/eb16TfuDfVEkY9WotXEjkbjyn5Rgn7XcASQh4eALjGsCDNkj1Aizv1I44JgONY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FsMPZyT+; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-38f1e8efef5so2334244f8f.1
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 06:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739801261; x=1740406061; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yj13b8lTTPaUsLpS7c2CEQvM5audUmq0dd7xX0lCkcs=;
        b=FsMPZyT+zyuTWt/gKI7Xu7o6t+LEudwYa8Der5eIlEshWl3FPXx83vtnVu7eLIIzHb
         BRzUqv9Y2YfEjAhKosUuVFUmC6g2cBB8Vzw9Eg+ECNA75uTHD74Csy9E05Ti9j0BUY7z
         nM9dZq+ItroMoTD3T/U4B9tUSwdnNhW/3o6yBWzbHk9DH+knAIs0/SpzQ/6PNInFTyBa
         0Hoe95STaDXdHM1IdeGp2VFyPjsmMWVZs8McCFxoBZYc+60+X7aKfVnN6iO/dob1V29k
         8+elTRUuKYac0wIxdivYgVwIIY+6Iex2+mEL13l6D6xwyk2yuAbGkAAEyiSWakCnVlYe
         5z7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739801261; x=1740406061;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yj13b8lTTPaUsLpS7c2CEQvM5audUmq0dd7xX0lCkcs=;
        b=BlxLixBpDAkWU9D9MMmLFYKpdU6Iv7N0x24dml99IItzP1QHC57AwDFWwFhTuVdsWg
         P76pA2Rm0S5BPl31VSretRxHBff4OtbbbXgKhTW1WIiXcuxgQlqpa3q12yP1kQgbZQIW
         iQB/RMBp5wzPG9TN74sUhYGDY/WTEs5Hlh+lReakW8hSqgaAfcRERq+GsJGgjdnEJGCo
         k6rzkIwwyPAwyS0IKtqgO5g/vAYJ4pcO4z1uy2ETFXQzFH4pXpaDc1320M+YClgqzrDa
         EzGEfL9ibl/xRwN+QRtjAlxnb7WJAAcWndZhgX49ZvkoftFOfUBBgEh6ZQhPe5EdAMpx
         D+tQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuyEEyuhvWEt7TA8MoLVuPIX8oWFHdUKDK1yV4/tDGJauYrkz+dewc1TLNnPbBTWSQwXsy+YwX/w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzje6j0a885Bw2tUQHFkypwV0Su/b9duJx1ggqg4w+0+8B+NqcA
	WSB9xe8WHUUzQooBXKB5EG3RSP+6XfY1DRvki25UZn0CDpwUo9MAx/epgw==
X-Gm-Gg: ASbGnctNcAqQ7NBwfXIVAIH7Qw+PVz59a4BM/9oRmgbYiiXwEsjSCs1xJmSYWnYW3RX
	Pa6KBAdhSiIqzi3BGtsqS3zl54TpJL7G7SfSTqeWuwl14GCftetgY+++KjcT2tBahEKGtdxuZkY
	ayT3jl8Z8h3w3Bvl1tTGGYLcD3vvjbQz3ObCN74uUiFf0mqOZ1Z1olo+as84a+u1OVQVkth6CDc
	ISNGFrA3K1QsdAEY/OWZiy41Oaq5q4oKiquGQeK+v/ERkBQ7T9GrXsG4hu63sRvJvkjBSXvxhG6
	xKJ0MVkmvnTWJtGqHvpXnKYb
X-Google-Smtp-Source: AGHT+IE33MJUWh7Jv9qVfx52O/MdSuarwiSt+lsG3or6MvEaV0LJFHTaJ7e6Fu40zPh2IhKmYZ/l5A==
X-Received: by 2002:a5d:5885:0:b0:38d:e02d:5f43 with SMTP id ffacd0b85a97d-38f33f118d3mr7500726f8f.2.1739801260478;
        Mon, 17 Feb 2025 06:07:40 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b4423sm12575485f8f.11.2025.02.17.06.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 06:07:39 -0800 (PST)
Message-ID: <c5daca6a-dedd-4d6a-a30c-00b7b942d1eb@gmail.com>
Date: Mon, 17 Feb 2025 14:08:35 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
 <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/25 13:58, Jens Axboe wrote:
> On 2/17/25 6:37 AM, Pavel Begunkov wrote:
> 
> The kiocb semantics of ki_complete == NULL -> sync kiocb is also odd,

That's what is_sync_kiocb() does. Would be cleaner to use
init_sync_kiocb(), but there is a larger chance to do sth
wrong as it's reinitialises it entirely.

> but probably fine for this case as read mshot strictly deals with
> pollable files. Otherwise you'd just be blocking off this issue,
> regardless of whether or not IOCB_NOWAIT is set.
> 
> In any case, it'd be much nicer to container this in io_read_mshot()
> where it arguably belongs, rather than sprinkle it in __io_read().
> Possible?

That's what I tried first, but __io_read() -> io_rw_init_file()
reinitialises it, so I don't see any good way without some
broader refactoring.

-- 
Pavel Begunkov


