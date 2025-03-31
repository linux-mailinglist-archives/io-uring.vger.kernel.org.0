Return-Path: <io-uring+bounces-7314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D46A768A2
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 16:50:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C33DB188D383
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 14:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB5B228CB0;
	Mon, 31 Mar 2025 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vIR7XGd4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B4021859F;
	Mon, 31 Mar 2025 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743431806; cv=none; b=K9lBTa1nziLW5SHIGDKm6hh1GYuFjc8DfcBIJjU9ir6Jh/dj7qflnslstLPDgWDSL5Lz5YcDyPSYErjcgEq6NxVDHzdIf3yynqJvb+PG0rKQLVweGIg/2wszv2riSkDRYmSApqUHbMNLLE9wPEiFTkVtANgoMNUf27NGcQXQmL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743431806; c=relaxed/simple;
	bh=saBfwSTx9+zrA2PPu4GkKVVeKaJUPYevf/A5oECr0ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Atx99MmGOBTo3I5oX869dZbc26YR8rrohPo/IyHqzWdqGIzJUV0gZInHmTBW+8r+8rRA/6hMG4yxzck/mfMxdWQerHjlggHyOOLS6eqAdKAN2UN2T40Ur7ZxZIxc0yAw5cOGQOUpwiwEHjROn348+XuYsuV9A+TuHJWnx9MXyxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vIR7XGd4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6394CC4CEED;
	Mon, 31 Mar 2025 14:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743431806;
	bh=saBfwSTx9+zrA2PPu4GkKVVeKaJUPYevf/A5oECr0ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vIR7XGd4L3Iz9uJZYZ/LcQjWI9ZXFd2ChMXVauWYXRo3tIRGb1kn3kwp/B7V2Jskb
	 6PDPr0nOrrCS2KTkQp8zwJPJ7qwsdTGnTHLyEHms9ZErYZE8aand4okT8pSWsLgXHQ
	 ybNAiGdg6EORQ4xfV2u4PSKvE5dZq9+IMPgWcQ/IpFL5v5Jus3F7SKMhgEl9jTEds9
	 Wm00667Wx3UtCd1xzPJQlVt1Tz5X0/tuZfQapA2UBXtEU7ZtX9FnNzBxCppbSfmspK
	 86P63Vs1o3tDnvbXpDntX3NkoyoigIUZ4eX25iPgUUmI7g8jYBc1oCgkfIPG0LePEw
	 p5IuDtle2V8Qg==
Date: Mon, 31 Mar 2025 08:36:42 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] nvme/ioctl: move fixed buffer lookup to
 nvme_uring_cmd_io()
Message-ID: <Z-qoevl5Jaf7WFsQ@kbusch-mbp.dhcp.thefacebook.com>
References: <20250328154647.2590171-1-csander@purestorage.com>
 <CGME20250328155548epcas5p2368eb1a59883b133a9baf4ac39d6bac6@epcas5p2.samsung.com>
 <20250328154647.2590171-4-csander@purestorage.com>
 <48b9a876-0e3b-4c89-9aa3-b48f502868c3@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48b9a876-0e3b-4c89-9aa3-b48f502868c3@samsung.com>

On Mon, Mar 31, 2025 at 12:16:58PM +0530, Kanchan Joshi wrote:
> On 3/28/2025 9:16 PM, Caleb Sander Mateos wrote:
> > For NVMe passthru operations with fixed buffers, the fixed buffer lookup
> > happens in io_uring_cmd_import_fixed(). But nvme_uring_cmd_io() can
> > return -EAGAIN first from nvme_alloc_user_request() if all tags in the
> > tag set are in use. This ordering difference is observable when using
> > UBLK_U_IO_{,UN}REGISTER_IO_BUF SQEs to modify the fixed buffer table. If
> > the NVMe passthru operation is followed by UBLK_U_IO_UNREGISTER_IO_BUF
> > to unregister the fixed buffer and the NVMe passthru goes async, the
> > fixed buffer lookup will fail because it happens after the unregister.
> 
> while the patch looks fine, I wonder what setup is required to 
> trigger/test this. Given that io_uring NVMe passthru is on the char 
> device node, and ublk does not take char device as the backing file. 
> Care to explain?

Not sure I understand the question. A ublk daemon can use anything it
wants on the backend. Are you just referring to the public ublksrv
implementation? That's not used here, if that's what you mean.

