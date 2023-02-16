Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CCC6993F7
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 13:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjBPMM0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 07:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBPMMZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 07:12:25 -0500
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBAF56483;
        Thu, 16 Feb 2023 04:12:22 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Vbof6OJ_1676549539;
Received: from 30.221.150.53(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Vbof6OJ_1676549539)
          by smtp.aliyun-inc.com;
          Thu, 16 Feb 2023 20:12:20 +0800
Message-ID: <54043113-e524-6ca2-ce77-08d45099aff2@linux.alibaba.com>
Date:   Thu, 16 Feb 2023 20:12:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC 3/3] ublk_drv: add ebpf support
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com
References: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
 <20230215004122.28917-4-xiaoguang.wang@linux.alibaba.com>
 <Y+3lOn04pdFtdGbr@T590>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <Y+3lOn04pdFtdGbr@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hello,

> On Wed, Feb 15, 2023 at 08:41:22AM +0800, Xiaoguang Wang wrote:
>> Currenly only one bpf_ublk_queue_sqe() ebpf is added, ublksrv target
>> can use this helper to write ebpf prog to support ublk kernel & usersapce
>> zero copy, please see ublksrv test codes for more info.
>>
>>  	 */
>> +	if ((req_op(req) == REQ_OP_WRITE) && ub->io_prep_prog)
>> +		return rq_bytes;
> Can you explain a bit why READ isn't supported? Because WRITE zero
> copy is supposed to be supported easily with splice based approach,
> and I am more interested in READ zc actually.
No special reason, READ op can also be supported. I'll
add this support in patch set v2.
For this RFC patch set, I just tried to show the idea, so
I must admit that current codes are not mature enough :)

>
>> +
>>  	if (req_op(req) != REQ_OP_WRITE && req_op(req) != REQ_OP_FLUSH)
>>  		return rq_bytes;
>>  
>> @@ -860,6 +921,89 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
>>  	}
>>  }
>>  
>>
>> +	kbuf->bvec = bvec;
>> +	rq_for_each_bvec(tmp, rq, rq_iter) {
>> +		*bvec = tmp;
>> +		bvec++;
>> +	}
>> +
>> +	kbuf->count = blk_rq_bytes(rq);
>> +	kbuf->nr_bvecs = nr_bvec;
>> +	data->kbuf = kbuf;
>> +	return 0;
> bio/req bvec table is immutable, so here you can pass its reference
> to kbuf directly.
Yeah, thanks.

>
>> +}
>> +
>> +static int ublk_run_bpf_prog(struct ublk_queue *ubq, struct request *rq)
>> +{
>> +	int err;
>> +	struct ublk_device *ub = ubq->dev;
>> +	struct bpf_prog *prog = ub->io_prep_prog;
>> +	struct ublk_io_bpf_ctx *bpf_ctx;
>> +
>> +	if (!prog)
>> +		return 0;
>> +
>> +	bpf_ctx = kmalloc(sizeof(struct ublk_io_bpf_ctx), GFP_NOIO);
>> +	if (!bpf_ctx)
>> +		return -EIO;
>> +
>> +	err = ublk_init_uring_kbuf(rq);
>> +	if (err < 0) {
>> +		kfree(bpf_ctx);
>> +		return -EIO;
>> +	}
>> +	bpf_ctx->ub = ub;
>> +	bpf_ctx->ctx.q_id = ubq->q_id;
>> +	bpf_ctx->ctx.tag = rq->tag;
>> +	bpf_ctx->ctx.op = req_op(rq);
>> +	bpf_ctx->ctx.nr_sectors = blk_rq_sectors(rq);
>> +	bpf_ctx->ctx.start_sector = blk_rq_pos(rq);
> The above is for setting up target io parameter, which is supposed
> to be from userspace, cause it is result of user space logic. If
> these parameters are from kernel, the whole logic has to be done
> in io_prep_prog.
Yeah, it's designed that io_prep_prog implements user space
io logic.

>
>> +	bpf_prog_run_pin_on_cpu(prog, bpf_ctx);
>> +
>> +	init_task_work(&bpf_ctx->work, ublk_bpf_io_submit_fn);
>> +	if (task_work_add(ubq->ubq_daemon, &bpf_ctx->work, TWA_SIGNAL_NO_IPI))
>> +		kfree(bpf_ctx);
> task_work_add() is only available in case of ublk builtin.
Yeah, I'm thinking how to work around it.

>
>> +	return 0;
>> +}
>> +
>>  static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
>>  		const struct blk_mq_queue_data *bd)
>>  {
>> @@ -872,6 +1016,9 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
>>  	if (unlikely(res != BLK_STS_OK))
>>  		return BLK_STS_IOERR;
>>  
>> +	/* Currently just for test. */
>> +	ublk_run_bpf_prog(ubq, rq);
> Can you explain the above comment a bit? When is the io_prep_prog called
> in the non-test version? Or can you post the non-test version in list
> for review.
Forgot to delete stale comments, sorry. I'm writing v2 patch set,

> Here it is the key for understanding the whole idea, especially when
> is io_prep_prog called finally? How to pass parameters to io_prep_prog?
Let me explain more about the design:
io_prep_prog has two types of parameters:
1) its call argument: struct ublk_bpf_ctx, see ublk.bpf.c.
ublk_bpf_ctx will describe one kernel io requests about
its op, qid, sectors info. io_prep_prog uses these info to
map target io.
2) ebpf map structure, user space daemon can use map
structure to pass much information from user space to
io_prep_prog, which will help it to initialize target io if necessary.

io_prep_prog is called when ublk_queue_rq() is called, this bpf
prog will initialize one or more sqes according to user logic, and
io_prep_prog will put these sqes in an ebpf map structure, then
execute a task_work_add() to notify ubq_daemon to execute
io_submit_prog. Note, we can not call io_uring_submit_sqe()
in task context that calls ublk_queue_rq(), that context does not
have io_uring instance owned by ubq_daemon.
Later ubq_daemon will call io_submit_prog to submit sqes.

>
> Given it is ebpf prog, I don't think any userspace parameter can be
> passed to io_prep_prog when submitting IO, that means all user logic has
> to be done inside io_prep_prog? If yes, not sure if it is one good way,
> cause ebpf prog is very limited programming environment, but the user
> logic could be as complicated as using btree to map io, or communicating
> with remote machine for figuring out the mapping. Loop is just the
> simplest direct mapping.
Currently, we can use ebpf map structure to pass user space
parameter to io_prep_prog. Also I agree with you that complicated
logic maybe hard to be implemented in ebpf prog, hope ebpf
community will improve this situation gradually.

For userspace target implementations I met so far, they just use
userspace block device solutions to visit distributed filesystem,
involves socket programming and have simple map io logic. We
can prepare socket fd in ebpf map structure, and these map io
logic should be easily implemented in ebpf prog, though I don't
apply this ebpf method to our internal business yet.

Thanks for review.

Regards,
Xiaoguang Wang

>
>
> Thanks, 
> Ming

