Return-Path: <io-uring+bounces-10890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A8FC9CB58
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 20:04:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8BE75348F9E
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 19:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C0F2D592D;
	Tue,  2 Dec 2025 19:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TG1fVrcg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A012BE7BB;
	Tue,  2 Dec 2025 19:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764702274; cv=none; b=Wt15nkFAxuau/xfdPRXn0NyL6xhzA8zDRBztFtH2LObC0UjQghftmIVwuPKS/b5ZB7I682+NLuDwVHAJo2moqvk+2P2I7zFCwRwHKHOmq4IdOjQPBNPNEqwIEHh1eq60Dmu+Fhs+sAOu4G4Uenjt+0wehFrG2tyoh8/0IFqXoRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764702274; c=relaxed/simple;
	bh=oMgyYMdZlPK5nSC4bnds/jvG0PuLnbp31xYiyr7l05A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GLsWroxCp315WUF1QYCWbvANHMTmyIkn9B1pzc2R+mTUmF7/6sFeeqJ4uIqccFFniSyPSQpkzW6dk4qK+vizMuV/fDfzsp+3obxUlaBC9ikBjosHjMZRvzu09HX5bGP1iVm68lNpW69ZFG6gexbwLfoz6e+reeaIKGl2bmtX2bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TG1fVrcg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78353C4CEF1;
	Tue,  2 Dec 2025 19:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764702273;
	bh=oMgyYMdZlPK5nSC4bnds/jvG0PuLnbp31xYiyr7l05A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TG1fVrcgd5Zo5KKXO6+NgGvBQzCu44jV2qwy0lUEfEze8wSWyyldtEzSSlycct91s
	 tvbOxR1VmurJZ1DkJ5sEjxc4S8RaXsq7tGn27mh9pyPkyQ4C7eFm2PW2TXGV5t1hEs
	 31DxmpFmwSA6nbLCaCzbD0T1/GNm3c+MLtne6SMUBABic2tfLDw7AfYcGg8DHVL2x/
	 jIbsaCZp51Vk8wUB84dtEftnrNbffBZWAk+op9O7UXJgsPnVIDdBH8D+DdNorHsi5N
	 AYi1PfjhjEyRJFOjg3h8K/lTnho51LyG0pFLHTUt+5hL+60ZIhvDt5j1sqHKj6a61C
	 DVSt//o+vPwtg==
Date: Tue, 2 Dec 2025 11:04:31 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jonathan
 Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>, Pavan
 Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Shuah Khan <shuah@kernel.org>, Mina Almasry
 <almasrymina@google.com>, Stanislav Fomichev <sdf@fomichev.me>, Yue Haibing
 <yuehaibing@huawei.com>, David Wei <dw@davidwei.uk>, Haiyue Wang
 <haiyuewa@163.com>, Jens Axboe <axboe@kernel.dk>, Joe Damato
 <jdamato@fastly.com>, Simon Horman <horms@kernel.org>, Vishwanath Seshagiri
 <vishs@fb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 io-uring@vger.kernel.org, dtatulea@nvidia.com
Subject: Re: [PATCH net-next v7 4/9] net: let pp memory provider to specify
 rx buf len
Message-ID: <20251202110431.376dc793@kernel.org>
In-Reply-To: <0364ec97cc65b7b7b7376b98438c2630fa2e003c.1764542851.git.asml.silence@gmail.com>
References: <cover.1764542851.git.asml.silence@gmail.com>
	<0364ec97cc65b7b7b7376b98438c2630fa2e003c.1764542851.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 30 Nov 2025 23:35:19 +0000 Pavel Begunkov wrote:
> +enum {
> +	/* queue restart support custom rx buffer sizes */
> +	NDO_QUEUE_RX_BUF_SIZE		= 0x1,

If you have to respin -- let's drop the NDO from this define.
To suggest something specific - QCFG_ is a better prefix?
IDK why we ended up with ndo_ prefix on the queue ops..

Also RX_PAGE_SIZE is a better name for the fields? RX_BUF_SIZE
is easy to confuse with RX_BUF_LEN which we are no longer trying
to modify.

