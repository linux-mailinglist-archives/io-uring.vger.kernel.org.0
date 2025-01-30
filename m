Return-Path: <io-uring+bounces-6188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7FAA230B4
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 15:57:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 713611888617
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 14:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14E51E990E;
	Thu, 30 Jan 2025 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sDX57FVR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AAE1E376C
	for <io-uring@vger.kernel.org>; Thu, 30 Jan 2025 14:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738249055; cv=none; b=amdjYz7qbzMvrQte2faO/l7ZcSDxFYmJbv6f1Rnh9rOiMU5jyWUbjbqRdZq2CQwhv2qrSx8EmX97IuvpYGCscl0YAqR54IVNTDBSRDKzM7qh0jd2Pzq2WLC99nRO6Yud1UnHQDNNGGV+T9leZZz6mEMs9OsRyzcyuW5wq7TAG38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738249055; c=relaxed/simple;
	bh=YCZHckUY30EpY3myEuNhOgHeD4k60WPQ9NvbFsdg0Tw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dKk3pstj8xhG57L9RrwAko1QSny+4G/Y9IPtGEghHoMbWjEcrvsoCHx8VIav4cSUqafmpY3FT65BXdLTm3x8/cUZmEWLcgf2a9n6e482VQrf+XCqfiX88oSQ9DomlPFPB6ZE26HhNscsKioAl9X+3HY3HtLl3fow6rbsbDfU+Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sDX57FVR; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-844e12f702dso24193239f.3
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2025 06:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738249053; x=1738853853; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IkEv1U9/G112flH4HXsgLJlIh40LmsNnwp8XpHC5mu8=;
        b=sDX57FVR1naKqVDzgOy9EWFO6gS9X99Hvqq5kEN44SduxPdTYtZA+ha9H7SHEWbCwa
         80dNn6qfR+yQNWxGG9dpQhzju4pd9cDDYO8e1qmQDMTTHsEI8Km5QPX3o59pUe1RB5WR
         xeqVbXeopD3FYczSlfnlk2zopjSYmK7ZpATc2NpzruRdGKRfnXmA5R7KawvoLfy73iPT
         IbgQX7XuKLlDTMgKvCF155vwfn5S+wdtss5xTxpFzZ8eHGGxRk0+AOZiPt0iDJPhQBxP
         f41YPCYfWAhLcjSN+LvEsy7+WaJzHBHeHAeaEXxeyVaqnCQ/vBnz7Tx6WTxs54yPNmSZ
         L5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738249053; x=1738853853;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IkEv1U9/G112flH4HXsgLJlIh40LmsNnwp8XpHC5mu8=;
        b=Lw8gwqq4oAAQw6r3syZhCJOuG6HgjcUxabXvGxvuqaSv3mR4544cyppj7ebEqkxeSW
         Sr9PjA1r8vBFEjM3+9OkCxsNIzfxK7oSe7BGmsdOCMVvh4Mok6NcxyAws7rQnbuzCyGG
         QpAst4ZzoDBxM3LN5wRR91+vs5eg9I5eZapzveA0ZiU1WvVkzwxaAnXcZXjhEkyUwUj4
         hmEUcHeOZ5e+Xit1yw8utnUow5AIhzykNnjKEuAG2HqTAMG/MRBiAJNtS74wK/Kq4c3R
         kulZU1+xInSsyUkzBxAvDAAgz0yy+ujVMi4ymHZOYoNZ6opnv/Ju4WpXPLAkRAfhJ84V
         vbAw==
X-Gm-Message-State: AOJu0YyCS+lBw1J1cf+xKMUcdKkpAeo/5DpNsLtaLsaEH/Oelk4N30Wj
	0o4ksHsCppBxjc0WTtR4+qZZJDyKOaUdj0nVKWODSkEmOKSHinlxlvoG5dTZG5E=
X-Gm-Gg: ASbGncsYvUiF5QS2E4XT1tTWfmvrK1qN4USr4RtZIFq04QcitCrttdjyzAaTJfgOjsq
	AxDHN/iWOVQ+rRJ9pX5MDjYU0dulWveIv/ShQy02iaGstT7Fxxddo+YeoWSqi83wnfE6diMpVMN
	5eB/mnPbUJCqHQvznr/1hrmlL8NUKNZQAf1liC2a+5snyts8DIXt4Ss8fGx3AjuUNe5IOTN6DP/
	ZlhHd3au2rOxB7Nqiyzyqcox4PAB2VYcjnKAEPjLLsWaVGym5b1zLX0mU/3o2yFHiQMvD12Pbr2
	3Djb57d1rZU=
X-Google-Smtp-Source: AGHT+IHsPgBqrAaLXMoHQyxcCNZgX3JmNrsqrf7wZXRph4wB0B0s6UXG4pSGyekff6oPIKUzdwWk+A==
X-Received: by 2002:a05:6602:148d:b0:835:4278:f130 with SMTP id ca18e2360f4ac-85439fb2695mr748203339f.13.1738249052768;
        Thu, 30 Jan 2025 06:57:32 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854a17185a0sm39411239f.33.2025.01.30.06.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 06:57:32 -0800 (PST)
Message-ID: <6fa97ace-362c-425e-a721-5e2a9921fe5c@kernel.dk>
Date: Thu, 30 Jan 2025 07:57:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] io_uring/io-wq: cache work->flags in variable
To: Max Kellermann <max.kellermann@ionos.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-5-max.kellermann@ionos.com>
 <856ed55d-b07b-499c-b340-2efa70c73f7a@gmail.com>
 <CAKPOu+-Mfx9q79nin7tGi1Rr4qGGY=y-2OhuP80U=7EtRpfBdg@mail.gmail.com>
 <19750632-1f9d-4075-ac5c-f44fab3690a6@gmail.com>
 <CAKPOu+8_Tivtyh0oj7UEuWPmdw-P96k3qRLvte1F1C9XivjS7A@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAKPOu+8_Tivtyh0oj7UEuWPmdw-P96k3qRLvte1F1C9XivjS7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/29/25 10:36 PM, Max Kellermann wrote:
> On Thu, Jan 30, 2025 at 12:41?AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> Ok, then it's an architectural problem and needs more serious
>> reengineering, e.g. of how work items are stored and grabbed
> 
> Rough unpolished idea: I was thinking about having multiple work
> lists, each with its own spinlock (separate cache line), and each
> io-wq thread only uses one of them, while the submitter round-robins
> through the lists.

Pending work would certainly need better spreading than just the two
classes we have now.

One thing to keep in mind is that the design of io-wq is such that it's
quite possible to have N work items pending and just a single thread
serving all of them. If the io-wq thread doesn't go to sleep, it will
keep processing work units. This is done for efficiency reasons, and to
avoid a proliferation of io-wq threads when it's not going to be
beneficial. This means than when you queue a work item, it's not easy to
pick an appropriate io-wq thread upfront, and generally the io-wq thread
itself will pick its next work item at the perfect time - when it
doesn't have anything else to do, or finished the existing work.

This should be kept in mind for making io-wq scale better.

-- 
Jens Axboe

