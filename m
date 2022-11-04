Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D97561933E
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 10:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiKDJPc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 05:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKDJPb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 05:15:31 -0400
Received: from out199-13.us.a.mail.aliyun.com (out199-13.us.a.mail.aliyun.com [47.90.199.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FA1308;
        Fri,  4 Nov 2022 02:15:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VTwcbeT_1667553323;
Received: from 30.97.56.135(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VTwcbeT_1667553323)
          by smtp.aliyun-inc.com;
          Fri, 04 Nov 2022 17:15:24 +0800
Message-ID: <056954c5-6442-50de-14f8-9511e3431cb6@linux.alibaba.com>
Date:   Fri, 4 Nov 2022 17:15:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC PATCH 0/4] io_uring/splice: extend splice for supporting
 ublk zero copy
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20221103085004.1029763-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/11/3 16:50, Ming Lei wrote:
> Hello Guys,
> 
> This patch extends io_uring/splice by adding two flags(SPLICE_F_DIRECT &
> SPLICE_F_READ_TO_READ) for supporting ublk zero copy, and fuse could benefit
> from the change too.
> 
> - SPLICE_F_DIRECT is for using do_splice_direct() to support zero copy
> 
> - SPLICE_F_READ_TO_READ is for supporting ublk READ zero copy, the plain
> splice can support WRITE zero copy by:
> 
> 	splice(ublkc_fd, ublkc_pos, pipe_wr_fd, NULL, len, flags)
> 	splice(pipe_rd_fd, NULL, backing_fd, backing_off, len, flags)
> 
> but can't support READ zc. Extend splice to allow to splice from the 1st
> ->splice_read()(producer) to the 2nd ->splice_read()(consumer), then READ
> request pages reference can be transferred to backing IO code path.
> 
> The initial idea is suggested by Miklos Szeredi & Stefan Hajnoczi.
> 
> The patchset has been verified basically by ublk builtin tests(loop/008,
> loop/009, generic/003), and basic mount, git clone, kernel building, umount
> tests on ublk-loop[1] which is created by 'ublk add -t loop -f $backing -z'.
> 
> The next step is to allow io_uring to run do_splice_direct*()
> in async style like normal async RW instead of offloading to
> iowq context, so that top performance can be reached, and that
> depends on current work.
> 
> Any comments are welcome.
> 
> [1] https://github.com/ming1/ubdsrv/commits/splice-zc
> 
> 
> Ming Lei (4):
>   io_uring/splice: support do_splice_direct
>   fs/splice: add helper of splice_dismiss_pipe()
>   io_uring/splice: support splice from ->splice_read to ->splice_read
>   ublk_drv: support splice based read/write zero copy
> 
>  drivers/block/ublk_drv.c      | 151 +++++++++++++++++++++++++-
>  fs/read_write.c               |   5 +-
>  fs/splice.c                   | 193 +++++++++++++++++++++++++++++-----
>  include/linux/fs.h            |   2 +
>  include/linux/pipe_fs_i.h     |   9 ++
>  include/linux/splice.h        |  14 +++
>  include/uapi/linux/ublk_cmd.h |  34 +++++-
>  io_uring/splice.c             |  16 ++-
>  8 files changed, 392 insertions(+), 32 deletions(-)
>

Hi, Ming

I have quickly scanned the code. It seems like biovec pages are successfully
passed to the backend for READ/WRITE. I will learn your code and run some
tests. I will give more feedback next week.

Regards,
Zhang
