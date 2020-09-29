Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B8827D621
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 20:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbgI2SuU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Sep 2020 14:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbgI2SuU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Sep 2020 14:50:20 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A36C061755;
        Tue, 29 Sep 2020 11:50:19 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a9so5934013wmm.2;
        Tue, 29 Sep 2020 11:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNJt0onxUCMMWKtijmk+/s8cyxgaUUUU8TxKJdwf3SE=;
        b=cbwaulEbECRgKujM4oD1rf0dCUjcvQwj44icbxaZj16EEQYFnJyKiq8iQTXjNOwyp4
         LtgFhMITHjjy/fcDH6pInueGam6oN5dGo/8HjsOg0i56d9TVQ5VG57IaLyXC6XOqQyEw
         fkDvE+VZZVRqBCT2SxIcp8s/HA+bHH4ftsu33Sm//L7Rmw482kt8KrgfBJV5Psy+QKy2
         v8ThzZbWWkQ6qHlyVK+k1uwRprMQqq1uKM4pVnsTQ7hjcCKDphwvaH6/rtIGwJnYsg+b
         DZZZetaRcigJWRrwMrzesxGEF4lQFNYvZmuh7o2KDW8h+EZgYQxt5Mu921Pbf+d1Vnzj
         YcDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNJt0onxUCMMWKtijmk+/s8cyxgaUUUU8TxKJdwf3SE=;
        b=O42AEmq3xp0HiNMA/xWJXV01+mOQlwDnqFzaHScDpc2Dq0ewr8WtMN0e2kg3m+4Dfy
         vq1APfYL5i2KpzI/tfs1iSm+wy9e8ws3NB8c30lyeuLBol0O0GKErI0J2pgzMpG2E7Ac
         /XdvhfAJM6yzyBEln831bpOkw0YbuGuxKHSEVrk4Ds6WnRYVVatSLD8XVwnSIyM7nyjF
         VtksB0YKaGIwQ5EL5r4lLgubK/PC7AKSMgbikTHE9KPRsgY/wmce0kYlbzaZPwM9nXnd
         PFXfgAdpH+PZl4Ej9AaNROdGSZjwZTIGhQt3UEsmegtpaF/jnAE6AnNiougdMEcXCLAj
         co5A==
X-Gm-Message-State: AOAM532qBrTg+5ar26m3gA40Fv0ABllFBO12RfutuUg8n+413EsFRitQ
        NvFDCekvDLcjZt32kCQFjPygqGtzi5Ob2SJ2qijSViWBgmB3Dhci0Ps=
X-Google-Smtp-Source: ABdhPJzezBrVB5Ar4cx8TTLyBXFwiu0GkZxAui4OWx8hKqwZIcIr8sD2S6eevw4SDX0J8JdbVOFIY6lm9+ShrQrQ5Ec=
X-Received: by 2002:a1c:dfc2:: with SMTP id w185mr5904005wmg.15.1601405418221;
 Tue, 29 Sep 2020 11:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org> <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org> <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org> <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org> <CA+1E3r+WXC_MK5Zf2OZEv17ddJDjtXbhpRFoeDns4F341xMhow@mail.gmail.com>
 <20200908151801.GA16742@infradead.org> <CA+1E3r+MSEW=-SL8L+pquq+cFAu+nQOULQ+HZoQsCvdjKMkrNw@mail.gmail.com>
 <MWHPR04MB3758A78AFAED3543F8D38266E7360@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rJANOsPOzjtJHSViVMq+Uc-sB0iZoExxBG++v2ghaL4uA@mail.gmail.com> <CY4PR04MB3751BFF86D1F7F1D22A143E6E7320@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR04MB3751BFF86D1F7F1D22A143E6E7320@CY4PR04MB3751.namprd04.prod.outlook.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 30 Sep 2020 00:19:52 +0530
Message-ID: <CA+1E3rLXm6x-pivNiW=t0g=H0NnLTdz3NMKNV-d=ezPGr5i2Qg@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 29, 2020 at 6:54 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2020/09/29 3:58, Kanchan Joshi wrote:
> [...]
> > ZoneFS is better when it is about dealing at single-zone granularity,
> > and direct-block seems better when it is about grouping zones (in
> > various ways including striping). The latter case (i.e. grouping
> > zones) requires more involved mapping, and I agree that it can be left
> > to application (for both ZoneFS and raw-block backends).
> > But when an application tries that on ZoneFS, apart from mapping there
> > would be additional cost of indirection/fd-management (due to
> > file-on-files).
>
> There is no indirection in zonefs. fd-to-struct file/inode conversion is very
> fast and happens for every system call anyway, regardless of what the fd
> represents. So I really do not understand what your worry is here.

file-over-files.....if application (user-space FS/DB) has to place
file-abstraction over zonefs again, to group/map the zones in a
different manner (larger files, striped mapping etc.).
Imagine a file over say 4 zones.....with zonefs backend, application
will invoke kernel at least 4 times to open the fds. With raw-block
backend, these system calls won't be required in the first place.

> If you are
> worried about overhead/performance, then please show numbers. If something is
> wrong, we can work on fixing it.
>
> > And if new features (zone-append for now) are available only on
> > ZoneFS, it forces application to use something that maynot be most
> > optimal for its need.
>
> "may" is not enough to convince me...
>
> > Coming to the original problem of plumbing append - I think divergence
> > started because RWF_APPEND did not have any meaning for block device.
> > Did I miss any other reason?
>
> Correct.
>
> > How about write-anywhere semantics (RWF_RELAXED_WRITE or
> > RWF_ANONYMOUS_WRITE flag) on block-dev.
>
> "write-anywhere" ? What do you mean ? That is not possible on zoned devices,
> even with zone append, since you at least need to guarantee that zones have
> enough unwritten space to accept an append command.
>
> > Zone-append works a lot like write-anywhere on block-dev (or on any
> > other file that combines multiple-zones, in non-sequential fashion).
>
> That is an over-simplification that is not helpful at all. Zone append is not
> "write anywhere" at all. And "write anywhere" is not a concept that exist on
> regular block devices anyway. Writes only go to the offset that the user
> decided, through lseek(), pwrite() or aio->aio_offset. It is not like the block
> layer decides where the writes land. The same constraint applies to zone append:
> the user decide the target zone. That is not "anywhere". Please be precise with
> wording and implied/desired semantic. Narrow down the scope of your concept
> names for clarity.

This -
<start>
Issue write on offset X with no flag, it happens at X.
Issue write on offset X with "anywhere" flag, it happens
anywhere....and application comes to know that on completion.
</start>
Above is fairly generic as far as high-level interface is concerned.
Return offset can be file-pointer or supplied-offset or something
completely different. If anywhere-flag is passed, the caller should
not assume anything and must explicitly check where write happened.
The "anywhere" part can be decided by the component that implements
the interface.
For zoned block dev,  this "anywhere" can come by issuing zone-append
underneath. Some other components are free to implement "anywhere" in
another way, or do nothing....in that case write continues to happen
at X.

For zoned raw-block, we have got an address-space that contains N
zones placed sequentially.
Write on offset O1 with anywhere flag: => The O1 is rounded-down to
zone-start (say Z1) by direct-io code, zone-append is issued on Z1,
and completion-offset O2 is returned.
write-anywhere on another offset O3 of address space => zone-start
could be Z2, and completion-offset O4 is returned.
Application picks completion offsets O3 and O4 and goes about its
business, not needing to know about Z1 or Z2.

> And talking about "file that combines multiple-zones" would mean that we are now
> back in FS land, not raw block device file accesses anymore. So which one are we
> talking about ?

About user-space FS/DB/SDS using zoned-storage, aiming optimized placement.
In all this discussion, I have been referring to ZoneFS and Raw-block
as backends for higher-level abstraction residing in user-space.

> It looks like you are confusing what the application does and
> how it uses whatever usable interface to the device with what that interface
> actually is. It is very confusing.
>
> >>> Also it seems difficult (compared to block dev) to fit simple-copy TP
> >>> in ZoneFS. The new
> >>> command needs: one NVMe drive, list of source LBAs and one destination
> >>> LBA. In ZoneFS, we would deal with N+1 file-descriptors (N source zone
> >>> file, and one destination zone file) for that. While with block
> >>> interface, we do not need  more than one file-descriptor representing
> >>> the entire device. With more zone-files, we face open/close overhead too.
> >>
> >> Are you expecting simple-copy to allow requests that are not zone aligned ? I do
> >> not think that will ever happen. Otherwise, the gotcha cases for it would be far
> >> too numerous. Simple-copy is essentially an optimized regular write command.
> >> Similarly to that command, it will not allow copies over zone boundaries and
> >> will need the destination LBA to be aligned to the destination zone WP. I have
> >> not checked the TP though and given the NVMe NDA, I will stop the discussion here.
> >
> > TP is ratified, if that is the problem you are referring to.
>
> Ah. Yes. Got confused with ZRWA. Simple-copy is a different story anyway. Let's
> not mix it into zone append user interface please.
>
> >
> >> filesend() could be used as the interface for simple-copy. Implementing that in
> >> zonefs would not be that hard. What is your plan for simple-copy interface for
> >> raw block device ? An  ioctl ? filesend() too ? As as with any other user level
> >> API, we should not be restricted to a particular device type if we can avoid it,
> >> so in-kernel emulation of the feature is needed for devices that do not have
> >> simple-copy or scsi extended copy. filesend() seems to me like the best choice
> >> since all of that is already implemented there.
> >
> > At this moment, ioctl as sync and io-uring for async. sendfile() and
> > copy_file_range() takes two fds....with that we can represent copy
> > from one source zone to another zone.
> > But it does not fit to represent larger copy (from N source zones to
> > one destination zone).
>
> nvme passthrough ? If that does not fit your use case, then think of an
> interface, its definition/semantic and propose it. But again, use a different
> thread. This is mixing up zone-append and simple copy, which I do not think are
> directly related.
>
> > Not sure if I am clear, perhaps sending RFC would be better for
> > discussion on simple-copy.
>
> Separate this discussion from zone append please. Mixing up 2 problems in one
> thread is not helpful to make progress.
Fine.


-- 
Joshi
