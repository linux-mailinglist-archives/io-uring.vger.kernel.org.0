Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B58C3CF4FC
	for <lists+io-uring@lfdr.de>; Tue, 20 Jul 2021 09:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242791AbhGTGVN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jul 2021 02:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243168AbhGTGTK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jul 2021 02:19:10 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18822C0613DE;
        Mon, 19 Jul 2021 23:59:41 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id a16so31400385ybt.8;
        Mon, 19 Jul 2021 23:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NTsNlpcS3m1RPAqJpTjt1eD/8FRCX20SGgwdUxbXddg=;
        b=N3JUWYsA26n1AarVQFBd//NcudAOtfWp23l1xRoCCmj3xSZXNaaFbm6b7CCaBIo6sc
         yNcJ3FFKEAMUdsAOsYidVLhpCs6ov1jHJrdE8yrboWCdqkNEYeU4H1E5kA9N6fXnJz3B
         ZRpUw4iKZtStQC3nTXHpmgSZT5IlTXwkPl7cmEs4P7nngG/tZa/DP6IEXZJ5YSxMRIsC
         e9qMU5XnS2x7nwf77miFvxx3TapfsICICRv4vrKenDd1mAOL4t2VwyeflxlBYl5Bz9qD
         41ThlSYvSQMfN5JhMi2Q6ef0OAR1ozkSzpypHSN57+0WmC606B9cT0cWkfsTT6VFsB4z
         s8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NTsNlpcS3m1RPAqJpTjt1eD/8FRCX20SGgwdUxbXddg=;
        b=Kz/VZJn92rjARauCViom59Khnlu6oYU5xKfU9WXBj5iHTVKGKDgslGpWLCIivIcGQy
         5ywqUwiTvZ0CG2lUYwg1GTs2bIoT0B+HfF64c6SBZwluutUg//BhbzoCTKoL003n3qEd
         7TRTp0kWYTn9f6Q5yUJdXwgA41mxGcEN6zdeF6xmMRN35RHbq3bggBHX5e+yUu9uO4ib
         8wxS7fcKSTNDXQQXeyycIWTayF0RXC2AWBJsoI8W0LhTqaLYbiE57YS4MbF1kOn7WGLO
         RdTfbZNtfhkgqdOqj98+gjEQiOJgtJ7zQxFzNX3MDM8N+wDGU0mbwA0BrbwdypchkGQT
         lC5g==
X-Gm-Message-State: AOAM531qCA+SQejv7TuovnVb31fCCQMOJWS3J+C873G1xv1Kywq+VJu2
        oE7+fR4EMBbK94XNZTz8HLLtuc4wfD24YVFWwQM=
X-Google-Smtp-Source: ABdhPJzHQWzeaBKjrfpgbPHIjudkJ5oM3rtajfL1cgg+a7Hco293AYL+aukcN4KdbTLu7RfihIYto8kVMWCP/cd7HA0=
X-Received: by 2002:a25:ab8b:: with SMTP id v11mr37594603ybi.375.1626764380472;
 Mon, 19 Jul 2021 23:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210715103600.3570667-1-dkadashev@gmail.com> <20210715103600.3570667-6-dkadashev@gmail.com>
 <YPCX5/0NtbEySW9q@zeniv-ca.linux.org.uk>
In-Reply-To: <YPCX5/0NtbEySW9q@zeniv-ca.linux.org.uk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 20 Jul 2021 13:59:29 +0700
Message-ID: <CAOKbgA79ODk_swv9nsU50ZrRe9Xqv3n9-JOH+H0zyhUF2SYcRw@mail.gmail.com>
Subject: Re: [PATCH 05/14] namei: prepare do_mkdirat for refactoring
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 16, 2021 at 3:17 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Thu, Jul 15, 2021 at 05:35:51PM +0700, Dmitry Kadashev wrote:
> > This is just a preparation for the move of the main mkdirat logic to a
> > separate function to make the logic easier to follow.  This change
> > contains the flow changes so that the actual change to move the main
> > logic to a separate function does no change the flow at all.
> >
> > Just like the similar patches for rmdir and unlink a few commits before,
> > there two changes here:
> >
> > 1. Previously on filename_create() error the function used to exit
> > immediately, and now it will check the return code to see if ESTALE
> > retry is appropriate. The filename_create() does its own retries on
> > ESTALE (at least via filename_parentat() used inside), but this extra
> > check should be completely fine.
>
> This is the wrong way to go.  Really.  Look at it that way - LOOKUP_REVAL
> is the final stage of escalation; if we had to go there, there's no
> point being optimistic about the last dcache lookup, nevermind trying
> to retry the parent pathwalk if we fail with -ESTALE doing it.
>
> I'm not saying that it's something worth optimizing for; the problem
> is different - the logics makes no sense whatsoever that way.  It's
> a matter of reader's cycles wasted on "what the fuck are we trying
> to do here?", not the CPU cycles wasted on execution.
>
> While we are at it, it makes no sense for filename_parentat() and its
> ilk to go for RCU and normal if it's been given LOOKUP_REVAL - I mean,
> look at the sequence of calls in there.  And try to make sense of
> it.  Especially of the "OK, RCU attempt told us to sod off and try normal;
> here, let's call path_parentat() with LOOKUP_REVAL for flags and if it
> says -ESTALE, call it again with exact same arguments" part.
>
> Seriously, look at that from the point of view of somebody who tries
> to make sense of the entire thing

OK, let me try to venture down that "change the way ESTALE retries are
done completely" path. The problem here is I'm not familiar with the
code enough to be sure the conversion is 1-to-1 (i.e. that we can't get
ESTALE from somewhere unexpected), and that retries are open-coded in
quite a few places it seems. Anyway, I'll try and dig in and come back
with either an RFC patch or some questions. Thanks for the feedback, Al.

-- 
Dmitry Kadashev
