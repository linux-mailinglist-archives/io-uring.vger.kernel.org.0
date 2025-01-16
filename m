Return-Path: <io-uring+bounces-5905-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E016A13036
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:53:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4E8D3A41AA
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 00:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD3DC139;
	Thu, 16 Jan 2025 00:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UKMlwquA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555D61CF8B;
	Thu, 16 Jan 2025 00:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736988791; cv=none; b=sZs8+vtj6Rx9ruIxOHjBFUcI/BhSp0l3/dWKeZkYu+B2Bguch7SNVIVRgqul6Af0MnTBX/zv5Ly3kmBntP0nEMdlwHAX4v8+rjZNKyD0HNr1vKdz4qeygOdgHNcvph5DFSEZhbJtbtwLc42wDOedSdjWJwRKSkvLwIlwL/tUG14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736988791; c=relaxed/simple;
	bh=nXLXVPNGVncqR9aq2fwIAJC9tbfGBpwBVznFLPG1Qdk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LcOzAnc0O98NNfe30R002EcurGSIspLDO8aUeBQG0C8QgwscTovDNzZEIGrhZhMChnjlYGMahei0bUygG9pa2gSZkdvWRw4aBNi0iGsmNa6DncpPBt/4lDxXKh7IX554nizf01P1fRggbT04aOnJTqANiiprXTmvO+bSdYlnaMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UKMlwquA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3FDC4CED1;
	Thu, 16 Jan 2025 00:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736988791;
	bh=nXLXVPNGVncqR9aq2fwIAJC9tbfGBpwBVznFLPG1Qdk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UKMlwquAycpo7n43esTwUN4Ztxc2/jZq6cMDqjK1zOnBdV3uM76zQe0jLGxKMCh7r
	 918D7j9EfFJ7N1nUU8DvUtCH8T9mZpRsJjXlmJcrvVQdqcbzyfY6xMr8iSaKZTUao5
	 CmaECctoF+47cTVC7ndH/eT0MuZw6djuE3hT5e3msURd+LU2j15Sh+oUOl5ZQOF2eS
	 9QTZqd+6HvhO0nb445M1U3tP1Uc8aGYdRcJLKb0SniRPl5eVzvtBNV0YVHYJPagNgB
	 IcrJodzfI+YjmUo8DCtDijmCVzOiBjfJ6tzS8EKKosjPyq6C9uD30bQUPz3uRv2LjR
	 bJQk3UdcyvWJg==
Date: Wed, 15 Jan 2025 16:53:09 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 22/22] io_uring/zcrx: add selftest
Message-ID: <20250115165309.52e94486@kernel.org>
In-Reply-To: <20250108220644.3528845-23-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-23-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Jan 2025 14:06:43 -0800 David Wei wrote:
> +$(OUTPUT)/iou-zcrx: CFLAGS += -I/usr/include/

Hm, that's the default system path, do we need this?

