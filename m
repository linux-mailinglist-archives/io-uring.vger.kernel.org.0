Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8214E4E593C
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 20:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344296AbiCWTib (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 15:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiCWTia (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 15:38:30 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076B98B6C1;
        Wed, 23 Mar 2022 12:36:59 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id d10so4907928eje.10;
        Wed, 23 Mar 2022 12:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=v4SH+Lnf5SOPs0r5kh/xVjZFopX+qmTF8utTxWxSajc=;
        b=PBJvJUdAngAOoJzuadgfA7J9DAH9ZJ1gCvoxXlYvP3GC5/9AKsXE5VGBcoqVfhL5rE
         3XutA6WhLX2qBA0Tx2vgPkLTLRAxf6sthyBMaCk8DZcxdo8ylqbHlq1CurNBDGd4QM0/
         gaHh78FP3hz7equcogGaQ2SqcoFD4jgA3ZnIzKDrEy6OinauaDjTU3hS8nZxBMzCPqmX
         bxQB2cdb0BQTIGUTvbv4vBWc/+t2kueeZzQEFAaSllPlEwlDb9J3PzPxZJHRF+QVJvvM
         8q4vi3RjMDd9mLFcZQ1vNeYIawWOdqZD8QIIAjWMm8vh+lHweJgywfV94s9Pm0jXqURk
         sRuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v4SH+Lnf5SOPs0r5kh/xVjZFopX+qmTF8utTxWxSajc=;
        b=cvgQFXqgtVEtsnu2dgVQbtCeR7lxCbmnpBo6He/hJa4PV7Ac9OqZ++/fFlQjgkyzDu
         ciKdpjYSQxFX8GBgRorLA1EwDzTkXsjQIxBZLy1NYgKMPSKf+6KDLO4bpTUfwqJb5LyI
         sKFhXmKqN9poHZSXxNXeyHYQHZmWlpbODKtUMg4gPZvdaEUj9tKyJmC2Tb7JXwPcUx4P
         ea24lefyOh5AJDWLKEesPSfj9KJV0CkDyo1FOditlvEE1ai9MN394YukI509an7iDrtw
         6aLhhPC8xadOnqtTRkRybRkVIImqUGRhTT3vcN+TW+R5Rvx6q5k6i27RCKgEPxyiZwZr
         6nHQ==
X-Gm-Message-State: AOAM530YuZOlWkYdoIXIx8UN+Qqyxg9dM+BnL3K9lfzKPrUu6Un4U2dy
        xJ2fR8egSs5WttdIZ+b4BjpqpsRQbIgt2w==
X-Google-Smtp-Source: ABdhPJyTHjqwMW6OVmfN6EPu7c17Mx9FZdOjAuhWEI7wpbouJBkWm4bcbrms2s2raVkf0mDn5+QCRg==
X-Received: by 2002:a17:907:2a53:b0:6ce:e4fe:3f92 with SMTP id fe19-20020a1709072a5300b006cee4fe3f92mr1787806ejc.389.1648064217514;
        Wed, 23 Mar 2022 12:36:57 -0700 (PDT)
Received: from [192.168.1.114] ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id n2-20020a17090673c200b006db8ec59b30sm279343ejl.136.2022.03.23.12.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 12:36:56 -0700 (PDT)
Message-ID: <fa4d06d8-ac33-07b3-de75-3e7512f0e41e@gmail.com>
Date:   Wed, 23 Mar 2022 19:35:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [syzbot] general protection fault in io_kill_timeouts
Content-Language: en-US
To:     syzbot <syzbot+f252f28df734e8521387@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000066cd8205dae72838@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <00000000000066cd8205dae72838@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/22 18:47, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit c9be622494c012d56c71e00cb90be841820c3e34
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Mon Mar 21 22:02:20 2022 +0000
> 
>      io_uring: remove extra ifs around io_commit_cqring

Already found and fixed something pretty similar

#syz test: git://git.kernel.dk/linux-block for-5.18/io_uring


> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a04739700000
> start commit:   b61581ae229d Add linux-next specific files for 20220323
> git tree:       linux-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17a04739700000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13a04739700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=def28433baf109ed
> dashboard link: https://syzkaller.appspot.com/bug?extid=f252f28df734e8521387
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117d3a43700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15538925700000
> 
> Reported-by: syzbot+f252f28df734e8521387@syzkaller.appspotmail.com
> Fixes: c9be622494c0 ("io_uring: remove extra ifs around io_commit_cqring")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

-- 
Pavel Begunkov
