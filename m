Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3902A358D99
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 21:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhDHTnV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 15:43:21 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46990 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhDHTnV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 15:43:21 -0400
Received: by mail-io1-f70.google.com with SMTP id w8so2097392iox.13
        for <io-uring@vger.kernel.org>; Thu, 08 Apr 2021 12:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=QAQHHUTa7Tp/+HffxF26prPlCaL4a426RwfTcuHtH+o=;
        b=I/fZhTTtxE9eHpWhM/VNEh0nFo7FyaWrnn1i/I5YgPQ9haNzeFbx8HgWoquHLJloQc
         cyq4WCRyU7kM6qutjZ1YADqi13myDuH09BewVmi2Esz0l2vJcDP2pl7PBsuU8gfWy08C
         Bvj3veG8z3fw7ezfwmS1hMSUQlZswlJP+TLyyxHKf933vNTb00CU55PQ2fAbG7q8jYne
         7c3cOXrRTUpoZqEZKgXcCAYNz7n8Fp7Asxoh8O2oJbU5vlSIESnlF8T/PMPd5Rv8OuM5
         HFy9LlKxPyjwIu3DbhUfld+0+EQ07SgNyMtixoQGO9YGAmMZupqJ6xlWuqAr9027cxNN
         mnQQ==
X-Gm-Message-State: AOAM530aH1jQYZUT5VTqcKHMGnUdCeYFj3HoGbSjfEF3Xp8uJk8TBdx8
        uBa96QHAG0hqAHFcxgUr1T2Y2b4JO3uGiEfc4c97P31BP8h3
X-Google-Smtp-Source: ABdhPJyn4ilIIDryRqlPdr9Xyrum6gvlbzGTLCpVJ28iXXrYaFVYW1uN84V49TH9mcJWXqqJlGwn40JFc7lEhhEoqq6IyjX7VZXK
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20cd:: with SMTP id 13mr8230433ilq.126.1617910989145;
 Thu, 08 Apr 2021 12:43:09 -0700 (PDT)
Date:   Thu, 08 Apr 2021 12:43:09 -0700
In-Reply-To: <000000000000430bf505bcef3b00@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c94d8605bf7b4135@google.com>
Subject: Re: [syzbot] possible deadlock in io_sq_thread_finish
From:   syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, bp@alien8.de,
        hdanton@sina.com, hpa@zytor.com, io-uring@vger.kernel.org,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit f4e61f0c9add3b00bd5f2df3c814d688849b8707
Author: Wanpeng Li <wanpengli@tencent.com>
Date:   Mon Mar 15 06:55:28 2021 +0000

    x86/kvm: Fix broken irq restoration in kvm_wait

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1022d7aad00000
start commit:   144c79ef Merge tag 'perf-tools-fixes-for-v5.12-2020-03-07'..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=db9c6adb4986f2f2
dashboard link: https://syzkaller.appspot.com/bug?extid=ac39856cb1b332dbbdda
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167574dad00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c8f566d00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: x86/kvm: Fix broken irq restoration in kvm_wait

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
