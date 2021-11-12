Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5CE44ED2F
	for <lists+io-uring@lfdr.de>; Fri, 12 Nov 2021 20:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhKLTWm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Nov 2021 14:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhKLTWl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Nov 2021 14:22:41 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9091AC061766;
        Fri, 12 Nov 2021 11:19:50 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id t30so17244934wra.10;
        Fri, 12 Nov 2021 11:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OJ7XG1dTJKk7nHZtLziR7Mxnn3Gu3SKVQ1z5PP5IYzw=;
        b=q7DKxufs3ny0SBMY5BPj0Iki3xXA4pUQY38EPt/AJCBsn91D6BosDtHzMTeRcDyI5u
         8p931nDDfQlf+iDgbPBddGO4QovTPeS+GGHkl+84uJDUjEpmZ4gwviiwHh2naMDoz0FH
         2BvXcd4TKSDQ9atkmnJRtza9E2B4vSqL7X6thBd4pTmCK4ZV9Hfmea5MEarso+FNc55k
         S9y78DdcNrrtFHuE2s2QOPA8PVYIxy4gUR4dCOEMUe7BfYdtJhOzyx7ii0odKa8OKE9Y
         zzGzMfsLz/b7FD9yVhTt+krJ4wrm9MYA/14F0RnDnIAbFzRsZnOV3qpAegGglinlzSeN
         PBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=OJ7XG1dTJKk7nHZtLziR7Mxnn3Gu3SKVQ1z5PP5IYzw=;
        b=U6Cl7IEWqLN+TtLAH9XFgWvZRpfME/WE7Wu2s8ivoL6lrjoHO94ZkEAFXqINtqx8hW
         JwbBnGU7obJjsrxtDjXyadnkQzKYTK6GOK5WInwwnHF3QxhG8LbgJkhWgV0tiLc1V7ky
         vRCLWtmREEcvQl32oVaQ1lGZfm+oOm/uT3+wlSDybhYaQDbB363PONI8h7EEH1KhM5nQ
         K5BJzwuVtdbdvko6yg0Extw9jrXWlocmseK/1Mbfpt8zLSXaaCJ6f63w29yvfIqEJYF3
         5hUEgAg95m8npgk8rPtupMBg32VmL0Auz8nNi1jzLWL6rodkP60BsRDdavySoNRtWSW1
         dnKw==
X-Gm-Message-State: AOAM532BKcoELQjO4tdU5P4Er73xXde2oGN2suhi/7RE98sHjBauqa1Z
        3K0SI/1yM0VdeejhiZp99ohroN7nLOH1JQ==
X-Google-Smtp-Source: ABdhPJwQZPeu/imivt3AZNAUJopcd35P252PMMJD/I4JhJdruImm8Bm+YIrloapUNlWhBxkE6rfyvA==
X-Received: by 2002:adf:d84c:: with SMTP id k12mr21324062wrl.24.1636744789121;
        Fri, 12 Nov 2021 11:19:49 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id j17sm7666326wmq.41.2021.11.12.11.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 11:19:48 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Fri, 12 Nov 2021 20:19:47 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Daniel Black <daniel@mariadb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: uring regression - lost write request
Message-ID: <YY6+Uxm+cV/Ji7XI@eldamar.lan>
References: <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
 <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
 <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk>
 <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
 <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
 <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
 <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
 <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk>
 <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
 <CABVffEOEayBow2Oot7_jNHbXL0CQq9SZCWmiWEJjbT6gVC7WKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABVffEOEayBow2Oot7_jNHbXL0CQq9SZCWmiWEJjbT6gVC7WKg@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Daniel,

On Fri, Nov 12, 2021 at 05:25:31PM +1100, Daniel Black wrote:
> On Fri, Nov 12, 2021 at 10:44 AM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 11/11/21 10:28 AM, Jens Axboe wrote:
> > > On 11/11/21 9:55 AM, Jens Axboe wrote:
> > >> On 11/11/21 9:19 AM, Jens Axboe wrote:
> > >>> On 11/11/21 8:29 AM, Jens Axboe wrote:
> > >>>> On 11/11/21 7:58 AM, Jens Axboe wrote:
> > >>>>> On 11/11/21 7:30 AM, Jens Axboe wrote:
> > >>>>>> On 11/10/21 11:52 PM, Daniel Black wrote:
> > >>>>>>>> Would it be possible to turn this into a full reproducer script?
> > >>>>>>>> Something that someone that knows nothing about mysqld/mariadb can just
> > >>>>>>>> run and have it reproduce. If I install the 10.6 packages from above,
> > >>>>>>>> then it doesn't seem to use io_uring or be linked against liburing.
> > >>>>>>>
> > >>>>>>> Sorry Jens.
> > >>>>>>>
> > >>>>>>> Hope containers are ok.
> > >>>>>>
> > >>>>>> Don't think I have a way to run that, don't even know what podman is
> > >>>>>> and nor does my distro. I'll google a bit and see if I can get this
> > >>>>>> running.
> > >>>>>>
> > >>>>>> I'm fine building from source and running from there, as long as I
> > >>>>>> know what to do. Would that make it any easier? It definitely would
> > >>>>>> for me :-)
> > >>>>>
> > >>>>> The podman approach seemed to work,
> 
> Thanks for bearing with it.
> 
> > >>>>> and I was able to run all three
> > >>>>> steps. Didn't see any hangs. I'm going to try again dropping down
> > >>>>> the innodb pool size (box only has 32G of RAM).
> > >>>>>
> > >>>>> The storage can do a lot more than 5k IOPS, I'm going to try ramping
> > >>>>> that up.
> 
> Good.
> 
> > >>>>>
> > >>>>> Does your reproducer box have multiple NUMA nodes, or is it a single
> > >>>>> socket/nod box?
> 
> It was NUMA. Pre 5.14.14 I could produce it on a simpler test on a single node.
> 
> > >>>>
> > >>>> Doesn't seem to reproduce for me on current -git. What file system are
> > >>>> you using?
> 
> Yes ext4.
> 
> > >>>
> > >>> I seem to be able to hit it with ext4, guessing it has more cases that
> > >>> punt to buffered IO. As I initially suspected, I think this is a race
> > >>> with buffered file write hashing. I have a debug patch that just turns
> > >>> a regular non-numa box into multi nodes, may or may not be needed be
> > >>> needed to hit this, but I definitely can now. Looks like this:
> > >>>
> > >>> Node7 DUMP
> > >>> index=0, nr_w=1, max=128, r=0, f=1, h=0
> > >>>   w=ffff8f5e8b8470c0, hashed=1/0, flags=2
> > >>>   w=ffff8f5e95a9b8c0, hashed=1/0, flags=2
> > >>> index=1, nr_w=0, max=127877, r=0, f=0, h=0
> > >>> free_list
> > >>>   worker=ffff8f5eaf2e0540
> > >>> all_list
> > >>>   worker=ffff8f5eaf2e0540
> > >>>
> > >>> where we seed node7 in this case having two work items pending, but the
> > >>> worker state is stalled on hash.
> > >>>
> > >>> The hash logic was rewritten as part of the io-wq worker threads being
> > >>> changed for 5.11 iirc, which is why that was my initial suspicion here.
> > >>>
> > >>> I'll take a look at this and make a test patch. Looks like you are able
> > >>> to test self-built kernels, is that correct?
> 
> I've been libreating prebuilt kernels, however on the path to self-built again.
> 
> Just searching for the holy penguin pee (from yaboot da(ze|ys)) to
> peesign(sic) EFI kernels.
> jk, working through docs:
> https://docs.fedoraproject.org/en-US/quick-docs/kernel/build-custom-kernel/
> 
> > >> Can you try with this patch? It's against -git, but it will apply to
> > >> 5.15 as well.
> > >
> > > I think that one covered one potential gap, but I just managed to
> > > reproduce a stall even with it. So hang on testing that one, I'll send
> > > you something more complete when I have confidence in it.
> >
> > Alright, give this one a go if you can. Against -git, but will apply to
> > 5.15 as well.
> 
> Applied, built, attempting to boot....

If you want to do the same for Debian based system, the following
might help to get the package built:

https://kernel-team.pages.debian.net/kernel-handbook/ch-common-tasks.html#s4.2.2

I might be able to provide you otherwise a prebuild package with the
patch (unsigned though, but best if you built and test it directly)

Regards,
Salvatore
