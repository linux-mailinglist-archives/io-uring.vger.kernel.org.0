Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C20404366
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 04:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349793AbhIICCd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 22:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbhIICCc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 22:02:32 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5ADC061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 19:01:24 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id a1so331019ilj.6
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 19:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=J7w6nPIL5l/i69KVjJtY1FnT7TyPzHGDm7cqFqbFrzM=;
        b=uAqFNoGPIouKroc8GlRRP8Ll1AILv3WI+RAmzxASefabLwPAOWkTnXpuwF3nU7PjnD
         LLRf7P0ENLFQjX5WRoaOvAX5YdDTRKVCW6whGABVlRNIApQ6rTuEvU0TDYfLA8iXTF1w
         Uel0xHsM4BcGTKAEhQb4xCfQWAvoaq1T5LVvq9mP8G/vxT0ukoL/M1rxPAHMcDb5YpjO
         48zjukyvRZfXSGm05Dv+ei2hGTZVDwfqxEjpnTcZPYB3nsz6sp9sjhsidBhuQiGHzarm
         PdvzodfhzXcKwlNAewWaAfX7LZaFUie75G27JtNPamTL44ayAIjtqp+khaY7JwbyE1K8
         Pqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J7w6nPIL5l/i69KVjJtY1FnT7TyPzHGDm7cqFqbFrzM=;
        b=c9HfPobEFSsy5WQrRbKL0jLrky8WNckDKXJLnOFwMubuSzvVy8zVuUVRruYmK5gsQt
         rdJbEoPYF1ApP32/UqGtLdLolXU9Gnu68Q5viEHQcan5Z5iEhVFyBFv3d9JeEDE/nSig
         +z0f/uPL5Z9V0LuZ9+oPRKiVDAlq6clMmNLbZM5y04C2hjvy7P42EuTfP+hNBJk5bzNR
         +Xdh69HYf4aPtcl+TOOK+uplnxJwsoRuzlidm7X5sUAAb4dcNny36sjW2h5vy6QdFFpK
         wG/uDD8D8zhFZbY79EN0mKRfH0yvPan99rcv1aKj1jKHFM81bg+PUPWREqiT4fxcp0ek
         bvNQ==
X-Gm-Message-State: AOAM531uOgXTYuQ5xsudrn7wiVFcLkF8XiCrRCbms/EHJW7gs6bYF7vy
        OnDYACUSWn8OvAUE8m0+cYYuKA==
X-Google-Smtp-Source: ABdhPJwEumYvFQI8qyEtCEmTTnCwB7vhccbE/dOal2FKavEbOHmgov65pQ/ohbaiKTr1sNnfhVH4lQ==
X-Received: by 2002:a05:6e02:130e:: with SMTP id g14mr414191ilr.81.1631152883747;
        Wed, 08 Sep 2021 19:01:23 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p135sm228722iod.26.2021.09.08.19.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 19:01:23 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_wq_put_and_exit
To:     syzbot <syzbot+f62d3e0a4ea4f38f5326@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000047c10a05cb84cf00@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9bef8d9e-7378-62e6-b78c-af3fceab2e46@kernel.dk>
Date:   Wed, 8 Sep 2021 20:01:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000047c10a05cb84cf00@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 6:09 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4b93c544e90e thunderbolt: test: split up test cases in tb_..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=111b2c2b300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ac2f9cc43f6b17e4
> dashboard link: https://syzkaller.appspot.com/bug?extid=f62d3e0a4ea4f38f5326
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1152501b300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16612dcd300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f62d3e0a4ea4f38f5326@syzkaller.appspotmail.com

#syz test: git://git.kernel.dk/linux-block io_uring-5.15

-- 
Jens Axboe

