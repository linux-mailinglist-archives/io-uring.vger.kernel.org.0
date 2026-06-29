Return-Path: <io-uring+bounces-13850-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id qPoxAtrZQmo8EwoAu9opvQ
	(envelope-from <io-uring+bounces-13850-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2026 22:47:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A536DEB47
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2026 22:47:21 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VzXEKYW9;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13850-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13850-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A0FE9302BE10
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2026 20:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D2838B7A1;
	Mon, 29 Jun 2026 20:47:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6FA3803C5
	for <io-uring@vger.kernel.org>; Mon, 29 Jun 2026 20:47:14 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782766036; cv=pass; b=k1XFI8NXk3MT81592A/bsLjJQ5j4gR3dbtBSJn7P7Z7I6F/3sfrAbLnZUmjSHvfa+UAcgfT4QYKVTuZYYfmZtmvgfGTByKaENb/CeXs97M9lel01gecb0pgPAJoO0d6iaJfIPcyPp98ztw86H+valqYtEJM6Ey9gix+MHcziE4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782766036; c=relaxed/simple;
	bh=kyjLFeUS/nye3+QWqmmUsO3ckyuCK5LNK0QWCT7OQjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nEC/6UHFURt8g/cY7ZKPgdPZDPslmOqFThWsDPjitQ1D2AtowFKAxVINEPxNz8CCxMd5nqcbe6cMe0LIhsCrhkEP+XBhoh3zRvg6BZ4gkRku3sXz4k4peLeCb8Y8pAKrOc2694RLJQBEPMuqxVZaTRI76LMWNnDdrR2wFQfwCC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VzXEKYW9; arc=pass smtp.client-ip=209.85.167.43
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aeb91c003eso1298791e87.3
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2026 13:47:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782766032; cv=none;
        d=google.com; s=arc-20260327;
        b=APJbwG5iGyNjmjFrBu0pjxK7PJkrRu/EQJ+zV/x1sCcj+yKZmh1wEeORTvTGsRspEy
         1Qpr0ofmpwiKLZYUr/TgX9MpOAqahcaBupX5vzNNzjMdAjV3nOEXFIlgOa5zGy3Y8gpN
         CwBWbrji9tJYWy9L2dBt1QsrZqIrQUcVyjmmK4vH9KJVYAVv47BQjistDt/EqLYLC23b
         wRs55+gzF3GwrC7N8UxpA/riz77h+luUYv061mLHTJsjEF6A+y2KNcjQOQWns00HksG7
         k4t6E3X8EH0c75iWOI8up5O4UovdEtnsWs3mBvYuS3kYPYBK4Ka2gi9LyruC8HNDvSGa
         dk2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z1hO+xSCWbLdhcLWSupY6siL4tHjnL8cHYR5eRRce5o=;
        fh=2Vp2m2qbrvADcae2wBg2xANxhesd3MAKAUIhmEv1vxY=;
        b=Lwv80PmTigzcdAD1bFXMldZYpMolRwE/f4RLylqIQAnKGHaTAqzamvTWSlnXC+LtfK
         JnO78Bj8QoUDg3+RnpQ1Sk3/dnjLS4LR1TXSCWYllX0h/t+3VN29ZRw/nP+wg5tAtRnY
         bwnyFa7Ix743UZBptmR3hK90HEf5U/JhkGvuNVyGBTV9jfOmg9ChMky0s1rdNbED+eVP
         bt05/lr8vEucksYsXdUzxGJ5w8HM9/IqrRWvr9inSybN4A1koo7nYYH7v6koqT1TYyOH
         z65fhcSuZU0p9PVGDktYUbwF44sNOgEzkhx3U+9nr4vicF9QGX/q8RbPuvKcpLfQ/S0x
         aWJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782766032; x=1783370832; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1hO+xSCWbLdhcLWSupY6siL4tHjnL8cHYR5eRRce5o=;
        b=VzXEKYW9zJqJH0w/3z2gtLV2EP/JTJ1IrJL4WHJo6xOrxudtoYcQ4Rjot1MWgHvS86
         CYuodkPBw30V5IsRGEXbUPWyh+IrBy40mu9Kd/dp1k1qRUBtkc8fOxIqNhbCoXB0IGpT
         3X+yXq/NuHk0lUF/kzvyW46k4ryqWq83y9y6at6m3TLpE/WwGSS9vd8ghtOiPOqxt6Bh
         F7HALq7aoFp1BOtUxwilI5HrhM9BmX8h72jA226VWJAAoe4jBzEKqZGJBSShgAZ28Aui
         7AcVK+X6VsB3FWp+K3D/hWWToOxoajs4KTmJ6JBbcyGy+7ErnVaPg285s1Xp2PvYLa61
         sayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782766032; x=1783370832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z1hO+xSCWbLdhcLWSupY6siL4tHjnL8cHYR5eRRce5o=;
        b=F82O/aJRAAJTQXfv+iCamI2dMBZf5XetDBteBbLsYIjRZO6QMCWko4WyALj9c8aj1C
         2Ka6EDKAmajFud9B+fEDTVmQzCGC86N6Uq0CVtf8rPIOz3jzQBjYysa1hTlq1OeIWZ34
         UD4qSDRRT5HGmVKoL5G2Jp9ZhArw6RgbskhLBjKuCP8r9BzQPEd5PYie2B5uRMKRBG0n
         0Msrv+cco+ZAZnERiTyAqJRE96cY9nedW5wJ1K6nSMIDEuZl2I5+E+q2QjBrRgwO6lcL
         HfUEupWDy8TJe55TOoX2SlDo/oOZ6HmfbendJ3fQ4ka7cS3R3ZYpTO00ZqKnbb7slm4v
         hSxw==
X-Forwarded-Encrypted: i=1; AHgh+Rq6n6uEalDN+mNQpdCHCNpMayiWzWtGQIEm3fCAbTvGiSLMA0bxwE1HshXKPUwPJCrS9EazEIaosg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/yz2VpCpZWfqMQSWVpDKL71xsRmP+/dZzXFNu31TL7xGKRIjt
	DTY2caPsUXEXefcAJ/54lZwGRXFuSNe9AgwllyINf8gtm02mzNAmqVevobyk6cdEgPfQOiYJnLj
	0yJqjD/UwYd8Eu2SlBRrMQNsch83zQNc=
X-Gm-Gg: AfdE7ckFbkl75cid2m983S6fzV3ChERjLPT3O5EtVJqe9o+hS64YQeXQwyVBSesRalk
	E6eA3KgSiZxxA8JT3qLB3xJ3QCYuodPeUiE3RSBm6hd3EI2hL21suEkPeiDeaaLE6gbfwv4KoFl
	D9HuhlOhC4Z/OhV3Gchs2EOOo+SYe2WAs1OUtmcxUGbZkRRZv9A3nHuOvgKTP/gkaq+GZg8xuJD
	q5TYu9RpdrGo+KmriTEf6wHnrK8dAZxcm7K1OuGyWk9r8/0Sk99hub98dwAOGWv6zkJNNrx70io
	X/UwHu+otiFhyl1TFhlxufKtXh9PVZ7ClGRu2vMWYw==
X-Received: by 2002:ac2:4906:0:b0:5ae:bd76:4981 with SMTP id
 2adb3069b0e04-5aebdb7d464mr148307e87.12.1782766032339; Mon, 29 Jun 2026
 13:47:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk> <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk> <aj6p3kZy1a8Mf68S@kbusch-mbp>
In-Reply-To: <aj6p3kZy1a8Mf68S@kbusch-mbp>
From: Ben Carey <benjamin.james.carey3@gmail.com>
Date: Mon, 29 Jun 2026 16:47:00 -0400
X-Gm-Features: AVVi8CfrkNqauou8hKzkE5BQjWkfxlt7JZqjj0VyWtOYNgyciREmjZR6QGCYUZQ
Message-ID: <CA+KFGSpgN7DChCfMK4itc39MB9ubxacbY3sWTByOkG58umvPkQ@mail.gmail.com>
Subject: Re: [BUG] RCU hang with io_uring nvme polling
To: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:kbusch@kernel.org,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13850-lists,io-uring=lfdr.de];
	FORGED_SENDER(0.00)[benjaminjamescarey3@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[benjaminjamescarey3@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 57A536DEB47

On Fri, Jun 26, 2026 at 12:33=E2=80=AFPM Keith Busch <kbusch@kernel.org> wr=
ote:
> The test has 1 polling queue with 2 jobs dispatching. One of the job's
> polled the completions for both. The other job is polling for no reason
> at all with nothing outstanding. The only thing that can break us out of
> that loop now is need_resched(), but that appears to never return true.

Inspired by this I tried to find a place where one thread polls on a job th=
at's
already finished. I found that a race to io_check_iopoll causes one thread =
to
enter the polling loop when another has already finished on it. Putting
io_check_iopoll behind a spinlock seems to fix it, though I imagine a more
elegant fix is out there (reusing a different lock, not using expensive loc=
ks,
a smarter place to check for racing, etc.)

The diff is as follows:

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.=
h
index 214fdbd49..e4f76fa74 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -406,6 +406,7 @@ struct io_ring_ctx {
        } ____cacheline_aligned_in_smp;

        spinlock_t              completion_lock;
+       spinlock_t              cq_poll_lock;

        struct list_head        cq_overflow_list;

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4d7bcbb97..b65e2b11a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -272,6 +272,7 @@ static __cold struct io_ring_ctx
*io_ring_ctx_alloc(struct io_uring_params *p)
        init_waitqueue_head(&ctx->cq_wait);
        init_waitqueue_head(&ctx->poll_wq);
        spin_lock_init(&ctx->completion_lock);
+       spin_lock_init(&ctx->cq_poll_lock);
        raw_spin_lock_init(&ctx->timeout_lock);
        INIT_LIST_HEAD(&ctx->iopoll_list);
        INIT_LIST_HEAD(&ctx->defer_list);
@@ -1243,7 +1244,13 @@ static int io_iopoll_check(struct io_ring_ctx
*ctx, unsigned int min_events)
                        if (tail !=3D ctx->cached_cq_tail ||
list_empty(&ctx->iopoll_list))
                                break;
                }
-               ret =3D io_do_iopoll(ctx, !min_events);
+               if (spin_trylock(&ctx->cq_poll_lock)) {
+                       ret =3D io_do_iopoll(ctx, !min_events);
+                       spin_unlock(&ctx->cq_poll_lock);
+               } else {
+                       ret =3D 0;
+               }
+
                if (unlikely(ret < 0))
                        return ret;

Best wishes,
Ben Carey

