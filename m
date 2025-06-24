Return-Path: <io-uring+bounces-8456-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32646AE58FC
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 03:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE44B1BC1CA7
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 01:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A8028F6E;
	Tue, 24 Jun 2025 01:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgfbXqq5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49AEEC5;
	Tue, 24 Jun 2025 01:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750727410; cv=none; b=q+GQqbepKTCRHS1p4s9g6lbVDVmoZpEBv9+m6Uabeu4RKCd5I4xRUiCgM0vVSRgEajfTLDvejZN4iKHct3zDInqk5NRM0QOOoKmTEdT/wZZ/EuF45DeKMxfaJYUFNngsmebEqgsgZ0tD5sLKyl0vJ1CfcOFehlEJ8hOm6M+AYEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750727410; c=relaxed/simple;
	bh=6l9Tuhg//hmpKMtIirISJ2XfkRAwMn0hn1IGx3EhRVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P+xfup856JGu2J0syoU9wFTQhzATi1SawFPwItEA6xfwddQ6uYj5RyU5LadIXwlfgfINVUXHKhMn6KQ2FMjzDf8Rf4aImwYhqytQeJ7pDQsqAUUbjtKuqrb8VDtkq/ixv78fW/AmkilaNs+7RgSB7mqJsH5ONCC948phFubuJfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kgfbXqq5; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2db2f23f174so3200910fac.2;
        Mon, 23 Jun 2025 18:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750727407; x=1751332207; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j5LQOSoQ0au9wfM+vKTbJerTRKhg8eJn/3ngarUjca8=;
        b=kgfbXqq57p+lv6usWMT+druCd36xyly3cGwPdPTdafMUyE0i2KkPJMI7Sjmir4qAMl
         8Aqpewhub0c5hqNHLDSO7vT19Dt0x7Zg+Ib5buaHq3m5H66+LsZQLSrlFT4KJ4o1/K//
         6uo7Nu7Rnu9tW97XEf66Y6G6j7CmHPloeFz7YOq7fbhqtKKqnr9BNRI/5jpKMz33+tJl
         6WWe6Jqkj5305Idw5AzQbMAhEuaymVxjV/+VNAAq3QwbA1mHa2GZuxMwQvMyWNaEBffa
         wHc3p5pFx7QOAGCrPFB5kcqF7xqG3ZXxqE331uSj8gA8lMf9Ixnkm7kxjuFAEK3+DmeN
         Gq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750727407; x=1751332207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j5LQOSoQ0au9wfM+vKTbJerTRKhg8eJn/3ngarUjca8=;
        b=VEoEpX9HL/w00OfqAgGNWi7cyj9rMpt7Vcd6jR20gT4LANi2P1xQsBqB0CHrFyYHkX
         l48MEOVcwsJgfqn0u11FFs31OBkBwGJLEmwSPWLLihTBmXL1MhX+fDqC/KowoChfFVEp
         xERBo3e3Hhfsfw1KzU1e0jka9sXL2+0bipqIKo+Gfgne7nNDLtRQzuxSsmn+ADDSkne4
         i0oEjA9yWsM4wvAvdl5+AC/1cJd6qETsXgEF8cSKrac92i9NlFDgyeWqvh3Emb0IbTns
         72AJFMixFLjkDz4i7s9YFERwmT9M7bXiPxqpkj6kZ8VGkhXVKrFtDYVdJ/LYqh4fd4Qk
         rZTg==
X-Forwarded-Encrypted: i=1; AJvYcCVqpI1UKPja4Qxowv5NNbxz3zWDlEL7itnSPtKWK16JkQckuDf1t/vnjn6AFKHQyWmZGpHehcdQ+g==@vger.kernel.org, AJvYcCXkQAUByczCDHLhtiNXmpMVK2BPFxppc4+xcgWz7C1paDV2RgGKtv+7DayqK0efrgfpnnzaxdHsM/nbDiA5oQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3jlOP1pc9G2bx83VALE889FfLahFPkjySuP9PHmIbT/dQsoRy
	ZoWRz3KC7Y6zUrXKfIyOXCgKKPp8MxI2V0WOZg0bRfGF4Q68PrpbAvPyZUXc8XZUgs4oqflO1oI
	Lk/AsVU+dzbeIU/PpaHAY2yUsxhH3OViHoMBk
X-Gm-Gg: ASbGncsHZF5RVAwLJLM/YgWT5IJGTtRwa8kInXJTAJdFXQ4Ym5m9PBiZs7InZqqd71R
	AR+QKeoTK76jarcA9SmgWtYmNkKhtZhQXBD0lDLzcGHx6yDh1BGm4Ls1353u8qulkjfpq1QKltY
	ajb/0fOz3j/bGBb23qb+/q6KarAzjzd9/pDS1ZcZ792Yhv
X-Google-Smtp-Source: AGHT+IFdRrTerAxSRn3QA2E7F+n4djFVvH5Q51hxEaETO7wVd7dWxMc1+uQsBQ+bxHuEJkIW3r0n1ixyhVRC5qDoulA=
X-Received: by 2002:a05:6870:f699:b0:2d4:e8fd:7ffb with SMTP id
 586e51a60fabf-2eeda4d3058mr9966711fac.1.1750727407492; Mon, 23 Jun 2025
 18:10:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aFLbq5zYU6_qu_Yk@kbusch-mbp> <CGME20250620014432epcas5p30841af52f56e49e557caef01f9e29e52@epcas5p3.samsung.com>
 <20250620013948.901965-1-xiaobing.li@samsung.com> <7f7f843e-f1ad-4c1c-ad4b-00063b1b6624@bsbernd.com>
In-Reply-To: <7f7f843e-f1ad-4c1c-ad4b-00063b1b6624@bsbernd.com>
From: Ming Lei <tom.leiming@gmail.com>
Date: Tue, 24 Jun 2025 09:09:55 +0800
X-Gm-Features: Ac12FXyoEzOK7zZsPBmBjpvT8VQeYdhbwbwH-61LRB6jv0Lcxa0Fo-25tXXsgzg
Message-ID: <CACVXFVPjDG8bdEY7tt9AEZAgQPK9fTnXmY06Yg8+vOePqOJJ3A@mail.gmail.com>
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring.
To: Bernd Schubert <bernd@bsbernd.com>
Cc: "xiaobing.li" <xiaobing.li@samsung.com>, bschubert@ddn.com, kbusch@kernel.org, 
	amir73il@gmail.com, asml.silence@gmail.com, axboe@kernel.dk, 
	io-uring@vger.kernel.org, joannelkoong@gmail.com, josef@toxicpanda.com, 
	linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, dw@davidwei.uk, 
	kun.dou@samsung.com, peiwei.li@samsung.com, xue01.he@samsung.com, 
	cliang01.li@samsung.com, joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025 at 5:36=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
>
>
> On 6/20/25 03:39, xiaobing.li wrote:
> > On Wed, Jun 18, 2025 at 09:30:51PM -0600, Keith Busch wrote:
> >> On Wed, Jun 18, 2025 at 03:13:41PM +0200, Bernd Schubert wrote:
> >>> On 6/18/25 12:54, xiaobing.li wrote:
> >>>>
> >>>> Hi Bernd,
> >>>>
> >>>> Do you have any plans to add zero copy solution? We are interested i=
n
> >>>> FUSE's zero copy solution and conducting research in code.
> >>>> If you have no plans in this regard for the time being, we intend to
> >>>>  submit our solution.
> >>>
> >>> Hi Xiobing,
> >>>
> >>> Keith (add to CC) did some work for that in ublk and also planned to
> >>> work on that for fuse (or a colleague). Maybe Keith could
> >>> give an update.
> >>
> >> I was initially asked to implement a similar solution that ublk uses f=
or
> >> zero-copy, but the requirements changed such that it won't work. The
> >> ublk server can't directly access the zero-copy buffers. It can only
> >> indirectly refer to it with an io_ring registered buffer index, which =
is
> >> fine my ublk use case, but the fuse server that I was trying to
> >> enable does in fact need to directly access that data.
> >>
> >> My colleauge had been working a solution, but it required shared memor=
y
> >> between the application and the fuse server, and therefore cooperation
> >> between them, which is rather limiting. It's still on his to-do list,
> >> but I don't think it's a high priority at the moment. If you have
> >> something in the works, please feel free to share it when you're ready=
,
> >> and I would be interested to review.
> >
> > Hi Bernd and Keith,
> >
> > In fact, our current idea is to implement a similar solution that ublk =
uses
> > for zero-copy. If this can really further improve the performance of FU=
SE,
> > then I think it is worth trying.
> > By the way, if it is convenient, could you tell me what was the origina=
l
> > motivation for adding io_uring, or why you want to improve the performa=
nce
> > of FUSE and what you want to apply it to?
>
> At DDN we have mainly a network file system using fuse - the faster it
> runs the better. But we need access to the data for erasure,
> compression, etc. Zero-copy would be great, but I think it is

BTW, the current ublk io_uring zero copy may be extended with ebpf uring_op
for supporting standard compression & checksum too, and Android has
similar requirements too:

https://lpc.events/event/18/contributions/1710/attachments/1440/3070/LPC202=
4_ublk_zero_copy.pdf



Thanks,
Ming Lei

