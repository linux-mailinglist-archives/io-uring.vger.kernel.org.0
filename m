Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6DE4D464A
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 12:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbiCJLvl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 06:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiCJLvl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 06:51:41 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ED6145AD8;
        Thu, 10 Mar 2022 03:50:40 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id r7so8963370lfc.4;
        Thu, 10 Mar 2022 03:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2HCgTW6tUM7DEFamof1h4tm/dHfLYbO8BtWVBOKqMwU=;
        b=qjSfnZolpLXexD4ysKMJx7z2iy7RSLmEydG1gUF0kZ6pnev5NF4zCn/mc2ym6OXH1h
         zrDf2WEDTBODUV9dGZHLbkh0nxcrk6skioLy2gvwGhzkOSdfJGfUYaYgl5q+tZfQSezQ
         nNktgy9uE0lrm09glMwhuHw4gb+bLrj3va6vCteSorTizOgxZ0rmHJ3HWAvpE5nIAu0C
         8M2Md7Bx3eDT8XXKDZE3zoSpTgsmKEu7HqFAMLWc3YXI48Gu1qtXKAXCJDnuPALg1Itz
         lygCOlnVNb5jSPmbgPIOAkIGVnIx6ZhAeClUQP99iLzaEAbeeJYGd+fpQg63IPK7JasX
         jdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2HCgTW6tUM7DEFamof1h4tm/dHfLYbO8BtWVBOKqMwU=;
        b=h8GrF4Zo9VBwCt3TtXOwmOehgT9ZFv9yh/+I3defa/KNIswbmBLkXaCww91Y+dtstN
         s0teBdqtmEfb8t62Jg9YHOvq6A87wn6vX10ny806/3l+sCY55QE0XUCr1Mi/NwHd8PFS
         m+iJ7fkhuNqfonm8xux2V3f9Ml6lPe6xVn+CJcPdOLMtndsqQZu4IvWT9hTBd5kEa4FC
         nx+DK7zWl5POqGRxwvhe+BvUvjmNbFjNCGfV1M30QZXKpQ3htNp9fsBRunDP1ksOOsz5
         HxZ6bmZzc93ej/Gw1Hj/uGFMkLsd2tZXmNUZ/SIozVBgDaAWwph33uq54wu9d/C3dwhz
         fbzw==
X-Gm-Message-State: AOAM5324IGjPE9oSJ73xJXQP9UyC8fGopOTylx2iEjN0lHSvRkH8EM+z
        cXAr0C4Ntw4YPGNLcgu8WSXV3bgF2Ur7UJcy/vE=
X-Google-Smtp-Source: ABdhPJyjVMSSENplit9xn7OPOjyV+zTxySFK+J9bgJ4QXkoieP+kCGLzFuJAzf/aP0M1vQ3ynfDAfGm0lc6zuCTIu+Y=
X-Received: by 2002:a05:6512:16a8:b0:448:6188:f8a8 with SMTP id
 bu40-20020a05651216a800b004486188f8a8mr1835823lfb.650.1646913038539; Thu, 10
 Mar 2022 03:50:38 -0800 (PST)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de>
In-Reply-To: <20220310083652.GF26614@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 10 Mar 2022 17:20:13 +0530
Message-ID: <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
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

On Thu, Mar 10, 2022 at 2:06 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Mar 08, 2022 at 08:51:05PM +0530, Kanchan Joshi wrote:
> > From: Anuj Gupta <anuj20.g@samsung.com>
> >
> > On submission,just fetch the commmand from userspace pointer and reuse
> > everything else. On completion, update the result field inside the
> > passthru command.
>
> What is that supposed to mean?  What is the reason to do it.  Remember
> to always document the why in commit logs.

I covered some of it in patch 6, but yes I need to expand the
reasoning here. Felt that retrospectively too.
So there are two ways/modes of submitting commands:

Mode 1: inline into sqe. This is the default way when passthru command
is placed inside a big sqe which has 80 bytes of space.
The only problem is - passthru command has this 'result' field
(structure below for quick reference) which is statically embedded and
not a pointer (like addr and metadata field).

struct nvme_passthru_cmd64 {
__u8 opcode;
__u8 flags;
__u16 rsvd1;
__u32 nsid;
__u32 cdw2;
__u32 cdw3;
__u64 metadata;
__u64 addr;
__u32 metadata_len;
__u32 data_len;
__u32 cdw10;
__u32 cdw11;
__u32 cdw12;
__u32 cdw13;
__u32 cdw14;
__u32 cdw15;
__u32 timeout_ms;
__u32   rsvd2;
__u64 result;
};
In sync ioctl, we always update this result field by doing put_user on
completion.
For async ioctl, since command is inside the the sqe, its lifetime is
only upto submission. SQE may get reused post submission, leaving no
way to update the "result" field on completion. Had this field been a
pointer, we could have saved this on submission and updated on
completion. But that would require redesigning this structure and
adding newer ioctl in nvme.

Coming back, even though sync-ioctl alway updates this result to
user-space, only a few nvme io commands (e.g. zone-append, copy,
zone-mgmt-send) can return this additional result (spec-wise).
Therefore in nvme, when we are dealing with inline-sqe commands from
io_uring, we never attempt to update the result. And since we don't
update the result, we limit support to only read/write passthru
commands. And fail any other command during submission itself (Patch
2).

Mode 2: Non-inline/indirect (pointer of command into sqe) submission.
User-space places a pointer of passthru command, and a flag in
io_uring saying that this is not inline.
For this, in nvme (this patch) we always update the 'result' on
completion and therefore can support all passthru commands.

Hope this makes the reasoning clear?
Plumbing wise, non-inline support does not create churn (almost all
the infra of inline-command handling is reused). Extra is
copy_from_user , and put_user.

> > +static inline bool is_inline_rw(struct io_uring_cmd *ioucmd, struct nvme_command *cmd)
>
> Overly long line.

Under 100, but sure, can fold it under 80.


-- 
Kanchan
