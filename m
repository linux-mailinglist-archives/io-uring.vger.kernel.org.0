Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD27624D6B0
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 15:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgHUNz7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Aug 2020 09:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgHUNz6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Aug 2020 09:55:58 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C8BC061573
        for <io-uring@vger.kernel.org>; Fri, 21 Aug 2020 06:55:58 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id m200so1070592ybf.10
        for <io-uring@vger.kernel.org>; Fri, 21 Aug 2020 06:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=datadoghq.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=252+vJaMVsbLgAEy+MzraO+zqIdAzi/sOZ+rVR5WF1g=;
        b=X9AF6VC4MdLAH+AwxrK78kxxmwMsRqRms5PEGXMizn79HWz3elIkqSrS9ns39MQK3a
         j85WzuLrMFR3OplZLSa7D64ZHoZbqCgUVkAPFjNLqDC56wKMFdn4jYnftAY6A4XHntrQ
         iHIv/5+IjuxMu2/duUAcbjr1VDbpKqXeS5KUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=252+vJaMVsbLgAEy+MzraO+zqIdAzi/sOZ+rVR5WF1g=;
        b=ZyNIfB1w45BijZtAxHaKHZqkBniMVL+c9pII1G1lkeDh4hw02eL42Vs9lSPrnWMJa/
         8qeIwxN/2H8EQm9RlVw6ZXkdbzdp6MYSK4EswH8ijNJX6dPMXz1FHKSt0FGACizgkn3t
         Og0wh6obTk/OFJsNCcjSenEcQvezk6IQLbUle/8zuZLiIbQio0Os0BvUBD1ijSezpeDv
         wNfqWmi2xxzZlNNtpueLeFHc4Wn3khQshPcr7fBhhsg6wCNKRrSdxti+hH+CUCy4N/r5
         mL2Aa7RQU9NwQGYQi43UQi2gXaNrPxNyT+xvfd0tY7mMNlxznFIJewCJBfIQvRl/zdyp
         LH8w==
X-Gm-Message-State: AOAM530AujAmsRWioKeG2k3KmUWFlA+fsoMSGDz9MEDW1okM0Nz/+tvZ
        bVU/YxfuQJ7t33XpLOIGAjOraqCg24BB2obQVDH9WXIJ1qM=
X-Google-Smtp-Source: ABdhPJxlfU6/Dk1sJ8T8f8PI9QzfaFeTCGZ0JgOIlb1p5TkrHN/Wwbp9kkDqZyU/fF74Tx8fHMrGedEVM1jrSZkc7A0=
X-Received: by 2002:a25:6908:: with SMTP id e8mr4251795ybc.83.1598018157494;
 Fri, 21 Aug 2020 06:55:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdqtNXQbQazseOuyNC_p53QjstsVqUz_6BU2MkAWMMrxEuJ=A@mail.gmail.com>
 <8d8870de-909a-d05d-51a5-238f5c59764d@kernel.dk> <CAMdqtNWVRrej-57v+rXhStPzLBh7kuocPpzJ0R--A3AcG36YAQ@mail.gmail.com>
 <8f509999-bfe3-c99b-6e82-dc604865ce9e@kernel.dk>
In-Reply-To: <8f509999-bfe3-c99b-6e82-dc604865ce9e@kernel.dk>
From:   Glauber Costa <glauber.costa@datadoghq.com>
Date:   Fri, 21 Aug 2020 09:55:46 -0400
Message-ID: <CAMdqtNWVgd4-X3t3WNZJdAcSqm9g_Bc3QYdJSCUBitz0j5xEOw@mail.gmail.com>
Subject: Re: Poll ring behavior broken by f0c5c54945ae92a00cdbb43bdf3abaeab6bd3a23
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, xiaoguang.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 20, 2020 at 11:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/20/20 8:24 PM, Glauber Costa wrote:
> > On Thu, Aug 20, 2020 at 9:57 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 8/20/20 6:46 PM, Glauber Costa wrote:
> >>> I have just noticed that the commit in $subject broke the behavior I
> >>> introduced in
> >>> bf3aeb3dbbd7f41369ebcceb887cc081ffff7b75
> >>>
> >>> In this commit, I have explained why and when it does make sense to
> >>> enter the ring if there are no sqes to submit.
> >>>
> >>> I guess one could argue that in that case one could call the system
> >>> call directly, but it is nice that the application didn't have to
> >>> worry about that, had to take no conditionals, and could just rely on
> >>> io_uring_submit as an entry point.
> >>>
> >>> Since the author is the first to say in the patch that the patch may
> >>> not be needed, my opinion is that not only it is not needed but in
> >>> fact broke applications that relied on previous behavior on the poll
> >>> ring.
> >>>
> >>> Can we please revert?
> >>
> >> Yeah let's just revert it for now. Any chance you can turn this into
> >> a test case for liburing? Would help us not break this in the future.
> >
> > would be my pleasure.
> >
> > Biggest issue is that poll mode really only works with ext4 and xfs as
> > far as I know. That may mean it won't get as much coverage, but maybe
> > that's not relevant.
>
> And raw nvme too, of course. But I'd say coverage is pretty decent with
> those two, in reality that's most likely what people would use for
> polling anyway. So not too concerned about that, and it'll hit multiple
> items in my test suite.
>
> I reverted the change manually, it didn't revert cleanly. Please test
> current -git, thanks!
>

Just tested (through a new unit test) and it works, thanks.

I wrote a unit test that works on HEAD but not on HEAD^.

However you will have to excuse my lack of manners, but in my new work account I
can't have app passwords for GSuite so I am unable to git-send-email
it without talking
to a host of corporate IT people... I'll have to send a ... urgh... PR


> --
> Jens Axboe
>
