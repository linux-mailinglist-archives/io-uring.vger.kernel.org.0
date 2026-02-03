Return-Path: <io-uring+bounces-12041-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNz5Bf9EgmlHRQMAu9opvQ
	(envelope-from <io-uring+bounces-12041-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 19:57:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 707F6DDF7A
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 19:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4E40830E6565
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 18:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB792DE70C;
	Tue,  3 Feb 2026 18:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="DK0E53PD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="durFDXvj"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4116325F7A5;
	Tue,  3 Feb 2026 18:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770144767; cv=none; b=fliANMaZ+tb3xv3uEqjZTu1ubNPDd7q0btyLewOaUb/c6rQ9nX2y8GWogKWMi9HjNIrTzB7ebXE5Wqr2oicHM6uybbhe44805El2SqwwKc1lm2WtQFHLGECQQ9b6PIviyn8JNg1LbJ0aNET8rWa3F+b6YK96SlHqSykKhGBsqT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770144767; c=relaxed/simple;
	bh=zVPiAP3T4UGtkVXMkDdmCpTW/YCWk/ixyuzXCi0/mYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CcSRRs+h0EQiYbcCM+BzAPmli4A0OPFFRJPm0ls2l+YF+zzsy71S10s1BAv7PPgtdj9nBfJXgfzv6B5WMzvBgdzShodXuO+U5jdoFTdbaeIwQxX3QdWhViPWFdhwGrwhyVC47a2pVXOKey/UF1ygWwNDn9uyaFeQBDQ/85K6iUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=DK0E53PD; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=durFDXvj; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id 42C321D0010D;
	Tue,  3 Feb 2026 13:52:45 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Tue, 03 Feb 2026 13:52:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1770144765;
	 x=1770231165; bh=PuuqUzrOW0ejy4N/6rH49JuxAIizRsFiW6QWrTJ6jjA=; b=
	DK0E53PDtjlF8yGTfIO1eZj0aTZuTi0aG/mu0JqwIJYCtvZC2/7DjdASgOQVPYUL
	vPmcoM80Uxp4r34Wl9Ytd3bMHsb+x1LaaViaMt8qIYa8cIpMACQ4vgvZa5ViIl+F
	qwD26FibxnVvdGcswP+mLvsUqQh6uHwUkjswjYo8yHL7q646O0FHAMjXzA/lBdet
	VZCoR6v37PKU10vAtIHw8O3RuXmgjIjbo2KvxmJApu+GmfAdhofoZhJNPMOcfMPL
	x/J2ciFv3wO5+GVublkC5/3/gFcRsRXijNsSMc3GVoM/bLKIpEQZId36v5FGZtoN
	0vnXUsF3rV68dnzSEGsK6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770144765; x=
	1770231165; bh=PuuqUzrOW0ejy4N/6rH49JuxAIizRsFiW6QWrTJ6jjA=; b=d
	urFDXvjhV49UPOdqm0a1WIV7veZxQ1vIgFgBazT5uX3z0nSCKsOuWQgEhtwPgNH2
	dUn37od4WSywCINDtw8A03B22acYmp3NWrtH8rt5ydbNtXGeQ1/Ok55GCHzR3ItY
	PSaEOiNff7NxpxFol9d1dx74UjcXNqdWAdxf7pCRskNgtTTSfiOOI/e/3hV06EO5
	wACARrnoA/gxrhsoREHKiql8NTzj7aJKGMmh3960ngv2Kr6II5dGgzMJm1cLPQWM
	0XG4rFh5h+dScaJI7R/nxQxvjYEzrrj1guPI5c672lvQWv64EJHUULo7l5xGGKvQ
	PGPJfkxMQdw+ULIxC5vBA==
X-ME-Sender: <xms:_EOCaQnouiuxxRzIiKtYjOE7bQSzjCnzKgfdluTdUzrBoZ1BUxLWUA>
    <xme:_EOCaeFn0aM4VP0pWwn-Y8NaKHgJevh7ZA0Wnqz_RiGckuFoLG1ChmlpzcAnAO3-9
    -P5JUZhryszuj4SG9unmWlM2VjYxMedoQwdZuNCL5rpoHRQ4PU>
X-ME-Received: <xmr:_EOCaX-kN7y97zJ1VG3KZ742g4eABGNwdGC6x9QpQLDol8OIfQs2yKkv9gMKRppA_0nvW_JfMxFa769a7eLsiloR7J5zAtil43Z12WQkGnAApMpq2Q>
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
X-ME-Proxy: <xmx:_EOCafn2c9-h75q2VPE4TiYfSh5QDxYyG8UjzjemjcV3uLEjBgWwcA>
    <xmx:_EOCaSD5mr-0ho7Oyx4zqzVIRKVb8jVcD_PoG9ZZMmKwx4kUwu9n9Q>
    <xmx:_EOCaYU9gPcLH7_7vsmYNaRGAYnyGpAmxFn29--8n_R__noIGTWRMg>
    <xmx:_EOCaQ_pzG2F2CBmsi3WA0TXGo_g57B5Fp7KQBcXtScE7wCiOTP7jw>
    <xmx:_UOCaaBJjEB7k2aGIN-rl39X_pz8yGdQY5lQdKZl-58q5Htb8odbgYRe>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Feb 2026 13:52:43 -0500 (EST)
Message-ID: <9c32bd42-b935-48fa-80f8-d610f4085025@bsbernd.com>
Date: Tue, 3 Feb 2026 19:52:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
To: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk, miklos@szeredi.hu
Cc: bschubert@ddn.com, csander@purestorage.com, krisman@suse.de,
 io-uring@vger.kernel.org, asml.silence@gmail.com, xiaobing.li@samsung.com,
 safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-7-joannelkoong@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20260116233044.1532965-7-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm1,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[ddn.com,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,szeredi.hu];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12041-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,bsbernd.com:mid,bsbernd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 707F6DDF7A
X-Rspamd-Action: no action



On 1/17/26 00:30, Joanne Koong wrote:
> Add kernel APIs to pin and unpin buffer rings, preventing userspace from
> unregistering a buffer ring while it is pinned by the kernel.
> 
> This provides a mechanism for kernel subsystems to safely access buffer
> ring contents while ensuring the buffer ring remains valid. A pinned
> buffer ring cannot be unregistered until explicitly unpinned. On the
> userspace side, trying to unregister a pinned buffer will return -EBUSY.
> 
> This is a preparatory change for upcoming fuse usage of kernel-managed
> buffer rings. It is necessary for fuse to pin the buffer ring because
> fuse may need to select a buffer in atomic contexts, which it can only
> do so by using the underlying buffer list pointer.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/cmd.h | 17 +++++++++++++
>  io_uring/kbuf.c              | 48 ++++++++++++++++++++++++++++++++++++
>  io_uring/kbuf.h              |  5 ++++
>  3 files changed, 70 insertions(+)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 375fd048c4cb..702b1903e6ee 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -84,6 +84,10 @@ struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
>  bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>  				 struct io_br_sel *sel, unsigned int issue_flags);
>  
> +int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
> +			  unsigned issue_flags, struct io_buffer_list **bl);
> +int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
> +			    unsigned issue_flags);
>  #else
>  static inline int
>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> @@ -126,6 +130,19 @@ static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>  {
>  	return true;
>  }
> +static inline int io_uring_buf_ring_pin(struct io_uring_cmd *cmd,
> +					unsigned buf_group,
> +					unsigned issue_flags,
> +					struct io_buffer_list **bl)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd,
> +					  unsigned buf_group,
> +					  unsigned issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index d9bdb2be5f13..94ab23400721 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -9,6 +9,7 @@
>  #include <linux/poll.h>
>  #include <linux/vmalloc.h>
>  #include <linux/io_uring.h>
> +#include <linux/io_uring/cmd.h>
>  
>  #include <uapi/linux/io_uring.h>
>  
> @@ -237,6 +238,51 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
>  	return sel;
>  }
>  
> +int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
> +			  unsigned issue_flags, struct io_buffer_list **bl)

I'm just looking at the fuse part and I'm actually not sure what the
"buf_group" parameter is. I guess it is a the buffer group set up by
userspace? Does io-uring have some documentation like fuse has under
Documentation/filesystems/fuse/?


Thanks,
Bernd

