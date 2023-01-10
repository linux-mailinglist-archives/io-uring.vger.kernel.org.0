Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3037664F99
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 00:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbjAJXJV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Jan 2023 18:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbjAJXJR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Jan 2023 18:09:17 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B71B05
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 15:09:16 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id u24-20020a6be918000000b006ed1e9ad302so8020872iof.22
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 15:09:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wMq+5YbxbdQtL7sPG63Ybj/quOFBMceHZrsboopnGL8=;
        b=xBSm4WBLtM282LJQOkL7JmOAlx60FooA2EJE3PEpWRa/3EGOAhXkhtc4ZXOj9E/LRU
         XGhMAwygf3lmW/LTv0KnlaO6kFheti1WVqyF3p8ipv08kLBDPRugiRrTj3X+dguUZuYQ
         ZxT69OP5LwWnLrh7Ry7dU76muMWQ+9t2L0oMCT0GgUF1WvYeZiUKHFBxFLl/te2GJsQ1
         8HUJnYzVMhKvRFcgfMpzZax8xtlbnfsDaKRd0Y2rjQWeLeb6v8ajHPWiq7l0Yc/lJH9T
         qXODjVW9/Ur9EiiaBbEa5SwskSNaXhQq/ifZtKZQGlCcLvQuM3Cd8fDVpSFbwTGcSEb6
         0mbA==
X-Gm-Message-State: AFqh2kpZkU1uJzdRnUv/zei75ZyAHM3doGCHNPRuNnw8YDSDxMmEhVcR
        qK/cXIMB3PkZELP4iSrbXjP5ibsTdBNvw8PIAI6dbMKOs/2N
X-Google-Smtp-Source: AMrXdXs0QEN0d230UYh4hktMs5Xcoyn7rnFVerfDN4YC+6KAO5M3f2s83bApDd/GfzP06dW/fhqeLPIJrwR9GerxJhw67un8bk15
MIME-Version: 1.0
X-Received: by 2002:a5d:8b8b:0:b0:6e2:deb4:b078 with SMTP id
 p11-20020a5d8b8b000000b006e2deb4b078mr5599832iol.52.1673392155056; Tue, 10
 Jan 2023 15:09:15 -0800 (PST)
Date:   Tue, 10 Jan 2023 15:09:15 -0800
In-Reply-To: <e0d7b1ed-1ffb-c97c-13fa-055db635f404@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f8e84405f1f0f804@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_wq_put_and_exit
From:   syzbot <syzbot+0ef474eead6cc5d7f8f9@syzkaller.appspotmail.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> I think we can stop reporting issues on the same buggy patch... But
> in any case:
>
> #syz test: git://git.kernel.dk/linux.git syztest

This crash does not have a reproducer. I cannot test it.

>
> -- 
> Jens Axboe
>
>
