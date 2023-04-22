Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9656EB935
	for <lists+io-uring@lfdr.de>; Sat, 22 Apr 2023 14:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjDVM4A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Apr 2023 08:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjDVM4A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Apr 2023 08:56:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AF11713
        for <io-uring@vger.kernel.org>; Sat, 22 Apr 2023 05:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682168114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=adU8Sc2l+xRsHc/CA+tyDXDlVvHGYvJ7FI9raRCB0tc=;
        b=G3pwV01yiU5uL9lzoP91IHd1ycx6m1CnVsfgqcCNTYbLCHCMAFEzrfjRZan3somvEY9odl
        N67KudQRTydrCiDlfS9yuoIcqh0jQMxz6pM1Uhbm58YUK7SNZxOWahonAcIO3F/tWS5Hce
        SeV/4VHSh0uZoEI6lGfB1ysXy8sSXEg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-HvTiNNoEN82OV-1fcAXPNg-1; Sat, 22 Apr 2023 08:55:13 -0400
X-MC-Unique: HvTiNNoEN82OV-1fcAXPNg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C65DE3C02538;
        Sat, 22 Apr 2023 12:55:12 +0000 (UTC)
Received: from ovpn-8-21.pek2.redhat.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDC00200A384;
        Sat, 22 Apr 2023 12:55:08 +0000 (UTC)
Date:   Sat, 22 Apr 2023 20:55:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bernd Schubert <bschubert@ddn.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, ming.lei@redhat.com
Subject: Re: SQPOLL / uring_cmd_iopoll
Message-ID: <ZEPZJ2wEhumPbYOU@ovpn-8-21.pek2.redhat.com>
References: <cbfa6c3f-11bd-84f7-bdb0-4342f8fd38f3@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbfa6c3f-11bd-84f7-bdb0-4342f8fd38f3@ddn.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 21, 2023 at 10:09:36PM +0000, Bernd Schubert wrote:
> Hello,
> 
> I was wondering if I could set up SQPOLL for fuse/IORING_OP_URING_CMD 
> and what would be the latency win. Now I get a bit confused what the 
> f_op->uring_cmd_iopoll() function is supposed to do.
> 
> Is it just there to check if SQEs are can be completed as CQE? In rw.c 
> io_do_iopoll() it looks like this. I don't follow all code paths in 
> __io_sq_thread yet, but it looks a like it already checks if the ring 
> has new entries
> 
> to_submit = io_sqring_entries(ctx);
> ...
> ret = io_submit_sqes(ctx, to_submit);
> 
>    --> it will eventually call into ->uring_cmd() ?
> 
> And then io_do_iopoll ->  file->f_op->uring_cmd_iopoll is supposed to 
> check for available cq entries and will submit these? I.e. I just return 
> 1 if when the request is ready? And also ensure that 
> req->iopoll_completed is set?
> 
> 
> I'm also not sure what I should do with struct io_comp_batch * - I don't 
> have struct request *req_list anywhere in my fuse-uring changes, seems 
> to be blk-mq specific? So I should just ignore that parameter?
> 
> 
> Btw, this might be useful for ublk as well?

For the in-tree ublk driver, we need to copy data inside ->uring_cmd()
between block request pages and user buffer, so SQPOLL may not be done
because it isn't efficient for the kthread to copy on remote task mm
space. However, ublk user copy feature[1](posted recently) doesn't
need the copy in ->uring_cmd() any more, so SQPOLL becomes possible for
ublk uring cmd.

Also for uring cmd only, IOPOLL may not be done given we don't know
when request from /dev/ublkb* is coming, maybe never.

But if there is any target IO pending, IOPOLL can be used, and the
change should be trivial.

[1] https://lore.kernel.org/linux-block/ZEFeYsQ%2FntUjUv2Y@ovpn-8-16.pek2.redhat.com/T/#t

Thanks,
Ming

