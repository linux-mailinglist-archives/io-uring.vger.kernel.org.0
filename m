Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDA64404DB
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 23:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhJ2VYD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 17:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhJ2VYC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 17:24:02 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32A2C061570;
        Fri, 29 Oct 2021 14:21:33 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o14so18565816wra.12;
        Fri, 29 Oct 2021 14:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=NiK7SwHxTnmnFF3x7Tss+IEdA+ZkPxnv1m3o6b+JWVw=;
        b=G4WPO5OAOn+LYA/zYW/Prt6LaSXj44Y1dvqC91n0ee17yPDw3HiuPGymqqClNnuC2E
         9tyESFakTuKtQl+fn2Tzs6OVL2YfZFVgM4jSKUQoMNzGeRzgkK8tiLs0HXEja0OPewpu
         hvkyAoQbbJuUG9JBFIZWPIqfGAiGwPXjBJ4yTb1PYs7vyRY8cXCOapBkAAvReQhvukNd
         W7UNXl+FzoD9PYwI8GFd8EloZwCIqSiXGDbUGmhkb4QBvRW/+pOeIS2ndmc0KrNAlIeq
         9ZMaM+lViRibw+Cs82WC7vA0mnLxIT69Ufpiq4NwlXbVD5AFzpp6tPsmZqL5LNdwOPBM
         ryqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NiK7SwHxTnmnFF3x7Tss+IEdA+ZkPxnv1m3o6b+JWVw=;
        b=5hkK+PGqRXi1mptFUuiRrOZ8Uq3E/RRjLwV+Sg9OqEgGCiND6QV+YQuidkMvNCFk3n
         KbuaPc0RaClHYkEGCKbFNMXjPDAdNt6KwCB7//CW/W2kezylLbGJw/ANzuYXhr48gfv6
         LsErdVFPEDY10xehRv7dl8aK3ZNVwvTqw2vnUXhw0P1iQFpikk685yoDXrlJcSHhbXmq
         zHE05nZw2TnRhmtYDVEBhNHdX/b267J5L+Was/ckekPOUnat4ziwUd3e7wn7kAiySq86
         rBgskLJFovwBZMJWC4ejx6H7goexCurYmri+ZjFziIps2HlDgyZuZI+gPF1jzbve0yCA
         yWKg==
X-Gm-Message-State: AOAM5338OxNfuKzbSjvLn9psqelWRg4eCnHBUF2Lnduu9DqWKEPJo2SO
        hj0fpm1AVr3sCU7go+R+kW8=
X-Google-Smtp-Source: ABdhPJxpTjYCFrGJA9JYhtIdnjNeuD/GIrhMKYTAepyvahRY8ck6qp6Ni3P88yg44LPKNNtiTeC3Tg==
X-Received: by 2002:a1c:e911:: with SMTP id q17mr21870719wmc.174.1635542492272;
        Fri, 29 Oct 2021 14:21:32 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.16])
        by smtp.gmail.com with ESMTPSA id o1sm6734502wru.91.2021.10.29.14.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 14:21:31 -0700 (PDT)
Message-ID: <cebb75d5-076d-0b05-6c37-b880accc320e@gmail.com>
Date:   Fri, 29 Oct 2021 22:20:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] KASAN: use-after-free Write in __io_free_req
Content-Language: en-US
To:     syzbot <syzbot+78b76ebc91042904f34e@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000abd1dc05cf8447ee@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000abd1dc05cf8447ee@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/29/21 22:12, syzbot wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:
> 
> failed to checkout kernel repo git://git.kernel.dk/linux-block on commit 3ecd20a9c77c632a5afe4e134781e1629936adab: failed to run ["git" "checkout" "3ecd20a9c77c632a5afe4e134781e1629936adab"]: exit status 128
> fatal: reference is not a tree: 3ecd20a9c77c632a5afe4e134781e1629936adab

#syz test: https://github.com/isilence/linux.git syz-test-iofree


> 
> Tested on:
> 
> commit:         [unknown
> git tree:       git://git.kernel.dk/linux-block 3ecd20a9c77c632a5afe4e134781e1629936adab
> dashboard link: https://syzkaller.appspot.com/bug?extid=78b76ebc91042904f34e
> compiler:
> 

-- 
Pavel Begunkov
