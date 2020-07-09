Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BD9219618
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 04:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGICRA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 22:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgGICQ5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 22:16:57 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C53C061A0B
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 19:16:57 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x9so193330plr.2
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 19:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SxqPykwmYEK8nqRhoD2yBLZ1OvCMARCQYQP5asMBGn8=;
        b=i+7f/fiZB02fify5t9QGJvmzVdZCbyMofKL1/+wx/JsSJtAsAnEPDIaKhXgDaWETlG
         DqUl8rG/zwFOk0E8jKEU483/uCcibTOpwuTKG+lwI2FWpudJiyXAbsoQ3EbdTRCnFSig
         sgM3EhLUqnMiD0KSyM+RBzrKZoYYkyAgEhROc7LzxPgfOMm97TRYSSjhHduReuLArGI3
         /58+pwB0fautDEuzTQBtM2wgfCVa0uAEe3ZfmvOquIznavg+7b+HlJeRswK59bSSEwy1
         E7F5jodrQVcMtCiCIJ8BlSc8znvpCqHOaKmHjN99mzoxU8af5FS/0mGBufdMFz6VlmIH
         Rk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SxqPykwmYEK8nqRhoD2yBLZ1OvCMARCQYQP5asMBGn8=;
        b=LiyKPRLX0WoMHdCx1Bq84oHn2GoCqcgiC3gdhFVorfyBRW3Dke6236wzvP5NpgVnSq
         laCszkGo4Hh1xGKhFeRh0P4U+f4l+lOGbsA/0qHnZ6G5iwoCGw/fcIUAlNRpWvUdrBqe
         h0g1Q3XP3CIGgopzE75ZG0n58R/HZX00PGkmo9f78JdmHGkoGZHyPCKSVcZ7uoVbrcdA
         ZL/uU/DlWX0UdTGAdnIvDrqZBmGfCvppBZed9oy76fJfb5ldUu1ypLCCCX9in7v3OiiS
         fZaGhF/wLETvX45QtAVsYMJN8gO4RJy+x4kTlyrHAfiTOU0PqFbIv/f2LaGwvEHHB4gE
         S/ow==
X-Gm-Message-State: AOAM530CiwiHcm7xQ/Kf/vA+T8SyJJHkpaSddxCGcH0hiwa5icbaNrDn
        k7bORRwGmyDDjd3/chSh4Rctug==
X-Google-Smtp-Source: ABdhPJzX3t+J5MrJq2jlm5O0gbfQJ4msTEe2yyUFoDiDDqt7oDQ1PzXWWe5XZqwVejMvXMCcosj0SQ==
X-Received: by 2002:a17:90a:318c:: with SMTP id j12mr12083565pjb.25.1594261016432;
        Wed, 08 Jul 2020 19:16:56 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m68sm675776pje.24.2020.07.08.19.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 19:16:55 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix memleak in __io_sqe_files_update()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200709101141.3261977-1-yangyingliang@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1edf6ed7-690e-ef7d-df35-b5d7f5bc6cb4@kernel.dk>
Date:   Wed, 8 Jul 2020 20:16:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709101141.3261977-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/9/20 4:11 AM, Yang Yingliang wrote:
> I got a memleak report when doing some fuzz test:
> 
> BUG: memory leak
> unreferenced object 0xffff888113e02300 (size 488):
> comm "syz-executor401", pid 356, jiffies 4294809529 (age 11.954s)
> hex dump (first 32 bytes):
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> a0 a4 ce 19 81 88 ff ff 60 ce 09 0d 81 88 ff ff ........`.......
> backtrace:
> [<00000000129a84ec>] kmem_cache_zalloc include/linux/slab.h:659 [inline]
> [<00000000129a84ec>] __alloc_file+0x25/0x310 fs/file_table.c:101
> [<000000003050ad84>] alloc_empty_file+0x4f/0x120 fs/file_table.c:151
> [<000000004d0a41a3>] alloc_file+0x5e/0x550 fs/file_table.c:193
> [<000000002cb242f0>] alloc_file_pseudo+0x16a/0x240 fs/file_table.c:233
> [<00000000046a4baa>] anon_inode_getfile fs/anon_inodes.c:91 [inline]
> [<00000000046a4baa>] anon_inode_getfile+0xac/0x1c0 fs/anon_inodes.c:74
> [<0000000035beb745>] __do_sys_perf_event_open+0xd4a/0x2680 kernel/events/core.c:11720
> [<0000000049009dc7>] do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
> [<00000000353731ca>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> BUG: memory leak
> unreferenced object 0xffff8881152dd5e0 (size 16):
> comm "syz-executor401", pid 356, jiffies 4294809529 (age 11.954s)
> hex dump (first 16 bytes):
> 01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 ................
> backtrace:
> [<0000000074caa794>] kmem_cache_zalloc include/linux/slab.h:659 [inline]
> [<0000000074caa794>] lsm_file_alloc security/security.c:567 [inline]
> [<0000000074caa794>] security_file_alloc+0x32/0x160 security/security.c:1440
> [<00000000c6745ea3>] __alloc_file+0xba/0x310 fs/file_table.c:106
> [<000000003050ad84>] alloc_empty_file+0x4f/0x120 fs/file_table.c:151
> [<000000004d0a41a3>] alloc_file+0x5e/0x550 fs/file_table.c:193
> [<000000002cb242f0>] alloc_file_pseudo+0x16a/0x240 fs/file_table.c:233
> [<00000000046a4baa>] anon_inode_getfile fs/anon_inodes.c:91 [inline]
> [<00000000046a4baa>] anon_inode_getfile+0xac/0x1c0 fs/anon_inodes.c:74
> [<0000000035beb745>] __do_sys_perf_event_open+0xd4a/0x2680 kernel/events/core.c:11720
> [<0000000049009dc7>] do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
> [<00000000353731ca>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> If io_sqe_file_register() failed, we need put the file that get by fget()
> to avoid the memleak.
> 
> Fixes: c3a31e605620 ("io_uring: add support for IORING_REGISTER_FILES_UPDATE")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  fs/io_uring.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e507737f044e..5c2487d954b2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6814,8 +6814,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  			}
>  			table->files[index] = file;
>  			err = io_sqe_file_register(ctx, file, i);
> -			if (err)
> +			if (err) {
> +				fput(file);
>  				break;
> +			}
>  		}
>  		nr_args--;
>  		done++;

Thanks, this looks good. I've committed it and marked it for stable
as well.

-- 
Jens Axboe

