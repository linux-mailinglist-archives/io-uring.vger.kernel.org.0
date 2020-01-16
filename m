Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C609E13DEC2
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2020 16:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgAPP3J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 10:29:09 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:44454 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgAPP3J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 10:29:09 -0500
Received: by mail-io1-f65.google.com with SMTP id b10so22174057iof.11
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 07:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JJcFvW8HJdilHnnCk22v1SBtvRGSSS8XKcSjVtOnrIo=;
        b=0s0D+UFaDYK6xrnqFY4RWZ85Cw7sAB42ZD2xHfNT4EsZ8JKtak1k8ZZJkGlzDu2xjs
         vtiRoN3kZV35k2FNoji6lV3M3AXln6xx0pK6i1QWFcPPwk1zFP66wOQBx2kK/zDvHhqP
         wJKpoeJBgZaKuLE3NQoKBI0Nk21N+Yda0ZXBE+ftxkdvzkhdDxnsYvHDhVcVMtfwf80A
         SEMW5nm1fVcomadiPkmyRAoAMT58nuqIKsSvI7sj6dzPm7wkj89fWecNSQETVuwX1Psw
         NH6k2NcvHyJJsBxf2A49ORcsV5O0eI1qiKcVaQUi+E8RIdKbSMzTsZWgLuZfgE4h8HjD
         EV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JJcFvW8HJdilHnnCk22v1SBtvRGSSS8XKcSjVtOnrIo=;
        b=BIT3UDvjFLRshxERWhShdvc1IjSlroWv4IzgT4pHoVkwpmqD76lc8nZi6RtVjxTu17
         YJIlWV7Rna0WO3I4AmzDOTcCn0YPXxPmAQtjF5OWFP3Na5u7yrZhJtYDkbkxjb+djeC7
         2COOzGFAyjXI/0myMvfwFe4hmPIzIcXu3sWuEUhW8qZidgn3Lz9bcMTdftcAxcbZ75Ou
         UDTO7by59afvjHS44+TOOecVfxS1SOHM/r3janiVGr43AjtQFkS+mZfayMAB5fbOPuQL
         HRopG4vsljLe0NbT3HD8AnK2cHyNyvPXXlMmri5ykQBB77Ph3mXeg1icrto+5N1ceDyO
         z7xA==
X-Gm-Message-State: APjAAAWBIk4itt3nPDcty0qmrhEONrHhyvZiEiumI4+hac1GbYaB3I3Y
        2U885YI07QY0fmVtwSbpz/WxsQ==
X-Google-Smtp-Source: APXvYqyq+mjlgPuHivk2+TNQ161jCn6GCai4KGnDmwom0xMohe+U1BAqMlNQy9ae2riH2dgDMe5KUQ==
X-Received: by 2002:a02:8587:: with SMTP id d7mr28917545jai.39.1579188548882;
        Thu, 16 Jan 2020 07:29:08 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b7sm2870279ioq.39.2020.01.16.07.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 07:29:08 -0800 (PST)
Subject: Re: [PATCH] io_uring: wakeup threads waiting for EPOLLOUT events
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20200116134946.184711-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2d2dda92-3c50-ee62-5ffe-0589d4c8fc0d@kernel.dk>
Date:   Thu, 16 Jan 2020 08:29:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200116134946.184711-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/20 6:49 AM, Stefano Garzarella wrote:
> io_uring_poll() sets EPOLLOUT flag if there is space in the
> SQ ring, then we should wakeup threads waiting for EPOLLOUT
> events when we expose the new SQ head to the userspace.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> 
> Do you think is better to change the name of 'cq_wait' and 'cq_fasync'?

I honestly think it'd be better to have separate waits for in/out poll,
the below patch will introduce some unfortunate cacheline traffic
between the submitter and completer side.

-- 
Jens Axboe

