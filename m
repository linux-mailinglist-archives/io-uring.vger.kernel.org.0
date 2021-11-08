Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C828449A0F
	for <lists+io-uring@lfdr.de>; Mon,  8 Nov 2021 17:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240118AbhKHQpY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Nov 2021 11:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbhKHQpY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Nov 2021 11:45:24 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20149C061570
        for <io-uring@vger.kernel.org>; Mon,  8 Nov 2021 08:42:40 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id k21so2353858ioh.4
        for <io-uring@vger.kernel.org>; Mon, 08 Nov 2021 08:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IxAdOb0LqPBFkwvM1Auqh52QS5bnCXigClzsNcGh4zY=;
        b=pWyC0UDicmpv1e+mmc2qy6UIzmW3a43fmJK9OZdzMGN6XowJNYmxkrcpLEY4l+L7Uo
         Fq/pJ6H4QzukA1o4IOgeIvscd9PC/oHtKPMRK5VCYBDfbhYPwea94iqHZuQKQXfKrjfc
         yuCy26oaXShM1f0JejBZJKq6UufqyTD0qRtXFeOKgKoOAhb4jZIKT1/Yf5tXgkqo8alL
         FGcOQLVv+wAZmCBCUYZ/JLXSx3nvPgCywiHlHbqm8lwM/SWP/FeMkJorCet2x6uA4kj8
         nWu67sAJz1p8TQwYp7iN6uvJytMFbtWuLpaKLqFAw5/FuqQb1YoRB3G2sjprezLhAKKL
         DShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IxAdOb0LqPBFkwvM1Auqh52QS5bnCXigClzsNcGh4zY=;
        b=IgiXLpK0unfWETO14pvawBssf2glxkzOWAQEDBhYAfP3ni+mUO8IUWJpXDLbi/NPRH
         QGXjscgXiOlUJXipztzmZjS3g6lHJoZDFalGSuknkiSXXFGHbFbEzlYzEbizuyMAnQ/T
         hgLK0i+QlaehFjH1jQqO644hZ41sASDM+nnu9Ti/QaL9JwzMstvTdNYTQFOEsMbLFjit
         Cv3hAJQztm8yXHta9Pa8DjVcAEiEaCRYoutj5d5AWyUtyvoF1Cf+zOZf40sagOduM1UZ
         piiVEhQk5sF6/3fJ3y80fqKZASX9vUnToafKwM6SD7l3KYuVROoprY8ifpwnxB9DdyN0
         TkXg==
X-Gm-Message-State: AOAM530ONaorEgLjkNMo3WJEWQd82mH9tHgfGgSPan1IyQKCEd0LqS6y
        KLcgKNBGtCxO2XrlIUdFM2gWuA==
X-Google-Smtp-Source: ABdhPJzxMe8r2lK7rB22X1iHEP3HPlWk2R5o7xQgDc/cFcH3xAZ/kr4G8p2zgMbbxhXphENNO2BY+A==
X-Received: by 2002:a6b:ee10:: with SMTP id i16mr369263ioh.98.1636389759476;
        Mon, 08 Nov 2021 08:42:39 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i15sm10697495ila.12.2021.11.08.08.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 08:42:39 -0800 (PST)
Subject: Re: [syzbot] WARNING in io_poll_task_func (2)
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     Aleksandr Nogikh <nogikh@google.com>,
        syzbot <syzbot+804709f40ea66018e544@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiaoguang.wang@linux.alibaba.com
References: <0000000000007a0d5705cfea99b2@google.com>
 <0935df19-f813-8840-fa35-43c5558b90e7@kernel.dk>
 <CANp29Y4hi=iFti=BzZxEEPgnn74L80fr3WXDR8OVkGNqR9BOLw@mail.gmail.com>
 <97328832-70de-92d9-bf42-c2d1c9d5a2d6@kernel.dk>
 <CACT4Y+a05_HXcUfooYP5Jp2V5QsxB6zoSZKM6g6P3DiVWUvcyg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0099680c-8955-6771-808f-7fcae8ba7dcb@kernel.dk>
Date:   Mon, 8 Nov 2021 09:42:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+a05_HXcUfooYP5Jp2V5QsxB6zoSZKM6g6P3DiVWUvcyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/8/21 9:30 AM, Dmitry Vyukov wrote:
> On Thu, 4 Nov 2021 at 12:44, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 11/4/21 4:45 AM, Aleksandr Nogikh wrote:
>>> Hi Jeans,
>>>
>>> We'll try to figure something out.
>>>
>>> I've filed an issue to track progress on the problem.
>>> https://github.com/google/syzkaller/issues/2865
>>
>> Great thanks. It's annoyed me a bit in the past, but it's really
>> excessive this time around. Probably because that particular patch
>> caused more than its fair share of problems, but still shouldn't
>> be an issue once it's dropped from the trees.
> 
> syzbot always tests the latest working tree. In this case it's the
> latest linux-next tree. No dead branches were tested.

Maybe the -next tree is just lagging. Does the syzbot setup for the
kernel have some notion of the trees involved? For this particular
example, if the upstream tree that contains/contained the patch that is
flagged as problematic, then it would be ideal if it didn't get
reported. Not sure if this is viable or not.

Ditto if the upstream tree already has a fix for that issue, marked
appropriately. But I guess this one naturally falls out from having told
syzbot with a #fix reply, but that normally doesn't need to happen as
long as the patch flows into the tree being tested. If -next is lagging,
then again we'd get multiple reports for the same thing on an outdated
tree.

> The real problem here is rebased trees and dropped patches and the use
> of "invalid" command.
> For issues fixed with a commit (#syz fix) syzbot tracks precisely when
> the commit reaches all of the tested builds and only then closes the
> issue and starts reporting new occurrences as new issues.
> But "syz invalid" does not give syzbot a commit to track and means
> literally "close now", so any new occurrences are reported as new
> issues immediately.
> The intention is that it's on the user issuing the "invalid" command
> to do this only when the issue is really not present in any of syzbot
> builds anymore.

And the latter is problematic if the -next tree isn't current anymore.

> There are hacks around like saying "syz fix" with some unrelated later
> commit that will reach linux-next upstream along with the dropped
> patch, then syzbot will do proper tracking on its own.
> Better suggestions are welcome.

I guess a work-around would just be to use #fix for eg the merge commit
in the upstream branch.

-- 
Jens Axboe

