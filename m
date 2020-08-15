Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C0F24532A
	for <lists+io-uring@lfdr.de>; Sat, 15 Aug 2020 23:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgHOV7A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 17:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728936AbgHOVvy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:51:54 -0400
Received: from mail-io1-xd46.google.com (mail-io1-xd46.google.com [IPv6:2607:f8b0:4864:20::d46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F01C0F26F8
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:15:04 -0700 (PDT)
Received: by mail-io1-xd46.google.com with SMTP id k20so7545626iog.2
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:15:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=4xpDMl3NeXZcwdAiC+yVFHrHRUJEIDgJ5ulLpZwqEjI=;
        b=joTISTfs3M1rih8HUKPnJ6FyGhmsY2xnYSuJA6lefTfvKT91N1Hsjm16OXnZUKYQsN
         8B9NRu9m884iChk4Bt9H8/NCXJ8Wxb8Ls0JAmsEoZIy9TWIw7vcGnx/g30YQEyIkKCX9
         y/49TxqnE3/zw5zGFZx3nLiPM3PgXF5mvFa5Sim+zkHZ2nlD1ejgDmW5IvND3B89PlUF
         6wPt8hTyvERT0q1XQhYM1fVCdaS9XgjysB6w74jKXk8gfcGnU7ZQ1CXnGicikUyY55pL
         ub8u2bm0amnlOuf81oqYaCe/zWoqQNDi+irM6ACDSPVZ0NA8FT6dAu0+//PFl5O5zi3Y
         +Eng==
X-Gm-Message-State: AOAM5327XGGSSIyNxcfodwj4EBVZAmlxM3ndSIadzWcxjxO/nPfOWskT
        gQh6cu+Hsm8U9dZ5ltP0k12n3uIoXEq+TianFw30kjKIiGan
X-Google-Smtp-Source: ABdhPJwWbQqFhbKiJRtugfK4oKOj21an5kZquR9VFiI9RweoGgikPQvFcrcRyVgyQeEnOHoeb3Up7TqAFi6Ze2gqNRsgMi9v/td7
MIME-Version: 1.0
X-Received: by 2002:a92:85c8:: with SMTP id f191mr7591361ilh.242.1597515302467;
 Sat, 15 Aug 2020 11:15:02 -0700 (PDT)
Date:   Sat, 15 Aug 2020 11:15:02 -0700
In-Reply-To: <e3494c53-f84e-5152-42b0-f8ddd3ad4ccb@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000207e2405acee84f5@google.com>
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
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/e3494c53-f84e-5152-42b0-f8ddd3ad4ccb%40kernel.dk.
