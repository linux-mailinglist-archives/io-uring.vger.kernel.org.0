Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79395222C91
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgGPUOb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgGPUOa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:14:30 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE03C061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:14:29 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j4so8374851wrp.10
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i5qz+FpeRfPY4KuNDA90ZDLLDlhF1syggHUwx/9SzpU=;
        b=gwdWu8DCNMHeOyCfK/qmQvG4bihbzuk218lD1hMT6t3NGlCMv4Vj2mByyqWNtw2VaX
         67+sTLOajVWoy1nqimJwQNaOZtuUoRoN/NvdGQbo5xK40Cw6lXOuoFVLs5p/up6T+eoX
         E0X0nkzHg81T+Bo8a8QxeTFd9oose5tlJm0GfHsoFIlN5La2784C6kjbIhJQl1hwDo8s
         l8/gK4FMBmxXmLWrFMMjwyz+y/yBhv/gHQ6h+91H18zj5dzG7xy9NPoV3vjJSOSfb8GJ
         qxttwMljQQMd/a3gciqMGJQO9TKi0NXFfFs7qG5Q6i7sUCnRG/mX/dNYYw3QqoRNwITW
         uyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i5qz+FpeRfPY4KuNDA90ZDLLDlhF1syggHUwx/9SzpU=;
        b=fIg2GDOC97dMHnsAMtKFS9kDWIUl6nbmu0S4OxLsT6eht9tM0UhQ2H36Fd+wr0cYlr
         mB8TT74NSNL1ymvtgRY7/WfEnRI6+5vJ2dlc/77jM6zVtvkJgd3DjMzF8Llu6K1X7IRC
         ma1B5UKosr31Q2DGfqX/RmMVDhO3Ht2vvQhYjMdfVYEknXZn2LjbEJ49+vC23cV4BtJq
         CIUXsdkcQpNaB2xxCdE/NpikSSKkfPVpATxeNqP11fQ28DYMupbh5ubn9QMFVx1gLO0w
         DI6pJIWFgxX9ouRGXs66dvHP0PGT4Pqr4gPFYbvrMEbrZvI/3PW78wxbySa016sp+pQ/
         LJ6Q==
X-Gm-Message-State: AOAM530WmMtAvNwSoxn2FpD7vrVEBuVOS8H10prkL4yY4rQ6v6SeYAyD
        DuAP2p+dGVPZJSvBwqYnggl15/x7
X-Google-Smtp-Source: ABdhPJySh8UM/nUIwx18tR4v9S3rVtvRNveMXncTto/Y6/AWVnD03x1PymJia2PRS4nK/6WuuWr2rw==
X-Received: by 2002:adf:f452:: with SMTP id f18mr6436024wrp.389.1594930468325;
        Thu, 16 Jul 2020 13:14:28 -0700 (PDT)
Received: from [192.168.43.238] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id k20sm9886466wmi.27.2020.07.16.13.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 13:14:27 -0700 (PDT)
Subject: Re: io_uring_setup spuriously returning ENOMEM for one user
To:     Andres Freund <andres@anarazel.de>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <20200716200543.iyrurpmcvrycekom@alap3.anarazel.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <af57a2d2-86d2-96f7-5f63-19b02d800e71@gmail.com>
Date:   Thu, 16 Jul 2020 23:12:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200716200543.iyrurpmcvrycekom@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/07/2020 23:05, Andres Freund wrote:
> Hi,
> 
> While testing the error handling of my uring using postgres branch I
> just encountered the situation that io_uring_setup() always fails with
> ENOMEN.
> 
> It only does so for the user I did the testing on and not for other
> users. During the testing a few io_uring using processes were kill -9'd
> and a few core-dumped after abort(). No io_uring using processes are
> still alive.
> 
> As the issue only happens to the one uid I suspect that
> current_user()->locked_mem got corrupted, perhaps after hitting the
> limit for real.

Any chance it's using SQPOLL mode?

> 
> Unfortunately I do not see any way to debug this without restarting. It
> seems the user wide limit isn't exported anywhere? I found
> uids_sysfs_init() while grepping around, but it seems that's just a
> leftover.
> 
> This happened on 07a56bb875afbe39dabbf6ba7b83783d166863db / 5.8rc5 +
> 16. I left the machine running for now, in case there's something that
> can be debugged while running. But I've to restart it in a bit. It took
> a while to hit this issue, unfortunately.
> 

-- 
Pavel Begunkov
