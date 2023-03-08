Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFFF6B0E6F
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 17:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCHQSk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 11:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCHQSj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 11:18:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF8DC1C38
        for <io-uring@vger.kernel.org>; Wed,  8 Mar 2023 08:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678292263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wT0bOwIurNPu04VZHoA/6oaAulTGzpLXdNBB6RkBKL8=;
        b=RQx1PMTiERt/9ieEtmt9qlS5Ij7qT+vHQ+bWDIERvQHBf/ytrwCWR1JsCT09sSLtiZWckF
        g8fk+Rp6FcYih4V112Gi+9qEJK7rgFn8EikV0WpghuBM9G27umanfoF9501WGEG+vVgZVz
        v1pKv3n1lNg7eNk+D71jZ7B2n6UGHhM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-E0eW84TUPZCZ-62HJDLN3w-1; Wed, 08 Mar 2023 11:17:40 -0500
X-MC-Unique: E0eW84TUPZCZ-62HJDLN3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90B56380451D;
        Wed,  8 Mar 2023 16:17:39 +0000 (UTC)
Received: from ovpn-8-17.pek2.redhat.com (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 834B8C15BA0;
        Wed,  8 Mar 2023 16:17:33 +0000 (UTC)
Date:   Thu, 9 Mar 2023 00:17:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZAi1GKgHfLcDL2jM@ovpn-8-17.pek2.redhat.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
 <ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com>
 <ZAfurtfY4lXa8sxX@ovpn-8-16.pek2.redhat.com>
 <effb2361-b66e-2678-ef86-5f9565c4ad9a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <effb2361-b66e-2678-ef86-5f9565c4ad9a@gmail.com>
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

On Wed, Mar 08, 2023 at 02:46:48PM +0000, Pavel Begunkov wrote:
> On 3/8/23 02:10, Ming Lei wrote:
> > On Tue, Mar 07, 2023 at 05:17:04PM +0000, Pavel Begunkov wrote:
> > > On 3/7/23 15:37, Pavel Begunkov wrote:
> > > > On 3/7/23 14:15, Ming Lei wrote:
> > > > > Hello,
> > > > > 
> > > > > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > > > > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > > > > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > > > > to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> > > > > and its ->issue() can retrieve/import buffer from master request's
> > > > > fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> > > > > this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> > > > > submits slave OP just like normal OP issued from userspace, that said,
> > > > > SQE order is kept, and batching handling is done too.
> > > > 
> > > >   From a quick look through patches it all looks a bit complicated
> > > > and intrusive, all over generic hot paths. I think instead we
> > > > should be able to use registered buffer table as intermediary and
> > > > reuse splicing. Let me try it out
> > > 
> > > Here we go, isolated in a new opcode, and in the end should work
> > > with any file supporting splice. It's a quick prototype, it's lacking
> > > and there are many obvious fatal bugs. It also needs some optimisations,
> > > improvements on how executed by io_uring and extra stuff like
> > > memcpy ops and fixed buf recv/send. I'll clean it up.
> > > 
> > > I used a test below, it essentially does zc recv.
> > > 
> > > https://github.com/isilence/liburing/commit/81fe705739af7d9b77266f9aa901c1ada870739d
> > > 
> [...]
> > > +int io_splice_from(struct io_kiocb *req, unsigned int issue_flags)
> > > +{
> > > +	struct io_splice_from *sp = io_kiocb_to_cmd(req, struct io_splice_from);
> > > +	loff_t *ppos = (sp->off == -1) ? NULL : &sp->off;
> > > +	struct io_mapped_ubuf *imu;
> > > +	struct pipe_inode_info *pi;
> > > +	struct io_ring_ctx *ctx;
> > > +	unsigned int pipe_tail;
> > > +	int ret, i, nr_pages;
> > > +	u16 index;
> > > +
> > > +	if (!sp->file->f_op->splice_read)
> > > +		return -ENOTSUPP;
> > > +
> > > +	pi = alloc_pipe_info();
> > 
> > The above should be replaced with direct pipe, otherwise every time
> > allocating one pipe inode really hurts performance.
> 
> We don't even need to alloc it dynanically, could be just
> on stack. There is a long list of TODOs I can add, e.g.
> polling support, retries, nowait, caching imu and so on.
> 
> [...]
> > Your patch looks like transferring pages ownership to io_uring fixed
> > buffer, but unfortunately it can't be done in this way. splice is
> > supposed for moving data, not transfer buffer ownership.
> 
> Borrowing rather than transferring. It's not obvious since it's
> not implemented in the patch, but the buffer should be eventually
> returned using the splice's ->release callback.

What is the splice's ->release() callback? Is pipe buffer's
release()? If yes, there is at least the following two problems:

1) it requires the buffer to be saved(for calling its callback and use its private
data to return back the whole buffer) in the pipe until it is consumed, which becomes
one sync interface like splice syscall, and can't cross multiple io_uring OPs or
per-buffer pipe inode is needed

2) pipe buffer's get()/release() works on per-buffer/page level, but
we need to borrow the whole buffer, and the whole buffer could be used
by arbitrary number of OPs, such as one IO buffer needs to be used for
handling mirror or stripped targets, so when we know the buffer can be released?

And basically it can't be known by kernel, and only application knows
when to release it.

Anyway, please post the whole patch, otherwise it is hard to see
the whole picture, and devil is always in details, especially Linus
mentioned splice can't be used in this way.

> 
> > https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/
> > 
> > 1) pages are actually owned by device side(ublk, here: sp->file), but we want to
> > loan them to io_uring normal OPs.
> > 
> > 2) after these pages are used by io_uring normal OPs, these pages have
> > been returned back to sp->file, and the notification has to be done
> > explicitly, because page is owned by sp->file of splice_read().
> 
> Right, see above, they're going to be returned back via ->release.

How?

> 
> > 3) pages RW direction has to limited strictly, and in case of ublk/fuse,
> > device pages can only be read or write which depends on user io request
> > direction.
> 
> Yes, I know, and directions will be needed anyway for DMA mappings and
> different p2p cases in the future, but again a bunch of things is
> omitted here.

Please don't omitted it and it is one fundamental security problem.

> 
> > 
> > Also IMO it isn't good to add one buffer to ctx->user_bufs[] oneshot and
> > retrieve it oneshot, and it can be set via req->imu simply in one fused
> > command.
> 
> That's one of the points though. It's nice if not necessary (for a generic
> feature) to be able to do multiple ops on the data. For instance, if we
> have a memcpy request, we can link it to this splice / zc recv, memcpy
> necessary headers to the userspace and let it decide how to proceed with
> data.

I feel it could be one big problem for buffer borrowing to cross more than one
OPs, and when can the buffer be returned back?

memory copy can be done simply by device's read/write interface, please see
patch 15.


Thanks,
Ming

