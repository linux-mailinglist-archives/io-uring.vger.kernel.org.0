Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDE35F9ECF
	for <lists+io-uring@lfdr.de>; Mon, 10 Oct 2022 14:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiJJMmi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 08:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJJMmh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 08:42:37 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A0550F97;
        Mon, 10 Oct 2022 05:42:36 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id q9so20087132ejd.0;
        Mon, 10 Oct 2022 05:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F1ZctX6XDmO3TswyeHBG/Q26Ppmm5MVYMtNhscdLU40=;
        b=m0RAaSsgDpVjL7zYC56uy68TGt3WWpOTzFm4ianTg8+q2uOqWyubb99P6NLVDkCmNZ
         X/kZIpjYlGR2Tv76D3wokM+t7MwXZ3EsRuQrpqwwaiSdvIxOLdXu5UtS8w32jM2uutxE
         enTTbflfoRRf53M4cUb4hWvnPKfpI3pPjabO11wnnGO+1ouiT1EVd5EiszK5Tbu+jgi2
         /L9v2p+w3Hca9Mcp4abS0XdNEj4y/QDVYfVsqHisAxMqMCqp24iijF4aU2VftaEohNsa
         A1cLas6Q5akos8p7ouiDgijJBDnrbKr42xIPCyhPTe6fafjLg2Gm4cHZPJQUPdQb7RfP
         Q7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F1ZctX6XDmO3TswyeHBG/Q26Ppmm5MVYMtNhscdLU40=;
        b=YbzkNzDfrJUyOs/X8mi3mHKuEStkwJ9VJ/dp2YgdXBD8dxsNOZlSigwRgwdKHpH/sF
         iBsNon+8X6fuYm/V+Emv9a5klkzb9o6MH96fnXX2aHyzvwXSDYuRaTPQ/hlpEcBlt8nx
         LFbGXwJJ2kloIWS7e+P6Awy7ByGpr/RkMdExqjJ0Pye4xcHnzJbCeXPbFxIYOs/FbuGp
         xWbTEosvbNVfm44OjjcKjN/5bj82fXZEFJvgfoqveZLoS+/pjy4Yv0aNvlBAVBYWWSbk
         f+/rWiASUb1HosBVj0ab/+J1LlsmN4m12OmJ75DJxMwhxIFNSivatOMHrxgam6f8urIc
         Apjg==
X-Gm-Message-State: ACrzQf0pT7vlM4/pOSK69RYLLt57nX3qYhdZaytxbu1bidEYkgyX9pzo
        hTOlOE8YdNKQ5BshBRCq+LTN8MugPpfaRet728NtfS+BMfI=
X-Google-Smtp-Source: AMsMyM6cY4SdiWzUd0GXPZdkdPGrNlDG+7POU4e9pOzYLbUWMlneaXmL+VS6qzBgXtEpqJfTlvZfq6bYjxjqc6k0/+E=
X-Received: by 2002:a17:907:948f:b0:78b:5a89:a23e with SMTP id
 dm15-20020a170907948f00b0078b5a89a23emr14716796ejc.421.1665405754508; Mon, 10
 Oct 2022 05:42:34 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Mon, 10 Oct 2022 20:41:59 +0800
Message-ID: <CAO4mrffiwEOr2tC+LXnjzP7QZ56M+V3o87K43Y7m6-rvHfwjwA@mail.gmail.com>
Subject: BUG: corrupted list in io_poll_task_func
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered:

HEAD commit: c5eb0a61238d Linux 5.18-rc6
git tree: upstream
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1Obzlp9wrLFx9BogwmOHhmnQqyMYa2z_k/view?usp=sharing
kernel config: https://drive.google.com/file/d/12fNP5UArsFqTi2jjGomWuCk5evtgU0Gu/view?usp=sharing

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

list_del corruption. prev->next should be ffff88810ec0ae30, but was
ffff888114119218. (prev=ffff888114119218)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:53!
invalid opcode: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 20805 Comm: iou-sqp-20802 Not tainted 5.18.0-rc6 #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:__list_del_entry_valid+0xa7/0xc0
Code: 48 c7 c7 54 12 3f 83 4c 89 fe 48 89 da 31 c0 e8 89 e0 21 01 0f
0b 48 c7 c7 6f d7 48 83 4c 89 fe 4c 89 e1 31 c0 e8 73 e0 21 01 <0f> 0b
48 c7 c7 17 b4 42 83 4c 89 fe 4c 89 f1 31 c0 e8 5d e0 21 01
RSP: 0018:ffffc900026dbb58 EFLAGS: 00010046
RAX: 000000000000006d RBX: dead000000000122 RCX: 6101d1e720e71900
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88810ec0ae08 R08: ffffffff8115f303 R09: 0000000000000000
R10: 0001ffffffffffff R11: 000188813bc1b460 R12: ffff888114119218
R13: ffff88810ec0ae00 R14: ffff888114119218 R15: ffff88810ec0ae30
FS:  00007f1e57534700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1e574afdb8 CR3: 00000001394b3000 CR4: 0000000000750ef0
DR0: 0000000020000140 DR1: 0000000020000440 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
PKRU: 55555554
Call Trace:
 <TASK>
 io_poll_task_func+0x1ca/0x4f0
 tctx_task_work+0x808/0xae0
 task_work_run+0x8e/0x110
 get_signal+0x13c6/0x1520
 io_sq_thread+0x382/0xbd0
 ret_from_fork+0x1f/0x30
 </TASK>
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid+0xa7/0xc0
Code: 48 c7 c7 54 12 3f 83 4c 89 fe 48 89 da 31 c0 e8 89 e0 21 01 0f
0b 48 c7 c7 6f d7 48 83 4c 89 fe 4c 89 e1 31 c0 e8 73 e0 21 01 <0f> 0b
48 c7 c7 17 b4 42 83 4c 89 fe 4c 89 f1 31 c0 e8 5d e0 21 01
RSP: 0018:ffffc900026dbb58 EFLAGS: 00010046
RAX: 000000000000006d RBX: dead000000000122 RCX: 6101d1e720e71900
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88810ec0ae08 R08: ffffffff8115f303 R09: 0000000000000000
R10: 0001ffffffffffff R11: 000188813bc1b460 R12: ffff888114119218
R13: ffff88810ec0ae00 R14: ffff888114119218 R15: ffff88810ec0ae30
FS:  00007f1e57534700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1e574afdb8 CR3: 00000001394b3000 CR4: 0000000000750ef0
DR0: 0000000020000140 DR1: 0000000020000440 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
PKRU: 55555554

Best,
Wei
