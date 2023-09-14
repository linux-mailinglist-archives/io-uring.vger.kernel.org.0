Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F2B7A0995
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 17:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241185AbjINPqc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 11:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241180AbjINPqc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 11:46:32 -0400
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F280CDD
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 08:46:27 -0700 (PDT)
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1d148c50761so1579431fac.0
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 08:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694706387; x=1695311187;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RArJlo5ye8urnOy2gyd9OsYoAqUo3/gdNcnqcjssqdU=;
        b=jLcJQVziSWm4KU79Y+uDXiE1Qah4Yt1QGf6TL1ZMofDmSTyqN2fiT860Gd1Q8g2G5O
         +hsjR3FuI2SLWFc/L8twSYQ9QE77IeXcqm4iykhqNa/YlpSgE8HLFqzXhwIirQ5SWtSf
         y9Bpe4AG7PUGiAHjTkIUBAKizkthWI7wmcny9fNZ48HRizHRO2s4gbdaCUaC5kbCp4yH
         OxhZEqDSjRPknG7FnRFe3mGs6HBD9niTD7XUGNRDRQA0XqZ25aHpzDrbAKHpBOblHH63
         STtrfhHrAxlQHlISWP7JcsntOTPfMR1ghuJx447cU4GGiZrH2AJc4/f5XodYJjP08Fld
         EwDw==
X-Gm-Message-State: AOJu0Yzikpt7HWjamt6RNPBFWZa74KSyICgcd1yoBoyJO1vqu6ItEeYh
        fFc5SLwT1sYm+ceeAK4YMXi7bytr/xFEMMLMjuVR8C83IDXc
X-Google-Smtp-Source: AGHT+IF6uNb9IK2O+QDjpLsm23ly5Qk2+0NB1BGNDr1vVzmcpsj6r1rN9DM0+mzTY/GGTklQy/xV7wXLSI31ay1LERgmfbbhfBfA
MIME-Version: 1.0
X-Received: by 2002:a05:6870:e6ce:b0:1c8:e107:4193 with SMTP id
 s14-20020a056870e6ce00b001c8e1074193mr2009281oak.3.1694706387368; Thu, 14 Sep
 2023 08:46:27 -0700 (PDT)
Date:   Thu, 14 Sep 2023 08:46:27 -0700
In-Reply-To: <6fd7f735-6262-73cc-c5d2-b508c25b360d@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000037c27b060553949c@google.com>
Subject: Re: [syzbot] [io-uring?] UBSAN: array-index-out-of-bounds in io_setup_async_msg
From:   syzbot <syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com

Tested on:

commit:         ff035989 select buf net iter init
git tree:       https://github.com/isilence/linux.git syz-test/netmsg-init
console output: https://syzkaller.appspot.com/x/log.txt?x=13421bbfa80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f4894cf58531f
dashboard link: https://syzkaller.appspot.com/bug?extid=a4c6e5ef999b68b26ed1
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
