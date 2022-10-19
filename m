Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2E4605079
	for <lists+io-uring@lfdr.de>; Wed, 19 Oct 2022 21:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiJSTdX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 15:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJSTdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 15:33:22 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F711B94F9
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 12:33:21 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r18so17157110pgr.12
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 12:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lWCtISAonKRN7ekzglAngcwTmYzkh3Bh978vu65OWDk=;
        b=icgJO6xwIb8y9mbfDnLk4y7/uabp9MMBukjR5sC+cKzHJFELgUz96wUoDUMf5HBRv5
         v1gVpSHkg41TW8zgrUZijssGKszTKUTekzS7Oe3Ow0z2b+NXCRHXhwXBkZZ1T55ohNYD
         tLnyFEacdKWwW1Umxl1T3Dn/ndGv1Z7npREgOpWLclwrWg4B5704WlUJc6Tk0Aw44PwF
         AV9jj4oIJ/AjcSs0YGw3U6Si9368E0NyTEYhexLTkxIXE0Ijr0IzmyFS+mr366cKH8+7
         nPz8JK2kca58fE4IsoBFjWx9pFsDvyVIUW3GsxSbxK0DVTzPSfa3HA3peGNLsM+zKBe7
         6vMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lWCtISAonKRN7ekzglAngcwTmYzkh3Bh978vu65OWDk=;
        b=DUorbxkn3lorxo3Me6bN68NjqZeLv/xvhsasBubS0yQfTmTDA4Iuc+SgqjglSMsMyu
         YoN8W7MR4B5wy9J+IAPrNtJzsbR8rkJZ6j7wVIjNrKHAMIyxC0oPnJ4ij9+wNm3a6Aj5
         ueXOtb1x/SNFLwd7quToIQeEiQXBCzy+p5SqM8mROjR6rytZJfXTSQvJpiKUN9gsUahT
         48k1p3nwDEBWcoWXR3pkgd7BROT/6kbE0wo7rQJUp4vwHndr+SvXib2UMEZO297eBela
         FnZbAXWr24iWyYhJPoITq1StEnGx149Vj9IEbr+y+q0LCCnUcqdYVigSXWdRKwOXz0+Q
         /sgw==
X-Gm-Message-State: ACrzQf0t+mOHlPpp8cx7Jp6uI77WSRzBEeqx2gdqkJhRwYgtJtoZDjHo
        oQ65dEVfA7hjPRJdTPhotSMRTQ==
X-Google-Smtp-Source: AMsMyM6cNofFaSh0Dq2N+cRd/e3jOLCT68K+lnDRvAYwTkCMQ2KGO1uZqyIN189m9z/N11FUHXVO4w==
X-Received: by 2002:a05:6a00:1341:b0:566:5e54:8110 with SMTP id k1-20020a056a00134100b005665e548110mr10233482pfu.6.1666208000755;
        Wed, 19 Oct 2022 12:33:20 -0700 (PDT)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id u15-20020a1709026e0f00b00176a5767fb0sm11123217plk.94.2022.10.19.12.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 12:33:20 -0700 (PDT)
Message-ID: <c464ec29-e282-f68f-cfe2-e9c7c2438464@kernel.dk>
Date:   Wed, 19 Oct 2022 12:33:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] io_uring/msg_ring: Fix NULL pointer dereference in
 io_msg_send_fd()
Content-Language: en-US
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     vegard.nossum@oracle.com, harshit.m.mogalapalli@gmail.com,
        syzkaller <syzkaller@googlegroups.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221019171218.1337614-1-harshit.m.mogalapalli@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221019171218.1337614-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/22 10:12 AM, Harshit Mogalapalli wrote:
> Syzkaller produced the below call trace:
> 
>  BUG: KASAN: null-ptr-deref in io_msg_ring+0x3cb/0x9f0
>  Write of size 8 at addr 0000000000000070 by task repro/16399
> 
>  CPU: 0 PID: 16399 Comm: repro Not tainted 6.1.0-rc1 #28
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0xcd/0x134
>   ? io_msg_ring+0x3cb/0x9f0
>   kasan_report+0xbc/0xf0
>   ? io_msg_ring+0x3cb/0x9f0
>   kasan_check_range+0x140/0x190
>   io_msg_ring+0x3cb/0x9f0
>   ? io_msg_ring_prep+0x300/0x300
>   io_issue_sqe+0x698/0xca0
>   io_submit_sqes+0x92f/0x1c30
>   __do_sys_io_uring_enter+0xae4/0x24b0
> ....
>  RIP: 0033:0x7f2eaf8f8289
>  RSP: 002b:00007fff40939718 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
>  RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2eaf8f8289
>  RDX: 0000000000000000 RSI: 0000000000006f71 RDI: 0000000000000004
>  RBP: 00007fff409397a0 R08: 0000000000000000 R09: 0000000000000039
>  R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004006d0
>  R13: 00007fff40939880 R14: 0000000000000000 R15: 0000000000000000
>   </TASK>
>  Kernel panic - not syncing: panic_on_warn set ...
> 
> We don't have a NULL check on file_ptr in io_msg_send_fd() function,
> so when file_ptr is NUL src_file is also NULL and get_file()
> dereferences a NULL pointer and leads to above crash.
> 
> Add a NULL check to fix this issue.
> 
> Fixes: e6130eba8a84 ("io_uring: add support for passing fixed file descriptors")
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> I am not completely sure whether to place the NULL check on file_ptr
> which i did in this case as file_ptr is NULL, or the masked src_file.
> 
> Similar checks are present in other files, io_uring/filetable.c has NULL
> check before masking and io_uring/cancel.c has NULL check after masking
> with FFS_MASK.

Doesn't really matter when it's done, but we should arguably have a
helper for this to avoid having differences in this pattern.

-- 
Jens Axboe
