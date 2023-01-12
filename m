Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01887667DA5
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 19:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240262AbjALSOd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Thu, 12 Jan 2023 13:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240579AbjALSN7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 13:13:59 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20093DEB
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:43:35 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id y5-20020a056e021be500b0030bc4f23f0aso13946748ilv.3
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:43:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6euKgqaz5CvSSFLuJHiJJPEhh3V6W0U8Nog8Z76wv4=;
        b=NfAnns5ZnmvAfLR5Hnnb5UzH/+q0L+oe7kGuOA6Dw9uWCtaGEn+OFMONcIJp9u3vZc
         xhwaZrnTkOnTK5C72DeaKOC52bGvYSs3/3bf64PnU88kxAD1za1qaXxR4TOJCzFHDTy/
         jrmmfcXfuB9+TmvC1okjXFE4BitbrD1DGgqmeElYeEy9zKDgJDDlg+LP3G0OraDU4Pn1
         CRBnBNuNBRzOnByJMtb1AlR8kAvwEzSCxKE/CmwS9Im0rqTv1TDkOMgj8g3nu5xR3+Fx
         VCL/hfMB+oS2pvaNzKrAQdH0MrIMXHuHvgqqDy2cWnXQ++SWOIgm26sMRuEb0mL7u+hT
         wf2A==
X-Gm-Message-State: AFqh2kr8/npDOR72PqvyJCTlXz+IW6Ybh45ORzKGm9bH7xixGj2NmacM
        qb9VlSq5/dT0kc63+g1gHzwY92pCpFU1nFw0F1rbXZMiDFgU
X-Google-Smtp-Source: AMrXdXt6RzWE0Rl0t6eyTbbNXTZXuwLItT296DHWjPJukooX4Stc7BSVoGxsFFhp3pGnXT+5J2Cx/373k8qd81Qu76FPg84d3ac8
MIME-Version: 1.0
X-Received: by 2002:a02:bb08:0:b0:39e:829f:b60b with SMTP id
 y8-20020a02bb08000000b0039e829fb60bmr2523546jan.83.1673545414457; Thu, 12 Jan
 2023 09:43:34 -0800 (PST)
Date:   Thu, 12 Jan 2023 09:43:34 -0800
In-Reply-To: <3c64a290-5134-2030-a2da-9ec2b1efc0c5@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1c14e05f214a763@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_req_caches_free
From:   syzbot <syzbot+131f71f381afff1eaa35@syzkaller.appspotmail.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On 1/12/23 3:26 AM, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1605ee86480000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
>> dashboard link: https://syzkaller.appspot.com/bug?extid=131f71f381afff1eaa35
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
>
> #syz test: git://git.kernel.dk/linux.git for-next

This crash does not have a reproducer. I cannot test it.

>
> -- 
> Jens Axboe
>
>
