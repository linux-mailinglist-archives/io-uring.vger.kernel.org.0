Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEA23A4F88
	for <lists+io-uring@lfdr.de>; Sat, 12 Jun 2021 17:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhFLPuV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Jun 2021 11:50:21 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39425 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhFLPuU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Jun 2021 11:50:20 -0400
Received: by mail-io1-f69.google.com with SMTP id n1-20020a6b8b010000b02904be419d64eeso11227582iod.6
        for <io-uring@vger.kernel.org>; Sat, 12 Jun 2021 08:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=fHKEKHdPjoZhYVJRZoCAKKckDq3mCm+7VXF61UEPMbE=;
        b=ZJatW7fR0GN+JalEFP+rF2Bnz13l21LMt02zZOtxctYib58W/7EodgkOTwsws2VYOu
         9RQf0+cjZIKQwmYlQMDNmgK3Vk6YVepcOgHMDfoXySaGhsAE+LD5cX9reDUPatYPkpCu
         Ub4s8sBGKbOZI6xhPCT35dno1bXUjAIRgnRNdEIAtsUVfbBORHbsiL9ugMNfGgi6mc6G
         5McLooCeJwE7/euhJ96waGY6JP38Kj5tQFp37/bWmK6XiXop9hnxtcW+QhshhQwqjasg
         ZOaLFwRtlt3l0hQ44IthvdqZ3kGCbkeXkagjSxoFpCGtuxF7MiVtIq/VieAy0u0VoOYm
         lJTA==
X-Gm-Message-State: AOAM532c7q5ciyLH9bGeKSiJhzmDcF5cMChRCQqXdRNeLqmolXJXMxPQ
        5zzPCB2SQTUWxXLm0KGf/vqRZe/ga/XopRv8umIpClbMY/oi
X-Google-Smtp-Source: ABdhPJxwicvpslAfehGqNDqtLCXqGTIaNYt46nQ5oM7xsDuDXeu+CzN/C0h5XtpoKbFsY4h1N65d9YNhyl6wHUwYr2dM4hUnln8a
MIME-Version: 1.0
X-Received: by 2002:a92:c211:: with SMTP id j17mr5619986ilo.232.1623512900682;
 Sat, 12 Jun 2021 08:48:20 -0700 (PDT)
Date:   Sat, 12 Jun 2021 08:48:20 -0700
In-Reply-To: <0000000000000c97e505bdd1d60e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bbc7c905c4938de9@google.com>
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
From:   syzbot <syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        oswalpalash@gmail.com,
        syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Auto-closing this bug as obsolete.
Crashes did not happen for a while, no reproducer and no activity.
