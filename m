Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002484D5193
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 20:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbiCJSox (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 13:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiCJSow (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 13:44:52 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900C9102408;
        Thu, 10 Mar 2022 10:43:50 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id o6so9038022ljp.3;
        Thu, 10 Mar 2022 10:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f2tYdizKTIshWFThjBTeAJGUpF74jo5FnvbdsKAlPgg=;
        b=L+NAx3DQW/kLZvssrOMcN20V+NDmLBkLyZ7yh4g09+9QiiNtUZZrTYVFbgyuJwgRa0
         npVQz+VlciSI4GFCb5GeQs1B67E4W4gQWwcHLKvG/i0BH3YJ+E1kTSKHlU0Rh2G8ve8O
         bwwzm0UVfMCfPzvN22b9mEBjHMCE3t6IgTCCu1XzJszdmF0YJsK4INNTpjOx5G5eHOEE
         Lpi1zSGNmgPo3EyAqProc37ugId5l3l+RcRz8AgVLPdfMJ0iyy72qqUPhp5ARp9q+X5A
         W1RZMimkPG7xwcQpRyzGjMrlPJoOP573x1t+jxsFAl80LDq7uV+YhJjLY0STZFoO90MH
         qzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f2tYdizKTIshWFThjBTeAJGUpF74jo5FnvbdsKAlPgg=;
        b=waWrz5VKhfrQwUPp8rSvaR+ootT3gNGCG/hyh/TcuwefWSSOsYCh6m7TbUP3yolPWp
         Z5O7T8bhEEyutBNWJWio6rsjQwx4i2oY9ATtJGAkE+uCvAL/jGz5kQTlpOFiS07aVYHm
         K+xR9GSobUJB6ltO5M9zzizKhNUbgqjP1pU6V1ijkHA/A8ePKnnURkbuXGennIGpBpcb
         Tce5yHQT3hgvyJnTfWy3HnCkfAwSxrPZYs21YIwvzB4gVQ82C4lTqKUweG/0mo3v4mPn
         3NGHBN/BEpvC5HeNlFrGr2Fz1NQQKPBADSKIfAI+SKLLS55zCLdP+BVoTxtGfsciw+a7
         yq1Q==
X-Gm-Message-State: AOAM530jlZtWupTF8hbqMZXYZ0L2YFMZ0X7viEQmaYWKHI3NKprPt/6x
        2mDf2klLuAb6oxiaXVd+l87oaXsaPlj4I3uc4W0=
X-Google-Smtp-Source: ABdhPJzQL58I6OV6Ntzjf1Sx72ym4uZ1I9t+0tr8hmh2IxxfBECQKSnK2+rNZtDoJC83aKh8L8hI7BYJ/Rb/x0njv+8=
X-Received: by 2002:a2e:8403:0:b0:248:31d:3e35 with SMTP id
 z3-20020a2e8403000000b00248031d3e35mr3682631ljg.445.1646937828736; Thu, 10
 Mar 2022 10:43:48 -0800 (PST)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com> <20220310141945.GA890@lst.de>
In-Reply-To: <20220310141945.GA890@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 11 Mar 2022 00:13:24 +0530
Message-ID: <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
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

On Thu, Mar 10, 2022 at 7:49 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Mar 10, 2022 at 05:20:13PM +0530, Kanchan Joshi wrote:
> > In sync ioctl, we always update this result field by doing put_user on
> > completion.
> > For async ioctl, since command is inside the the sqe, its lifetime is
> > only upto submission. SQE may get reused post submission, leaving no
> > way to update the "result" field on completion. Had this field been a
> > pointer, we could have saved this on submission and updated on
> > completion. But that would require redesigning this structure and
> > adding newer ioctl in nvme.
>
> Why would it required adding an ioctl to nvme?  The whole io_uring
> async_cmd infrastructure is completely independent from ioctls.

io_uring is sure not peeking into ioctl and its command-structure but
offering the facility to use its sqe to store that ioctl-command
inline.
Problem is, the inline facility does not go very well with this
particular nvme-passthru ioctl (NVME_IOCTL_IO64_CMD).
And that's because this ioctl requires additional "__u64 result;" to
be updated within "struct nvme_passthru_cmd64".
To update that during completion, we need, at the least, the result
field to be a pointer "__u64 result_ptr" inside the struct
nvme_passthru_cmd64.
Do you see that is possible without adding a new passthru ioctl in nvme?

> > Coming back, even though sync-ioctl alway updates this result to
> > user-space, only a few nvme io commands (e.g. zone-append, copy,
> > zone-mgmt-send) can return this additional result (spec-wise).
> > Therefore in nvme, when we are dealing with inline-sqe commands from
> > io_uring, we never attempt to update the result. And since we don't
> > update the result, we limit support to only read/write passthru
> > commands. And fail any other command during submission itself (Patch
> > 2).
>
> Yikes.  That is outright horrible.  passthrough needs to be command
> agnostic and future proof to any newly added nvme command.

This patch (along with patch 16) does exactly that. Makes it
command-agnostic and future-proof. All nvme-commands will work with
it.
Just that application needs to pass the pointer of ioctl-command and
not place it inline inside the sqe.

Overall, I think at io_uring infra level both submission makes sense:
big-sqe based inline submission (more efficient for <= 80 bytes) and
normal-sqe based non-inline/indirect submissions.
At nvme-level, we have to pick (depending on ioctl in hand). Currently
we are playing with both and constructing a sort of fast-path (for all
commands) and another faster-path (only for read/write commands).
Should we (at nvme-level) rather opt out and use only indirect
(because it works for all commands) or must we build a way to enable
inline-one for all commands?

> > > Overly long line.
> >
> > Under 100, but sure, can fold it under 80.
>
> You can only use 100 sparingly if it makes the code more readable.  Which
> I know is fuzzy, and in practice never does.  Certainly not in nvme and
> block code.

Clears up, thanks.

-- 
Kanchan
