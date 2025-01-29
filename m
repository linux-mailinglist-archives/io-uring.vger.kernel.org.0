Return-Path: <io-uring+bounces-6183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61392A224A8
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 20:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71F841888F7A
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 19:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CDDF1E282D;
	Wed, 29 Jan 2025 19:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Cge3cqgw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4E71E260A
	for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 19:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738179840; cv=none; b=GqIQnsgUhiITs23p8isYHacnmNdFMv/BKu4n5/rjMbGr+74ew5TT3GoYwM7TCT5TsYW7GJtgiVG7/o9SFyD4STy14TFqwcEdmKyJO5yMTJgrGeAuSaILS1x6VTX+2EQX70DWjrP8EOpGvlilyMPoOKgXyXlr4is/EfKmIxZxJ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738179840; c=relaxed/simple;
	bh=EQ2Qp1aZ/RrzI6X07Dxnkdod2mmkQLuI5b1oIeCeZ/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oJ9rUl4ibdmRys/WZFu3yBuCWIOvdWX1rqtJRH6XzD9ekK69kDYlKA1IELib/sIMCCpnWMRCco87yxF6QrVA3btwGK0bzL+cQaH7LxhIKnm8Rr+pLs5ye4AjfNKK7aF0Dmln0B/13QKIdfA1RSCwYxnQHJ2xlvYgIq8W0E6rsKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Cge3cqgw; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa68b513abcso15033166b.0
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 11:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738179836; x=1738784636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQ2Qp1aZ/RrzI6X07Dxnkdod2mmkQLuI5b1oIeCeZ/w=;
        b=Cge3cqgwIcrjnR0AoXRDdpELyexzLQlX2GErYLVDgXsV2Zsh9/Egk26LF/yBz7f6MZ
         BTB1DxOzFAvmDiAURO18PAPSEWaBZHRp6ninl4c0iSunBrhtJWMoU3JmrSCqfiyAmOjS
         y4myfRMj6h+mr3pZU/Q4JkKFOSkZKdMouoVqP4yf211y1FIh8kReEc2GzgHsv4D3+4ZG
         H08k6RQaSSR64WA4KPTzscGWRWmUd+HGeR7VX+l2aPOrisa1ddMYtN8bINfU4N73Rx5v
         Q46iQXVdaWabReoSt9xpnX7s2tXjSLMjzC81DNHEV76RfjOEDZZWKoHsshJSotAn5mEb
         vdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738179836; x=1738784636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EQ2Qp1aZ/RrzI6X07Dxnkdod2mmkQLuI5b1oIeCeZ/w=;
        b=ssivqpfsW5yL72BDdxPvgnsuQOgA0hJ9Bcm+CLy4cS86XLoE+kM+5sIdBr9UdKm8gq
         mBkyTWCpKvh1fX9pmHkUqFpMZ5QXFExQvKzbtrc+gJPGvvM0pIymWLa8FbOO8IZdgezB
         PvYV3Fdm3JJkjhxff+koDc1APovUs+IPdFFusTIVwE4nstkgaA4oemt8TOBhxCAh7Uoe
         yigq4SuvoGq3uuiWscIruhw55Sc7jqr9NNsb/NxWArdVv4SLp2vbt9pvJle3apt6wNIn
         4ciyIS0qgfBfnspnpKrQJC42GgYekJMPaSdCt4GOdpB8TheFkuplqtIt13YbthrYS2iX
         Sr0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVgOM2tuCfVcsp+HqG8PwCKFfXPObHUbZS68Fc55jTlBQTZOlpMj3e2zlRjNNqbEf6uA/rGfpg5/w==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf/WeER8Js1xESXXUSy4EbTMeFUXZGB2exbEh8oTVDFxMKq6bx
	nXF4uTb1lZHyv5K8ITSqc3ZHDsPIFJMRAr1E8F3al9rnbW3HKAcGvh2PyTKHZ+uIOOO6AXlV/ks
	EbBESgFlQmBWSyOJ4/TymhMoUwu91C5ZtZHmBM0w56juKLwQySnA=
X-Gm-Gg: ASbGncsNEAd113Hgw8hP2syx9cdP5lwQB0bwDQfUYWO2Y6l27t9VY2axbhrs5CPSX7/
	uND3NAX50CVCXHFiGQOYcDWIBxwPbQa99zqaoIyBkdIgZyPz1S6eyIjNxfmL5EhWMKBzQ2+71Cu
	DaOQfOQM5IgBlY5/TWO3vVHfZY3A==
X-Google-Smtp-Source: AGHT+IHqBhk8eZvOcVzmk0+UGUaVJks34bZySLSyENAIDx9w4+2lD6ZlIeCtcNvVKLlBVkp46ACNA8dqohZnhJBRUCQ=
X-Received: by 2002:a17:907:1c16:b0:ab6:330c:7af0 with SMTP id
 a640c23a62f3a-ab6cfcdf591mr401678066b.20.1738179836435; Wed, 29 Jan 2025
 11:43:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <7f046e6e-bb9d-4e72-9683-2cdfeabf51bc@kernel.dk> <CAKPOu+90YT8KSbadN8jsag+3OnwPKWUDABv+RUFdBgj73yzgWQ@mail.gmail.com>
 <a5d8d039-f2d7-4adb-afd7-693b3be41e45@gmail.com>
In-Reply-To: <a5d8d039-f2d7-4adb-afd7-693b3be41e45@gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 29 Jan 2025 20:43:44 +0100
X-Gm-Features: AWEUYZn-sT_YB-jTzNWVaSZIzR7183waPz-Q5hMMVZrMiZ_D_Bj_0ZiosMZNAgk
Message-ID: <CAKPOu+-0kT5PXt1WbEGJSC8=47pZDz311DHB7D920ZHuoXPvwQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] Various io_uring micro-optimizations (reducing lock contention)
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2025 at 8:30=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
> It's great to see iowq getting some optimisations, but note that
> it wouldn't be fair comparing it to single threaded peers when
> you have a lot of iowq activity as it might be occupying multiple
> CPUs.

True. Fully loaded with the benchmark, I see 400%-600% CPU usage on my
process (30-40% of that being spinlock contention).
I wanted to explore how far I can get with a single (userspace)
thread, and leave the dirty thread-sync work to the kernel.

> It's wasteful unless you saturate it close to 100%, and then you
> usually have SQPOLL on a separate CPU than the user task submitting
> requests, and so it'd take some cache bouncing. It's not a silver
> bullet.

Of course, memory latency always bites us in the end. But this isn't
the endgame just yet, we still have a lot of potential for
optimizations.

