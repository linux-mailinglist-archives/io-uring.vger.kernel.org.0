Return-Path: <io-uring+bounces-12042-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iAwbFEJFgmlHRQMAu9opvQ
	(envelope-from <io-uring+bounces-12042-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 19:58:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C57DDFB2
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 19:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BBFAC30160D8
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 18:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2509831A542;
	Tue,  3 Feb 2026 18:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="DNddKSWV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QYGBnmej"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B289426ED3D;
	Tue,  3 Feb 2026 18:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770144970; cv=none; b=prr6nIObV931hv5me+vyXUr70joAVZfCzjc1tPGKlcbNljnaY+M9Mbdv7sNQ00F1LwkypTeo90YaGtrTrZqmagFPP6B9BePdomNwTm5DdvYB54Vvlb9+6RMTP5phTINmx8unJqdD0ayMyidEf+0gVP9LWg+P9kc0uj/qJ36CIcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770144970; c=relaxed/simple;
	bh=gdHRDhDYRqqbYHhtLoPSN0qxy9R4GbekIJs2bxp/m/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B5/+QsZB3nmLpxLcztKSor936iTk33aC8hbO13Uf8Dn2EuQN8mTqVCvJ7S+6jZX+3qkQ9bznOFviLlepH/rthrQztfBKqKuh2I7XC5Xq5RqeUvEfRAsbd5aR9sdBX1ky/hPtpCjGdPKS+hmT3JdHEbQpPu7HFJ1gRaJGr/QwYpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=DNddKSWV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QYGBnmej; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id BA5D91D0010D;
	Tue,  3 Feb 2026 13:56:07 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 03 Feb 2026 13:56:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1770144967;
	 x=1770231367; bh=Ze+1oYV3o66rSkKlk/cFc6CC1VrAmL3qxvxVWwUI8rA=; b=
	DNddKSWVTNuSzlHNPwUiQ7LW6sPAHdx7DzSIz5Lg+GEBuvriUSvj6Cd++oLlXRDa
	tHe+R12LIzOA4I5mCFOVrkufhFxJTTuaPkO2eIGbycQL+/FIs1Tm6CzDvtvnw57N
	CXRqvJIl9qkwFWcV4fkrEwAH3dDT9YX/eJEnwhfurgjyOTu1NKnN4wwz7Fvyxq3q
	xATDQSza5jbnSdF+ZjglDWlz9fNR8Qi5NVr2T8Ny5EOUeSyKfbez323O/3wZt+2K
	GR2TH/AoSKYV6GWtj1eMjB2/srrsSE27SoD/Y3fV8oDjAv09iPDlQ0xWYtRXKV4y
	fMYZ4tJuD5ImfWXRAhq8AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770144967; x=
	1770231367; bh=Ze+1oYV3o66rSkKlk/cFc6CC1VrAmL3qxvxVWwUI8rA=; b=Q
	YGBnmejXK2wPHsmQ23OlBTpS7XUXyAyjt2A9IPPWu+RfjODEgFq7wXT6Z9nPLFPM
	ERDsBmABK4ibaYFht/TC5L0QOobNscKKlX/m+MWEXbMBwdqW9VeGZs66TovePA0d
	JWKSYnHxCOmm+08+DCGPcFeAsTXxdq+llw1jbhJsNB3/a7PKqMq78Xhj5Jq8n3VT
	RHy89bG0fyTZQrrzjry/EC3VDfMpTUCpHXDTLW6xu/ZeIgnnKUQ8PVBXhLeHyMgS
	qDXXkijP1SGVVI3tjbtxPQGkm+JPC6yWS4a2bnfLoqjtTaHqohzm5fI3yWch63D8
	+lwuBurYscKmZqcjHetrQ==
X-ME-Sender: <xms:xkSCaWfsKZoXqH7rrOQcgY9XN-pVMnhwpFM3MbBDqu5w8tqrCZ5K3A>
    <xme:xkSCaee3qvErcMcTugn0TNydeM8pUnAK1x5zuEian3pgCwRmbhqMvVXm6l8B6ul_5
    oGBlcbBRByrQViv0rxV2E09SvuEMLGcDjwyJwPZQW8A7j4tdeYe>
X-ME-Received: <xmr:xkSCaQ0bLBkQ-jKTK-6F97s-JRAivZ0ufhjb_5lL8gczJNrHfDLkVNx_o6xvbhU-tolLT-nWoep0HqEAdrJU4EA6bJJIxZQB8sNESqxk16EXMKEZ2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukedtkeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeehhfejueejleehtdehteefvdfgtdelffeuudejhfehgedufedvhfehueev
    udeugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeduuddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrd
    gtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopehm
    ihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtohepsghstghhuhgsvghrthesug
    gunhdrtghomhdprhgtphhtthhopegtshgrnhguvghrsehpuhhrvghsthhorhgrghgvrdgt
    ohhmpdhrtghpthhtohepkhhrihhsmhgrnhesshhushgvrdguvgdprhgtphhtthhopehioh
    dquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrshhmlhdr
    shhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopeigihgrohgsihhnghdrlh
    hisehsrghmshhunhhgrdgtohhm
X-ME-Proxy: <xmx:xkSCaW8F9oS39mlg9BL53H9hvCQEmT_IOgiFdf0r_cZp3ASshV-2XA>
    <xmx:xkSCaV4lwbk1U2gGNNfUzgAGGves8sRKbUZORihKPgRUk5IiIBRG6w>
    <xmx:xkSCaevHqFKtHJHxGlpVxEK-L4h0yuMJp6RANyUWnOlZQnx9khEItQ>
    <xmx:xkSCaX16b7QzlHdOxhggDmKasuifa-SEHDMk1A14bOrK_UBLLz95NA>
    <xmx:x0SCaXwjh4wHckM0JXWG6iGqLRbJwLFvRIs9ct14nqLriwp6LJkUjK1O>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Feb 2026 13:56:05 -0500 (EST)
Message-ID: <4b609081-89e9-41b7-bea2-b3fa4e8b9e3e@bsbernd.com>
Date: Tue, 3 Feb 2026 19:56:04 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 25/25] docs: fuse: add io-uring bufring and zero-copy
 documentation
To: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk, miklos@szeredi.hu
Cc: bschubert@ddn.com, csander@purestorage.com, krisman@suse.de,
 io-uring@vger.kernel.org, asml.silence@gmail.com, xiaobing.li@samsung.com,
 safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-26-joannelkoong@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20260116233044.1532965-26-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm1,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[ddn.com,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,szeredi.hu];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12042-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bsbernd.com:mid,bsbernd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,messagingengine.com:dkim]
X-Rspamd-Queue-Id: A7C57DDFB2
X-Rspamd-Action: no action



On 1/17/26 00:30, Joanne Koong wrote:
> Add documentation for fuse over io-uring usage of kernel-managed
> bufrings and zero-copy.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  .../filesystems/fuse/fuse-io-uring.rst        | 59 ++++++++++++++++++-
>  1 file changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/fuse/fuse-io-uring.rst b/Documentation/filesystems/fuse/fuse-io-uring.rst
> index d73dd0dbd238..11c244b63d25 100644
> --- a/Documentation/filesystems/fuse/fuse-io-uring.rst
> +++ b/Documentation/filesystems/fuse/fuse-io-uring.rst
> @@ -95,5 +95,62 @@ Sending requests with CQEs
>   |    <fuse_unlink()                         |
>   |  <sys_unlink()                            |
>  
> +Kernel-managed buffer rings
> +===========================
>  
> -
> +Kernel-managed buffer rings have two main advantages:
> +
> +* eliminates the overhead of pinning/unpinning user pages and translating
> +  virtual addresses for every server-kernel interaction
> +* reduces buffer memory allocation requirements
> +
> +In order to use buffer rings, the server must preregister the following:
> +
> +* a fixed buffer at index 0. This is where the headers will reside
> +* a kernel-managed buffer ring. This is where the payload will reside

Would you mind to add the actual liburing call for this? I think it
would be helpful for anyone who wants to implement it.

> +
> +At a high-level, this is how fuse uses buffer rings:
> +
> +* The server registers a kernel-managed buffer ring. In the kernel this
> +  allocates the pages needed for the buffers and vmaps them. The server
> +  obtains the virtual address for the buffers through an mmap call on the ring
> +  fd.
> +* When there is a request from a client, fuse will select a buffer from the
> +  ring if there is any payload that needs to be copied, copy over the payload
> +  to the selected buffer, and copy over the headers to the fixed buffer at
> +  index 0, at the buffer id that corresponds to the server (which the server
> +  needs to specify through sqe->buf_index).
> +* The server obtains a cqe representing the request. The cqe flag will have
> +  IORING_CQE_F_BUFFER set if a selected buffer was used for the payload. The
> +  buffer id is stashed in cqe->flags (through IORING_CQE_BUFFER_SHIFT). The
> +  server can directly access the payload by using that buffer id to calculate
> +  the offset into the virtual address obtained for the buffers.
> +* The server processes the request and then sends a
> +  FUSE_URING_CMD_COMMIT_AND_FETCH sqe with the reply.
> +* When the kernel handles the sqe, it will process the reply and if there is a
> +  next request, it will reuse the same selected buffer for the request. If
> +  there is no next request, it will recycle the buffer back to the ring.
> +
> +Zero-copy
> +=========
> +
> +Fuse io-uring zero-copy allows the server to directly read from / write to the
> +client's pages and bypass any intermediary buffer copies. This is only allowed
> +on privileged servers.
> +
> +In order to use zero-copy, the server must pregister the following:
> +
> +* a sparse buffer for every entry in the queue. This is where the client's
> +  pages will reside
> +* a fixed buffer at index queue_depth (tailing the sparse buffer).
> +  This is where the headers will reside
> +* a kernel-managed buffer ring. This is where any non-zero-copied payload (eg
> +  out headers) will reside
> +
> +When the client issues a read/write, fuse stores the client's underlying pages
> +in the sparse buffer entry corresponding to the ent in the queue. The server
> +can then issue reads/writes on these pages through io_uring rw operations.
> +Please note that the server is not able to directly access these pages, it
> +must go through the io-uring interface to read/write to them. The pages are
> +unregistered once the server replies to the request. Non-zero-copyable
> +payload (if needed) is placed in a buffer from the kernel-managed buffer ring.


