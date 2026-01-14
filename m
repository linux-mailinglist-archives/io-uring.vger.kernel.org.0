Return-Path: <io-uring+bounces-11719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A227D2140B
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 22:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F837304EF61
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 21:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03ACA34F24E;
	Wed, 14 Jan 2026 21:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXTPI7kW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699FB3587B4
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 21:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768424408; cv=pass; b=XBzPCAW4BjNv1DMwSffxOx7sA2qywkBlkX0g5SSinbulf7irUrAjEv6TUh8d/999BF+AKGlIGKLYGt/t6TIkl0Ai/TLq4CMXHxPlXWDW91oYDgdTme69oxlmqcqQTN+iynZVk5r96CieCC03rktKWXOfXcRU9utn+//R9cceONM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768424408; c=relaxed/simple;
	bh=roWdbXmH7FYe7K06oDGRBsbroLRllsBYVG2zPysP60k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JjSfks7fTjjvgEoKmClbyF9zzO/5RlB9M0dowg69VgJi+IrQcvc0lKdwJIxleiSbdl0nXRuT7Q1rt3v18L2ZUn8ABUv5VDEp/GVWOKVZEuxR+IVvbAncPiYCwfNy+dASoFQ2pkDwWvpadB5Z5yTsQ/hK/bl6mKAUEV9aHDR+9ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LXTPI7kW; arc=pass smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1233702afd3so283919c88.0
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 13:00:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768424406; cv=none;
        d=google.com; s=arc-20240605;
        b=k5njCr6S4HkQZzqJkDb7X3FGFRHJQSnrlFGvmA6rifjpaEgPWiORUgQIJiSSorhNpE
         UV98s2ETEDGQ9G4qPoY1kdrwjjfOA1IfPqaMATlJXaJoKClKUvadY0LaRYumlAC5iDpm
         TMuc3eBK3/hM/hTC3gAYKt/xpwkxxyDsYduvwsZWGzIl10cgBYRYboIipheQ4/4gRxgO
         pBCnXG5OwnFNeC29+YLFI0J45QdTPGbTs78zWUpN3RFjqcUJ9HHtz3+kZ3ZmBeclwhE6
         QvEqLxZYd8YrKXx4ZXTAv3gPEvVfPoZ0Du0S7atzLi17h9ExgyrOZMVwJG/XrGA+wyPb
         7Cpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MSWh5xUyjDvmLyvooG8auWxA1AMLYn3JJ96M9PT/SwU=;
        fh=8txRMK4Rwc84VZ0pX49aSiVUqYaycUVfKiwEegkW3hg=;
        b=SWV3Sy09HG+R5dj/pw2MaShn14Fecg3bAA5ct3LSgV4uQ8L8gwbU/CwDcGTvzVnzSF
         Djq8p6oVVD5zOaB4m4lcDRPZHyc7ZWj3rY08uCp/2MyLQfybMzCh7gkIn8U2i3q+asiS
         /YZpbBbVAYjDFuOpWNy7TjAJWMz4qpSBI3mJioU02kwjIOwuICvh1FfpZhtIBxgflkO9
         cdzEQy5ZXLjvJyUdKK8UjEsK9eCON2AiAUvZgrgJHxxes36m45M4VJITXdtXjhct0ReK
         tpPpJx9+liiJYr1yA8djkqxfooQ97qpJ9HDqeQcQuHUgvzoKtfFQcGLoJMVp44xqzBjz
         xUQQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768424406; x=1769029206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSWh5xUyjDvmLyvooG8auWxA1AMLYn3JJ96M9PT/SwU=;
        b=LXTPI7kWIABRtR7YJifst9MtUEJyuZiQK3VniYQZyqtH0dQg8VxYw9L5I8OR6tXGTR
         wYw5FHicXAGQqdB0zrwQi3WQDTClUOy3a0nX/5jbLyw6JNZVFgmoCRVAOXIWmglYi9/S
         2/d2qPsfX6xSYCPYLMuN5/AUklFr4qnK6JGh/ipM8oQIaE4twAt1gEeXLVCsxmxPEpO6
         M9BUvdnh7M1KOSP66tVOnJYr9EQesXRxupb0z44ev+QCRF6Zt817BgJD1T19POy2ohFg
         w4LOR5V3Wpvvcob6uTH8xof7xQSepcPrU8j3wrBpf9I6j/mS12SJmhiyxQhtZdyO5lu4
         Cv3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768424406; x=1769029206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MSWh5xUyjDvmLyvooG8auWxA1AMLYn3JJ96M9PT/SwU=;
        b=QNeF+GhmP7ncGerqtk5BcKbWmd07vGpWkkGWfsnSN2+oG1z75O2OJY5k1Hz7MV6sLL
         m4+6JQoc/tswa9Q7k2O6Bjm6Ths2cXQo314bW7wDqzHcV7NdlTZRD3aZ1BduY7TEdWJK
         NPw0VJvSQJmGwYZxchR0QEyO/LdyaTtiY8V+0DiwFW0sAPiooneCckd0+zem8ljiLyvv
         ct18T283IaGG2IRTe2bAxHa1wqCF+bLqEjcLR11bTdCUeoCFbNcX2MA9EHTa9cuQ6gLd
         S8GAehL8brzisPAgawQqb4g9jGyPbt0rmfnpWfGwyBWaFe8n8CiTZMzgo1cf+v/vzx5x
         GUdg==
X-Forwarded-Encrypted: i=1; AJvYcCUIemNRiDin1Fkv/Ncc4IdE66wXQp3GMAo7NXNaxWPeLqLTqvtPfWS0S9+ojqJ4RfqrSti82bNmmQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwksjbmrrnZivVgvOjWweqmc66T/2WQ/Qsw1uxUFGJjhhSStKW3
	oCc9ykpUTCZOGiiLJPuTuDqNv24YaUBxrAEYftl13GQ2B9xUPBQFecGeEf25SxbalowkdbK4nJg
	rvuKGlxIfQVd7l5W3Q/K2uK/c7gAXyT0=
X-Gm-Gg: AY/fxX7SM49UuorWCukv7MkWErHkOj5BWL5459Gd6MYq8UF3XoTwfxQXzU8nTGEh9/Q
	meslvqc6qGPuYeRwi44LjefbSQJWIBhjsXXCD5vl8EaaoEd9wA/Cre2hHerqQDdh5IHoBykutFQ
	2iVJ9fSq43lsDZwCHWrpQ7itc2ZmayFEpxlseP4BlXoNb+a3hJSIuI0Uk2M378Rd66LAy0pldkE
	Cq9K4r1hXNLZ4C7tkgdT48J81G5mGdtdbN47Scr6Byzqh8Jf1cqM89qbjE0BfHsoHn56QW91LKG
	3kE0XA3A/MLil/DXwy6YuypljN4=
X-Received: by 2002:a05:7022:e885:b0:119:e55a:9c04 with SMTP id
 a92af1059eb24-12336a8a71dmr3806797c88.32.1768424406283; Wed, 14 Jan 2026
 13:00:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218025947.36115-1-danisjiang@gmail.com> <CAHYQsXQzAWhpwzqSTGxvWgNXq_=g4V_nsmRGnYeKPumGgAmyXw@mail.gmail.com>
 <afe7d084-a254-46a3-889b-a136dc8f4fbd@gmail.com> <0adb508f-480d-4bfc-b861-3cf42e87bee1@gmail.com>
In-Reply-To: <0adb508f-480d-4bfc-b861-3cf42e87bee1@gmail.com>
From: Yuhao Jiang <danisjiang@gmail.com>
Date: Wed, 14 Jan 2026 14:59:54 -0600
X-Gm-Features: AZwV_QjqmVPvsgBUGTMluvi_ytZFdM2YDTFk_tl-xlx66lE24cqxrxT5S_F6E2s
Message-ID: <CAHYQsXR996msVqgqMRznharf1v1Yrwpo7029Oen3cTHZgYEn3A@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass via compound
 page accounting
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2026 at 8:10=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 1/13/26 19:44, Pavel Begunkov wrote:
> > On 1/9/26 03:02, Yuhao Jiang wrote:
> >> Hi Jens, Pavel, and all,
> >>
> >> Just a gentle follow-up on this patch below.
> >> Please let me know if there are any concerns or if changes are needed.
> >
> > I'm pretty this will break with buffer sharing / cloning. I'd
> > be tempted to remove all this cross buffer accounting logic
> > and overestimate it, the current accounting is not sane.
> > Otherwise, it'll likely need some proxy object shared b/w
> > buffers or some other overly overcomplicated solution
>
> Another way would be to double account cloned buffers and then
> have your patch, which combines overaccounting with the ugliness
> of full buffer table walks.
>
> >> On Wed, Dec 17, 2025 at 9:00=E2=80=AFPM Yuhao Jiang <danisjiang@gmail.=
com> wrote:
> >>>
> >>> When multiple registered buffers share the same compound page, only t=
he
> >>> first buffer accounts for the memory via io_buffer_account_pin(). The
> >>> subsequent buffers skip accounting since headpage_already_acct() retu=
rns
> >>> true.
> >>>
> >>> When the first buffer is unregistered, the accounting is decremented,
> >>> but the compound page remains pinned by the remaining buffers. This
> >>> creates a state where pinned memory is not properly accounted against
> >>> RLIMIT_MEMLOCK.
> >>>
> >>> On systems with HugeTLB pages pre-allocated, an unprivileged user can
> >>> exploit this to pin memory beyond RLIMIT_MEMLOCK by cycling buffer
> >>> registrations. The bypass amount is proportional to the number of
> >>> available huge pages, potentially allowing gigabytes of memory to be
> >>> pinned while the kernel accounting shows near-zero.
> >>>
> >>> Fix this by recalculating the actual pages to unaccount when unmappin=
g
> >>> a buffer. For regular pages, always unaccount. For compound pages, on=
ly
> >>> unaccount if no other registered buffer references the same compound
> >>> page. This ensures the accounting persists until the last buffer
> >>> referencing the compound page is released.
> >>>
> >>> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> >>> Fixes: 57bebf807e2a ("io_uring/rsrc: optimise registered huge pages")
> >
> > That's not the right commit, the accounting is ancient, should
> > get blamed somewhere around first commits that added registered
> > buffers.
>
> Turns it came just a bit later:
>
> commit de2939388be564836b06f0f06b3787bdedaed822
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu Sep 17 16:19:16 2020 -0600
>
>      io_uring: improve registered buffer accounting for huge pages
>
> --
> Pavel Begunkov
>

Thanks for the review. I see the issues with buffer sharing/cloning and
the accounting concerns you pointed out. I'll rework this accordingly
and send a v2, and also fix the Fixes tag.

Best regards,
Yuhao Jiang

