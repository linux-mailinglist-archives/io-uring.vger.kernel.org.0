Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E11A4E482E
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 22:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbiCVVQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 17:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbiCVVQk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 17:16:40 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C9C3FD83
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 14:15:09 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id s14-20020a056e021a0e00b002c7c03a5d81so9880855ild.9
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 14:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=MG5Y8xILdnFlJljeDRhJEgQB6FlTo+9PoQNjAE5QtFg=;
        b=rlyUBE1gK6AIZoQJc/vAVVBrezVl/hlFGwLpf4n+f9pbtkmr/rQeUXTe3wsMJt6TDn
         8Oz0+SG4PIh9KXO8BPst4Dl4/QLJFCq0diz5U2iaftHWG46L/uzh7D4RgNh4S8nLCYsB
         Wwoe1Ok4tIYAbILpVQ1tcrafxviNinxov26bbws9cQHagW5BDyit9L1orHouBjtjxZ3g
         rOlVwZIIolQkFBtl6CyTNvLDjKlcF1hs+zEpKNnp046C1N2vC2eR/zteOKe7tt4u42Op
         UQideE1xc3iLSWWgrfvHF9twP3hZJvzVkAAEwj2qROBoaFnZK3GNaE+hWoQRhLOIAnUk
         vWPQ==
X-Gm-Message-State: AOAM532rjpAvvXr9jNk7vIi6yclBqld2ri+pD3fL54NxluUznvai45XV
        e8MrGsxHrYY675ScyHvgE9wAWgB11WvLnDw3m1hF3gu6CRsK
X-Google-Smtp-Source: ABdhPJzTvsmDj8F2NfYsv6RQxGTEFIkU5OHFdqWqiIQHfiW3AlzdeqdQlJ/DXbOuA/B92prR6jT/PoV0AmcCO+DnykKKdH6Hytq8
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2f04:b0:648:cfb5:974a with SMTP id
 q4-20020a0566022f0400b00648cfb5974amr13360299iow.187.1647983709020; Tue, 22
 Mar 2022 14:15:09 -0700 (PDT)
Date:   Tue, 22 Mar 2022 14:15:09 -0700
In-Reply-To: <5cd8d8f7-b172-12a1-5c4f-f9933b576208@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000092671e05dad51b08@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in add_wait_queue
From:   syzbot <syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com

Tested on:

commit:         7d58de1a io_uring: don't recycle provided buffer if pu..
git tree:       git://git.kernel.dk/linux-block for-5.18/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=3172c0bf8614827
dashboard link: https://syzkaller.appspot.com/bug?extid=950cee6d91e62329be2c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
