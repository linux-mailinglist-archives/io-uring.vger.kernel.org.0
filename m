Return-Path: <io-uring+bounces-8763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EE64B0C841
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 17:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC83F6C4601
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 15:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC152E11B6;
	Mon, 21 Jul 2025 15:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SdQ0mdTr"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4118E2E11B0;
	Mon, 21 Jul 2025 15:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753113165; cv=none; b=YTnd3TVGPV0vRwW3oBCK2u8dl7SVj6LDwl5bVerwA1YyEgIk++C6ztxsEPSVJ1F6YD0Ca3OfPfEPtBNPeD4AFMtOzytQZ3xX7/01l6KbRShreDB9WyKx8Tn8sEA5hSg4v8v70okS6C/I7kR5GZbZwHI5pU8TuR5LKUUr6h3ZnxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753113165; c=relaxed/simple;
	bh=ebxpT4tJxM7GxWWAlBVAy5e6LcGZEiVSnIHeto4m+xA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=onHG6Bk/u8nLXyR0Mau8dCc86t7ttTVI1YZRxBkJHxP0X+d2Vz1YcWJVbUqnJkcmWyRq+wPRDTXqyT7vhhnCKnsjtTByGlwvhqvf1mrU7353V0pZkNPyKPTbRryUtrLQ9Ovo64xfK8EfMD2n1lJ9wdoZbKEWiBBwTPuaMggnlOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SdQ0mdTr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30339C4CEED;
	Mon, 21 Jul 2025 15:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753113164;
	bh=ebxpT4tJxM7GxWWAlBVAy5e6LcGZEiVSnIHeto4m+xA=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=SdQ0mdTrTEQiDDz8sELioP+rf20muWk7pxDygCR8Vx0kV+dMoeLJizVw+0vTkWHwE
	 amfqB3cbHRC5LHUf7HLek3hRvHSDDo1g7vtYHeMYSczFTDiT+wVmvklVSfwmZMJxx8
	 MFeHGAyng5rm8h1MLjQDF538+4FCB4OrzKqoJYiZoP6XOEx08xvAbQzSdPJaMFuLhC
	 oip9Z32nmARlIY8uT9Q0UCZuh9/EoBzPYmKGW3xFgck/Nq/UEOqVbL1M6ajt8BgEYf
	 6nzQkL+qZ9fq54ajorL+daQUHbn4DdJ0KRZHWNt5FDDUJJ2yCkrh66JCNk7tIKYLpA
	 WUddMo27NNgkA==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Jul 2025 17:52:41 +0200
Message-Id: <DBHUR00PDVO2.16BCDQ94SF29J@kernel.org>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
 "Jens Axboe" <axboe@kernel.dk>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [PATCH 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Caleb Sander Mateos" <csander@purestorage.com>, "Sidong Yang"
 <sidong.yang@furiosa.ai>
X-Mailer: aerc 0.20.1
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <20250719143358.22363-3-sidong.yang@furiosa.ai>
 <CADUfDZoBrnDpnTOxiDq6pBkctJ3NDJq7Wcqm2pUu_ooqMy8yyw@mail.gmail.com>
 <aH3OsKD6l18pLG92@sidongui-MacBookPro.local>
 <CADUfDZrLKrf6evTXQ03cJ1W4kj0gxsF9Bopu+i2SjkBObXKnMA@mail.gmail.com>
In-Reply-To: <CADUfDZrLKrf6evTXQ03cJ1W4kj0gxsF9Bopu+i2SjkBObXKnMA@mail.gmail.com>

On Mon Jul 21, 2025 at 5:04 PM CEST, Caleb Sander Mateos wrote:
> On Mon, Jul 21, 2025 at 1:23=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.=
ai> wrote:
>> On Sun, Jul 20, 2025 at 03:10:28PM -0400, Caleb Sander Mateos wrote:
>> > On Sat, Jul 19, 2025 at 10:34=E2=80=AFAM Sidong Yang <sidong.yang@furi=
osa.ai> wrote:
>> > > +    }
>> > > +
>> > > +    // Called by consumers of io_uring_cmd, if they originally retu=
rned -EIOCBQUEUED upon receiving the command
>> > > +    #[inline]
>> > > +    pub fn done(self, ret: isize, res2: u64, issue_flags: u32) {
>> >
>> > I don't think it's safe to move io_uring_cmd. io_uring_cmd_done(), for
>> > example, calls cmd_to_io_kiocb() to turn struct io_uring_cmd *ioucmd
>> > into struct io_kiocb *req via a pointer cast. And struct io_kiocb's
>> > definitely need to be pinned in memory. For example,
>> > io_req_normal_work_add() inserts the struct io_kiocb into a linked
>> > list. Probably some sort of pinning is necessary for IoUringCmd.
>>
>> Understood, Normally the users wouldn't create IoUringCmd than use borro=
wed cmd
>> in uring_cmd() callback. How about change to &mut self and also uring_cm=
d provides
>> &mut IoUringCmd for arg.
>
> I'm still a little worried about exposing &mut IoUringCmd without
> pinning. It would allow swapping the fields of two IoUringCmd's (and
> therefore struct io_uring_cmd's), for example. If a struct
> io_uring_cmd belongs to a struct io_kiocb linked into task_list,
> swapping it with another struct io_uring_cmd would result in
> io_uring_cmd_work() being invoked on the wrong struct io_uring_cmd.
> Maybe it would be okay if IoUringCmd had an invariant that the struct
> io_uring_cmd is not on the task work list. But I would feel safer with
> using Pin<&mut IoUringCmd>. I don't have much experience with Rust in
> the kernel, though, so I would welcome other opinions.

Pinning in the kernel isn't much different from userspace. From your
description of what normally happens with `struct io_uring_cmd`, it
definitely must be pinned.

From a quick glance at the patch series, I don't see a way to create a
`IoUringCmd` by-value, which also means that the `done` function won't
be callable (also the `fn pdu(&mut self)` function won't be callable,
since you only ever create a `&IoUringCmd`). I'm not sure if I'm missing
something, do you plan on further patches in the future?

How (aside from `from_raw`) are `IoUringCmd` values going to be created
or exposed to the user?

---
Cheers,
Benno

