Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8364404AD
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 23:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhJ2VOk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 17:14:40 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:57117 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhJ2VOh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 17:14:37 -0400
Received: by mail-io1-f72.google.com with SMTP id z1-20020a056602004100b005e1759b24f8so1647483ioz.23
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 14:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DZhb+VO37XCGG7f7xVXdqzAOL+vfGSVWBL7jiOZyERA=;
        b=sfxdtrt7nZiZGwa1s2GbL/WWemaHPXubJ7VPk4JtuqAwxdWaRa0mpSPaM+dppqbzb6
         vvCNaKNI7Hi+eKvlpPF/Wwc7JQp+yOFHmiA6oXJNdscGI/1xGaioCmEJzC2k75JJ9a6c
         +VoaPUId0GOMesFTT44zCG/QU5rwc5x0UBWgb9RqmV/IqeV3I5mVys1mxGp94p+AFqV5
         H6jFsj+NzaLR9WlEiLn2Of3txWbrR0H5zw0XsjA1gr+N1TveLoKfaD19GbHYrsRvdcvn
         GBA28lvXv23UsZA0AeHwqU99xfJ/yw+B/++s/MjSQC5CyqXUVTapqlcQsqJZ7JgpO3dU
         T3Cw==
X-Gm-Message-State: AOAM533c4F2flMG1eAoAdU016ZfRLbP03a1aLcajXmrD9BJWuJwOSr0h
        4pSGXWet8INMxQV0uv+Z/dj9qE4wcR7fr52S//NnEh9o0NUM
X-Google-Smtp-Source: ABdhPJzPFjEpTzpO7k8nLm2VnYMkJSdJGEwdkl7gMHmQZUrJy9wjQWpdZMv7G1boha9IooJCaMCR3FGsNm+zdpT5U5M1CWgLLEsh
MIME-Version: 1.0
X-Received: by 2002:a02:2b08:: with SMTP id h8mr10206922jaa.137.1635541928627;
 Fri, 29 Oct 2021 14:12:08 -0700 (PDT)
Date:   Fri, 29 Oct 2021 14:12:08 -0700
In-Reply-To: <ef1ef79b-af92-863a-c5b9-49ea231c5192@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000abd1dc05cf8447ee@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in __io_free_req
From:   syzbot <syzbot+78b76ebc91042904f34e@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to checkout kernel repo git://git.kernel.dk/linux-block on commit 3ecd20a9c77c632a5afe4e134781e1629936adab: failed to run ["git" "checkout" "3ecd20a9c77c632a5afe4e134781e1629936adab"]: exit status 128
fatal: reference is not a tree: 3ecd20a9c77c632a5afe4e134781e1629936adab



Tested on:

commit:         [unknown 
git tree:       git://git.kernel.dk/linux-block 3ecd20a9c77c632a5afe4e134781e1629936adab
dashboard link: https://syzkaller.appspot.com/bug?extid=78b76ebc91042904f34e
compiler:       

