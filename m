Return-Path: <io-uring+bounces-12040-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UCeWFR9EgmlHRQMAu9opvQ
	(envelope-from <io-uring+bounces-12040-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 19:53:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC74BDDE1B
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 19:53:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A4653100A33
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 18:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0122D36A00E;
	Tue,  3 Feb 2026 18:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="YGHQuUhu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DWbnyZa/"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5F935D5E1;
	Tue,  3 Feb 2026 18:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770144261; cv=none; b=huWyI1NWEy1FDFKyzQq02hVChhF5sU1X5LqFTBQgg4GE5Dnxk733yUdle4Wrnj6tMMcuingtW4RrH6fZ5N6g+gAjFkSPKfLWoB5fSF6KnhWe7nhA06u5ZFbWqevJ/VdQAooGQ1wSiOHw7qjXMT5xmcCGgfUhpTKGiUMqCBeXnlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770144261; c=relaxed/simple;
	bh=M5BCM77qAB/Idmzcw3Vy2CbN+rIYWee+af0pdVmvAdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cW9TD/u5AR/BSOdDkuHmd0fk5FZ/W4+svwZaq1rqfd09rXhZQlF8BPZZD31jc4dNmtwdiTQOPcMQDVojn4jqP3fQ4N1tcN80KZqXWlKXwc9+DK0LtvKW0hz+HhtBnTPljdtOrN+LjfQIAuTsUfcumAa//gGPr6KbC6tX9O+bmbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=YGHQuUhu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DWbnyZa/; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 439EF7A003A;
	Tue,  3 Feb 2026 13:44:19 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Tue, 03 Feb 2026 13:44:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1770144259;
	 x=1770230659; bh=rcD9ueS8lTPylHeuokUJO8kUTnkzHrfzjn4OKTI0g2g=; b=
	YGHQuUhuxoE2QPF4AmhmruSOo7OFgENjEG7/VJgfRhVjDNnDlaRllDTO3TL/cFwm
	QQoDLZF6ul+cSyCm+snO/oKK/f3fwW+Kk05/LBvHPpnJTavgYIJfNIbCuNTzu1IB
	7zKv2z9qXPA/13grYVuVlTtO8/LbthE3zzAKwYnWaoi9ZJBc3m8rwnK7lCLdqaJ9
	jFK3brm+PHv0jYf5b5mqBpw6GKAYmTdSmx8XzREB4FG1a/peSoMBtdKO5yxhJV5e
	G6YD1R6un3uc2qka8gYXN56fvaA6drPSMduF0eoZ5Z8WA16dNwurTgqeXlEEuGcb
	tzAtvcwg8BidlbyD9wDMHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770144259; x=
	1770230659; bh=rcD9ueS8lTPylHeuokUJO8kUTnkzHrfzjn4OKTI0g2g=; b=D
	WbnyZa/tLdzsEGwjH1YxnGLpJXCYsFdmMV7nnqnoGHsC5/MVmKvLPHLsUNgRMoDi
	FFTqd6uuip5jhGM6om1s1bIAw4ahJWT8ThJ+A1xAsFQ3+61iBI1rfp/1FtEZNzLr
	l5WNwWjJJtLSmkJOtCt3cpOB5PZZz7AVb6fHr/0/G98BWab0ordoUE2xsdA5SNll
	sz+r6fgID5nJj1fW7WfXwMt+yy1KmZ+ppC81U6aAcwd84L8uFnPq4NJqIde3e+xx
	Wg7FJ/qjp7e/Os6BBP329vgUBSk7QFC7+KDuSuZemuGBUo0akVopIFjPRnEA2nDa
	FjsPYZF5W2MG1kHUgbMBA==
X-ME-Sender: <xms:AkKCaZZ6ZhcukjRe5XdlWP9CViYt6tAc4LTSYWU6XEfBJ8iIGePKDQ>
    <xme:AkKCaep7hYFqUrr8KwkjiwEbnaS_RDCUgqcolarzazQHBTGfi23yWaOZgOwoLSrQh
    89gwrLEX1_r9P3g2SXRaBMje89Z4z9Xh9qW7pE0Yv9LlJjr5CnI>
X-ME-Received: <xmr:AkKCaVRCMDKrKjsom9uMKx6YP_4D26e-JqiFwvGYNE5AK5kzVy9giT1PdvL0xNfdUhaC45jXdt6mqmn3Btnq3O01S7Q40zzeIR8ThthykQX3X7Gt0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukedtjeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:AkKCaaqIeK7dkZ2o2ooBr5mrbsBRpM3fSA-NK2afc_UcV2kjvrfcmg>
    <xmx:AkKCaX0HnswCCroSvxagdAOugjvv68SXFLoI5kyKpwQODjdYW27azg>
    <xmx:AkKCaR7pcCQYR1mQGQO09t9iXlQyHyZ8nY9CwtBcP3cB0v-ctsTgpw>
    <xmx:AkKCaTRvfaml9rBJBA0PpgQWXLvfofWEI0lBLWlBiRiwa35j45tBPg>
    <xmx:A0KCaSH-38_MbdD3hHYCevciHauAw3KwnwG_uVzPsrtqGUmQ9BtETogX>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Feb 2026 13:44:17 -0500 (EST)
Message-ID: <4f96f8b5-7f51-449c-9717-8c8392a3d671@bsbernd.com>
Date: Tue, 3 Feb 2026 19:44:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/25] io_uring/kbuf: add recycling for kernel managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk, miklos@szeredi.hu
Cc: bschubert@ddn.com, csander@purestorage.com, krisman@suse.de,
 io-uring@vger.kernel.org, asml.silence@gmail.com, xiaobing.li@samsung.com,
 safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-8-joannelkoong@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20260116233044.1532965-8-joannelkoong@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12040-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,bsbernd.com:mid,bsbernd.com:dkim]
X-Rspamd-Queue-Id: DC74BDDE1B
X-Rspamd-Action: no action



On 1/17/26 00:30, Joanne Koong wrote:
> Add an interface for buffers to be recycled back into a kernel-managed
> buffer ring.
> 
> This is a preparatory patch for fuse over io-uring.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/cmd.h | 11 +++++++++
>  io_uring/kbuf.c              | 44 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 702b1903e6ee..a488e945f883 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -88,6 +88,10 @@ int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
>  			  unsigned issue_flags, struct io_buffer_list **bl);
>  int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
>  			    unsigned issue_flags);
> +
> +int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
> +			   u64 addr, unsigned int len, unsigned int bid,
> +			   unsigned int issue_flags);
>  #else
>  static inline int
>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> @@ -143,6 +147,13 @@ static inline int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd,
>  {
>  	return -EOPNOTSUPP;
>  }
> +static inline int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd,
> +					 unsigned int buf_group, u64 addr,
> +					 unsigned int len, unsigned int bid,
> +					 unsigned int issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 94ab23400721..a7d7d2c6b42c 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -102,6 +102,50 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
>  	req->kbuf = NULL;
>  }
>  
> +int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
> +			   u64 addr, unsigned int len, unsigned int bid,
> +			   unsigned int issue_flags)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_uring_buf_ring *br;
> +	struct io_uring_buf *buf;
> +	struct io_buffer_list *bl;
> +	int ret = -EINVAL;
> +
> +	if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
> +		return ret;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +
> +	bl = io_buffer_get_list(ctx, buf_group);
> +
> +	if (WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
> +	    WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
> +		goto done;

Misses "if bl"?



Thanks,
Bernd

