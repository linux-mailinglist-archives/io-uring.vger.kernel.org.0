Return-Path: <io-uring+bounces-10662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A52B6C6F64E
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 15:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id 3A9FB29A2B
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 14:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564EC2566F7;
	Wed, 19 Nov 2025 14:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="QVsWPFEL"
X-Original-To: io-uring@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81497278753;
	Wed, 19 Nov 2025 14:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763563157; cv=none; b=bBPI/kI8NF9NqGX4m4XThbc6ykIyD0fW6xdw21TJxLPRMcFxe6NDvVI/EniRodjgi4K3mDmBsTaPSQChEIZo46IgeRHUHQhhc5ZfwSKbJGG87aCZZeJ5CHu7YJEmMB4I0CDzINHPovzGFg8pSkZpxkyr17088pX9iWhgCr0k2Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763563157; c=relaxed/simple;
	bh=gsrYx8uS4tz7AIR1Us+F/2J+ABNvI5bcIRrK5o0XQGk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tMPV3NqdsjEZGOrHghV8g4mtlJY4VXCso4LyDQBiBZvGnoqnKrwo6yryc8TpZeeeVVp4Ji1pKO6VgRldFw7AyYr7wMjDjMbhHCq4P7AR3bw2uAd+jnBbSGPttBj24Z77FulYi4Yyuvdw9Q0Y2TcAlAI2UiegfdqEORUTyRBTJPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=QVsWPFEL; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 797A5406FB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1763563154; bh=sKzE61vBMnr+tqsH97HWCoeKB4wp4Md+kkbG2MxtnSs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QVsWPFELjL3F7dx47jPKOc94uV41EBp2KDX/B8rb6EjYoTnzhxh/PrDEtAF2W8gxl
	 Ktd9CjmVBBgdJ7NrJDkkihWApIP86DYa1Z/adL36PMCmfzh3gVkYOI26yDX9f9sMdb
	 UTvqXtuFKOpmbi5EMHAXq9c5DWglUm5icyt6tqjyheEz9PtIKWL7S4c1Qq5QS4kf42
	 XD5fZjOWv+CoJmlqtA9k/D0WcrnLd3nhsOhFgD5PuVqdUcEhFVpH6uzYuK7eNw8gc/
	 IF3rNppMbpcw1O3FKp13Takoix7arQISDcQtjvR3BLTDsVnG52QtUZPdfh8Ct+XZ7A
	 6XWkdLWD0GSsQ==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 797A5406FB;
	Wed, 19 Nov 2025 14:39:14 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>, Akilesh Kailash
 <akailash@google.com>, bpf@vger.kernel.org, Alexei Starovoitov
 <ast@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
In-Reply-To: <20251104162123.1086035-4-ming.lei@redhat.com>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <20251104162123.1086035-4-ming.lei@redhat.com>
Date: Wed, 19 Nov 2025 07:39:12 -0700
Message-ID: <87346a2ijz.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ming Lei <ming.lei@redhat.com> writes:

> io_uring can be extended with bpf struct_ops in the following ways:

So I have a probably dumb question I ran into as I tried to figure this
stuff out.  You define this maximum here...

> +#define MAX_BPF_OPS_COUNT	(1 << IORING_BPF_OP_BITS)

...which sizes the bpf_ops array:

> +static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];

Later, you do registration here:

> +static int io_bpf_reg_unreg(struct uring_bpf_ops *ops, bool reg)
> +{
> +	struct io_ring_ctx *ctx;
> +	int ret = 0;
> +
> +	guard(mutex)(&uring_bpf_ctx_lock);
> +	list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
> +		mutex_lock(&ctx->uring_lock);
> +
> +	if (reg) {
> +		if (bpf_ops[ops->id].issue_fn)
> +			ret = -EBUSY;
> +		else
> +			bpf_ops[ops->id] = *ops;
> +	} else {
> +		bpf_ops[ops->id] = (struct uring_bpf_ops) {0};
> +	}
> +
> +	synchronize_srcu(&uring_bpf_srcu);
> +
> +	list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
> +		mutex_unlock(&ctx->uring_lock);
> +
> +	return ret;
> +}

Nowhere do I find a test ensuring that ops->id is within range;
MAX_BPF_OPS_COUNT never appears in a test.  What am I missing?

Thanks,

jon

