Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6461015AE75
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 18:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgBLRLZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 12:11:25 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:41241 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbgBLRLZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Feb 2020 12:11:25 -0500
Received: by mail-pf1-f176.google.com with SMTP id j9so1536815pfa.8
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2020 09:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=el4TyD0vmJurHsbqt4foeYLdv20V6DBSG2FAZM7b/kI=;
        b=BFJ5Nn05uX/rr9RDCcao3IwPXmDanoQhJ9uIu5FWRBWcHBwug5j1K1Z7B3VaFHJ2pR
         am7UxrqhHcH5OFv+28OJSqw9IEliNLzbQS7ulwKBOCk1EPqrnj+Z1BJFeM7pVqlriLxN
         fRKMwsdXFjqpZf/4LnLv/OReD5i2teWIZBAGNvlCGymRRFjjemquDNfzFYGUZQiSHLKh
         96SqQGtfOr8lnt+adJqjkjNJfSzsl0Sim2RGlmDbvoxGlj/KrrU21MQ8XX2qJftsHl88
         FonFIxl8ExrZqqkcshu2ARqF4WXyysbe7N22VXsG2yb7D3F9+XsYnasAaWC6HiFIMPvJ
         +TmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=el4TyD0vmJurHsbqt4foeYLdv20V6DBSG2FAZM7b/kI=;
        b=DWy5DOwBkYyd68sSJYhGuLKfGPlVDhqAotsGI7eURDV6X0XnPeqM+3tWvCue6aGWt3
         6q+0Mjh5anpKoOzGC+facULh+Dzk7pZVfH6yqBEgn8ZTCrq3oMCrR+DO5Fqg/p8ShFkY
         kDnvFFWrhuJrCTo7lXtC+L56I3AmweufUg+ZE0D7QnonaKnhVIdKqB/PCCcrMYqN+1K3
         HpchJ7J5zRufYB5E8XKl5eMD53yUeOcdr6cgJZnG9wFh4GhjmBSgRHiInVImXmzN+21E
         C/GgNpORk6u6S9oHj3oVPEwxxopdfwIwp5h8aju7DWcwOceqBq15MrQ26S9/wr4OX3yl
         MWqg==
X-Gm-Message-State: APjAAAUugmRE+xDNDUwnhXq0nj/NQFK2fJBcY0pzBXjJMYLQ4Ya+qhQu
        lCJl8gv7YT26davjsAnKFvXwqvI18PE=
X-Google-Smtp-Source: APXvYqyWLo00DFTA0g8AHFnskW8gKENqix+gqTcvKsck8BT+rmq67MFHPTlMtlGLiTTbR7aGUInt+Q==
X-Received: by 2002:a65:5242:: with SMTP id q2mr13069524pgp.74.1581527482895;
        Wed, 12 Feb 2020 09:11:22 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1018? ([2620:10d:c090:180::78ef])
        by smtp.gmail.com with ESMTPSA id 13sm1519394pfj.68.2020.02.12.09.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 09:11:22 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
Date:   Wed, 12 Feb 2020 10:11:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/20 9:31 AM, Carter Li 李通洲 wrote:
> Hi everyone,
> 
> IOSQE_IO_LINK seems to have very high cost, even greater then io_uring_enter syscall.
> 
> Test code attached below. The program completes after getting 100000000 cqes.
> 
> $ gcc test.c -luring -o test0 -g -O3 -DUSE_LINK=0
> $ time ./test0
> USE_LINK: 0, count: 100000000, submit_count: 1562500
> 0.99user 9.99system 0:11.02elapsed 99%CPU (0avgtext+0avgdata 1608maxresident)k
> 0inputs+0outputs (0major+72minor)pagefaults 0swaps
> 
> $ gcc test.c -luring -o test1 -g -O3 -DUSE_LINK=1
> $ time ./test1
> USE_LINK: 1, count: 100000110, submit_count: 799584
> 0.83user 19.21system 0:20.90elapsed 95%CPU (0avgtext+0avgdata 1632maxresident)k
> 0inputs+0outputs (0major+72minor)pagefaults 0swaps
> 
> As you can see, the `-DUSE_LINK=1` version emits only about half io_uring_submit calls
> of the other version, but takes twice as long. That makes IOSQE_IO_LINK almost useless,
> please have a check.

The nop isn't really a good test case, as it doesn't contain any smarts
in terms of executing a link fast. So it doesn't say a whole lot outside
of "we could make nop links faster", which is also kind of pointless.

"Normal" commands will work better. Where the link is really a win is if
the first request needs to go async to complete. For that case, the
next link can execute directly from that context. This saves an async
punt for the common case.

-- 
Jens Axboe

