Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B634082F8
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 04:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbhIMCwM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 22:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbhIMCwL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 22:52:11 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F80CC061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 19:50:56 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id j18so10188093ioj.8
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 19:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ThbAI+5YxnpFJqe1M2jD1J1Y+Fa7E6ZmvkAniQmhAF4=;
        b=orpszyoX6g9Oi0URBnBo3drRbJgLY5TFQZyavsbeJFe0o41NI6vmBtSAMpTwS2fSOA
         GYcj2Vzy7kQvMSB0j3X0rBdlGnsHW1e9KhEOW6hMMnJKSOrHh87AFrcL4EBcOPfzLLZp
         Wwf1tHH49RSWxd6i9jU4b0LG/eYU7v7VwxY64Rcsj73dSWl59IOJS1obI2RIla5wKEkW
         xyFNi3E/jWbOuRE/3hYA5bakI4GSnXXeyQjMglm8Kk2TwrzG6R2h+/haytE2PqXR6JI1
         6cW6tZaHPPLqg6vpXOSAX+dYZ/oR81W/rwDyY/0PLpkb95PN+KqW/Nv6w/NKHfePrlBL
         ePDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ThbAI+5YxnpFJqe1M2jD1J1Y+Fa7E6ZmvkAniQmhAF4=;
        b=AzmKO2C372ORO/h/EB1WOnLNYwPnxDtQ0Wzw7QIYS6LbekXpv6SpNWxQElVq5trAIn
         zgREAS9TrCeQecBjmK9Kjmz0IOsLwZybxMPN7Gq4epkalRvByvvDtROnxBFf/SIAWJjs
         hoC0c7BXLdcks0RCJWLBK9SB+qooIqCjJ7AjfYF9lPk/T9pcb7RZdybPI/hKpsyN5oIa
         6Z8xB8cVCOUopkCJQ4Us0MjlL9GZHGRp449QcTVut8NKpbVm7RZPiwsaHe38MmjeRcyc
         1pSiHzSG12A5y+WE5pQFLLWCpsL+v3lciXQBw9Dqwf1Jt4+yyZ3oWQpG0txNX25NXEtC
         Q9wQ==
X-Gm-Message-State: AOAM530h6uWMKavst/cd87974cE+4waSu8iLu/s29bHrlqe294XFtFlY
        mK7NC+xLW2QOyvuQa593+Qm4wDJNz/FMFg==
X-Google-Smtp-Source: ABdhPJxs4WWwYVZefB5LmjszWdfcnUu77zRi+S4z4+69IvnpCKCE45e2adAOhZdMHUkfk6RkKW45qg==
X-Received: by 2002:a5d:9247:: with SMTP id e7mr7280591iol.161.1631501456083;
        Sun, 12 Sep 2021 19:50:56 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a16sm3958547ili.64.2021.09.12.19.50.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 19:50:55 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_cancel_generic
To:     Hao Sun <sunhao.th@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CACkBjsbs2tahJMC_TBZhQUBQiFYhLo-CW+kyzNxyUqgs5NCaXA@mail.gmail.com>
 <df072429-3f45-4d9d-c81d-73174aaf2e7d@kernel.dk>
 <e5ac817b-bc96-bea6-aadb-89d3c201446d@gmail.com>
 <CACkBjsZLyNbMwyoZc8T9ggq+R6-0aBFPCRB54jzAOF8f2QCH0Q@mail.gmail.com>
 <CACkBjsaGTkxsrBW+HNsgR0Pj7kbbrK-F5E4hp3CJJjYf3ASimQ@mail.gmail.com>
 <ce4db530-3e7c-1a90-f271-42d471b098ed@gmail.com>
 <CACkBjsYvCPQ2PpryOT5rHNTg5AuFpzOYip4UNjh40HwW2+XbsA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9b5d8c00-0191-895b-0556-2f8167ab52bd@kernel.dk>
Date:   Sun, 12 Sep 2021 20:50:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsYvCPQ2PpryOT5rHNTg5AuFpzOYip4UNjh40HwW2+XbsA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/21 8:26 PM, Hao Sun wrote:
> Hi
> 
> Healer found a C reproducer for this crash ("INFO: task hung in
> io_ring_exit_work").
> 
> HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases

Does this reproduce on 5.15-rc1? We had a few hang cases fixed for io-wq
since that commit 6 days ago.

-- 
Jens Axboe

