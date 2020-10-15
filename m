Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E62528F4D5
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388393AbgJOOfc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387589AbgJOOfc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:35:32 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5715C0613D2
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 07:35:31 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j8so4432451ilk.0
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 07:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3L1/9TBjpLndWthwoBtB4TeBTtQ0A63hi99kT0nsw3A=;
        b=BzJiNkYItJ0a0K19sc+CJzVjK04s7IdG6sUwtX8FggqZPkZ1Y08i29g2RXglnEgykN
         Bn8vUti72MSkl86BawXLiX2P8z/DTa4Rz3woD5N0hyOexA1KlTbFXwdS0fuXprwyjKSf
         Hst+oIURzeY9GdxLuaRyt8fqSOJMyouKdzgKlNHc8x+j9+NcP+05IkJCU3EhtDOTRsds
         2Eni0M3FHrANKoKcL0VVZ3QAtYFHsDf+HrnVH0rkwaHK+PM5R4iZQoD/1jmhXrRZfIMy
         NzfiUz7mc1xv8UIcHfR56hYNV08bN0ClnyQuRAoCpqHOhFl4A2cLyfGwmCCZYfZqpxag
         pdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3L1/9TBjpLndWthwoBtB4TeBTtQ0A63hi99kT0nsw3A=;
        b=OUY2xjbfqGD1q+1+YGvDnWkpdDmtB8WTNP5lreIVSfONP1rTcc3cSa6zmV/6GTO50Z
         zOLUKKYGSykquh6vGNPpvHKN2BRf3I83vUnAE8vfkHbbWtNetEIyfYA2uyMs3D5tGWBa
         yVRkSI/1kkcaAlqCPXVKBqSB0eMuTveH7rmHNdQk6JkCJKDwIxebWS9FF5cpOch8GMhe
         XwvEIXJFUFOrd61cXDlKurxG1wbtDhRuIPZhPEzOiK65MS00qO7ROqXa/hAX0Avok/s+
         MBytUyxZ33XxFJDWr3CIeCuPmCghQ1srGL2qhidtXtAZrj+REdkprFNT4O/swfV2anbX
         9Ekw==
X-Gm-Message-State: AOAM533bw7QdhBc5Er90cTgpE2QNC8ykQnCgD+7ir4wCgK/89Qttulo8
        KdUWtElB67wCYSSBA1r57dQ88A==
X-Google-Smtp-Source: ABdhPJyqXcj9QRFyoB1KPc/WOeAGEY2EarWDvhjGXoHzQE6g7WikjXzel8kZLXYRkKSy6gCvpRuIkg==
X-Received: by 2002:a92:c10e:: with SMTP id p14mr2984337ile.160.1602772531133;
        Thu, 15 Oct 2020 07:35:31 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o13sm2778921iop.46.2020.10.15.07.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 07:35:30 -0700 (PDT)
Subject: Re: [PATCH 4/5] x86: wire up TIF_NOTIFY_SIGNAL
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-5-axboe@kernel.dk>
 <87o8l3a8af.fsf@nanos.tec.linutronix.de>
 <da84a2a7-f94a-d0aa-14e0-3925f758aa0e@kernel.dk>
 <87ft6fa77o.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1a618cba-759f-11f4-df39-bcef64a2e1fa@kernel.dk>
Date:   Thu, 15 Oct 2020 08:35:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87ft6fa77o.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15/20 8:34 AM, Thomas Gleixner wrote:
> On Thu, Oct 15 2020 at 08:31, Jens Axboe wrote:
>> On 10/15/20 8:11 AM, Thomas Gleixner wrote:
>> We could, should probably make it:
>>
>> static void handle_signal_work(ti_work, regs)
>> {
>> 	if (ti_work & _TIF_NOTIFY_SIGNAL)
>>         	tracehook_notify_signal();
>>
>> 	if (ti_work & _TIF_SIGPENDING)
>>         	arch_do_signal(regs);
>> }
>>
>> and then we can skip modifying arch_do_signal() all together, as it'll
>> only be called if _TIF_SIGPENDING is set.
> 
> Then you loose the syscall restart thing which was the whole point of
> this exercise :)

Hah oh yeah, good point... But then we need to touch every arch
do_signal() anyway, so probably not much point in making the change
then.

-- 
Jens Axboe

