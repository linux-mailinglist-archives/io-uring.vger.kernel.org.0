Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE1E7A0DD5
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 21:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjINTJD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 15:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjINTJC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 15:09:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 149711FC7
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 12:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694718493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lUkBtpL09XaDl93SQFkhLqqXYE3XGI2pnQvdUgh6xTY=;
        b=FZH+LnIfrQMJV2TJbqsoARlzEdl/U+eI3sju68sGWnjntX6cWbLA/oV1O2S6bMZ84we5u8
        IDBJNM9GoRxy4XIBMOpUE4WujUhNdBcYDvKOiutabZoG7119gCMvk7+ERW7IY4JY6IMviQ
        TuF/ZoeiUaS7GVGbl3MLo50qHL3O/4Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-eO4oN72AMvun9-4vsT8cpg-1; Thu, 14 Sep 2023 15:06:05 -0400
X-MC-Unique: eO4oN72AMvun9-4vsT8cpg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DBC1800D8E;
        Thu, 14 Sep 2023 19:06:05 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D3A440F2D2C;
        Thu, 14 Sep 2023 19:06:05 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Pierre Labat <plabat@micron.com>
Cc:     'Jens Axboe' <axboe@kernel.dk>,
        "'io-uring\@vger.kernel.org'" <io-uring@vger.kernel.org>
Subject: Re: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
References: <SJ0PR08MB6494F5A32B7C60A5AD8B33C2AB09A@SJ0PR08MB6494.namprd08.prod.outlook.com>
        <x49pm3y4nq5.fsf@segfault.boston.devel.redhat.com>
        <65911cc1-5b3f-ff5f-fe07-2f5c7a9c3533@kernel.dk>
        <SJ0PR08MB649422919BA3E86C48E83340AB12A@SJ0PR08MB6494.namprd08.prod.outlook.com>
        <x49o7jg2l4c.fsf@segfault.boston.devel.redhat.com>
        <SJ0PR08MB6494678810F31652FA65854CAB17A@SJ0PR08MB6494.namprd08.prod.outlook.com>
        <SJ0PR08MB64949350D2580D27863FBFDFABE7A@SJ0PR08MB6494.namprd08.prod.outlook.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 14 Sep 2023 15:11:49 -0400
In-Reply-To: <SJ0PR08MB64949350D2580D27863FBFDFABE7A@SJ0PR08MB6494.namprd08.prod.outlook.com>
        (Pierre Labat's message of "Tue, 29 Aug 2023 21:54:42 +0000")
Message-ID: <x49r0n04lje.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--=-=-=
Content-Type: text/plain

Pierre Labat <plabat@micron.com> writes:

> Hi,
>
> Had some time to re-do some testing.
>
> 1) Pipewire (its wireplumber deamon) set a watch on the children of the directory /dev via inotify.
> I removed that (disabled pipewire), but still had the fsnotify
> overhead when using aio/io_ring at high IOPS across several threads on
> several cores.
>
> 2) I then noticed that udev set a watch (via inotify) on the files in /dev.
> This is due to a rule in /usr/lib/udev/rules.d/60-block.rules
> # watch metadata changes, caused by tools closing the device node which was opened for writing
> ACTION!="remove", SUBSYSTEM=="block", \
>   KERNEL=="loop*|mmcblk*[0-9]|msblk*[0-9]|mspblk*[0-9]|nvme*|sd*|vd*|xvd*|bcache*|cciss*|dasd*|ubd*|ubi*|scm*|pmem*|nbd*|zd*",
> \
>   OPTIONS+="watch"
> I removed "nvme*" from this rule (I am testing on /dev/nvme0n1), then finally the fsnotify overhead disappeared.

Interesting.  I don't see that behavior.  I setup a null block device
with the following parameters:

modprobe null_blk submit_queues=96 queue_mode=2 gb=350 bs=4096 completion_nsec=0 hw_queue_depth=1024

And I ran the following fio job:

---
[global]
ioengine=io_uring
iodepth=8
direct=1
rw=read
filename=/dev/nullb0
cpus_allowed=0-95
cpus_allowed_policy=split
size=1g
offset_increment=10g

[32thread]
numjobs=32
---

If there are no watches on /dev or /dev/nullb0, then I see 70-79GiB/s
throughput from this job.  If I add a watch on /dev/nullb0, there
appears to be a small performance hit, but it is within the run-to-run
variation.  If I instead add a watch to /dev, the throughput drops to
~10GiB/s.  So, I think this matches your initial report (the perf top
output closely matched yours).

Can you run the attached script to verify that nothing is watching /dev
when you have udev configured to watch the nvme device, and report back?
Run it with the path as the argument, so "inotify-watchers.sh /dev".
If there is no watch on /dev, and you still see a performance problem,
then we'll need to start investigating that.  A good starting point
would be details of how you are testing, along with new perf top output.

-Jeff

> 3) I think there is nothing wrong with Pipewire and udev, they simply want to watch what is going on in /dev.
> I don't think they are interested in (and it is not the goal/charter
> of fsnotify) quantifying millions of read/write accesses/sec to a file
> they watch. There are other tools for that, that are optimized for
> that task.
>
> I think to avoid the overhead, the fsnotify subsystem should be
> refined to factor high frequency read/write file access.
> Or piece of code (like aio/io_uring) doing high frequency fsnotify should do the factoring themselves.
> Or the user should be given a way to turn off fsnotify calls for read/write on specific file.
> Now, the only way to work around the cpu overhead without hacking, is
> to disable services watching /dev.  That means people can't use these
> services anymore. Doesn't seem right.
>
> Regards,
>
> Pierre
>
>
>> -----Original Message-----
>> From: Pierre Labat
>> Sent: Monday, August 14, 2023 9:31 AM
>> To: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Jens Axboe <axboe@kernel.dk>; 'io-uring@vger.kernel.org' <io-
>> uring@vger.kernel.org>
>> Subject: RE: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
>> 
>> Hi Jeff,
>> 
>> Indeed, by default, in my configuration, pipewire is running.
>> When I can re-test, I'll disabled it and see if that remove the problem.
>> Thanks for the hint!
>> 
>> Pierre
>> 
>> > -----Original Message-----
>> > From: Jeff Moyer <jmoyer@redhat.com>
>> > Sent: Wednesday, August 9, 2023 10:15 AM
>> > To: Pierre Labat <plabat@micron.com>
>> > Cc: Jens Axboe <axboe@kernel.dk>; 'io-uring@vger.kernel.org' <io-
>> > uring@vger.kernel.org>
>> > Subject: Re: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
>> >
>> > CAUTION: EXTERNAL EMAIL. Do not click links or open attachments unless
>> > you recognize the sender and were expecting this message.
>> >
>> >
>> > Pierre Labat <plabat@micron.com> writes:
>> >
>> > > Micron Confidential
>> > >
>> > > Hi Jeff and Jens,
>> > >
>> > > About "FAN_MODIFY fsnotify watch set on /dev".
>> > >
>> > > Was using Fedora34 distro (with 6.3.9 kernel), and fio. Without any
>> > particular/specific setting.
>> > > I tried to see what could watch /dev but failed at that.
>> > > I used the inotify-info tool, but that display watchers using the
>> > > inotify interface. And nothing was watching /dev via inotify.
>> > > Need to figure out how to do the same but for the fanotify interface.
>> > > I'll look at it again and let you know.
>> >
>> > You wouldn't happen to be running pipewire, would you?
>> >
>> > https://urldefense.com/v3/__https://gitlab.freedesktop.org/pipewire/pi
>> > pewir
>> > e/-
>> > /commit/88f0dbd6fcd0a412fc4bece22afdc3ba0151e4cf__;!!KZTdOCjhgt4hgw!6E
>> > 063jj
>> > -_XK1NceWzms7DaYacILy4cKmeNVA3xalNwkd0zrYTX-IouUnvJ8bZs-RG3YSdk5XpFoo$
>> >
>> > -Jeff
>> >
>> > >
>> > > Regards,
>> > >
>> > > Pierre
>> > >
>> > >
>> > >
>> > > Micron Confidential
>> > >> -----Original Message-----
>> > >> From: Jens Axboe <axboe@kernel.dk>
>> > >> Sent: Tuesday, August 8, 2023 2:41 PM
>> > >> To: Jeff Moyer <jmoyer@redhat.com>; Pierre Labat
>> > >> <plabat@micron.com>
>> > >> Cc: 'io-uring@vger.kernel.org' <io-uring@vger.kernel.org>
>> > >> Subject: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
>> > >>
>> > >> CAUTION: EXTERNAL EMAIL. Do not click links or open attachments
>> > >> unless you recognize the sender and were expecting this message.
>> > >>
>> > >>
>> > >> On 8/7/23 2:11?PM, Jeff Moyer wrote:
>> > >> > Hi, Pierre,
>> > >> >
>> > >> > Pierre Labat <plabat@micron.com> writes:
>> > >> >
>> > >> >> Hi,
>> > >> >>
>> > >> >> This is FYI, may be you already knows about that, but in case
>> > >> >> you
>> > >> don't....
>> > >> >>
>> > >> >> I was pushing the limit of the number of nvme read IOPS, the FIO
>> > >> >> + the Linux OS can handle. For that, I have something special
>> > >> >> under the Linux nvme driver. As a consequence I am not limited
>> > >> >> by whatever the NVME SSD max IOPS or IO latency would be.
>> > >> >>
>> > >> >> As I cranked the number of system cores and FIO jobs doing
>> > >> >> direct 4k random read on /dev/nvme0n1, I hit a wall. The IOPS
>> > >> >> scaling slows (less than linear) and around 15 FIO jobs on 15
>> > >> >> core threads, the overall IOPS, in fact, goes down as I add more
>> > >> >> FIO jobs. For example on a system with 24 cores/48 threads, when
>> > >> >> I goes beyond 15 FIO jobs, the overall IOPS starts to go down.
>> > >> >>
>> > >> >> This happens the same for io_uring and aio. Was using kernel
>> > >> >> version
>> > >> 6.3.9. Using one namespace (/dev/nvme0n1).
>> > >> >
>> > >> > [snip]
>> > >> >
>> > >> >> As you can see 76% of the cpu on the box is sucked up by
>> > >> >> lockref_get_not_zero() and lockref_put_return().  Looking at the
>> > >> >> code, there is contention when IO_uring call fsnotify_access().
>> > >> >
>> > >> > Is there a FAN_MODIFY fsnotify watch set on /dev?  If so, it
>> > >> > might be a good idea to find out what set it and why.
>> > >>
>> > >> This would be my guess too, some distros do seem to do that. The
>> > >> notification bits scale horribly, nobody should use it for anything
>> > >> high performance...
>> > >>
>> > >> --
>> > >> Jens Axboe


--=-=-=
Content-Type: application/x-sh
Content-Disposition: attachment; filename=inotify-watchers.sh
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCmZpbGU9JDEKCnRhcmdldF9kZXY9JChzdGF0IC1jICIlRCIgJGZpbGUpCnRh
cmdldF9pbm9kZT0kKHN0YXQgLWMgIiVpIiAkZmlsZSkKCmZ1bmN0aW9uIGRlY3RvaGV4KCkKewoJ
aGV4PSQxCgoJZWNobyAiaWJhc2U9MTY7b2Jhc2U9QTske2hleF5efSIgfCBiYwp9Cgpmb3IgcHJv
Y2RpciBpbiAkKGZpbmQgL3Byb2MgLW1heGRlcHRoIDEgLXJlZ2V4ICIvcHJvYy9bMC05XSsiIC1w
cmludCk7IGRvCglmb3IgZmQgaW4gJChscyAkcHJvY2Rpci9mZC8gMj4vZGV2L251bGwpOyBkbwoJ
CWlmIFsgIiQocmVhZGxpbmsgJHByb2NkaXIvZmQvJGZkKSIgIT0gImFub25faW5vZGU6aW5vdGlm
eSIgXTsgdGhlbgoJCQljb250aW51ZTsKCQlmaQoJCWlub3RpZnk9JChncmVwICJpbm90aWZ5IiAk
cHJvY2Rpci9mZGluZm8vJGZkKQoJCWRldj0kKGVjaG8gJGlub3RpZnkgfCBzZWQgLWUgJ3MvLipz
ZGV2OlwoWzAtOUEtRmEtZl1cK1wpLiokL1wxL2cnKQoJCWlmIFsgIiRkZXYiICE9ICIkdGFyZ2V0
X2RldiIgXTsgdGhlbgoJCQljb250aW51ZTsKCQlmaQoJCWlub2RlPSQoZWNobyAkaW5vdGlmeSB8
IHNlZCAtZSAncy8uKmlubzpcKFswLTlBLUZhLWZdXCtcKS4qJC9cMS9nJykKCQlpbm9kZT0kKGRl
Y3RvaGV4ICRpbm9kZSkKCQlpZiBbICIkaW5vZGUiICE9ICIkdGFyZ2V0X2lub2RlIiBdOyB0aGVu
CgkJCWNvbnRpbnVlOwoJCWZpCgoJCSMgZm91bmQgb25lCgkJZWNobyAtbiAiYWN0aXZlIGlub3Rp
Znkgd2F0Y2ggb24gJGZpbGUgYnkgIgoJCWNhdCAkcHJvY2Rpci9jb21tCglkb25lCmRvbmUK
--=-=-=--

