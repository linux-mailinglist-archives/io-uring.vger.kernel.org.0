Return-Path: <io-uring+bounces-7739-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CC43A9D86A
	for <lists+io-uring@lfdr.de>; Sat, 26 Apr 2025 08:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA2615A3F5E
	for <lists+io-uring@lfdr.de>; Sat, 26 Apr 2025 06:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7441AF0A4;
	Sat, 26 Apr 2025 06:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="dO3h3FBk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A097B192D97;
	Sat, 26 Apr 2025 06:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745649091; cv=none; b=X/lYbOgHDBKVm5ZMJzFasz3insnbTnhJjSTdKrprxipELuAxNo++trwCOOhvxoT1O7YbwP3aashupciUI212uhVMqIb97wjmxCFnurDlFDEGxxAOTjRi/K2Nr7GYtTDbXCmjga81hBA7GRbF5vO7hC6NM6obPAjBvvjU/0ztNN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745649091; c=relaxed/simple;
	bh=LStxSYSMQWQfySUUYevBrjI7tk6cSXHz2Zsm/0azcgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JLfAs2EHqFP1ORmFMw/ioAiLn3q2cWSZ/7dgAVrS9ovTaOARWzKKQHT0T8wPw2iXJqJJyp1wQYFhL0HGWSh9hylPueigmSPzfgcKl2o0P5FTEuUj5HkyFmdouL6XvbOOlZkvlfQlq6BODUZj7kxBochyKkh73J+K0i+BUxkH7NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=dO3h3FBk; arc=none smtp.client-ip=80.12.242.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id 8Z4AudHRUAix78Z4DuSQ21; Sat, 26 Apr 2025 08:31:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1745649079;
	bh=5noqtwG52h6FrrE55CMqaxj5XRYDTBNIEIbRi1Rpv78=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=dO3h3FBk53n0URP5sGWwvqGIIC7nb3y3Qme+QXyz0HxA0rlcgxtDXrebZJiX2CmDc
	 tQLJT2yCS16OVuENKMNuYvjlbwrh+AutA7W3UtRL9GcOGf2z1Tdab2igjI+ARLQ0SA
	 i7Y3q68HodHMA7Yn98R4+0eVQ52f3Eyksb5aJr0TgYAlm2wb443OmPmdluHVQGE1T/
	 SrGw1yj0NdSyS7TnO0VbN/W1MjZ5YG7UkrIHiv8fahuHWp4pOuMcP9+VmKsXqFQWuK
	 fhtmBSFWu7WWOHyFXLtIKOOHhcDFZOw+qtMXOfLdCelB7DoQirXCvB0j0CfazUJKGP
	 lJwTTNeNMHZNg==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Sat, 26 Apr 2025 08:31:19 +0200
X-ME-IP: 90.11.132.44
Message-ID: <a70511f2-70b2-4f48-94df-c55c179ce488@wanadoo.fr>
Date: Sat, 26 Apr 2025 08:31:10 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v12 1/9] netmem: add niov->type attribute to
 distinguish different net_iov types
To: Mina Almasry <almasrymina@google.com>
Cc: andrew+netdev@lunn.ch, asml.silence@gmail.com, axboe@kernel.dk,
 corbet@lwn.net, davem@davemloft.net, donald.hunter@gmail.com,
 dsahern@kernel.org, dw@davidwei.uk, edumazet@google.com,
 eperezma@redhat.com, horms@kernel.org, hramamurthy@google.com,
 io-uring@vger.kernel.org, jasowang@redhat.com, jeroendb@google.com,
 jhs@mojatatu.com, kuba@kernel.org, kuniyu@amazon.com, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, mst@redhat.com, ncardwell@google.com,
 netdev@vger.kernel.org, pabeni@redhat.com, pctammela@mojatatu.com,
 sdf@fomichev.me, sgarzare@redhat.com, shuah@kernel.org, skhawaja@google.com,
 stefanha@redhat.com, victor@mojatatu.com, virtualization@lists.linux.dev,
 willemb@google.com, xuanzhuo@linux.alibaba.com
References: <20250425204743.617260-1-almasrymina@google.com>
 <20250425204743.617260-2-almasrymina@google.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20250425204743.617260-2-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

below a few nitpicks in case of a v13.


Le 25/04/2025 à 22:47, Mina Almasry a écrit :
> Later patches in the series adds TX net_iovs where there is no pp
> associated, so we can't rely on niov->pp->mp_ops to tell what is the
> type of the net_iov.
> 
> Add a type enum to the net_iov which tells us the net_iov type.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 
> ---

Nitpick: unneeded empty need line above ---?

...

> +enum net_iov_type {
> +	NET_IOV_DMABUF,
> +	NET_IOV_IOURING,
> +
> +	/* Force size to unsigned long to make the NET_IOV_ASSERTS below pass.
> +	 */
> +	NET_IOV_MAX = ULONG_MAX,

Nitpick: unneeded trailing , after such a terminator.

> +};

...

CJ

