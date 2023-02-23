Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC996A0B69
	for <lists+io-uring@lfdr.de>; Thu, 23 Feb 2023 15:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbjBWOB3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Feb 2023 09:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbjBWOB2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Feb 2023 09:01:28 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C94F5678A;
        Thu, 23 Feb 2023 06:01:25 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VcKjgr3_1677160881;
Received: from 30.221.149.207(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VcKjgr3_1677160881)
          by smtp.aliyun-inc.com;
          Thu, 23 Feb 2023 22:01:22 +0800
Message-ID: <39303cc0-23d9-c769-94c0-25d3e51ed20f@linux.alibaba.com>
Date:   Thu, 23 Feb 2023 22:01:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [RFC v2 4/4] ublk_drv: add ebpf support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        ZiyangZhang@linux.alibaba.com
References: <20230222132534.114574-1-xiaoguang.wang@linux.alibaba.com>
 <20230222132534.114574-5-xiaoguang.wang@linux.alibaba.com>
 <CAADnVQ+tqakZWm8P9dLSLKxBJJanxVY3rVbbkzwhSgM2N-S2ow@mail.gmail.com>
Content-Language: en-US
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <CAADnVQ+tqakZWm8P9dLSLKxBJJanxVY3rVbbkzwhSgM2N-S2ow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On Wed, Feb 22, 2023 at 5:29 AM Xiaoguang Wang
> <xiaoguang.wang@linux.alibaba.com> wrote:
>> Currenly only one bpf_ublk_queue_sqe() ebpf is added, ublksrv target
>> can use this helper to write ebpf prog to support ublk kernel & usersapce
>> zero copy, please see ublksrv test codes for more info.
>>
>>
>> +const struct bpf_func_proto ublk_bpf_queue_sqe_proto = {
>> +       .func = bpf_ublk_queue_sqe,
>> +       .gpl_only = false,
>> +       .ret_type = RET_INTEGER,
>> +       .arg1_type = ARG_ANYTHING,
>> +       .arg2_type = ARG_ANYTHING,
>> +       .arg3_type = ARG_ANYTHING,
>> +       .arg4_type = ARG_ANYTHING,
>> +};
> You know that the above is unsafe, right?
Yes, I know it's not safe, will improve it in next version.

>
>> +
>>  static const struct bpf_func_proto *
>>  ublk_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>  {
>> -       return bpf_base_func_proto(func_id);
>> +       switch (func_id) {
>> +       case BPF_FUNC_ublk_queue_sqe:
>> +               return &ublk_bpf_queue_sqe_proto;
>> +       default:
>> +               return bpf_base_func_proto(func_id);
>> +       }
>>  }
>>
>>  static bool ublk_bpf_is_valid_access(int off, int size,
>> @@ -200,6 +252,23 @@ static bool ublk_bpf_is_valid_access(int off, int size,
>>                         const struct bpf_prog *prog,
>>                         struct bpf_insn_access_aux *info)
>>  {
>> +       if (off < 0 || off >= sizeof(struct ublk_bpf_ctx))
>> +               return false;
>> +       if (off % size != 0)
>> +               return false;
>> +
>> +       switch (off) {
>> +       case offsetof(struct ublk_bpf_ctx, q_id):
>> +               return size == sizeof_field(struct ublk_bpf_ctx, q_id);
>> +       case offsetof(struct ublk_bpf_ctx, tag):
>> +               return size == sizeof_field(struct ublk_bpf_ctx, tag);
>> +       case offsetof(struct ublk_bpf_ctx, op):
>> +               return size == sizeof_field(struct ublk_bpf_ctx, op);
>> +       case offsetof(struct ublk_bpf_ctx, nr_sectors):
>> +               return size == sizeof_field(struct ublk_bpf_ctx, nr_sectors);
>> +       case offsetof(struct ublk_bpf_ctx, start_sector):
>> +               return size == sizeof_field(struct ublk_bpf_ctx, start_sector);
>> +       }
>>         return false;
> We don't introduce stable 'ctx' anymore.
> Please see how hid-bpf is doing things.
ok, will learn it, thanks.

Regards,
Xiaoguang Wang

