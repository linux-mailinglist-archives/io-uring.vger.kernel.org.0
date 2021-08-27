Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE3C3F9A56
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbhH0NhE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 09:37:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232417AbhH0NhD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 09:37:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630071374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/NIYyavBh8XnOVQ6CtLDeu7aH39KozHfLZib7zDJx5I=;
        b=ZbGngYsvRCvRP1wWmmr+1DGgZerdvd4RG/PchQI3zP9seNJBmeWtkjfUR1tBDxG7O3MVdi
        LyFIHGUkbW3hR2hb/GEG3W6fVXWF9c6SzAwdajD4awmVU7qTjE0Q9IDdTxFYj6gsf8y7m8
        gaS4Agr1Lau3ONJ2/XeIBipzkS8I8Hc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-kuszwh0aNLGhF1LuDxAjYg-1; Fri, 27 Aug 2021 09:36:11 -0400
X-MC-Unique: kuszwh0aNLGhF1LuDxAjYg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E63E8190B2A3;
        Fri, 27 Aug 2021 13:36:09 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54051604CC;
        Fri, 27 Aug 2021 13:36:02 +0000 (UTC)
Date:   Fri, 27 Aug 2021 09:35:59 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH v2 0/9] Add LSM access controls and auditing to
 io_uring
Message-ID: <20210827133559.GG490529@madcap2.tricolour.ca>
References: <162871480969.63873.9434591871437326374.stgit@olly>
 <20210824205724.GB490529@madcap2.tricolour.ca>
 <20210826011639.GE490529@madcap2.tricolour.ca>
 <CAHC9VhSADQsudmD52hP8GQWWR4+=sJ7mvNkh9xDXuahS+iERVA@mail.gmail.com>
 <20210826163230.GF490529@madcap2.tricolour.ca>
 <CAHC9VhTkZ-tUdrFjhc2k1supzW1QJpY-15pf08mw6=ynU9yY5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTkZ-tUdrFjhc2k1supzW1QJpY-15pf08mw6=ynU9yY5g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-08-26 15:14, Paul Moore wrote:
> On Thu, Aug 26, 2021 at 12:32 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > I'm getting:
> >         # ./iouring.2
> >         Kernel thread io_uring-sq is not running.
> >         Unable to setup io_uring: Permission denied
> >
> >         # ./iouring.3s
> >         >>> server started, pid = 2082
> >         >>> memfd created, fd = 3
> >         io_uring_queue_init: Permission denied
> >
> > I have CONFIG_IO_URING=y set, what else is needed?
> 
> I'm not sure how you tried to run those tests, but try running as root
> and with SELinux in permissive mode.

Ok, they ran, including iouring.4.  iouring.2 claimed twice: "Kernel
thread io_uring-sq is not running." and I didn't get any URING records
with ausearch.  I don't know if any of this is expected.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

