Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C762D226C1A
	for <lists+io-uring@lfdr.de>; Mon, 20 Jul 2020 18:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbgGTQrA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 12:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730047AbgGTQq6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 12:46:58 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E18C0619D2;
        Mon, 20 Jul 2020 09:46:58 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o2so190224wmh.2;
        Mon, 20 Jul 2020 09:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9TUkabklxIXk2rG01tEVzaKI9h1RHrZIgtt3w/3l2iM=;
        b=cqgBjnypFa1cbeUeu4WKA3uvV4175XXicaesi3cB7HqFuZkvUS3EnOHeMfJwNpNlcu
         thvdafoSdEpu3CyPa0BvtB18a649D+XC6ajS63SeSnJp6XDu18WDcEJTK8klZNzdximZ
         VuENIM+1ZvbGer8HlSEIJ5nBBP/QCWiT36HTgRFZfhMl74u3ZylqJREsFY0Lwc7KPZfZ
         CVu19F0/MAN2L88oyFeatinyVCcE8rFRVB0KHI7TQT2a/Fv/pRVO9FMOnNYPgoKZVlO4
         hlQqnmp+3KYZ9wrW6RC9f04lVmriNZKKST63JfVFty4Y9voY7HrmjAKp9hJlI1COu6AR
         TYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9TUkabklxIXk2rG01tEVzaKI9h1RHrZIgtt3w/3l2iM=;
        b=mt66boa/ILERyE81gMU+dgOyJczfAxN2dRToEms2isikkt+Xn2W9qrRxu1gCh6AJQd
         BhFCxp4UeoW+LWcyW5gkyj6DiOOYTnJytApYVsVF9gLMpa4OxLPvRWz1rWH7SIOgJK0/
         gFV+NlnsFV+7uZ2jhd4XGEnDeTLpFzvtPQpfCc6H7vFeVVoeCvBaCfGDIPR37uK3aO44
         8EW/h7C6YPu0n+BcETWiNEd9Ba5EEg6TSf7zXcWpGKnswD5zo3xo0Y5nAVhlVkPwgtIc
         2rxhoRrRqHKm23xGTwv+ashf5mBGr1ZRi/Fnncpg5QnMplnkKzB4ObNCjOOAN4Tf8PKh
         wCMw==
X-Gm-Message-State: AOAM531dngUaN1OfmoLCkbp8t5koWX0m9sF7/5/WQx75M9CRkNBmcFbj
        NBJx7ytNfpR16KrYM3nkbM39RKwi1tQUrdYvXyg=
X-Google-Smtp-Source: ABdhPJwHnWafr2ui/E9BQNR1LWn8VA0FKZgs+fhoDxBR6hA5H0uc44yL3f5SpS8O04T80tEL381rAROIPtdr1Fbg7hY=
X-Received: by 2002:a1c:2485:: with SMTP id k127mr220540wmk.138.1595263616571;
 Mon, 20 Jul 2020 09:46:56 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com> <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org> <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org> <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk> <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org> <9e870249-01db-c68d-ea65-28edc3c1f071@kernel.dk>
In-Reply-To: <9e870249-01db-c68d-ea65-28edc3c1f071@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 20 Jul 2020 22:16:28 +0530
Message-ID: <CA+1E3rK9LCmB4Lt8hTLrCx7bXaF6sETWgm=M6=D6grOnGSgiRQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, "Matias Bj??rling" <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 7:39 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/10/20 7:10 AM, Christoph Hellwig wrote:
> > On Fri, Jul 10, 2020 at 12:35:43AM +0530, Kanchan Joshi wrote:
> >> Append required special treatment (conversion for sector to bytes) for io_uring.
> >> And we were planning a user-space wrapper to abstract that.
> >>
> >> But good part (as it seems now) was: append result went along with cflags at
> >> virtually no additional cost. And uring code changes became super clean/minimal
> >> with further revisions.
> >> While indirect-offset requires doing allocation/mgmt in application,
> >> io-uring submission
> >> and in completion path (which seems trickier), and those CQE flags
> >> still get written
> >> user-space and serve no purpose for append-write.
> >
> > I have to say that storing the results in the CQE generally make
> > so much more sense.  I wonder if we need a per-fd "large CGE" flag
> > that adds two extra u64s to the CQE, and some ops just require this
> > version.
>
> I have been pondering the same thing, we could make certain ops consume
> two CQEs if it makes sense. It's a bit ugly on the app side with two
> different CQEs for a request, though. We can't just treat it as a large
> CQE, as they might not be sequential if we happen to wrap. But maybe
> it's not too bad.

Did some work on the two-cqe scheme for zone-append.
First CQE is the same (as before), while second CQE does not keep
res/flags and instead has 64bit result to report append-location.
It would look like this -

struct io_uring_cqe {
        __u64   user_data;      /* sqe->data submission passed back */
-       __s32   res;            /* result code for this event */
-       __u32   flags;
+       union {
+               struct {
+                       __s32   res;            /* result code for this event */
+                       __u32   flags;
+               };
+               __u64   append_res;   /*only used for append, in
secondary cqe */
+       };

And kernel will produce two CQEs for append completion-

static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
{
-       struct io_uring_cqe *cqe;
+       struct io_uring_cqe *cqe, *cqe2 = NULL;

-       cqe = io_get_cqring(ctx);
+       if (unlikely(req->flags & REQ_F_ZONE_APPEND))
+ /* obtain two CQEs for append. NULL if two CQEs are not available */
+               cqe = io_get_two_cqring(ctx, &cqe2);
+       else
+               cqe = io_get_cqring(ctx);
+
        if (likely(cqe)) {
                WRITE_ONCE(cqe->user_data, req->user_data);
                WRITE_ONCE(cqe->res, res);
                WRITE_ONCE(cqe->flags, cflags);
+               /* update secondary cqe for zone-append */
+               if (req->flags & REQ_F_ZONE_APPEND) {
+                       WRITE_ONCE(cqe2->append_res,
+                               (u64)req->append_offset << SECTOR_SHIFT);
+                       WRITE_ONCE(cqe2->user_data, req->user_data);
+               }
  mutex_unlock(&ctx->uring_lock);


This seems to go fine in Kernel.
But the application will have few differences such as:

- When it submits N appends, and decides to wait for all completions
it needs to specify min_complete as 2*N (or at least 2N-1).
Two appends will produce 4 completion events, and if application
decides to wait for both it must specify 4 (or 3).

io_uring_enter(unsigned int fd, unsigned int to_submit,
                   unsigned int min_complete, unsigned int flags,
                   sigset_t *sig);

- Completion-processing sequence for mixed-workload (few reads + few
appends, on the same ring).
Currently there is a one-to-one relationship. Application looks at N
CQE entries, and treats each as distinct IO completion - a for loop
does the work.
With two-cqe scheme, extracting, from a bunch of completion, the ones
for read (one cqe) and append (two cqe): flow gets somewhat
non-linear.

Perhaps this is not too bad, but felt that it must be put here upfront.

-- 
Kanchan Joshi
