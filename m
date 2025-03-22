Return-Path: <io-uring+bounces-7198-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 099FDA6CA1B
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 13:17:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68BCD3B75B4
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 12:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A246199934;
	Sat, 22 Mar 2025 12:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BfXpFX10"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E531519BA;
	Sat, 22 Mar 2025 12:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742645870; cv=none; b=hwPQK02JcxJ8ADkxwSXzUjtLrNzpYFeUI6gezytFlupskj++dwMSqp2EUcHw/zdDveMNOhCC35QYAGusNL+3VvsgM9AyebA4o9smWcDnWnb7FU88ZsV45g3HufoavBC3lvGWk2RAnWA4t4ldNQ5LjrsLoPyznpyQF0pcZjWXD24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742645870; c=relaxed/simple;
	bh=xVgqGVzqpQ/awjytHOqDWt1+4Ym6FX1qpE9A3Tn1cFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Za+Ubam/dToBuiWGjhiYfoeuSxXYGW3l2LrBVtcC8Kz9MkhbTdXbfNm0KCGdNXNNIrkwRi0GwPiDnI8vwstBgVnToZ0DIJRlQqfbiZbkmEiqQyqL7QWB1lIiHqjyeLPS6L4EUAh6T11ktGmjuXJStKIih1xglv5V/FwCW3F6kso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BfXpFX10; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-abbb12bea54so274246966b.0;
        Sat, 22 Mar 2025 05:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742645867; x=1743250667; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P4HDI5VjdjIs2jVHnIwb1VkXitmTpZuNV3Y614FNy5Y=;
        b=BfXpFX10QNJSz/GAz7h1SqyNh9Y3LKar/X2zmni2LVzHAOSahvI1YQcbisFE1D3VUs
         nDA7+nlPL0dbDOCMr04aSUQkhkFKHzMR8MGXaQ2h1mBC/hdLckIsV/Gq6zvBgwQAKHyy
         bV2EJwNzmsmxzZuO9RQsOhlpYbqrPYF5OendzKCe7xiYt8obvZZTffyN3jGu1yVTb8Xc
         Xnxo7lUKkeABfoXsNjNOhn+PSziU5QoHzCOdpPPQe7ZzXVkJvUsXuomFILVIYxUGrT0x
         RB8Ei/TveuC5RqfgeQbWLHCOE0JEY1OBLTmBGJIl2NB3yP1KwWI9v9J/1F6axdIuz3yM
         qgsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742645867; x=1743250667;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4HDI5VjdjIs2jVHnIwb1VkXitmTpZuNV3Y614FNy5Y=;
        b=MQnsSOAq2hCkjNWJtB52px5ljIIHJ0ru69V/OAzWc0FKqtT0h3i92OX0HwoY5bAslL
         aWBoTnvlNT1Nizp/CZkn1mwCszWh/AbVzwlODUo5et61LvJnTTmUkor4dVhdwRGcTkiE
         dgkGddvbuocpNI0heNMHEJpOu1MDWc6wu4QnuGABm902O2m3zPpMvwvjSjfyU5jIldgB
         D35znwcnpI6sS/I6dE/WJImQTVy+N3mpBUlWFZFpHosK4KIdK501RwAQe0RIR7Vt9/qA
         3Z4Ak8g5zd+ndQWg9LgfeNbW5caKLAF0swfqScGpGYtKDfuc8jKS1bJ9ClraXhMHq5Ms
         eSQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWugfhSYVrHnFpYJU6CX29C5/c3MY4gkxxsDWjiG7BunPbeDdAiaRIbsns+NbG6JlTh4eVcHm5Njw==@vger.kernel.org, AJvYcCXzaRBS1yUONxGEJCzS5DK8IE5LzhxY/tyIZCpvp+QRn4GQiG/S2qTqPNUXaapVAKYrqyIKxfP84/bn5RoV@vger.kernel.org
X-Gm-Message-State: AOJu0YzYuL+sqRVcb9VB9opwVZI4WtTxobyDb4sJZEW2WK5BwLN/s0QQ
	JjauOHRrCSvQ7H0/oJyunNPeSkmQS9fD+cJhFTwZcBtUIZksYMmC
X-Gm-Gg: ASbGnctgiX+xc3DYENcFuLp8owf6bGP8ibNJOAnwyB0VnbCKDZY2s2eJ8QvNpkn2sxk
	QykhJFQ/yDwjKXICL0omuDl6/rRIG8aqVyhK1mt1t49agp/UznbQCk58utsmTkczc9IuF6sG0cZ
	v2e5YR3GLbXjlUhyKT73XTUPwk7CI95XEeAgpfAzyu9rT7SWNJgrKT3IdpO5LDE52tqjyFGpLD5
	0hWbW2Nd7c2O0aJFT8G6Pn89+aBaFTW5AbxfJE6r4i3z3xHuVQzWGNoOJprmwJnWPs0oWcM3dfz
	srCFHhxpEl7/i50GnW45k3jZnDoaxr0BtmZpITjtELu4vCy6uVI7
X-Google-Smtp-Source: AGHT+IGTuEpHZ1J0PVeUKZ2VvqMGPeVTC2axbdt19OYrJw3swztReYqCcwl8lgFmgDWsSvmvtEHqpg==
X-Received: by 2002:a17:907:c5cb:b0:ac4:2b1:56cf with SMTP id a640c23a62f3a-ac402b17f6bmr376798766b.30.1742645866479;
        Sat, 22 Mar 2025 05:17:46 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.37])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efd569fesm336941466b.173.2025.03.22.05.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 05:17:45 -0700 (PDT)
Message-ID: <68e33a48-8a77-4c49-824f-902187a4aacc@gmail.com>
Date: Sat, 22 Mar 2025 12:18:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/uring_cmd: import fixed buffer before going
 async
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Xinyu Zhang <xizhang@purestorage.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org
References: <20250321184819.3847386-1-csander@purestorage.com>
 <20250321184819.3847386-4-csander@purestorage.com>
 <8338ac70-ed0b-4df5-a052-9ab1dfec9e26@gmail.com>
 <CADUfDZoELiri8Fuq3tHSsKf1XhPVaZ1eoCzfXK7g994VY4o9Vg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZoELiri8Fuq3tHSsKf1XhPVaZ1eoCzfXK7g994VY4o9Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/21/25 21:38, Caleb Sander Mateos wrote:
> On Fri, Mar 21, 2025 at 1:34 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 3/21/25 18:48, Caleb Sander Mateos wrote:
>>> For uring_cmd operations with fixed buffers, the fixed buffer lookup
>>> happens in io_uring_cmd_import_fixed(), called from the ->uring_cmd()
>>> implementation. A ->uring_cmd() implementation could return -EAGAIN on
>>> the initial issue for any reason before io_uring_cmd_import_fixed().
>>> For example, nvme_uring_cmd_io() calls nvme_alloc_user_request() first,
>>> which can return -EAGAIN if all tags in the tag set are in use.
>>
>> That's up to command when it resolves the buffer, you can just
>> move the call to io_import_reg_buf() earlier in nvme cmd code
>> and not working it around at the io_uring side.
>>
>> In general, it's a step back, it just got cleaned up from the
>> mess where node resolution and buffer imports were separate
>> steps and duplicate by every single request type that used it.
> 
> Yes, I considered just reordering the steps in nvme_uring_cmd_io().
> But it seems easy for a future change to accidentally introduce
> another point where the issue can go async before it has looked up the
> fixed buffer. And I am imagining there will be more uring_cmd fixed
> buffer users added (e.g. btrfs). This seems like a generic problem
> rather than something specific to NVMe passthru.

That's working around the api for ordering requests, that's the
reason you have an ordering problem.

> My other feeling is that the fixed buffer lookup is an io_uring-layer
> detail, whereas the use of the buffer is more a concern of the
> ->uring_cmd() implementation. If only the opcodes were consistent
> about how a fixed buffer is requested, we could do the lookup in the
> generic io_uring code like fixed files already do.

That's one of things I'd hope was done better, and not only
specifically for registered buffers, but it's late for that.

> But I'm open to implementing a different fix here if Jens would prefer.

It's not a fix, the behaviour is well within the constrained
of io_uring.

-- 
Pavel Begunkov


