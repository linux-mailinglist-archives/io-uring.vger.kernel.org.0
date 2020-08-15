Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84152452D7
	for <lists+io-uring@lfdr.de>; Sat, 15 Aug 2020 23:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgHOVzl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 17:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbgHOVwZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:52:25 -0400
Received: from mail-il1-x146.google.com (mail-il1-x146.google.com [IPv6:2607:f8b0:4864:20::146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0DCC0F26F4
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:15:01 -0700 (PDT)
Received: by mail-il1-x146.google.com with SMTP id u13so569552ilc.3
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=oxh1zcQhSSj1sRDYKLj8pdLk064Zf9K9zDx2kCQjG6E=;
        b=eeCoX8MZ15EUKkWpRAUpYgkdH9xz96c+pwffKRMaddRCfZ2Cpce9CB8KUtv4HpyWFt
         1d2S/jgbEKQIJxar05YGamaETsoPFs1wLo9jpkxpNTgEfyrtrMbezH4jjg2MPsB7cR54
         2kvRXvCnow0vWro6BIoIxq+qn6zBBU9LCkEv0OtKFqliaAXrFP4xyKfsivLXC4So30kd
         NzCvn1Wf+Zxwjnw4NDA6k5GQMQnsRYUR0D3UKMHtdgPwHUDYU7zshVowGaBlaihlan//
         lHAZs5EOu7CTUzzRi2ocAVdaDhqPMTS10dbHF5OQ42siRxsDMG4+NlkyawkMmsT1Oinf
         6FQQ==
X-Gm-Message-State: AOAM530RwqtFLqtA64xN2ce1mBRW9Zo2n1okilQugYsTDFmCQCrL+AQr
        6Y7XJiUl4NL3yHKvZfcCWeN8Os8sp1500OkMvBtq5qTX4tLe
X-Google-Smtp-Source: ABdhPJwKIeEtMwp1Y8DbX5t31FAG0vSEIhEefpQF/pyBQ5lBtW1+CfErzIxRKUS8nmtkvSnig51XIfvJAMACW2/7etVGb8cI+Crj
MIME-Version: 1.0
X-Received: by 2002:a5e:dd4c:: with SMTP id u12mr6289294iop.93.1597515300962;
 Sat, 15 Aug 2020 11:15:00 -0700 (PDT)
Date:   Sat, 15 Aug 2020 11:15:00 -0700
In-Reply-To: <e3494c53-f84e-5152-42b0-f8ddd3ad4ccb@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000009878b05acee84c0@google.com>
Subject: Re: Re: possible deadlock in io_poll_double_wake
From:   syzbot <syzbot+0d56cfeec64f045baffc@syzkaller.appspotmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> #syz dupe general protection fault in io_poll_double_wake

unknown command "dupe"

>
> -- 
> Jens Axboe
>
