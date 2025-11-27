Return-Path: <io-uring+bounces-10822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF0BC8DA9F
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 11:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 652C14E6017
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 10:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3A623ABA9;
	Thu, 27 Nov 2025 10:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="b9d35gq6"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFFBC13B;
	Thu, 27 Nov 2025 10:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764237652; cv=none; b=d0ia3SVp0wgSVwaZKuWSY48A5niHQa+8nZ0/XpdnRwBPJMoU8lziGw40FSl+jsnF/lFpC9R2/mFhA1cTCDqYoProfOLvQP89wQI0xel2/sKXd9aLuFJhlYkMqJIGnkryk4x7J3+pknZLtFl4mFDYP0SMg/EO3OvB0pNBRa4wxko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764237652; c=relaxed/simple;
	bh=mTNcRsNUmAZxjUjhRGk/zXfnFuxw9csNeCE1CCJVepA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PGtqEb1CzsCChUL7fYH+L7wtHO6JcRddpB0KST2EpzCHjynkBYFPxS17kVHUAqdHjouBgeVr5SbUwURQyhruj63vfreuzuvANzCRxWgScMmfGbhFKsxZ96euJgrW+9XK9GCfcZcCHxg9SKHGF+tqZ+7SkpsZZTtZGpJoD4W8drY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=b9d35gq6; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=F2zpbaJahseu3rIsIrIii/w/rv9EwhaYzhHAWVmULG0=; b=b9d35gq6J96c21yDOOYWinZkAP
	Dv8FJ/2OZc/965A1Kc3+DagB/UAd3UWjA3JEI/yO3n/nxIsM3hzTI3K9D+Lk7UM2OQKW1EujSQvm9
	FwY51z276Ow3YvsR3TLqrzcV/tOCZ91dR6We/Ibb+CSBALCJr2dgcN0FGxTwgCZywOtxCUAnp9pN3
	W/bdJztYiWs8COH6C2qP6m8WTBY4dGc6BEhCwVkEvS59TqE09/WxlHQpL+cZWRVMlunYSW/LSvgQd
	B9BxxASlR7rQMvDyChn/2NWZFaVCSpjArs6Ltl33TjuvKUjKoNTDtRvw3XQoX0dIdiJRlQLTFMWkx
	EM2Q4CBT9/D5/0jq+fFbeSqR4yCm1ukoHUE4r2lHUhJh9lQmEFwdG187Z/oUqvt6Dpf0bTzD9m6Yg
	TaYFfLEFIFc1Wn5hmACK4bqeIu5ZRIF9i9PRf/j54r5kdveRX4SkdFMXTAAn9dt4w6ytAPGQs4/vf
	tWAVhPaOhgTmFbGBytWN5miz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vOYnt-00FygN-2c;
	Thu, 27 Nov 2025 10:00:45 +0000
Message-ID: <b36b09c0-95ad-4437-8076-9d8d73a6dbc6@samba.org>
Date: Thu, 27 Nov 2025 11:00:45 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: wire up support for
 sk->sk_prot->uring_cmd() with SOCKET_URING_OP_PASSTHROUGH_FLAG
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn
 <willemb@google.com>, netdev@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251126111931.1788970-1-metze@samba.org>
 <46280bc6-0db9-4526-aa7d-3e1143c33303@kernel.dk>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <46280bc6-0db9-4526-aa7d-3e1143c33303@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 26.11.25 um 23:19 schrieb Jens Axboe:
> On 11/26/25 4:19 AM, Stefan Metzmacher wrote:
>> This will allow network protocols to implement async operations
>> instead of using ioctl() syscalls.
>>
>> By using the high bit there's more than enough room for generic
>> calls to be added, but also more than enough for protocols to
>> implement their own specific opcodes.
>>
>> The IPPROTO_SMBDIRECT socket layer [1] I'm currently working on,
>> will use this in future in order to let Samba use efficient RDMA offload.
> 
> Patch looks fine to me, but I think it needs to be submitted with an
> actual user of it too. If not, then it's just unused infrastructure...
> 
>> [1]
>> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/master-ipproto-smbdirect

Ok, thanks for the feedback, I'll resubmit once I'm ready to use it.

metze


