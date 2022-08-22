Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4441059CC4C
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 01:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbiHVXiF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Aug 2022 19:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238538AbiHVXiE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 19:38:04 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D662E56B80
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 16:38:02 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-11c5ee9bf43so14853799fac.5
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 16:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=I7R+VEDbO3foZ6yKN1RvxUlGUWMUqe+kxx9F62LzajE=;
        b=wUiHZMryHOsnt+1mwbFzsumcA+zH0BVbOWQPuaxftVdFIYVHHPnnopFrM6s+f+tI/2
         2+L+UPFyCoJr0aSOVO2SZmm3elEyk6kDuGpAXcsc3Jn4aAJn6EWwAQ21irctfgDXQoGi
         AtIUMFtKTtLXZgDHSd+JP8rxnxU+qFpo9lgJ4EHYFf2M3KZSMu8116oAZrkeoIJkIOve
         tB+WGRSWxppgzZx2da2kLVvVpxMNW1dVQBPUae31JUODx7QfDFR0qrm1dswWfS9tfxkx
         sf6q8z79zEap/aa2kX2VG0hPhjdeyDh8ymTStyR6Qwhz9cXkwX6WU184GYFwMvw3xpH6
         8STw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=I7R+VEDbO3foZ6yKN1RvxUlGUWMUqe+kxx9F62LzajE=;
        b=IyCLVgfes9X1fGs/fsV9Vc/JdyhT8KUAzdXVSNSz8eFEWPR/PlgEZMh1/1c8DZKuPt
         bNKY60xcyyWDjW66TnLUbezE6IqUDvCmyCEEU3EbdDdiGtsQhbhH3puT71GvQTNl6ZXc
         wBipXXpHK4O0veDYuTifNT7E7g3JlDEcEVsJcDZkRNTHKvi0Vff9+HQylX4fVIMsuYy9
         PHBzGDXLECgOrxizG9IxZP9BAvH83Hsyh6S5iEMUyvXlymB5H/Bhwzi2GdS1KeepLwz7
         fGdsFJqBss8n8Y9KMnT8EE2bxQGNKwtsuJ32KLb/LhM87IU9WCpiHnGiU64D7EVzhRms
         lQsQ==
X-Gm-Message-State: ACgBeo3h8BEhG4pwkbsOryt3RCY4Oc2v8v5olu1Rk0uCyFhtAFwbcXGH
        LGWkLck2m56itC1g5yDQ1OVwolAGRRvBvXzZAjjj
X-Google-Smtp-Source: AA6agR57ZOJqsf2RI1gMF+ciEe763uY+u/5e99MRG9osFBjYQFQ7KXslo0CXF4PeKFh3is70TOYQtWbWNeIS3U9lAvU=
X-Received: by 2002:a05:6870:a78d:b0:11c:437b:ec70 with SMTP id
 x13-20020a056870a78d00b0011c437bec70mr297717oao.136.1661211482201; Mon, 22
 Aug 2022 16:38:02 -0700 (PDT)
MIME-Version: 1.0
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327984.369593.8371751426301540450.stgit@olly> <1e4dde67-4ac2-06b0-b927-ce4601ed9b30@kernel.dk>
 <CAHC9VhQbnN2om-Qt59ZNovEgRAcB=XvcR+AYK8HhLLrPmMjMLA@mail.gmail.com>
 <1017959d-7ec0-4230-89db-b077067692d1@kernel.dk> <CAHC9VhQw5V_aH=y2vSX4=f6fofc01w32c5gfediubVU=LCVJng@mail.gmail.com>
 <73022e0f-4913-2620-605d-ad86d8b73494@kernel.dk>
In-Reply-To: <73022e0f-4913-2620-605d-ad86d8b73494@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 22 Aug 2022 19:37:51 -0400
Message-ID: <CAHC9VhSQwkYNdzKrkM6sMSj_fLFTpeNaAoRgpZrzfZizYti_ag@mail.gmail.com>
Subject: Re: [PATCH 3/3] /dev/null: add IORING_OP_URING_CMD support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 22, 2022 at 7:25 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/22/22 5:19 PM, Paul Moore wrote:
> > On Mon, Aug 22, 2022 at 7:13 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 8/22/22 5:09 PM, Paul Moore wrote:
> >>> On Mon, Aug 22, 2022 at 6:36 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 8/22/22 3:21 PM, Paul Moore wrote:
> >>>>> This patch adds support for the io_uring command pass through, aka
> >>>>> IORING_OP_URING_CMD, to the /dev/null driver.  As with all of the
> >>>>> /dev/null functionality, the implementation is just a simple sink
> >>>>> where commands go to die, but it should be useful for developers who
> >>>>> need a simple IORING_OP_URING_CMD test device that doesn't require
> >>>>> any special hardware.
> >>>>>
> >>>>> Cc: Arnd Bergmann <arnd@arndb.de>
> >>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>>> Signed-off-by: Paul Moore <paul@paul-moore.com>
> >>>>> ---
> >>>>>  drivers/char/mem.c |    6 ++++++
> >>>>>  1 file changed, 6 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> >>>>> index 84ca98ed1dad..32a932a065a6 100644
> >>>>> --- a/drivers/char/mem.c
> >>>>> +++ b/drivers/char/mem.c
> >>>>> @@ -480,6 +480,11 @@ static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
> >>>>>       return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
> >>>>>  }
> >>>>>
> >>>>> +static int uring_cmd_null(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
> >>>>> +{
> >>>>> +     return 0;
> >>>>> +}
> >>>>
> >>>> This would be better as:
> >>>>
> >>>>         return IOU_OK;
> >>>>
> >>>> using the proper return values for the uring_cmd hook.
> >>>
> >>> The only problem I see with that is that IOU_OK is defined under
> >>> io_uring/io_uring.h and not include/linux/io_uring.h so the #include
> >>> macro is kinda ugly:
> >>>
> >>>   #include "../../io_uring/io_uring.h"
> >>>
> >>> I'm not sure I want to submit that upstream looking like that.  Are
> >>> you okay with leaving the return code as 0 for now and changing it at
> >>> a later date?  I'm trying to keep this patchset relatively small since
> >>> we are in the -rcX stage, but if you're okay with a simple cut-n-paste
> >>> of the enum to linux/io_uring.h I can do that.
> >>
> >> Ugh yes, that should move into the general domain. Yeah I'm fine with it
> >> as it is, we can fix that up (and them nvme as well) at a later point.
> >
> > Okay, sounds good, I'll leave it as-is.  Is it okay to still add your ACK?
>
> Yep, all things considered, for 6.0 I think that's the way to go.

Great, thanks.

-- 
paul-moore.com
