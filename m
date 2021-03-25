Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838C33496A2
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 17:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCYQTp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 12:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhCYQTl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 12:19:41 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E503DC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 09:19:40 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id d10so2602620ils.5
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 09:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ny7W7nmNL0f2kx37U2KnK1Y8GB/j8Ew/zS7FydXgYaM=;
        b=1TGzRoP4nzflQ7ef524XsMC5b59L/6l0xgoIgzNCTrNcUS1VME115hs3xwgV6mGnge
         +9G2c/WV50zaaZiRDp1VLK4g+3BmuHfrWrShAzfVhcjyeTpAo6GHkQ36oLrx6yKN/mJw
         MB5KPOhm/nWfft5X4tv9sPXgmBctYm1VAfqabhoFrSfOIjb9X6DhPhKYa9GzeL3QCRq9
         oY8lL/72pOiAKGvMfeARfH+tcuAkCPWIrBpl0tkzYrAPKoUMiIuyhlUjGB844dmrE7Vp
         GUOkyEGWhlq5NerzHwWVM4jU8scYLe7FIVStGMbq75nsXjBjf+m+ITz+HKpaKbl2GZFP
         TwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ny7W7nmNL0f2kx37U2KnK1Y8GB/j8Ew/zS7FydXgYaM=;
        b=rWdrlmeeumC8gtHNcjvrIwstagbWqr1GpxcHbiZBCpd2HgL3fk2lByojaqng0nQblp
         Ur0k5XV3rxH7keCRlEHUJs8XD+SNLWDM55tonS5HwSyuq56v/n8cfk80oRjRA0FiSeix
         fq+jhoHN67TXHvyC/m7S9V4uQyivLWlPtk4lwYi0ndIZGwxUYig5xdTp80WZGifJfV8t
         nP/I3bxDAwwyrxqLjCUUki3SIYsBeEMavUKtkEjDHJkQNGCTnTUa7Fj7vxvk9ihradh+
         BI6pxIgY98YCnO1QRwVX6c0Qn9GHrjmWmvq4kbjNqXhYLxjlwnIT0yFjjMSHoSK27j4W
         r8/g==
X-Gm-Message-State: AOAM533hahXwtRVb735FUjXy4ZoqfxFmj8PeMuh6I0X5tmRvRrhGCCQE
        Ociz84vRle+eP8Su9Xf6GpcIFA==
X-Google-Smtp-Source: ABdhPJxIiA6R39HdNvXHx3c2SyTFeZMos+ZQ8unpx6kmIyvJnm570Oh9mTJuA/yqkjHsyzOj8jW0Yw==
X-Received: by 2002:a05:6e02:e91:: with SMTP id t17mr7396763ilj.258.1616689180302;
        Thu, 25 Mar 2021 09:19:40 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 7sm931320ilx.81.2021.03.25.09.19.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 09:19:40 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_wq_put
To:     syzbot <syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000007a49c105be013f72@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4befa1ec-11d8-fca8-692a-492b72b219f4@kernel.dk>
Date:   Thu, 25 Mar 2021 10:19:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000007a49c105be013f72@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/21 6:44 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    1c273e10 Merge tag 'zonefs-5.12-rc4' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13853506d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c51293a9ca630f6d
> dashboard link: https://syzkaller.appspot.com/bug?extid=77a738a6bc947bf639ca
> compiler:       Debian clang version 11.0.1-2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ec259ed00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13acfa62d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com

#syz test: git://git.kernel.dk/linux-block io_uring-5.12

-- 
Jens Axboe

