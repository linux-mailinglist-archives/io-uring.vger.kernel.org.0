Return-Path: <io-uring+bounces-12763-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6EwGOPuCvWk4+gIAu9opvQ
	(envelope-from <io-uring+bounces-12763-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 18:25:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 09F982DE92C
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 18:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1F63E303999C
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 17:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1653CEB97;
	Fri, 20 Mar 2026 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="R4Bn19da";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vA00O2m2"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6633D3007;
	Fri, 20 Mar 2026 17:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774026994; cv=none; b=ryAWGmeAkqljjpqvgfV2hN6nitfrXbrX3JEhZueIOTigdwdEwl/+ZfSFCD/wBpwFOa7I2U8mxOkFHS0l04J3f3pdw16RHOulBiU12iFx706nwUfq+ARmn7F7fYcgd3Mr5yDflp9+G/RD7wzMkOel4kh7DM5pB2JZbqoojMBemlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774026994; c=relaxed/simple;
	bh=9pDpX980kmJChYNxaErFMXNJfPagFU9rbyoNCCbZzMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CDbOcxs9XCZW+pJolWxvrSQW71fe2CsTUmAV1Uo5wnHj+AdrVvDsc244hMs4UdtYnJ46xvT72atcKH6y4TLqaAWZOmRmvWWAEPTrtb3XqWzzh44mFCejTDryGG0UBzNw6iVQQTobdoND5IB2hkiv4hX2/2T0nTjb9Y3bBnYBQh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=R4Bn19da; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vA00O2m2; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 092C8EC010C;
	Fri, 20 Mar 2026 13:16:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 20 Mar 2026 13:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1774026990;
	 x=1774113390; bh=iBVwy6wPmsXSl0bKdKs+qYpsQMMlUcTaeWnEjxukZ78=; b=
	R4Bn19daDjTAwk6MXKmhl3Zv/BIOuABb8i4sGPtqJCM0YOOa36rdpb9SMQfv37Xg
	k+3qYbz53SsnQ7FrUSRIloZtsOVOlaMtKv27TTBkeEl48OnIgKoF/R1typo6tnK3
	r4uLG3/BRb22oi55CHhheyBy9ZUUXf1N0/0eiUCMGuDRZbzmgcfxq9rTBZpiB68D
	4gZITBIhoPVof9FCjbGCykOpOxka/YqDV6ojnkhzms8mylLNbe+RzsX3xR+cXYCk
	9Adt8yURpwDkqlgfwnn9p/EndJ/+eLHOiyWJHYiYcVOv/gXV0Ux/4MmW4V5oGExa
	fstb+2K4+Eoom0rKeKB/UA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774026990; x=
	1774113390; bh=iBVwy6wPmsXSl0bKdKs+qYpsQMMlUcTaeWnEjxukZ78=; b=v
	A00O2m2gjUEMYF4Eo7Ax6wBA/IDwHZcSs6rMXD9H5H7mF5wk1dR/hiUI3jMsKnM0
	ufSVSCG4lQomPiRp7S5Wvlt8ffpdzt/jyApcl/7+z21sfvUaoVVCkvAQ/JwEKV1F
	ix/8eWdsJzdWup2E6egWSar5rBft2KkwntNOA9RSxzMGcEZyE55OJdf/tL9oa/WW
	zlsORbQd0RsPQfhXL2tD3nFXlrmlCQvtNbxIN86i2kYnB8r5tUhdadwhVMA+kbgu
	nIV6CJGIyuV6B9YAlCw2hh0dGk/EiqyrBFxYJpf74fvTJHuuECT3aCMZoEtVB7J+
	f7nq0ZdEtq/pBSjkivz8g==
X-ME-Sender: <xms:7YC9aUcEVFfvE39v7gkAMjWRgMLFe3rgQga02Ld-Lrq5fxXYT6zprA>
    <xme:7YC9abJRnjumRU9ruLdq7gfYXwseqipoOT6MysmT9B2jv_CJu2MM2RnHDTQDyWNQJ
    hnYTEq2e0lXK8QUH8K2OzQgTW3_x5zXNJ8QpmYcZKt2dRTgllJF>
X-ME-Received: <xmr:7YC9aZzkZs2xE8XKA9ZsoHMRPx8hR2o1X3SsJ9VQyQy1qAXFvtVFDM0Kg6DtU9P6xbajkIPfqPXPnec4HxEdZ5o3_zuSc7_O2pMeY_FinadI96P8gA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefuddtgeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpedtgefhgfeuuddvueeuuddtudfhveetieeihfdtvdeufffhvefffeeiueeh
    udekvdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtghomhenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgu
    segsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgt
    phhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtohephhgthhesihhnfh
    hrrgguvggrugdrohhrghdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghi
    lhdrtghomhdprhgtphhtthhopegtshgrnhguvghrsehpuhhrvghsthhorhgrghgvrdgtoh
    hmpdhrtghpthhtohepkhhrihhsmhgrnhesshhushgvrdguvgdprhgtphhtthhopehlihhn
    uhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepih
    hoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohephhgsihhr
    thhhvghlmhgvrhesuggunhdrtghomh
X-ME-Proxy: <xmx:7YC9aZs0pf9YIZr_zFIj64h1xEDGOmH407pxGIZJFVIiMQDmZleB2g>
    <xmx:7YC9aUCkhfjsJb-7XIsJdb9f3rKvAmZI6_qqjZT0S9dNE9hel-YMIg>
    <xmx:7YC9aTFWREVj6Y1EQb3ZNfY5Xko9MOQ0qz8OH1f9L2HtEnkAiXNOCw>
    <xmx:7YC9acDxWkoQ40d992VHfcVLY7xpel_bidEqdn7tOki5Dq1F0FoqMA>
    <xmx:7oC9aUf385BGHaNGkCyBaT6HFHLE2S_hzuxrp9KKt23pgq-fNeq0bAZY>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Mar 2026 13:16:27 -0400 (EDT)
Message-ID: <59dcb27f-875c-4a2a-82dc-63b832f8eb1e@bsbernd.com>
Date: Fri, 20 Mar 2026 18:16:25 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] io_uring: add kernel-managed buffer rings
To: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk
Cc: hch@infradead.org, asml.silence@gmail.com, csander@purestorage.com,
 krisman@suse.de, linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Horst Birthelmer <hbirthelmer@ddn.com>
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20260306003224.3620942-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,purestorage.com,suse.de,vger.kernel.org,ddn.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12763-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.991];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,bsbernd.com:dkim,bsbernd.com:mid]
X-Rspamd-Queue-Id: 09F982DE92C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/6/26 01:32, Joanne Koong wrote:
> Currently, io_uring buffer rings require the application to allocate and
> manage the backing buffers. This series introduces buffer rings where the
> kernel allocates and manages the buffers on behalf of the application. From
> the uapi side, this goes through the pbuf ring interface, through the
> IOU_PBUF_RING_KERNEL_MANAGED flag.
> 
> There was a long discussion with Pavel on v1 [1] regarding the design. The
> alternatives were to have the buffers allocated and registered through a
> memory region or through the registered buffers interface and have fuse
> implement ring buffer logic internally outside of io-uring. However, because
> the buffers need to be contiguous for DMA and some high-performance fuse
> servers may need non-fuse io-uring requests to use the buffer ring directly,
> v3 keeps the design.
> 
> This is split out from the fuse-over-io_uring series in [2], which needs the
> kernel to own and manage buffers shared between the fuse server and the
> kernel. The link to the fuse tree that uses the commits in this series is in
> [3].
> 
> This series is on top of the for-7.1/io_uring branch in Jens' io-uring
> tree (commit ee1d7dc33990). The corresponding liburing changes are in [4] and
> will be submitted after the changes in this patchset have landed.
> 
> Thanks,
> Joanne
> 
> [1] https://lore.kernel.org/linux-fsdevel/20260210002852.1394504-1-joannelkoong@gmail.com/T/#t
> [2] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/
> [3] https://github.com/joannekoong/linux/commits/fuse_zero_copy_for_v3/
> [4] https://github.com/joannekoong/liburing/commits/pbuf_kernel_managed/

Hi Joanne,

I'm a bit late, but could we have a design discussion about fuse here?
From my point of view it would be good if we could have different
request sizes for the ring buffers. Without kbuf I thought we would just
register entries with different sizes, which would then get sorted into
per size lists. Now with kbuf that will not work anymore and we need
different kbuf sizes. But then kbuf is not suitable for non-privileged
users. So in order to support different request sizes one basically has
to implement things two times - not ideal. Couldn't we have pbuf for
non-privileged users and basically depcrecate the existing fuse io-uring
buffer API? In the sense that it needs to be further supported for some
time, but won't get any new feature. Different buffer sizes would then
only be supported through kbuf/pbuf?


Thanks,
Bernd

