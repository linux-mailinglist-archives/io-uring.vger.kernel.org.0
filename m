Return-Path: <io-uring+bounces-11958-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0M2WIBZFeWlCwQEAu9opvQ
	(envelope-from <io-uring+bounces-11958-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 00:07:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C71DF9B4FE
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 00:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA8D33014C20
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 23:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7382EAD10;
	Tue, 27 Jan 2026 23:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="V7H7ej7f";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bg2itZhn"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EF32C15BA;
	Tue, 27 Jan 2026 23:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769555196; cv=none; b=EaNZzqG0x1D9pdBN19nf2FxxLv4aGMPD6XMe3AoCVZ8Je46EENW8442/4QYViHItAur89ahIPZziqUXZ6kO4ZPxJsWediYpLU4m+koV87X+wgiKJkHoAb30GJcRDGUJBf+nX5InW/HpUocUs/LrEhPnikTwQQpnrBk7KHKrkN2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769555196; c=relaxed/simple;
	bh=PVLICvQzmBSJ4qNAVGDt9PtD2+/lIjW83F2xNZYYhJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JPRtPinW8imsz/bi+QbtK4gCWnXiqWZKAKmplEZXwuuz0vuG8zqSSg9phDI3el6u7LKxEkQXdQUCHbWT8nYARMfOIbnYX+gtTJi4x3dPeiotbTso/pYmTjYqyEO7vZc0GpMtg3CN0oeJdN1fIrbJXSYtTxdt+3zYok2W5vBwsAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=V7H7ej7f; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bg2itZhn; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 9B7BBEC0214;
	Tue, 27 Jan 2026 18:06:33 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Tue, 27 Jan 2026 18:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1769555193;
	 x=1769641593; bh=RktKN6tWP9iLo2VeltpCT+RlApqVZgdGMIIE0pDSG9s=; b=
	V7H7ej7f1Qkwlm6PIvqHC6DXCqvkE4TFPwEHzQAxG/vtAAuvHxaqTwiKM5vNYc4A
	C7u6/OX6IP9++8cHY2vpYXCJ9RjV0yYBUfnyt/YcdgzutDoMiIPh1+045xmgqxTi
	nfF0Orwf2nl7NAO2s99Oti4z4UzIeBvl9GZ/YnMqicZmuSNkZC91HPKgreab29s5
	+t3v3k1M71ndOqTuVGGGQH8XY+1AlrVylClyG2m11T57BwMyaMJae6GLXN5ud9fs
	a+oN2dQs/0EfmA0YyLwogJNR+vOhU4brcbi+GDv2/hICSoliRxkEe6c3OIMjml4m
	TLg7GtnQjWQhl53Gn+u2yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1769555193; x=
	1769641593; bh=RktKN6tWP9iLo2VeltpCT+RlApqVZgdGMIIE0pDSG9s=; b=b
	g2itZhnVDlgLV3Nm0iOporcP8bFE7Fe1Kn1ebqZc7n2rAdMtOr6cK9vMJOjNN1k2
	elDZf+/RBXSB0cg7S7OLoClR7yT/3mkx1fLBTvAUI1tCNXYNg79rzhJU+t/S7Vu1
	X7+zLUeTa3CZyfY8LesilkKhOpYX8yW86UdUIGblPaUVjI3tOUs3mZgNq7dkodIG
	qYreBCz4CSxlBLWF6RvgpQKN2CYIPAJMUk/64pye3I+FoxPx5ZfyLuiq5yPmPLvn
	Ln1rmZUsoHDZ+VUyMIF9lzh7ZLXejhCsrUvRnpk08ALT6d/k4JapRDJ94OjdMDVF
	Nz27vjytQwb74As18iOPw==
X-ME-Sender: <xms:-UR5adAzKPRpERAuKua7R8FUh4r-jkwHZ416qixAz_zUkctiWMfIUw>
    <xme:-UR5aQel90SU4QwXiZpIgo-P-HV6vOxb5SovE4KpOC-tC4FH7bl8Ywy_XpQn2_a8s
    MM72qCLdtHtjeDx_8ZzzV7aO1nNiaoPhtPF58r2cziQwsLlOt0a>
X-ME-Received: <xmr:-UR5ac29qZG1PPft4j-vSnkYa2Wtb42aSNF_47cKn2JLDUe_mLyntARRp-Cem7qbY4WmJrbcfIdQWt7woVB7w1CwjICpq-23tgpTmb1A3M2XMmTpgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduiedujeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeefgeegfeffkeduudelfeehleelhefgffehudejvdfgteevvddtfeeiheef
    lefgvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeelpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtg
    homhdprhgtphhtthhopegsshgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtohep
    mhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopegrgigsohgvsehkvghrnh
    gvlhdrughkpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhm
    pdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheptghsrghnuggvrhesphhurhgvshhtohhrrghgvgdrtghomhdprhgtphhtthho
    peigihgrohgsihhnghdrlhhisehsrghmshhunhhgrdgtohhmpdhrtghpthhtoheplhhinh
    hugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:-UR5aXi0aVYGq24pnJGrpPKsIeZMhCVlQMiAyaTEHyQeA1nve-NsZQ>
    <xmx:-UR5aVmjzPofRDOwtaVyzDtKCbdQDqMqa0fInqZagYbZy7JW9Tz8PA>
    <xmx:-UR5adZpu9_autJyzLDTLzIYhYLkocwFDYornSpyMkfrhhD-C-ZsYA>
    <xmx:-UR5aQGN0Dz-QTinS52RnYiqp1fZ78q5-04fE4jPpcQMivFD6FQlXA>
    <xmx:-UR5aXXkclo_Y45wxmxf98Y38jxN3QVoDcf9LNJ6s8GhTE-z1HWar5Qb>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Jan 2026 18:06:32 -0500 (EST)
Message-ID: <5c435071-cc62-45be-a954-8e7c217061cf@bsbernd.com>
Date: Wed, 28 Jan 2026 00:06:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/25] fuse: refactor io-uring header copying to ring
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bschubert@ddn.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "asml.silence@gmail.com" <asml.silence@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "csander@purestorage.com" <csander@purestorage.com>,
 "xiaobing.li@samsung.com" <xiaobing.li@samsung.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-15-joannelkoong@gmail.com>
 <a27b24fe-659e-4aa1-830c-7096a3c293b8@ddn.com>
 <CAJnrk1ZC0x14Oub=_Ah0zdEo6Rhy7Q5c4DkY-bNbeae+Tdb52Q@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1ZC0x14Oub=_Ah0zdEo6Rhy7Q5c4DkY-bNbeae+Tdb52Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm1,messagingengine.com:s=fm2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[szeredi.hu,kernel.dk,gmail.com,vger.kernel.org,purestorage.com,samsung.com];
	TAGGED_FROM(0.00)[bounces-11958-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,ddn.com];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,bsbernd.com:mid,bsbernd.com:dkim]
X-Rspamd-Queue-Id: C71DF9B4FE
X-Rspamd-Action: no action



On 1/16/26 23:33, Joanne Koong wrote:
> On Sun, Jan 11, 2026 at 8:04 AM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> On 12/23/25 01:35, Joanne Koong wrote:
>>> Move header copying to ring logic into a new copy_header_to_ring()
>>> function. This consolidates error handling.
>>>
>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>> ---
>>>  fs/fuse/dev_uring.c | 39 +++++++++++++++++++++------------------
>>>  1 file changed, 21 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>>> index 1efee4391af5..7962a9876031 100644
>>> --- a/fs/fuse/dev_uring.c
>>> +++ b/fs/fuse/dev_uring.c
>>> @@ -575,6 +575,18 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
>>>       return err;
>>>  }
>>>
>>> +static __always_inline int copy_header_to_ring(void __user *ring,
>>> +                                            const void *header,
>>> +                                            size_t header_size)
>>
>> Minor nit: The only part I don't like too much is the __always_inline. I
>> had at least two times a debug issue where I didn't get much out of the
>> trace and then used for fuse.ko
> 
> Unfortunately the __always_inline here is necessary else builds with
> CONFIG_HARDENED_USERCOPY will complain because there's no metadata
> visibility into the header object which means __builtin_object_size()
> can't correctly determine the header size.

Oh I see, thanks for pointing to CONFIG_HARDENED_USERCOPY.


Thanks,
Bernd

