Return-Path: <io-uring+bounces-13136-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Z8VCgYB62kzHQAAu9opvQ
	(envelope-from <io-uring+bounces-13136-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 07:35:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 606BC459ED8
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 07:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87957300DDFE
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 05:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B43B33E35F;
	Fri, 24 Apr 2026 05:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGuTI9mc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E0F224AF1
	for <io-uring@vger.kernel.org>; Fri, 24 Apr 2026 05:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777008898; cv=none; b=szCWR9Nl+VZnYpwyYtOfA+TDtNNy2xLz664lnc/YmLpm3RMzVpmbj04uFDbwk8R3bg4lFTzwexW+IcM/u5ES5vtqRFA9siCQIY1/SNMMxR6MxvV6qE1d5YzM1r+Ut80x9f4SXWOLx/Q71qGJeWgpsvl8oJkyBYiWWXGIRUsOCrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777008898; c=relaxed/simple;
	bh=eaFxle09HZ3Mi3TWmETPK/MUer+eZZmUd6julWVZ/aY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ClfnLA/8/LjMA6HDrFc5/D+ySQVgLd9/BRDK8sfE/eVltKXXNdXXCubIDILnxVNeDZo4E/8bgEpf5Fwzp+19/LXYrB1NfFUyAOwBTIiRjE3oVgyVvoXtzFXo4TcnHoJdG91euoNsj3dhyYknGMeJnhWRiO/WHIcfeuXHIqmfrws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGuTI9mc; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4890098abbaso55243715e9.0
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2026 22:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777008896; x=1777613696; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iqdpk+Ggm92P1vJ+ZvbwR4JX2QTeplou7QDWgCpSKcg=;
        b=jGuTI9mcCBnBgmvpMfDTQ6gpYi2uhjER6tcRtnOdf/3fsVMwxiot0dQDzy7A0LdhdM
         Jp7fK9tUPnLJr6UwnJynv9ogIyTDBtgg0/xOv1aB/xbUof3oCs66XftqK+auNOWrkdjL
         CFHLTiELbdBqDxfdaUorZGuM9WyIVEdpQyyVwTqIEXlV0SVjfJh8zAuSmSXOdA31uJTv
         aKaF77D5t32s1WlaVv1SrTxixvpLcam2VPR1FZTxzAAPnByycqDQUkvESnHEcJQSJuj6
         0G0opVjJbW14FMWyt3WCwYo8xWmRx7SKmwLYUrgPmFvxhyTP7eRVShcIQnMWlYgJKNLn
         V/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777008896; x=1777613696;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iqdpk+Ggm92P1vJ+ZvbwR4JX2QTeplou7QDWgCpSKcg=;
        b=GmRFRS2AlKFFJtYs7V5h+XyUaU/HcG4NkrQrDmt171lQOgONhGCmBHtjmLEZq2Naw1
         5wl30gvqlpLCDqBOaLq33PRsK1gSi+tNknV86ic5TVNPNZJ18Y7bjUffMz6lzgw4P5ZP
         wyskwEsw0uoRCFxgGtgu/IcP636gOQgXB36WvP6bVvxB4VCyAAr7Ms3tFd0hZ3bDDD5Y
         SKUZMES65pYudkE2z2bsCO5v2uF9aRxon3mUCUQjb3TpQSOzkIisF+Vgx8MCj+HlfQ6u
         Hv4DFCflkL6TBDyXGImY+ax8UAnwxVspjms8Fdu7n2LspHC3X0qATzOWfSDUJxuG7eLI
         jqWA==
X-Gm-Message-State: AOJu0YyvlImOByup7ecVs1wO+2MQyA2hoU4gRYL9nkuVB6u8yDMGWFYK
	arGZdC1Ama5yUYj/rGfxb3qL0iFRnRqsnZL3GTNm9734oCX6dH8S5WgA
X-Gm-Gg: AeBDietDobWS4XBcpNt6pTH1c66weSq05iQ5sQ364IwC0W3DR1pkM/aJYQSs1111DJw
	iX9SzZx3T2k1AYcIRz2ulX9wFCduO7u7BG1Ku49I3e7q0EFiz6QyXLR/Ylbfqm7/nBFeztHEaSs
	7BgcsNOJNK9gE/HOnFJUb2W+O4pdCry2+gsMY/NIEoMzzxiH1epqmmUKRaKYVClnbajLA2fapao
	DQQwcDhWWBFAEtBDgmnaDXPZbxp0TOU7D02NYBCE5kJm0PFffiOJTkNlmO1B3i1bSozrF30DHn6
	H0qzhib01BLW6e0da0XFyAHZcdhVE40ver3drBl74ZhTuMeLILebAsRr0W2CABcf2P49PEjkPoW
	FkNipy6g8knbuPo9sl0KKxHDJmxIXJT+dcqEk/RyTsn2hUYz+cbNgd0qnnx/JSa3+m6y5twOwH3
	gusKUjgMRrS3J2rf+WddQnODlwihcLGemL9G5fv1T6
X-Received: by 2002:a05:600c:a105:b0:485:3a03:ceca with SMTP id 5b1f17b1804b1-488fb7826femr302020955e9.23.1777008895517;
        Thu, 23 Apr 2026 22:34:55 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e46471sm55719874f8f.28.2026.04.23.22.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 22:34:54 -0700 (PDT)
Date: Fri, 24 Apr 2026 08:34:51 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: [bug report] io_uring/register: fix ring resizing with mixed/large
 SQEs/CQEs
Message-ID: <aesA-_AEKgF_oucO@stanley.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 606BC459ED8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13136-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[error27@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

Hello Jens Axboe,

Commit 45cd95763e19 ("io_uring/register: fix ring resizing with
mixed/large SQEs/CQEs") from Apr 20, 2026 (linux-next), leads to the
following Smatch static checker warning:

    io_uring/register.c:613 io_register_resize_rings()
    warn: potential integer overflow from user (local copy) 'p->sq_entries << 1'

    io_uring/register.c:643 io_register_resize_rings()
    warn: potential integer overflow from user (local copy) 'p->cq_entries << 1'

io_uring/register.c
    498 static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
    499 {
    500         struct io_ctx_config config;
    501         struct io_uring_region_desc rd;
    502         struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
    503         unsigned i, tail, old_head;
    504         struct io_uring_params *p = &config.p;
    505         struct io_rings_layout *rl = &config.layout;
    506         int ret;
    507 
    508         memset(&config, 0, sizeof(config));
    509 
    510         /* limited to DEFER_TASKRUN for now */
    511         if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
    512                 return -EINVAL;
    513         if (copy_from_user(p, arg, sizeof(*p)))

p comes from the user.  p->sq_entries and p->cq_entries are u32.

    514                 return -EFAULT;
    515         if (p->flags & ~RESIZE_FLAGS)
    516                 return -EINVAL;
    517 
    518         /* properties that are always inherited */
    519         p->flags |= (ctx->flags & COPY_FLAGS);
    520 
    521         ret = io_prepare_config(&config);
    522         if (unlikely(ret))
    523                 return ret;
    524 
    525         memset(&rd, 0, sizeof(rd));
    526         rd.size = PAGE_ALIGN(rl->rings_size);
    527         if (p->flags & IORING_SETUP_NO_MMAP) {
    528                 rd.user_addr = p->cq_off.user_addr;
    529                 rd.flags |= IORING_MEM_REGION_TYPE_USER;
    530         }
    531         ret = io_create_region(ctx, &n.ring_region, &rd, IORING_OFF_CQ_RING);
    532         if (ret)
    533                 return ret;
    534 
    535         n.rings = io_region_get_ptr(&n.ring_region);
    536 
    537         /*
    538          * At this point n.rings is shared with userspace, just like o.rings
    539          * is as well. While we don't expect userspace to modify it while
    540          * a resize is in progress, and it's most likely that userspace will
    541          * shoot itself in the foot if it does, we can't always assume good
    542          * intent... Use read/write once helpers from here on to indicate the
    543          * shared nature of it.
    544          */
    545         WRITE_ONCE(n.rings->sq_ring_mask, p->sq_entries - 1);
    546         WRITE_ONCE(n.rings->cq_ring_mask, p->cq_entries - 1);

If p->sq_entries is 0 then this wraps to U32_MAX

    547         WRITE_ONCE(n.rings->sq_ring_entries, p->sq_entries);
    548         WRITE_ONCE(n.rings->cq_ring_entries, p->cq_entries);
    549 
    550         if (copy_to_user(arg, p, sizeof(*p))) {
    551                 io_register_free_rings(ctx, &n);
    552                 return -EFAULT;
    553         }
    554 
    555         memset(&rd, 0, sizeof(rd));
    556         rd.size = PAGE_ALIGN(rl->sq_size);
    557         if (p->flags & IORING_SETUP_NO_MMAP) {
    558                 rd.user_addr = p->sq_off.user_addr;
    559                 rd.flags |= IORING_MEM_REGION_TYPE_USER;
    560         }
    561         ret = io_create_region(ctx, &n.sq_region, &rd, IORING_OFF_SQES);
    562         if (ret) {
    563                 io_register_free_rings(ctx, &n);
    564                 return ret;
    565         }
    566         n.sq_sqes = io_region_get_ptr(&n.sq_region);
    567 
    568         /*
    569          * If using SQPOLL, park the thread
    570          */
    571         if (ctx->sq_data) {
    572                 mutex_unlock(&ctx->uring_lock);
    573                 io_sq_thread_park(ctx->sq_data);
    574                 mutex_lock(&ctx->uring_lock);
    575         }
    576 
    577         /*
    578          * We'll do the swap. Grab the ctx->mmap_lock, which will exclude
    579          * any new mmap's on the ring fd. Clear out existing mappings to prevent
    580          * mmap from seeing them, as we'll unmap them. Any attempt to mmap
    581          * existing rings beyond this point will fail. Not that it could proceed
    582          * at this point anyway, as the io_uring mmap side needs go grab the
    583          * ctx->mmap_lock as well. Likewise, hold the completion lock over the
    584          * duration of the actual swap.
    585          */
    586         mutex_lock(&ctx->mmap_lock);
    587         spin_lock(&ctx->completion_lock);
    588         o.rings = ctx->rings;
    589         ctx->rings = NULL;
    590         o.sq_sqes = ctx->sq_sqes;
    591         ctx->sq_sqes = NULL;
    592 
    593         /*
    594          * Now copy SQ and CQ entries, if any. If either of the destination
    595          * rings can't hold what is already there, then fail the operation.
    596          */
    597         tail = READ_ONCE(o.rings->sq.tail);
    598         old_head = READ_ONCE(o.rings->sq.head);
    599         if (tail - old_head > p->sq_entries)
    600                 goto overflow;

I guess if p->sq_entries were zero then we would hit this goto

    601         for (i = old_head; i < tail; i++) {
    602                 unsigned index, dst_mask, src_mask;
    603                 size_t sq_size;
    604 
    605                 index = i;
    606                 sq_size = sizeof(struct io_uring_sqe);
    607                 src_mask = ctx->sq_entries - 1;
    608                 dst_mask = p->sq_entries - 1;
    609                 if (ctx->flags & IORING_SETUP_SQE128) {
    610                         index <<= 1;
    611                         sq_size <<= 1;
    612                         src_mask = (ctx->sq_entries << 1) - 1;
--> 613                         dst_mask = (p->sq_entries << 1) - 1;

These shifts could integer overflow.  So if you picked p->sq_entries
which was (1U << 31) then the (p->sq_entries << 1) would be zero and
the mask would be 0xffffffff.  Which might even be intentional, since
overflowing to zero and subtracting one is an idiom...

regards,
dan carpenter

    614                 }
    615                 memcpy(&n.sq_sqes[index & dst_mask], &o.sq_sqes[index & src_mask], sq_size);
    616         }
    617         WRITE_ONCE(n.rings->sq.head, old_head);
    618         WRITE_ONCE(n.rings->sq.tail, tail);
    619 
    620         tail = READ_ONCE(o.rings->cq.tail);
    621         old_head = READ_ONCE(o.rings->cq.head);
    622         if (tail - old_head > p->cq_entries) {
    623 overflow:
    624                 /* restore old rings, and return -EOVERFLOW via cleanup path */
    625                 ctx->rings = o.rings;
    626                 ctx->sq_sqes = o.sq_sqes;
    627                 to_free = &n;
    628                 ret = -EOVERFLOW;
    629                 goto out;
    630         }
    631         for (i = old_head; i < tail; i++) {
    632                 unsigned index, dst_mask, src_mask;
    633                 size_t cq_size;
    634 
    635                 index = i;
    636                 cq_size = sizeof(struct io_uring_cqe);
    637                 src_mask = ctx->cq_entries - 1;
    638                 dst_mask = p->cq_entries - 1;
    639                 if (ctx->flags & IORING_SETUP_CQE32) {
    640                         index <<= 1;
    641                         cq_size <<= 1;
    642                         src_mask = (ctx->cq_entries << 1) - 1;
    643                         dst_mask = (p->cq_entries << 1) - 1;
    644                 }
    645                 memcpy(&n.rings->cqes[index & dst_mask], &o.rings->cqes[index & src_mask], cq_size);
    646         }
    647         WRITE_ONCE(n.rings->cq.head, old_head);
    648         WRITE_ONCE(n.rings->cq.tail, tail);
    649         /* invalidate cached cqe refill */
    650         ctx->cqe_cached = ctx->cqe_sentinel = NULL;
    651 
    652         WRITE_ONCE(n.rings->sq_dropped, READ_ONCE(o.rings->sq_dropped));
    653         atomic_set(&n.rings->sq_flags, atomic_read(&o.rings->sq_flags));
    654         WRITE_ONCE(n.rings->cq_flags, READ_ONCE(o.rings->cq_flags));
    655         WRITE_ONCE(n.rings->cq_overflow, READ_ONCE(o.rings->cq_overflow));
    656 
    657         /* all done, store old pointers and assign new ones */
    658         if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
    659                 ctx->sq_array = (u32 *)((char *)n.rings + rl->sq_array_offset);
    660 
    661         ctx->sq_entries = p->sq_entries;
    662         ctx->cq_entries = p->cq_entries;
    663 
    664         /*
    665          * Just mark any flag we may have missed and that the application
    666          * should act on unconditionally. Worst case it'll be an extra
    667          * syscall.
    668          */
    669         atomic_or(IORING_SQ_TASKRUN | IORING_SQ_NEED_WAKEUP, &n.rings->sq_flags);
    670         ctx->rings = n.rings;
    671         rcu_assign_pointer(ctx->rings_rcu, n.rings);
    672 
    673         ctx->sq_sqes = n.sq_sqes;
    674         swap_old(ctx, o, n, ring_region);
    675         swap_old(ctx, o, n, sq_region);
    676         to_free = &o;
    677         ret = 0;
    678 out:
    679         spin_unlock(&ctx->completion_lock);
    680         mutex_unlock(&ctx->mmap_lock);
    681         /* Wait for concurrent io_ctx_mark_taskrun() */
    682         if (to_free == &o)
    683                 synchronize_rcu_expedited();
    684         io_register_free_rings(ctx, to_free);
    685 
    686         if (ctx->sq_data)
    687                 io_sq_thread_unpark(ctx->sq_data);
    688 
    689         return ret;
    690 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter

