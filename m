Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C9A776625
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 19:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjHIRJ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 13:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbjHIRJ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 13:09:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A1A1FEF
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 10:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691600952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V0gIF2Tl+GEXOUled2HOUbrWDj5K5LDlIUjRN2O/S+s=;
        b=d6s8lSFfDug3UJEIo03ayZEDA5kd4KpXCIIH8VdwAy26UpS0/7D50MorZe/QDOEToIIdHE
        f/ujtLiTOVHTk7Cc6qVzRZfq5DBiF/BYD6zF6+AqDRjLAqa5KpVSFetk2/yQ13JlPKZCaL
        C2oC99F5/50dtDpyw9Iu2cEsvSsO5qk=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-A4K6FIXJPWiKgYWDWQUAfQ-1; Wed, 09 Aug 2023 13:09:11 -0400
X-MC-Unique: A4K6FIXJPWiKgYWDWQUAfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E9A11C07240;
        Wed,  9 Aug 2023 17:09:10 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BD3C140E96D;
        Wed,  9 Aug 2023 17:09:10 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Pierre Labat <plabat@micron.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "'io-uring\@vger.kernel.org'" <io-uring@vger.kernel.org>
Subject: Re: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
References: <SJ0PR08MB6494F5A32B7C60A5AD8B33C2AB09A@SJ0PR08MB6494.namprd08.prod.outlook.com>
        <x49pm3y4nq5.fsf@segfault.boston.devel.redhat.com>
        <65911cc1-5b3f-ff5f-fe07-2f5c7a9c3533@kernel.dk>
        <SJ0PR08MB649422919BA3E86C48E83340AB12A@SJ0PR08MB6494.namprd08.prod.outlook.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 09 Aug 2023 13:14:59 -0400
In-Reply-To: <SJ0PR08MB649422919BA3E86C48E83340AB12A@SJ0PR08MB6494.namprd08.prod.outlook.com>
        (Pierre Labat's message of "Wed, 9 Aug 2023 16:33:28 +0000")
Message-ID: <x49o7jg2l4c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pierre Labat <plabat@micron.com> writes:

> Micron Confidential
>
> Hi Jeff and Jens,
>
> About "FAN_MODIFY fsnotify watch set on /dev".
>
> Was using Fedora34 distro (with 6.3.9 kernel), and fio. Without any particular/specific setting.
> I tried to see what could watch /dev but failed at that.
> I used the inotify-info tool, but that display watchers using the
> inotify interface. And nothing was watching /dev via inotify.
> Need to figure out how to do the same but for the fanotify interface.
> I'll look at it again and let you know.

You wouldn't happen to be running pipewire, would you?

https://gitlab.freedesktop.org/pipewire/pipewire/-/commit/88f0dbd6fcd0a412fc4bece22afdc3ba0151e4cf

-Jeff

>
> Regards,
>
> Pierre
>
>
>
> Micron Confidential
>> -----Original Message-----
>> From: Jens Axboe <axboe@kernel.dk>
>> Sent: Tuesday, August 8, 2023 2:41 PM
>> To: Jeff Moyer <jmoyer@redhat.com>; Pierre Labat <plabat@micron.com>
>> Cc: 'io-uring@vger.kernel.org' <io-uring@vger.kernel.org>
>> Subject: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
>>
>> CAUTION: EXTERNAL EMAIL. Do not click links or open attachments unless you
>> recognize the sender and were expecting this message.
>>
>>
>> On 8/7/23 2:11?PM, Jeff Moyer wrote:
>> > Hi, Pierre,
>> >
>> > Pierre Labat <plabat@micron.com> writes:
>> >
>> >> Hi,
>> >>
>> >> This is FYI, may be you already knows about that, but in case you
>> don't....
>> >>
>> >> I was pushing the limit of the number of nvme read IOPS, the FIO +
>> >> the Linux OS can handle. For that, I have something special under the
>> >> Linux nvme driver. As a consequence I am not limited by whatever the
>> >> NVME SSD max IOPS or IO latency would be.
>> >>
>> >> As I cranked the number of system cores and FIO jobs doing direct 4k
>> >> random read on /dev/nvme0n1, I hit a wall. The IOPS scaling slows
>> >> (less than linear) and around 15 FIO jobs on 15 core threads, the
>> >> overall IOPS, in fact, goes down as I add more FIO jobs. For example
>> >> on a system with 24 cores/48 threads, when I goes beyond 15 FIO jobs,
>> >> the overall IOPS starts to go down.
>> >>
>> >> This happens the same for io_uring and aio. Was using kernel version
>> 6.3.9. Using one namespace (/dev/nvme0n1).
>> >
>> > [snip]
>> >
>> >> As you can see 76% of the cpu on the box is sucked up by
>> >> lockref_get_not_zero() and lockref_put_return().  Looking at the
>> >> code, there is contention when IO_uring call fsnotify_access().
>> >
>> > Is there a FAN_MODIFY fsnotify watch set on /dev?  If so, it might be
>> > a good idea to find out what set it and why.
>>
>> This would be my guess too, some distros do seem to do that. The
>> notification bits scale horribly, nobody should use it for anything high
>> performance...
>>
>> --
>> Jens Axboe

