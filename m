Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274DB668958
	for <lists+io-uring@lfdr.de>; Fri, 13 Jan 2023 03:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbjAMCE1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 21:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjAMCEZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 21:04:25 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14851621A5
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 18:04:24 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id r6-20020a92cd86000000b00304b2d1c2d7so14850049ilb.11
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 18:04:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ayK0uCBsQox46J2IE0pM400tXWnCHlDcWCx3CfqtMg4=;
        b=4CiR9PvT+kRrIGFQRiiElL7iK1fp+sq0G2CrC4/8au/CAHmOeRqs7wn8FlVhN+ccrE
         iJ/K4OTQ84PEzTBGyLLKx4oKKa87mlFsC4gTqAMg8PIZ7pJu+mTcMyiBYLdXO0LmCqN+
         ehB8bQoOgkx6mhVp4td07feH/ZLC4js7vN/BiBIzKTe7Axhk8t/CYAEwXBcQw/ezPKJd
         gvijZW4EGa8q6bdZfNv6eM7G+mFk+EjpHSmFM8E2pz8HtGc+by0WG9Q0GHjnBsbSEhuT
         ++Cd4nEllseOMcfgJpAeSwGIXwhWWK9RWZQKaAigjnc0iS27yhN5kY9Rj7H89CqHEzso
         Ty0A==
X-Gm-Message-State: AFqh2kqzphnzaXeT6+bwcw59u4dNnCXxMiZ3mPlEWNQw/wGABDCqZr1P
        VZjq8WpkWUmWTzcZ/5efDX3lEOEGmJnPUJaxBQDBcXbZZuUz
X-Google-Smtp-Source: AMrXdXsKcSRHw8sK4t0XWANe42NYk0I4/oJdtmEBrZdoPzhm0JpvcxnGDQ4Sn8K9sIotqBiDSGtJjPWBqOpkz1le8/IfbiZrzani
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f53:b0:30c:2d97:1a9b with SMTP id
 y19-20020a056e020f5300b0030c2d971a9bmr5456205ilj.143.1673575463465; Thu, 12
 Jan 2023 18:04:23 -0800 (PST)
Date:   Thu, 12 Jan 2023 18:04:23 -0800
In-Reply-To: <d4f4556c-11ac-7533-f047-cdcfda9bddf8@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000013c3e05f21ba793@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_fallback_tw
From:   syzbot <syzbot+ebcc33c1e81093c9224f@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
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

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+ebcc33c1e81093c9224f@syzkaller.appspotmail.com

Tested on:

commit:         73f41663 Merge branch 'for-6.3/iter-ubuf' into for-next
git tree:       git://git.kernel.dk/linux.git for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16cc1236480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b6ecad960fc703e
dashboard link: https://syzkaller.appspot.com/bug?extid=ebcc33c1e81093c9224f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
