Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C006A1E9A51
	for <lists+io-uring@lfdr.de>; Sun, 31 May 2020 22:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgEaUTz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 May 2020 16:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgEaUTz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 May 2020 16:19:55 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAF1C061A0E
        for <io-uring@vger.kernel.org>; Sun, 31 May 2020 13:19:54 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o6so2538667pgh.2
        for <io-uring@vger.kernel.org>; Sun, 31 May 2020 13:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WXpkexEydca2ydTytfOH62A1hOXqS8U6kVnts+vbTFE=;
        b=jthtBQq7Iq8MllOWe8aaY4DHaY5Ih3+TDcbD8nEOn9sg1atK45zkM65gAWLr7r3aqs
         3ei/WxdhOa7jaLuJ2xccgaEGlhdFzhekGqk351Y5Dqw5wLGIeLNzZMm4bVfnc9f0hFte
         gJya0R4vtopxant4RRAGRJUzCsk80O6mAKB0nkBGOWPq8ZnsCb1UJ0RFRkApGM1St+IX
         MJFTCr1ECjT0T7/Su/80Z3jZe6LyLNl4scCo0Hj+AvN4c/EN/Ct11J021vNzvOYvpXDc
         iJjsodudbsiP9Zrj7ZIXb/83+SVIfebjRCnb/4jryBsC1y5ecwBDNhUJw5brucfJhZgT
         MKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WXpkexEydca2ydTytfOH62A1hOXqS8U6kVnts+vbTFE=;
        b=Qi0mmOHH8j1DNvfu2KDMj5Ki0pSmq2xyRSOQzX42to66ESMn+aXprUv8zgGRz2Iw5f
         S4AIexZsdqCZCt5DZ7Laj7sgVu+RjwAe8pLdljzY+AJ+EjBUP6G7LzWN19kRtMSXJr9+
         MIHEBIQGzx1eL+sNxHAeMsGJ/vJ+9s9s+20gQveN4e+tHU9r3qw+vJ0HMWsfvmKO2R8h
         Zme5b1Uc+ZVDrGhdry+p4ug7GXPvq6rwtzysNxPHTyFfhMtvh7eiSrC5qneANrQ080P6
         7fNlTanA78b96r23IkfhQw/gD2UlolKcAJ5cS0sS9MSWx5TpmIHix6uOmAhCuBmoNmPK
         BSwA==
X-Gm-Message-State: AOAM531KSKMTcZjhU0X24+v+/Xn3Ow631HA+Eqyl6bJqT1sdq9XU0/6T
        uAwo1ep4RbQT5msFFUp1HjbTYqe/dD1Bjw==
X-Google-Smtp-Source: ABdhPJzDLsa0mClAQGVlzCqCXxYfi3eS6GI/gmjXj36jkBpVzNhaLyk8n904lEga5GAdTE8Hi1PhzA==
X-Received: by 2002:a63:5d62:: with SMTP id o34mr16309328pgm.420.1590956393597;
        Sun, 31 May 2020 13:19:53 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m3sm5485796pjs.17.2020.05.31.13.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2020 13:19:53 -0700 (PDT)
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
From:   Jens Axboe <axboe@kernel.dk>
To:     Clay Harris <bugs@claycon.org>, io-uring@vger.kernel.org
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
Message-ID: <4eaad89b-f6e3-2ff4-af07-f63f7ce35bdc@kernel.dk>
Date:   Sun, 31 May 2020 14:19:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/20 8:46 AM, Jens Axboe wrote:
> On 5/31/20 6:47 AM, Clay Harris wrote:
>> Tested on kernel 5.6.14
>>
>> $ ./closetest closetest.c
>>
>> path closetest.c open on fd 3 with O_RDONLY
>>  ---- io_uring close(3)
>>  ---- ordinary close(3)
>> ordinary close(3) failed, errno 9: Bad file descriptor
>>
>>
>> $ ./closetest closetest.c opath
>>
>> path closetest.c open on fd 3 with O_PATH
>>  ---- io_uring close(3)
>> io_uring close() failed, errno 9: Bad file descriptor
>>  ---- ordinary close(3)
>> ordinary close(3) returned 0
> 
> Can you include the test case, please? Should be an easy fix, but no
> point rewriting a test case if I can avoid it...

We just need this ported to stable once it goes into 5.8-rc:

https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.8/io_uring&id=904fbcb115c85090484dfdffaf7f461d96fe8e53

-- 
Jens Axboe

