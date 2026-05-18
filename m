Return-Path: <io-uring+bounces-13404-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eAepLAsqC2pAEAUAu9opvQ
	(envelope-from <io-uring+bounces-13404-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:02:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F9E56F7A6
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:02:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D91403051D26
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77AC2641CA;
	Mon, 18 May 2026 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="uyKqRxn7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="J+rZvXbu"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDA425D215;
	Mon, 18 May 2026 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115575; cv=none; b=YaTyS5nrqbfZoM6hlt5BfA/c+nyoZXQ3M6uVjLPl4MUbtH7DYWSVtiQCjDqPtBhd6NHwCvLpkdSRlxuAkpbGIiOVMYC8r4RKxdsvcp8hiyQeagA7DaNKtDpLYuEiE+Z8I45l88ymVB1yZuNn4T8abIWts2hRWm5Z0Mr7mvg2V14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115575; c=relaxed/simple;
	bh=uCwEMFlrceX2NYy3s0s2xjdsqk9auTPLj4QOWo1OOR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oBcBigNALyBa97DZrvdMF2OvTQn2ekXC4BSTm/frNu5RxGiR7ihuVcHz5GaokRp2eCtG7mNxIM0s0ma8sY9onZ/32zQ2PcbmhrA3WHFaHRNLV7MGmeI5ScaLyU4YjHQZFhbe5DfhicpAzorFDgV6mu3gPpTYbplIzlg5m9dv8gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=uyKqRxn7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=J+rZvXbu; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 82A461D0012B;
	Mon, 18 May 2026 10:46:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 18 May 2026 10:46:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1779115572;
	 x=1779201972; bh=kF/MHu6owxGkDoRJJ1BDiU+HShjK55SOMC12/QfYVOk=; b=
	uyKqRxn7uaEfk4Kn8D6fgFUha4c1+46VYo8z2F3t5WsQYRXRfsqu+tqkJFupzz0B
	7D4iX75+pOsXJSbmExoBfHbq8Tg46EcooQF3MTnBylmQNzl2fAg9zXC97mB3S3wa
	K1uCX8ZhPypO5J9RpTFRPAGJlR0F4lNMIFwgiALvyKXRqJqSwafFI2MMPTTy54CG
	yB24YeM8bmqxjmfOQLua4039362yfULz96vsLB8j9IoM0q2Zf7fVt124AehqlkeO
	YXAVb+E4FdcDbW4q/gC0Q4WGKCE/vkSNUeojkAk/dutUk+QvoxGsVN95XyS2EgYJ
	NHk0gdrLl0EzVXQpBU6kbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779115572; x=
	1779201972; bh=kF/MHu6owxGkDoRJJ1BDiU+HShjK55SOMC12/QfYVOk=; b=J
	+rZvXbuMkEA8PQ3kTId5/mojp4MAZ84H8PNyUMGDKVX7MZUKdgZOrImcu8FISJKB
	979h6pIN77UhReHpMjnjphHvmeK2RFjPbpGl9s43x3Dny2/Lr6BCy7iJfdCEnxqq
	o1lL4MC7bkralaKTkul3f9SXXcSCqABMPnSX1DvOQoJz+tGVre4Bl16rHugB2ytq
	GSxH62KQdIw2w4LTZNoevr+LrkuF4C3opb19UpeInEmtUtESmNvfnCJ2yjKY0K87
	QyPjF73NLPN+lAaYYIY4fcOVNldd2MbYS5VTsg4wIAenwZbe7zkPttD55dIgxjXC
	DCOk7Pok2gDegcqTZ04aw==
X-ME-Sender: <xms:MyYLart-2seZC_dil9-u6981wdgzENZEoSLaBz2bmlmPuFhMDBMNPw>
    <xme:MyYLaoXKLFvSPGSJzqbMbEWZTYBKwsinNQFYP4SwQlYE3S2Sl9H0wVvrf6lRba3DQ
    y_P3LQbh5t5RcbuL9rYAHsz204wiIUhwF7hap0YKCw3OxMv9G2D>
X-ME-Received: <xmr:MyYLarzTbOirTM2vQAX3T4QkWUoXihFxX_Gi1grj0Maxh9Ivw3WTcq71Msix-TcDRgfFK8oLrzDrkVO7MChZrk4Q7dI1VbWgepMPfqd9oiE48mm3yA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddufeeludegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeehhfejueejleehtdehteefvdfgtdelffeuudejhfehgedufedvhfehueev
    udeugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeduuddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepmhgvsegsvghrkhhotgdrtghomhdprhgtphhtth
    hopegsshgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtohepghhrvghgkhhhsehl
    ihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhikhhlohhssehsii
    gvrhgvughirdhhuhdprhgtphhtthhopehsvggtuhhrihhthieskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghpth
    htoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eprgigsghovgeskhgvrhhnvghlrdgukh
X-ME-Proxy: <xmx:MyYLavF5ErNLZvUO9OGRDcM5KxCO6HHWw4QoIVtVFhgPkijo4Flu4A>
    <xmx:MyYLagur6QjSqkHYSW7BpibQPS4xV4OKGxWsvJh3bIy6PmsBcyATgg>
    <xmx:MyYLavDy-yVjQz7b8oAKJIdWyPwPiVYHEeVFaKp3OaKGpcY68i3HDg>
    <xmx:MyYLarCmVOQd5CyPu-hWM1LU62l_LGIpi1mWsvo_PulKNHQT89qLSQ>
    <xmx:NCYLauzik5tR2hfyO7Ktti3_gkRcqad2yKZXxAhNl3VqdQVurh6H3Vzc>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 May 2026 10:46:09 -0400 (EDT)
Message-ID: <0e4f0d30-7ed0-431d-ac9a-874b046337cf@bsbernd.com>
Date: Mon, 18 May 2026 16:46:08 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] fuse: wait for aborted connection before releasing
 last fuse_dev
To: Berkant Koc <me@berkoc.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Miklos Szeredi <miklos@szeredi.hu>,
 security@kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 fuse-devel <fuse-devel@lists.linux.dev>
References: <20260517-fuse-uaf-patch2@berkoc.com>
 <2889c98c-21e8-47eb-903a-ea40bf5c8c04@ddn.com>
 <20260518143218.7c7c1689.clarification@berkoc.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: fr, en-US, de-DE, ru-RU
In-Reply-To: <20260518143218.7c7c1689.clarification@berkoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm2,messagingengine.com:s=fm3];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linuxfoundation.org,szeredi.hu,kernel.org,gmail.com,vger.kernel.org,kernel.dk,lists.linux.dev];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	TAGGED_FROM(0.00)[bounces-13404-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RSPAMD_URIBL_FAIL(0.00)[messagingengine.com:query timed out];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 51F9E56F7A6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 5/18/26 16:32, Berkant Koc wrote:
> On Mon, 18 May 2026 11:47:00 +0000, Bernd Schubert <bschubert@ddn.com> wrote:
>> Would it be possible for you to test the attached patch?
> 
> Reproducer and KASAN harness from the PATCH 2/2 series are staged.
> Two-arm plan: revert vs apply, race-widening debug hunk kept in both
> arms, 2x50 iterations each against torvalds/master tip, KASAN + lockdep
> + kmemleak enabled. Results back within the day once the base resolves.
> 
> Blocker before I build. The patch references ring->chan and chan->conn.
> On mainline fs/fuse/dev_uring_i.h declares struct fuse_ring with
> struct fuse_conn *fc at line 110, no chan member; grep fuse_chan
> across fs/fuse/ returns zero hits. As-is the patch fails to compile
> with "struct fuse_ring has no member named chan".
> 
> Is this based on a DDN topic branch that introduces a fuse_chan
> abstraction not yet upstream? If so, point me at the base tree or
> branch URL and I will rebase the test against that. If the references
> were meant to be ring->fc and fc against current mainline, confirm and
> I will adjust before the run.
> 
> Assisted-by: Claude:claude-opus-4-7 berkoc-pipeline
> 

Ah, it is based on Miklos' for-next branch, which is also in linux-next
(I think). Yeah, we have a bit back port headache here.


Thanks,
Bernd

