Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776A9698E61
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 09:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBPIMo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 03:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjBPIMl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 03:12:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A7828855
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 00:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676535114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bLiI8Cs8GTJaqbUl8yfRkBufA2tSGWh+a0jF9gutzko=;
        b=HVPi8fe9UaDnuFyPM6NxB9W6NC07Y0jJG87qy9VapZ/2MAQwlosfN9Eno8PmcoeU7kj7v/
        rRaTJdfXJTi61SUm123wY/HNn0AYp+lOWGKPx0VVhxcI0E1dwPqAZm3DdOowDM7S6PvDNm
        HomT8YTu/UEq3lGXPYegnk9iBDLJCxE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-CfIr1rMmPyiePNUnB60YKA-1; Thu, 16 Feb 2023 03:11:50 -0500
X-MC-Unique: CfIr1rMmPyiePNUnB60YKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D26B53C025AC;
        Thu, 16 Feb 2023 08:11:49 +0000 (UTC)
Received: from T590 (ovpn-8-29.pek2.redhat.com [10.72.8.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 51F511121314;
        Thu, 16 Feb 2023 08:11:43 +0000 (UTC)
Date:   Thu, 16 Feb 2023 16:11:38 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com, ming.lei@redhat.com
Subject: Re: [RFC 3/3] ublk_drv: add ebpf support
Message-ID: <Y+3lOn04pdFtdGbr@T590>
References: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
 <20230215004122.28917-4-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215004122.28917-4-xiaoguang.wang@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 15, 2023 at 08:41:22AM +0800, Xiaoguang Wang wrote:
> Currenly only one bpf_ublk_queue_sqe() ebpf is added, ublksrv target
> can use this helper to write ebpf prog to support ublk kernel & usersapce
> zero copy, please see ublksrv test codes for more info.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  drivers/block/ublk_drv.c       | 207 ++++++++++++++++++++++++++++++++-
>  include/uapi/linux/bpf.h       |   1 +
>  include/uapi/linux/ublk_cmd.h  |  11 ++
>  scripts/bpf_doc.py             |   4 +
>  tools/include/uapi/linux/bpf.h |   8 ++
>  5 files changed, 229 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index b628e9eaefa6..44c289b72864 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -61,6 +61,7 @@
>  struct ublk_rq_data {
>  	struct llist_node node;
>  	struct callback_head work;
> +	struct io_mapped_kbuf *kbuf;
>  };
>  
>  struct ublk_uring_cmd_pdu {
> @@ -163,6 +164,9 @@ struct ublk_device {
>  	unsigned int		nr_queues_ready;
>  	atomic_t		nr_aborted_queues;
>  
> +	struct bpf_prog		*io_prep_prog;
> +	struct bpf_prog		*io_submit_prog;
> +
>  	/*
>  	 * Our ubq->daemon may be killed without any notification, so
>  	 * monitor each queue's daemon periodically
> @@ -189,10 +193,46 @@ static DEFINE_MUTEX(ublk_ctl_mutex);
>  
>  static struct miscdevice ublk_misc;
>  
> +struct ublk_io_bpf_ctx {
> +	struct ublk_bpf_ctx ctx;
> +	struct ublk_device *ub;
> +	struct callback_head work;
> +};
> +
> +BPF_CALL_4(bpf_ublk_queue_sqe, struct ublk_io_bpf_ctx *, bpf_ctx,
> +	   struct io_uring_sqe *, sqe, u32, sqe_len, u32, fd)
> +{
> +	struct request *rq;
> +	struct ublk_rq_data *data;
> +	struct io_mapped_kbuf *kbuf;
> +	u16 q_id = bpf_ctx->ctx.q_id;
> +	u16 tag = bpf_ctx->ctx.tag;
> +
> +	rq = blk_mq_tag_to_rq(bpf_ctx->ub->tag_set.tags[q_id], tag);
> +	data = blk_mq_rq_to_pdu(rq);
> +	kbuf = data->kbuf;
> +	io_uring_submit_sqe(fd, sqe, sqe_len, kbuf);
> +	return 0;
> +}
> +
> +const struct bpf_func_proto ublk_bpf_queue_sqe_proto = {
> +	.func = bpf_ublk_queue_sqe,
> +	.gpl_only = false,
> +	.ret_type = RET_INTEGER,
> +	.arg1_type = ARG_ANYTHING,
> +	.arg2_type = ARG_ANYTHING,
> +	.arg3_type = ARG_ANYTHING,
> +};
> +
>  static const struct bpf_func_proto *
>  ublk_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  {
> -	return bpf_base_func_proto(func_id);
> +	switch (func_id) {
> +	case BPF_FUNC_ublk_queue_sqe:
> +		return &ublk_bpf_queue_sqe_proto;
> +	default:
> +		return bpf_base_func_proto(func_id);
> +	}
>  }
>  
>  static bool ublk_bpf_is_valid_access(int off, int size,
> @@ -200,6 +240,23 @@ static bool ublk_bpf_is_valid_access(int off, int size,
>  			const struct bpf_prog *prog,
>  			struct bpf_insn_access_aux *info)
>  {
> +	if (off < 0 || off >= sizeof(struct ublk_bpf_ctx))
> +		return false;
> +	if (off % size != 0)
> +		return false;
> +
> +	switch (off) {
> +	case offsetof(struct ublk_bpf_ctx, q_id):
> +		return size == sizeof_field(struct ublk_bpf_ctx, q_id);
> +	case offsetof(struct ublk_bpf_ctx, tag):
> +		return size == sizeof_field(struct ublk_bpf_ctx, tag);
> +	case offsetof(struct ublk_bpf_ctx, op):
> +		return size == sizeof_field(struct ublk_bpf_ctx, op);
> +	case offsetof(struct ublk_bpf_ctx, nr_sectors):
> +		return size == sizeof_field(struct ublk_bpf_ctx, nr_sectors);
> +	case offsetof(struct ublk_bpf_ctx, start_sector):
> +		return size == sizeof_field(struct ublk_bpf_ctx, start_sector);
> +	}
>  	return false;
>  }
>  
> @@ -324,7 +381,7 @@ static void ublk_put_device(struct ublk_device *ub)
>  static inline struct ublk_queue *ublk_get_queue(struct ublk_device *dev,
>  		int qid)
>  {
> -       return (struct ublk_queue *)&(dev->__queues[qid * dev->queue_size]);
> +	return (struct ublk_queue *)&(dev->__queues[qid * dev->queue_size]);
>  }
>  
>  static inline bool ublk_rq_has_data(const struct request *rq)
> @@ -492,12 +549,16 @@ static inline int ublk_copy_user_pages(struct ublk_map_data *data,
>  static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
>  		struct ublk_io *io)
>  {
> +	struct ublk_device *ub = ubq->dev;
>  	const unsigned int rq_bytes = blk_rq_bytes(req);
>  	/*
>  	 * no zero copy, we delay copy WRITE request data into ublksrv
>  	 * context and the big benefit is that pinning pages in current
>  	 * context is pretty fast, see ublk_pin_user_pages
>  	 */
> +	if ((req_op(req) == REQ_OP_WRITE) && ub->io_prep_prog)
> +		return rq_bytes;

Can you explain a bit why READ isn't supported? Because WRITE zero
copy is supposed to be supported easily with splice based approach,
and I am more interested in READ zc actually.

> +
>  	if (req_op(req) != REQ_OP_WRITE && req_op(req) != REQ_OP_FLUSH)
>  		return rq_bytes;
>  
> @@ -860,6 +921,89 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
>  	}
>  }
>  
> +static void ublk_bpf_io_submit_fn(struct callback_head *work)
> +{
> +	struct ublk_io_bpf_ctx *bpf_ctx = container_of(work,
> +			struct ublk_io_bpf_ctx, work);
> +
> +	if (bpf_ctx->ub->io_submit_prog)
> +		bpf_prog_run_pin_on_cpu(bpf_ctx->ub->io_submit_prog, bpf_ctx);
> +	kfree(bpf_ctx);
> +}
> +
> +static int ublk_init_uring_kbuf(struct request *rq)
> +{
> +	struct bio_vec *bvec;
> +	struct req_iterator rq_iter;
> +	struct bio_vec tmp;
> +	int nr_bvec = 0;
> +	struct io_mapped_kbuf *kbuf;
> +	struct ublk_rq_data *data = blk_mq_rq_to_pdu(rq);
> +
> +	/* Drop previous allocation */
> +	if (data->kbuf) {
> +		kfree(data->kbuf->bvec);
> +		kfree(data->kbuf);
> +		data->kbuf = NULL;
> +	}
> +
> +	kbuf = kmalloc(sizeof(struct io_mapped_kbuf), GFP_NOIO);
> +	if (!kbuf)
> +		return -EIO;
> +
> +	rq_for_each_bvec(tmp, rq, rq_iter)
> +		nr_bvec++;
> +
> +	bvec = kmalloc_array(nr_bvec, sizeof(struct bio_vec), GFP_NOIO);
> +	if (!bvec) {
> +		kfree(kbuf);
> +		return -EIO;
> +	}
> +	kbuf->bvec = bvec;
> +	rq_for_each_bvec(tmp, rq, rq_iter) {
> +		*bvec = tmp;
> +		bvec++;
> +	}
> +
> +	kbuf->count = blk_rq_bytes(rq);
> +	kbuf->nr_bvecs = nr_bvec;
> +	data->kbuf = kbuf;
> +	return 0;

bio/req bvec table is immutable, so here you can pass its reference
to kbuf directly.

> +}
> +
> +static int ublk_run_bpf_prog(struct ublk_queue *ubq, struct request *rq)
> +{
> +	int err;
> +	struct ublk_device *ub = ubq->dev;
> +	struct bpf_prog *prog = ub->io_prep_prog;
> +	struct ublk_io_bpf_ctx *bpf_ctx;
> +
> +	if (!prog)
> +		return 0;
> +
> +	bpf_ctx = kmalloc(sizeof(struct ublk_io_bpf_ctx), GFP_NOIO);
> +	if (!bpf_ctx)
> +		return -EIO;
> +
> +	err = ublk_init_uring_kbuf(rq);
> +	if (err < 0) {
> +		kfree(bpf_ctx);
> +		return -EIO;
> +	}
> +	bpf_ctx->ub = ub;
> +	bpf_ctx->ctx.q_id = ubq->q_id;
> +	bpf_ctx->ctx.tag = rq->tag;
> +	bpf_ctx->ctx.op = req_op(rq);
> +	bpf_ctx->ctx.nr_sectors = blk_rq_sectors(rq);
> +	bpf_ctx->ctx.start_sector = blk_rq_pos(rq);

The above is for setting up target io parameter, which is supposed
to be from userspace, cause it is result of user space logic. If
these parameters are from kernel, the whole logic has to be done
in io_prep_prog.

> +	bpf_prog_run_pin_on_cpu(prog, bpf_ctx);
> +
> +	init_task_work(&bpf_ctx->work, ublk_bpf_io_submit_fn);
> +	if (task_work_add(ubq->ubq_daemon, &bpf_ctx->work, TWA_SIGNAL_NO_IPI))
> +		kfree(bpf_ctx);

task_work_add() is only available in case of ublk builtin.

> +	return 0;
> +}
> +
>  static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		const struct blk_mq_queue_data *bd)
>  {
> @@ -872,6 +1016,9 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	if (unlikely(res != BLK_STS_OK))
>  		return BLK_STS_IOERR;
>  
> +	/* Currently just for test. */
> +	ublk_run_bpf_prog(ubq, rq);

Can you explain the above comment a bit? When is the io_prep_prog called
in the non-test version? Or can you post the non-test version in list
for review.

Here it is the key for understanding the whole idea, especially when
is io_prep_prog called finally? How to pass parameters to io_prep_prog?

Given it is ebpf prog, I don't think any userspace parameter can be
passed to io_prep_prog when submitting IO, that means all user logic has
to be done inside io_prep_prog? If yes, not sure if it is one good way,
cause ebpf prog is very limited programming environment, but the user
logic could be as complicated as using btree to map io, or communicating
with remote machine for figuring out the mapping. Loop is just the
simplest direct mapping.


Thanks, 
Ming

