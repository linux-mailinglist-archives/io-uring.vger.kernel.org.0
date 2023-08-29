Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109BC78C6CC
	for <lists+io-uring@lfdr.de>; Tue, 29 Aug 2023 16:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjH2OEj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Aug 2023 10:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbjH2OEb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Aug 2023 10:04:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D293FCD8
        for <io-uring@vger.kernel.org>; Tue, 29 Aug 2023 07:04:22 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1befe39630bso6950615ad.0
        for <io-uring@vger.kernel.org>; Tue, 29 Aug 2023 07:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1693317862; x=1693922662;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jaZqe+CNDkocdPgUpmu0V3P4V84hYUqk/fkvgnUAY8k=;
        b=H7VS95BIXtxUih5MXEY7VhT8xHIBK1IYJzzPgiPAbLv35EhA9zaUqVuRk2EUJGpY83
         3seOb64BRdA8eCaE7kga8hiboG6PnojYqxVuRhqhYKEYOzHVeruFsUq0InnHwgm8RIYJ
         NcR0M2fgO2i+gxmCFDUtjEjy2GiSFwi62Hl2rY/AqPQMlN1nUzLTg5RQXryJjaqNmluP
         HIcEEi1bk5LMAlooCcw0TZJ8ucYbQCWoqNk9zhKNoxQGAZ3+QfdHxO/7kTggIYXlkUqJ
         AHpWzgqopO1fykSIAj+SN00eITLR7SCmX2CwDlALN/NqTvUInKsCFt6xQNKqK0QIrNDv
         jonw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693317862; x=1693922662;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jaZqe+CNDkocdPgUpmu0V3P4V84hYUqk/fkvgnUAY8k=;
        b=fcFcFRTnPg1kXCE31oqQek2B2u4J2IhulogqxX+u8llYAdWy7h/rODqLozbFHlg2n0
         deMO6gTZszJJYL0diRp66hDYrCuWZ1Vm2pdMHV3mZiiYS7rR9YIcTykBl3fBv3kTLdUQ
         yxpXFNWcikpDuN/jqSdcTXIvbTyqWT1ZuHdf85E+e/dIq8xHzODKedPeA4tjyPwylJQG
         qfhVWzpPbMcV4N6vCDZQ1iTLUDRLslbd7PyEBNUN1aW0FDrLMFCQWBtWqbQ2VJ2wVeiW
         NM/AIdqgJMCGUmu36/wPxld8lHvL5UmipaemOhMer+BdjJ00I8Nk1exTOZj+4eliHJ8g
         cS2A==
X-Gm-Message-State: AOJu0YwDxPIP77PtchKolt3bprYlqGlWJvU2OGsNITNHieFVhGeEWTyE
        NraIGw0UdIGLW3FeSaTfdjPI/A==
X-Google-Smtp-Source: AGHT+IEqVPxhWf9+Qbj52o42d0RX8KvJN+idDJ+2awlN/P1fnaxYlS0amaOBT3XDjRDgrh4B45lMiA==
X-Received: by 2002:a17:902:f68f:b0:1b8:aded:524c with SMTP id l15-20020a170902f68f00b001b8aded524cmr32026496plg.1.1693317862003;
        Tue, 29 Aug 2023 07:04:22 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z1-20020a170903018100b001bdb167f6ebsm9422989plg.94.2023.08.29.07.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 07:04:21 -0700 (PDT)
Message-ID: <870ea887-ecb0-4058-855b-6c82ab01c7fc@kernel.dk>
Date:   Tue, 29 Aug 2023 08:04:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Don't set affinity on a dying sqpoll thread
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>,
        syzbot <syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000753fbd0603f8c10b@google.com> <87v8cybuo6.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87v8cybuo6.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/28/23 5:42 PM, Gabriel Krisman Bertazi wrote:
> syzbot <syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com> writes:
> 
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    626932085009 Add linux-next specific files for 20230825
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12a97797a80000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8c992a790e5073
>> dashboard link: https://syzkaller.appspot.com/bug?extid=c74fea926a78b8a91042
>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/46ec18b3c2fb/disk-62693208.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/b4ea0cb78498/vmlinux-62693208.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/5fb3938c7272/bzImage-62693208.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com
>>
>> general protection fault, probably for non-canonical address 0xdffffc000000011d: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x00000000000008e8-0x00000000000008ef]
>> CPU: 1 PID: 27342 Comm: syz-executor.5 Not tainted 6.5.0-rc7-next-20230825-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/26/2023
>> RIP: 0010:io_sqpoll_wq_cpu_affinity+0x8c/0xe0 io_uring/sqpoll.c:433
> 
> Jens,
> 
> I'm not sure I got the whole story on this one, but it seems fairly
> trivial to reproduce and I can't see another way it could be
> triggered. What do you think?

Yep looks like the right fix, we should check the thread after parking.
I'll get this added to the queue, thanks.

-- 
Jens Axboe

