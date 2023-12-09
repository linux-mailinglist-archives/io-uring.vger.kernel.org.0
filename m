Return-Path: <io-uring+bounces-275-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B30B80B188
	for <lists+io-uring@lfdr.de>; Sat,  9 Dec 2023 02:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9F3A28170A
	for <lists+io-uring@lfdr.de>; Sat,  9 Dec 2023 01:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3527F8;
	Sat,  9 Dec 2023 01:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfMpESn4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF6C136C;
	Sat,  9 Dec 2023 01:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFB5C433C7;
	Sat,  9 Dec 2023 01:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702086043;
	bh=QTTMy1y8OdOXVPFao0z+PqxfVUfwnOwJIHTnC62pLO4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CfMpESn4OZrSiVqt4ghNyP7H5mKmZaOxJHddpFXLikFAER1zWvTMUqRNqRrJ6uLdo
	 VcFLr/7dQBQbMsAQESjWNVaib0mchj8tO8KljDkXJP+ag7swrimhzqv0Im2NbBLGMZ
	 AzrbksVEbgeC1p4W7szyyXnGRKuc2M9pY5LVb0FR4bGlL0qYzsIqX3u1nRDSw8LHYo
	 tSDVst+26Fmr2TtRDy1VKIZkms+RJE8IfV3daeMj352hXUVohwRDVG2Bfe7e3LKWGR
	 OS41Nk7eteb/3MHs3vRmMW2AYIVp4/qe2TRFIW1QhgC/7YBMxu28WzDw0PaZZwggQp
	 m3uYoz7THKfjg==
Date: Fri, 8 Dec 2023 17:40:41 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 jannh@google.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND] io_uring/af_unix: disable sending io_uring over
 sockets
Message-ID: <20231208174041.3eddcc6b@kernel.org>
In-Reply-To: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  6 Dec 2023 13:55:19 +0000 Pavel Begunkov wrote:
> File reference cycles have caused lots of problems for io_uring
> in the past, and it still doesn't work exactly right and races with
> unix_stream_read_generic(). The safest fix would be to completely
> disallow sending io_uring files via sockets via SCM_RIGHT, so there
> are no possible cycles invloving registered files and thus rendering
> SCM accounting on the io_uring side unnecessary.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0091bfc81741b ("io_uring/af_unix: defer registered files gc to io_uring release")
> Reported-and-suggested-by: Jann Horn <jannh@google.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
FWIW

