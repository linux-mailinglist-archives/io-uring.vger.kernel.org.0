Return-Path: <io-uring+bounces-12773-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IG/GJ8DOvWneCAMAu9opvQ
	(envelope-from <io-uring+bounces-12773-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 23:48:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B38F22E216C
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 23:48:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A96E63073432
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 22:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B6438D01A;
	Fri, 20 Mar 2026 22:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="TAqIuahZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TLq23uUv"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40CB364927;
	Fri, 20 Mar 2026 22:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774046680; cv=none; b=IWa9HnkpYINjcACuhd75lEAx5+4pGL2nE05CUtEgUaL3ECfn0/7FlB2K/GAkSi/5Uyzp3H9ssJP8pPCkjhCcmgmBtZKzFrEJPaHG03Hl8kT8S1Mgt0Mzrjkso7cABqcEqVx42v/nFMZsNd8NkJA7/tcWNJ5AqN6enSn395MbRMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774046680; c=relaxed/simple;
	bh=vg8pSQ38Lqb8wRJcqqM5KXzG1WeZYngevfaJKNUMIrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fIyT7flxKs7/m8+Iu+qiZ/ni+1DN29Wh55ZxHQEWi1Do7kykhOBdaAR+0Cyb7Pb8G11fwPBjmeAeduBwohHmzKQtxqtxrOwNntj3VIjVGXcLgejNExwtcHJFNjnFokY8DD1OdErSj/SJr9dQdhhY9VISFxvIRrmu4EQHDa9wI2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=TAqIuahZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TLq23uUv; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1A4071400249;
	Fri, 20 Mar 2026 18:44:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 20 Mar 2026 18:44:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1774046678;
	 x=1774133078; bh=W85qkiBpR9YTAJhgxNufbNVd5e5oDYVfNZv4NIu3lP0=; b=
	TAqIuahZrCZen/ZwwFO2FYekLmgz4/9Zmxkaw0LBa3dUdW67tLsH357ct+mi7ueo
	4rt1CVdAVHXk/Fn8khpLhEbg8JO+y8lMz/js5A7G7B0G3QjR5pzkzmopvHZWlHfZ
	TRHlRKfHXy/tkc5jyUq77XFQXPMZ4l6xYvFuaxbDnmzDbqew4WPZOIDVfSp6XzIG
	C8DDyK+pMnCtclI7zzwo3CCquu5kOPzAX7LGLT3FSpW9F4g9fuclmkKj/jlHJnfV
	SKMv0NiCS1exj3T3x4bazOidFf7/YFOUQkO3uN83/tyqvus2w6QgK1i5zbU3oGUw
	dmUYRgyrzJQ5Y7k+0yfTeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774046678; x=
	1774133078; bh=W85qkiBpR9YTAJhgxNufbNVd5e5oDYVfNZv4NIu3lP0=; b=T
	Lq23uUve4DmDBPbl6wIFU+nsGlR7E/8tXtlpj+W8yqsJBXTnbbhzr7IIJvjLzSvz
	cxF3xVsYsE7fKhqnfSf+wbLH/WBRafrRbx+Apk2srLs9WqSBxnsJaWClOC+mf3IA
	s8h2TERmL+w0RDNualoXn6lKsGr11l0A8AwXqF2CrPMUHubeLe1hZOwy8yxbzFH5
	HdbbAvIF+O23Pfz91m9jJIgJOzLV4yeNI/cJFoUgJH/tc7z4tG4nmIbLl1uXD9j4
	pgO9mIIoy8I8/wm1nfLFn9faM2178yHH7r6Ihun5haUuZhi8N/cQQQbrunmSCeqC
	RWEcyfn3MP43rzfwkDHfQ==
X-ME-Sender: <xms:1c29afxWuFsjdPuwnQohc3p7lbzj9pES69qje8otRqOlhPI-lq8B9w>
    <xme:1c29acMmgHF58yIh-TnNfe-ZabQuoy5nERZSHRAwWtOZmNO5qdWyL-piEMXKGrrz9
    LQ3-3DvyK5mHwGhIvCYemdOIZ1hNK5RDGerp2uVSya5bHoNMTBTkw>
X-ME-Received: <xmr:1c29adnip82OgAcOa8qwaD9UJZh2vyq9C9RMdrHiJqfHJRG6mjtwCBa9XUPD19lkRpsGOUEZ0sw0BPNZnEk2duCIEAVwrHbKSBUl81M-2wlMCd_Bcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefudduudehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeefgeegfeffkeduudelfeehleelhefgffehudejvdfgteevvddtfeeiheef
    lefgvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeelpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtg
    homhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtohephhgt
    hhesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvg
    esghhmrghilhdrtghomhdprhgtphhtthhopegtshgrnhguvghrsehpuhhrvghsthhorhgr
    ghgvrdgtohhmpdhrtghpthhtohepkhhrihhsmhgrnhesshhushgvrdguvgdprhgtphhtth
    hopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    ephhgsihhrthhhvghlmhgvrhesuggunhdrtghomh
X-ME-Proxy: <xmx:1c29aZRC-MX6qFydLfwf7iyDvrNvMTrpKb_7uCWySSBlj_njN32npg>
    <xmx:1c29aUVN_NcQJ4DVzexupHjVCnUyP4qUUsW9uP0kmjfdum3eK2EPBg>
    <xmx:1c29aVLLQC3lgZKb_g_692zoT_Nx1gu3lUbhGpEe_OZPtTPG1Im5Ig>
    <xmx:1c29ac12gHp7pv_JgaVlEMcHtNMQ8knFUs68tdTAvPFTjgnd7c3f7A>
    <xmx:1s29acAqL6XUWDTTQ1mk_e6SEKDeD5Go_t7oj0K35mKh2NyZApsTy3QB>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Mar 2026 18:44:36 -0400 (EDT)
Message-ID: <f8a1808b-4068-49a7-a17d-8dcab1ae9cdf@bsbernd.com>
Date: Fri, 20 Mar 2026 23:44:34 +0100
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
 <d9aae2bf-b81d-42c8-b919-5e64292323e8@bsbernd.com>
 <CAJnrk1bYLwHpZsW85XiyWfM=gXXXS6pHg4=p9fcbDOwpca8UXQ@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1bYLwHpZsW85XiyWfM=gXXXS6pHg4=p9fcbDOwpca8UXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,gmail.com,purestorage.com,suse.de,vger.kernel.org,ddn.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12773-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,bsbernd.com:dkim,bsbernd.com:email,bsbernd.com:mid]
X-Rspamd-Queue-Id: B38F22E216C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 3/20/26 22:58, Joanne Koong wrote:
> On Fri, Mar 20, 2026 at 12:45 PM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>> On 3/20/26 20:20, Joanne Koong wrote:
>>> On Fri, Mar 20, 2026 at 10:16 AM Bernd Schubert <bernd@bsbernd.com> wrote:
>>>>
>>>> On 3/6/26 01:32, Joanne Koong wrote:
>>> Hi Bernd,
>>>
>>>> Hi Joanne,
>>>>
>>>> I'm a bit late, but could we have a design discussion about fuse here?
>>>> From my point of view it would be good if we could have different
>>>> request sizes for the ring buffers. Without kbuf I thought we would just
>>>
>>> Is your motivation for wanting different request sizes for the ring
>>> buffers so that it can optimize the memory costs of the buffers? I
>>> agree that trying to reduce the memory footprint of the buffers is
>>> very important. The main reason I ended up going with the buffer ring
>>> design was for that purpose. When kbuf incremental buffer consumption
>>> is added in the future (I plan to submit it separately once all the
>>> io-uring pieces of the fuse-zero-copy patchset land), this will allow
>>> non-overlapping regions of the individual buffer to be used across
>>> multiple different-sized requests concurrently.
>>
>> That is also fine.
>>
>>>
>>> From my point of view, this is better than allocating variable-sized
>>> buffers upfront because:
>>> a) entries are fully maximized. With variable-sized buffers, the big
>>> buffers would be reserved specifically for payload requests while the
>>> small buffers would be reserved specifically for metadata requests. We
>>> could allocate '# entries' amount of small buffers, but for big
>>> buffers there would be less than '# entries'. If the server needs to
>>> service a lot of concurrent I/O requests, then the ring gets throttled
>>> on the limited number of big buffers available.
>>
>> I would like to see something like 8K, 16K, 32K, 128K.
> 
> My worry is that for I/O heavy workloads with large read/write
> payloads (eg client access patterns reading/writing MBs at a time),
> the limited number of big enough buffers becomes the throttling
> bottleneck.
> 
>>
>>>
>>> b) it best maximizes buffer memory. A request could need a buffer of
>>> any size so with variable-sized buffers, there's extra space in the
>>> buffer that is still being wasted. For example, for large payload
>>> requests, the big buffers would need to be the size of the max payload
>>> size (eg default 1 MB) but a lot of requests will fall under that.
>>> With incremental buffer consumption, only however many bytes used by
>>> the request are reserved in the buffer.
>>
>> Doesn't that cause fragmentation?
> 
> With incremetnal buffer consumption, there's not fragmentation in the
> classical sense (eg scattered unusable holes). The buffer gets
> recycled back into the ring as a whole once all the requests in it
> have completed (tracked by refcounting).
> 
> I think the concern is that if the server is very slow to fulfill
> requests and the workload pattern has it so that slow requests are
> packed into the same buffer as fast requests across all the buffers in
> the queue and that queue has all its buffers saturated, then the next
> buffer is available only once the slow request has completed. We can
> mitigate this by assigning the request to a queue on the nearest numa
> node as a fallback if we detect that case. We could also do the same
> thing to mitigate the variable-sized buffer scenario where there's not
> enough big buffers for the queue, but I think that logic ends up a bit
> more complex.
> 
> I think overall we're able to support both incremental buffer
> consumption + variable-sized buffers if there's a need for it in the
> future where the server would like to choose.
> 
>>
>>>
>>> c) there's no overhead with having to (as you pointed out) keep the
>>> buffers tracked and sorted into per-sized lists. If we wanted to use
>>> variable-sized buffers with kbufs instead of using incremental buffer
>>> consumption, the best way to do that would be to allocate a separate
>>> kbufring to support payload requests vs metadata requests.
>>
>> Yeah, I had thought of multiple kbuf rings, with different sizes.
>>
>>>
>>>> register entries with different sizes, which would then get sorted into
>>>> per size lists. Now with kbuf that will not work anymore and we need
>>>> different kbuf sizes. But then kbuf is not suitable for non-privileged
>>>> users. So in order to support different request sizes one basically has
>>>
>>> Non-privileged fuse servers use kbufs as well. It's only zero-copying
>>> that is not possible for non-privileged servers.
>>
>> Non-privileged cannot pin, at least by default mlock size is 8MB. I was
>> under the impression that kbuf would be always pinned, but I need to
>> read over it again.
> 
> The kbufs get accounted to the user's mlock usage (this happens in
> __io_account_mem()). If the user running the unprivileged server
> doesn't belong to a group that has high enough mlock limits, they'll
> have to use regular fuse over-io-uring buffers instead of kbufs for
> most of their queues.

That is exactly what I mean - in reality  unprivileged servers will not
be able to use kbufs. And there it would be good, if that server could
use unpinned pbufs.


Thanks,
Bernd

