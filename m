Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1836F9E23
	for <lists+io-uring@lfdr.de>; Mon,  8 May 2023 05:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjEHDS6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 May 2023 23:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjEHDS5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 May 2023 23:18:57 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EE79ECD
        for <io-uring@vger.kernel.org>; Sun,  7 May 2023 20:18:55 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1aaf70676b6so27551395ad.3
        for <io-uring@vger.kernel.org>; Sun, 07 May 2023 20:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1683515935; x=1686107935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z6TSnkERdwXl1bzYWkrNGEY8R3ItHdA5poRBtKCKBUQ=;
        b=HGtUFwdH62bhvHTDQJDJvcj/pZK5lOOSKNQGuqL3ImStRkfh8067wgSEp3VXxrLGad
         eQS51NsapjzZ3e2XRksshuMsy1US9lKmpZ3Qq2LcytuidewDXgjMdyBFodZ3y6y4dqcR
         IBGgV1dpw/XR0LDs2UOzCxktcAX/F12Iy9oV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683515935; x=1686107935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6TSnkERdwXl1bzYWkrNGEY8R3ItHdA5poRBtKCKBUQ=;
        b=Qbwa6ZT0+NNiiEtfrWv77lUthltJj7oTLyYAe0JvKD3HsJ/NkRxQYdMxFH2x5yZHiO
         eDFLtHp8Q3CUdug2Gw6r3Db0wdjY0gwKS3N8Ni9NrP1UOl6hoyUvOyXppWcQ/DfPhYA8
         //CBe9NlHvaSGFcKJlUp04JU4bx8qdVF7cJYbsdYvxCL7XMLNXq3Pd4yt6K+Z3Dlb1cc
         I2DwfspJgGYvU3taVlNXENxNQfLH1xVMjFQM4J0OHVsTWpjmtCuqXymQkXvOazHIEVLD
         CJgMwrEPRvvWSqinLaSznhVgoiXqgKA/I3zevQmMhdv0eiK4tfAwdMp5v/GkPXW9OrL4
         UogA==
X-Gm-Message-State: AC+VfDzB/aqI2zzoszZuvGNS3Q//5dXMkQ8J1tdBPUJEkWwuh/8VkVmk
        fgF+PrT0gmjLtNdkBrhmvxnrlA==
X-Google-Smtp-Source: ACHHUZ5AA29U1SAmSn2ASfZU4azicHg1Nihp+g2ahPTNjg0J9v5F2/bjkmhVK3kN8jPE5teFQgtSGA==
X-Received: by 2002:a17:902:7e84:b0:1a6:f755:a4a0 with SMTP id z4-20020a1709027e8400b001a6f755a4a0mr8198049pla.58.1683515935349;
        Sun, 07 May 2023 20:18:55 -0700 (PDT)
Received: from google.com ([2401:fa00:1:10:526f:c8c9:de13:77a])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902ab8c00b001a060007fcbsm5877550plr.213.2023.05.07.20.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 20:18:55 -0700 (PDT)
Date:   Mon, 8 May 2023 11:18:52 +0800
From:   Chen-Yu Tsai <wenst@chromium.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Final io_uring updates for 6.4-rc1
Message-ID: <20230508031852.GA4029098@google.com>
References: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On Sun, May 07, 2023 at 06:00:48AM -0600, Jens Axboe wrote:
> Hi Linus,
> 
> Nothing major in here, just two different parts:
> 
> - Small series from Breno that enables passing the full SQE down
>   for ->uring_cmd(). This is a prerequisite for enabling full network
>   socket operations. Queued up a bit late because of some stylistic
>   concerns that got resolved, would be nice to have this in 6.4-rc1
>   so the dependent work will be easier to handle for 6.5.
> 
> - Fix for the huge page coalescing, which was a regression introduced
>   in the 6.3 kernel release (Tobias).
> 
> Note that this will throw a merge conflict in the ublk_drv code, due
> to this branch still being based off the original for-6.4/io_uring
> branch. Resolution is pretty straight forward, I'm including it below
> for reference.
> 
> Please pull!
> 
> 
> The following changes since commit 3c85cc43c8e7855d202da184baf00c7b8eeacf71:
> 
>   Revert "io_uring/rsrc: disallow multi-source reg buffers" (2023-04-20 06:51:48 -0600)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.dk/linux.git tags/for-6.4/io_uring-2023-05-07
> 
> for you to fetch changes up to d2b7fa6174bc4260e496cbf84375c73636914641:
> 
>   io_uring: Remove unnecessary BUILD_BUG_ON (2023-05-04 08:19:05 -0600)
> 
> ----------------------------------------------------------------
> for-6.4/io_uring-2023-05-07
> 
> ----------------------------------------------------------------
> Breno Leitao (3):
>       io_uring: Create a helper to return the SQE size
>       io_uring: Pass whole sqe to commands

This commit causes broken builds when IO_URING=n and NVME_CORE=y, as
io_uring_sqe_cmd(), called in drivers/nvme/host/ioctl.c, ends up being
undefined. This was also reported [1] by 0-day bot on your branch
yesterday, but it's worse now that Linus merged the pull request.

Not sure what the better fix would be. Move io_uring_sqe_cmd() outside
of the "#if defined(CONFIG_IO_URING)" block?


ChenYu

[1] https://lore.kernel.org/all/202305080039.r7cguaXB-lkp@intel.com/

>       io_uring: Remove unnecessary BUILD_BUG_ON
> 
> Tobias Holl (1):
>       io_uring/rsrc: check for nonconsecutive pages
> 
>  drivers/block/ublk_drv.c  | 26 +++++++++++++-------------
>  drivers/nvme/host/ioctl.c |  2 +-
>  include/linux/io_uring.h  |  7 ++++++-
>  io_uring/io_uring.h       | 10 ++++++++++
>  io_uring/opdef.c          |  2 +-
>  io_uring/rsrc.c           |  7 ++++++-
>  io_uring/uring_cmd.c      | 12 +++---------
>  io_uring/uring_cmd.h      |  8 --------
>  8 files changed, 40 insertions(+), 34 deletions(-)
> 
> Merge resolution:
> 
> commit 775e045e380626ce769d95badc79ea08edc1b15d
> Merge: efd141da30bb d2b7fa6174bc
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu May 4 08:22:24 2023 -0600
> 
>     Merge branch 'for-6.4/io_uring' into test
>     
>     * for-6.4/io_uring:
>       io_uring: Remove unnecessary BUILD_BUG_ON
>       io_uring: Pass whole sqe to commands
>       io_uring: Create a helper to return the SQE size
>       io_uring/rsrc: check for nonconsecutive pages
>     
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --cc drivers/block/ublk_drv.c
> index 72a5cde9a5af,42f4d7ca962e..0af6a41f92b2
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@@ -1397,23 -1362,6 +1397,23 @@@ static int __ublk_ch_uring_cmd(struct i
>   	return -EIOCBQUEUED;
>   }
>   
>  +static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  +{
> - 	struct ublksrv_io_cmd *ub_src = (struct ublksrv_io_cmd *) cmd->cmd;
> ++	const struct ublksrv_io_cmd *ub_src = io_uring_sqe_cmd(cmd->sqe);
>  +	struct ublksrv_io_cmd ub_cmd;
>  +
>  +	/*
>  +	 * Not necessary for async retry, but let's keep it simple and always
>  +	 * copy the values to avoid any potential reuse.
>  +	 */
>  +	ub_cmd.q_id = READ_ONCE(ub_src->q_id);
>  +	ub_cmd.tag = READ_ONCE(ub_src->tag);
>  +	ub_cmd.result = READ_ONCE(ub_src->result);
>  +	ub_cmd.addr = READ_ONCE(ub_src->addr);
>  +
>  +	return __ublk_ch_uring_cmd(cmd, issue_flags, &ub_cmd);
>  +}
>  +
>   static const struct file_operations ublk_ch_fops = {
>   	.owner = THIS_MODULE,
>   	.open = ublk_ch_open,
> @@@ -2240,9 -2171,8 +2240,9 @@@ exit
>   static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
>   		unsigned int issue_flags)
>   {
> - 	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
> + 	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
>   	struct ublk_device *ub = NULL;
>  +	u32 cmd_op = cmd->cmd_op;
>   	int ret = -EINVAL;
>   
>   	if (issue_flags & IO_URING_F_NONBLOCK)
> 
> -- 
> Jens Axboe
> 
> 
