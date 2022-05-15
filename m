Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620D1527903
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 20:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbiEOSGT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 14:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbiEOSGS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 14:06:18 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C7827176
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 11:06:17 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id u18-20020a5d8712000000b0064c7a7c497aso8948154iom.18
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 11:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=oPGQxfIwbb9QsQbrJvf8Wi53xwv1p8oC92azXf2cBpE=;
        b=iD7vlBbz/oT5gipjJDFvaFQIedFZ4LUG6Z33+yQt5wvNHqxeWxxsGVOvfjGhhf0s91
         /BPdSm4jfdcRxod6u3EDcd1F9zzsE6BgtQ+G0ud4DLXKSM1BLwyBC9h25rkkbKE25rxS
         V2g2bIK0+lmezc/RvWxQwRbt5wP2PU/42mWyeUMRbfJDy5xTyq6V31CSwqdT7V+T2N0s
         DKxkHFejibNra1YyIrnV9KXNtWK8DnS9KNWaFRBX5GWbIuG5rfa+oF3W0g3Cc7/h+E9z
         d4ytvYKvBHT9YeqItNZY8UPLdQ9DJPkqpabNm3ZFQmpySfDkToYhs1qt0kZ6LU60aG+g
         kTxw==
X-Gm-Message-State: AOAM530ANelg0YLXs9v4tMLOtzcDphP9Drn6RmAJACdyuRq69e1EFpQY
        NgvgxOQ5uWEU/I3Hn/vpwgvDkfuGZ0owJSKhb5M6IuChPRrS
X-Google-Smtp-Source: ABdhPJxD3ycjJsSa5v55IdSjv/TrHXKD0tEnHw6gL+FulOK3q2CBC9dHIAgVaOCcnI21lSPIaBaG5tDuhzkpvxwmAIGsNudsVNaG
MIME-Version: 1.0
X-Received: by 2002:a05:6638:22c1:b0:32b:8e38:bff4 with SMTP id
 j1-20020a05663822c100b0032b8e38bff4mr7184895jat.151.1652637975100; Sun, 15
 May 2022 11:06:15 -0700 (PDT)
Date:   Sun, 15 May 2022 11:06:15 -0700
In-Reply-To: <556cb5e5-bfb8-9a2f-054e-e5c8c488a578@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000072c21d05df10c303@google.com>
Subject: Re: [syzbot] WARNING: still has locks held in io_ring_submit_lock
From:   syzbot <syzbot+987d7bb19195ae45208c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, f.fainelli@gmail.com,
        io-uring@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, olteanv@gmail.com,
        syzkaller-bugs@googlegroups.com, xiam0nd.tong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+987d7bb19195ae45208c@syzkaller.appspotmail.com

Tested on:

commit:         3782ad72 Merge branch 'for-5.19/io_uring' into for-next
git tree:       git://git.kernel.dk/linux-block.git for-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=7b4d7b33ae78f4c2
dashboard link: https://syzkaller.appspot.com/bug?extid=987d7bb19195ae45208c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
