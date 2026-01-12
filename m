Return-Path: <io-uring+bounces-11596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5E5BD13F1F
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 17:20:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D2FB4300A6DC
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 16:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4A623ED6A;
	Mon, 12 Jan 2026 16:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cmuEIUru"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370663644D4
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 16:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768234847; cv=none; b=bst199KsD9KZJbTR0z9AIUQuzfe0EsIBAkHz2nMbdRzQh8MTunkYfUgbnKV2C5MD6lXzE33VRUYRE+mWtydu0vuvCV8/IQ8xp5HWxkhjeWl3ayfMsVkiCB3NdA4mXIEOn3tNFFCxD7AzlDDmOt4UXOMGmp+6nUBeiD0txNxwyqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768234847; c=relaxed/simple;
	bh=N7A9fzwKmchtEdIQM+UHFzjF/GSM5XqhOEUjlPPpO6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OKvqXx1FK5gdCKjD8yRkr2YpUMuyyrXCEAvd0QSqFujgWqCeyzJyGIZv2dfcTQ31pigzr63ceJfYS16NyFa6wkQQFOBl8Xg40pQMvusLk+HPKLl2TAArJf+G7S5o5zvoEGpUvrBb6mGOga8pf7C6de/UcB6QZHIX1TfGK4gH4kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cmuEIUru; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-11df44181c3so333168c88.3
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 08:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1768234845; x=1768839645; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RbjavQYGxVH0nESvIyPTBU08cNQ1UOrKGNnSjkyMra4=;
        b=cmuEIUruU3duDNvK0iaC9G526hhkRk5s6OvB3xUAoV5r1Z98EbIfoaW/JGUuFzsNX5
         tcefq2UxyaXTT1dB+3Br1INt9SjHRA9sNOFU3dctHM2evjKbC1n9rsY1wvfUHqj22wT4
         kJ8RVvZJJNy1VMrF+PR0gwDGM3Fc7Ab/J0Wh396xqbiyP0QOPepl32CGcFFxXTob99L8
         GySOXVd+u8K98lvZlPDCf5ZKwr5MXF7fF9FSN0rIkq2bGn6cpb+IdRbM9+jDugV7fFFM
         ElL+iLYKzAHhDPVCeC2s++pdIFHJtbq0tmhCfA4GlZxE1nkLPcu41tA1CK+2DNxdAPSB
         R7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768234845; x=1768839645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RbjavQYGxVH0nESvIyPTBU08cNQ1UOrKGNnSjkyMra4=;
        b=V+bQ8tLcu6XI5poC77g2ycCDMtWAxZHICs/ddcXOaC7+kd4SaDiMkH0BHcV2hOu2U1
         psOQUeUavhiakQB+3ut+9SjFVeJL2fcLBY/TlTCyY6zUkHzk95rdlx+ojteSYmt58QxK
         3I20Igt1qHhPusqmbEcuLBzGhQSrc6e1+MmKfcdc4uYKTfQv0xQDJIfh5cGPtu9EA+02
         dbOxwy8ZIDaFVeWbQwhtpRBfQ1zKwsEddTVa2gogrnvxPqPMhSIJH3T48bK9PKw1aLhv
         yJ7kgKDBbRhoveoNOMBOu38kNqBrbVhv73fAeYZWPp3Y+Z2O057tXeh570Mpi0Oh2CkC
         g2hQ==
X-Forwarded-Encrypted: i=1; AJvYcCUevBFrUWhWTN6HrU9BSs6KZVGb3ySAyid5wQPZH9uwSrO8SbGwcD1KDAPc+Ws3n8c5MP3/6J+9xw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzrvR8R5vcDMuwIjUqNC2TwuJbx7gu/a63uSVix1LMkGmJ7jFbj
	pZZwRZJ9S+MSZgBTYam0N1mLdjNt5rDBpjMb/VNydWA8dP5ZM4Z2Ei3yQEsey09EWvEX9sfGfL8
	nbVb/fMsSPDb7zEFaslScL5zhvdH7/Gcp7EXp63qWAQ==
X-Gm-Gg: AY/fxX7gM5vo9DJaaFTdAAWLRHCqP271fza2dAF4vrZ8PcwKAz9YfqjEyAXxnjRk71w
	gE3yRNml/LUaFPcZqdwOLXjN/jYiZFLP8VBP4OIxuhBDp+mIzATEQZwF5ThdOu6uVdj1Y5oGL6o
	tBFfN6+KXtVk05wQIOiRSQg3ycdOssc16o50k1A31X2UsjwdtzKABzEI3flAtGT/EVrpel1M2So
	fbV2YofZLS4tL/5Skyeif2iHCC1xojwA/Zz28X+ra/P7hAAYFL7gKlXIe/CaIaTX455snuW7av4
	2WxJzKErwTxwoIekJlgIYNKavOs0Ng==
X-Google-Smtp-Source: AGHT+IEJ9O0RHrE5BMUtit3nPAkMo1VAmQBQTqifHW0v6jpKSA02/a3m/5PUJFyJSfqyceSyZpmFVrEFIvVC6PcYDuE=
X-Received: by 2002:a05:7022:ea2c:b0:11b:65e:f33 with SMTP id
 a92af1059eb24-121f8b00246mr8469576c88.1.1768234844318; Mon, 12 Jan 2026
 08:20:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105230932.3805619-1-krisman@suse.de> <wuha2oln3kdumecdsmpttykdq2p5bwp6db3cfoyqoy5ftnedmg@ftlotbrnrev7>
 <87ldi25254.fsf@mailhost.krisman.be> <peuwrn3dswaomm4aqglv2injqbvkmmzw7ost6js5pxvb3ahlu6@23z6cqmrvj5e>
In-Reply-To: <peuwrn3dswaomm4aqglv2injqbvkmmzw7ost6js5pxvb3ahlu6@23z6cqmrvj5e>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 12 Jan 2026 08:20:33 -0800
X-Gm-Features: AZwV_QiFG9rfc3nAkACndV5HpkgfAbqqtyP5QbpHw6AHW_Om2zUXyoHH-iUQD5k
Message-ID: <CADUfDZqe+2FB0mM7D5WH1nonrCnhS54C9iq3ofTw-45F6_njNg@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Trim out unused includes
To: Breno Leitao <leitao@debian.org>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

There is a tool "Include What You Use"
(https://github.com/include-what-you-use/include-what-you-use) that
can be used to automate removing unused includes, among other things.
I've used it in other codebases, though never tried it on Linux.

Best,
Caleb

On Mon, Jan 12, 2026 at 7:46=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> On Mon, Jan 12, 2026 at 09:36:23AM -0500, Gabriel Krisman Bertazi wrote:
> > Breno Leitao <leitao@debian.org> writes:
> >
> > > Do you have a tool to detect those unused header? I am curious how is
> > > the process to discover unused headers in .c files.
> >
> > No.  I noticed one that was obviously wrong and that caused me to
> > manually walk over the rest that looked suspicious.  I probably missed
> > some in the process.
>
> That is fair, I do the same for my code as well.
>
> Thanks
> --breno
>

