Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533F67B5EE5
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 04:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjJCCDC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 22:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238973AbjJCCDB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 22:03:01 -0400
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E86BB
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 19:02:57 -0700 (PDT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6c6370774e8so438673a34.0
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 19:02:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696298577; x=1696903377;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pPEFo8oXbjF8ymg516CdpgBbWirZ9N1y8MVaoi0LUdU=;
        b=HpFXKxEWXSOibLHOquhsikXm8S0HVEHjrueKSLcjX1+bD4N9FE/bP1YzqQ7LO7n1Nk
         240NQDfgxVH1oXNj7RRmbdic+mg8G88vmOehmLHKWerqxcczOb8heggq4KrNh+BYcO5q
         pN2VvVkXYBN9kHyHDCtdzh6Q0CzGkvMViHlYGjg+ogEzL/iV+cu2nOzB4tiOVavh4VpS
         pE7J1VxN0H6Ax7ddzWHANKb9OR+GGsilPuMeN3j0yMVpsLRT9yU8xdfbNl0KiWHhCjJz
         U6WEOp9yvnDYawtas1z10/M/zYZn7ziexhkSbTWwcS9BG/d1K5S2n8hG0e7VsluSO9NF
         /pig==
X-Gm-Message-State: AOJu0YyOiFRPnYhZke9g3muf5oSYElFnix5kur0QVUVzKhuciL6qnUI/
        3HpIlY3aMvx37rP6KqRuMICj06sAgnzSCAOS7nTq5/mLIcKI
X-Google-Smtp-Source: AGHT+IFG6Y4BuEnzsU58NXttRueTKaCyi5cseJlO00Gj2Jgb/3OO8UWPOedLc16gZm2SspFlnfK80Ycu0WqzbDW/rzvRuj1J0uTP
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2221:b0:3ad:29a4:f54f with SMTP id
 bd33-20020a056808222100b003ad29a4f54fmr6490861oib.4.1696298576935; Mon, 02
 Oct 2023 19:02:56 -0700 (PDT)
Date:   Mon, 02 Oct 2023 19:02:56 -0700
In-Reply-To: <04086fa2-8506-4f6f-8b31-3b539736adc6@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c82d20606c64a89@google.com>
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in __io_remove_buffers (2)
From:   syzbot <syzbot+2113e61b8848fa7951d8@syzkaller.appspotmail.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> #syz test: git://git.kernel.dk/linux.git io_uring-6.6

This crash does not have a reproducer. I cannot test it.

>
> -- 
> Jens Axboe
>
