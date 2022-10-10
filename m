Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965495F9E16
	for <lists+io-uring@lfdr.de>; Mon, 10 Oct 2022 13:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiJJLz1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 07:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiJJLyw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 07:54:52 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AB16431;
        Mon, 10 Oct 2022 04:54:44 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id iv17so6703545wmb.4;
        Mon, 10 Oct 2022 04:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=loHfl9E8ZeXupW1T+/lYVBoYujd6PO2i0X9CyIK6EyM=;
        b=e7woRVqKx5F7x/9gUuOBMzyOU2OuB1HCt3qfqTB9+TLoJXel6YUzFEnGnHFTIjzu+3
         gnnDSmDNGAd1y+w4D7MmFB+cLUnndmh4Lk2f2UYI5qoN8l+ML2NUxib6cDTTi7J8Wl5c
         Bp2Z++Rrq20VPapVmZ3YztFhndqdYQKU9Hpi5SI8iiE8UC4uYHenmzO8MIBXnJJM1R+T
         w9y9uvz1R76LpYZMm2spvl86WzzJChvJ65UojcD/oxOFdiaEwxhwwuQBeGGn3pOqphqx
         +WgTvs5ByoiBFqeuGDV87hkWl8mTXL2EO8le8FR9+/GEw9Uy4b+8TgdHC4E9GvH3ltDp
         FcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=loHfl9E8ZeXupW1T+/lYVBoYujd6PO2i0X9CyIK6EyM=;
        b=DTy+XFsTKgdL0hLH0HRw+MRqkRkE99nBorjbArooHQCZbrEaheKasjGlLfLiFfoZsa
         i9sGBUEgLXbFifX+livJ6GMNi0qAGjxdWVGpTNJaZ8S9xU+U6RTD5CDeZlx+J8djbHEj
         VEU9avrk+O0qvj1reDDE7s9JB81dRPAhO8CemdL5bCEdRWrxE3tRvZjY1ncKMHmfDXQ2
         Rz6J+ek3P/8O9vvlT4HGQwT4GgvzEYrbHeCYcdvXmzBfHnROCI8MZd6ZjYFmEjGni7Rv
         y/T+ghntXLBnh00ODywUaa2JDTV5vB54pCzrxixsv/4D4fnU93rHwbIUqwPnNbGT1FAh
         jOFA==
X-Gm-Message-State: ACrzQf07cNYLQPIKD+c1v8fgkPypvbJdmmREJVYvqGYGA2hMGplav9PV
        eJFibNmUVDom5yOTEjh4ppE=
X-Google-Smtp-Source: AMsMyM4CNXwLBZz/T2XKUXCPmo11XQdzTp3znypehBUFYG44Gjzkxusl/uf2Ylz3Sj6usGmyeKBUQw==
X-Received: by 2002:a7b:c048:0:b0:3b4:fb26:f0f3 with SMTP id u8-20020a7bc048000000b003b4fb26f0f3mr20258053wmc.115.1665402882702;
        Mon, 10 Oct 2022 04:54:42 -0700 (PDT)
Received: from [192.168.8.100] (94.196.221.180.threembb.co.uk. [94.196.221.180])
        by smtp.gmail.com with ESMTPSA id g20-20020a05600c4ed400b003b4ac05a8a4sm22691107wmq.27.2022.10.10.04.54.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 04:54:42 -0700 (PDT)
Message-ID: <a88a1cbd-2800-78a2-1651-ebac0736549b@gmail.com>
Date:   Mon, 10 Oct 2022 12:49:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in io_uring_show_fdinfo
To:     syzbot <syzbot+e5198737e8a2d23d958c@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000009b01b805eaa8eda8@google.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0000000000009b01b805eaa8eda8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/22 08:15, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a6afa4199d3d Merge tag 'mailbox-v6.1' of git://git.linaro...
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=10cfc3fa880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e2021a61197ebe02
> dashboard link: https://syzkaller.appspot.com/bug?extid=e5198737e8a2d23d958c
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108b448a880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a0403a880000

#syz test: https://github.com/isilence/linux.git io_uring/fdinfo_fix

-- 
Pavel Begunkov
