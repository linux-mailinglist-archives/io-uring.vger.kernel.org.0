Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BAB4D4296
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 09:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbiCJIeQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 03:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240369AbiCJIeP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 03:34:15 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A525C864;
        Thu, 10 Mar 2022 00:33:12 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id n19so8100838lfh.8;
        Thu, 10 Mar 2022 00:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CHbpwpNAXxSBKfhDwIRmudJnsbVYGAke39m3xKYChPE=;
        b=L/DkDf9IC2x74KpLQAlmtKu3IaTcmokKlvdUBeJzpMWmhxTRloGr2UzxDAyiEnDr0i
         Pti1RmTn59LLWHUg2e4IMofp6JY+7MBZUON552Tx8W1DeqkoV9/e4P7XtL4AMxwBFtKg
         u/Sr4BwLmYLN/Mtw3tGxluKjrI7FqlMTwWPUYVNn+ZmXEHmchbPoNTlv4/Ff90CpXlgv
         ylzHH2keNi9xhF1r7Q0MRn3Ub+yq1KAXSCncY8uEUnoU6Fu9sNGPQ37dxGyWlJwiSfu1
         UL/rAL+3AC+lv3hDPYiyUBmk+qTPa//Fj4oybspPvTDRe4DHwlFEhYw0KguCpqtJyQG+
         zeyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CHbpwpNAXxSBKfhDwIRmudJnsbVYGAke39m3xKYChPE=;
        b=dzZeH0virluXIepJsCkoFStkbNj+CLSb5UHJKgGHJFgoroZBlWQGuYGOB8wEHKPYjE
         0i8wAGwJqvilhTO38LNAZ2RHtriTQKXUAnp9+jbihevWeDN3vPdqUpfPylQEXfODjukd
         Nbj9KHlIgIAqTnhHokQ4NeoF1bChzoYmgWQ+WNTaEha08cwldo2F7Li2DiaL3ln9Sx/5
         PDQI3C0NxwgaNbPYI+tbreKdwO+F4W9jHdZph7TmecbqlPe+qKqQtIwM8QAgpAjRMxIj
         feCrIVNescAAsMxUk6eFY8xDdtqZpFTIKrzzSrKnuDVap+Tfu8UuFnIGBMGEempHc8ah
         O1cg==
X-Gm-Message-State: AOAM533vsm+8ety/yrbTgXa0r+4JKlejaGvcS1lV3xLTZwkEhkH/Ljlo
        M82uLibHilZLxOJPNKN+PCV8ex0x5I/m1P44Ifw=
X-Google-Smtp-Source: ABdhPJywu0uHNvT9G5e/CDKAa05XQh1Gy4awrCqbwE+r3qeyU8kGngSEue7+mGmQJRsKiqPISGtXBRz7RiuLKgg+8eg=
X-Received: by 2002:ac2:5e2f:0:b0:443:671b:cead with SMTP id
 o15-20020ac25e2f000000b00443671bceadmr2249180lfg.306.1646901190862; Thu, 10
 Mar 2022 00:33:10 -0800 (PST)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com> <7e163c463c4d420abf68ae2a2a061cc8@kioxia.com>
In-Reply-To: <7e163c463c4d420abf68ae2a2a061cc8@kioxia.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 10 Mar 2022 14:02:46 +0530
Message-ID: <CA+1E3rJPkwFjW5jidinqXmFewh64jJ2=TSgVHdyrR-nunrwLkQ@mail.gmail.com>
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on char-device.
To:     Clay Mayers <Clay.Mayers@kioxia.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "sbates@raithlin.com" <sbates@raithlin.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        "pankydev8@gmail.com" <pankydev8@gmail.com>,
        "javier@javigon.com" <javier@javigon.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "a.manzanares@samsung.com" <a.manzanares@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 10, 2022 at 5:32 AM Clay Mayers <Clay.Mayers@kioxia.com> wrote:
>
> > From: Linux-nvme <linux-nvme-bounces@lists.infradead.org> On Behalf Of
> > Kanchan Joshi
> > Sent: Tuesday, March 8, 2022 7:21 AM
> > To: axboe@kernel.dk; hch@lst.de; kbusch@kernel.org;
> > asml.silence@gmail.com
> > Cc: io-uring@vger.kernel.org; linux-nvme@lists.infradead.org; linux-
> > block@vger.kernel.org; sbates@raithlin.com; logang@deltatee.com;
> > pankydev8@gmail.com; javier@javigon.com; mcgrof@kernel.org;
> > a.manzanares@samsung.com; joshiiitr@gmail.com; anuj20.g@samsung.com
> > Subject: [PATCH 05/17] nvme: wire-up support for async-passthru on char-
> > device.
> >
> > Introduce handler for fops->async_cmd(), implementing async passthru
> > on char device (/dev/ngX). The handler supports NVME_IOCTL_IO64_CMD
> > for
> > read and write commands. Returns failure for other commands.
> > This is low overhead path for processing the inline commands housed
> > inside io_uring's sqe. Neither the commmand is fetched via
> > copy_from_user, nor the result (inside passthru command) is updated via
> > put_user.
> >
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > ---
> >  drivers/nvme/host/core.c      |   1 +
> >  drivers/nvme/host/ioctl.c     | 205 ++++++++++++++++++++++++++++------
> >  drivers/nvme/host/multipath.c |   1 +
> >  drivers/nvme/host/nvme.h      |   3 +
> >  4 files changed, 178 insertions(+), 32 deletions(-)
> >
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index 159944499c4f..3fe8f5901cd9 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -3667,6 +3667,7 @@ static const struct file_operations
> > nvme_ns_chr_fops = {
> >       .release        = nvme_ns_chr_release,
> >       .unlocked_ioctl = nvme_ns_chr_ioctl,
> >       .compat_ioctl   = compat_ptr_ioctl,
> > +     .async_cmd      = nvme_ns_chr_async_cmd,
> >  };
> >
> >  static int nvme_add_ns_cdev(struct nvme_ns *ns)
> > diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> > index 5c9cd9695519..1df270b47af5 100644
> > --- a/drivers/nvme/host/ioctl.c
> > +++ b/drivers/nvme/host/ioctl.c
> > @@ -18,6 +18,76 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
> >               ptrval = (compat_uptr_t)ptrval;
> >       return (void __user *)ptrval;
> >  }
> > +/*
> > + * This overlays struct io_uring_cmd pdu.
> > + * Expect build errors if this grows larger than that.
> > + */
> > +struct nvme_uring_cmd_pdu {
> > +     u32 meta_len;
> > +     union {
> > +             struct bio *bio;
> > +             struct request *req;
> > +     };
> > +     void *meta; /* kernel-resident buffer */
> > +     void __user *meta_buffer;
> > +} __packed;
> > +
> > +static struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(struct
> > io_uring_cmd *ioucmd)
> > +{
> > +     return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
> > +}
> > +
> > +static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
> > +{
> > +     struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> > +     struct request *req = pdu->req;
> > +     int status;
> > +     struct bio *bio = req->bio;
> > +
> > +     if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
> > +             status = -EINTR;
> > +     else
> > +             status = nvme_req(req)->status;
> > +
> > +     /* we can free request */
> > +     blk_mq_free_request(req);
> > +     blk_rq_unmap_user(bio);
> > +
> > +     if (!status && pdu->meta_buffer) {
> > +             if (copy_to_user(pdu->meta_buffer, pdu->meta, pdu-
> > >meta_len))
> > +                     status = -EFAULT;
> > +     }
> > +     kfree(pdu->meta);
> > +
> > +     io_uring_cmd_done(ioucmd, status);
> > +}
> > +
> > +static void nvme_end_async_pt(struct request *req, blk_status_t err)
> > +{
> > +     struct io_uring_cmd *ioucmd = req->end_io_data;
> > +     struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> > +     /* extract bio before reusing the same field for request */
> > +     struct bio *bio = pdu->bio;
> > +
> > +     pdu->req = req;
> > +     req->bio = bio;
> > +     /* this takes care of setting up task-work */
> > +     io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
> > +}
> > +
> > +static void nvme_setup_uring_cmd_data(struct request *rq,
> > +             struct io_uring_cmd *ioucmd, void *meta,
> > +             void __user *meta_buffer, u32 meta_len)
> > +{
> > +     struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> > +
> > +     /* to free bio on completion, as req->bio will be null at that time */
> > +     pdu->bio = rq->bio;
> > +     pdu->meta = meta;
> > +     pdu->meta_buffer = meta_buffer;
> > +     pdu->meta_len = meta_len;
> > +     rq->end_io_data = ioucmd;
> > +}
> >
> >  static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
> >               unsigned len, u32 seed, bool write)
> > @@ -56,7 +126,8 @@ static void *nvme_add_user_metadata(struct bio
> > *bio, void __user *ubuf,
> >  static int nvme_submit_user_cmd(struct request_queue *q,
> >               struct nvme_command *cmd, void __user *ubuffer,
> >               unsigned bufflen, void __user *meta_buffer, unsigned
> > meta_len,
> > -             u32 meta_seed, u64 *result, unsigned timeout)
> > +             u32 meta_seed, u64 *result, unsigned timeout,
> > +             struct io_uring_cmd *ioucmd)
> >  {
> >       bool write = nvme_is_write(cmd);
> >       struct nvme_ns *ns = q->queuedata;
> > @@ -64,9 +135,15 @@ static int nvme_submit_user_cmd(struct
> > request_queue *q,
> >       struct request *req;
> >       struct bio *bio = NULL;
> >       void *meta = NULL;
> > +     unsigned int rq_flags = 0;
> > +     blk_mq_req_flags_t blk_flags = 0;
> >       int ret;
> >
> > -     req = nvme_alloc_request(q, cmd, 0, 0);
> > +     if (ioucmd && (ioucmd->flags & IO_URING_F_NONBLOCK)) {
> > +             rq_flags |= REQ_NOWAIT;
> > +             blk_flags |= BLK_MQ_REQ_NOWAIT;
> > +     }
> > +     req = nvme_alloc_request(q, cmd, blk_flags, rq_flags);
> >       if (IS_ERR(req))
> >               return PTR_ERR(req);
> >
> > @@ -92,6 +169,19 @@ static int nvme_submit_user_cmd(struct
> > request_queue *q,
> >                       req->cmd_flags |= REQ_INTEGRITY;
> >               }
> >       }
> > +     if (ioucmd) { /* async dispatch */
> > +             if (cmd->common.opcode == nvme_cmd_write ||
> > +                             cmd->common.opcode == nvme_cmd_read) {
> > +                     nvme_setup_uring_cmd_data(req, ioucmd, meta,
> > meta_buffer,
> > +                                     meta_len);
> > +                     blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
> > +                     return 0;
> > +             } else {
> > +                     /* support only read and write for now. */
> > +                     ret = -EINVAL;
> > +                     goto out_meta;
> > +             }
> > +     }
> >
> >       ret = nvme_execute_passthru_rq(req);
> >       if (result)
> > @@ -100,6 +190,7 @@ static int nvme_submit_user_cmd(struct
> > request_queue *q,
> >               if (copy_to_user(meta_buffer, meta, meta_len))
> >                       ret = -EFAULT;
> >       }
> > + out_meta:
> >       kfree(meta);
> >   out_unmap:
> >       if (bio)
> > @@ -170,7 +261,8 @@ static int nvme_submit_io(struct nvme_ns *ns, struct
> > nvme_user_io __user *uio)
> >
> >       return nvme_submit_user_cmd(ns->queue, &c,
> >                       nvme_to_user_ptr(io.addr), length,
> > -                     metadata, meta_len, lower_32_bits(io.slba), NULL,
> > 0);
> > +                     metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
> > +                     NULL);
> >  }
> >
> >  static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
> > @@ -224,7 +316,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl,
> > struct nvme_ns *ns,
> >       status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
> >                       nvme_to_user_ptr(cmd.addr), cmd.data_len,
> >                       nvme_to_user_ptr(cmd.metadata),
> > cmd.metadata_len,
> > -                     0, &result, timeout);
> > +                     0, &result, timeout, NULL);
> >
> >       if (status >= 0) {
> >               if (put_user(result, &ucmd->result))
> > @@ -235,45 +327,53 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl,
> > struct nvme_ns *ns,
> >  }
> >
> >  static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
> > -                     struct nvme_passthru_cmd64 __user *ucmd)
> > +                     struct nvme_passthru_cmd64 __user *ucmd,
> > +                     struct io_uring_cmd *ioucmd)
> >  {
> > -     struct nvme_passthru_cmd64 cmd;
> > +     struct nvme_passthru_cmd64 cmd, *cptr;
> >       struct nvme_command c;
> >       unsigned timeout = 0;
> >       int status;
> >
> >       if (!capable(CAP_SYS_ADMIN))
> >               return -EACCES;
> > -     if (copy_from_user(&cmd, ucmd, sizeof(cmd)))
> > -             return -EFAULT;
> > -     if (cmd.flags)
> > +     if (!ioucmd) {
> > +             if (copy_from_user(&cmd, ucmd, sizeof(cmd)))
> > +                     return -EFAULT;
> > +             cptr = &cmd;
> > +     } else {
> > +             if (ioucmd->cmd_len != sizeof(struct nvme_passthru_cmd64))
> > +                     return -EINVAL;
> > +             cptr = (struct nvme_passthru_cmd64 *)ioucmd->cmd;
> > +     }
> > +     if (cptr->flags)
> >               return -EINVAL;
> > -     if (!nvme_validate_passthru_nsid(ctrl, ns, cmd.nsid))
> > +     if (!nvme_validate_passthru_nsid(ctrl, ns, cptr->nsid))
> >               return -EINVAL;
> >
> >       memset(&c, 0, sizeof(c));
> > -     c.common.opcode = cmd.opcode;
> > -     c.common.flags = cmd.flags;
> > -     c.common.nsid = cpu_to_le32(cmd.nsid);
> > -     c.common.cdw2[0] = cpu_to_le32(cmd.cdw2);
> > -     c.common.cdw2[1] = cpu_to_le32(cmd.cdw3);
> > -     c.common.cdw10 = cpu_to_le32(cmd.cdw10);
> > -     c.common.cdw11 = cpu_to_le32(cmd.cdw11);
> > -     c.common.cdw12 = cpu_to_le32(cmd.cdw12);
> > -     c.common.cdw13 = cpu_to_le32(cmd.cdw13);
> > -     c.common.cdw14 = cpu_to_le32(cmd.cdw14);
> > -     c.common.cdw15 = cpu_to_le32(cmd.cdw15);
> > -
> > -     if (cmd.timeout_ms)
> > -             timeout = msecs_to_jiffies(cmd.timeout_ms);
> > +     c.common.opcode = cptr->opcode;
> > +     c.common.flags = cptr->flags;
> > +     c.common.nsid = cpu_to_le32(cptr->nsid);
> > +     c.common.cdw2[0] = cpu_to_le32(cptr->cdw2);
> > +     c.common.cdw2[1] = cpu_to_le32(cptr->cdw3);
> > +     c.common.cdw10 = cpu_to_le32(cptr->cdw10);
> > +     c.common.cdw11 = cpu_to_le32(cptr->cdw11);
> > +     c.common.cdw12 = cpu_to_le32(cptr->cdw12);
> > +     c.common.cdw13 = cpu_to_le32(cptr->cdw13);
> > +     c.common.cdw14 = cpu_to_le32(cptr->cdw14);
> > +     c.common.cdw15 = cpu_to_le32(cptr->cdw15);
> > +
> > +     if (cptr->timeout_ms)
> > +             timeout = msecs_to_jiffies(cptr->timeout_ms);
> >
> >       status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
> > -                     nvme_to_user_ptr(cmd.addr), cmd.data_len,
> > -                     nvme_to_user_ptr(cmd.metadata),
> > cmd.metadata_len,
> > -                     0, &cmd.result, timeout);
> > +                     nvme_to_user_ptr(cptr->addr), cptr->data_len,
> > +                     nvme_to_user_ptr(cptr->metadata), cptr-
> > >metadata_len,
> > +                     0, &cptr->result, timeout, ioucmd);
> >
> > -     if (status >= 0) {
> > -             if (put_user(cmd.result, &ucmd->result))
> > +     if (!ioucmd && status >= 0) {
> > +             if (put_user(cptr->result, &ucmd->result))
> >                       return -EFAULT;
> >       }
> >
> > @@ -296,7 +396,7 @@ static int nvme_ctrl_ioctl(struct nvme_ctrl *ctrl,
> > unsigned int cmd,
> >       case NVME_IOCTL_ADMIN_CMD:
> >               return nvme_user_cmd(ctrl, NULL, argp);
> >       case NVME_IOCTL_ADMIN64_CMD:
> > -             return nvme_user_cmd64(ctrl, NULL, argp);
> > +             return nvme_user_cmd64(ctrl, NULL, argp, NULL);
> >       default:
> >               return sed_ioctl(ctrl->opal_dev, cmd, argp);
> >       }
> > @@ -340,7 +440,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns,
> > unsigned int cmd,
> >       case NVME_IOCTL_SUBMIT_IO:
> >               return nvme_submit_io(ns, argp);
> >       case NVME_IOCTL_IO64_CMD:
> > -             return nvme_user_cmd64(ns->ctrl, ns, argp);
> > +             return nvme_user_cmd64(ns->ctrl, ns, argp, NULL);
> >       default:
> >               return -ENOTTY;
> >       }
> > @@ -369,6 +469,33 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int
> > cmd, unsigned long arg)
> >       return __nvme_ioctl(ns, cmd, (void __user *)arg);
> >  }
> >
> > +static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd
> > *ioucmd)
> > +{
> > +     int ret;
> > +
> > +     BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) >
> > sizeof(ioucmd->pdu));
> > +
> > +     switch (ioucmd->cmd_op) {
> > +     case NVME_IOCTL_IO64_CMD:
> > +             ret = nvme_user_cmd64(ns->ctrl, ns, NULL, ioucmd);
> > +             break;
> > +     default:
> > +             ret = -ENOTTY;
> > +     }
> > +
> > +     if (ret >= 0)
> > +             ret = -EIOCBQUEUED;
> > +     return ret;
> > +}
>
> ret can equal -EAGAIN, which will cause io_uring to reissue the cmd
> from a worker thread.  This can happen when ioucmd->flags has
> IO_URING_F_NONBLOCK set causing nvme_alloc_request() to return
> -EAGAIN when there are no tags available.
>
> Either -EAGAIN needs to be remapped or force set REQ_F_NOWAIT in the
> io_uring cmd request in patch 3 (the 2nd option is untested).

This patch already sets REQ_F_NOWAIT for IO_URING_F_NONBLOCK flag.
Here:
+ if (ioucmd && (ioucmd->flags & IO_URING_F_NONBLOCK)) {
+ rq_flags |= REQ_NOWAIT;
+ blk_flags |= BLK_MQ_REQ_NOWAIT;
+ }
+ req = nvme_alloc_request(q, cmd, blk_flags, rq_flags);

And if -EAGAIN goes to io_uring, we don't try to setup the worker and
instead return the error to userspace for retry.
Here is the relevant fragment from Patch 3:

+ ioucmd->flags |= issue_flags;
+ ret = file->f_op->async_cmd(ioucmd);
+ /* queued async, consumer will call io_uring_cmd_done() when complete */
+ if (ret == -EIOCBQUEUED)
+ return 0;
+ io_uring_cmd_done(ioucmd, ret);

> > +
> > +int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd)
> > +{
> > +     struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
> > +                     struct nvme_ns, cdev);
> > +
> > +     return nvme_ns_async_ioctl(ns, ioucmd);
> > +}
> > +
> >  #ifdef CONFIG_NVME_MULTIPATH
> >  static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
> >               void __user *argp, struct nvme_ns_head *head, int srcu_idx)
> > @@ -412,6 +539,20 @@ int nvme_ns_head_ioctl(struct block_device *bdev,
> > fmode_t mode,
> >       return ret;
> >  }
> >
> > +int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd)
> > +{
> > +     struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
> > +     struct nvme_ns_head *head = container_of(cdev, struct
> > nvme_ns_head, cdev);
> > +     int srcu_idx = srcu_read_lock(&head->srcu);
> > +     struct nvme_ns *ns = nvme_find_path(head);
> > +     int ret = -EWOULDBLOCK;
>
> -EWOULDBLOCK has the same value as -EAGAIN so the same issue
> Is here as with nvme_ns_async_ioctl() returning it.

Same as above.

> > +
> > +     if (ns)
> > +             ret = nvme_ns_async_ioctl(ns, ioucmd);
> > +     srcu_read_unlock(&head->srcu, srcu_idx);
> > +     return ret;
> > +}
> > +
> >  long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
> >               unsigned long arg)
> >  {
> > @@ -480,7 +621,7 @@ long nvme_dev_ioctl(struct file *file, unsigned int
> > cmd,
> >       case NVME_IOCTL_ADMIN_CMD:
> >               return nvme_user_cmd(ctrl, NULL, argp);
> >       case NVME_IOCTL_ADMIN64_CMD:
> > -             return nvme_user_cmd64(ctrl, NULL, argp);
> > +             return nvme_user_cmd64(ctrl, NULL, argp, NULL);
> >       case NVME_IOCTL_IO_CMD:
> >               return nvme_dev_user_cmd(ctrl, argp);
> >       case NVME_IOCTL_RESET:
> > diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> > index f8bf6606eb2f..1d798d09456f 100644
> > --- a/drivers/nvme/host/multipath.c
> > +++ b/drivers/nvme/host/multipath.c
> > @@ -459,6 +459,7 @@ static const struct file_operations
> > nvme_ns_head_chr_fops = {
> >       .release        = nvme_ns_head_chr_release,
> >       .unlocked_ioctl = nvme_ns_head_chr_ioctl,
> >       .compat_ioctl   = compat_ptr_ioctl,
> > +     .async_cmd      = nvme_ns_head_chr_async_cmd,
> >  };
> >
> >  static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
> > diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> > index b32f4e2c68fd..e6a30543d7c8 100644
> > --- a/drivers/nvme/host/nvme.h
> > +++ b/drivers/nvme/host/nvme.h
> > @@ -16,6 +16,7 @@
> >  #include <linux/rcupdate.h>
> >  #include <linux/wait.h>
> >  #include <linux/t10-pi.h>
> > +#include <linux/io_uring.h>
> >
> >  #include <trace/events/block.h>
> >
> > @@ -752,6 +753,8 @@ long nvme_ns_head_chr_ioctl(struct file *file,
> > unsigned int cmd,
> >               unsigned long arg);
> >  long nvme_dev_ioctl(struct file *file, unsigned int cmd,
> >               unsigned long arg);
> > +int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd);
> > +int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd);
> >  int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
> >
> >  extern const struct attribute_group *nvme_ns_id_attr_groups[];
> > --
> > 2.25.1
>
> On 5.10 with our version of this patch, I've seen that returning -EAGAIN to
> io_uring results in poisoned bios and crashed kernel threads (NULL current->mm)
> while constructing the async pass through request.  I looked at
> git://git.kernel.dk/linux-block and git://git.infradead.org/nvme.git
> and as best as I can tell, the same thing will  happen.

As pointed above in the snippet, any error except -EIOCBQUEUED is just
posted in CQE during submission itself. So I do not see why -EAGAIN
should cause trouble, at least in this patchset.
FWIW- I tested by forcefully returning -EAGAIN from nvme, and also tag
saturation case (which also returns -EAGAIN) and did not see that sort
of issue.

Please take this series for a spin.
Kernel: for-next in linux-block, on top of commit 9e9d83faa
("io_uring: Remove unneeded test in io_run_task_work_sig")
