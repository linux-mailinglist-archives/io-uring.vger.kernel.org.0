Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADDA5778AC
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 00:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiGQW6x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jul 2022 18:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiGQW6w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jul 2022 18:58:52 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25FC5F4C
        for <io-uring@vger.kernel.org>; Sun, 17 Jul 2022 15:58:50 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id k19so7580416pll.5
        for <io-uring@vger.kernel.org>; Sun, 17 Jul 2022 15:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nZfKPEzrFSWnD4VyW5avsdp1T5dDlLEjwOKs9E9j9Io=;
        b=4rdc9IcZS5Y9hlo7H/x+W9QLnojcgSmuqjAZ+WYCB7jY4H+rTelSerf9HlDd2Ycr9t
         VR6sT+iF4XtEZiaA/cYg4s5pN1dpqQG7mT9OvKICcxPe8JnhjQaVaYheWTtqL1fL2uUH
         K3K0kFEe/HjPcGqKbpXPJrCNiM410PtFNEF1ixeusEB4B9LmDRi94nn4MhLBL89eG+7R
         C6QY8VJOz0bSXP8GmNl5lrS8jrFWAEbTWHOmHEBBpCzi7+daf+PFS8v+MxW55rHV6Rb8
         SeZxZrL5/vE8FlVCSPptcmxhxFta9BYGGvwiYk9SQ2Y02QpISJ5T+Yeh143KY/S4EM6O
         YnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nZfKPEzrFSWnD4VyW5avsdp1T5dDlLEjwOKs9E9j9Io=;
        b=ilLVgvRtBVJcHgcXmGgWlTW81FYa/623bw758pMaISH/djOjYz1MQGImoOSFFuGISs
         c6bay3TOwGMKNaVokYER9AB4lnCP+IRMnOkuPM7/ughJVOP3T9Dle0KkDJVh2v76awrT
         wZB9FDaiQS9vMBLkn0m0AnLr5+UfH0BNBPzEC+R/X3AhBl2YQ00lV68cpgTs3jjWRFk+
         hjL/F0iAooNZfw2e30fcV4/wzF2AqyDQKSJrQri2k5GdAhtztuEqSPg8OHl+aVko6GT8
         qKVdDDwAygyqgZ3LeP7kX+/C7iOohWTVotxmDdP0tlyNJaZ++nA/PMA/97kqTQJB0xsn
         BSng==
X-Gm-Message-State: AJIora+uVrN0VcOGhN5gicgJaNhoKq8YO5Zx4cZ22w1UHsymkTmb5U2I
        VUH+dbdBJLevzJRMCnmAnEJMCQ==
X-Google-Smtp-Source: AGRyM1tNh+v5YxjZZicTtlUmmxCaGTCHhNcXislwvxO23JXT3CWeQnrqKIR5SsH3vUWoAJ/NZGsAig==
X-Received: by 2002:a17:902:d490:b0:16b:f101:b295 with SMTP id c16-20020a170902d49000b0016bf101b295mr24686581plg.52.1658098730176;
        Sun, 17 Jul 2022 15:58:50 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s9-20020a17090a764900b001ed1444df67sm9996856pjl.6.2022.07.17.15.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 15:58:49 -0700 (PDT)
Message-ID: <a1cb7271-def9-0387-96fc-93e55f85cd1c@kernel.dk>
Date:   Sun, 17 Jul 2022 16:58:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: KASAN: use-after-free Read in io_iopoll_getevents
Content-Language: en-US
To:     mail.dipanjan.das@gmail.com, viro@zeniv.linux.org.uk,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     syzkaller@googlegroups.com
References: <CAEK-7JLEwuC8z1+Mdcc8gcZoSkL=h_3iW0aTtVvE1i3PjaR7cQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAEK-7JLEwuC8z1+Mdcc8gcZoSkL=h_3iW0aTtVvE1i3PjaR7cQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/17/22 4:55 PM, Dipanjan Das wrote:
> Hi,
> 
> We would like to report the following bug which has been found by our
> modified version of syzkaller.
> 
> ======================================================
> description: KASAN: use-after-free Read in io_iopoll_getevents
> affected file: fs/io_uring.c
> kernel version: 5.7

Unless you can trigger this in a stable release, there's nothing we can do
about it as 5.7 has been dead for a long time. No more releases of that
branch will be happening.

-- 
Jens Axboe

