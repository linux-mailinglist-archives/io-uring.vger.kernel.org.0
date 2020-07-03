Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83183213FB8
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 20:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGCS5r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 14:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCS5q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 14:57:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE7FC061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 11:57:46 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o13so12495871pgf.0
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 11:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KvtDOt0cp8jJzhntUQ/7YMRdTOA+Llf4V+Zc916HHLM=;
        b=u8ch5KitaAb6ooFLzs38CAn4MVGsLw9HpsLN8Z0Q8zK5SiAcj7Bv+HTDOS+asbiUfT
         7Xc33jzFpfLq532fwQvfFfY9rlB6rOGQ+cSG7k2bsmpXAcpiaHVoPy0BPOamoo/yHU4j
         qrv+ief8Q+pXfWF6HrxFDEDkB0xnsRUIQ3Bjf/ztGm+fv81DwVFbMbf3A12cxLFag2Fl
         QgVOvIqG9Fx7AfZdMnZs+5TZ/jukldREwTGRT85w70Tcl86r+SS9XHUi3hrC3udCnjMo
         4Qv3elZ9EH7AbIiMTtGUkf8qI+sUkVdYNkex++JFqnryFNmFFaTYYVpIMdFaiRlv8slt
         ClCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KvtDOt0cp8jJzhntUQ/7YMRdTOA+Llf4V+Zc916HHLM=;
        b=qp7yHjsoV6TVcHOMMnwPGCD9OQsZrsH8yy9vXW+WnIs4NPAmyJl6psbG6il47SAaHF
         gNl9qaSVsOg2ORtSeC30tWmXT9eTpo0qSzfVZ1i/QvKwNWqEP51SkEgAb7nI0ARa+Tzx
         Px0eOhAcCHPLLeU9nEATKfSNMLXrZoHttzT7q1+0vYQ4fzAl/GBli8u/rKt4LHG6yEWk
         YZ3gFAjHbMo3kDtXvZxShGW4Rq8gzZ8k7vtcHqdo69GJzPIQ+1zOCkc9d5xj/1TI3EWZ
         7SItnukccyyZbItrRxL+hZKwWmcsXtzzIZV660a8uOhAxdh0FN4Ra3LVGaI85uVYPwav
         fV0g==
X-Gm-Message-State: AOAM530ORWwA3o3KFzfzSVDsyrBVfUlp0hrhR27U8LP73oDciXJRafQL
        mZKTnHm00ZNRBdr1RG6SA4u5bPppxc/r1w==
X-Google-Smtp-Source: ABdhPJwgKPmRE0vjVFiKadVRrkPXv8dafMVXKADyj54I+LYn4LY4zBbdgM1J8O9etCurqADXuOUTWw==
X-Received: by 2002:a63:140a:: with SMTP id u10mr31598473pgl.238.1593802664909;
        Fri, 03 Jul 2020 11:57:44 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k4sm11187155pjt.16.2020.07.03.11.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 11:57:43 -0700 (PDT)
Subject: Re: Keep getting the same buffer ID when RECV with
 IOSQE_BUFFER_SELECT
To:     Daniele Salvatore Albano <d.albano@gmail.com>,
        io-uring@vger.kernel.org
References: <CAKq9yRg1NkEOei-G8JKMMo-cTCp128aPPONeLCGPFLqD5w+fkA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <193a1dc9-6b88-bb23-3cb5-cc72e109f41b@kernel.dk>
Date:   Fri, 3 Jul 2020 12:57:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAKq9yRg1NkEOei-G8JKMMo-cTCp128aPPONeLCGPFLqD5w+fkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/3/20 12:48 PM, Daniele Salvatore Albano wrote:
> Hi,
> 
> I have recently started to play with io_uring and liburing but I am
> facing an odd issue, of course initially I thought it was my code but
> after further investigation and testing some other code (
> https://github.com/frevib/io_uring-echo-server/tree/io-uring-op-provide-buffers
> ) I faced the same behaviour.
> 
> When using the IOSQE_BUFFER_SELECT with RECV I always get the first
> read right but all the subsequent return a buffer id different from
> what was used by the kernel.
> 
> The problem starts to happen only after io_uring_prep_provide_buffers
> is invoked to put back the buffer, the bid set is the one from cflags
>>> 16.
> 
> The logic is as follow:
> - io_uring_prep_provide_buffers + io_uring_submit + io_uring_wait_cqe
> initialize all the buffers at the beginning
> - within io_uring_for_each_cqe, when accepting a new connection a recv
> sqe is submitted with the IOSQE_BUFFER_SELECT flag
> - within io_uring_for_each_cqe, when recv a send sqe is submitted
> using as buffer the one specified in cflags >> 16
> - within io_uring_for_each_cqe, when send a provide buffers for the
> bid used to send the data and a recv sqes are submitted.
> 
> If I drop io_uring_prep_provide_buffers both in my code and in the
> code I referenced above it just works, but of course at some point
> there are no more buffers available.
> 
> To further debug the issue I reduced the amount of provided buffers
> and started to print out the entire bufferset and I noticed that after
> the first correct RECV the kernel stores the data in the first buffer
> of the group id but always returns the last buffer id.
> It is like after calling io_uring_prep_provide_buffers the information
> on the kernel side gets corrupted, I tried to follow the logic on the
> kernel side but there is nothing apparent that would make me
> understand why I am facing this behaviour.
> 
> The original author of that code told me on SO that he wrote & tested
> it on the kernel 5.6 + the provide buffers branch, I am facing this
> issue with 5.7.6, 5.8-rc1 and 5.8-rc3. The liburing library is built
> out of the branch, I didn't do too much testing with different
> versions but I tried to figure out where the issue was for the last
> week and within this period I have pulled multiple times the repo.
> 
> Any hint or suggestion?

Do you have a simple test case for this that can be run standalone?
I'll take a look, but I'd rather not spend time re-creating a test case
if you already have one.

-- 
Jens Axboe

