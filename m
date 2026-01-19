Return-Path: <io-uring+bounces-11814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6899D3B303
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 18:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9E6393048231
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 16:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52AF42EDD41;
	Mon, 19 Jan 2026 16:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROxnCHVY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B512FE593;
	Mon, 19 Jan 2026 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841862; cv=none; b=drk8OLHOCGj/dfSODZMCN7CpyEDvLnjVbB29CNpdE2vMntfJdFBf7fB8gSPt16M94V3/n+GUDXYlH3NOc9HuwacolH0n+j3tgvk8Mw9COFcfFAwQStHodk+9u8tuuF8PJwqA/iWnp9Bcjh5JtQvy0kWVDirg1ZuuubdGeYilJe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841862; c=relaxed/simple;
	bh=YW8Q9Lrp/bZQRu5rYELHUc9owzCj1x411m/oRmGY61A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a5S3LjSeguLSwCi8jBxo9cvBeo0YKhxmpOluPF6B4jo0O6aObabJ6o0Tcr7YvuOe2ag3VAdvZ98GFuIimUfPf0Go2LkSfO1ubRJnB7rfUm45DFkpVqWrAUt6MqZpvGKailyjMwXrGYXdUrFlM/8hETAQfOK7VJ5HkD9L0+qsttE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROxnCHVY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF98C116C6;
	Mon, 19 Jan 2026 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768841861;
	bh=YW8Q9Lrp/bZQRu5rYELHUc9owzCj1x411m/oRmGY61A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ROxnCHVYM82zYZN+jSegSYEzsqVDfjVYwXb3yhsN3Z1ZlaUF5gukdxz9XNEvFF/5t
	 mtrRIJVcR/okwxcWj+TbqhpTVzdQYh5BGz9VsSKZFN4ta0MzQIbHcU8S1Bu/mRWg+p
	 1g3ZbULO9jvF+SBlE4G0pJmfv84EU9n3j/TamvLgQvZBC5nkTz3wDiDXei/jxErWmh
	 d5GlLI9OjptF8FXjUzykeCU9hjns/DKjat7mHwQvDrrgUoWcvayl1q007/A2V8b1mA
	 8I5/KxrFJtRHJWgKIQr5NZWfsY8BZVQDOAk3fpPZmmspIDbKVBWXUOoH+4Dp+QjBTJ
	 Y6eZMsr498kLA==
Date: Mon, 19 Jan 2026 08:57:37 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jonathan
 Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>, Pavan
 Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Joshua Washington
 <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Alexander Duyck
 <alexanderduyck@fb.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Shuah Khan <shuah@kernel.org>, Willem de Bruijn <willemb@google.com>, Ankit
 Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>, Alok Tiwari
 <alok.a.tiwari@oracle.com>, Ziwei Xiao <ziweixiao@google.com>, John Fraker
 <jfraker@google.com>, Praveen Kaligineedi <pkaligineedi@google.com>, Mohsin
 Bashir <mohsin.bashr@gmail.com>, Joe Damato <joe@dama.to>, Mina Almasry
 <almasrymina@google.com>, Dimitri Daskalakis
 <dimitri.daskalakis1@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Kuniyuki Iwashima <kuniyu@google.com>, Samiullah Khawaja
 <skhawaja@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>,
 David Wei <dw@davidwei.uk>, Yue Haibing <yuehaibing@huawei.com>, Haiyue
 Wang <haiyuewa@163.com>, Jens Axboe <axboe@kernel.dk>, Simon Horman
 <horms@kernel.org>, Vishwanath Seshagiri <vishs@fb.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, dtatulea@nvidia.com, kernel-team@meta.com,
 io-uring@vger.kernel.org
Subject: Re: [PATCH net-next v9 0/9] Add support for providers with large rx
 buffer
Message-ID: <20260119085737.2161f9e6@kernel.org>
In-Reply-To: <7ab5309d-8654-4fa8-9a1e-24b948bccba2@gmail.com>
References: <cover.1768493907.git.asml.silence@gmail.com>
	<7ab5309d-8654-4fa8-9a1e-24b948bccba2@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 Jan 2026 13:54:37 +0000 Pavel Begunkov wrote:
> On 1/15/26 17:11, Pavel Begunkov wrote:
> > Note: it's net/ only bits and doesn't include changes, which shoulf be
> > merged separately and are posted separately. The full branch for
> > convenience is at [1], and the patch is here:  
> 
> Looks like patchwork says the patches don't apply, but the branch
> still merges well. Alternatively, I can rebase on top of net-next
> and likely delay the final io_uring commit to one release after.

Yes, David refactored the test in the meantime :/
I'll pull the branch.

