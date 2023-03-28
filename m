Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AD36CB38B
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 04:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjC1CDt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 22:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjC1CDp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 22:03:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6693B2
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 19:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679968977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z+FqEPJNucRwHbPqzEVTmeG1neXFruKCfqBC3cpAa3c=;
        b=JAQx9D6A3K0jvT+xzxOd9Op8Pmij6T8QuKDAUOEXjoIdYXChwY9/u8WPZOBNg7iymr+yOy
        rI6ZmzR7WzsRCuqh3ESISFK6pcbCRtdzpb5iIConmgSSLGXep9N9r66IYl6iTHGJjpcnJy
        ayo7UaYOF/kuFAumhW/gPqdfl8bLvw4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-xNtOs8SCPH2haJiCiLiCvA-1; Mon, 27 Mar 2023 22:02:54 -0400
X-MC-Unique: xNtOs8SCPH2haJiCiLiCvA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA46085A588;
        Tue, 28 Mar 2023 02:02:53 +0000 (UTC)
Received: from ovpn-8-20.pek2.redhat.com (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C521492C3E;
        Tue, 28 Mar 2023 02:02:46 +0000 (UTC)
Date:   Tue, 28 Mar 2023 10:02:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, ming.lei@redhat.com
Subject: Re: [PATCH V4 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZCJKwQLE3Fu2udmG@ovpn-8-20.pek2.redhat.com>
References: <20230324135808.855245-1-ming.lei@redhat.com>
 <642236912a229_29cc2942c@dwillia2-xfh.jf.intel.com.notmuch>
 <ZCJABlFshb0UmTMv@ovpn-8-20.pek2.redhat.com>
 <6422437981a0b_21a8294d0@dwillia2-xfh.jf.intel.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6422437981a0b_21a8294d0@dwillia2-xfh.jf.intel.com.notmuch>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 27, 2023 at 06:31:37PM -0700, Dan Williams wrote:
> Ming Lei wrote:
> > Hi Dan,
> > 
> > On Mon, Mar 27, 2023 at 05:36:33PM -0700, Dan Williams wrote:
> > > Ming Lei wrote:
> > > > Hello Jens,
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
> > > Hi Ming,
> > > 
> > > io_uring and ublk are starting to be more on my radar these days. I
> > > wanted to take a look at this series, but could not get past the
> > > distracting "master"/"slave" terminology in this lead-in paragraph let
> > > alone start looking at patches.
> > > 
> > > Frankly, the description sounds more like "head"/"tail", or even
> > > "fuse0"/"fuse1" because, for example, who is to say you might not have
> > 
> > The term "master/slave" is from patches.
> 
> From what patches?

https://lore.kernel.org/linux-block/20230324135808.855245-3-ming.lei@redhat.com/T/#u

> 
> I did not understand this explanation either:
> 
> https://lore.kernel.org/all/ZBXjH5ipRUwtYIVF@ovpn-8-18.pek2.redhat.com/

Jens just suggested primary/secondary, which looks better, and I will
use them in this thread and next version.

> 
> > The master command not only provides buffer for slave request, but also requires
> > slave request for serving master command, and master command is always completed
> > after all slave request are done.
> 
> In terms of core kernel concepts that description aligns more with
> idiomatic "parent"/"child" relationships where the child object holds a
> reference on the parent.

Yeah, holding reference is true for both two relationships.

But "parent"/"child" relationship is often one long-time relation, but here
both requests are short-time objects, just the secondary requests need to
grab primary command buffer for running IO. After secondary requests IO
is done, the relation is over. So it is sort of temporary/short-term relation,
like contract.

Also the buffer meta(bvec) data are readable for all secondary requests,
and secondary requests have to use buffer in the primary command allowed
direction. So the relation is very limited.

> 
> > That is why it is named as master/slave.
> 
> That explanation did not clarify.

Hope the above words help.

> 
> > Actually Jens raised the similar concern
> 
> Thanks Jens!
> 
> > ...and I hate the name too, but it is always hard to figure out
> > perfect name, or any other name for reflecting the relation?
> > (head/tail, fuse0/1 can't do that, IMO)
> 
> Naming is hard, and master/slave is not appropriate so this needs a new
> name. The reason I mentioned "head"/"tail" is not for ring buffer
> purposes but more for its similarity to pages and folios where the folio
> is not unreferenced until all tail pages are unreferenced.
> 
> In short there are several options that add more clarity and avoid
> running afoul of coding-style.
> 
> > > larger fused ops in the future and need terminology to address
> > > "fuse{0,1,2,3}"?
> > 
> > Yeah, definitely, the interface can be extended in future to support
> > multiple "slave" requests.
> 
> Right, so why not just name them fuse0,1...n and specify that fuse0 is
> the head of a fused op?

fuse0, 1...n often means all these objects sharing common property, such
as, all are objects of same class. However, here we do know primary is
completely different with secondary.


Thanks,
Ming

