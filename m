Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FA8667DAE
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 19:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240400AbjALSPJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Thu, 12 Jan 2023 13:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240607AbjALSOF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 13:14:05 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4ED95AF
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:43:56 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id r6-20020a92cd86000000b00304b2d1c2d7so13938525ilb.11
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:43:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k76Tm9AExJH8yhWGj0bClcG043cy2CzV+QD9Vr5N/pw=;
        b=EHd8lzBup15CP6T861r7kvA+p5aozLxywdAcxaoyZILgB2wzK6GlFT9P1cHJZMkbMM
         9lwS2XwZxLg/Lk6FAaxFpt2sJOCMMLgbzZvby9Sm77hmUj9bVPQ75vUPgzToTK7nuqLp
         p7hg6D3cH8Gxk6xbfl4ghKBmNvwnJ5ZZHYDTP5kaaNa+1bHN04x2m4fqAeeWpftRGmOJ
         Nr0KNYMB9nKFu+QmRnnBhlaxYQ0rSIvS/8eSPNSEAW53G8ISXx++jbsIyt8zOt+p1if6
         6Iv0V7PCHYQuvQtjZQERabjysmplE9EVCQF/n4UHfhQ5mrkTePaJx1URsvUcffkWadr6
         b+Ig==
X-Gm-Message-State: AFqh2kplsz8ycO9CvHn1xer7Yg1kDExcN9BxTkJEE4Ub39Bnwn+HYEga
        HHXaby6+xvZT90mw/TcTobJAxfVAzpa7IB8POboRV0gT/Jju
X-Google-Smtp-Source: AMrXdXuj0Sq65PVMwZ8u6T39249nH2iGCEJYwj1ru2xGXO/yjTT6+NFpYyDwHBwUiZIWSUlV+lbSoNFMv7BhY7OULa0+xqmKRhGR
MIME-Version: 1.0
X-Received: by 2002:a92:c011:0:b0:30d:95ce:5d88 with SMTP id
 q17-20020a92c011000000b0030d95ce5d88mr2725503ild.186.1673545435930; Thu, 12
 Jan 2023 09:43:55 -0800 (PST)
Date:   Thu, 12 Jan 2023 09:43:55 -0800
In-Reply-To: <a6225d05-3e75-5a0c-1998-c34e7db6950c@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000396a8b05f214a98c@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in __io_req_task_work_add
From:   syzbot <syzbot+01db4d8aed628ede44b1@syzkaller.appspotmail.com>
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

> On 1/12/23 3:26 AM, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=111a5a86480000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
>> dashboard link: https://syzkaller.appspot.com/bug?extid=01db4d8aed628ede44b1
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
>
> #syz test: git://git.kernel.dk/linux.git for-next

This crash does not have a reproducer. I cannot test it.

>
> -- 
> Jens Axboe
>
>
