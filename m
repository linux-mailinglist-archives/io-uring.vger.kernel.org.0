Return-Path: <io-uring+bounces-12603-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFU3A6EZr2nHNgIAu9opvQ
	(envelope-from <io-uring+bounces-12603-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 20:04:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC5E23F1ED
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 20:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2B07F300DA40
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 19:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E9C34572B;
	Mon,  9 Mar 2026 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4Bt3twn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C866A175A75
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 19:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773083038; cv=none; b=OIojovEP2RMustjA4lNbeiCpKRvwh57mp0g0rirSAQCFdAykAYJ8n0dqDTBNOQO73OETp9ZJ4AukbTA4fIiLF44kYZybAwcrYFTn2ln1LKhX/2h3Yt6Gl9NqA1Iv31m0rgEt/7j8AWt7lr4S1Foz/XCLWix77MqyQPHSRrOMCIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773083038; c=relaxed/simple;
	bh=rwILhUZan+amNqmf+eGyJgqqtLh+qpDNWEGH04ys5Xw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RXnzLuu4uOfljae7okAzXleEYyi263ryJlXH17Je95GVuv0ORrZlYVnfuGcnZv3WtYMTvVLv3Y+h3xW+OVzrGCqqdMe69thHFqdZuOhuvz1NeFSqQlzOsFa9veYB7h7nIJBFT0tC6WpOL2x4KDLpreM0O5asnKjtRyxKJUxPwII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4Bt3twn; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b942424d231so470924266b.0
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 12:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1773083035; x=1773687835; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AN46rwVFm4AOM44t1Drekt08GTwc3bjzYdTKLuL7BI4=;
        b=K4Bt3twnZH3wdp1wQlMnPwrG/xDfYoAYi3fvocQdGp6Mv0VcCNvvAVE3WFPARNp+Pb
         64q6OZFDA8NHEWsb5Qi8Om1beSkfc7bU3sz/8ZBSlrwwpjTJStox/oveQHwcM9XCNp5g
         BIBP7mo+IyQd9UohnopK4i2tTkYjup+25sgyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773083035; x=1773687835;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AN46rwVFm4AOM44t1Drekt08GTwc3bjzYdTKLuL7BI4=;
        b=FnHu31WlZ23TegWuupJ0H7RSo0fAab3x2swSYg0qLvyMPoaeyU2E/kgrDM/+DB09ba
         x59zeir5dFk8bg6wKKREjTpFmJDNa35jswDIBxY79V8mHu/eGfMtPSYV41bxkYBHyPpv
         5ePWxByUcYaABichX0GxklxREB6S2JPIotIw1ZrxInYpesAwaCLVQbsPaoYP6MfTzxM2
         cm68vSaAK5gi0eeNj5O4gRMMsHcpCJLLKPQr2sAxn3m/gQVwhAmfjRu44tTGijtVIkUk
         5c7vE2l/btD17rtL2FyqV8Pe4S+v1mQhkWPkvtDj+ahR2ZqdSr3lUSnGFhcWuxWp+cjP
         NHKA==
X-Forwarded-Encrypted: i=1; AJvYcCXHe2fWV/+ZL3r9AKJ65cH4QcuZgQWBz2u8GZ1cx9offxKz3sHUK7KGpUkoasnScH0hlY4baLvgMA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyViIXyanJ3R4YF98pUbZKHg6AzOLf3sBP+QaIvUOfwIKdw7XNn
	1whTItLI5NUp12k9OD7HybRhRWsI4LkhhrSydgQbsF/2kfYkZOfeoBzrrMcvZbK2sOqeFvOz9e9
	Qp1tGq2UAFQ==
X-Gm-Gg: ATEYQzxd00EdP1FSWH0OdEpv8CJEyYaij3v9tcJ6AiVNihpt7zToo6q/ybJfaBTpekS
	M5c2kMOpLCTHoQ2XxjyOD8pgYeG2H/gBJaGoL6nXg9pKZwFQNlCb3n1HF4X9zoooEiu9d9AuDB4
	oH9IeMrfDMI8p7W3usb3fpnIAEP/sDjRfRYyC2wI/rqs2F9wuN9yXku8qnFHNrJuw1VbGAom2c9
	raaDWx5uiUYKJPqAWRV6S4udqK7uH5LEZzFkYRgyie3TRcexP5I8yn2xHwQHUeBl4tgN5EghE9J
	bXwEp4BLu2ZLtcSh2T9lo/fyMnO7E6KcCQsTSP9PaDKxseKCtZw3goQQlu3E7CQHLAs+YnHPqSL
	eua4WJ8u2YE2PgV15evGV2uUztdLaQnCE/Px8jB+/IIQzKB2SZGgyDKaHJW8Jqt6SyKVfu0xyuq
	wQAb3SNdwth+E6pfTflOoHWV24ON7Su+/KJ8USdSctAr3mX7X+D+EDsQhIMYr6NsmrqXcY71M=
X-Received: by 2002:a17:907:94ca:b0:b96:ee7e:a66d with SMTP id a640c23a62f3a-b96ee7eb170mr306726466b.59.1773083034652;
        Mon, 09 Mar 2026 12:03:54 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942f13a3afsm409059766b.40.2026.03.09.12.03.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 12:03:54 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b96d784828bso289197866b.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 12:03:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVPBAkP+lxbfuJyMsvGgQQuxrd23uGM7RAfOfYCYC0FLXJ5WNWVuA3K55IGKDez+yAfpPlwVwPpgQ==@vger.kernel.org
X-Received: by 2002:a17:907:961d:b0:b73:2b08:ac70 with SMTP id
 a640c23a62f3a-b942e01dec5mr664086466b.49.1773083034035; Mon, 09 Mar 2026
 12:03:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=wi-24g2yzRTHwJ-kD1RqK0TvuPBr0VzvuQVVzR83ddgsw@mail.gmail.com>
 <42AD516A-B078-40A5-94EE-80739B9883E7@kernel.dk> <453563bb-8dda-471a-901a-30ba9ff3f9c8@kernel.dk>
 <e9a7152d-3be9-44c2-8626-75ca9da7d408@kernel.dk>
In-Reply-To: <e9a7152d-3be9-44c2-8626-75ca9da7d408@kernel.dk>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Mon, 9 Mar 2026 12:03:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgqyb7M3LZK=+mZOmrS2YDfvh-WKeMeTDCXsoMMkLXfPw@mail.gmail.com>
X-Gm-Features: AaiRm53MY1MOcz8Gor__drnYc-ZpbeH_-ZI8u8KuP5BY2aDE9nyVEQOlYcLII70
Message-ID: <CAHk-=wgqyb7M3LZK=+mZOmrS2YDfvh-WKeMeTDCXsoMMkLXfPw@mail.gmail.com>
Subject: Re: [PATCH v1] io_uring/register.c: fix NULL pointer dereference in io_register_resize_rings
To: Jens Axboe <axboe@kernel.dk>
Cc: Hao-Yu Yang <naup96721@gmail.com>, security@kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5BC5E23F1ED
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12603-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[torvalds@linuxfoundation.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid,kernel.dk:email,linuxfoundation.org:dkim]
X-Rspamd-Action: no action

On Mon, 9 Mar 2026 at 11:35, Jens Axboe <axboe@kernel.dk> wrote:
>
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -575,6 +575,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>          * ctx->mmap_lock as well. Likewise, hold the completion lock over the
>          * duration of the actual swap.
>          */
> +       smp_store_release(&ctx->in_resize, 1);
>         mutex_lock(&ctx->mmap_lock);
>         spin_lock(&ctx->completion_lock);

The store-release doesn't actually make sense here. It just says "this
store is visible after all previous stores".

It can still be delayed arbitraritly, and migrate down into the locked
regions, and be visible to other cpus much later.

On x86, getting a lock will be a full memory barrier, but that's not
true everywhere else: locks keep things *inside* the locked region
inside the lock, but don't stop things *outside* the locked region
from moving into it.

End result: the smp_store_release does nothing. You should use a write
barrier (or a smp_store_mb(), but that's expensive).

But even *that* won't work - because the irq can already be running on
another CPU, and maybe it already tested 'in_resize', and saw a zero,
and then did that

     atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);

afterwards.

> @@ -647,6 +648,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>         if (ctx->sq_data)
>                 io_sq_thread_unpark(ctx->sq_data);
>
> +       smp_store_release(&ctx->in_resize, 0);

On the release side, the store_release would make sense - the store is
visible to others after all the other stores are done (including,
obviously, the new 'rings' calue)

But see above. This just doesn't *work*, because the irq - running on
another cpu - will do the flag test and the cts->rings access as two
separate operations.

All these semantics means that 'in_resize' needs to basically be a lock.

You can then use 'trylock()' in irq context *around* the whole
sequence of using ctx->rings, to avoid disabling interrupts.

                Linus

