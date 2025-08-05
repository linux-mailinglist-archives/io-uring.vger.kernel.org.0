Return-Path: <io-uring+bounces-8884-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFDCFB1B3F5
	for <lists+io-uring@lfdr.de>; Tue,  5 Aug 2025 15:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECF3F16DAA2
	for <lists+io-uring@lfdr.de>; Tue,  5 Aug 2025 13:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCE9245014;
	Tue,  5 Aug 2025 13:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="kbgsaQO1"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0313A1F19A;
	Tue,  5 Aug 2025 13:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754398973; cv=pass; b=qi/yXabmZ4AqrpKpH/Q+e4kJOoexfMbT5PfJSMSMkMSU3omgSVkQn0al7J0f+U4CWoh6+J5V31gcsROWLT9i8R1ofvkiF9/DKOTEe3n//oo4Q2P8qP+PO5ZYXhkVDYUr8kQu0nsZJ6pS6rWoMDq31ne8cq1+Qg+ocu+vu/JY9Js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754398973; c=relaxed/simple;
	bh=n2Sb20dV+591KKOtNEv4uJy6Vhzl2VnY9PrLgehYi1Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=rB2Oe+hjAVXSiJuAD33OkJzoJuSTnASNDD82E2/c1PrdlWmN5yVeo/c+frl+SPdUIZu3Y+/XNYSdNUWOF2YiX2VIZSwTKLpSdr/46L9xNVmttvn5Ciosqbw9q6N4mx8Ww77RwcOnZtO9naK/lMH6Z/rKTy/kkw8JdyhuLynajaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=kbgsaQO1; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1754398956; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=KL0l75xCB6MJlQDlqSvyu2DtVauw3dgDEfuUEmLj4dq4pPkUT2iffloKgOtOuB4R5Oob2hwnx2umAFNqiRnntwbu1Vbmy71Uy9kDtODe9q3n/bBhpowzROAnjRdDj6v+C626+VgafXqvsU99VWUGepc8Ga1cXGrJD4Em/smG2lE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754398956; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=n2Sb20dV+591KKOtNEv4uJy6Vhzl2VnY9PrLgehYi1Q=; 
	b=kVEeT0q7ZSDMRcYddYTOGmq2Va8BJ38dBsP50qQQIWKzL6IjSrniaKI8FFzfli+rARZ/eD+sLNV4Ny8mS+KyObZus0AZgY9pbsxk9GxC7YzZOcaw1Hi70/BHQEfUweDtxUdHLHIRDXQbGWsCyDPt+PlScrBT4BhDnHKn0RS34/c=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754398956;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=n2Sb20dV+591KKOtNEv4uJy6Vhzl2VnY9PrLgehYi1Q=;
	b=kbgsaQO1x5F+cFGW1EcXtI9I7iLDmjXvGJBTY6PD95Wqoqu52S1X5wQ1HKpjQqi+
	+k4ZdndZJAoAyL3dWovPhffrorjHLthBewC5lJY7pxIftem9zwb9n2pHIRMthUMGt2G
	pbf8iUI8IiLD6J/cYUhEMfY4AQXs0fJm3Aik+a2c=
Received: by mx.zohomail.com with SMTPS id 1754398953004767.270068394596;
	Tue, 5 Aug 2025 06:02:33 -0700 (PDT)
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
In-Reply-To: <aJF9B0sV__t2oG20@sidongui-MacBookPro.local>
Date: Tue, 5 Aug 2025 10:02:18 -0300
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 Benno Lossin <lossin@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Jens Axboe <axboe@kernel.dk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8A317BB0-750B-4B68-9C62-2732DA3986F8@collabora.com>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
 <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
 <aJF9B0sV__t2oG20@sidongui-MacBookPro.local>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External

Hi Sidon,

> On 5 Aug 2025, at 00:39, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>=20
> On Fri, Aug 01, 2025 at 10:48:40AM -0300, Daniel Almeida wrote:
>=20
> Hi Daniel,
>=20
>> Hi Sidong,
>>=20
>>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> =
wrote:
>>>=20
>>> This patch introduces rust abstraction for io-uring sqe, cmd. =
IoUringSqe
>>> abstracts io_uring_sqe and it has cmd_data(). and IoUringCmd is
>>> abstraction for io_uring_cmd. =46rom this, user can get cmd_op, =
flags,
>>> pdu and also sqe.
>>=20
>> IMHO you need to expand this substantially.
>>=20
>> Instead of a very brief discussion of *what* you're doing, you need =
to explain
>> *why* you're doing this and how this patch fits with the overall plan =
that you
>> have in mind.
>=20
> It seems that it's hard to explain *why* deeply. But I'll try it.

Just to be clear, you don=E2=80=99t need to go deep enough in the sense =
that
you=E2=80=99re basically rewriting the documentation that is already =
available in
C, but you do need to provide an overview of how things fit together, =
otherwise
we're left to connect the dots.

Have a look at the I2C series [0]. That is all you need to do IMHO.

I=E2=80=99d use that as an example.
=20
[0]: =
https://lore.kernel.org/rust-for-linux/2D1DE1BC-13FB-4563-BE11-232C755B511=
7@collabora.com/T/#t

=E2=80=94 Daniel=

