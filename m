Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969A76AE4FF
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 16:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCGPjO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 10:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCGPjN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 10:39:13 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298426A61;
        Tue,  7 Mar 2023 07:38:28 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s11so53920143edy.8;
        Tue, 07 Mar 2023 07:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678203500;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tFbwCEdKuqYepuAAhuwT0WTQVbDTWUfJ9hO2iOl1AaE=;
        b=gW/ebMhW6w70Qahj+bae0bYJ+mKqZR/6SWy1gHZ0St3OCNhgo8KGeazlDfBbcMCqy8
         b7AyZXOkN93ILjw1ryZsgqAPu5hM82woEn7rOENcNrnzdPv1nYgn0WuJKrIhCaYP5UTg
         T6HUt4Dg6ZApIfYSWa8ibjPCvAeAsVjZnVpxZGnT4n0xlzaUe4batZoVHqwf5XdBo/6u
         OuGf83MP6khCq/lN3mAAo47WvwBz+1uebWN2zAFcumcONesN7YzcWMmxks4i1uMZcMJL
         C+6GENUxpzB7pE4Ah2FnAhPzBMwBivYg10fOq9n+Y/dcIaiwtEEi/fomlVfleqe5iiyk
         A/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678203500;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tFbwCEdKuqYepuAAhuwT0WTQVbDTWUfJ9hO2iOl1AaE=;
        b=4jmyIBq6FUIWpNy6VGhW8uxOFSlL87XdlJFGPCPgv7HCgxqYapNOcv6YraXcQVFN3u
         NtgRS1qUzY/1N+aIfdG3PiYLanRg3dyXlmPUpY2Zz+nL43PBF9cPJCiYlDWnbjoMYIux
         qmXN+n2y0xzv1lKqsjuGs0hi7h8Q7mbWqrHar70kWcZHDUKdzt8pAGAY2czul1afsd9i
         5LCBbG9DKVmDyrVmxWbycwwrom7AyUEC1ua/nOMbOF7qlq9J+LL7fO2mo7pYzCuJgpTt
         qeN2HYDVPMkRAD8CXhC0j33fnNHlGgYnR13BDsqlqYxu7f3lO56v2e79oCiivjnz2TMb
         a7Bg==
X-Gm-Message-State: AO0yUKUHP4e4k/71xAbe27F4Nb7KsWcxISUCTU7zVknhwauSrTGnN9ai
        v+Sm13dS4Kg7cDsL1Qg1qVw=
X-Google-Smtp-Source: AK7set/VRlSHux3kb6r3+JPz9w6c9sVGRUF9mgQpBH+4GPUys8nT30YO+O5v5VG+oSsot3VFGYjWyw==
X-Received: by 2002:a17:906:aadb:b0:905:a46b:a725 with SMTP id kt27-20020a170906aadb00b00905a46ba725mr17227816ejb.16.1678203500192;
        Tue, 07 Mar 2023 07:38:20 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:d2b4])
        by smtp.gmail.com with ESMTPSA id hy26-20020a1709068a7a00b008d92897cc29sm6245615ejc.37.2023.03.07.07.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 07:38:20 -0800 (PST)
Message-ID: <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
Date:   Tue, 7 Mar 2023 15:37:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230307141520.793891-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/7/23 14:15, Ming Lei wrote:
> Hello,
> 
> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> and its ->issue() can retrieve/import buffer from master request's
> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> submits slave OP just like normal OP issued from userspace, that said,
> SQE order is kept, and batching handling is done too.

 From a quick look through patches it all looks a bit complicated
and intrusive, all over generic hot paths. I think instead we
should be able to use registered buffer table as intermediary and
reuse splicing. Let me try it out


> Please see detailed design in commit log of the 3th patch, and one big
> point is how to handle buffer ownership.
> 
> With this way, it is easy to support zero copy for ublk/fuse device.
> 
> Basically userspace can specify any sub-buffer of the ublk block request
> buffer from the fused command just by setting 'offset/len'
> in the slave SQE for running slave OP. This way is flexible to implement
> io mapping: mirror, stripped, ...
> 
> The 4th & 5th patches enable fused slave support for the following OPs:
> 
> 	OP_READ/OP_WRITE
> 	OP_SEND/OP_RECV/OP_SEND_ZC
> 
> The other ublk patches cleans ublk driver and implement fused command
> for supporting zero copy.
> 
> Follows userspace code:
> 
> https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-v2
> 
> All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:
> 
> 	ublk add -t [loop|nbd|qcow2] -z ....
> 
> Basic fs mount/kernel building and builtin test are done.
> 
> Also add liburing test case for covering fused command based on miniublk
> of blktest:
> 
> https://github.com/ming1/liburing/commits/fused_cmd_miniublk
> 
> Performance improvement is obvious on memory bandwidth
> related workloads, such as, 1~2X improvement on 64K/512K BS
> IO test on loop with ramfs backing file.
> 
> Any comments are welcome!
> 
> V2:
> 	- don't resue io_mapped_ubuf (io_uring)
> 	- remove REQ_F_FUSED_MASTER_BIT (io_uring)
> 	- fix compile warning (io_uring)
> 	- rebase on v6.3-rc1 (io_uring)
> 	- grabbing io request reference when handling fused command
> 	- simplify ublk_copy_user_pages() by iov iterator
> 	- add read()/write() for userspace to read/write ublk io buffer, so
> 	that some corner cases(read zero, passthrough request(report zones)) can
> 	be handled easily in case of zero copy; this way also helps to switch to
> 	zero copy completely
> 	- misc cleanup
> 
> Ming Lei (17):
>    io_uring: add IO_URING_F_FUSED and prepare for supporting OP_FUSED_CMD
>    io_uring: increase io_kiocb->flags into 64bit
>    io_uring: add IORING_OP_FUSED_CMD
>    io_uring: support OP_READ/OP_WRITE for fused slave request
>    io_uring: support OP_SEND_ZC/OP_RECV for fused slave request
>    block: ublk_drv: mark device as LIVE before adding disk
>    block: ublk_drv: add common exit handling
>    block: ublk_drv: don't consider flush request in map/unmap io
>    block: ublk_drv: add two helpers to clean up map/unmap request
>    block: ublk_drv: clean up several helpers
>    block: ublk_drv: cleanup 'struct ublk_map_data'
>    block: ublk_drv: cleanup ublk_copy_user_pages
>    block: ublk_drv: grab request reference when the request is handled by
>      userspace
>    block: ublk_drv: support to copy any part of request pages
>    block: ublk_drv: add read()/write() support for ublk char device
>    block: ublk_drv: don't check buffer in case of zero copy
>    block: ublk_drv: apply io_uring FUSED_CMD for supporting zero copy
> 
>   drivers/block/ublk_drv.c       | 605 ++++++++++++++++++++++++++-------
>   drivers/char/mem.c             |   4 +
>   drivers/nvme/host/ioctl.c      |   9 +
>   include/linux/io_uring.h       |  49 ++-
>   include/linux/io_uring_types.h |  18 +-
>   include/uapi/linux/io_uring.h  |   1 +
>   include/uapi/linux/ublk_cmd.h  |  37 +-
>   io_uring/Makefile              |   2 +-
>   io_uring/fused_cmd.c           | 232 +++++++++++++
>   io_uring/fused_cmd.h           |  11 +
>   io_uring/io_uring.c            |  22 +-
>   io_uring/io_uring.h            |   3 +
>   io_uring/net.c                 |  23 +-
>   io_uring/opdef.c               |  17 +
>   io_uring/opdef.h               |   2 +
>   io_uring/rw.c                  |  20 ++
>   16 files changed, 926 insertions(+), 129 deletions(-)
>   create mode 100644 io_uring/fused_cmd.c
>   create mode 100644 io_uring/fused_cmd.h
> 

-- 
Pavel Begunkov
