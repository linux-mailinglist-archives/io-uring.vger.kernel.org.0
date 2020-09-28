Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2766127B4E5
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 20:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgI1S6k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 14:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgI1S6k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 14:58:40 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142AEC061755;
        Mon, 28 Sep 2020 11:58:40 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d4so2169938wmd.5;
        Mon, 28 Sep 2020 11:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qzLx+ktMPVhQAktjSFRBaXH0o66/8M0vKBETAdf1Yx4=;
        b=RYjU8DFGC3OKNRooUCoAsNT82Ecoc3NppLjTMfL3psheFuIc2gxNhNsy9kGyOSpsxe
         XkbyCfc6wdtuRVKVzZBlgdr5Hb3R4QiVZKlg8VUfDpYvSFQc9P8gIv0NDjkbH6BOSD6l
         /HpHbj0scL9/CIEc8UI0zMmlVHzd7TAtmoviJ1wlBQPJT/S0+bay2Sjpo4QYLhzYwh+3
         nI4RyguxXOCD2pHc4MYHY+7p3p0wjm9FEod+wE2JE2gZcyDnZmT3y0B9q0TZ8aQ+P9sM
         K+xyknUeZDn1qoc/nrQVRgT2rvBGzdkzSGQs9aiti1mev+azxSxrx1RcbByRAKlaO0TM
         OnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qzLx+ktMPVhQAktjSFRBaXH0o66/8M0vKBETAdf1Yx4=;
        b=gdhcab2bUgprb1aIjI60m0/1pqVKWCHCczDAQVuL9JKjfQDlFh/dohQ6HmlpttsaYo
         eScPit074XmBlSashv/0/ke1cP6diLSWo9lYAjnzx4c1gUhnDkgCEMS3jtvojBXwBP1/
         cBAmcr1guz1GDSZdzgq4IGCGgI7HtMnChixIlIAI/ncBFpdnQRfaInIKTu/MjbENJ4lD
         JsDom4yUuqQL/9YJRqB3e5esKrAMYaE/uT1hm4PntoSvuvPnHEd283qIpzXNb5YwBgL4
         BrYFUkSbCxgaGa9RbQt3btniiysAX+ljWA5khRISjPVdSum+QjzYuEtqen+c1ojbqiPI
         cawA==
X-Gm-Message-State: AOAM532u/A0eACD/pvKhzo+Tvcr44lRskSaCJgtMenLBmyz8sTmioDt9
        bAGDKWMidepzZtvy3NsacQYyhBbiDpmgutoaW6s=
X-Google-Smtp-Source: ABdhPJxfvtSw/ZhL8NlA6HZcJ6dh91x4IhK4/Mxt/FgbMU2pzQdY4fBuBDZ7RHTYnZNdn803D/7Osnd3Adxo91wuQ/o=
X-Received: by 2002:a7b:c1d9:: with SMTP id a25mr636586wmj.4.1601319518619;
 Mon, 28 Sep 2020 11:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org> <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org> <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org> <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org> <CA+1E3r+WXC_MK5Zf2OZEv17ddJDjtXbhpRFoeDns4F341xMhow@mail.gmail.com>
 <20200908151801.GA16742@infradead.org> <CA+1E3r+MSEW=-SL8L+pquq+cFAu+nQOULQ+HZoQsCvdjKMkrNw@mail.gmail.com>
 <MWHPR04MB3758A78AFAED3543F8D38266E7360@MWHPR04MB3758.namprd04.prod.outlook.com>
In-Reply-To: <MWHPR04MB3758A78AFAED3543F8D38266E7360@MWHPR04MB3758.namprd04.prod.outlook.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 29 Sep 2020 00:28:12 +0530
Message-ID: <CA+1E3rJANOsPOzjtJHSViVMq+Uc-sB0iZoExxBG++v2ghaL4uA@mail.gmail.com>
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

On Fri, Sep 25, 2020 at 8:22 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2020/09/25 2:20, Kanchan Joshi wrote:
> > On Tue, Sep 8, 2020 at 8:48 PM hch@infradead.org <hch@infradead.org> wrote:
> >>
> >> On Mon, Sep 07, 2020 at 12:31:42PM +0530, Kanchan Joshi wrote:
> >>> But there are use-cases which benefit from supporting zone-append on
> >>> raw block-dev path.
> >>> Certain user-space log-structured/cow FS/DB will use the device that
> >>> way. Aerospike is one example.
> >>> Pass-through is synchronous, and we lose the ability to use io-uring.
> >>
> >> So use zonefs, which is designed exactly for that use case.
> >
> > Not specific to zone-append, but in general it may not be good to lock
> > new features/interfaces to ZoneFS alone, given that direct-block
> > interface has its own merits.
> > Mapping one file to a one zone is good for some use-cases, but
> > limiting for others.
> > Some user-space FS/DBs would be more efficient (less meta, indirection)
> > with the freedom to decide file-to-zone mapping/placement.
>
> There is no metadata in zonefs. One file == one zone and the mapping between
> zonefs files and zones is static, determined at mount time simply using report
> zones. Zonefs files cannot be renamed nor deleted in anyway. Choosing a zonefs
> file *is* the same as choosing a zone. Zonfes is *not* a POSIX file system doing
> dynamic block allocation to files. The backing storage of files in zonefs is
> static and fixed to the zone they represent. The difference between zonefs vs
> raw zoned block device is the API that has to be used by the application, that
> is, file descriptor representing the entire disk for raw disk vs file descriptor
> representing one zone in zonefs. Note that the later has *a lot* of advantages
> over the former: enables O_APPEND use, protects against bugs with user write
> offsets mistakes, adds consistency of cached data against zone resets, and more.
>
> > - Rocksdb and those LSM style DBs would map SSTable to zone, but
> > SSTable file may be two small (initially) and may become too large
> > (after compaction) for a zone.
>
> You are contradicting yourself here. If a SSTable is mapped to a zone, then its
> size cannot exceed the zone capacity, regardless of the interface used to access
> the zones. And except for L0 tables which can be smaller (and are in memory
> anyway), all levels tables have the same maximum size, which for zoned drives
> must be the zone capacity. In any case, solving any problem in this area does
> not depend in any way on zonefs vs raw disk interface. The implementation will
> differ depending on the chosen interface, but what needs to be done to map
> SSTables to zones is the same in both cases.
>
> > - The internal parallelism of a single zone is a design-choice, and
> > depends on the drive. Writing multiple zones parallely (striped/raid
> > way) can give better performance than writing on one. In that case one
> > would want to file that seamlessly combines multiple-zones in a
> > striped fashion.
>
> Then write a FS for that... Or have a library do it in user space. For the
> library case, the implementation will differ for zonefs vs raw disk due to the
> different API (regular file vs block devicer file), but the principles to follow
> for stripping zones into a single storage object remain the same.

ZoneFS is better when it is about dealing at single-zone granularity,
and direct-block seems better when it is about grouping zones (in
various ways including striping). The latter case (i.e. grouping
zones) requires more involved mapping, and I agree that it can be left
to application (for both ZoneFS and raw-block backends).
But when an application tries that on ZoneFS, apart from mapping there
would be additional cost of indirection/fd-management (due to
file-on-files).
And if new features (zone-append for now) are available only on
ZoneFS, it forces application to use something that maynot be most
optimal for its need.

Coming to the original problem of plumbing append - I think divergence
started because RWF_APPEND did not have any meaning for block device.
Did I miss any other reason?
How about write-anywhere semantics (RWF_RELAXED_WRITE or
RWF_ANONYMOUS_WRITE flag) on block-dev.
Zone-append works a lot like write-anywhere on block-dev (or on any
other file that combines multiple-zones, in non-sequential fashion).

> > Also it seems difficult (compared to block dev) to fit simple-copy TP
> > in ZoneFS. The new
> > command needs: one NVMe drive, list of source LBAs and one destination
> > LBA. In ZoneFS, we would deal with N+1 file-descriptors (N source zone
> > file, and one destination zone file) for that. While with block
> > interface, we do not need  more than one file-descriptor representing
> > the entire device. With more zone-files, we face open/close overhead too.
>
> Are you expecting simple-copy to allow requests that are not zone aligned ? I do
> not think that will ever happen. Otherwise, the gotcha cases for it would be far
> too numerous. Simple-copy is essentially an optimized regular write command.
> Similarly to that command, it will not allow copies over zone boundaries and
> will need the destination LBA to be aligned to the destination zone WP. I have
> not checked the TP though and given the NVMe NDA, I will stop the discussion here.

TP is ratified, if that is the problem you are referring to.

> filesend() could be used as the interface for simple-copy. Implementing that in
> zonefs would not be that hard. What is your plan for simple-copy interface for
> raw block device ? An  ioctl ? filesend() too ? As as with any other user level
> API, we should not be restricted to a particular device type if we can avoid it,
> so in-kernel emulation of the feature is needed for devices that do not have
> simple-copy or scsi extended copy. filesend() seems to me like the best choice
> since all of that is already implemented there.

At this moment, ioctl as sync and io-uring for async. sendfile() and
copy_file_range() takes two fds....with that we can represent copy
from one source zone to another zone.
But it does not fit to represent larger copy (from N source zones to
one destination zone).
Not sure if I am clear, perhaps sending RFC would be better for
discussion on simple-copy.

> As for the open()/close() overhead for zonefs, may be some use cases may suffer
> from it, but my tests with LevelDB+zonefs did not show any significant
> difference. zonefs open()/close() operations are way faster than for a regular
> file system since there is no metadata and all inodes always exist in-memory.
> And zonefs() now supports MAR/MOR limits for O_WRONLY open(). That can simplify
> things for the user.
>
>
> --
> Damien Le Moal
> Western Digital Research



-- 
Joshi
