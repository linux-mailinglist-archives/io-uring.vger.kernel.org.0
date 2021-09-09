Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A06404364
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 04:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349126AbhIICCP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 22:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242103AbhIICCO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 22:02:14 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B2DC061757
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 19:01:06 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id j18so317044ioj.8
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 19:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Oy5A8PYrCuxEwNcqPutPFjqQJ1l+woiGv/ZNAsuFTUs=;
        b=KtW/t7Psm8GhVojYnQZpdTHgLbyANmRgGMhvw0gs3r7M3zVGG4VIgZaL/34q1JCYKZ
         7L5g8GsjOvXLJgOX2fbnzBVlzw7az5UDm+OJbSlsKg07QkLEijvIQ5oYUOrQ7wwCvHU5
         otYoBW1ajlhlYS9uTuXWUILCBGuIggjOPxlNzjoU+gE2TBNpFsodEMZZW1wfywRtlfst
         fj+9r+dC4O3pRt7Nuly6o42Q0t/tWYPpGbOD7czjmSkRecLchMzD2MJxhL9/EP6nReyp
         oQcAlbIM+exF7Ki5XpOOUv9XQrHcT0iAdX3+SpXVB/iJRLygft/45+cuSVdrE3hy+wXD
         pGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Oy5A8PYrCuxEwNcqPutPFjqQJ1l+woiGv/ZNAsuFTUs=;
        b=G2qRXBfn9EVls/14xf9OAtHZWBfvI1rD1j/Db0KMFQ1vHQ9/MepZtAqv9vauTkuKZ6
         KUtE7Ohkv3enbU4SmqDueuJnzS/Bd2IRx9Tcl/nBP7x2gcI8yRmpaYe5JuZ/6i6Okbw2
         wNUm4gCCKxri6EKItcMEnhgBuKJxOKGOcAq+/0J1PQIaMDnQAB1eTrrEJzaQolU1+oTZ
         bBWnSvpxFqSy5PNItWlKaNtcU+yCYotXZM1N4WWsBqYoKgqfPNqfLR1kxZf7x096fkgk
         HsA2ixsVAztQ/xw9pXOduM0LhPC3BxlCet59nsD4cTYYGF7FvMeVWAK/32y+8FVu7V7R
         6kaw==
X-Gm-Message-State: AOAM533Jm6bh1gGMqHm3WOR2YAEweMk6xflLiMa0BuU30sMbaQOzN+Ho
        MVlAgID/HLRNlRYwhY2cXHqdOdZVSJYaug==
X-Google-Smtp-Source: ABdhPJz+3VWsj6qLUOS0nV44i7XfUESePxiXfH1wiihdYFoek28nTz7qLML/xJRaJXTdEucfVGnMFw==
X-Received: by 2002:a05:6602:2ac7:: with SMTP id m7mr528771iov.66.1631152865415;
        Wed, 08 Sep 2021 19:01:05 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id t11sm202551ilf.16.2021.09.08.19.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 19:01:04 -0700 (PDT)
Subject: Re: [syzbot] possible deadlock in io_uring_register
To:     syzbot <syzbot+97fa56483f69d677969f@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000868f9305cb84d318@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9774a34b-93af-5b09-8ad0-fec289d31428@kernel.dk>
Date:   Wed, 8 Sep 2021 20:01:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000868f9305cb84d318@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 6:10 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ac08b1c68d1b Merge tag 'pci-v5.15-changes' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=177842dd300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dc596ab8008badc2
> dashboard link: https://syzkaller.appspot.com/bug?extid=97fa56483f69d677969f
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Pushed out a fix for this one.

-- 
Jens Axboe

