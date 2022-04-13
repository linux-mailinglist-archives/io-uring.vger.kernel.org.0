Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199114FF103
	for <lists+io-uring@lfdr.de>; Wed, 13 Apr 2022 09:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbiDMH42 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Apr 2022 03:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbiDMH4Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Apr 2022 03:56:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B8294BFC3
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 00:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649836443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8xkesHfa1w9R4L8ql/fNnstcdduqyaQQByovClcRXXU=;
        b=gpEj85sBBM+EOku0Mchsi/AIRd2hjIqeAOI94PVAWbxysS9HrU2piXqcxJzf7dS8wCkLKC
        KW9UQ4eX+jKqCckaPG/W4HyGhJTN5rtdQ6QB3EWflVPlnEliLw1NhjqR30y4jSjIolCVu+
        aaPj2LFB8WEmzSlzfafU6uMOCg77yr8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-cw98XF_YMbaocdMR2meutQ-1; Wed, 13 Apr 2022 03:54:02 -0400
X-MC-Unique: cw98XF_YMbaocdMR2meutQ-1
Received: by mail-wr1-f70.google.com with SMTP id s8-20020adfc548000000b00207a28e0583so133063wrf.23
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 00:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8xkesHfa1w9R4L8ql/fNnstcdduqyaQQByovClcRXXU=;
        b=mABTWZ0OnKDnJrP4FBYwpS8sdmoOVtHdHNSs+ZyqrSKa46YDjKwSiJkpUVttYFFu5a
         vouuAmZ1j2iegWJcvyaJ+Bdi5J64YljDkxKMHUrCb7UvIPKLNCrGN8vujpk5bvKj8gwd
         1F2CNtc9b9dNltmj0cF/Sxb1ITZc5v6hpgwhQIQaCIPyrgmhS9vcP+oL/VUV1+xmfhQs
         qZscpeEEEzByNqCN/xWZN7nxeLUr7jRkTadVblbKgamlAqJ2nw7nqoRXlutdnX39osvJ
         ihy3J+W3dNLlPuM9ctAGfy3NW320JpAKz5mUiM77OUF9qdcrN1HXMKk2k+yk/OuQs0h7
         MSOQ==
X-Gm-Message-State: AOAM5326wqpkwbG08PlGjcdVMvR7cQ6O/CdIeHvYY/3layF2btsjtNcW
        v/YFJ/CMkpHQ4CLJn2UIxILfqSZVRsDJu5taDDcogJJ6gVNDcCgLa9Pp1gG0YXnRyNJMVg7U2Vf
        oLizia0d++nAFHcvtDoE=
X-Received: by 2002:a5d:4751:0:b0:207:9bdd:ee69 with SMTP id o17-20020a5d4751000000b002079bddee69mr16933866wrs.406.1649836440818;
        Wed, 13 Apr 2022 00:54:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfG/2ZRzPsBw4aEb8kcpAYLsgwj+YPj8JuaUWjzU6+Iq1qQ4r5ZqPpClVj41vt6/d8obx10g==
X-Received: by 2002:a5d:4751:0:b0:207:9bdd:ee69 with SMTP id o17-20020a5d4751000000b002079bddee69mr16933845wrs.406.1649836440567;
        Wed, 13 Apr 2022 00:54:00 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id m20-20020a05600c3b1400b0038ebbbb2ad2sm1579752wms.44.2022.04.13.00.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 00:54:00 -0700 (PDT)
Message-ID: <4864c2c265f6986bcd7576a9066cb430fbfdde95.camel@redhat.com>
Subject: Re: [PATCHSET 0/4] Add support for no-lock sockets
From:   Paolo Abeni <pabeni@redhat.com>
To:     dust.li@linux.alibaba.com, Jens Axboe <axboe@kernel.dk>,
        Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, io-uring@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Date:   Wed, 13 Apr 2022 09:53:59 +0200
In-Reply-To: <20220413052339.GJ35207@linux.alibaba.com>
References: <20220412202613.234896-1-axboe@kernel.dk>
         <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
         <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk>
         <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
         <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk>
         <20220413052339.GJ35207@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 2022-04-13 at 13:23 +0800, dust.li wrote:
> On Tue, Apr 12, 2022 at 08:01:10PM -0600, Jens Axboe wrote:
> > On 4/12/22 7:54 PM, Eric Dumazet wrote:
> > > On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
> > > > 
> > > > On 4/12/22 6:40 PM, Eric Dumazet wrote:
> > > > > 
> > > > > On 4/12/22 13:26, Jens Axboe wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > If we accept a connection directly, eg without installing a file
> > > > > > descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
> > > > > > we have a socket for recv/send that we can fully serialize access to.
> > > > > > 
> > > > > > With that in mind, we can feasibly skip locking on the socket for TCP
> > > > > > in that case. Some of the testing I've done has shown as much as 15%
> > > > > > of overhead in the lock_sock/release_sock part, with this change then
> > > > > > we see none.
> > > > > > 
> > > > > > Comments welcome!
> > > > > > 
> > > > > How BH handlers (including TCP timers) and io_uring are going to run
> > > > > safely ? Even if a tcp socket had one user, (private fd opened by a
> > > > > non multi-threaded program), we would still to use the spinlock.
> > > > 
> > > > But we don't even hold the spinlock over lock_sock() and release_sock(),
> > > > just the mutex. And we do check for running eg the backlog on release,
> > > > which I believe is done safely and similarly in other places too.
> > > 
> > > So lets say TCP stack receives a packet in BH handler... it proceeds
> > > using many tcp sock fields.
> > > 
> > > Then io_uring wants to read/write stuff from another cpu, while BH
> > > handler(s) is(are) not done yet,
> > > and will happily read/change many of the same fields
> > 
> > But how is that currently protected? The bh spinlock is only held
> > briefly while locking the socket, and ditto on the relase. Outside of
> > that, the owner field is used. At least as far as I can tell. I'm
> > assuming the mutex exists solely to serialize acess to eg send/recv on
> > the system call side.
> 
> Hi jens,
> 
> I personally like the idea of using iouring to improve the performance
> of the socket API.
> 
> AFAIU, the bh spinlock will be held by the BH when trying to make
> changes to those protected fields on the socket, and the userspace
> will try to hold that spinlock before it can change the sock lock
> owner field.
> 
> For example:
> in tcp_v4_rcv() we have
> 
>         bh_lock_sock_nested(sk);
>         tcp_segs_in(tcp_sk(sk), skb);
>         ret = 0;
>         if (!sock_owned_by_user(sk)) {
>                 ret = tcp_v4_do_rcv(sk, skb);
>         } else {
>                 if (tcp_add_backlog(sk, skb, &drop_reason))
>                         goto discard_and_relse;
>         }
>         bh_unlock_sock(sk);
> 
> When this is called in the BH, it will first hold the bh spinlock
> and then check the owner field, tcp_v4_do_rcv() will always been
> protected by the bh spinlock.
> 
> If the user thread tries to make changes to the socket, it first
> call lock_sock() which will also try to hold the bh spinlock, I
> think that prevent the race.
> 
>   void lock_sock_nested(struct sock *sk, int subclass)
>   {
>           /* The sk_lock has mutex_lock() semantics here. */
>           mutex_acquire(&sk->sk_lock.dep_map, subclass, 0, _RET_IP_);
> 
>           might_sleep();
>           spin_lock_bh(&sk->sk_lock.slock);
>           if (sock_owned_by_user_nocheck(sk))
>                   __lock_sock(sk);
>           sk->sk_lock.owned = 1;
>           spin_unlock_bh(&sk->sk_lock.slock);
>   }
> 
> But if we remove the spinlock in the lock_sock() when sk_no_lock
> is set to true. When the the bh spinlock is already held by the BH,
> it seems the userspace won't respect that anymore ?

Exactly, with sk_no_lock we will have the following race:

[BH/timer on CPU 0]			[ reader/writer on CPU 1]

bh_lock_sock_nested(sk);
// owned is currently 0
if (!sock_owned_by_user(sk)) {
    // modify sk state

					if (sk->sk_no_lock) {
						sk->sk_lock.owned = 1;
						smp_wmb();
   // still touching sk state
					// cuncurrently modify sk
state
					// sk is corrupted

We need both the sk spinlock and the 'owned' bit to ensure mutually
exclusive access WRT soft interrupts. 

I personally don't see any way to fix the above without the sk spinlock
- or an equivalent contended atomic operation.

Additionally these changes add relevant overhead for the !sk_no_lock
case - the additional memory barriers and conditionals - which will
impact most/all existing users.

Touching a very fundamental and internal piece of the core networking,
corrently extremelly stable, similar changes will require a very
extensive testing, comprising benchmarking for the current/!sk_no_lock
code paths with different workloads and additional self-tests.

Thanks.

Paolo

