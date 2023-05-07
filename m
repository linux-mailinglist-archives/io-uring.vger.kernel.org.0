Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214EE6F9872
	for <lists+io-uring@lfdr.de>; Sun,  7 May 2023 14:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjEGMAx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 May 2023 08:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjEGMAw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 May 2023 08:00:52 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED284EF8
        for <io-uring@vger.kernel.org>; Sun,  7 May 2023 05:00:50 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 3f1490d57ef6-ba1ddf79e4eso451473276.1
        for <io-uring@vger.kernel.org>; Sun, 07 May 2023 05:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683460850; x=1686052850;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ck8OvdvABzy3rAvrB8FaqcqJLoP1q/kg29mG++8MriM=;
        b=SGowI/nNzeH4azufn0/FRgkWQDsXIpqfKkZL2TcIIKcbaeA8u84kde0J2qPWbXwyAz
         ENbfBizOj8+RMouYhh3w4auVCeCj/Q5MM3RZeOIcf4IniHxKjkfTKl6dtj9mt0nECgZk
         /Fp7eybMyuHf4BfV71UPU8WaUhgBQHItkcb5UozdCkt6J6SiGeOTiThAiOW0Ti2jCXBI
         NAH2vhMX7rGkM54ndCSAGz/x5MuSmroJbqbpql3f2xRaa1nTzP8LdnB6rKtGx+dfFZPr
         bWwfxKnEnCyFHUR95Tm4c1v/f2iQdO8y4pg36GqFh8kT9tk7tFAADH8MG+uoBvARrMhM
         1grQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683460850; x=1686052850;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ck8OvdvABzy3rAvrB8FaqcqJLoP1q/kg29mG++8MriM=;
        b=GMMvRNJmbe/MwC8F+8xW6G1Yd3JbtdANe2JyO6LXTKZTvjTAVvJ5zI+8rOJ7uAxQqS
         fvMVv0mkhLEoaNhpEYyZ6mTX4BK7q7mPxZ9JtCoP9pdM1dAoLLcOr6TLSFBVAw+PUN2g
         4ndUVMvsr0kO65i1hLxhYkUctD4LpcsdENcHOJ6gJIr7vcrdgK5SR6HpQcnaPqpu7odi
         MCosvmTAsKI21WqeisMVPEAGHXBYRKB+KchqHpw1WTZK29RGWwYptIsyM+m+6S25ARPU
         dq89sVIbTI1YIzsJYDKL+1eo4dppVS9Ii3Q8M9pn1NruHAYFpM7j0LO/YkH+TTiT9eWG
         fQWg==
X-Gm-Message-State: AC+VfDyKyrpCar5IxEo0PmbaKIfiVN//f/tMj7xr1um3u/S0Y9Ann6Zj
        qjiS6seDTc4yRsn3a+XiYahmQfaSjd1Yid9MyC8=
X-Google-Smtp-Source: ACHHUZ7zJCmJu3Ovwmnq3dAvuQ41t3PKJk9uUEhdxeuvGFkBigfXc7iVODzj2V1qlqvU9DkaSf8VnA==
X-Received: by 2002:a81:1b94:0:b0:55d:a393:a2bc with SMTP id b142-20020a811b94000000b0055da393a2bcmr7389564ywb.4.1683460850086;
        Sun, 07 May 2023 05:00:50 -0700 (PDT)
Received: from [172.20.2.186] ([12.153.103.3])
        by smtp.gmail.com with ESMTPSA id l64-20020a0dc943000000b0055aad7d3f34sm1734166ywd.142.2023.05.07.05.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 May 2023 05:00:49 -0700 (PDT)
Message-ID: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
Date:   Sun, 7 May 2023 06:00:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Final io_uring updates for 6.4-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Nothing major in here, just two different parts:

- Small series from Breno that enables passing the full SQE down
  for ->uring_cmd(). This is a prerequisite for enabling full network
  socket operations. Queued up a bit late because of some stylistic
  concerns that got resolved, would be nice to have this in 6.4-rc1
  so the dependent work will be easier to handle for 6.5.

- Fix for the huge page coalescing, which was a regression introduced
  in the 6.3 kernel release (Tobias).

Note that this will throw a merge conflict in the ublk_drv code, due
to this branch still being based off the original for-6.4/io_uring
branch. Resolution is pretty straight forward, I'm including it below
for reference.

Please pull!


The following changes since commit 3c85cc43c8e7855d202da184baf00c7b8eeacf71:

  Revert "io_uring/rsrc: disallow multi-source reg buffers" (2023-04-20 06:51:48 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.4/io_uring-2023-05-07

for you to fetch changes up to d2b7fa6174bc4260e496cbf84375c73636914641:

  io_uring: Remove unnecessary BUILD_BUG_ON (2023-05-04 08:19:05 -0600)

----------------------------------------------------------------
for-6.4/io_uring-2023-05-07

----------------------------------------------------------------
Breno Leitao (3):
      io_uring: Create a helper to return the SQE size
      io_uring: Pass whole sqe to commands
      io_uring: Remove unnecessary BUILD_BUG_ON

Tobias Holl (1):
      io_uring/rsrc: check for nonconsecutive pages

 drivers/block/ublk_drv.c  | 26 +++++++++++++-------------
 drivers/nvme/host/ioctl.c |  2 +-
 include/linux/io_uring.h  |  7 ++++++-
 io_uring/io_uring.h       | 10 ++++++++++
 io_uring/opdef.c          |  2 +-
 io_uring/rsrc.c           |  7 ++++++-
 io_uring/uring_cmd.c      | 12 +++---------
 io_uring/uring_cmd.h      |  8 --------
 8 files changed, 40 insertions(+), 34 deletions(-)

Merge resolution:

commit 775e045e380626ce769d95badc79ea08edc1b15d
Merge: efd141da30bb d2b7fa6174bc
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu May 4 08:22:24 2023 -0600

    Merge branch 'for-6.4/io_uring' into test
    
    * for-6.4/io_uring:
      io_uring: Remove unnecessary BUILD_BUG_ON
      io_uring: Pass whole sqe to commands
      io_uring: Create a helper to return the SQE size
      io_uring/rsrc: check for nonconsecutive pages
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --cc drivers/block/ublk_drv.c
index 72a5cde9a5af,42f4d7ca962e..0af6a41f92b2
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@@ -1397,23 -1362,6 +1397,23 @@@ static int __ublk_ch_uring_cmd(struct i
  	return -EIOCBQUEUED;
  }
  
 +static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 +{
- 	struct ublksrv_io_cmd *ub_src = (struct ublksrv_io_cmd *) cmd->cmd;
++	const struct ublksrv_io_cmd *ub_src = io_uring_sqe_cmd(cmd->sqe);
 +	struct ublksrv_io_cmd ub_cmd;
 +
 +	/*
 +	 * Not necessary for async retry, but let's keep it simple and always
 +	 * copy the values to avoid any potential reuse.
 +	 */
 +	ub_cmd.q_id = READ_ONCE(ub_src->q_id);
 +	ub_cmd.tag = READ_ONCE(ub_src->tag);
 +	ub_cmd.result = READ_ONCE(ub_src->result);
 +	ub_cmd.addr = READ_ONCE(ub_src->addr);
 +
 +	return __ublk_ch_uring_cmd(cmd, issue_flags, &ub_cmd);
 +}
 +
  static const struct file_operations ublk_ch_fops = {
  	.owner = THIS_MODULE,
  	.open = ublk_ch_open,
@@@ -2240,9 -2171,8 +2240,9 @@@ exit
  static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
  		unsigned int issue_flags)
  {
- 	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+ 	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
  	struct ublk_device *ub = NULL;
 +	u32 cmd_op = cmd->cmd_op;
  	int ret = -EINVAL;
  
  	if (issue_flags & IO_URING_F_NONBLOCK)

-- 
Jens Axboe

