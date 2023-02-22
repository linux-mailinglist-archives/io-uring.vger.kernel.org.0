Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16DC69FC15
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 20:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjBVT0n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 14:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbjBVT0k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 14:26:40 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB5541B62;
        Wed, 22 Feb 2023 11:26:12 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id da10so36034018edb.3;
        Wed, 22 Feb 2023 11:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GEdeqff+ZwrmFl+/DPm1pzL6a0UpHLPfrOHqKHeVa8U=;
        b=QYXjSAAZkK/Afobeq+u1rOSJczjvPhRV9GdtzLxlk4eruICYMI+WRWhREUuG9TcKP1
         P03eemUdzp5vHlKv/xLycGSTF1IBgr05Vj9lf2XMJxy0wKIAqLlvoPAZnamwP1OwbRSp
         kJ5d+Mdkt7MuyHIOJU8yb5D9gkUhwhH9f4sJwcMPQ/LHaMl8+64PyUj3nxti1tw20gJT
         HLKCGVIhHifrhgtTWjklC3DkJCLezcmR8xsCZW+3ArwwXXbr8flO3JO97UpLdkVUT+Pw
         2Ofegk32/XJz9wD9Vr0ao4DZ56PBXUfZqZjRBtGj23uU4qgEuuZ8VdleoQ700lyrGBRj
         RzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GEdeqff+ZwrmFl+/DPm1pzL6a0UpHLPfrOHqKHeVa8U=;
        b=bYsriXt0yHmYDhdDwP7+crAZWIu8xshlIS5cZ9wSJBksOBMlIu908zxUDt81m07PoB
         K7s31epFLAbkqjoU9Eww6yMLKeoGqyLofxv349KvkGfVzPGvh8W8043oJK/nob7uDlrG
         vsRbQC7Ft2OytlDBRKklCM6eUrj1gdUlBb1I3UomBpe9jIdVSwtac9UINNI6Sd2Eh9f4
         E1VOgue2MSH+bVRtFZpLtREZKRG1yr7+Eimbdc64VSf0B8qohD9APExoVGNc94zxQ7/d
         EWVzdzy6GGgFQqdt4Xg0XKd4BB0wOoPjlRq1KMafLDbGyG/g6BYrMJS+d7Y7YnhWARGl
         6qZg==
X-Gm-Message-State: AO0yUKUr9AsEaFWKT8g7JlOyRfqVBP8JA4NILpKk6pwaV25NwX6HaExj
        zCspF2HF1sHfc3mswZFeXO2Rjzq7zL3xvvjrKAw=
X-Google-Smtp-Source: AK7set9qHvUzbNZTdJFG9Acy28tlzQMIjDnfj/+yEawVdViK0agWobnFI4UtD3refZro4AYi/rA3KBBn2NRR3tetq2E=
X-Received: by 2002:a17:906:48c9:b0:8ae:9f1e:a1c5 with SMTP id
 d9-20020a17090648c900b008ae9f1ea1c5mr7763755ejt.3.1677093969895; Wed, 22 Feb
 2023 11:26:09 -0800 (PST)
MIME-Version: 1.0
References: <20230222132534.114574-1-xiaoguang.wang@linux.alibaba.com> <20230222132534.114574-5-xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <20230222132534.114574-5-xiaoguang.wang@linux.alibaba.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Feb 2023 11:25:58 -0800
Message-ID: <CAADnVQ+tqakZWm8P9dLSLKxBJJanxVY3rVbbkzwhSgM2N-S2ow@mail.gmail.com>
Subject: Re: [RFC v2 4/4] ublk_drv: add ebpf support
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        ZiyangZhang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 22, 2023 at 5:29 AM Xiaoguang Wang
<xiaoguang.wang@linux.alibaba.com> wrote:
>
> Currenly only one bpf_ublk_queue_sqe() ebpf is added, ublksrv target
> can use this helper to write ebpf prog to support ublk kernel & usersapce
> zero copy, please see ublksrv test codes for more info.
>
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  drivers/block/ublk_drv.c       | 263 +++++++++++++++++++++++++++++++--
>  include/uapi/linux/bpf.h       |   1 +
>  include/uapi/linux/ublk_cmd.h  |  18 +++
>  kernel/bpf/verifier.c          |   3 +-
>  scripts/bpf_doc.py             |   4 +
>  tools/include/uapi/linux/bpf.h |   9 ++
>  6 files changed, 286 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index b628e9eaefa6..d17ddb6fc27f 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -105,6 +105,12 @@ struct ublk_uring_cmd_pdu {
>   */
>  #define UBLK_IO_FLAG_NEED_GET_DATA 0x08
>
> +/*
> + * UBLK_IO_FLAG_BPF is set if IO command has be handled by ebpf prog instead
> + * of user space daemon.
> + */
> +#define UBLK_IO_FLAG_BPF       0x10
> +
>  struct ublk_io {
>         /* userspace buffer address from io cmd */
>         __u64   addr;
> @@ -114,6 +120,11 @@ struct ublk_io {
>         struct io_uring_cmd *cmd;
>  };
>
> +struct ublk_req_iter {
> +       struct io_fixed_iter fixed_iter;
> +       struct bio_vec *bvec;
> +};
> +
>  struct ublk_queue {
>         int q_id;
>         int q_depth;
> @@ -163,6 +174,9 @@ struct ublk_device {
>         unsigned int            nr_queues_ready;
>         atomic_t                nr_aborted_queues;
>
> +       struct bpf_prog         *io_bpf_prog;
> +       struct ublk_req_iter    *iter_table;
> +
>         /*
>          * Our ubq->daemon may be killed without any notification, so
>          * monitor each queue's daemon periodically
> @@ -189,10 +203,48 @@ static DEFINE_MUTEX(ublk_ctl_mutex);
>
>  static struct miscdevice ublk_misc;
>
> +struct ublk_io_bpf_ctx {
> +       struct ublk_bpf_ctx ctx;
> +       struct ublk_device *ub;
> +};
> +
> +static inline struct ublk_req_iter *ublk_get_req_iter(struct ublk_device *ub,
> +                                       int qid, int tag)
> +{
> +       return &(ub->iter_table[qid * ub->dev_info.queue_depth + tag]);
> +}
> +
> +BPF_CALL_4(bpf_ublk_queue_sqe, struct ublk_io_bpf_ctx *, bpf_ctx,
> +          struct io_uring_sqe *, sqe, u32, sqe_len, u32, fd)
> +{
> +       struct ublk_req_iter *req_iter;
> +       u16 q_id = bpf_ctx->ctx.q_id;
> +       u16 tag = bpf_ctx->ctx.tag;
> +
> +       req_iter = ublk_get_req_iter(bpf_ctx->ub, q_id, tag);
> +       io_uring_submit_sqe(fd, sqe, sqe_len, &(req_iter->fixed_iter));
> +       return 0;
> +}
> +
> +const struct bpf_func_proto ublk_bpf_queue_sqe_proto = {
> +       .func = bpf_ublk_queue_sqe,
> +       .gpl_only = false,
> +       .ret_type = RET_INTEGER,
> +       .arg1_type = ARG_ANYTHING,
> +       .arg2_type = ARG_ANYTHING,
> +       .arg3_type = ARG_ANYTHING,
> +       .arg4_type = ARG_ANYTHING,
> +};

You know that the above is unsafe, right?

> +
>  static const struct bpf_func_proto *
>  ublk_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  {
> -       return bpf_base_func_proto(func_id);
> +       switch (func_id) {
> +       case BPF_FUNC_ublk_queue_sqe:
> +               return &ublk_bpf_queue_sqe_proto;
> +       default:
> +               return bpf_base_func_proto(func_id);
> +       }
>  }
>
>  static bool ublk_bpf_is_valid_access(int off, int size,
> @@ -200,6 +252,23 @@ static bool ublk_bpf_is_valid_access(int off, int size,
>                         const struct bpf_prog *prog,
>                         struct bpf_insn_access_aux *info)
>  {
> +       if (off < 0 || off >= sizeof(struct ublk_bpf_ctx))
> +               return false;
> +       if (off % size != 0)
> +               return false;
> +
> +       switch (off) {
> +       case offsetof(struct ublk_bpf_ctx, q_id):
> +               return size == sizeof_field(struct ublk_bpf_ctx, q_id);
> +       case offsetof(struct ublk_bpf_ctx, tag):
> +               return size == sizeof_field(struct ublk_bpf_ctx, tag);
> +       case offsetof(struct ublk_bpf_ctx, op):
> +               return size == sizeof_field(struct ublk_bpf_ctx, op);
> +       case offsetof(struct ublk_bpf_ctx, nr_sectors):
> +               return size == sizeof_field(struct ublk_bpf_ctx, nr_sectors);
> +       case offsetof(struct ublk_bpf_ctx, start_sector):
> +               return size == sizeof_field(struct ublk_bpf_ctx, start_sector);
> +       }
>         return false;

We don't introduce stable 'ctx' anymore.
Please see how hid-bpf is doing things.
