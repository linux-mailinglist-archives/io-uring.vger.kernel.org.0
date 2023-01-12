Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD10667D98
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 19:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbjALSOY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Thu, 12 Jan 2023 13:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240531AbjALSNu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 13:13:50 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4436DBB0
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:43:18 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id y11-20020a056e02178b00b0030c048d64a7so13918400ilu.1
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:43:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mJ/3NEdJjcfIwphz3ctLNzvcyG4TGwGYyLvC3FGbeU=;
        b=L+PRZACzhCRl1jVyAka3jHxccNpU0399tyLUv6JIjoGt2UcZBPDqd3MORxV8PM/xNo
         o4SgPZfzE3wYaUOn9qx3FAn0ThYEdpYLrV6CcYdwh6Ndv8IjnYTO27un2up+0bNjmkVs
         25u64EHZgqv8D6+5GZYdpuXuCtOySEDZVvAU3sPFpcUeNGXpEfkGguEcbhvjjH6gz7Wd
         4k/8a9hCIZDkjlvqbcvmhmqW79G0sVwE/D+9TPNwfz/bPYRm3j7gr4SzAy3zZ2BL5ITI
         X/zqXaym5O/x0DO1GLCy0eJo/9FjoRv6h9W/V7Gkkt4W7cpaEODewSoebpk0tYrIzyBE
         xKnA==
X-Gm-Message-State: AFqh2kplOuDITgHEhA6aTjBKAXMxgv8Wh5e/USkgg0xUEAmZAWGT9u5y
        nDfuzRnkaLUzRB9hL2IOUMmVSliBNEvNdmbB5Sb0wSb9Bf/s
X-Google-Smtp-Source: AMrXdXsi/nM7b2/T2ZImf2mdRFJBqoTWqs7nDy7uSg47A2a/jY21QFeZggHBd3V2E/8L2XD1GMgfLU70Qc4Fzm4TQPfw2wcsXfm1
MIME-Version: 1.0
X-Received: by 2002:a5d:9644:0:b0:6ec:c7a1:aa0d with SMTP id
 d4-20020a5d9644000000b006ecc7a1aa0dmr6588951ios.139.1673545398261; Thu, 12
 Jan 2023 09:43:18 -0800 (PST)
Date:   Thu, 12 Jan 2023 09:43:18 -0800
In-Reply-To: <b130dd91-0871-6138-9a40-8499fb776875@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fa9db705f214a6c2@google.com>
Subject: Re: [syzbot] WARNING: ODEBUG bug in __io_put_task
From:   syzbot <syzbot+1aa0bce76589e2e98756@syzkaller.appspotmail.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On 1/12/23 3:14 AM, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14d269ce480000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
>> dashboard link: https://syzkaller.appspot.com/bug?extid=1aa0bce76589e2e98756
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
>
> I know there's no reproducer yet, but when there is:
>
> #syz test: git://git.kernel.dk/linux.git for-next

This crash does not have a reproducer. I cannot test it.

>
> All of the ones from today was due to a buggy patch that was staged
> for 6.2, should all be gone with the updated branches.
>
> -- 
> Jens Axboe
>
>
