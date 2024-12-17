Return-Path: <io-uring+bounces-5518-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1BAE9F497D
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 12:02:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B4D5188CF5E
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 11:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD041D47D9;
	Tue, 17 Dec 2024 11:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gzh7Qvl2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122091CD215
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 11:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734433355; cv=none; b=MpVwv4hyNhDgriOno1+tWXRfZH9DwFNbHB5PWgmLQRyfcAhf8MKxEgzS1nK+jjs5CuyuW8uKMaVI7stwI6+AhAPs1w03x+jVlAcVxUhU7qTuXDQXMM4+Z0RPgMiquWSA396H8z5x2OwUIq7fkfvCyJEP32nvqSv/0G3dUUzwEII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734433355; c=relaxed/simple;
	bh=NsBVFYilP1zfmY6SqMDWHWeCTMkxVpOs3oMc1gDhpns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tL88IrnxIlySxx6c6XPSYSjijS36HY1S6TwXIS1AA6XglQeQejyQCHYYgiie3lJFCHOk8cryh3PnlbYckscZ5aMY8KLxNnJKCOR5N/PBarGFr0lbNH0nH01+xcDzvlIm782f1WYumf2QukP7rMd7mCAwrrSjq2TX3yb4jv754to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gzh7Qvl2; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43618283dedso50359965e9.3
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 03:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734433352; x=1735038152; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QbOY3BI58ZnAQr66I9mqgp1ACmI8vHtwLfc8vT8bbkA=;
        b=Gzh7Qvl2lrIn0+wAMvBZePbA1tqAe6d93m0sMmkSmwtDmaqMfdlZ/sUSCjEtDzscov
         rCoX5drm6d2Ck3pwKnWvyA+Wy5kHFJ5smFtcgBIJaCaGJvElQi4RwO/EA/YICfmNNkTO
         vmRQhDmoyQnjxAQRKSRC1LMbAHevsUn5rcRJqVQueAQHG51o8AJcNn89ywtYWZOUggFD
         A+36Ovhn92O17e4bNb8U8Mx0RHwGMFM1F3aRicaOWVI020S61WoT5Ps5GcNJEN6PsWTo
         lgzceLHQlGlIQEWwOqLKKmewHkyd7IDWIfA0RsZQ676z15c3ffMJ5YwHboB9efU6WAKV
         e5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734433352; x=1735038152;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QbOY3BI58ZnAQr66I9mqgp1ACmI8vHtwLfc8vT8bbkA=;
        b=d6RhSzZwTVswUkvMXGrfLbpiDNFFqRufw95DsBsQv/bk+6fiJIEoX6jDub0SeYIlSG
         +PSf18Uj+JsrRR+oj8IO2NT5SYJHPuD9mYZprggGKjBiKxlAhNWqTN2nVTi4pTmcvfCi
         lJwLXBoYIHlOAopoz8y8fHw7JAzDgJ8wFTHM6fXJ4K/N6IOCyVvmHqIqRsu8n/BQdnkM
         nE4JIF7znrhN7Hj2BsyFHm3/rpIYHAY3BZakG1JRJ3yNEcQfsdnXEs/gUYQFpq71rxml
         8rCUo5CxCTkhBjYxg+3ncq8tz48mFrCXFwC1JS0uV1j4T6SK5rlGLt3FX6YE7Z33fklz
         zpMA==
X-Forwarded-Encrypted: i=1; AJvYcCVvDxPkjpkAjbJ2R6KW8MUf9UtCQgQ9/NJwHwKW+lWG/e6v4wdpE0KBi7kv8TI9QigFO3KTqeQZGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTESULMw3fh+xieDtG7BarH34I0s/407OwPryjlnaoL//f/Dsm
	YOwS/hL+U34RC1X5oCO1+4SNI91wltuduhQYTPP45Gfmx/5xcO6f
X-Gm-Gg: ASbGncuTFNfR03DRK9GRO7srZ9x81d0GAgepQJsPJqtKe2mm06Tz+48oANLap56Cdyq
	1DKaMY9V0P9WEv0SKT0lJi55bsltfxnJShNza7MEMWIlTY4l7Vt+JcyX28N5rwu6a23Q+4uTSfm
	5guJE8FzAq/R3c2J3pKQvUytA+tCKY9Ow6vunW1ondD2NJw92r4RBFCZNwxjp0vXez28/tL55c+
	Ivcku/Dm98i9E4juyq5mdykZVELIiN4aDhWT3G4VHhvadCtVta86BjFEbdlDSFpnHE=
X-Google-Smtp-Source: AGHT+IETGOfill7Ta0lIyI5E5xOY7y6LjcBp3+fkz74A8W6ye7iLyW06ZwyrJ5lhfg7HJYgerrkL9Q==
X-Received: by 2002:a05:600c:4ec9:b0:436:488f:4fe with SMTP id 5b1f17b1804b1-436488f07b0mr18858105e9.22.1734433352050;
        Tue, 17 Dec 2024 03:02:32 -0800 (PST)
Received: from [192.168.42.240] ([148.252.147.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43625706c82sm168680295e9.35.2024.12.17.03.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 03:02:31 -0800 (PST)
Message-ID: <c51a815f-89f3-483d-bfc6-0f7877885aa8@gmail.com>
Date: Tue, 17 Dec 2024 11:03:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 7/9] io_uring: Introduce IORING_OP_CLONE
To: Josh Triplett <josh@joshtriplett.org>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, axboe@kernel.dk,
 io-uring@vger.kernel.org
References: <20241209234316.4132786-1-krisman@suse.de>
 <20241209234316.4132786-8-krisman@suse.de>
 <4100233a-a715-4c62-89e4-ab1054f97fce@gmail.com> <Z1nLRcwaKPv7lAsB@localhost>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z1nLRcwaKPv7lAsB@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/24 17:26, Josh Triplett wrote:
> On Wed, Dec 11, 2024 at 01:37:40PM +0000, Pavel Begunkov wrote:
>> Also, do you block somewhere all other opcodes? If it's indeed
>> an under initialised task then it's not safe to run most of them,
>> and you'd never know in what way, unfortunately. An fs write
>> might need a net namespace, a send/recv might decide to touch
>> fs_struct and so on.
> 
> I would not expect the new task to be under-initialised, beyond the fact
> that it doesn't have a userspace yet (e.g. it can't return to userspace

I see, that's good. What it takes to setup a userspace? and is
it expensive? I remember there were good numbers at the time and
I'm to see where the performance improvement comes from. Is it
because the page table is shared? In other word what's the
difference comparing to spinning a new (user space) thread and
executing the rest with a new io_uring instance from it?


> without exec-ing first); if it is, that'd be a bug. It *should* be
> possible to do almost any reasonable opcode. For instance, reasonable
> possibilities include "write a byte to a pipe, open a file,
> install/rearrange some file descriptors, then exec".

-- 
Pavel Begunkov


