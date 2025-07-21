Return-Path: <io-uring+bounces-8764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A62B0C8B9
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 18:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3262161DC4
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 16:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930382DECD8;
	Mon, 21 Jul 2025 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfcQtrvX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A39B2DEA87;
	Mon, 21 Jul 2025 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753115293; cv=none; b=cDQFBc+epIgEGX4h/fqTR5yuk0aDIrhsq7GwfV6TUGqL2nQ+OFwxnn95aHACgHb9C6+VaiHKje8zVTlI44h45oMJuDdlbSBUO8K6mxfIvwn5ZYxc51ANWGTv61HAw9e+5OBbHbywHSwEs2B8OCfIqRlmvKFoI661diR7awpFr2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753115293; c=relaxed/simple;
	bh=z883QMRJOcZ6JZ6lKxQ4Q13+pStWAe3SzQLx7G/nzPk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=teA+Y76XUESPaZTKGmw/21PvA7YLMfA47Uvrc0881rEymWNiXBADCpKtH2dHQScQtDdfpq0m0BuiWGsbRsmSigOxRm1sb4qDHTLF1/JZSD0/k2mTV1353Yxp2IGmENryfHMdar/UQsvMdFEIncUp/ibybBNlYvNEuKNMadm+uZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfcQtrvX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79434C4CEED;
	Mon, 21 Jul 2025 16:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753115293;
	bh=z883QMRJOcZ6JZ6lKxQ4Q13+pStWAe3SzQLx7G/nzPk=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=UfcQtrvXdjw9XP1xbiK1iSIv9O+jRFJwV8rBGb4ETwTiSZz5yhF+wFBkeApWHefnz
	 CzfNx8b8z6jb4WsFQ3CweS+elcKjr0zYxBn2V7qsUYKdzjfzTfElYPAItf4KaeRF2t
	 AoQylUtN4+V+Pra+7W4moZvj5rSJQNd2Pml9fr1SvT8RtvXb8+s/DUMXliwpuute0V
	 O7dIGZ7IhLEH8evkEna3I2duogr54iB6BPD2b3IeW6UHUjpxBomJ1QxHMEFpGz3iKO
	 Ym7ZgogUaOh8wvDZvec3+9kr8hM4EkksK2inWp2Ri+8dZyQyvu0bMXTCfl8++Pv+ZQ
	 fp+qHXahTAWzg==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Jul 2025 18:28:09 +0200
Message-Id: <DBHVI5WDLCY3.33K0F1UAJSHPK@kernel.org>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
 "Jens Axboe" <axboe@kernel.dk>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [PATCH 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Sidong Yang" <sidong.yang@furiosa.ai>, "Caleb Sander Mateos"
 <csander@purestorage.com>
X-Mailer: aerc 0.20.1
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <20250719143358.22363-3-sidong.yang@furiosa.ai>
 <CADUfDZoBrnDpnTOxiDq6pBkctJ3NDJq7Wcqm2pUu_ooqMy8yyw@mail.gmail.com>
 <aH3OsKD6l18pLG92@sidongui-MacBookPro.local>
 <CADUfDZrLKrf6evTXQ03cJ1W4kj0gxsF9Bopu+i2SjkBObXKnMA@mail.gmail.com>
 <aH5g-Q_hu6neI5em@sidongui-MacBookPro.local>
In-Reply-To: <aH5g-Q_hu6neI5em@sidongui-MacBookPro.local>

On Mon Jul 21, 2025 at 5:47 PM CEST, Sidong Yang wrote:
> On Mon, Jul 21, 2025 at 11:04:31AM -0400, Caleb Sander Mateos wrote:
>> On Mon, Jul 21, 2025 at 1:23=E2=80=AFAM Sidong Yang <sidong.yang@furiosa=
.ai> wrote:
>> > On Sun, Jul 20, 2025 at 03:10:28PM -0400, Caleb Sander Mateos wrote:
>> > > On Sat, Jul 19, 2025 at 10:34=E2=80=AFAM Sidong Yang <sidong.yang@fu=
riosa.ai> wrote:
>> > > > +    }
>> > > > +
>> > > > +    // Called by consumers of io_uring_cmd, if they originally re=
turned -EIOCBQUEUED upon receiving the command
>> > > > +    #[inline]
>> > > > +    pub fn done(self, ret: isize, res2: u64, issue_flags: u32) {
>> > >
>> > > I don't think it's safe to move io_uring_cmd. io_uring_cmd_done(), f=
or
>> > > example, calls cmd_to_io_kiocb() to turn struct io_uring_cmd *ioucmd
>> > > into struct io_kiocb *req via a pointer cast. And struct io_kiocb's
>> > > definitely need to be pinned in memory. For example,
>> > > io_req_normal_work_add() inserts the struct io_kiocb into a linked
>> > > list. Probably some sort of pinning is necessary for IoUringCmd.
>> >
>> > Understood, Normally the users wouldn't create IoUringCmd than use bor=
rowed cmd
>> > in uring_cmd() callback. How about change to &mut self and also uring_=
cmd provides
>> > &mut IoUringCmd for arg.
>>=20
>> I'm still a little worried about exposing &mut IoUringCmd without
>> pinning. It would allow swapping the fields of two IoUringCmd's (and
>> therefore struct io_uring_cmd's), for example. If a struct
>> io_uring_cmd belongs to a struct io_kiocb linked into task_list,
>> swapping it with another struct io_uring_cmd would result in
>> io_uring_cmd_work() being invoked on the wrong struct io_uring_cmd.
>> Maybe it would be okay if IoUringCmd had an invariant that the struct
>> io_uring_cmd is not on the task work list. But I would feel safer with
>> using Pin<&mut IoUringCmd>. I don't have much experience with Rust in
>> the kernel, though, so I would welcome other opinions.
>
> I've thought about this deeply. You're right. exposing &mut without
> pinning make it unsafe.

> User also can make *mut and memmove to anywhere without unsafe block.

How so? Using `*mut T` always needs unsafe.

> It's safest to get NonNull from from_raw and it returns
> Pin<&mut IoUringCmd>.

I don't think you need `NonNull<T>`.

> from_raw() name is weird. it should be from_nonnnull()? Also, done()
> would get Pin<&mut Self>.

That sounds reasonable.

Are you certain that it's an exclusive reference?

---
Cheers,
Benno

