Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1402243CFA
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 18:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHMQHm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 12:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMQHm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 12:07:42 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BF8C061757
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 09:07:41 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id r19so2851908qvw.11
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 09:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bX97ss88UuBsRhIlc2+E5NQVMRFpQjp3KqzkhDmleXQ=;
        b=veHAFfPmksrkhJK+WuP6VSMD0ygjF+Dk8eBj+KH5Pkcf0qycqMHX/gnIy7uj0rkKDy
         BC2U+fAfhSBn7GBFH9OtW4ayHtZqZ8CXlihqtOpMnwA+7Lk/IczenLstQ4GX5bA29Zlt
         bag6C/XRX2y+xNvgD5gVV/7EWbM1r8oSMLzMEcosGLNPiFY06tU9E3yO92EYBrn8XO02
         hrumPPDjNIrOMaA/+cBcwUrRTRBLOVGlekqLho195W84ZD72gc0HiOkZLQJL7o2NYoGi
         S3StREXnKDqb4fMPPRNlkFveAT3fsKGJBx65FZgPmxvwfMWSZm1xmnARtRqkr8lsURQE
         rTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bX97ss88UuBsRhIlc2+E5NQVMRFpQjp3KqzkhDmleXQ=;
        b=RsrP85RDNWh9lsiYwhap1EM1ZLh4/kWsAsd/wVQVmmwo7GtnyEvIxjPfKMEGFYmsyQ
         H2YMjSvbTRspxnjjJpd1R2icd/eFYRMQjA4rY859jAuvBZOE3DBlGCfUXej3f+YT19sH
         t5dBVEd7Xg11tv0/xgs1ZkGrNMsuefR5hsV58riu7MofbGbW5Dm3e+ulMBcykqwzHvlp
         MmDZ6wpB1z1qZe1iFTivlwYJJvEmNLW8+n6u1QUN2KswU8zxDRpWLOLO0MWQ8w9C64oZ
         F0MCWHjJeSHv/3jfRu3jpsTydFNofPj3pQafswKH1v2KaelTLyefDO5g8uzBBmn12WGL
         dkZQ==
X-Gm-Message-State: AOAM532jghZ4ufe71mLsCUeojLpQhTZ2gz3OL2CZtc+hkTS66dZLRT4V
        CiHxH8CfSFcgj3aLvoXy82+e4tJEZG4o/Jn5pKJKzxfVqWQ=
X-Google-Smtp-Source: ABdhPJzf9ldYgU+Enl6GsRon5UQX2SH/LFGnkOt0FXtvJGp6faK33NI9qE3WBpI+WwNzMzd7cycpdT4oDTvl74AlmNI=
X-Received: by 2002:a0c:fa0a:: with SMTP id q10mr5389799qvn.33.1597334860404;
 Thu, 13 Aug 2020 09:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk> <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com> <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
In-Reply-To: <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Thu, 13 Aug 2020 18:07:29 +0200
Message-ID: <CAAss7+rk5jH5Peov-Scffp3cmRpk3=0suBZvw1RFTEc7a6Rstw@mail.gmail.com>
Subject: Re: io_uring process termination/killing is not working
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 13 Aug 2020 at 01:32, Jens Axboe <axboe@kernel.dk> wrote:
> Yeah I think you're right. How about something like the below? That'll
> potentially cancel more than just the one we're looking for, but seems
> kind of silly to only cancel from the file table holding request and to
> the end.
>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8a2afd8c33c9..0630a9622baa 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4937,6 +5003,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
>                 io_cqring_fill_event(req, -ECANCELED);
>                 io_commit_cqring(req->ctx);
>                 req->flags |= REQ_F_COMP_LOCKED;
> +               req_set_fail_links(req);
>                 io_put_req(req);
>         }
>
> @@ -7935,6 +8002,47 @@ static bool io_wq_files_match(struct io_wq_work *work, void *data)
>         return work->files == files;
>  }
>
> +static bool __io_poll_remove_link(struct io_kiocb *preq, struct io_kiocb *req)
> +{
> +       struct io_kiocb *link;
> +
> +       if (!(preq->flags & REQ_F_LINK_HEAD))
> +               return false;
> +
> +       list_for_each_entry(link, &preq->link_list, link_list) {
> +               if (link != req)
> +                       break;
> +               io_poll_remove_one(preq);
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +/*
> + * We're looking to cancel 'req' because it's holding on to our files, but
> + * 'req' could be a link to another request. See if it is, and cancel that
> + * parent request if so.
> + */
> +static void io_poll_remove_link(struct io_ring_ctx *ctx, struct io_kiocb *req)
> +{
> +       struct hlist_node *tmp;
> +       struct io_kiocb *preq;
> +       int i;
> +
> +       spin_lock_irq(&ctx->completion_lock);
> +       for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
> +               struct hlist_head *list;
> +
> +               list = &ctx->cancel_hash[i];
> +               hlist_for_each_entry_safe(preq, tmp, list, hash_node) {
> +                       if (__io_poll_remove_link(preq, req))
> +                               break;
> +               }
> +       }
> +       spin_unlock_irq(&ctx->completion_lock);
> +}
> +
>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>                                   struct files_struct *files)
>  {
> @@ -7989,6 +8097,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>                         }
>                 } else {
>                         io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
> +                       /* could be a link, check and remove if it is */
> +                       io_poll_remove_link(ctx, cancel_req);
>                         io_put_req(cancel_req);
>                 }
>
>

btw it works for me thanks

--
Josef


On Thu, 13 Aug 2020 at 01:32, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/12/20 12:28 PM, Pavel Begunkov wrote:
> > On 12/08/2020 21:22, Pavel Begunkov wrote:
> >> On 12/08/2020 21:20, Pavel Begunkov wrote:
> >>> On 12/08/2020 21:05, Jens Axboe wrote:
> >>>> On 8/12/20 11:58 AM, Josef wrote:
> >>>>> Hi,
> >>>>>
> >>>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
> >>>>> doesn't work to kill this process(always state D or D+), literally I
> >>>>> have to terminate my VM because even the kernel can't kill the process
> >>>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
> >>>>> works
> >>>>>
> >>>>> I've attached a file to reproduce it
> >>>>> or here
> >>>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
> >>>>
> >>>> Thanks, I'll take a look at this. It's stuck in uninterruptible
> >>>> state, which is why you can't kill it.
> >>>
> >>> It looks like one of the hangs I've been talking about a few days ago,
> >>> an accept is inflight but can't be found by cancel_files() because it's
> >>> in a link.
> >>
> >> BTW, I described it a month ago, there were more details.
> >
> > https://lore.kernel.org/io-uring/34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com
>
> Yeah I think you're right. How about something like the below? That'll
> potentially cancel more than just the one we're looking for, but seems
> kind of silly to only cancel from the file table holding request and to
> the end.
>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8a2afd8c33c9..0630a9622baa 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4937,6 +5003,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
>                 io_cqring_fill_event(req, -ECANCELED);
>                 io_commit_cqring(req->ctx);
>                 req->flags |= REQ_F_COMP_LOCKED;
> +               req_set_fail_links(req);
>                 io_put_req(req);
>         }
>
> @@ -7935,6 +8002,47 @@ static bool io_wq_files_match(struct io_wq_work *work, void *data)
>         return work->files == files;
>  }
>
> +static bool __io_poll_remove_link(struct io_kiocb *preq, struct io_kiocb *req)
> +{
> +       struct io_kiocb *link;
> +
> +       if (!(preq->flags & REQ_F_LINK_HEAD))
> +               return false;
> +
> +       list_for_each_entry(link, &preq->link_list, link_list) {
> +               if (link != req)
> +                       break;
> +               io_poll_remove_one(preq);
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +/*
> + * We're looking to cancel 'req' because it's holding on to our files, but
> + * 'req' could be a link to another request. See if it is, and cancel that
> + * parent request if so.
> + */
> +static void io_poll_remove_link(struct io_ring_ctx *ctx, struct io_kiocb *req)
> +{
> +       struct hlist_node *tmp;
> +       struct io_kiocb *preq;
> +       int i;
> +
> +       spin_lock_irq(&ctx->completion_lock);
> +       for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
> +               struct hlist_head *list;
> +
> +               list = &ctx->cancel_hash[i];
> +               hlist_for_each_entry_safe(preq, tmp, list, hash_node) {
> +                       if (__io_poll_remove_link(preq, req))
> +                               break;
> +               }
> +       }
> +       spin_unlock_irq(&ctx->completion_lock);
> +}
> +
>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>                                   struct files_struct *files)
>  {
> @@ -7989,6 +8097,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>                         }
>                 } else {
>                         io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
> +                       /* could be a link, check and remove if it is */
> +                       io_poll_remove_link(ctx, cancel_req);
>                         io_put_req(cancel_req);
>                 }
>
>
> --
> Jens Axboe
>
