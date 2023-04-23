Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE966EBC33
	for <lists+io-uring@lfdr.de>; Sun, 23 Apr 2023 03:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjDWBHN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Apr 2023 21:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjDWBHM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Apr 2023 21:07:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF9B198B
        for <io-uring@vger.kernel.org>; Sat, 22 Apr 2023 18:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682211983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h6HLm1JMiSaO59wqo0ZIuPWdvIz/co8n0mqVrUh7nmQ=;
        b=UHzWMt9UenNRG3j2Le3MqDERmYcyym8bxGUJaLZurztQju8FpP8ruZqDFRRTSVjHFd3+v5
        KWyIqnWu8bcgkdqfbeL9lMP7r++Zaa5Q6Ob9zUyg+xUht4rYXcCw6iipEwTSkkt+S7T6yr
        JeVAi2lf3NEEuLXWtbEM+QVNyevMiKI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-ZIR8KNzWNwejvPSb_j3vZA-1; Sat, 22 Apr 2023 21:06:21 -0400
X-MC-Unique: ZIR8KNzWNwejvPSb_j3vZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 360E929AA3B0;
        Sun, 23 Apr 2023 01:06:21 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CFFD41121318;
        Sun, 23 Apr 2023 01:06:17 +0000 (UTC)
Date:   Sun, 23 Apr 2023 09:06:12 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Bernd Schubert <bschubert@ddn.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, ming.lei@redhat.com
Subject: Re: SQPOLL / uring_cmd_iopoll
Message-ID: <ZESEhJHY902Jhrl9@ovpn-8-16.pek2.redhat.com>
References: <cbfa6c3f-11bd-84f7-bdb0-4342f8fd38f3@ddn.com>
 <ZEPZJ2wEhumPbYOU@ovpn-8-21.pek2.redhat.com>
 <05ad98bb-0f03-d870-e975-a223205294c8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05ad98bb-0f03-d870-e975-a223205294c8@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Apr 22, 2023 at 08:08:41AM -0600, Jens Axboe wrote:
> On 4/22/23 6:55?AM, Ming Lei wrote:
> > On Fri, Apr 21, 2023 at 10:09:36PM +0000, Bernd Schubert wrote:
> >> Hello,
> >>
> >> I was wondering if I could set up SQPOLL for fuse/IORING_OP_URING_CMD 
> >> and what would be the latency win. Now I get a bit confused what the 
> >> f_op->uring_cmd_iopoll() function is supposed to do.
> >>
> >> Is it just there to check if SQEs are can be completed as CQE? In rw.c 
> >> io_do_iopoll() it looks like this. I don't follow all code paths in 
> >> __io_sq_thread yet, but it looks a like it already checks if the ring 
> >> has new entries
> >>
> >> to_submit = io_sqring_entries(ctx);
> >> ...
> >> ret = io_submit_sqes(ctx, to_submit);
> >>
> >>    --> it will eventually call into ->uring_cmd() ?
> >>
> >> And then io_do_iopoll ->  file->f_op->uring_cmd_iopoll is supposed to 
> >> check for available cq entries and will submit these? I.e. I just return 
> >> 1 if when the request is ready? And also ensure that 
> >> req->iopoll_completed is set?
> >>
> >>
> >> I'm also not sure what I should do with struct io_comp_batch * - I don't 
> >> have struct request *req_list anywhere in my fuse-uring changes, seems 
> >> to be blk-mq specific? So I should just ignore that parameter?
> >>
> >>
> >> Btw, this might be useful for ublk as well?
> > 
> > For the in-tree ublk driver, we need to copy data inside ->uring_cmd()
> > between block request pages and user buffer, so SQPOLL may not be done
> > because it isn't efficient for the kthread to copy on remote task mm
> > space. However, ublk user copy feature[1](posted recently) doesn't
> > need the copy in ->uring_cmd() any more, so SQPOLL becomes possible for
> > ublk uring cmd.
> 
> That hasn't been true for a long time, and isn't even true in
> 5.10-stable anymore or anything newer. The SQPOLL thread is not a
> kthread, and it doesn't need to do anything to copy the data that the
> inline submission wouldn't also do. There is no "remote task mm". The
> cost would be the same, outside of caching effects.

OK, thanks for the clarification, and create_io_thread() does pass
CLONE_VM, so there isn't remote task mm problem.

However, ublk still can't use SETUP_SQPOLL so far, and problem is that
ublk driver has to be bound with the user task for canceling pending commands
when the ctx is gone[1]. When this issue is solved, SETUP_SQPOLL should
work just fine.

Given fuse takes similar approach with ublk, I believe fuse has similar
limit too.

Actually I was working on adding notifiers in io_uring[2] for addressing
this issue so that driver needn't to use the trick for tracking io_uring
context destroying. Just see one request double free issue(same request freed
in io_submit_flush_completions<-io_fallback_req_func() twice) in case of
DEFER_TASKRUN only, but driver actually calls io_uring_cmd_done() just once.
Will investigate the issue further.


[1] https://lore.kernel.org/linux-fsdevel/ZBxTdCj60+s1aZqA@ovpn-8-16.pek2.redhat.com/
[2] https://github.com/ming1/linux/commits/for-6.4/io_uring_block


Thanks, 
Ming

