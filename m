Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAA452AAF6
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 20:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347910AbiEQSeF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 14:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347597AbiEQSeF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 14:34:05 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647E73DA6C
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 11:34:03 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id m6so20233363iob.4
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 11:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=+4eO+6dsz/WjJ3Ziz2RakmC3CRqePaTzJgHcVdw/yuA=;
        b=T/UuAwa9f6bwKJmONQbjyNo5Hb7Fp9P0zXqLJje0MYM9+5aaIiZoQSIHy/gPOeLk+5
         PUVq6z4bgcWhq7mK6xzFGHj7E7r2/sLw+5+LnBiE3v+uoUvco1h7RGvyoNg4z2ZIDMi+
         J4YHwSUbg47cRabbEzljDvBjlS287TWAsu2qjSojdSk/Z+t5SWNh4fdzyvYoa6lxd6fG
         gw1g651qXiIblfAzmnZQU0uL0Un6awAgrjZwoJX6QKZ5zJCbDL8IuIqAOGBDf5hRaCiT
         w7KcIQeUDv8axGmEzgogeVw4M1XLWII18COO3ZL3qcLmSPgNhMXZP5NxAYlUaa7+k9xi
         sw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+4eO+6dsz/WjJ3Ziz2RakmC3CRqePaTzJgHcVdw/yuA=;
        b=wrUKWNBqqjHcJnleMCbiQWwnSRbcJ5fbFKP+ZqC9zZr3/YwdRwPHohitIKoKJ+AZ9y
         Fb3a/PfRSb5H60M2mrAzXZX6eTTuGjL4jtVybIkxn67O1eTDKeJhy3pF8remkUf4skPL
         rqBBkTRYDXBKXXgU+Y7+4WrvSYPDQ0yM5l8gBcwlW97bLddY5EuL//wJvOTC7y/kYNyE
         LxQy7YmLMeOqa0QSvm6Y8lXz0QhxNKzlGeW3G1GiXTQT/roN9GvKuvP2BiSsWA98AS1T
         PDq+BAJBcRDJWkxCn/BnQcOsKNkImQti7a5X4h81mjun264IjXmTM/yYc9vmqMJNaN5V
         l8LQ==
X-Gm-Message-State: AOAM533yXNxRJm6HHbvaCiuTYvCnj/iCPd45IlChOESPkT53eRF2SnXZ
        yw+6aC6h8UcVg1qjwD1cdjs1MQ==
X-Google-Smtp-Source: ABdhPJzBW4iVMCeI6E+uwI5T5nFEuqU2cNQ6snGSVakcyzU6iKhhwGbkQeHi2Qo7cEVby0yYvmHrhg==
X-Received: by 2002:a05:6638:134d:b0:32b:af0d:f49 with SMTP id u13-20020a056638134d00b0032baf0d0f49mr12992488jad.249.1652812442760;
        Tue, 17 May 2022 11:34:02 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y14-20020a92950e000000b002cde6e352c1sm13833ilh.11.2022.05.17.11.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 11:34:01 -0700 (PDT)
Message-ID: <8cf1ef4e-03b6-4da2-530f-65058c57a9d1@kernel.dk>
Date:   Tue, 17 May 2022 12:34:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in
 io_do_iopoll
Content-Language: en-US
To:     syzbot <syzbot+1a0a53300ce782f8b3ad@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000093a60105df3918eb@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000093a60105df3918eb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 12:13 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    42226c989789 Linux 5.18-rc7
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=125b807ef00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=902c5209311d387c
> dashboard link: https://syzkaller.appspot.com/bug?extid=1a0a53300ce782f8b3ad
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149eb59ef00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17cc57c6f00000
> 
> The issue was bisected to:
> 
> commit 3f1d52abf098c85b177b8c6f5b310e8347d1bc42
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue Mar 29 16:43:56 2022 +0000
> 
>     io_uring: defer msg-ring file validity check until command issue

#syz test git://git.kernel.dk/linux-block io_uring-5.18

-- 
Jens Axboe

