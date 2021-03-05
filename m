Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E1A32E692
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 11:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhCEKkx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 05:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhCEKkw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 05:40:52 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799B3C061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 02:40:49 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id e10so1503644wro.12
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 02:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H95xvo9vQWpBEjEoM4WW8sLMHdulWjpm44uHAKvsKSE=;
        b=QtBqNgGK1tiNxAChBsd1aMaBD1tQwbJY/Y01r4QpFdNzSwhEdTAFrNcdOSfnN+mpSd
         HACc/kmLxu3a/1obQ4GecNWSU1EhumLdaj2ZboTieVoSzTIhP0ect1Zgm92jxdKEfgFR
         EYqqy6mjj8fFr7XeaPzjBRZZ8ezGvaNEj3G9Jpzt/drD0zztzsjoHuUYsbGMGpeLMtH8
         nWstmcT4DgvF7tTutcvIS6P5fZfuft3R1W4fhXXWkasnuSCMUMs1ewiR824mFUYwANyL
         7a9YrGCzFSmOiRqG2ceI2MDSKRi5PcUYAFgfHJH9mYtkptflumP1DXFaiKMvDWX3Pxsy
         XkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H95xvo9vQWpBEjEoM4WW8sLMHdulWjpm44uHAKvsKSE=;
        b=buBYKGExNfQ0VCExve6++GrKfDDiz+DuGjmwtwpGPZG0YNHBW3iSkbwnQreLbij985
         nMyyh586rBC/TsjsS/AOOvIs6B+w9uUVWB/kUPxnkfiVALW52oegI4Cd/FUhVWZwWwXK
         wKBd3tuyhvdyoyvF+zUatUiwZAWCU0hAJgZYjXCy9+aiIRdeoBF25FO75loSAPEnkSNw
         UTyXlpjDKFKaO8q55IOVG0C3dh0QEbRzNK73CGC4V1QCHe43fI+f/GkNhP4LGZ9QU7Hk
         lJ6VKRe+nuihSPPxW7CSpEX/7cwf0h1oCjCADw3+uerQxUUBZBnutsa1sfT6x/yXBIev
         2bYA==
X-Gm-Message-State: AOAM531rUkyMpWwlz3HCQvu9IZ5BryQGMYqGLGZ7gxFtS+jt7A+jvLCI
        PK/hVv63ypmLAk5XR1owvGQzaYB2YVzHBCye2iA=
X-Google-Smtp-Source: ABdhPJzPG/VE3eG4qnhLsT5LJ0GWlh20Mud+oLZU78uOjs5eDa1trxFOV58DpuC8BivumJPHjM2SwFudyifiDA5Db4E=
X-Received: by 2002:a5d:56d0:: with SMTP id m16mr8473834wrw.355.1614940848299;
 Fri, 05 Mar 2021 02:40:48 -0800 (PST)
MIME-Version: 1.0
References: <20210302160734.99610-1-joshi.k@samsung.com> <CGME20210302161005epcas5p23f28fe21bab5a3e07b9b382dd2406fdc@epcas5p2.samsung.com>
 <20210302160734.99610-3-joshi.k@samsung.com> <BYAPR04MB496566944851825B251CA93686989@BYAPR04MB4965.namprd04.prod.outlook.com>
 <CA+1E3rLCSWDmLa1rrZ986xnbx6fcsGgBE6NPP59eJj4swY+gQg@mail.gmail.com> <BYAPR04MB49658E6ACD06FAC7F6F26A6886969@BYAPR04MB4965.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB49658E6ACD06FAC7F6F26A6886969@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 5 Mar 2021 16:10:22 +0530
Message-ID: <CA+1E3rJ62DNN=9-w1g0E7=0y4CZYjjckQ-K4Efk+3HjigbdSQA@mail.gmail.com>
Subject: Re: [RFC 2/3] nvme: passthrough helper with callback
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 5, 2021 at 9:44 AM Chaitanya Kulkarni
<Chaitanya.Kulkarni@wdc.com> wrote:
>
> On 3/4/21 03:14, Kanchan Joshi wrote:
> > On Wed, Mar 3, 2021 at 8:52 PM Chaitanya Kulkarni
> > <Chaitanya.Kulkarni@wdc.com> wrote:
> >> On 3/2/21 23:22, Kanchan Joshi wrote:
> >>> -void nvme_execute_passthru_rq(struct request *rq)
> >>> +void nvme_execute_passthru_rq_common(struct request *rq,
> >>> +                     rq_end_io_fn *done)
> >>>  {
> >>>       struct nvme_command *cmd = nvme_req(rq)->cmd;
> >>>       struct nvme_ctrl *ctrl = nvme_req(rq)->ctrl;
> >>> @@ -1135,9 +1136,17 @@ void nvme_execute_passthru_rq(struct request *rq)
> >>>       u32 effects;
> >>>
> >>>       effects = nvme_passthru_start(ctrl, ns, cmd->common.opcode);
> >>> -     blk_execute_rq(disk, rq, 0);
> >>> +     if (!done)
> >>> +             blk_execute_rq(disk, rq, 0);
> >>> +     else
> >>> +             blk_execute_rq_nowait(disk, rq, 0, done);
> >>>       nvme_passthru_end(ctrl, effects);
> >> This needs a detailed explanation in order to prove the correctness.
> > Do you see something wrong here?
> > blk_execute_rq() employs the same helper (i.e. nowait one) and uses
> > additional completion-variable to make it sync.
> >
>
> There is no gurantee that command will finish between call to
> blk_execute_rq_nowait()
> and nvme_passthru_end() is there ?

Got your concern now, thanks for elaborating.
I will move the passthru_end to when completion actually occurs, and
get it processed via workqueue.

And perhaps I should send a micro-optimization patch which will call
passthru_end only for non-zero command-effects.
Currently we do three checks.
