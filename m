Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A71E66C006
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 14:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjAPNn7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 08:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbjAPNn5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 08:43:57 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260301CF52
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 05:43:56 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 141so19712124pgc.0
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 05:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BNSsmno8e8s9oFCMBiRbmu66VIEr5qjM0vt5oGHy2JU=;
        b=aAJ7bHocMQ8t2p9/9nDJJWMlvaBtA/p7xcLuCk6+5H4U60Y+ahRYKaDENAtmBXJg2R
         Rzj9abrDPhI/PjkA1NWGCf5R2brQ5quq2fHOKZ67Meu2L7GQVNp4h+0+7lvrcSDDOyh0
         DUj1+lQi8cM7c0+KE1iXPgBXktTBdJ7ecW6L9IhZqROSUIcxIQGFnahAbL3yjoKjpp7T
         cSYHP16YrxF5/xtCLLf9E79uPNnEEwAlTAMCWtMkcHukedu+TwLjeHBmAXfeHwKQaCA7
         qSLST8E473ecUwRr9vvZWB7/dSHsZHrjtV/wCHKBsUHKPtOPag1kUOunUvnmjHj8/du9
         ahaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BNSsmno8e8s9oFCMBiRbmu66VIEr5qjM0vt5oGHy2JU=;
        b=5pwrWxpmqYre0+NQD9r4Pug1qArQCOxJIiOtm7gI+TD+ry1oldNwv/hQsnD74dkvmB
         BxeHoLJbikWsqj88VrE6UGLnQ88iGuLjLm3ayfmrw4pNwdBYKtR7t0H1m8DaOzC0584o
         ya0O5087ntrdoyXtaDjvz6fDpswSEHySRvlZjynSAGpCQR+XEGz8F58674kybEYDjSc3
         SWQVJRGgbUt+isZNwSunwezoOJX+JOvW9AvThv2gkWyDI7rLIwGZivKV1frOj1GeBawi
         Fp4wShor2/fjn2cgm7l7WEcgWIllMvQE/MpeSJv+mHBeGPDcBxqg8vMrt0SWCyxmNvG4
         Zg/w==
X-Gm-Message-State: AFqh2koP5aO/CJRQyzRwZ4Xpk35GkLEwDip6NgLeoLlBUnLmb0pk+H27
        pTR8UMSj6OEJzEg4LNPWdOGHyQ==
X-Google-Smtp-Source: AMrXdXsCDsCqQp0C3v1H7c5m1yd13Zbw4SzK7gfjWP3xAYyzgSBqj5ofeBqknm+ZNqo4ggcMwfMhug==
X-Received: by 2002:a05:6a00:781:b0:57f:d5d1:41d0 with SMTP id g1-20020a056a00078100b0057fd5d141d0mr20227289pfu.3.1673876635545;
        Mon, 16 Jan 2023 05:43:55 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y10-20020aa79aea000000b0058ba2ebee12sm2324129pfp.158.2023.01.16.05.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 05:43:55 -0800 (PST)
Message-ID: <4aabf060-e024-7e6f-2037-8b13a35531ca@kernel.dk>
Date:   Mon, 16 Jan 2023 06:43:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [syzbot] KASAN: use-after-free Read in io_poll_task_func
Content-Language: en-US
To:     syzbot <syzbot+cb95143d1d4d788c1941@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000b9f9fd05f25b74ff@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000b9f9fd05f25b74ff@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/15/23 11:11 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12fcd936480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
> dashboard link: https://syzkaller.appspot.com/bug?extid=cb95143d1d4d788c1941
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

syz fix: io_uring/io-wq: only free worker if it was allocated for creation

-- 
Jens Axboe


