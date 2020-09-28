Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5032527B072
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 17:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgI1PBY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 11:01:24 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:52085 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgI1PBX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 11:01:23 -0400
Received: by mail-io1-f69.google.com with SMTP id o7so782902iof.18
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 08:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=vgUtXMoVzIZuhx8MiM8mjs9qIwIIfUuwYTFaRd2LK1M=;
        b=Ho4tlhpV0NARm6ewYmcaRJG5D6+XrJl9g2+KqC3ocN2ThOXmBoanEVGK+Q64UDoktT
         f4YCxNdS+dk/G3dcjiJ8RpbpuoS9Rx+euZcW31HrLCRliUUyKozFZEZsXmGzkQdxj/Zu
         9l2Zb2wk6nwpWlT4YxKsGRJBQmCMrcemICWVH+IFu+Lfb4UmxTFyIkyGXZ1zaAD3TlGj
         zC+DwHvw3kEVn1fTy5XNC7nGAc3rUuUoTL8G/luRBDo87fVzu/78G4G/wDmDF7XQqJaw
         eR1e0KwExWXuH4pzbRkGb1PGazVm8bYYMXod0auFjmLeyUZogg5nj+BpZaTJeHNyiNmX
         5BLQ==
X-Gm-Message-State: AOAM532FAo/myD7ByUMYr+iGPwG0qZ8lskDt+rM/CL8mhX1ivy+MSgZ+
        SK7FT+1o+pIXFKOO+JzNQFZ88S8hIvc15MH2yFpCOq4W627f
X-Google-Smtp-Source: ABdhPJzvmXPhbd+OnJjeaLpf0fv/dOPSi+n2gUF1+r+JZy/3sFGdT1z/4lOKD5DI7cxhl3aBCCDj2qXGrL7rRLGXhmlGS74ESKhd
MIME-Version: 1.0
X-Received: by 2002:a92:4805:: with SMTP id v5mr1662666ila.170.1601305282258;
 Mon, 28 Sep 2020 08:01:22 -0700 (PDT)
Date:   Mon, 28 Sep 2020 08:01:22 -0700
In-Reply-To: <69d85830-b846-72ad-7315-545509f3a099@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000086c59505b060f073@google.com>
Subject: Re: Re: possible deadlock in io_write
From:   syzbot <syzbot+2f8fa4e860edc3066aba@syzkaller.appspotmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Not the prettiest solution, but I don't think that's a real concern as
> this is just for human consumption.
>
> #syz test: git://git.kernel.dk/linux-block io_uring-5.9

This crash does not have a reproducer. I cannot test it.

>
> -- 
> Jens Axboe
>
