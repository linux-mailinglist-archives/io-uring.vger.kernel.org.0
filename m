Return-Path: <io-uring+bounces-12892-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QIlBDiFJy2l8FQYAu9opvQ
	(envelope-from <io-uring+bounces-12892-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 06:10:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 61ED2363D8A
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 06:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6954C3041A42
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 04:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D628D28AAEB;
	Tue, 31 Mar 2026 04:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/IvsqJu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4144A28C84A
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 04:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774929837; cv=pass; b=taPiTthaRnjfHMCf1hIX8K4C7vRoWgeVXkAWu1K2qXIQnP2rFQyp5vR0yJeuJdqBCeFUx3mucDm+A3FNuxjUI2JFF67sNPBgXk7xL7ospoWyO8N6jtgElE2O48NwZfI0h7gIy5R7sKSgEdhjtjmLMqEfVTVAIjRsJFwn9gIZCZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774929837; c=relaxed/simple;
	bh=P9CGErQ3bmwPzSYp8TQ7aV3ll5NmyROm5938YbnYtVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=n7y/3MGBA7iK3NMHy05mUBS1cyMLPHJhlsr0E1WQ0V8MH2JUZskzgX8gZrqWn1f9Pzn0BytRL6frbAuPO97Ygxma+IhivCq4XWD23lGzFk3slr/DOEWH+QCqPx2Y/2rCSlnWQT+rSTEiG1rmMoYfmjTvInXq1kSKIq/wGL9+gPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W/IvsqJu; arc=pass smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c76af7b0f94so314156a12.1
        for <io-uring@vger.kernel.org>; Mon, 30 Mar 2026 21:03:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774929836; cv=none;
        d=google.com; s=arc-20240605;
        b=cTZbDbnsQTYAZY0vXBdK1ZxvnER954i7FTXKobVEyvSBYF8NqSNjyZYjr33pJNCAZQ
         prdj+YIFs3FEHmhIi3V0rMCb0COZ/PPu7ucZw/OUfDcG0cXQb6a0JVrWF4saN5h1gmu3
         JNggwcbH2sD/Tywp5mZcFFHeKpUNDumov3hsfgFrjKeFMrkpwt91wWL47BU4twYHmfxZ
         R2DAjvLpZMLthoaA1mX2/MtED67Ybfh1NQRqw1RNBs9CEU/HqD24wcvAybWbr6wtY8zR
         5tOHySzRbKsAloRMMPToOF2lGBJc3gMxZIXpnd57x2JXb4Za/GMAlZputvq65tbolRq5
         r+ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P+nxlHG2L7C07x1XwYslkb9zZm/TmLIQGCC7tzgrkt8=;
        fh=loXlXTglV1wpKucxOW5YrldhCnmJBYTMfhc/8bNDM4Q=;
        b=IpZlDZfApayaY9r35Nrj4kYgvB23AQvcY+tt0IplmMfVbLxnRji6FZzTHEzYybMpak
         Vr3SxUNQ6wZlT3xH/QH1IULStvwEjqi/IsCzuDiQ9XN0kaps1tQT1IKsOjvCNOdRtcrg
         B6wGk1nk5q0GL2YAGuemRaio0YcPeAKhFzoaKeXRIFteEQpbz1sI20mvQXRHSDFeOFXh
         /DrdCzHfkHLulP99cpGqT5/gJLZEpAZFwH7uewBfBLFrzPsabRMWr45tBzyATVv/nrft
         NJTWH7+InFGV7b/XeRA6M1wr3A6ibdwX2YWCpfxoW/sK04dlM82hidhUFDvuO4SzNYft
         svYA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774929836; x=1775534636; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+nxlHG2L7C07x1XwYslkb9zZm/TmLIQGCC7tzgrkt8=;
        b=W/IvsqJu3+ujKDXpPhx69GNS1vRJFuSSoX5tiQxeDAfZBFoRcpUjWxdsDw2wVb/+Bz
         lR7z6ow9qFKRhzAHsX1bJPSa0xbhrdSy9C7XnzXM/hsPSGhvgAI5kbloHxcHc9juLijP
         bl4aeOOIdju7WKjaB0tj/8BgwBBBrEZkzGW0Zd5G41UMpriIcrKYbQZuc6DzeoNYrQur
         Ervhp8Jcu26n7As6ABElDkYXt1ijvlPaUKIi4syhEiNjUYIn8Kw18dyiIiL8fAnmGSLz
         UK1pmyaCQeA1hbN04eUjfYYPTRY+SzEJMTVhhPdfRTwoWvCPB8tDbxju15bsuIxvkSgC
         ocXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774929836; x=1775534636;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P+nxlHG2L7C07x1XwYslkb9zZm/TmLIQGCC7tzgrkt8=;
        b=lrTnm2q0skAY18MPLHXq3SL3nX1TorED2kPTt0bPQZQwoqlNrVD3jbxVwOB5SUVvhA
         4StUVWYNpJd2ak55Z6YW4u+gdC72d8OZklSx/ZsryOyEDbPzi3MKrSN6X5cs/hymbJLD
         LwOEJ3WcvKV9X/F6ui96qHqd8Ex9Zl58VzycKHzgoI13b+X5Bw6zxkVEkKv53pQJTUKx
         Lckb4JOMXfi7xF/Qs4oWanUb/JtxzdW7Cn6PDK5cR5q9eJFLnBz9+93VcLvL7E0zLuyJ
         F9T5F6ZA2QToU67tDcRZWzPR2Zw5T3YSbvnrVbgtUTO+e0TYrwQmo+jX2DiTzeFjmRTf
         qzZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUON0DEJT9OAf0bbOy+AUsWbhoIxpLs+aX4p6yCgECcs1tRe69RVzv0g8P2sU6ZCnlLF8mSLj0R9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcVlzwbCQ56ILE6npOaQAG66eefUnXImRdNsuHhZPavmVqhsvN
	gFDg2kdCUNv4f2vfZGIRkCthJf9L48QgJPs+Gl9OlgvnLt/bgz68+5NQ099Uv3YAzjAuhYFTJaK
	bAuUUIkTZMaLL9uIubRvjSeDiLlZTey9VLbI47U8=
X-Gm-Gg: ATEYQzzyIvYpIkuJK+5YXpgMH071sNshgVRH9od35Ey4KJeC2bfySR2zI8qtYykrwOr
	GHxJs3pQ84Uvt8ods9Zi1TFBpZzgQ5NI639F/shhsBTkt5MbX5H33EQJ29VimRP22N1nNWLgjhO
	A/XrXSN9pAco+G5V5uXBLTk/9fpzrjtrQzuCyQO0A7zUkIZa3y1hmTpNy8zm3/a3Vnt+cBoA73C
	jGwplj3zivMAGPagALn2IhEQiEr3EgGAt5nfziMhZUx2cbJXJdeXl4U4FLGonHIr6YbJmeDcuff
	q9c021e4
X-Received: by 2002:a05:6a20:9143:b0:38b:dec8:9da2 with SMTP id
 adf61e73a8af0-39c87915773mr17147315637.26.1774929835312; Mon, 30 Mar 2026
 21:03:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260330172348.89416-1-qjx1298677004@gmail.com> <a0c448c5-8fe8-43e8-a8ec-17f5912a4bc4@kernel.dk>
In-Reply-To: <a0c448c5-8fe8-43e8-a8ec-17f5912a4bc4@kernel.dk>
From: junxi qian <qjx1298677004@gmail.com>
Date: Tue, 31 Mar 2026 12:03:45 +0800
X-Gm-Features: AQROBzAVjt4341SulGhCyELZFjDgGfc1y1LksGBLkJlHBenVQcTkCGnIN6KKaNk
Message-ID: <CAAkLyHT_6Wvucnt6kOV=ec2qsUzEkAdrLVp0XZf3WOXdfsRNgQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: protect remaining lockless ctx->rings accesses
 with RCU
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12892-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[qjx1298677004@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 61ED2363D8A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Looks good, thanks for the rework!

I applied this on top of v7.0-rc5, compiled with KASAN enabled, and
ran the resize + poll() race reproducer - no KASAN splat triggered.

Reviewed-by: Junxi Qian <qjx1298677004@gmail.com>
Tested-by: Junxi Qian <qjx1298677004@gmail.com>

On Tue, Mar 31, 2026 at 2:08=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/30/26 11:23 AM, Junxi Qian wrote:
> > io_register_resize_rings() briefly sets ctx->rings to NULL under
> > completion_lock before assigning the new rings and publishing them
> > via rcu_assign_pointer(ctx->rings_rcu, ...).  Several code paths
> > read ctx->rings without holding any of those locks, leading to a
> > NULL pointer dereference if they race with a resize:
> >
> >   - io_uring_poll()              (VFS poll callback)
> >   - io_should_wake()             (waitqueue wake callback)
> >   - io_cqring_min_timer_wakeup() (hrtimer callback)
> >   - io_cqring_wait()             (called from io_uring_enter)
> >
> > Commit 96189080265e only addressed io_ctx_mark_taskrun() in tw.c.
> > Protect the remaining sites by reading ctx->rings_rcu under
> > rcu_read_lock() (via guard(rcu)/scoped_guard(rcu)) and treating a
> > NULL rings as "no data available / force re-evaluation".
>
> First of all, thanks for the patch!
>
> I took a look at this, but I'm not a huge fan of the scoped guard in
> most spots, it just makes it harder to read. And I think that building
> on top of this for later kernels will make sense, so cleaner to add some
> helpers. Outside of that, the wait side can be a bit smarter rather than
> just wrap everything in rcu multiple times (eg the nr_wait part).
>
> There also should be no need to check 'rings' for NULL, it'll always be
> a valid value.
>
> How about something like this instead?
>
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 16122f877aed..079b37835833 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2017,7 +2017,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigne=
d int nr)
>         if (ctx->flags & IORING_SETUP_SQ_REWIND)
>                 entries =3D ctx->sq_entries;
>         else
> -               entries =3D io_sqring_entries(ctx);
> +               entries =3D __io_sqring_entries(ctx);
>
>         entries =3D min(nr, entries);
>         if (unlikely(!entries))
> @@ -2253,7 +2253,9 @@ static __poll_t io_uring_poll(struct file *file, po=
ll_table *wait)
>          */
>         poll_wait(file, &ctx->poll_wq, wait);
>
> -       if (!io_sqring_full(ctx))
> +       rcu_read_lock();
> +
> +       if (!__io_sqring_full(ctx))
>                 mask |=3D EPOLLOUT | EPOLLWRNORM;
>
>         /*
> @@ -2273,6 +2275,7 @@ static __poll_t io_uring_poll(struct file *file, po=
ll_table *wait)
>         if (__io_cqring_events_user(ctx) || io_has_work(ctx))
>                 mask |=3D EPOLLIN | EPOLLRDNORM;
>
> +       rcu_read_unlock();
>         return mask;
>  }
>
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 91cf67b5d85b..5c47ed0b4276 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -142,16 +142,28 @@ struct io_wait_queue {
>  #endif
>  };
>
> +static inline struct io_rings *io_get_rings(struct io_ring_ctx *ctx)
> +{
> +       return rcu_dereference_check(ctx->rings_rcu,
> +                       lockdep_is_held(&ctx->uring_lock) ||
> +                       lockdep_is_held(&ctx->completion_lock));
> +}
> +
>  static inline bool io_should_wake(struct io_wait_queue *iowq)
>  {
>         struct io_ring_ctx *ctx =3D iowq->ctx;
> -       int dist =3D READ_ONCE(ctx->rings->cq.tail) - (int) iowq->cq_tail=
;
> +       struct io_rings *rings;
> +       int dist;
> +
> +       guard(rcu)();
> +       rings =3D io_get_rings(ctx);
>
>         /*
>          * Wake up if we have enough events, or if a timeout occurred sin=
ce we
>          * started waiting. For timeouts, we always want to return to use=
rspace,
>          * regardless of event count.
>          */
> +       dist =3D READ_ONCE(rings->cq.tail) - (int) iowq->cq_tail;
>         return dist >=3D 0 || atomic_read(&ctx->cq_timeouts) !=3D iowq->n=
r_timeouts;
>  }
>
> @@ -431,9 +443,9 @@ static inline void io_cqring_wake(struct io_ring_ctx =
*ctx)
>         __io_wq_wake(&ctx->cq_wait);
>  }
>
> -static inline bool io_sqring_full(struct io_ring_ctx *ctx)
> +static inline bool __io_sqring_full(struct io_ring_ctx *ctx)
>  {
> -       struct io_rings *r =3D ctx->rings;
> +       struct io_rings *r =3D io_get_rings(ctx);
>
>         /*
>          * SQPOLL must use the actual sqring head, as using the cached_sq=
_head
> @@ -445,9 +457,15 @@ static inline bool io_sqring_full(struct io_ring_ctx=
 *ctx)
>         return READ_ONCE(r->sq.tail) - READ_ONCE(r->sq.head) =3D=3D ctx->=
sq_entries;
>  }
>
> -static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
> +static inline bool io_sqring_full(struct io_ring_ctx *ctx)
>  {
> -       struct io_rings *rings =3D ctx->rings;
> +       guard(rcu)();
> +       return __io_sqring_full(ctx);
> +}
> +
> +static inline unsigned int __io_sqring_entries(struct io_ring_ctx *ctx)
> +{
> +       struct io_rings *rings =3D io_get_rings(ctx);
>         unsigned int entries;
>
>         /* make sure SQ entry isn't read before tail */
> @@ -455,6 +473,12 @@ static inline unsigned int io_sqring_entries(struct =
io_ring_ctx *ctx)
>         return min(entries, ctx->sq_entries);
>  }
>
> +static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
> +{
> +       guard(rcu)();
> +       return __io_sqring_entries(ctx);
> +}
> +
>  /*
>   * Don't complete immediately but use deferred completion infrastructure=
.
>   * Protected by ->uring_lock and can only be used either with
> diff --git a/io_uring/wait.c b/io_uring/wait.c
> index 0581cadf20ee..c24d018d53ab 100644
> --- a/io_uring/wait.c
> +++ b/io_uring/wait.c
> @@ -79,12 +79,15 @@ static enum hrtimer_restart io_cqring_min_timer_wakeu=
p(struct hrtimer *timer)
>         if (io_has_work(ctx))
>                 goto out_wake;
>         /* got events since we started waiting, min timeout is done */
> -       if (iowq->cq_min_tail !=3D READ_ONCE(ctx->rings->cq.tail))
> -               goto out_wake;
> -       /* if we have any events and min timeout expired, we're done */
> -       if (io_cqring_events(ctx))
> -               goto out_wake;
> +       scoped_guard(rcu) {
> +               struct io_rings *rings =3D io_get_rings(ctx);
>
> +               if (iowq->cq_min_tail !=3D READ_ONCE(rings->cq.tail))
> +                       goto out_wake;
> +               /* if we have any events and min timeout expired, we're d=
one */
> +               if (io_cqring_events(ctx))
> +                       goto out_wake;
> +       }
>         /*
>          * If using deferred task_work running and application is waiting=
 on
>          * more than one request, ensure we reset it now where we are swi=
tching
> @@ -186,9 +189,9 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_e=
vents, u32 flags,
>                    struct ext_arg *ext_arg)
>  {
>         struct io_wait_queue iowq;
> -       struct io_rings *rings =3D ctx->rings;
> +       struct io_rings *rings;
>         ktime_t start_time;
> -       int ret;
> +       int ret, nr_wait;
>
>         min_events =3D min_t(int, min_events, ctx->cq_entries);
>
> @@ -201,15 +204,23 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min=
_events, u32 flags,
>
>         if (unlikely(test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)))
>                 io_cqring_do_overflow_flush(ctx);
> -       if (__io_cqring_events_user(ctx) >=3D min_events)
> +
> +       rcu_read_lock();
> +       rings =3D io_get_rings(ctx);
> +       if (__io_cqring_events_user(ctx) >=3D min_events) {
> +               rcu_read_unlock();
>                 return 0;
> +       }
>
>         init_waitqueue_func_entry(&iowq.wq, io_wake_function);
>         iowq.wq.private =3D current;
>         INIT_LIST_HEAD(&iowq.wq.entry);
>         iowq.ctx =3D ctx;
> -       iowq.cq_tail =3D READ_ONCE(ctx->rings->cq.head) + min_events;
> -       iowq.cq_min_tail =3D READ_ONCE(ctx->rings->cq.tail);
> +       iowq.cq_tail =3D READ_ONCE(rings->cq.head) + min_events;
> +       iowq.cq_min_tail =3D READ_ONCE(rings->cq.tail);
> +       nr_wait =3D (int) iowq.cq_tail - READ_ONCE(rings->cq.tail);
> +       rcu_read_unlock();
> +       rings =3D NULL;
>         iowq.nr_timeouts =3D atomic_read(&ctx->cq_timeouts);
>         iowq.hit_timeout =3D 0;
>         iowq.min_timeout =3D ext_arg->min_time;
> @@ -240,14 +251,6 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_=
events, u32 flags,
>         trace_io_uring_cqring_wait(ctx, min_events);
>         do {
>                 unsigned long check_cq;
> -               int nr_wait;
> -
> -               /* if min timeout has been hit, don't reset wait count */
> -               if (!iowq.hit_timeout)
> -                       nr_wait =3D (int) iowq.cq_tail -
> -                                       READ_ONCE(ctx->rings->cq.tail);
> -               else
> -                       nr_wait =3D 1;
>
>                 if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>                         atomic_set(&ctx->cq_wait_nr, nr_wait);
> @@ -298,11 +301,20 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min=
_events, u32 flags,
>                         break;
>                 }
>                 cond_resched();
> +
> +               /* if min timeout has been hit, don't reset wait count */
> +               if (!iowq.hit_timeout)
> +                       scoped_guard(rcu)
> +                               nr_wait =3D (int) iowq.cq_tail -
> +                                               READ_ONCE(ctx->rings_rcu-=
>cq.tail);
> +               else
> +                       nr_wait =3D 1;
>         } while (1);
>
>         if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>                 finish_wait(&ctx->cq_wait, &iowq.wq);
>         restore_saved_sigmask_unless(ret =3D=3D -EINTR);
>
> -       return READ_ONCE(rings->cq.head) =3D=3D READ_ONCE(rings->cq.tail)=
 ? ret : 0;
> +       guard(rcu)();
> +       return READ_ONCE(ctx->rings_rcu->cq.head) =3D=3D READ_ONCE(ctx->r=
ings_rcu->cq.tail) ? ret : 0;
>  }
> diff --git a/io_uring/wait.h b/io_uring/wait.h
> index 037e512dd80c..a4274b137f81 100644
> --- a/io_uring/wait.h
> +++ b/io_uring/wait.h
> @@ -29,12 +29,15 @@ void io_cqring_overflow_flush_locked(struct io_ring_c=
tx *ctx);
>
>  static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
>  {
> -       return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
> +       struct io_rings *rings =3D io_get_rings(ctx);
> +       return ctx->cached_cq_tail - READ_ONCE(rings->cq.head);
>  }
>
>  static inline unsigned int __io_cqring_events_user(struct io_ring_ctx *c=
tx)
>  {
> -       return READ_ONCE(ctx->rings->cq.tail) - READ_ONCE(ctx->rings->cq.=
head);
> +       struct io_rings *rings =3D io_get_rings(ctx);
> +
> +       return READ_ONCE(rings->cq.tail) - READ_ONCE(rings->cq.head);
>  }
>
>  /*
>
> --
> Jens Axboe

