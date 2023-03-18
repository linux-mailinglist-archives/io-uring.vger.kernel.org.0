Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C9F6BFB1C
	for <lists+io-uring@lfdr.de>; Sat, 18 Mar 2023 16:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCRPHv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 11:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCRPHu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 11:07:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E4335EC9
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 08:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679152025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x4ukQ6EK6l+1pfCLwKAUuJ1U5wkWCpu7f+W5BduB3UM=;
        b=PsOWulEsYhQ65u0t+jMIIpymOqywYd4zjIOQG0qR4YORen16gY0PKUVJ/4OhIq0gQVDHx1
        9vDPkEsCyuPYnWJ18DTP0+BSJJeC0mgB7DzsOie/GsLFIL/A4FDp9pLbINEzHEc8O6Kh8D
        U44F5CSiREaayMqHujKgK8iKQAKry8g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-5VoisF5MOx6DUMvUuRg8SQ-1; Sat, 18 Mar 2023 11:07:01 -0400
X-MC-Unique: 5VoisF5MOx6DUMvUuRg8SQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AED71C05AEF;
        Sat, 18 Mar 2023 15:07:01 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E017E2166B26;
        Sat, 18 Mar 2023 15:06:54 +0000 (UTC)
Date:   Sat, 18 Mar 2023 23:06:49 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZBXTiZ/li8BM9+QO@ovpn-8-18.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <ZBQhSzIhvZL+83nM@ovpn-8-18.pek2.redhat.com>
 <3971d43f-601f-635f-5a30-df7e647f6659@kernel.dk>
 <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
 <bb2a0c27-afc9-5683-9346-005b55a7240c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb2a0c27-afc9-5683-9346-005b55a7240c@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 18, 2023 at 08:36:37AM -0600, Jens Axboe wrote:
> On 3/18/23 7:35?AM, Ming Lei wrote:
> > Hi Jens,
> > 
> > Thanks for the response!
> > 
> > On Sat, Mar 18, 2023 at 06:59:41AM -0600, Jens Axboe wrote:
> >> On 3/17/23 2:14?AM, Ming Lei wrote:
> >>> On Tue, Mar 14, 2023 at 08:57:11PM +0800, Ming Lei wrote:
> >>>> Hello,
> >>>>
> >>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> >>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> >>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> >>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> >>>> and its ->issue() can retrieve/import buffer from master request's
> >>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> >>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> >>>> submits slave OP just like normal OP issued from userspace, that said,
> >>>> SQE order is kept, and batching handling is done too.
> >>>>
> >>>> Please see detailed design in commit log of the 2th patch, and one big
> >>>> point is how to handle buffer ownership.
> >>>>
> >>>> With this way, it is easy to support zero copy for ublk/fuse device.
> >>>>
> >>>> Basically userspace can specify any sub-buffer of the ublk block request
> >>>> buffer from the fused command just by setting 'offset/len'
> >>>> in the slave SQE for running slave OP. This way is flexible to implement
> >>>> io mapping: mirror, stripped, ...
> >>>>
> >>>> The 3th & 4th patches enable fused slave support for the following OPs:
> >>>>
> >>>> 	OP_READ/OP_WRITE
> >>>> 	OP_SEND/OP_RECV/OP_SEND_ZC
> >>>>
> >>>> The other ublk patches cleans ublk driver and implement fused command
> >>>> for supporting zero copy.
> >>>>
> >>>> Follows userspace code:
> >>>>
> >>>> https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-v2
> >>>>
> >>>> All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:
> >>>>
> >>>> 	ublk add -t [loop|nbd|qcow2] -z .... 
> >>>>
> >>>> Basic fs mount/kernel building and builtin test are done, and also not
> >>>> observe regression on xfstest test over ublk-loop with zero copy.
> >>>>
> >>>> Also add liburing test case for covering fused command based on miniublk
> >>>> of blktest:
> >>>>
> >>>> https://github.com/ming1/liburing/commits/fused_cmd_miniublk
> >>>>
> >>>> Performance improvement is obvious on memory bandwidth
> >>>> related workloads, such as, 1~2X improvement on 64K/512K BS
> >>>> IO test on loop with ramfs backing file.
> >>>>
> >>>> Any comments are welcome!
> >>>>
> >>>> V3:
> >>>> 	- fix build warning reported by kernel test robot
> >>>> 	- drop patch for checking fused flags on existed drivers with
> >>>> 	  ->uring_command(), which isn't necessary, since we do not do that
> >>>>       when adding new ioctl or uring command
> >>>>     - inline io_init_rq() for core code, so just export io_init_slave_req
> >>>> 	- return result of failed slave request unconditionally since REQ_F_CQE_SKIP
> >>>> 	will be cleared
> >>>> 	- pass xfstest over ublk-loop
> >>>
> >>> Hello Jens and Guys,
> >>>
> >>> I have been working on io_uring zero copy support for ublk/fuse for a while, and
> >>> I appreciate you may share any thoughts on this patchset or approach?
> >>
> >> I'm a bit split on this one, as I really like (and want) the feature.
> >> ublk has become popular pretty quickly, and it makes a LOT of sense to
> >> support zero copy for it. At the same time, I'm not really a huge fan of
> >> the fused commands... They seem too specialized to be useful for other
> >> things, and it'd be a shame to do something like that only for it later
> >> to be replaced by a generic solution. And then we're stuck with
> >> supporting fused commands forever, not sure I like that prospect.
> >>
> >> Both Pavel and Xiaoguang voiced similar concerns, and I think it may be
> >> worth spending a bit more time on figuring out if splice can help us
> >> here. David Howells currently has a lot going on in that area too.
> > 
> > IMO, splice(->splice_read()) can help much less in this use case, and
> > I can't see improvement David Howells has done in this area:
> > 
> > 1) we need to pass reference of the whole buffer from driver to io_uring,
> > which is missed in splice, which just deals with page reference; for
> > passing whole buffer reference, we have to apply per buffer pipe to
> > solve the problem, and this way is expensive since the pipe can't
> > be freed until all buffers are consumed.
> > 
> > 2) reference can't outlive the whole buffer, and splice still misses
> > mechanism to provide such guarantee; splice can just make sure that
> > page won't be gone if page reference is grabbed, but here we care
> > more the whole buffer & its (shared)references lifetime
> > 
> > 3) current ->splice_read() misses capability to provide writeable
> > reference to spliced page[2]; either we have to pass new flags
> > to ->splice_read() or passing back new pipe buf flags, unfortunately
> > Linus thought it isn't good to extend pipe/splice for such purpose,
> > and now I agree with Linus now.
> > 
> > I believe that Pavel has realized this point[3] too, and here the only
> > of value of using pipe is to reuse ->splice_read(), however, the above
> > points show that ->splice_read() isn't good at this purpose.
> > 
> > 
> > [1] https://lore.kernel.org/linux-block/ZAk5%2FHfwc+NBwlbI@ovpn-8-17.pek2.redhat.com/
> > [2] https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/
> > [3] https://lore.kernel.org/linux-block/7cdea685-98d3-e24d-8282-87cb44ae6174@gmail.com/
> 
> splice is just one idea, but I do wonder if there's a way to express
> this relationship (and buffer handovers) that doesn't involve needing
> these odd kind of fused commands where they must be submitted as one big
> sqe, but really are two normal ones. BPF is obviously one way, and maybe

The problem can't be solved in single normal SQE, so either two normal
SQEs or single big one.

I thought of using two SQEs:

1) the 1st SQE has to be the uring command for providing buffer by
reference

2) the 2nd one consumes the buffer reference, so it depends on 1st SQE

3) the 1st SQE has to be completed after the 2nd one is done because
reference(io_uring_bvec_buf) can't outlive value(buffer, or bvec), so existed
IO_LINK can't handle this problem simply

That is why I take single big SQE, which can:

1) meet buffer & its reference lifetime requirement

2) dependence between uring command for providing buffer and normal OP which
consumes the provided buffer reference

> we'll do BPF with io_uring at some point, but it makes things rather
> more complicated to use and I'd prefer to avoid it if we can.

Agree.

> 
> I'll take a closer look at the patches.

Thanks!

-- 
Ming

