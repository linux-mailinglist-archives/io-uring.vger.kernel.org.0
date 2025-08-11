Return-Path: <io-uring+bounces-8932-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7498EB20919
	for <lists+io-uring@lfdr.de>; Mon, 11 Aug 2025 14:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EE9C2A4577
	for <lists+io-uring@lfdr.de>; Mon, 11 Aug 2025 12:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7C12D3EE1;
	Mon, 11 Aug 2025 12:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="ZuuGQRIO"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97232550DD;
	Mon, 11 Aug 2025 12:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754916294; cv=pass; b=im3C4ILC+Gy6f0+kiRsxfdRJKA1jw/LkBm14K7zqMHed5+95K+anGfPKhXcMrG2bZskmwp2KSMSNi8RDaVW1EHDNjzIC7iTFxE2J4FxbKTnCRucja9xISzp1hxXkTzNOnUOK4pySQwaPSeqaJuryQ37WLcJFZAg1mcPkemR7nUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754916294; c=relaxed/simple;
	bh=ulnko+f7RhYbqw4rJ0GmLKtW69KU7fq6k2US4VAeWA4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Dv85gQwstvT9zo7WbljaQ7tqXLNiqx6QXQG6HqzdNOPuu4M8CKJSajwhw+abJOyd7XPfX0yM6/sorp/NgFbkRUx+246We7ynYoJXh2HHohsQhEMRN4Nqj2SV5OoCTmn5/Ld6OiHP0/W/L1yzOPxaCWZ9zfaZL39/cFaS5dpgzAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=ZuuGQRIO; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1754916280; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=bGgTo0/YKQqNOPrytVrA6Np4r6JiWq7Enb2OsfBOnj17lIZsTs0pKhUcHN9kRZmf0LSXp+TBalhgAk5igueU6tOhndIc7Sz6jvWn5xTz2kKlYcxyZYiY4wm+AkuQLiBCa+bVdvzQyKgk1J8ao4y2jA0OmYxj89CHJ3unt5N1NDs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754916280; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ulnko+f7RhYbqw4rJ0GmLKtW69KU7fq6k2US4VAeWA4=; 
	b=VnqdKbndosnkWXEOHO+199cZ342LFdhHoLinXTzIi0WMv0jPQkP01vleAHKXKkRwKwFs2CXWY4ASeiSRhkaq9igV7+bmG0/4xJ5RLAMWxKmdjeNr/cQNJoO54wCWMVheSg6PL5JtNbC+6gh7ENA+IBi0Xzdz1E2xOda8Kegeh9E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754916279;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=ulnko+f7RhYbqw4rJ0GmLKtW69KU7fq6k2US4VAeWA4=;
	b=ZuuGQRIOKxWONQNCGjUWlUVkXRh1aRFuzgzoaB70rbsnocvTXGbMxyvxG6Y3fp8U
	YmFr7KyMOp21k7x4/5vQ9LbyPAAWROlXRTBFaoHP+gEDVBw1+mDJ2WCVJsVduijWopG
	9cyMUQ4Y6CX5hfQEvEx1K2nSDXt5LCv0PM7j5/+M=
Received: by mx.zohomail.com with SMTPS id 1754916277144319.23689616237255;
	Mon, 11 Aug 2025 05:44:37 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <aJnjYPAqA6vtn9YH@sidongui-MacBookPro.local>
Date: Mon, 11 Aug 2025 09:44:22 -0300
Cc: Benno Lossin <lossin@kernel.org>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Jens Axboe <axboe@kernel.dk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8416C381-A654-41D4-A731-323CEDE58BB1@collabora.com>
References: <aJWfl87T3wehIviV@sidongui-MacBookPro.local>
 <DBWX0L4LIOF6.1AVJJV0SMDQ3P@kernel.org>
 <aJXG3wPf9W3usEj2@sidongui-MacBookPro.local>
 <DBXTJQ27RY6K.1R6KUNEXF008N@kernel.org>
 <aJdEbFI2FqSCBt9L@sidongui-MacBookPro.local>
 <DBY6DMQYZ2CL.2P0LZO2HF13MJ@kernel.org>
 <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
 <81C84BD8-D99C-4103-A280-CFC71DF58E3B@collabora.com>
 <aJiwrcq9nz0mUqKh@sidongui-MacBookPro.local>
 <DBZ0O49ME4BF.2JFHBZQVPJ4TK@kernel.org>
 <aJnjYPAqA6vtn9YH@sidongui-MacBookPro.local>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External


>=20
> There is `uring_cmd` callback in `file_operation` at c side. `Pin<&mut =
IoUringCmd>`
> would be create in the callback function. But the callback function =
could be
> called repeatedly with same `io_uring_cmd` instance as far as I know.
>=20
> But in c side, there is initialization step `io_uring_cmd_prep()`.
> How about fill zero pdu in `io_uring_cmd_prep()`? And we could assign =
a byte
> as flag in pdu for checking initialized also we should provide 31 =
bytes except
> a byte for the flag.
>=20

That was a follow-up question of mine. Can=E2=80=99t we enforce =
zero-initialization
in C to get rid of this MaybeUninit? Uninitialized data is just bad in =
general.

Hopefully this can be done as you've described above, but I don't want =
to over
extend my opinion on something I know nothing about.

=E2=80=94 Daniel=

