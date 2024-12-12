Return-Path: <io-uring+bounces-5459-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60E3E9EE4E3
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 12:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 483DE1886C2B
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 11:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE432101BB;
	Thu, 12 Dec 2024 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QRP0c1zt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA431C5497;
	Thu, 12 Dec 2024 11:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734002449; cv=none; b=mP5EdW4F+lZpoY/dh/cWmPR0Vc8PDC9Oaf/GJ1Zd+RqjM4cWnl9RiAXSSsCY+cJqXLULoVNEaZh2I8iRVuY5MIXfIdYlkJo2uT4LhwKsOODOhXpOQktR3KwaN8HvD+xn5ZCzF8P9R+13Fap5cvArdgP73YNkIR2uLe0BIAF4oYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734002449; c=relaxed/simple;
	bh=K0alDfkVRM4GixWQKBi2xildKzL+uQdSn1BMJJNZuUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cugggi4aMdi86+PCznVTM8AmyOxlqijH512VWkaGI1XzIG5nWNr6XjhhHLiFq9oqyqSiohs/KK/7GrcXsPJneuZV7IDYMwA83PsG+5hlO+jx0rg+ttUIbus8z73hWi4T94s+wCM9AGqIYXxIwo9rzonpPFajnzBRkscG1yNWBAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QRP0c1zt; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d3f28a4fccso681187a12.2;
        Thu, 12 Dec 2024 03:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734002446; x=1734607246; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ED5hrp2kgt2dd8xV3Z1fC0SU7DMXRbtJN8k9vIkCfGI=;
        b=QRP0c1zt7EMUr7tUZOOgcH1soNvvaaaQR0ZneiojJaEF3EEPMhHYErE59fYpiGdqow
         TxqfC/vq5fiMobQgX9EF+b1MtVCjdnVZGZvuYdd2AtqGeOlcayf7RLEN20kGOjUH0Dy+
         TOJK2QJqne1C1onm+On7ENBzF7BfzSoTM4ZVb9/4eK9kwbhMdPMCmnpNkWDxPuRA8rwt
         JwRa+CgsWos86ltzWKtUCyXimioFkdjYhC+GAMX2FBVT7LFl1ctQq7TnSOLcMLSKbNNc
         X3+flR2pqB3ypkn7r0ahN8Wv4h9f7wXuVtVCGKiTCK4W16utaBIxXb3Ua8zj3194VzT3
         Nq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734002446; x=1734607246;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ED5hrp2kgt2dd8xV3Z1fC0SU7DMXRbtJN8k9vIkCfGI=;
        b=L4bouc6ud3cDkD8Tvs0mrXYTy7kQl8UBdK+sm4BjyLd2/j4dyWGfGdP6OlFvsyX/cQ
         yxtSW6ENJbveTL9rAMDJEuNpuczrA8+ePXNHxmVuorQp07DYpc2hXqaTL+FOoojX9hZO
         GOVYg3yBItuzqpU4p3EiU5DbosRNHVmiUmH0zOT573e7UEIgnConC7892NmjC3aJnHf6
         5bPq7jWs3LURNOybmo7J2opYpRFhGZ914L7XOFclXdmuV3o8o4ZVFdIA9+QeY1ZzNJ//
         LCR3a60r4RcPFZQPXD4Bh2Qmgt4v36/lVjV6FI7WzyZHdDnCZAhpOEkcLRtIE6BbIwZL
         oJiA==
X-Forwarded-Encrypted: i=1; AJvYcCV6O2FI+fFjF8x7oN4ACSGK1kc7EG0QngbFMlQ1LBdKMDX6B5mWDfiilUqVN7sYIXjyl2U1rUvwzQ==@vger.kernel.org, AJvYcCXa3BMdrvyV5v0/wTqNDS1JoLAKyCBEK+3ap1xfiR/8Kflvvvao2AECW/HcishmeUOOwyqPRWGp0BKJRRmr@vger.kernel.org
X-Gm-Message-State: AOJu0YymVOPePWh4OUqW0N/zhdPAO7yqIhunzpZS/aQSc97Ll/K8XA2T
	kDlK/Ei00npwwWtw+ANk1fJ7C0H9NJj9iSgqbFFM/6tnE4adjU1A2EdvEw==
X-Gm-Gg: ASbGncsNNTcbWsbfcLUnRaRkHbgYZ0iE5IjYNWOcucwepouIuD4RsBvjsoGQN4qXvj/
	zfs74fQtbLzFTw6LIon+8A/RSw1PQP6MB5uznBQKTP18QymD3DoEEQAT5NqClJVlPGlYllU/uTD
	7gMWVwGmr0dmcrGKG5DKE/6qMWQp3qjaR4Ci4wlZIYNQBC8X8ybAuY1i230Fd62KRvviWB/KZRM
	FAtOhQksk+bI37MG8heKsfdo+AMOe5ju0GDT7oL7qUiiQ7yhSn1eBWgg1bUNo7YZQk=
X-Google-Smtp-Source: AGHT+IGuSK2rW46YEXzDTA50F+TrXwFJ2X3gZtjBu9Q5sloS3kAV1HVs7/ZUWG9+rrK7foKVs6DtFg==
X-Received: by 2002:a05:6402:2786:b0:5d0:d183:cc05 with SMTP id 4fb4d7f45d1cf-5d4e8f65a64mr665041a12.5.1734002446178;
        Thu, 12 Dec 2024 03:20:46 -0800 (PST)
Received: from [192.168.42.68] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3df02f416sm7461599a12.8.2024.12.12.03.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 03:20:45 -0800 (PST)
Message-ID: <54192dd9-d4e6-49ba-82b4-01710d9f7925@gmail.com>
Date: Thu, 12 Dec 2024 11:21:35 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] use-after-free in io_cqring_wait
To: chase xd <sl1589472800@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADZouDQ7TcKn8gz8_efnyAEp1JvU1ktRk8PWz-tO0FXUoh8VGQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADZouDQ7TcKn8gz8_efnyAEp1JvU1ktRk8PWz-tO0FXUoh8VGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 10:08, chase xd wrote:
> Syzkaller hit 'KASAN: use-after-free Read in io_cqring_wait' bug.
> 
> ==================================================================
> BUG: KASAN: use-after-free in io_cqring_wait+0x16bc/0x1780
> io_uring/io_uring.c:2630
> Read of size 4 at addr ffff88807d128008 by task syz-executor994/8389

So kernel reads CQ head/tail and get a UAF. The ring was allocated
while resizing rings and was also deleted while resizing rings, but
those could be different resize attempts.

Jens, considering the lack of locking on the normal waiting path,
while swapping rings what prevents waiters from seeing an old ring?
I'd assume that's the problem at hand.

-- 
Pavel Begunkov


