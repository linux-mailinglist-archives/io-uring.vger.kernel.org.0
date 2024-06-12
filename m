Return-Path: <io-uring+bounces-2171-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E9BB904BFB
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 08:53:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC2E41F21D1E
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 06:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2A516B750;
	Wed, 12 Jun 2024 06:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gQiRMZdn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623FA169376;
	Wed, 12 Jun 2024 06:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718175219; cv=none; b=nAMfYRi13zrkLNK8fxhkrG6iC8zF8Q0qV4qs9CAY/v2U7XjuPBr+Obbfm23o/7/cRf+54qprjht0Hu4bERngfGK8XfcJVkVGNIvv77lix6m08Vw/kf3LAkjuhsyqZ5/Gft130SrDnSnjLdE2FkdAgjNY/T9F5ks87na5a6yUtDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718175219; c=relaxed/simple;
	bh=H/jSw5/jmZkfHl+w3KDhnRo8P+BSpCu1X1hYk8AvnP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Nvqza1RNHI1J3xynbl3lEY+CJzsXJ9G0O2mbpOrlk/6oYHVFA6mxt7S94RxOd+aH9/AS0jq6u6wvuQA9eBoQmwqLrvWrNH8dhQyaCzH65jDGgcoWZ3Uk0XPqstzyaRdFXW9J8ZLp4fEaUDrpdIlUx2bgXXeMSOEAVOUnQM5f7BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gQiRMZdn; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-62fdcd9b297so2770267b3.1;
        Tue, 11 Jun 2024 23:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718175217; x=1718780017; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/jSw5/jmZkfHl+w3KDhnRo8P+BSpCu1X1hYk8AvnP0=;
        b=gQiRMZdnfxy3fyvqAabtV9zGOVdtoNmaGVDoRSZI0tmEO715j5mtmJrG78aZklj1fH
         8fKXjllDNEc0LsXrv60BVZUG9JUsf9QWRGfaXStot00WPHKOxGlBUblKEO09xx6QKNah
         4gcZTgcjUEx5b7boyt6K/2QxDozhrruvQiBD9Tls0t5mNrwagTa97ADaNlfoQh6g29q9
         +99ZsSh9ZQUA/5JNUMmO4iSp98geVMvqqtJ5m2TgslETtTQCywwmF86Uxnk0UJ51pSEE
         D+XlmkN/g75eePgNKrG7PtaI337NUqGNCNofPtYc1zYV6iaYhbBjJPwX7blbfqvr9sEW
         mGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718175217; x=1718780017;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H/jSw5/jmZkfHl+w3KDhnRo8P+BSpCu1X1hYk8AvnP0=;
        b=U+H95a1XRW4lIEUn7sxJPdfyp2d9GPb4ewWKpr+KLFZf8u59PCpryqcqBiUdKXYhzG
         CFh0ksOCoBEngKzaNbWDhmx/Q3hsM3/Vn+zTWnW0BoFtG/YjPNFVsmeU/tyfjCjnMKB0
         qW+GtDC/MKA1fie62grEJuMtwQlpzGr4kK8sjvXxcVMuAdYe9MsOgKLkyFZv3MsGI4vs
         wv22OCSOy8UZLSK5UbH9VUt7wbwAM9uuZE6nBRLJiMR7khOCiE9xuXYmoTaFARQ1JvC9
         lk7eGkvbRUO26KoCLxQETe58LyM0+7i4E+DtyK3c7n0XNjPRa+pRPkMCkxvP8LWmF1oe
         5/yw==
X-Forwarded-Encrypted: i=1; AJvYcCX6Knqu91mfUidpVuzWGUe0k32J5m/JifYaKop++m8ZKC/XP4bMBGBlzQe8jIeAsbvurPi0i+liRq6K2ST94WTCBIg1iD3vZE30YZYLvSoVGZAbGlJtrcUr5ARX3jepyIgGXtn31cQ=
X-Gm-Message-State: AOJu0Yxb37rDkVoLAJJ9aLRbLwlgSKX7iYa7min4cZ3Mvc03YhJ5tQif
	rAmm5WH1E8KHXx2cfHTIfi5jCdQflRF1FJCJh1TbHr1/+0Td3ZNcwrTMJ2UNLfOI6t+XBBzfOEX
	EF4ylqAkhu1JT3UWBPDSTwbeNJCg=
X-Google-Smtp-Source: AGHT+IGC0V4CBwuulb2ugTB/zFI3apFX6grghdbTtYL8iciQ2tAP6PIkEV3Fukv3yjmSTuQ8I/fp3lKKJiU4caXSbXE=
X-Received: by 2002:a81:a54c:0:b0:62f:2c3e:73a2 with SMTP id
 00721157ae682-62fb828846bmr9639617b3.1.1718175217399; Tue, 11 Jun 2024
 23:53:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADZouDSJRVEHUK1dMQF-guuDh_EcMJE55uLYRR23M0a0gvkd=w@mail.gmail.com>
 <e0c76f8a-68c1-472c-a2f9-2e1557be26ff@gmail.com> <CADZouDRNKYB6ryGF+0HP5aJECUxApq4az6WNAYvjPs703mnDWA@mail.gmail.com>
In-Reply-To: <CADZouDRNKYB6ryGF+0HP5aJECUxApq4az6WNAYvjPs703mnDWA@mail.gmail.com>
From: chase xd <sl1589472800@gmail.com>
Date: Wed, 12 Jun 2024 08:53:27 +0200
Message-ID: <CADZouDRrFiP+Zs-=hkFVNQhZNKCMpneaRHuXLVS_zDXkkr8CoA@mail.gmail.com>
Subject: Re: [io-uring] WARNING in io_rsrc_ref_quiesce
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the reply, =E2=80=9Cxdchase=E2=80=9D is ok for the credit.

chase xd <sl1589472800@gmail.com> =E4=BA=8E2024=E5=B9=B46=E6=9C=8812=E6=97=
=A5=E5=91=A8=E4=B8=89 08:38=E5=86=99=E9=81=93=EF=BC=9A
>
> Thanks for the reply, =E2=80=9Cxdchase=E2=80=9D is ok.
>
> On Wed, Jun 12, 2024 at 03:13 Pavel Begunkov <asml.silence@gmail.com> wro=
te:
>>
>> On 6/7/24 18:11, chase xd wrote:
>> > Dear Linux kernel maintainers,
>> >
>> > Syzkaller reports this previously unknown bug on Linux
>> > 6.8.0-rc3-00043-ga69d20885494-dirty #4. Seems like the bug was
>> > silently or unintendedly fixed in the latest version.
>>
>> Thanks for reports, this one looks legit. I'll fix
>> it up. Do you have a name I can put as "reported-by"?
>>
>>
>> --
>> Pavel Begunkov

