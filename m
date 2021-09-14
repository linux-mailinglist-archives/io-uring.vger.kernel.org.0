Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4F940B2C4
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 17:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhINPPg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 11:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbhINPPg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 11:15:36 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28677C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:14:19 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id b15so13952083ils.10
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6f6HxR3BPfdHdUlWHpviXptAtwE5sJzs4ppblom14aM=;
        b=gS9wDNVaP4nsC+3B6pUM7VYhrlhIkhnTDm7PPxKMRXtR5P1ZfFMzJmkOROEPfsx4hi
         HU8xyej3bFowa4GTkKN6h0nfsZa1IZh1WgeHJ6c9AmYwsAxKqnMVOQY7h/K4kZftKlGF
         9UrBudNdREOGu4rWNugOzKNl3KHwYULkefxEyel7JZSxLF4Uj+qXTQiWI9bEcqZDyt1H
         4JDAkEztL4wyymImZwz/DesHoLeBfsj2St4zmVOZXFP7MeyL+46CqlA4cLW5IKxWRfzZ
         efWrWpT5WilSEVeU6kguaFtVjF8klsR486JhpPQhtebcZoenkJxhOxxBHocm/cWjemIB
         qqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6f6HxR3BPfdHdUlWHpviXptAtwE5sJzs4ppblom14aM=;
        b=ys6ny1qva4qNsK5KxuCaIxzDC1PTDH2ZqyKrbGCL7e8bM4TH6NCV2LQqbz/JBwBWQ7
         kyXVPn+kawDEzvFHwo8KRbSBQcmiepTLE1/PF9dyC+TmhLKEBKfmZkithv0JLO1qxDk6
         3TYY98Mxu7c1WYLGUxkbq3YWuBCsvcoRL5TtOWuR6xt+oONR0DNzWQebCKPwFdAA7eLR
         25FGzWcvKZAYiVXConIEFtnhCWWmRpT5BNPz0omqnKAnSIl1+vHk2tMJaWERoIah1NZ/
         DPG+ibMxm2Xz47yPAHsyGczXFo034XenEyJHY1TBLEiP83vbIP6SW9c+sNp7GCTaMT8c
         gYjg==
X-Gm-Message-State: AOAM533Muxgg3WMFWdC5y0AxbYMj5B9SBYk/LQH2m1GNuiMh/LZla1f/
        WrS8FMQ3/KdbC0v/7Mtw+ZsCZJD2EV+aBOhDYUY=
X-Google-Smtp-Source: ABdhPJxlUdZLLOqgDzhkpychqFqVuo+mAwEijsVojn+WU65SqWdCKF6ic+02wBO+nsZ+BKN17hjsGg==
X-Received: by 2002:a92:c8c7:: with SMTP id c7mr10097631ilq.62.1631632458465;
        Tue, 14 Sep 2021 08:14:18 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v1sm6720515ile.83.2021.09.14.08.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 08:14:18 -0700 (PDT)
Subject: Re: [PATCH v2 5.15] io_uring: auto-removal for direct open/accept
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
References: <c896f14ea46b0eaa6c09d93149e665c2c37979b4.1631632300.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de129f22-1a44-8ddf-ec42-fa6fba85d7fe@kernel.dk>
Date:   Tue, 14 Sep 2021 09:14:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c896f14ea46b0eaa6c09d93149e665c2c37979b4.1631632300.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 9:12 AM, Pavel Begunkov wrote:
> It might be inconvenient that direct open/accept deviates from the
> update semantics and fails if the slot is taken instead of removing a
> file sitting there. Implement this auto-removal.
> 
> Note that removal might need to allocate and so may fail. However, if an
> empty slot is specified, it's guaraneed to not fail on the fd
> installation side for valid userspace programs. It's needed for users
> who can't tolerate such failures, e.g. accept where the other end
> never retries.

Can you submit a liburing test case for this too?

-- 
Jens Axboe

