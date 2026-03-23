Return-Path: <io-uring+bounces-12803-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCZYHMBPwWnLSAQAu9opvQ
	(envelope-from <io-uring+bounces-12803-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 15:35:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BD12F4CC2
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 15:35:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE07A32CADB2
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 14:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B8F3AEF23;
	Mon, 23 Mar 2026 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jI7GABMN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175073AC0D2
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275793; cv=none; b=DNE8sHqfWOiuS2rM+tapYjopS/uyMb8tK0NQaFlYwuuSly0vZsH8xXYcfsJX2YwSspN7UQOYaPif7c0tKyr5WBS4qVFs1iR4Z8ntIzFYjt5qLG4gbvXTTVAuGW8VXIktCUohbiRFQyILxKHfbwhWgBOjyUoBNmK+AIDh9blL0QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275793; c=relaxed/simple;
	bh=C+9I8qKss0WgLUFVKxwU390YrmBUMAcHGwnzXZi12Vg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mqhXIBkEu8Nz3YV+uFZZfKo1eT27ALqGw7PTWH0UOmobRjBXfKxqO8i2FuqMhUXf/BAS1FrS3XVXIBbnIElr27oOQO2R+RKIm+NZhhzoXX8EPgtk/35WzLnBPI/VCwDbFqvFwEJJBKoLXS5ekQP/WCyvi9iWRT0iqZBuLCUZUlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jI7GABMN; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-41c4d660b19so319162fac.1
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 07:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774275791; x=1774880591; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3zm+uLazNQIplB8qIgyuexcD83A6/QI4uC1344ND9QI=;
        b=jI7GABMNhA8JVmNX75DdYanW8D4zZxB8EvshRZRCRZ3rc8ac4ASQqjSJELsMWrhagj
         a2iMY2e0b9w6+OlmJ7MeHBWc75m+66sdYQ5mHf0AGefKjANNWpJ7QplVdim3OLfkk72Z
         aG01jykkr6j3/T2HtFB5zH+goRdVA3MjcGC78M8mN5dLXjGuUSQXeo3kmmd/BqNy7Ykw
         zmqBBvcNns0KbB7VVZyhovPcCZJxR/K9mSIn4fEs+nlO2irQKVY6nghRT1t4FsNgXhD6
         uJJWN27G/cexXSjuhJvEfMeami193uBRdMe8fRbk25Z3Zp4yMBHWFd24H4F0kEjvEtpB
         BtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774275791; x=1774880591;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3zm+uLazNQIplB8qIgyuexcD83A6/QI4uC1344ND9QI=;
        b=nWJKysP1K5BzTI5HqJamZYPj0BCKdGWeeJ/i6MQI74pbf+0QoTUPnKig/2x0N2fWOl
         KIFVHjYlNVMcHQb1wuAO/qMEF+BmY2fTUPMgvie86z24H6eorNzY8XhjNRd5RZFh5oaB
         HV6ie9kQQyyM+k/uZ0Khv1biAUrbzvDXBy9WIbjfvxfzlx59i529tBTVXTUVUNoAsPja
         MiK3kwnoJwDVJ1otDo/N3HodQLI2Zon657p2gToKmQYGisVcPxRKViArSl9kCvUp2OHA
         agHCLHUKdGjXXbVgukphFxI1kZFWB8oRAKssq+/xePIzyT/1LWAEJT0RUapxgnxddXd4
         YG7w==
X-Forwarded-Encrypted: i=1; AJvYcCVVk9TfbMP86SfQXb3Kn4PpMLag6augMVidY/fOtJmC0F0ytYyCfiRqv1Z1iBt6FBjjm9Jn43vDmw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5esgZ7NR+qBoUC/sld9iY6XDOdbvgxnExlrYWBMoQFHlqNtGE
	RwVGyK37iI+GlaxI6DEmhIN3eWW3Xbrf2UH0vNUbHG7bNW2ZpNLKXTLjKGJKmxRj60v5mK887LU
	+eUI3vbU=
X-Gm-Gg: ATEYQzxn1m2GhFst9tJqUZXRMuk9DfisSb8kTtsuNWwGKg+Ct2h8QV5ouxr0xENoeQ9
	l04iDLvjMjdx6j8LLbA8BzPt+KcNRqxgo05HW5fZm8oS0hYR7wQRg+sNfXPIUf0t6dV0ZIYk3KK
	CAF+kc+g2BlzfoFkkkr7+g/ofBd//ObmDsr1S76WgOdaoOeU8BFDiMujop8rRcuhjrFnfKLYshC
	bD1rL+W8X01KsP7fIHoZXlAQaG+6pXHYdfAUIxwD3GPpDMNLMUNpHDI+Zx53PMXppB9fuC/0jtm
	lJAesCcD1PJuZ2QxXXTWWU2S58Jj7oJl0+k+jVVdC/T3k1dLtKBXuoZq/OH5oaGj7qX0miYPY5L
	NRR1KtbMFYIALzOwN+BS563jyP11BP9jS6VjvvIJApq0kSPAZwLv5O/d8A6k431tUN/ZFG87eIo
	1Lo9yniubk4HW77eNMFh1VvzZy0W0MsRrcyEwxeGKX4zq4rKxMeiYTiVzqgdeLGML5Sw1nDpViR
	zkt59N9Ew==
X-Received: by 2002:a05:6870:51cd:b0:417:359c:292e with SMTP id 586e51a60fabf-41c10f84c98mr6864368fac.12.1774275790874;
        Mon, 23 Mar 2026 07:23:10 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14e45213sm9682225fac.18.2026.03.23.07.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 07:23:10 -0700 (PDT)
Message-ID: <4a3cf1f2-274a-4ceb-9980-4b379e81394a@kernel.dk>
Date: Mon, 23 Mar 2026 08:23:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] io_uring: Add IORING_OP_DUP
To: Daniele Di Proietto <daniele.di.proietto@gmail.com>,
 io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
References: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
 <20260321232142.911280-5-daniele.di.proietto@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20260321232142.911280-5-daniele.di.proietto@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,vger.kernel.org,zeniv.linux.org.uk,suse.cz];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-12803-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: C0BD12F4CC2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/21/26 5:21 PM, Daniele Di Proietto wrote:
> +	if (((id->flags & IORING_DUP_NEW_FIXED) == 0) ==
> +		    ((id->flags & IORING_DUP_OLD_FIXED) == 0) &&
> +	    id->old_fd == id->new_fd)
> +		return -EINVAL;

I think !(id->flags BLA) == would be shorter and hence easier to read.
This is hard to read, at least for me.

> +static int io_dup_to_fd(struct io_kiocb *req, unsigned int issue_flags,
> +			bool old_fixed, int old_fd, int new_fd, int o_flags)
> +{
> +	bool non_block = issue_flags & IO_URING_F_NONBLOCK;
> +	struct files_struct *files = current->files;
> +	struct file *old_file, *to_close = NULL;
> +	int err;
> +
> +	if (new_fd >= rlimit(RLIMIT_NOFILE))
> +		return -EBADF;
> +
> +	if (old_fixed)
> +		old_file = io_dup_get_old_file_fixed(req, issue_flags, old_fd);
> +
> +	{
> +		guard(spinlock)(&files->file_lock);

I did suggest a function, but if you're not doing that, at least use a
scoped_guard rather than have some randomly inserted scope here. That
looks like AI code..

-- 
Jens Axboe

