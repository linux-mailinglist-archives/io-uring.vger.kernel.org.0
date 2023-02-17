Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A4B69A418
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 04:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjBQDDQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 22:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQDDP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 22:03:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805A053832
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 19:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676602950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RjjlCMVMb3EezHMkB/Mb8sIIpSZbgw8rx0/Qxei1PM4=;
        b=c7wjxpvos5N1U6+UBp/Svq/XN/jGIcW21FSYG84cUFPjO2RS/NMugJeigqRrg0R+sq0Mc/
        jgm3qQS5YZ8kHwV955S1deNPwHuqzVtl2jc9XNheWCzr1+vbaU+oxrh+eb3yHcovfHmgi8
        sOh3mH2bIy52WC3aeOwm2MDt0AJm5/E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-LJhmi1swO3u1DRqy4uGsiw-1; Thu, 16 Feb 2023 22:02:27 -0500
X-MC-Unique: LJhmi1swO3u1DRqy4uGsiw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E17D3857A87;
        Fri, 17 Feb 2023 03:02:26 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88C31492B0E;
        Fri, 17 Feb 2023 03:02:20 +0000 (UTC)
Date:   Fri, 17 Feb 2023 11:02:14 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com, ming.lei@redhat.com
Subject: Re: [RFC 3/3] ublk_drv: add ebpf support
Message-ID: <Y+7uNpw7QBpJ4GHA@T590>
References: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
 <20230215004122.28917-4-xiaoguang.wang@linux.alibaba.com>
 <Y+3lOn04pdFtdGbr@T590>
 <54043113-e524-6ca2-ce77-08d45099aff2@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54043113-e524-6ca2-ce77-08d45099aff2@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 16, 2023 at 08:12:18PM +0800, Xiaoguang Wang wrote:
> hello,
> 
> > On Wed, Feb 15, 2023 at 08:41:22AM +0800, Xiaoguang Wang wrote:
> >> Currenly only one bpf_ublk_queue_sqe() ebpf is added, ublksrv target
> >> can use this helper to write ebpf prog to support ublk kernel & usersapce
> >> zero copy, please see ublksrv test codes for more info.
> >>
> >>  	 */
> >> +	if ((req_op(req) == REQ_OP_WRITE) && ub->io_prep_prog)
> >> +		return rq_bytes;
> > Can you explain a bit why READ isn't supported? Because WRITE zero
> > copy is supposed to be supported easily with splice based approach,
> > and I am more interested in READ zc actually.
> No special reason, READ op can also be supported. I'll
> add this support in patch set v2.
> For this RFC patch set, I just tried to show the idea, so
> I must admit that current codes are not mature enough :)

OK.

> 
> >
> >> +
> >>  	if (req_op(req) != REQ_OP_WRITE && req_op(req) != REQ_OP_FLUSH)
> >>  		return rq_bytes;
> >>  
> >> @@ -860,6 +921,89 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
> >>  	}
> >>  }
> >>  
> >>
> >> +	kbuf->bvec = bvec;
> >> +	rq_for_each_bvec(tmp, rq, rq_iter) {
> >> +		*bvec = tmp;
> >> +		bvec++;
> >> +	}
> >> +
> >> +	kbuf->count = blk_rq_bytes(rq);
> >> +	kbuf->nr_bvecs = nr_bvec;
> >> +	data->kbuf = kbuf;
> >> +	return 0;
> > bio/req bvec table is immutable, so here you can pass its reference
> > to kbuf directly.
> Yeah, thanks.

Also if this request has multiple bios, either you need to submit
multple sqes or copy all bvec into single table. And in case of single bio,
the table reference can be used directly.

> 
> >
> >> +}
> >> +
> >> +static int ublk_run_bpf_prog(struct ublk_queue *ubq, struct request *rq)
> >> +{
> >> +	int err;
> >> +	struct ublk_device *ub = ubq->dev;
> >> +	struct bpf_prog *prog = ub->io_prep_prog;
> >> +	struct ublk_io_bpf_ctx *bpf_ctx;
> >> +
> >> +	if (!prog)
> >> +		return 0;
> >> +
> >> +	bpf_ctx = kmalloc(sizeof(struct ublk_io_bpf_ctx), GFP_NOIO);
> >> +	if (!bpf_ctx)
> >> +		return -EIO;
> >> +
> >> +	err = ublk_init_uring_kbuf(rq);
> >> +	if (err < 0) {
> >> +		kfree(bpf_ctx);
> >> +		return -EIO;
> >> +	}
> >> +	bpf_ctx->ub = ub;
> >> +	bpf_ctx->ctx.q_id = ubq->q_id;
> >> +	bpf_ctx->ctx.tag = rq->tag;
> >> +	bpf_ctx->ctx.op = req_op(rq);
> >> +	bpf_ctx->ctx.nr_sectors = blk_rq_sectors(rq);
> >> +	bpf_ctx->ctx.start_sector = blk_rq_pos(rq);
> > The above is for setting up target io parameter, which is supposed
> > to be from userspace, cause it is result of user space logic. If
> > these parameters are from kernel, the whole logic has to be done
> > in io_prep_prog.
> Yeah, it's designed that io_prep_prog implements user space
> io logic.

That could be the biggest weakness of this approach, because people
really want to implement complicated logic in userspace, which should
be the biggest value of ublk, but now seems you move kernel C
programming into ebpf userspace programming, I don't think ebpf
is good at handling complicated userspace logic.

> 
> >
> >> +	bpf_prog_run_pin_on_cpu(prog, bpf_ctx);
> >> +
> >> +	init_task_work(&bpf_ctx->work, ublk_bpf_io_submit_fn);
> >> +	if (task_work_add(ubq->ubq_daemon, &bpf_ctx->work, TWA_SIGNAL_NO_IPI))
> >> +		kfree(bpf_ctx);
> > task_work_add() is only available in case of ublk builtin.
> Yeah, I'm thinking how to work around it.
> 
> >
> >> +	return 0;
> >> +}
> >> +
> >>  static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
> >>  		const struct blk_mq_queue_data *bd)
> >>  {
> >> @@ -872,6 +1016,9 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
> >>  	if (unlikely(res != BLK_STS_OK))
> >>  		return BLK_STS_IOERR;
> >>  
> >> +	/* Currently just for test. */
> >> +	ublk_run_bpf_prog(ubq, rq);
> > Can you explain the above comment a bit? When is the io_prep_prog called
> > in the non-test version? Or can you post the non-test version in list
> > for review.
> Forgot to delete stale comments, sorry. I'm writing v2 patch set,

OK, got it, so looks ublk_run_bpf_prog is designed to run two progs
loaded from two control commands.

> 
> > Here it is the key for understanding the whole idea, especially when
> > is io_prep_prog called finally? How to pass parameters to io_prep_prog?
> Let me explain more about the design:
> io_prep_prog has two types of parameters:
> 1) its call argument: struct ublk_bpf_ctx, see ublk.bpf.c.
> ublk_bpf_ctx will describe one kernel io requests about
> its op, qid, sectors info. io_prep_prog uses these info to
> map target io.
> 2) ebpf map structure, user space daemon can use map
> structure to pass much information from user space to
> io_prep_prog, which will help it to initialize target io if necessary.
> 
> io_prep_prog is called when ublk_queue_rq() is called, this bpf
> prog will initialize one or more sqes according to user logic, and
> io_prep_prog will put these sqes in an ebpf map structure, then
> execute a task_work_add() to notify ubq_daemon to execute
> io_submit_prog. Note, we can not call io_uring_submit_sqe()
> in task context that calls ublk_queue_rq(), that context does not
> have io_uring instance owned by ubq_daemon.
> Later ubq_daemon will call io_submit_prog to submit sqes.

Submitting sqe from kernel looks interesting, but I guess
performance may be hurt, given plugging(batching) can't be applied
any more, which is supposed to affect io perf a lot.



Thanks,
Ming

