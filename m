Return-Path: <io-uring+bounces-7272-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A7EFA74D6C
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 16:09:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F4043AAB16
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 15:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF13E1A9B5D;
	Fri, 28 Mar 2025 15:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="k9yjoY6H"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4D91B4F15
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743174538; cv=none; b=In05GEkhsaZYQM+f/A7KEu+AxKdgaNS7cw2Vxrj8GuSlrhINKU6Bu1nYSdSTntBMyuDGlNily63ZMAUsKUF2lGNSvRBXdukAJgiMrEhSTt6bq9Ptw/qmJHIPRCwPdYMqKbYLYMUqbfWq2jVulnimoz/BxG3KldzaITwySIqzrcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743174538; c=relaxed/simple;
	bh=VRYm18uJ88BAeuAIdxwIclAuUDFTNaVJ5W992LUlAxc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=F/5jr3y1z03zDqjGprYwNmEBN2jBiISWZfJX/HjKdHI74PWvCxe6VnksanSL+2uBzlvXPH1L88r4QkVeRinUWHQtUpu3Bx7m7wQZTyntQbW1otTSDx3xUMqZTVSTjKVgfebH75y6WSkVc0XC7ZdAv/ryQLcbNvPd9MsmpPCk1YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=k9yjoY6H; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=k8d+DDvGLbz5QPJw0Yh9axFiyMnpU1amBg6HeJaNcSA=; b=k9yjoY6HLXxhoZw/7qtwynEadF
	e3cuIeIbVjXMRkAZeZ/NR5DQWvGYHBR5CjDKDme+hsXgnJ/fVqr1xgfyWgn7EdDS78QDTxRF3nOzW
	orIrWaINJwgYVwMXV6QzG3koYXlkWPlC7Idch2P2zTMYM0bs0hk7kJbUVscuEO4R7k9y/Z4czhZfd
	ifZ6nqWwS8D0XnPUyVMtXeJ6X3QvAIyTKCnIMlMUS5hUfKEjmvllCJkTB1mbUDXgJ7QRghWgaOqTE
	E2Wu4sDALaDJuU5xp6hz8t80WLEkY8yeVxNHuC57RMSV10taL64sbtZWmB5mLNjwm93zFowHMlw6k
	xhOba6sm6ExXeG9wOOV+aW2AnQYbaFFVhM8di5RWqpZJLAhVVT5LedaQ+GPy40duHo1BtIDq34gHV
	N96XP2+DY/p14+Tj8qEapRAklFcvLl2jA01TqkBE9hrhdDK9fsqxkje1i7hAlCzvcx19t7PkgF+92
	wN4JaKmqhDheBVdNsaxXcEpZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tyBKI-0077Ss-1M;
	Fri, 28 Mar 2025 15:08:54 +0000
Message-ID: <032c0b03-5ad5-40a8-a496-c626ff335b2d@samba.org>
Date: Fri, 28 Mar 2025 16:08:53 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
From: Stefan Metzmacher <metze@samba.org>
To: Jens Axboe <axboe@kernel.dk>, Breno Leitao <leitao@debian.org>,
 Christoph Hellwig <hch@lst.de>
Cc: io-uring <io-uring@vger.kernel.org>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
 <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
 <0fd93d3b-6646-4399-8eb8-32262fd32ab3@samba.org>
Content-Language: en-US, de-DE
In-Reply-To: <0fd93d3b-6646-4399-8eb8-32262fd32ab3@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 28.03.25 um 16:02 schrieb Stefan Metzmacher:
> Am 28.03.25 um 15:30 schrieb Jens Axboe:
>> On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>> while playing with the kernel QUIC driver [1],
>>> I noticed it does a lot of getsockopt() and setsockopt()
>>> calls to sync the required state into and out of the kernel.
>>>
>>> My long term plan is to let the userspace quic handshake logic
>>> work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.
>>>
>>> The used level is SOL_QUIC and that won't work
>>> as io_uring_cmd_getsockopt() has a restriction to
>>> SOL_SOCKET, while there's no restriction in
>>> io_uring_cmd_setsockopt().
>>>
>>> What's the reason to have that restriction?
>>> And why is it only for the get path and not
>>> the set path?
>>
>> There's absolutely no reason for that, looks like a pure oversight?!
> 
> It seems RFC had the limitation on both:
> https://lore.kernel.org/io-uring/20230724142237.358769-1-leitao@debian.org/
> 
> v0 had it only for get because of some userpointer restrictions:
> https://lore.kernel.org/io-uring/20230724142237.358769-1-leitao@debian.org/
> 
> The merged v7 also talks about the restriction:
> https://lore.kernel.org/all/20231016134750.1381153-1-leitao@debian.org/
> 
> Adding Breno ...
> 
> It seems proto_ops->getsockopt is the problem as it's not changed
> to sockptr_t yet.

commit a7b75c5a8c41445f33efb663887ff5f5c3b4454b
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Jul 23 08:09:07 2020 +0200

     net: pass a sockptr_t into ->setsockopt

     Rework the remaining setsockopt code to pass a sockptr_t instead of a
     plain user pointer.  This removes the last remaining set_fs(KERNEL_DS)
     outside of architecture specific code.

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Acked-by: Stefan Schmidt <stefan@datenfreihafen.org> [ieee802154]
     Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
     Signed-off-by: David S. Miller <davem@davemloft.net>

only converted setsockopt function pointer...

Is there any reason not to change getsockopt too?
Except for someone needs to do the work?

metze


