Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E916BC347
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 02:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCPB0d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 21:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCPB0a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 21:26:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046B4A02A7
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 18:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678929943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TGdqVcEwycRAYylVPKoiqjaZZ0k1hNyn+fxbbrBISQE=;
        b=UA3G/dTDxBho2Uy9KQVPk4mRGrqo0MsI50PlwsoNVBt1qv4b5C0bWzhOyZtlr+7HeZ5M+T
        kK5JVESCFAoAhzNazQLWRK5LkM/t8YTvUuAlB9W1sMr7sod7a6S7oEZg1lHSc2UiaztvbQ
        eWP9VvpB0UsPWIHRNWfoZniHhVkDAfE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-ub4KjYc-Mxe8mYFv5T6ChQ-1; Wed, 15 Mar 2023 21:25:40 -0400
X-MC-Unique: ub4KjYc-Mxe8mYFv5T6ChQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5270D87B2A0;
        Thu, 16 Mar 2023 01:25:40 +0000 (UTC)
Received: from ovpn-8-22.pek2.redhat.com (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F34EB400F5D;
        Thu, 16 Mar 2023 01:25:36 +0000 (UTC)
Date:   Thu, 16 Mar 2023 09:25:32 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Message-ID: <ZBJwDOGGYIkIHTdJ@ovpn-8-22.pek2.redhat.com>
References: <cover.1678474375.git.asml.silence@gmail.com>
 <ZBEvD04sH/JzN7MJ@ovpn-8-22.pek2.redhat.com>
 <f3d1faef-dc0e-48e2-ab08-3ac1c7e7bcbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3d1faef-dc0e-48e2-ab08-3ac1c7e7bcbb@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 15, 2023 at 04:53:09PM +0000, Pavel Begunkov wrote:
> On 3/15/23 02:35, Ming Lei wrote:
> > Hi Pavel
> > 
> > On Fri, Mar 10, 2023 at 07:04:14PM +0000, Pavel Begunkov wrote:
> > > io_uring extensively uses task_work, but when a task is waiting
> > > for multiple CQEs it causes lots of rescheduling. This series
> > > is an attempt to optimise it and be a base for future improvements.
> > > 
> > > For some zc network tests eventually waiting for a portion of
> > > buffers I've got 10x descrease in the number of context switches,
> > > which reduced the CPU consumption more than twice (17% -> 8%).
> > > It also helps storage cases, while running fio/t/io_uring against
> > > a low performant drive it got 2x descrease of the number of context
> > > switches for QD8 and ~4 times for QD32.
> > 
> > ublk uses io_uring_cmd_complete_in_task()(io_req_task_work_add())
> > heavily. So I tried this patchset, looks not see obvious change
> > on both IOPS and context switches when running 't/io_uring /dev/ublkb0',
> > and it is one null ublk target(ublk add -t null -z -u 1 -q 2), IOPS
> > is ~2.8M.
> 
> Hi Ming,
> 
> It's enabled for rw requests and send-zc notifications, but
> io_uring_cmd_complete_in_task() is not covered. I'll be enabling
> it for more cases, including pass through.
> 
> > But ublk applies batch schedule similar with io_uring before calling
> > io_uring_cmd_complete_in_task().
> 
> The feature doesn't tolerate tw that produce multiple CQEs, so
> it can't be applied to this batching and the task would stuck
> waiting.
> 
> btw, from a quick look it appeared that ublk batching is there
> to keep requests together but not to improve batching. And if so,
> I think we can get rid of it, rely on io_uring batching and
> let ublk to gather its requests from tw list, which sounds
> cleaner. I'll elaborate on that later

Yeah, the ublk batching can be removed since __io_req_task_work_add
already does it, and it is kept just for micro optimization of calling
less io_uring_cmd_complete_in_task(), but I think we can get bigger
improvement with your tw optimization.


Thanks,
Ming

