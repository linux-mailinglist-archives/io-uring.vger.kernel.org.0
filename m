Return-Path: <io-uring+bounces-6725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 968DEA4317D
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 01:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3B7E3A8CC5
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 00:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB09F367;
	Tue, 25 Feb 2025 00:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUBXlpl4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF4C366;
	Tue, 25 Feb 2025 00:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441747; cv=none; b=kykjV4PxEOLt2E1u7h813ScMPEgtRYHM/Balex+JmAaXWLIe+W2HUO2wedP/pd+K1Ca02jMkTM4hI/CSBkOWNnBXTYNZi4FAVK0cdkVA06Vxy1xerIvftdUAfGhZ7doSys9cWjuywKZrJYbBayb39idCeHSs3/KmbxkiZrXkmlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441747; c=relaxed/simple;
	bh=K4JnVdphQ3T2+hWP3FMbWebBQFthET305SWLD3c48So=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxAgg3Q4dor6CxVQTwMogQ97GkvTxfTeIxfsnAoLLyq3E6w+om6/THbcwWQoKWYOdwULb0+z6uvIxrAa969NxvPNP0rZ3WT4OkDx57AncF0ijHSIUV2i6oYIJxBgrwrh3YU6rFIq/95saI1IbOIrxajo4De3KEnHG8SRE3S+vMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUBXlpl4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C2FC4CED6;
	Tue, 25 Feb 2025 00:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740441747;
	bh=K4JnVdphQ3T2+hWP3FMbWebBQFthET305SWLD3c48So=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DUBXlpl42H0Sa5Gcbu2NS855QRg0XaM2cHNlzDNYT8FdJFFFyidNsdZkfmDa5GYfQ
	 5D8Z8aKJfGDfFoOKUk7oj7bb9ERr3ZqAu5vFATgoMds7zxf+zNdV80eDsUbzKNPKq6
	 TUIjf7CghzrJoR8yPYfzINj4bSEH35DcqrSFarIDSLp8kktWBCN7PoXSW7mGa6GX5H
	 vgL4lVUat77vAH6Gdf8pBI+eifPb3XwitOSZnPDONZGMALwNeX5D2Ayv2+p/f5K3EE
	 iayW9O2s1UbmFSA0Yb149lX3TIb8tV6Ol5qkB7BJEMinEJdhvaZRjG8IgZRhU/2brp
	 IIvLbNkuWzdMg==
Date: Mon, 24 Feb 2025 17:02:24 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
	asml.silence@gmail.com, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com
Subject: Re: [PATCHv5 02/11] io_uring/nop: reuse req->buf_index
Message-ID: <Z70IkEtkNUkdDDg4@kbusch-mbp>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-3-kbusch@meta.com>
 <54284f45-b597-415a-a954-5ab282747704@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54284f45-b597-415a-a954-5ab282747704@kernel.dk>

On Mon, Feb 24, 2025 at 04:30:48PM -0700, Jens Axboe wrote:
> On 2/24/25 2:31 PM, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > There is already a field in io_kiocb that can store a registered buffer
> > index, use that instead of stashing the value into struct io_nop.
> 
> Only reason it was done this way is that ->buf_index is initially the
> buffer group ID, and then the buffer ID when a buffer is selected. But I
> _think_ we always restore that and hence we don't need to do this
> anymore, should be checked. Maybe you already did?

The IORING_OP_NOP opdef doesn't set the buffer_select flag, so the req
buf_index couldn't be used for a buffer select id.

