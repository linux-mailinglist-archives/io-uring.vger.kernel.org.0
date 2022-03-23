Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162394E5BC0
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 00:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345470AbiCWXSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 19:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345467AbiCWXSq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 19:18:46 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AA190CE8
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 16:17:15 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id b15-20020a05660214cf00b00648a910b964so1980829iow.19
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 16:17:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=clW1tH3ZC7Lm0X7T/4WUZGOowaN8nMkUH4EAKd7mMwA=;
        b=FqEq6ceFpg3HjVrHGgsxmbuNhC1eTloJMU2+ss0Yq0wGHfLZeW93SCe/PUtPsF5XJw
         K3Bl42BaC4EtFMFIfUiYpjNGgN9cZaEDZUzEnmlJTpyh7YPTt92R1BmbG8B7r295R1Pg
         wOCxohf94U+CxKkbYEHu3ySul3/p+tykQ0jdWVH9tzgy3KudHC2l2juQaPElovGmpFnQ
         wW0vku++3jfmNbSKI+4rJrQ7Xwok73AkANRMBLQOtGzbvrUkV2o1IhCRTXCUyuqtQllb
         vMyUlD3SwWd6PXcto3bObGkxBGmL95Q/LIcmjwOPMcxk9S6CG8DI+4zfMQmbrSzTW9aB
         N5rQ==
X-Gm-Message-State: AOAM532UlJwi4LS6agcegeAasC+huizp0M1nWDyvElf9xRzPy3tDs5eo
        xKgq4lrbnNW6XkTeoP9TuppKrhdqwFk0YKLMhpJj2cv30niX
X-Google-Smtp-Source: ABdhPJx5oe25ghsA451wnyS8jAONpeOgSsVTFqm8sKVCgTUeGUlgGdMSvN/eNIS6+5zzG5XyESpkqmR7/ui7OT1nLeHmmeEH+AaQ
MIME-Version: 1.0
X-Received: by 2002:a5d:860d:0:b0:649:be05:7b0b with SMTP id
 f13-20020a5d860d000000b00649be057b0bmr1283401iol.22.1648077434896; Wed, 23
 Mar 2022 16:17:14 -0700 (PDT)
Date:   Wed, 23 Mar 2022 16:17:14 -0700
In-Reply-To: <442f565c-b68c-9359-60d1-dd61213d3233@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011c72405daeaee81@google.com>
Subject: Re: [syzbot] INFO: task hung in io_wq_put_and_exit (3)
From:   syzbot <syzbot+adb05ed2853417be49ce@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+adb05ed2853417be49ce@syzkaller.appspotmail.com

Tested on:

commit:         8a3e8ee5 io_uring: add flag for disabling provided buf..
git tree:       git://git.kernel.dk/linux-block for-5.18/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=3172c0bf8614827
dashboard link: https://syzkaller.appspot.com/bug?extid=adb05ed2853417be49ce
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
