Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED73349A8D
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 20:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhCYTkq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 15:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCYTkh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 15:40:37 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DF6C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:40:36 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id b10so3081849iot.4
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=inE7F0TbtrpX8JhWXnKNGugnhF2L+PECbmtt7gVIrNk=;
        b=Mg/wYEQjME+yzX7+3mkuMjdSLrX/JGvsUCKXrIae//Ay5yL5UYIy8y9AVBv5/dcGOk
         uDtZzT1e10HzygsnZfrpKarfxRAOEootSTGmhvkghYKYInbwMGu8KrH3CkYTMsElNTfT
         IEpM0RB1CG77nBcX3WXALA1PzIrtF4mkWDtVEo2VuEq9UHXr2lJnctgyLC+49r71XQ+6
         bi7iEVuDQv1fW654yjPoEo3ESfYiCBe/Re68wjyAR+ZlF3/GoiJljPZNHmPPQxgF8GkU
         KZAPKgKsqhLUi86ysbmFXgBTMWEa5FSENTrtDWEFRy9G8or+3/Y8z3w1beVco/3IFSWI
         EBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=inE7F0TbtrpX8JhWXnKNGugnhF2L+PECbmtt7gVIrNk=;
        b=RJWSKE39Ea4Wcar8vcWe08vUg6yoLSx3mR1+g9gZUaQTTbV2XTgBpWh3apyPLPc56B
         QABxAhksmRQwhmF8MjUHwSZes6+Nh7sLTZNX8TKBFAFPzz0BypURGlkA4a/Fyj8jkV/m
         qrxBFgt3vA+Dusg+6iUHcHRnHUyfwZVchwuTaPeaXICcibzHLjasiAb0AK48zHb3R8zE
         s/kR5xfSPCJxgWskeq+0Y7jxHbZnPkMD7mjKzOVcBdTLRky2C74Sw+4t5E7yub3TrGdr
         51jYRU9T8KxidRBtujYeY+MOnGD9tW0M3vUpiBrn15kOHe/tfNlkm5qijfmYnUnguEPM
         6mhA==
X-Gm-Message-State: AOAM532vwJ9YwuY3lo/cKg6H+GaLDIPvvlnTp1BE6Rt7PM6TO7J1Z5JX
        hoyt/XKDeiNUd4XI40OaWoOTIg==
X-Google-Smtp-Source: ABdhPJwnnrF5Ld5QVSpGoYhxQQiSHGOvNXxkkWOWSzcaxztKCMBybWD0q6QSkNhryacOiJ72JslkBw==
X-Received: by 2002:a05:6602:2048:: with SMTP id z8mr7822623iod.143.1616701235726;
        Thu, 25 Mar 2021 12:40:35 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y20sm3116004ioy.10.2021.03.25.12.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 12:40:35 -0700 (PDT)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com, metze@samba.org
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5ee8ad82-e145-3ed6-1421-eede1ada0d7e@kernel.dk>
Date:   Thu, 25 Mar 2021 13:40:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m1ft0j3u5k.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 1:33 PM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Hi,
>>
>> Stefan reports that attaching to a task with io_uring will leave gdb
>> very confused and just repeatedly attempting to attach to the IO threads,
>> even though it receives an -EPERM every time. This patchset proposes to
>> skip PF_IO_WORKER threads as same_thread_group(), except for accounting
>> purposes which we still desire.
>>
>> We also skip listing the IO threads in /proc/<pid>/task/ so that gdb
>> doesn't think it should stop and attach to them. This makes us consistent
>> with earlier kernels, where these async threads were not related to the
>> ring owning task, and hence gdb (and others) ignored them anyway.
>>
>> Seems to me that this is the right approach, but open to comments on if
>> others agree with this. Oleg, I did see your messages as well on SIGSTOP,
>> and as was discussed with Eric as well, this is something we most
>> certainly can revisit. I do think that the visibility of these threads
>> is a separate issue. Even with SIGSTOP implemented (which I did try as
>> well), we're never going to allow ptrace attach and hence gdb would still
>> be broken. Hence I'd rather treat them as separate issues to attack.
> 
> A quick skim shows that these threads are not showing up anywhere in
> proc which appears to be a problem, as it hides them from top.
> 
> Sysadmins need the ability to dig into a system and find out where all
> their cpu usage or io's have gone when there is a problem.  I general I
> think this argues that these threads should show up as threads of the
> process so I am not even certain this is the right fix to deal with gdb.

That's a good point, overall hiding was not really what I desired, just
getting them out of gdb's hands. And arguably it _is_ a gdb bug, but...

-- 
Jens Axboe

