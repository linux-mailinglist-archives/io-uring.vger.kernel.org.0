Return-Path: <io-uring+bounces-12989-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qBXQF1dP1mm8DQgAu9opvQ
	(envelope-from <io-uring+bounces-12989-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 14:51:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A673BC66B
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 14:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D7F5030055B1
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 12:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DFB3AC0FF;
	Wed,  8 Apr 2026 12:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="krQkutTf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="u3W3T+o4"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05A41F4CA9;
	Wed,  8 Apr 2026 12:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775652690; cv=none; b=bAspRzbV0aTyXwsZdXGtJkxY3B5X2D1YNqw5ahWUV3XlLS/e0Aiyxi8DM9bq5Qiw74tc/4t7aEFHVj51LNOOVcaDBrCOT0A394j5vProjw4sHh0n0n4IgzdWmHcDrnuPn0auvC/h7NSneV5RilOGF1cL1B9VkcAp+9/sJ47DWEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775652690; c=relaxed/simple;
	bh=aVqr7b491flfZ/a7qwqxfspBhDecVe68lScS1osuznk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozocUTk9kKYqdXypXU7wwEDVMbjavRoXJNsSGyierTV+DqF0Oh2KfvZofIgGKWsla/Y/UgMZO/m1UCWmdR4QYFT1EPu/DeBuRNzu1hRJTLLaF65Lk++NW6NLNrAHmzlTPulV8zXU5QyeyDPzwl1FbWCHyM8tVCjslGcXyKoCtXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=krQkutTf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=u3W3T+o4; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B90617A02A9;
	Wed,  8 Apr 2026 08:51:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 08 Apr 2026 08:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1775652686; x=1775739086; bh=qEAAixDrH4
	hM9fy7WrMx7Dkhp/zwxrIYzBvUGK+jIs0=; b=krQkutTfLUaBlKltqPD7l4TGuP
	c1ukG8q9hOZO/49X20UxucasmRECtn0yneplUuWY/i64uIYMWhvU8dohTwnL/+iu
	iiJMrMi3xuXjtCfMKFMMd7wL2nO6ZCjVhmHIEgvG6vK6B0Jm99+yYFlmoHJI0MO4
	ojUf5C4h5cqwqISTp3B+Bd1JFyFV8Kt9LmIwJBVBgVS1ACU94p2Sk1ZkE9K1c2tg
	te/RzucSOZsMczO8bTK0KPEWPj0VX5QRA6c4iY//4dafSGJFpF9HwqdsjRk4Qv5h
	stET8Nk7UwNlhqDMv1dUMM0qT1dekpTfg81AgLPWxQeLid4TVqXjDp/631Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775652686; x=1775739086; bh=qEAAixDrH4hM9fy7WrMx7Dkhp/zwxrIYzBv
	UGK+jIs0=; b=u3W3T+o4y0CqVoNQeAtU8ZUggEysk4+jrgk+8PVAfz+mfVbKyOn
	eK8eaYVbV3XuSVxU/l+4Tg9w/ooE7lTdMC6g1JngOpPnJh1NAuleL9UBV/1u9c85
	nc2TXup3pqY5EPiyUgLciVx8N1C/zey7eWioALubk1xVqaI68S2JSQeeu9eWonUM
	W85nFLeyeyWedfIIJCS7PX7MWltSUUwH/rLtUSlBpXvnBKtaawduoORYAElmmvYL
	aleXEpGdGEBqaSquDyg3uxIDvH2xT1bFcX+tEogQgC/0JntWUKkcFgc1kVd9lJEU
	iYSI4NsBInJp/CLsevsiIeT3HEqpBkAk6YA==
X-ME-Sender: <xms:Tk_WaYqLRKzmagy-Fc9n72TIwWU7ESBur6z-9I6zER_KDKWA3EYFjw>
    <xme:Tk_WabWxb0s0C_q3bIPjxWixaLZhP1jX4JxpBBUOXHK1czxHT9J0Wf9Jg22O1GtVI
    Ty_Ubsugiqheq_JiomZgehJvRJGZRhz1fIFXfW6uLKWtD6NP9s>
X-ME-Received: <xmr:Tk_WaRErAbs7DDN0x_Eawn3DusiZFCRUBjnchRoPeUh3sGDUUJKNB8e_dJTf3bneWdJFTboneK7d04r7hbxXhdU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvfeeivdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcumffj
    uceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhefgtd
    eluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghinhep
    khgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmpdhnsggprhgtphhtthhopeduvddp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukh
    dprhgtphhtthhopehrohgspghgrghrtghirgesudeifedrtghomhdprhgtphhtthhopehs
    thgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrshhmlhdrsh
    hilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopehiohdquhhrihhnghesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvh
    hgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:Tk_WaaCPorss7IwiqYd81D4u1MSZLHiV0xCj2Q4qlPR8kCdIVnA_Gg>
    <xmx:Tk_Wabw0OOCsWH7wb4cTzsaM-0Z9UE4PDK1e8I1SVHeAmRwjS16QVg>
    <xmx:Tk_WaYejH82B9_lcOUROWEyd1nrcC4eRfXY40dJ1KTzCI1ArvR3ghA>
    <xmx:Tk_WaYtyQrXF6e6d5awisPf44Zc-_a-bpI_GktQikbBU95O_b58SXQ>
    <xmx:Tk_WaahknCu2sG2EppX_keyeBmHNy2OAQTwpK5aYvMYOu7Iby2yDCnyq>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Apr 2026 08:51:25 -0400 (EDT)
Date: Wed, 8 Apr 2026 14:51:24 +0200
From: Greg KH <greg@kroah.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Robert Garcia <rob_garcia@163.com>, stable@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15.y] io_uring/tctx: work around xa_store() allocation
 error issue
Message-ID: <2026040818-staunch-clicker-c988@gregkh>
References: <20260323081930.899697-1-rob_garcia@163.com>
 <c0e7718f-7bec-44b5-966d-46149fe30507@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0e7718f-7bec-44b5-966d-46149fe30507@kernel.dk>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kroah.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kroah.com:s=fm2,messagingengine.com:s=fm2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12989-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[163.com,vger.kernel.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[greg@kroah.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kroah.com:+,messagingengine.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,messagingengine.com:dkim,kernel.dk:email]
X-Rspamd-Queue-Id: A2A673BC66B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Mar 23, 2026 at 07:37:24AM -0600, Jens Axboe wrote:
> On 3/23/26 2:19 AM, Robert Garcia wrote:
> > From: Jens Axboe <axboe@kernel.dk>
> > 
> > [ Upstream commit 7eb75ce7527129d7f1fee6951566af409a37a1c4 ]
> > 
> > syzbot triggered the following WARN_ON:
> > 
> > WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51
> > 
> > which is the
> > 
> > WARN_ON_ONCE(!xa_empty(&tctx->xa));
> > 
> > sanity check in __io_uring_free() when a io_uring_task is going through
> > its final put. The syzbot test case includes injecting memory allocation
> > failures, and it very much looks like xa_store() can fail one of its
> > memory allocations and end up with ->head being non-NULL even though no
> > entries exist in the xarray.
> > 
> > Until this issue gets sorted out, work around it by attempting to
> > iterate entries in our xarray, and WARN_ON_ONCE() if one is found.
> > 
> > Reported-by: syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com
> > Link: https://lore.kernel.org/io-uring/673c1643.050a0220.87769.0066.GAE@google.com/
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > [ Modify the function in io_uring.c because it's located here in v5.15. ]
> > Signed-off-by: Robert Garcia <rob_garcia@163.com>
> 
> I'm find adding this to 5.15 stable. However, this also need to go to
> 5.10-stable then as the io_uring bases are identical. Greg, when you
> queue this up, please add to both. Thanks!

Now done, thanks.

greg k-h

