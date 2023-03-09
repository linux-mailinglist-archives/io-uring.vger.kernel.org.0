Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15FA6B1907
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 03:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCICGq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 21:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCICGp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 21:06:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498FA99C2A
        for <io-uring@vger.kernel.org>; Wed,  8 Mar 2023 18:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678327552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ltrQWF5dnN4RYTyvmMcMbr5k2zo99y6r8vIMJI6Evs=;
        b=aZ6eI1mtMDQd7MarXThjUuRnyK5bit4AtHH1CgAYlEy4q3qjnA6TdKfCKdEjnJVk9/ZD0U
        s3OQv9kZyefP5tci8MauT1lSA7podRZrje7VQlguwaWhGkJO6uKYveMDnuju5f69zW3qcp
        anMnq0KsuRUXp4Mr8L5jdFLSw/qS/SA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-YkP85ZUeMU-UcI2KALbBmA-1; Wed, 08 Mar 2023 21:05:48 -0500
X-MC-Unique: YkP85ZUeMU-UcI2KALbBmA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE4C029AA2C1;
        Thu,  9 Mar 2023 02:05:47 +0000 (UTC)
Received: from ovpn-8-17.pek2.redhat.com (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 83F732026D4B;
        Thu,  9 Mar 2023 02:05:42 +0000 (UTC)
Date:   Thu, 9 Mar 2023 10:05:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZAk+nGUMDNiAfgPx@ovpn-8-17.pek2.redhat.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
 <ZAff9usDuyXxIPt9@ovpn-8-16.pek2.redhat.com>
 <7cdea685-98d3-e24d-8282-87cb44ae6174@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cdea685-98d3-e24d-8282-87cb44ae6174@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 08, 2023 at 04:22:15PM +0000, Pavel Begunkov wrote:
> On 3/8/23 01:08, Ming Lei wrote:
> > On Tue, Mar 07, 2023 at 03:37:21PM +0000, Pavel Begunkov wrote:
> > > On 3/7/23 14:15, Ming Lei wrote:
> > > > Hello,
> > > > 
> > > > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > > > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > > > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > > > to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> > > > and its ->issue() can retrieve/import buffer from master request's
> > > > fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> > > > this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> > > > submits slave OP just like normal OP issued from userspace, that said,
> > > > SQE order is kept, and batching handling is done too.
> > > 
> > >  From a quick look through patches it all looks a bit complicated
> > > and intrusive, all over generic hot paths. I think instead we
> > 
> > Really? The main change to generic hot paths are adding one 'true/false'
> > parameter to io_init_req(). For others, the change is just check on
> > req->flags or issue_flags, which is basically zero cost.
> 
> Extra flag in io_init_req() but also exporting it, which is an
> internal function, to non-core code. Additionally it un-inlines it

We can make it inline for core code only.

> and even looks recurse calls it (max depth 2). From a quick look,

The reurse call is only done for fused command, and won't be one
issue for normal OPs.

> there is some hand coded ->cached_refs manipulations, it takes extra
> space in generic sections of io_kiocb.

Yeah, but it is still done on fused command only. I think people
is happy to pay the cost for the benefit, and we do not cause trouble
for others.

> It makes all cmd users to
> check for IO_URING_F_FUSED. There is also a two-way dependency b/w

The check is zero cost, and just for avoiding to add ->fused_cmd() callback,
otherwise the check can be killed.

> requests, which never plays out well, e.g. I still hate how linked
> timeouts stick out in generic paths.

I appreciate you may explain it in details.

Yeah, part of fused command's job is to submit one new io and wait its completion.
slave request is actually invisible in the linked list, and only fused
command can be in the linked list.

> 
> Depending on SQE128 also doesn't seem right, though it can be dealt
> with, e.g. sth like how it's done with links requests.

I thought about handling it by linked request, but we need fused command to be
completed after the slave request is done, and that becomes one deadlock if
the two are linked together.

SQE128 is per-context feature, when we need to submit uring SQE128 command, the
same ring is required to handle IO, then IMO it is perfect for this
case, at least for ublk.

> 
> > > should be able to use registered buffer table as intermediary and
> > > reuse splicing. Let me try it out
> > 
> > I will take a look at you patch, but last time, Linus has pointed out that
> > splice isn't one good way, in which buffer ownership transferring is one big
> > issue for writing data to page retrieved from pipe.
> 
> There are no real pipes, better to say io_uring replaces a pipe,
> and splice bits are used to get pages from a file. Though, there
> will be some common problems. Thanks for the link, I'll need to
> get through it first, thanks for the link

Yeah, here the only value of pipe is to reuse ->splice_read() interface,
that is why I figure out fused command for this job. I am open for
other approaches, if the problem can be solved(reliably and efficiently).

Thanks, 
Ming

