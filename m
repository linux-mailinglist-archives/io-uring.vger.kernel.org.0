Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93206931E0
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjBKPGf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 10:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBKPGe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 10:06:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5198126846
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 07:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676127950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RAA6MLVbCYRbaNJcYcJSydJa+JkBz3cL6cg9ack6zDU=;
        b=QGygcVWWoMiCGabbhc08N0BJ53NJVQfyeCrWsC1J9+1nJKrwpWPKDPM4xT6Wz6+pVhSwhs
        JRSW+nXImrGw1iERxuwK5w1KJL9zIdRMkEaDekY38WVvQkXrMbUc+tJDKy7IYFyzYxaJbS
        eZrYkqHOSAFfZTmHwizlQMlKMWXK4L8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-Du0Nyxm1PCWBRLvFA9Z8fg-1; Sat, 11 Feb 2023 10:05:49 -0500
X-MC-Unique: Du0Nyxm1PCWBRLvFA9Z8fg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6791101A521;
        Sat, 11 Feb 2023 15:05:48 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94B83C16022;
        Sat, 11 Feb 2023 15:05:40 +0000 (UTC)
Date:   Sat, 11 Feb 2023 23:05:35 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>,
        ming.lei@redhat.com
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+euv+zR5ltTELqk@T590>
References: <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk>
 <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk>
 <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
 <b44783e6-3da2-85dd-a482-5d9aeb018e9c@kernel.dk>
 <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
 <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
 <Y+cJDnnMuirSjO3E@T590>
 <55eaac9e-0d77-1fa2-df27-4d64e123177e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55eaac9e-0d77-1fa2-df27-4d64e123177e@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 11, 2023 at 07:13:44AM -0700, Jens Axboe wrote:
> On 2/10/23 8:18?PM, Ming Lei wrote:
> > On Fri, Feb 10, 2023 at 02:08:35PM -0800, Linus Torvalds wrote:
> >> On Fri, Feb 10, 2023 at 1:51 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> Speaking of splice/io_uring, Ming posted this today:
> >>>
> >>> https://lore.kernel.org/io-uring/20230210153212.733006-1-ming.lei@redhat.com/
> >>
> >> Ugh. Some of that is really ugly. Both 'ignore_sig' and
> >> 'ack_page_consuming' just look wrong. Pure random special cases.
> >>
> >> And that 'ignore_sig' is particularly ugly, since the only thing that
> >> sets it also sets SPLICE_F_NONBLOCK.
> >>
> >> And the *only* thing that actually then checks that field is
> >> 'splice_from_pipe_next()', where there are exactly two
> >> signal_pending() checks that it adds to, and
> >>
> >>  (a) the first one is to protect from endless loops
> >>
> >>  (b) the second one is irrelevant when  SPLICE_F_NONBLOCK is set
> >>
> >> So honestly, just NAK on that series.
> >>
> >> I think that instead of 'ignore_sig' (which shouldn't exist), that
> >> first 'signal_pending()' check in splice_from_pipe_next() should just
> >> be changed into a 'fatal_signal_pending()'.
> > 
> > Good point, here the signal is often from task_work_add() called by
> > io_uring.
> 
> Usually you'd use task_sigpending() to distinguis the two, but
> fatal_signal_pending() as Linus suggests would also work. The only
> concern here is that since you'll be potentially blocking on waiting for
> the pipe to be readable - if task does indeed have task_work pending and
> that very task_work is the one that will ensure that the pipe is now
> readable, then you're waiting condition will never be satisfied.

The 2nd signal_pending() will break the loop to get task_work handled,
so it is safe to only change the 1st one to fatal_signal_pending().


Thanks,
Ming

