Return-Path: <io-uring+bounces-12771-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uFR+JMejvWkM/wIAu9opvQ
	(envelope-from <io-uring+bounces-12771-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 20:45:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B11E62E04D3
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 20:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5164A303D721
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D7F2F83AE;
	Fri, 20 Mar 2026 19:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="f6oZcx+2";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wqAMW/3M"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A48A34EF16;
	Fri, 20 Mar 2026 19:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774035908; cv=none; b=Dq1wfSvmyJ64elzwLtd2VvVowv68j5t5mSOecjTUujIZyHGDsrPyPFsg1gzljLfGjK4h8FmBvh1JAm9xr2A9c83ecH6B+OzwZJBR+ia6pBQuQ5NwJDbTgUdLxr3u+nc8QViBcx0RxEGibagQtcP8rLy8V+Ap7s67sTLb2eSkwxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774035908; c=relaxed/simple;
	bh=AqBaFIOnfFTMagDMOdbcuH0qnhUjHr0dUHWu4IYd2T0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bIePidQSwu0nxfXhCrEzgY8FL1ZNpSI1ckTfkSEOyx+wcu8aHhhs0QMkee6JF5Cm4pL8C+6p1RCrgH4fAEvqTH2CSgmKOzFmDIoO69AItewDz7eVGlxXvBC+HQWJ+xrcNusxmRop1eIPZSRq4ZLzq2TSfxGhcnSTYdbSIDLotZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=f6oZcx+2; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wqAMW/3M; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 9887A140013E;
	Fri, 20 Mar 2026 15:45:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Fri, 20 Mar 2026 15:45:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1774035905;
	 x=1774122305; bh=+sJ1Ok2AjKWO161JBMWf8rF55g3lV1mXUWLG8hILYMo=; b=
	f6oZcx+2YOrfk/3LR4J69w175jT0k1guXsNvagfFL1D8hIiyrojQkl4SXAImuTa8
	uQF8tnWsKFYvToJlR606Gy+LX/HAAkkMdTDsyqYk/JsTvADfTgKdFWSgeLtmjVdy
	QzZ9YeCdkXM3xQaLViGQJ1tKP5mJcQ8m1dbS13AKrth5g4IOaMzqro7IXVe2u5/U
	NpYQ9OZjXpwNsIV4Smocm3nYadQ/wjVTpj2EfgjBOm5SHTBw7dCIpGnQwHVXMEzu
	GdZvThh9sZhtrN+890dvzLkf6v6/7REDAxMcIKhvtrnEiftdFr1FOIf+Utwtd4LS
	RqSQlGE03Ad2qTOR6Uz+Tg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774035905; x=
	1774122305; bh=+sJ1Ok2AjKWO161JBMWf8rF55g3lV1mXUWLG8hILYMo=; b=w
	qAMW/3M17N1eh/haCeD8Zp2VH+YxA+Z5wOOsQJwxFmOHmHGTxzhF2Yp9+GF2nq98
	z2J5BWaSsH9K/pOaxqr/VXxZaXnnl8/wqMKMJFrzD7eRJkktJ19OtZwaGboOzChy
	1NFnAF4ubFtzDUoZi1eh6qzYUwHX1ZBZF/0+tQLl/AxXhM4eawyuXLoiHXcmEAkO
	ceXWrpU4YLsH8Vgk0w06CaxeguLcWbJ3ngySRTe63DZenGb16Ha12SIypgWmjRAX
	mSQ5Nb3jV+aoKjsY5GOnLdqEqfhi7h7Jn2E/+R51Wou3bS8rQeyRr81QrRw2xuRJ
	cPVbZ5vH+DB1aj+9fSBDg==
X-ME-Sender: <xms:waO9acgC5IvdDU_wFosIrw2Dt31R3QjrF0AX-EJ1NH43fPV9Iz9ULg>
    <xme:waO9aZ-UgXhs8CABBjqbPyQKGGRl2ZbY3kRCRGm9j_ZN2GU4iaj5MzaFxGUOuBEIO
    uSHCliYBb1NtCxzrnLtW1j1rrqD2cQBZIcqNvIp1fadF3XDCzQ>
X-ME-Received: <xmr:waO9aYVRxyC11O6OlEBZ2-QiRHM83hk0rw5i09rwk-5jLe6qNluHw2YO8jjXEI5LGhO4hEiAPTkvOCcpvTZN85jhxuXtGG1Clgx4MBbx-NhNFQT5QA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefuddtjeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeetiefgkefgteegledvjeeiueehfffhjeekjefgheejjeejgeeuudehgfel
    geevtdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtghomhenuc
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
X-ME-Proxy: <xmx:waO9adDpWJaGT6U6ubfypcghHmVtExdNzmgp5HxQ-MwSgZ3ClD2G9Q>
    <xmx:waO9adFps5qiarLbzW4KYR9LsvLYyKf5jJHx9ZM85nsp5ZbTt58WVw>
    <xmx:waO9ae667VFtyecYf-w1FWjTmSivCwzxYVTTmRCgTcAdeySMoDXsjw>
    <xmx:waO9aTmkOKMmsi-E2EvT-jpSYpZKiK0Z85stShU-Ku24hQNccZE7eA>
    <xmx:waO9aeyGHvAQ5K0yR4Ik_VsteCPpHZX2OU2dVonv4jFyT49-emJyfDC0>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Mar 2026 15:45:03 -0400 (EDT)
Message-ID: <d9aae2bf-b81d-42c8-b919-5e64292323e8@bsbernd.com>
Date: Fri, 20 Mar 2026 20:45:01 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] io_uring: add kernel-managed buffer rings
To: Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, hch@infradead.org, asml.silence@gmail.com,
 csander@purestorage.com, krisman@suse.de, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Horst Birthelmer <hbirthelmer@ddn.com>
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
 <59dcb27f-875c-4a2a-82dc-63b832f8eb1e@bsbernd.com>
 <CAJnrk1YLtQF=SF-GoG4irKYzzePNewNgyTeU7VLvUN6Ub_NFVw@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1YLtQF=SF-GoG4irKYzzePNewNgyTeU7VLvUN6Ub_NFVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,gmail.com,purestorage.com,suse.de,vger.kernel.org,ddn.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12771-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,messagingengine.com:dkim,bsbernd.com:dkim,bsbernd.com:email,bsbernd.com:mid]
X-Rspamd-Queue-Id: B11E62E04D3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 3/20/26 20:20, Joanne Koong wrote:
> On Fri, Mar 20, 2026 at 10:16 AM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>> On 3/6/26 01:32, Joanne Koong wrote:
>>> Currently, io_uring buffer rings require the application to allocate and
>>> manage the backing buffers. This series introduces buffer rings where the
>>> kernel allocates and manages the buffers on behalf of the application. From
>>> the uapi side, this goes through the pbuf ring interface, through the
>>> IOU_PBUF_RING_KERNEL_MANAGED flag.
>>>
>>> There was a long discussion with Pavel on v1 [1] regarding the design. The
>>> alternatives were to have the buffers allocated and registered through a
>>> memory region or through the registered buffers interface and have fuse
>>> implement ring buffer logic internally outside of io-uring. However, because
>>> the buffers need to be contiguous for DMA and some high-performance fuse
>>> servers may need non-fuse io-uring requests to use the buffer ring directly,
>>> v3 keeps the design.
>>>
>>> This is split out from the fuse-over-io_uring series in [2], which needs the
>>> kernel to own and manage buffers shared between the fuse server and the
>>> kernel. The link to the fuse tree that uses the commits in this series is in
>>> [3].
>>>
>>> This series is on top of the for-7.1/io_uring branch in Jens' io-uring
>>> tree (commit ee1d7dc33990). The corresponding liburing changes are in [4] and
>>> will be submitted after the changes in this patchset have landed.
>>>
>>> Thanks,
>>> Joanne
>>>
>>> [1] https://lore.kernel.org/linux-fsdevel/20260210002852.1394504-1-joannelkoong@gmail.com/T/#t
>>> [2] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/
>>> [3] https://github.com/joannekoong/linux/commits/fuse_zero_copy_for_v3/
>>> [4] https://github.com/joannekoong/liburing/commits/pbuf_kernel_managed/
>>
> 
> Hi Bernd,
> 
>> Hi Joanne,
>>
>> I'm a bit late, but could we have a design discussion about fuse here?
>> From my point of view it would be good if we could have different
>> request sizes for the ring buffers. Without kbuf I thought we would just
> 
> Is your motivation for wanting different request sizes for the ring
> buffers so that it can optimize the memory costs of the buffers? I
> agree that trying to reduce the memory footprint of the buffers is
> very important. The main reason I ended up going with the buffer ring
> design was for that purpose. When kbuf incremental buffer consumption
> is added in the future (I plan to submit it separately once all the
> io-uring pieces of the fuse-zero-copy patchset land), this will allow
> non-overlapping regions of the individual buffer to be used across
> multiple different-sized requests concurrently.

That is also fine.

> 
> From my point of view, this is better than allocating variable-sized
> buffers upfront because:
> a) entries are fully maximized. With variable-sized buffers, the big
> buffers would be reserved specifically for payload requests while the
> small buffers would be reserved specifically for metadata requests. We
> could allocate '# entries' amount of small buffers, but for big
> buffers there would be less than '# entries'. If the server needs to
> service a lot of concurrent I/O requests, then the ring gets throttled
> on the limited number of big buffers available.

I would like to see something like 8K, 16K, 32K, 128K.

> 
> b) it best maximizes buffer memory. A request could need a buffer of
> any size so with variable-sized buffers, there's extra space in the
> buffer that is still being wasted. For example, for large payload
> requests, the big buffers would need to be the size of the max payload
> size (eg default 1 MB) but a lot of requests will fall under that.
> With incremental buffer consumption, only however many bytes used by
> the request are reserved in the buffer.

Doesn't that cause fragmentation?

> 
> c) there's no overhead with having to (as you pointed out) keep the
> buffers tracked and sorted into per-sized lists. If we wanted to use
> variable-sized buffers with kbufs instead of using incremental buffer
> consumption, the best way to do that would be to allocate a separate
> kbufring to support payload requests vs metadata requests.

Yeah, I had thought of multiple kbuf rings, with different sizes.

> 
>> register entries with different sizes, which would then get sorted into
>> per size lists. Now with kbuf that will not work anymore and we need
>> different kbuf sizes. But then kbuf is not suitable for non-privileged
>> users. So in order to support different request sizes one basically has
> 
> Non-privileged fuse servers use kbufs as well. It's only zero-copying
> that is not possible for non-privileged servers.

Non-privileged cannot pin, at least by default mlock size is 8MB. I was
under the impression that kbuf would be always pinned, but I need to
read over it again.

> 
>> to implement things two times - not ideal. Couldn't we have pbuf for
>> non-privileged users and basically depcrecate the existing fuse io-uring
> 
> I don't think this is necessary because kbufs works for both
> non-privileged and privileged servers. For how the buffer gets used by
> the server/kernel, pbufs are not an option here because the kernel has
> to be the one to recycle back the buffer (since it needs to read /
> copy data the server returns back in the buffer).

I was thinking to set a flag or take ref count and to disallow pbuf
destruction.

> 
>> buffer API? In the sense that it needs to be further supported for some
>> time, but won't get any new feature. Different buffer sizes would then
>> only be supported through kbuf/pbuf?
> 
> I hope I understood your questions correctly, but if I misread
> anything, please let me know. I am going to be updating and submitting
> the fuse patches next week - the main update will be changing the
> headers to go through a registered memory region (which I only
> realized existed after the discussion with Pavel in v1) instead of as
> a registered buffer, as that will allow us to avoid the per I/O lookup
> overhead and drop the patch for the
> "io_uring_fixed_index_get()/io_uring_fixed_index_put()" refcount dance
> altogether.

I will try to review ASAP when you submit.


Thanks,
Bernd



