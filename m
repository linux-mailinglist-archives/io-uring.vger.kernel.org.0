Return-Path: <io-uring+bounces-12973-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAwJOI121WlC6gcAu9opvQ
	(envelope-from <io-uring+bounces-12973-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 07 Apr 2026 23:26:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C98A3B505F
	for <lists+io-uring@lfdr.de>; Tue, 07 Apr 2026 23:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 68402303D2D4
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2026 21:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C645937B019;
	Tue,  7 Apr 2026 21:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PD36timq"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B59A37C901
	for <io-uring@vger.kernel.org>; Tue,  7 Apr 2026 21:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775596938; cv=none; b=et5Skgc1vXYbF5IEmSFsloeD1eNDqz1XIFi8U5YEymfABDgUHQCTVVXruS+lfeOaVgYqHYFrqiXxOlogs/GFxurbzkKKbSJiiJhemfwYvbFSotNpPsktFGMgjWJ5FZlmUkEKMfyKNlZcgP7DyRzoQNdgG2xVYdmYldD0skFXfpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775596938; c=relaxed/simple;
	bh=oFXUOMCsWM0FVG3uwyZVORg9tvvv6jaX/JdVX69Md7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XrBvl2/uHwjCN+9rIZXQoqBz97mFkH0dtkj8PNYs56292Xckqx9WuSyqA66BrirbKvKTUUj77zlNDhzNVT0LWze7Gp/LRzzrMdV35p7h5aUEBHJOTLVXDy6dxdXURSNsgh3yp7oYE0rPLRGnQ4FlAXwns4kXTqxbtDtP2HG910o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PD36timq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775596936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=08oaNpMk0ZvV0Wt0jg05aCMOjVRxzil+ZF5ABphc55M=;
	b=PD36timqXpDkZ/3XXZXvS0ATwNGT+XKKqfhSb2C8BljDIBUQdsUHWQw3QDqtm97sfe4Bbn
	4N8VoQ3GLpErJHe0J8HUHu4IgS/GpeIDMBQIzki6UCD0OSJM1KLaRG+pX1y8OTwmt29zDH
	IThFaFCdwkzeVszs6KTe3fPIeFirEfc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-mQHGT6mpN9GXzYVFdNKmBw-1; Tue,
 07 Apr 2026 17:22:13 -0400
X-MC-Unique: mQHGT6mpN9GXzYVFdNKmBw-1
X-Mimecast-MFC-AGG-ID: mQHGT6mpN9GXzYVFdNKmBw_1775596931
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 534FF19560A2;
	Tue,  7 Apr 2026 21:22:10 +0000 (UTC)
Received: from fedora (unknown [10.44.32.11])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5EEA4300019F;
	Tue,  7 Apr 2026 21:22:05 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  7 Apr 2026 23:22:09 +0200 (CEST)
Date: Tue, 7 Apr 2026 23:22:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kusaram Devineni <kusaram@devineni.in>,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jens Axboe <axboe@kernel.dk>, Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] signalfd: don't dequeue the forced fatal signals
Message-ID: <adV1fCyvANv4h2dH@redhat.com>
References: <adKJMRkQJXEwHs-j@redhat.com>
 <202604080450.mkKRp9Mk-lkp@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202604080450.mkKRp9Mk-lkp@intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12973-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[oleg@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 4C98A3B505F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 04/08, kernel test robot wrote:
>
> kernel test robot noticed the following build warnings:

...

> sparse warnings: (new ones prefixed by >>)
> >> fs/signalfd.c:53:40: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct k_sigaction *k @@     got struct k_sigaction [noderef] __rcu * @@

...

> vim +53 fs/signalfd.c
>
>     50	
>     51	static void mk_sigmask(struct signalfd_ctx *ctx, sigset_t *sigmask)
>     52	{
>   > 53		struct k_sigaction *k = current->sighand->action;

I am going to ignore this new warning...

Yes, task_struct->sighand is __rcu. Not sure this annotation makes a lot of sense.

In any case. current->sighand is always stable. Plus task->sighand is stable under siglock.

We have a lot of (correct) non-rcu deferences of ->sighand.

I think that only lock_task_sighand() needs rcu_dereference(tsk->sighand).

Say, __exit_signal() does

	sighand = rcu_dereference_check(tsk->sighand,
					lockdep_tasklist_lock_is_held());

To me this just adds the unnecessary noise. I do not want to add another precedent.

Oleg.


