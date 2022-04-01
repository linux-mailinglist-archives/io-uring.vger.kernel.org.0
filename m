Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0CE4EE9DE
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 10:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243483AbiDAIml (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 04:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiDAImk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 04:42:40 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6448025A4BD
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 01:40:48 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h4so2119305edr.3
        for <io-uring@vger.kernel.org>; Fri, 01 Apr 2022 01:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ODp466/ZjqwhHwnyoWxPttVU2UXfEYkQNMY70RST0c=;
        b=bzHaC5XoP+bPSKB6EmcWOIIiQKbqWRnKIP3NtSCb0hffxjaj8dod+/JQuoe2UVojBr
         Ihsn8Tl2VeHEG+LjPjB3z3c0Ke0h53uf8LJ1Z4Kw8Y4/OHKVc0OWp7u69ukbKK1cKtuM
         otCDLsxAkmtfmkVcP8MmyMBYs4SVq+MhdC2A4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ODp466/ZjqwhHwnyoWxPttVU2UXfEYkQNMY70RST0c=;
        b=TOe57BM4MwnXOlQoQLzglcJH3nPR7za7Fne7vCf8qpsHcUP6UeYUpyh2dZgYuVGYB4
         HepmyHj2dgLwaIGGgdi5CFkOELS2Khq676vDuFU1E0b47slf+q8v7u4PzzEPuIecPhiu
         udVWnAxIBcny3dby97/MMEknMOPZZ9kVgHakSozEQASN7VAZ7TbBP5brBpSZdUWNMMjh
         686fFw0UA6YBgWe46DU3MmYRA3Ax/oUNSXvjqEavhJReR20dsJf5P9h73UjIm2cYR6dV
         wNjlg7j4Z1PnmVYPAgRQSuTUI/37OvsoSqY3fjXW1+X4JHCbprDoqprS7AX9VXO3KzF7
         3Zrg==
X-Gm-Message-State: AOAM531YyPgkDjOnQW8lXzxkDHhg+eLoGKTPpo0i4Lp1oEhQ9bvqbC4U
        ln3777cREvWBKjepWVGqoLMxv9dUl6yFw17KcuGHuA==
X-Google-Smtp-Source: ABdhPJydVxp7y2TOLY4NvudX+gcCH3h2oZaD5I2ZL5nfQtgFSdLNpRA0MrumqZZ1DX007ALSkZ1LvP9R79NLe+FqkkA=
X-Received: by 2002:a50:d711:0:b0:410:a51a:77c5 with SMTP id
 t17-20020a50d711000000b00410a51a77c5mr19959999edi.154.1648802446994; Fri, 01
 Apr 2022 01:40:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk> <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk> <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk> <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk> <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk> <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk> <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
 <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk> <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
 <38436a44-5048-2062-c339-66679ae1e282@kernel.dk>
In-Reply-To: <38436a44-5048-2062-c339-66679ae1e282@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 1 Apr 2022 10:40:35 +0200
Message-ID: <CAJfpegvM3LQ8nsJf=LsWjQznpOzC+mZFXB5xkZgZHR2tXXjxLQ@mail.gmail.com>
Subject: Re: io_uring_prep_openat_direct() and link/drain
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 30 Mar 2022 at 19:49, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/30/22 9:53 AM, Jens Axboe wrote:
> > On 3/30/22 9:17 AM, Jens Axboe wrote:
> >> On 3/30/22 9:12 AM, Miklos Szeredi wrote:
> >>> On Wed, 30 Mar 2022 at 17:05, Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 3/30/22 8:58 AM, Miklos Szeredi wrote:
> >>>>> Next issue:  seems like file slot reuse is not working correctly.
> >>>>> Attached program compares reads using io_uring with plain reads of
> >>>>> proc files.
> >>>>>
> >>>>> In the below example it is using two slots alternately but the number
> >>>>> of slots does not seem to matter, read is apparently always using a
> >>>>> stale file (the prior one to the most recent open on that slot).  See
> >>>>> how the sizes of the files lag by two lines:
> >>>>>
> >>>>> root@kvm:~# ./procreads
> >>>>> procreads: /proc/1/stat: ok (313)
> >>>>> procreads: /proc/2/stat: ok (149)
> >>>>> procreads: /proc/3/stat: read size mismatch 313/150
> >>>>> procreads: /proc/4/stat: read size mismatch 149/154
> >>>>> procreads: /proc/5/stat: read size mismatch 150/161
> >>>>> procreads: /proc/6/stat: read size mismatch 154/171
> >>>>> ...
> >>>>>
> >>>>> Any ideas?
> >>>>
> >>>> Didn't look at your code yet, but with the current tree, this is the
> >>>> behavior when a fixed file is used:
> >>>>
> >>>> At prep time, if the slot is valid it is used. If it isn't valid,
> >>>> assignment is deferred until the request is issued.
> >>>>
> >>>> Which granted is a bit weird. It means that if you do:
> >>>>
> >>>> <open fileA into slot 1, slot 1 currently unused><read slot 1>
> >>>>
> >>>> the read will read from fileA. But for:
> >>>>
> >>>> <open fileB into slot 1, slot 1 is fileA currently><read slot 1>
> >>>>
> >>>> since slot 1 is already valid at prep time for the read, the read will
> >>>> be from fileA again.
> >>>>
> >>>> Is this what you are seeing? It's definitely a bit confusing, and the
> >>>> only reason why I didn't change it is because it could potentially break
> >>>> applications. Don't think there's a high risk of that, however, so may
> >>>> indeed be worth it to just bite the bullet and the assignment is
> >>>> consistent (eg always done from the perspective of the previous
> >>>> dependent request having completed).
> >>>>
> >>>> Is this what you are seeing?
> >>>
> >>> Right, this explains it.   Then the only workaround would be to wait
> >>> for the open to finish before submitting the read, but that would
> >>> defeat the whole point of using io_uring for this purpose.
> >>
> >> Honestly, I think we should just change it during this round, making it
> >> consistent with the "slot is unused" use case. The old use case is more
> >> more of a "it happened to work" vs the newer consistent behavior of "we
> >> always assign the file when execution starts on the request".
> >>
> >> Let me spin a patch, would be great if you could test.
> >
> > Something like this on top of the current tree should work. Can you
> > test?
>
> You can also just re-pull for-5.18/io_uring, it has been updated. A last
> minute edit make a 0 return from io_assign_file() which should've been
> 'true'...

Yep, this works now.

Next issue:  will get ENFILE even though there are just 40 slots.
When running as root, then it will get as far as invoking the OOM
killer, which is really bad.

There's no leak, this apparently only happens when the worker doing
the fputs can't keep up.  Simple solution:  do the fput() of the
previous file synchronously with the open_direct operation; fput
shouldn't be expensive...  Is there a reason why this wouldn't work?

Thanks,
Miklos
