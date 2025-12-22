Return-Path: <io-uring+bounces-11245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9155CCD4817
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 02:03:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 604793005FCD
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 01:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84A21946BC;
	Mon, 22 Dec 2025 01:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=veygax.dev header.i=@veygax.dev header.b="Xvn7vZtM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-07.mail-europe.com (mail-0701.mail-europe.com [51.83.17.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A3F1EA84
	for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 01:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.83.17.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766365384; cv=none; b=d/ZsfbNOY8gL4leJjHyqAMUDrz/rROOVkc+bIwxUvqUDCD6U4rwkKfli2qvaBxqr1VuFlvHGc6LCN/3grpMIRVbm1WobDgCcZkkhWbxLdJv0aqexarxDJCuL2iKJ7q0KHslrTjd+YSLGaZYY2VrXbkMAzhIZkEon3c5pQhnM9/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766365384; c=relaxed/simple;
	bh=XgMAZ0Yxez7Hn3QkJKpkv1heLb820N7MiqVt+lhHLOo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N+zZ7Lxu25uqKF9OV5xukOQvQtwyROKnxuvmhBLENfqIdlBE8hizj7HAA8hONdVYPjJdJQ9n5a82SuY5a+3vsl85/tyF+nRaxNhrpuvX5UVZ7QsJpH/wTLThvaGGii1gIvJ9cgtwcAJEawee/F9RPXytueH4b4WzLuH+knTn0oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=veygax.dev; spf=fail smtp.mailfrom=veygax.dev; dkim=pass (2048-bit key) header.d=veygax.dev header.i=@veygax.dev header.b=Xvn7vZtM; arc=none smtp.client-ip=51.83.17.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=veygax.dev
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=veygax.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=veygax.dev;
	s=protonmail; t=1766365372; x=1766624572;
	bh=2W4WrUTZBZ8YBiWj5mlbqN0BqLiELz/K0TCnECzZj14=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Xvn7vZtMx9Xr4PAWihM5GWyMApaHklEO23ZBVzhXFBBPmQEI9uXu1A95fnhDA7fY3
	 hLESwhP1l/KaQ6LX/mzRmz8SMZc3KodxzGdIlIK3KWr7yJYIeOAdGsHOl3oHXZNNhM
	 pjQaSD+xzOEmghZK97MBnEIaXRlKhH6TYo+VFC/6yi1vhuZP2cvERdr+2/PNWP/He/
	 ba++v6hhTF/UCXv2aH4b5bsbstAcgjhYODzesOv8SiaAYDfd3qdEcdfpoS/PNKTJ/u
	 9WVZuFD3ND7lbOuoDaBVExiyXMULVt7zAnF/O5llDj1htkw2eYBYj2vTnrWzOZ2pQj
	 IvHWHybaDShBQ==
Date: Mon, 22 Dec 2025 01:02:47 +0000
To: Christoph Hellwig <hch@infradead.org>, Keith Busch <kbusch@kernel.org>
From: veygax <veyga@veygax.dev>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Caleb Sander Mateos <csander@purestorage.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in io_buffer_register_bvec
Message-ID: <e0054c50-3ea2-48e4-b913-8cd861a34f72@veygax.dev>
In-Reply-To: <aUTjxJEDYYfOT_QG@infradead.org>
References: <20251217210316.188157-3-veyga@veygax.dev> <aUNLs5g3Qed4tuYs@fedora> <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev> <aUNRS1Qiaiqo1scX@kbusch-mbp> <aUTjxJEDYYfOT_QG@infradead.org>
Feedback-ID: 160365411:user:proton
X-Pm-Message-ID: 5ae190422f98687d7b8dcc6b04ded977062019ce
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 19/12/2025 05:33, Christoph Hellwig wrote:
> The above is simply an open coded version of doing repeated
> __bio_add_page calls.  Which would be rather suboptimal, but perfectly
> valid.

I can confirm iterating over num_bvecs in __bio_add_page produces the
same KASAN output.

=09for (i =3D 0; i < num_bvecs; i++)
=09=09__bio_add_page(bio, page + i, PAGE_SIZE, 0);

Also (to all CC's), please disregard this version of the patch. V2 has
been posted with typos fixed and a more performance efficient approach.
https://lore.kernel.org/io-uring/20251217214753.218765-3-veyga@veygax.dev/

--=20
- Evan Lambert / veygax



