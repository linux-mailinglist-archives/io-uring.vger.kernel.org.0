Return-Path: <io-uring+bounces-12612-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uIjCM5Tbr2kzdAIAu9opvQ
	(envelope-from <io-uring+bounces-12612-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 09:51:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A00247A4C
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 09:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4A0333032076
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 08:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072793E8C64;
	Tue, 10 Mar 2026 08:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BLJ5rUbB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93F83F23AF
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 08:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773132680; cv=none; b=L3qun9BVsS6mD3ni6r6sqVckvxJKkeVDkptVCW484YZeOOfTxHiJoVMOuNeGL3u9fJA8c02x6GFv4Iv74wO/fqr2v/ne+s15rQEIqRAp1mZ+/ecG+2bRhvKJJcVAkuHz75ZnvS9vBftKgllgawwB+lbka5Rj+P3c919+BOANFeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773132680; c=relaxed/simple;
	bh=Junyxo/AxC0i9kN4JSIPlzik1XZ2+ndba50wnqgyp2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYa6dQJhL7OVb7iH4ZYRUS1xwuqvB6oojjHoz1bzX8Si91C7u8wT573y6L7jtYYlgrgW7jYfxrm4jHnqdanwAask7gdm0pjaqGH1CN8QesSuBjr48pTek5HaHhTjLZEnhRwP6HHO5LAai6GYnCTc0yZi9qB5WdEuWP8SqDV5L1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BLJ5rUbB; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-829928e512aso2728380b3a.2
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 01:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773132679; x=1773737479; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FEIJMcCOSlK/2cej+ULe0a9NbkGx/J/3ZpxAws4xPTk=;
        b=BLJ5rUbBKem18ev3AQCyA8h3kcjGDxTY5bp3h6Akf3fPfbZXkE5HE8H1/8x1qvMzRh
         tQOmlEI82Zl3xV2hN91WOKWehDP3RoMdbUg3dpPcYiZ2MTqonHHMwuI8qOttIsbIPHBz
         t7rGoBUkw5OfVggEVUO8zBQCWRUD2RpO9RBZEyt/1OSKm4PbVvNUcLD1wFDPM1jta0mt
         Jm6j85BQcgtSOjK3ILlbnECADt3MGuYh14nYdiw9jKQTLZ/dQ9/VEYHao2B4efjK2TKh
         Mu0o1Gfdvtb9XXjZKHq0dLzieJ/JwB1p9d22jnOjgxqxlt5jqXiGIyNAjLPnpHN3T5yp
         YIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773132679; x=1773737479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FEIJMcCOSlK/2cej+ULe0a9NbkGx/J/3ZpxAws4xPTk=;
        b=jG8UHsN3mmKQ3zFeQ7gwNKGQ1zf9y0gFwzAInAqDdCPOlzeT/B+hWPWPJFzL1Ps9Ef
         AEcubjA5Ls/A6oW4X29K+bDLvp2HaX8+qVS8hZu96mY/e1M3BMPcCVVllF8/wYn5hvus
         rPulUCRtEoif9Lb10ykDpHL9aIvNVXG7mDbVGBMmuNCbdOIJZ/wk1AEb7j21Ro7plhxw
         bcRtu0m/3m2EtkpubcbSOBGtMbIpgj0naq66eQlyzG4TIs0+FNB53vIVW3z/6/FUEs81
         zJU5rYEBxl5A5wg0jUWb0LsKYfdo1OUg5+ac7spw8DHIEYt531V0HRys1yCT2RxD7XEA
         UG6g==
X-Forwarded-Encrypted: i=1; AJvYcCUFbMFcnvRInRf2bF+NN2xoDrlpjGKhNf772MspxvtoLSjAhhxlQMK4Kazp2ljZyFHtwQgXjtK3Aw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEzA3fY0B0oXZnQA6Vt1B5TaxSHPG7QK8YJ/h6mTMvdG9WNQ7G
	W2TFSOadbpp+MMA+lzWgYn+d4MOP3NE8145UJcZL995Xf9GK9gogyhMyg5JFc7xt
X-Gm-Gg: ATEYQzwl4SNpUn9L46op7J9KwCc1nUyPuYDIxlWOxavozJwx2umKTse27teGqA3KXHJ
	4bieLYv4pE3H9YKLcUKSVUfaTgmsDXscylsMsRFPTM5t77EjDNJLPFqZ/QSCr/MySJpl9DiaccB
	wm9tCKGGR9A5IlIVRd2r/Bup0s1Jlj5FWGva5dWE4AA3HlxsU6xQ7/scb+uOlVq4RyjjQhsgFvG
	VobfeUNZdeVyHZTe6QKXrmi/kx4GepsUclfy+jA5KB4SOBEIzhfCek2ws7TLzgmJBPz3Vx/jZ/S
	oLmg1SJeVtqb1T2W015lr7CoPXxJ7OnKnWlsiHJcYsiz7m5TmIM+ox7D/yEK4pLO5LhPo6P+ziH
	MuZHUklXb637g0zUxx0lvPUMSUp8M9widTDwG+r7ZCdv5ae/s5VxzABWglabl5SSb6sHobi6zDJ
	jMLxNnh33QIcXQW4hZmLaKbCm/Mw9J13g4D0gHDOcveP07Zkc4
X-Received: by 2002:a05:6a21:700a:b0:398:a1ca:7a05 with SMTP id adf61e73a8af0-398a1ca8fd3mr4024883637.51.1773132679179;
        Tue, 10 Mar 2026 01:51:19 -0700 (PDT)
Received: from naup-virtual-machine ([140.113.92.221])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e16cefcsm11171854a12.19.2026.03.10.01.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:51:18 -0700 (PDT)
Date: Tue, 10 Mar 2026 16:51:15 +0800
From: Hao-Yu Yang <naup96721@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, security@kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] io_uring/register.c: fix NULL pointer dereference in
 io_register_resize_rings
Message-ID: <aa/bgyqaRk3W4kIq@naup-virtual-machine>
References: <CAHk-=wi-24g2yzRTHwJ-kD1RqK0TvuPBr0VzvuQVVzR83ddgsw@mail.gmail.com>
 <42AD516A-B078-40A5-94EE-80739B9883E7@kernel.dk>
 <453563bb-8dda-471a-901a-30ba9ff3f9c8@kernel.dk>
 <e9a7152d-3be9-44c2-8626-75ca9da7d408@kernel.dk>
 <CAHk-=wgqyb7M3LZK=+mZOmrS2YDfvh-WKeMeTDCXsoMMkLXfPw@mail.gmail.com>
 <aabe81fa-299e-4b86-be57-933b1f7ce32a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aabe81fa-299e-4b86-be57-933b1f7ce32a@kernel.dk>
X-Rspamd-Queue-Id: 76A00247A4C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12612-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026 at 01:22:10PM -0600, Jens Axboe wrote:
> On 3/9/26 1:03 PM, Linus Torvalds wrote:
> > On Mon, 9 Mar 2026 at 11:35, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> --- a/io_uring/register.c
> >> +++ b/io_uring/register.c
> >> @@ -575,6 +575,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
> >>          * ctx->mmap_lock as well. Likewise, hold the completion lock over the
> >>          * duration of the actual swap.
> >>          */
> >> +       smp_store_release(&ctx->in_resize, 1);
> >>         mutex_lock(&ctx->mmap_lock);
> >>         spin_lock(&ctx->completion_lock);
> > 
> > The store-release doesn't actually make sense here. It just says "this
> > store is visible after all previous stores".
> > 
> > It can still be delayed arbitraritly, and migrate down into the locked
> > regions, and be visible to other cpus much later.
> > 
> > On x86, getting a lock will be a full memory barrier, but that's not
> > true everywhere else: locks keep things *inside* the locked region
> > inside the lock, but don't stop things *outside* the locked region
> > from moving into it.
> > 
> > End result: the smp_store_release does nothing. You should use a write
> > barrier (or a smp_store_mb(), but that's expensive).
> > 
> > But even *that* won't work - because the irq can already be running on
> > another CPU, and maybe it already tested 'in_resize', and saw a zero,
> > and then did that
> > 
> >      atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
> > 
> > afterwards.
> > 
> >> @@ -647,6 +648,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
> >>         if (ctx->sq_data)
> >>                 io_sq_thread_unpark(ctx->sq_data);
> >>
> >> +       smp_store_release(&ctx->in_resize, 0);
> > 
> > On the release side, the store_release would make sense - the store is
> > visible to others after all the other stores are done (including,
> > obviously, the new 'rings' calue)
> > 
> > But see above. This just doesn't *work*, because the irq - running on
> > another cpu - will do the flag test and the cts->rings access as two
> > separate operations.
> > 
> > All these semantics means that 'in_resize' needs to basically be a lock.
> > 
> > You can then use 'trylock()' in irq context *around* the whole
> > sequence of using ctx->rings, to avoid disabling interrupts.
> 
> Agree - I think Pavel's suggestion to use an rcu protected pointer and
> have the resize sync rcu is probably better though. As mentioned, resize
> can be expensive, it's not a hot path operation. the local_work_add()
> path is extremely hot, however.
> 
> I'll take a look with fresh eyes tomorrow.
> 
> -- 
> Jens Axboe

Hello
Yes, crash point is at 

	if (!head) {
		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);

When access &ctx->rings->sq_flags. I removed it accidentally, yesterday.


