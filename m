Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80ABC5278E3
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 19:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbiEORXE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 13:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiEORXE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 13:23:04 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0864513CFE
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 10:23:00 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l11so12051525pgt.13
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 10:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=lako1s90iv7mGjeeXnoRjSCjYy4a0LZsCpdiegVx6o0=;
        b=oRXqB9iM8/RGMZ9TRhj5Va0gAsNpHnuF65cKqV3IbwSX5JE7s0wCO3vS1junFZr9nl
         e1q1LaABzhGX7TvEKjv5frIOX1Zj8qLMOKQOgl2qRPaHZjeEcBlVk2BeDKrIoEgYdMqN
         fJgudEGgG7FFLNxNgShP5dmvwKdi8LSVoy/uN/HNCwFMUJh70ZKKZMCjAz1Cmgh8m7kJ
         e5fh1E/D8emfury5MxoBvr/s8F2n5pzTV0kjZq6a92lce/6v2/yBclYU8GiYq93h/uz7
         Ta98UHfUVBYeHT87HvSnPcHFRdUyFTxvbhiburWEcjSxW/djHNgVeqTwDQtLH263Qhm1
         VUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lako1s90iv7mGjeeXnoRjSCjYy4a0LZsCpdiegVx6o0=;
        b=uVRQ2ISAEtCZbG3ww5tkm7pLBwMGWL+Qrmd30UzTc0E0HxnjJsiJq4eJXZM5phYe/1
         EWR0pdLTIhXjxRXNuSxQCyDK+DyUucFOTRPs0cSDNV7c1VQF+qObQrx4vXDKTit1NVgd
         0qGruRpncltLxKHQLHhugZ74aIb+gSoXaIpdV3iFwonehU/fE79KWDyW95xguQPfcDJU
         sYtlVaLQ4B83Y1NURJ/kK14vkOMBPepHsuYwD6RTxa3G1rixuXYtuPuZBT9FhPZKcuKp
         k5/6Td70djXI/GgzMS7rx4GY8NZey9iJL1cC+V/y16kv2k71bmv//6zmXXspj5ZFerWi
         GcvQ==
X-Gm-Message-State: AOAM533rFL0E4dYmkFoGgdfECL2k4wgDqezHSh9H/n9961XPkGD3p2hp
        gTc6m+pUU8KhTcwp4mAYJVDlMQ==
X-Google-Smtp-Source: ABdhPJzzuElGI25UpjDd2J/j3a61E8jxQDdCFJaJT8lh08LSFFpUmI0GsPa2xef0CDBDPMcb7vG9fA==
X-Received: by 2002:a05:6a00:150d:b0:510:3a9c:3eed with SMTP id q13-20020a056a00150d00b005103a9c3eedmr14049388pfu.86.1652635379452;
        Sun, 15 May 2022 10:22:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902bf4a00b0015e8d4eb26csm5344971pls.182.2022.05.15.10.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 May 2022 10:22:58 -0700 (PDT)
Message-ID: <de26ea1c-c263-0418-ba79-e9dfa85a3abd@kernel.dk>
Date:   Sun, 15 May 2022 11:22:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [syzbot] WARNING: still has locks held in io_ring_submit_lock
Content-Language: en-US
To:     syzbot <syzbot+987d7bb19195ae45208c@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, f.fainelli@gmail.com,
        io-uring@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, olteanv@gmail.com,
        syzkaller-bugs@googlegroups.com, xiam0nd.tong@gmail.com
References: <0000000000001c058f05df0e0eea@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000001c058f05df0e0eea@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/15/22 8:52 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1e1b28b936ae Add linux-next specific files for 20220513
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=10872211f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e4eb3c0c4b289571
> dashboard link: https://syzkaller.appspot.com/bug?extid=987d7bb19195ae45208c
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1141bd21f00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167ebdbef00000
> 
> The issue was bisected to:
> 
> commit 6da69b1da130e7d96766042750cd9f902e890eba
> Author: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> Date:   Mon Mar 28 03:24:31 2022 +0000
> 
>     net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator

That looks totally unrelated...

#syz test: git://git.kernel.dk/linux-block.git for-next

-- 
Jens Axboe

