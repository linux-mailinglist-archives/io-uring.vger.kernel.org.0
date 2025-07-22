Return-Path: <io-uring+bounces-8782-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C4DB0E3B3
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 20:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB22B17516B
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 18:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C16280329;
	Tue, 22 Jul 2025 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnK2HYU7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CEA21516E;
	Tue, 22 Jul 2025 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753210329; cv=none; b=W23RLUK1e83qBo4Gx4+5Y61PF9iYF3sYz5gdzsNdplnr+5VDFuXKnsHnLbOiA9vA/OVn4Yy5DW5up1iA8I//H6lQuMui4R0USerfy0pvNv3Blq6BPfdFD1pmEKP8h5QJw1j8FWT/2QL19xfgT0emO+MZFoHGcVErlHdiWaUM8nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753210329; c=relaxed/simple;
	bh=ncQDcwLtFXrjxRWbHOnOf177mQ7JXQHPpytEH3Fg8+w=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=PHLS1asyK6fO67z3BipEgptEMpJBlrMt76NlDm6EkVmYos9+FggxVSeRgE9uWGPTJZoYyARq/m1yrMCsin0BmWTmaz6Ws7D6BTF9skHE3jOOEdQ/ih0QOJAixDqI1nKe//kkATxG/0kQF4jpA5SvTgvn0QJ90U6l0FGJF89UAGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnK2HYU7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DE6C4CEEB;
	Tue, 22 Jul 2025 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753210329;
	bh=ncQDcwLtFXrjxRWbHOnOf177mQ7JXQHPpytEH3Fg8+w=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=SnK2HYU7grJiwjXNxheqxrKGhKHtJyDSZQuKzilLPG1K3UhEf+w8fLQEseNI/5JbS
	 34L4mfJmoVzaL4jVzgmNyYZLm3ezaf0LhL4VrJ+aawt2U2MI17ye/IQ9lYaOHib13q
	 uH8sFnySvRLuKw5nWXWTbfJiBP70cw3CaQqQ7kZ4Wqt4E/98t8XZsWbiuoFhyJme3C
	 am38NQU5nhSpRVnZgN0xDyZurUaQBB2mFjg0qAu81XQGq0vSaE5leZ2x0BdB1pI6En
	 g4wNLBDwD6WasTx4CJdD9TpxBNcp5e+wePvv2Zf9LDQy5LsWTxOCIYUR/BEcFJN9xw
	 oeb2DJfxTWSwA==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Jul 2025 20:52:05 +0200
Message-Id: <DBIT6WL2C5MG.2J7OBX6LCVYP7@kernel.org>
Cc: "Caleb Sander Mateos" <csander@purestorage.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Jens Axboe"
 <axboe@kernel.dk>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [PATCH 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Sidong Yang" <sidong.yang@furiosa.ai>
X-Mailer: aerc 0.20.1
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <20250719143358.22363-3-sidong.yang@furiosa.ai>
 <CADUfDZoBrnDpnTOxiDq6pBkctJ3NDJq7Wcqm2pUu_ooqMy8yyw@mail.gmail.com>
 <aH3OsKD6l18pLG92@sidongui-MacBookPro.local>
 <CADUfDZrLKrf6evTXQ03cJ1W4kj0gxsF9Bopu+i2SjkBObXKnMA@mail.gmail.com>
 <aH5g-Q_hu6neI5em@sidongui-MacBookPro.local>
 <DBHVI5WDLCY3.33K0F1UAJSHPK@kernel.org>
 <aH-ga6WdOpkbRK3T@sidongui-MacBookPro.local>
In-Reply-To: <aH-ga6WdOpkbRK3T@sidongui-MacBookPro.local>

On Tue Jul 22, 2025 at 4:30 PM CEST, Sidong Yang wrote:
> On Mon, Jul 21, 2025 at 06:28:09PM +0200, Benno Lossin wrote:
>> On Mon Jul 21, 2025 at 5:47 PM CEST, Sidong Yang wrote:
>> > It's safest to get NonNull from from_raw and it returns
>> > Pin<&mut IoUringCmd>.
>>=20
>> I don't think you need `NonNull<T>`.
>
> NonNull<T> gurantees that it's not null. It could be also dangling but it=
's
> safer than *mut T. Could you tell me why I don't need it?

Raw pointers have better ergonomics and if you're just passing it back
into ffi, I don't see the point of using `NonNull`...

>> > from_raw() name is weird. it should be from_nonnnull()? Also, done()
>> > would get Pin<&mut Self>.
>>=20
>> That sounds reasonable.
>>=20
>> Are you certain that it's an exclusive reference?
>
> As far as I know, yes.

So the `IoUringCmd` is not refcounted and it is also not owned by the
`done` callee?

---
Cheers,
Benno

