Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE0B4DAF2A
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 12:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355492AbiCPLx0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 07:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355481AbiCPLxZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 07:53:25 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866A465813;
        Wed, 16 Mar 2022 04:52:06 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h11so2793792ljb.2;
        Wed, 16 Mar 2022 04:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2+MlSG+PCN1QrvqAqdI+V/FmSzwhtZltZpgLHvQd0pA=;
        b=OAKcW8NA6yRBHIf3QblNXdLGjPWH635S3vjzYztlr0pdZxW0c/ANy635P52q0g0MNY
         Uf7MNzsx3YZ67ts6KGQlLvzN8H5iy4ltqcZfz+Lp3e/jRvLhj5+tx6x0hk1Bd7sq7POb
         Usx+nn3CkzPV01hfqNByV+Yi34xdJrI0CBLd3Nxyj5L+PWaE4RCbdGZV+ETES6yDLBt+
         GhEPaqExsi7y5fHHoVKDWpoy45AxXdJwKa/mf0a0DrjcyUseilG/Q+qDgmqEvxMCrwW4
         sIy706xfYgPvqY1nv+70xypy2zpNjsxMbTQkd3+EQuSRGRdd3ZRUjU6YO0ngy0ZJLJeB
         lBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2+MlSG+PCN1QrvqAqdI+V/FmSzwhtZltZpgLHvQd0pA=;
        b=FW6n95tI7hiRq2rZtqI8idNBoHzK8P5krV+FXNN0uFOicXO1UNdv+bU6XSchvYX7NK
         75pLHWTxoK3p+mPFePIjxmcIAIuabqxXDYBzNnNytpbiupG7Qwn0W4F6FtP69FVGub1v
         x0aCYbfwrjc7pn2wpKPRryHqRFmEZS57XKk4Wz0MB+re3r4LIz3x/g1kBMVn8Lrsw7xx
         VgfHBhLldFeXcs8PgjDJoHY3FgxrPLNfCKqIn3rxkG6EK7K8A+uLxJiyjOtY0ka/U2Qs
         1aXoL0oBcv0MK85V/OnVNfcrDGhetgi3yJ0HIrEyam7DjPyVltQOMazA1pbrpjhdCf37
         aOhQ==
X-Gm-Message-State: AOAM530X9A5oTq0EUOYOmhCiTvbrHfdZ1ADm6AzxmwCJZK0ZVUK4JvQu
        5slYZ2INmsj/mqKsRWcOI0Dzkx9GHYY2OTGhjFw=
X-Google-Smtp-Source: ABdhPJxEP49r9yY0bwlO5aom4dubx0+xTR6k3FdpcyqkLKXjOmBJFreWsAbE30sIpImaY6vozz8Ganl72KbN7xCW06U=
X-Received: by 2002:a2e:3004:0:b0:223:c126:5d1a with SMTP id
 w4-20020a2e3004000000b00223c1265d1amr20117180ljw.408.1647431524627; Wed, 16
 Mar 2022 04:52:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com> <7a123895-1102-4b36-2d6e-1e00e978d03d@grimberg.me>
 <CA+1E3rK8wnABptQLQrEo8XRdsbua9t_88e3ZP-Ass3CnxHv+oA@mail.gmail.com>
 <8f45a761-5ecb-5911-1064-9625a285c93d@grimberg.me> <20220316092153.GA4885@test-zns>
 <11f9e933-cfc8-2e3b-c815-c49a4b7db4ec@grimberg.me>
In-Reply-To: <11f9e933-cfc8-2e3b-c815-c49a4b7db4ec@grimberg.me>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 16 Mar 2022 17:21:39 +0530
Message-ID: <CA+1E3r+_DEw5ABPbLzSp9Gvg6L8XU-2HBoLK7kuXucLjr=+Ezw@mail.gmail.com>
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on char-device.
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
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

> On 3/16/22 11:21, Kanchan Joshi wrote:
> > On Tue, Mar 15, 2022 at 11:02:30AM +0200, Sagi Grimberg wrote:
> >>
> >>>>> +int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd)
> >>>>> +{
> >>>>> +     struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
> >>>>> +     struct nvme_ns_head *head = container_of(cdev, struct
> >>>>> nvme_ns_head, cdev);
> >>>>> +     int srcu_idx = srcu_read_lock(&head->srcu);
> >>>>> +     struct nvme_ns *ns = nvme_find_path(head);
> >>>>> +     int ret = -EWOULDBLOCK;
> >>>>> +
> >>>>> +     if (ns)
> >>>>> +             ret = nvme_ns_async_ioctl(ns, ioucmd);
> >>>>> +     srcu_read_unlock(&head->srcu, srcu_idx);
> >>>>> +     return ret;
> >>>>> +}
> >>>>
> >>>> No one cares that this has no multipathing capabilities what-so-ever?
> >>>> despite being issued on the mpath device node?
> >>>>
> >>>> I know we are not doing multipathing for userspace today, but this
> >>>> feels like an alternative I/O interface for nvme, seems a bit cripled
> >>>> with zero multipathing capabilities...
> >>>
> >>> Multipathing is on the radar. Either in the first cut or in
> >>> subsequent. Thanks for bringing this up.
> >>
> >> Good to know...
> >>
> >>> So the char-node (/dev/ngX) will be exposed to the host if we enable
> >>> controller passthru on the target side. And then the host can send
> >>> commands using uring-passthru in the same way.
> >>
> >> Not sure I follow...
> >
> > Doing this on target side:
> > echo -n /dev/nvme0 >
> > /sys/kernel/config/nvmet/subsystems/testnqn/passthru/device_path
> > echo 1 > /sys/kernel/config/nvmet/subsystems/testnqn/passthru/enable
>
> Cool, what does that have to do with what I asked?
Maybe nothing.
This was rather about how to set up nvmeof if block-interface does not
exist for the underlying nvme device.

> >>> May I know what are the other requirements here.
> >>
> >> Again, not sure I follow... The fundamental capability is to
> >> requeue/failover I/O if there is no I/O capable path available...
> >
> > That is covered I think, with nvme_find_path() at places including the
> > one you highlighted above.
>
> No it isn't. nvme_find_path is a simple function that retrieves an I/O
> capable path which is not guaranteed to exist, it has nothing to do with
> I/O requeue/failover.

Got it, thanks. Passthrough (sync or async) just returns the failure
to user-space if that fails.
No attempt to retry/requeue as the block path does.

-- 
Kanchan
