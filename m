Return-Path: <io-uring+bounces-3817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62BC79A4361
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 034AC281111
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 16:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D5C20262E;
	Fri, 18 Oct 2024 16:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CYqZMDiT"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17941EE028;
	Fri, 18 Oct 2024 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729267953; cv=none; b=cNyNrxiWrSBskWp4i4elWeFxdvz87slIeoODMOcMt8fTw8W1avcpD+tnatYzeW9SZLSHxLWA3HP4e+O4p8HxdKxb8NRbmGI7RztwvQYAtqx942+ZvzXhcuglG/YrYVQOK3Q5R6BjfBENGwwBedzZeFz5nysbk+fYRk+Zo1m4L4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729267953; c=relaxed/simple;
	bh=rQV62hxlr3+rovr4DKSmaBZ3uldc0H0pGK7FLzGu7AE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QhG4UFJ/UstckIHMa7uq4z21NG7NUIuFSsrIxi0OMcVzctBsnmKoDq4gebCAw0Of3QmCMVr6uWCdQaocH48iUi3xTIKepXhyoXyEU0th/oQrysq5IxKb3IM0JgIptiuKb68i8cZgkaUGFUslXkRDW+Q7I8SwVxEhDrP/b4Pw7b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CYqZMDiT; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XVV8v3Npwz6ClSpy;
	Fri, 18 Oct 2024 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729267948; x=1731859949; bh=Jq8Ad7kSqhfGS4A9cN7JcUt3
	5EIeLJtTutEGEd7kVT4=; b=CYqZMDiT510FtZkz5+5s2r9tWuqsJpkL57dW6q0W
	KUR9t7uDPTGPvIsa0Cq3L4lkTPNdJVJeck1/337Msd7Xei4yJ5Cc+toXZD+bsyfC
	miom68w1FCZJpPyFDVUaTdQQlkSyN71dk94Y3cm54f90RI/q6Km0IGlMlG+oHaA0
	3vk6y/nZL64imq7VKQIPqlNcJoQ91u5kG7FPN39r/lVNvJTJvoe5IRg8krk3uPC1
	Ha1cEoEsBAdmCzV3Hu8YUTljzYU5VrSjULwenpdxuPJEqSQR3pb2iTKgwW311QEm
	iBzcpXPw365T9NAxjZ5vubAXLmBs/Tz9v3GDw3woP9G8Ag==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id K5RnAnkziMAE; Fri, 18 Oct 2024 16:12:28 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XVV8k4Fpdz6ClY9l;
	Fri, 18 Oct 2024 16:12:21 +0000 (UTC)
Message-ID: <d09efed0-c1d2-4c7b-a893-0c7367d1a420@acm.org>
Date: Fri, 18 Oct 2024 09:12:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 2/6] block: use generic u16 for write hints
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
 javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-3-kbusch@meta.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241017160937.2283225-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 9:09 AM, Keith Busch wrote:
> @@ -156,7 +155,7 @@ struct request {
>   	struct blk_crypto_keyslot *crypt_keyslot;
>   #endif
>   
> -	enum rw_hint write_hint;
> +	unsigned short write_hint;

Why 'u16' for ki_write_hint and 'unsigned short' for write_hint? Isn't
that inconsistent?

Thanks,

Bart.

