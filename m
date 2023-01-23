Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A76677DC7
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjAWOQc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbjAWOQc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:16:32 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3924D279B1
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:16:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id 88so196868pjo.3
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jP1b55ki+STn0s6xh8gZR/iPcnLxk3LVkuJyMpHsjHY=;
        b=2EXt2dKJQfDDZ5KLn9ti25dsk2K3z7BoGO9aFN5ywV3yMvlb5iH2Qi9Et3rDuJUkOT
         zlmL2X1FDcCbrxG5ZOAOKpbfad3hDv6K3CwRExpXmx7NtaIhmZY3srQiTMddlwtf3yWt
         FVBdS9EDDADXBzssdG5OEB+JEP6vEMMgKo3rTprPRYc0woziacNaEvM2XH8DSQdCvt5j
         9/y8RGPdRTEqFRI2+J2HdExN4zkv9aElNA+07eOygvA+bQnBCC4lCTmNU+1jXtpUZLnz
         vJjRU+HzOI6g/XlAJHxuQUwascIHaIPdUR5Ufp4PVZwt5s11bcERjs4oH4gHMRyqKBok
         1ttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jP1b55ki+STn0s6xh8gZR/iPcnLxk3LVkuJyMpHsjHY=;
        b=C+9NAQ5BnPiyE2by9IveYTTeEbuYWANbOTbtcsEHewT9FdT0Fzs6Ufszd7siCKDd6j
         MNneqZpvgZVvAlA+3cRl5n/NxS4DvWViKEFMnFDO7Yv3/lReHDOQ0x9SlkCT3W6UmXBa
         VrmWGjlOZrH80S4tdpcnat6MRxpU6g30CuVA1HEv/hf7uHwtWUjgCnw/CO6eagQ1fP7K
         g1mLRljyE95U2a7WnXen2ZyYFDBoBcepd7zd8yO5G4Vzo57V791NGnyUG0VuxChGKbSA
         Y4PffYKme2DexJCy3nv2mzs29c7KSJzitk3RwEXmrYwVfhxPfyv6CCZ0jRVbSXKP78e4
         QJCA==
X-Gm-Message-State: AFqh2kplNz0q19yzvEzBNlCPuTrE/uw2MkmNdSuTcar31+BWFoRl2gJk
        vgc7SUVLAxk/flTlMAlQsMXR6vBM2aixFMJk
X-Google-Smtp-Source: AMrXdXv3yfVBJr008KwGfMb4IrHInNrkgbokM3hyM5BKI3cxz2BttrRhDW9Xyg7TWQhAUfsxT2eBjg==
X-Received: by 2002:a17:90b:710:b0:229:d7f1:9e2b with SMTP id s16-20020a17090b071000b00229d7f19e2bmr4230001pjz.3.1674483387667;
        Mon, 23 Jan 2023 06:16:27 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090a024c00b00228f45d589fsm6570644pje.29.2023.01.23.06.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 06:16:27 -0800 (PST)
Message-ID: <9ba8e211-9264-11db-5991-7fc733c559cf@kernel.dk>
Date:   Mon, 23 Jan 2023 07:16:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [syzbot] WARNING in io_get_cqe_overflow
Content-Language: en-US
To:     syzbot <syzbot+200ab9a0f030458682a9@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000000b45a105f2e781db@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000000b45a105f2e781db@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/22/23 10:16 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    edb2f0dc90f2 Merge branch 'for-next/core' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=11cb0589480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a1c301efa2b11613
> dashboard link: https://syzkaller.appspot.com/bug?extid=200ab9a0f030458682a9
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
> 
> Unfortunately, I don't have any reproducer for this issue yet.

#syz fix: io_uring/msg_ring: fix missing lock on overflow for IOPOLL

-- 
Jens Axboe


