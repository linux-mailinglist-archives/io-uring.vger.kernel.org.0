Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CA1349AA5
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 20:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhCYTrL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 15:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhCYTqt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 15:46:49 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F72BC06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:46:49 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z3so3069604ioc.8
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w4tXV4bjH2c8KynLJsKEa06SrUbk+HhPBB7dNQjtcMM=;
        b=MvF9EcaP6yLfYa/7v62PIim8XiIiqUXRH21gM7E8BzGMxecJ1lI9X5AkqtYLGoRXC1
         b3F5PmHC8nFlkkyvXRurbk2VPXVypEOIiWXIq3Bn/C6VAdcVGKICrEnVS+dg3TzesfwZ
         1G55KUHnMzZEBlbaZ/SKFI5W982T6HHc84VIIsm3g+Uc3H2eNQkexrc/NTAGCtTeYg6E
         AoR9mPzQkZJP+N3gT8iLxal++mlD8FCIchmiQ9MOUyERs81JY/azInm8CvLPG6duzmys
         gJHRRQytR/RQXTgRE2NAfkRorpbsTgeCMGsX5FQ0l65p49P2q3vHvBE9q740jtKa7U1H
         Pspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w4tXV4bjH2c8KynLJsKEa06SrUbk+HhPBB7dNQjtcMM=;
        b=SUXB7bD7lkHrGhK9U7p+/mtCi4Ssgz/x7XfkBT2DHhOI7/oSYuYJuEUuq+AHEVO2go
         T2NVZsWZVFTtk9QLUSPfFOuJpC52/hzR4e/QEEA/xndlTU2HqLo5cau9yPLnUY0x4UPh
         5ewiHTDtDH3gVzrKe+ArFDkh1VFSvejuwVMvMYhVl4MGmCsY98CG6VMvRGjnCJOfBEWS
         /YQzkUCiqxkenDsJwqeM5+7ArGl44ct15+Qt35dtlZCDd2FFe51IrknDKxBj5j5E3waa
         WoILfxjoAV9ZZKuRklAr5+9JID0u/nEqocgCUsb9ReQmQT/9w8D9ziMPJZ3tltUq8B4T
         hyCQ==
X-Gm-Message-State: AOAM533xSiCUQMvtbzNKfCYFkRW6w5DLo+9wkKJmoOJExs8ghOlCoDgO
        eJ0muxkqoV3nPYH/kF8cRMvILQ==
X-Google-Smtp-Source: ABdhPJyrehP8WY34/73Y0Umb05rmNkbp2CdjyZaTXlHtPfJyxt0WDhvyoLTe92Tv9PvClh6KA7vlPg==
X-Received: by 2002:a5d:9610:: with SMTP id w16mr7886714iol.167.1616701607804;
        Thu, 25 Mar 2021 12:46:47 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g6sm3142446ilj.28.2021.03.25.12.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 12:46:47 -0700 (PDT)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3a1c02a5-db6d-e3e1-6ff5-69dd7cd61258@kernel.dk>
Date:   Thu, 25 Mar 2021 13:46:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 1:42 PM, Linus Torvalds wrote:
> On Thu, Mar 25, 2021 at 12:38 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I don't know what the gdb logic is, but maybe there's some other
>> option that makes gdb not react to them?
> 
> .. maybe we could have a different name for them under the task/
> subdirectory, for example (not  just the pid)? Although that probably
> messes up 'ps' too..

Heh, I can try, but my guess is that it would mess up _something_, if
not ps/top.

-- 
Jens Axboe

