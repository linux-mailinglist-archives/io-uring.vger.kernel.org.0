Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C46444BA1
	for <lists+io-uring@lfdr.de>; Thu,  4 Nov 2021 00:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhKCXaN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Nov 2021 19:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhKCXaK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Nov 2021 19:30:10 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72794C061714
        for <io-uring@vger.kernel.org>; Wed,  3 Nov 2021 16:27:33 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id q203so4720783iod.12
        for <io-uring@vger.kernel.org>; Wed, 03 Nov 2021 16:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9briV7S+xwu2jII1u3WP74CsyaHx/9CSCvTDSgnplDA=;
        b=e9pD45l8q/YOHP0mAg4QMA2i5/Q2mJSKMY7uFEzZkzmPjvSsV6zFs8gOa9EYCIxdj6
         7gHRSEelccv3sy8JyDr8qa/fovYkBeLL46AlpKhXG7/lXricug6a8tYnIUI410fjtHNM
         TD0Kuy+wz+xc4l97oecMxxUKTjf4HwAa9/oVy51HVW9F4PUarvVOIDJ+UpW9h2FRdw0r
         QjMeeMdiLp4lu7XAdEbp+ukxblLdO1/+smft+8WjpuRHWXAOdiwjVKFhoUz/AMI2jfWr
         RZc74GYdt3+1CzE9etbBlsV5K3mi8md60VWRkPUgZPKEqUxucsw7yJsj6FQLMI4hsA3x
         4XYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9briV7S+xwu2jII1u3WP74CsyaHx/9CSCvTDSgnplDA=;
        b=XKLDQ2DwUwoNEkFNg2XyoCu6V/gmEyRP2Y3H2GejUoVAF1+ZCZMcJUw9OaXh/cra3I
         01tOmRoYkkvfMWParl+ZHwInOwN828F+0IpzW6NCyRQomXTl3SfnobDr+19nvyXOVVcB
         6EcU0jCH+vyu/mQjgEPu8XNIXP4X7T6c4SVsfpbtf1gXP6yNDSeIcrs+bNdN4M/gkSyb
         UQ2+ZHlK6c0CRj4Gh4Um2i0rjSPK+AuNUBAhD8p/zoLdGfXra13CPuz1W2T6SShG7jUR
         Bv76/EMUUI3lFtm3Vb2BT61o5XMA0SHQtnwaown4bcOi9JYa+v8fpUyfyH89Gv+WrD9k
         aBOA==
X-Gm-Message-State: AOAM533Gu5HeFZSazhSbnurhp0oidS+ltUM/+K7J9pv5XerFIsxpF00a
        Ozjxwlk2aOzY6JnH/ilPzWA3Lw==
X-Google-Smtp-Source: ABdhPJyGoOfpZXPZcdChNFRjiYPgi/i385fBbmhb6Q0lulL3ZyL0ZdhNiI7a8bH+lOTwuWL3oKJPvg==
X-Received: by 2002:a5d:954b:: with SMTP id a11mr33350224ios.99.1635982052859;
        Wed, 03 Nov 2021 16:27:32 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id l18sm1682458iob.17.2021.11.03.16.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 16:27:32 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_poll_task_func (2)
To:     syzbot <syzbot+804709f40ea66018e544@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiaoguang.wang@linux.alibaba.com
References: <0000000000007a0d5705cfea99b2@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0935df19-f813-8840-fa35-43c5558b90e7@kernel.dk>
Date:   Wed, 3 Nov 2021 17:27:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000007a0d5705cfea99b2@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/3/21 5:16 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    bdcc9f6a5682 Add linux-next specific files for 20211029
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14ab0e5cb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4b504bcb4c507265
> dashboard link: https://syzkaller.appspot.com/bug?extid=804709f40ea66018e544
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15710012b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11862ef4b00000
> 
> The issue was bisected to:
> 
> commit 34ced75ca1f63fac6148497971212583aa0f7a87
> Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> Date:   Mon Oct 25 05:38:48 2021 +0000
> 
>     io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request

Again:

#syz invalid

Please stop testing dead branches, it's pointless and just wastes time.

-- 
Jens Axboe

