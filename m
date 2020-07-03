Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A7F213FC8
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 21:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgGCTM7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 15:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCTM7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 15:12:59 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01ED1C061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 12:12:59 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x8so12055118plm.10
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 12:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c/oGgRwa/4E/da5AB/UYxrpjdAR1VllEHom3bt/fh20=;
        b=TIWg1CcoaGGCHxGYTc5VCohOZ8ktCOydRLLmVMdmo1HcgwzvcLvGaanBQy+2faYYr1
         ZNmR+Ouu4s5CBc9fHXMZ0i0hLm9EEJfwpcu+pL25+tCXO4NorIuq/yUXLxYpmibCFP0R
         /h87ddlQr0NqIlW9V7qGNCDsvXnq1AHPbTqj5LijAtSdCMTr9U1hDsKabClWg3G7G+XA
         /coo02XpW4Hd4cqu0csHhiXB/dQ1ZIRVZWnSqebsaGajmFD1YPKjGK590YmXy+utXZvH
         d7rqqUFuE8vIg2KrEep0Lz08a/zGi7Dlh1Ks5hcHMXTufbAolMjIMPMC4++mz2NOFHqa
         jEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c/oGgRwa/4E/da5AB/UYxrpjdAR1VllEHom3bt/fh20=;
        b=EjP4DEH7qxibA/vIxJlxrljd/7k3OE/N07mk6WpZTgr4LRvuF/A4fWrDdCSZrE3miD
         lYY71IO9YihGVrMjDzTyiDQyIbjgbIrKnBWR8oGvfuFPZD3E1tKtofVxh/VFDR1lAlmi
         TdAJ4QbxV3OUeWL8wsM6eoLKXXYBldUavfJ9k5spZBMdBNpuTQGPym8aFkJfPlhmt4H4
         tJ9JoufHQL50oSEwl66HBE5uIalLBAo2W5+z3UCEKZTSk1dFVwRjoGNQUCfkY7SNzf7z
         zgsYfEyYR0uPhTk/9opl/VSjWyEvSLKkRAJAxZdln/ZggtGhObLwoGCaAFC1aqL5vGbv
         zIfw==
X-Gm-Message-State: AOAM530FR+k+VbGp+vGARDhsrNUTpcdNGXZdLX6Qas86Kzmge5+hkDPW
        YI/L+G8ycpp8p0w2qr+MdMcK1qmWVhsRCw==
X-Google-Smtp-Source: ABdhPJw7IOqp1NjL/OX5DJCC9+jIf/a2nFEs+jWUoH9CjzS5BXht8vzweQ0xKydvvZkaMyq6DopAQA==
X-Received: by 2002:a17:90a:ca90:: with SMTP id y16mr20800395pjt.223.1593803577968;
        Fri, 03 Jul 2020 12:12:57 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v28sm12474133pgc.44.2020.07.03.12.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 12:12:57 -0700 (PDT)
Subject: Re: Keep getting the same buffer ID when RECV with
 IOSQE_BUFFER_SELECT
To:     Daniele Salvatore Albano <d.albano@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAKq9yRg1NkEOei-G8JKMMo-cTCp128aPPONeLCGPFLqD5w+fkA@mail.gmail.com>
 <193a1dc9-6b88-bb23-3cb5-cc72e109f41b@kernel.dk>
 <CAKq9yRjSewr5z2r8G7dt68RBX4VA9phGpFumKCipNgLzXMdcdQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e68f971b-8b4a-0cdf-8688-288d6f6da56e@kernel.dk>
Date:   Fri, 3 Jul 2020 13:12:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAKq9yRjSewr5z2r8G7dt68RBX4VA9phGpFumKCipNgLzXMdcdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/3/20 1:09 PM, Daniele Salvatore Albano wrote:
> On Fri, 3 Jul 2020, 20:57 Jens Axboe, <axboe@kernel.dk <mailto:axboe@kernel.dk>> wrote:
> 
>     On 7/3/20 12:48 PM, Daniele Salvatore Albano wrote:
>     > Hi,
>     >
>     > I have recently started to play with io_uring and liburing but I am
>     > facing an odd issue, of course initially I thought it was my code but
>     > after further investigation and testing some other code (
>     > https://github.com/frevib/io_uring-echo-server/tree/io-uring-op-provide-buffers
>     > ) I faced the same behaviour.
>     >
>     > When using the IOSQE_BUFFER_SELECT with RECV I always get the first
>     > read right but all the subsequent return a buffer id different from
>     > what was used by the kernel.
>     >
>     > The problem starts to happen only after io_uring_prep_provide_buffers
>     > is invoked to put back the buffer, the bid set is the one from cflags
>     >>> 16.
>     >
>     > The logic is as follow:
>     > - io_uring_prep_provide_buffers + io_uring_submit + io_uring_wait_cqe
>     > initialize all the buffers at the beginning
>     > - within io_uring_for_each_cqe, when accepting a new connection a recv
>     > sqe is submitted with the IOSQE_BUFFER_SELECT flag
>     > - within io_uring_for_each_cqe, when recv a send sqe is submitted
>     > using as buffer the one specified in cflags >> 16
>     > - within io_uring_for_each_cqe, when send a provide buffers for the
>     > bid used to send the data and a recv sqes are submitted.
>     >
>     > If I drop io_uring_prep_provide_buffers both in my code and in the
>     > code I referenced above it just works, but of course at some point
>     > there are no more buffers available.
>     >
>     > To further debug the issue I reduced the amount of provided buffers
>     > and started to print out the entire bufferset and I noticed that after
>     > the first correct RECV the kernel stores the data in the first buffer
>     > of the group id but always returns the last buffer id.
>     > It is like after calling io_uring_prep_provide_buffers the information
>     > on the kernel side gets corrupted, I tried to follow the logic on the
>     > kernel side but there is nothing apparent that would make me
>     > understand why I am facing this behaviour.
>     >
>     > The original author of that code told me on SO that he wrote & tested
>     > it on the kernel 5.6 + the provide buffers branch, I am facing this
>     > issue with 5.7.6, 5.8-rc1 and 5.8-rc3. The liburing library is built
>     > out of the branch, I didn't do too much testing with different
>     > versions but I tried to figure out where the issue was for the last
>     > week and within this period I have pulled multiple times the repo.
>     >
>     > Any hint or suggestion?
> 
>     Do you have a simple test case for this that can be run standalone?
>     I'll take a look, but I'd rather not spend time re-creating a test case
>     if you already have one.
> 
>     -- 
>     Jens Axboe
> 
> 
> I will shrink down the code to produce a simple test case but not sure
> how much code I will be able to lift because it's showing this
> behaviour on a second recv of a connection so I will need to keep all
> the boilerplate code to get there. 

That's fine, I'm just looking to avoid having to write it from scratch.
Plus a test case is easier to deal with than trying to write a test case
based on your description, less room for interpretative errors.

-- 
Jens Axboe

