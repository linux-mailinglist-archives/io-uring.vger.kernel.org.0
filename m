Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FDD263F68
	for <lists+io-uring@lfdr.de>; Thu, 10 Sep 2020 10:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgIJIKr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Sep 2020 04:10:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726381AbgIJIKq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Sep 2020 04:10:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599725445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TfFFqKJejyDv5SKkcJjKf+5TRx98yxg9SAhwBOgq+8I=;
        b=W9N3TAIt+FfHAPvmOJLxP8+w2niHVyE4NoiDWftLbYURaS1J0vFo42kxewlRTNzGbKSjtA
        CXQeqSsxP43qWtZaIVtK/VjepC5Q81XV/2AJmyXjXoubbrDqlPsDLrz0yGgr7ehIwl9LUR
        KaeB4JsvjFphu/jF/llPdBtYiyK5O2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-eJCsYcyUMxCRbiRTYXNBmw-1; Thu, 10 Sep 2020 04:10:43 -0400
X-MC-Unique: eJCsYcyUMxCRbiRTYXNBmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61DCE1084C82
        for <io-uring@vger.kernel.org>; Thu, 10 Sep 2020 08:10:42 +0000 (UTC)
Received: from work (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A650B7E8EB;
        Thu, 10 Sep 2020 08:10:41 +0000 (UTC)
Date:   Thu, 10 Sep 2020 10:10:37 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
Subject: Re: A way to run liburing tests on emulated nvme in qemu
Message-ID: <20200910081037.j26hht5dbv4xw5hc@work>
References: <20200909182703.d3wjz3rxys6haij6@work>
 <20200910073837.u4vypgrcku674n2o@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910073837.u4vypgrcku674n2o@steredhat>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 10, 2020 at 09:38:37AM +0200, Stefano Garzarella wrote:
> Hi Lukas,
> 
> On Wed, Sep 09, 2020 at 08:27:03PM +0200, Lukas Czerner wrote:
> > Hi,
> > 
> > because I didn't have an acces to a nvme HW I created a simple set of
> > scripts to help me run the liburing test suite on emulated nvme device
> > in qemu. This has also an advantage of being able to test it on different
> > architectures.
> > 
> > Here is a repository on gihub.
> > https://github.com/lczerner/qemu-test-iouring
> > 
> > I am attaching a README file to give you some sence of what it is.
> > 
> > It is still work in progress and only supports x86_64 and ppc64 at the
> > moment. It is very much Fedora centric as that's what I am using. But
> > maybe someone find some use for it. Of course I accept patches/PRs.
> 
> Cool! Thanks for sharing!
> 
> I had a look and I will definitely try it!

Great!

> 
> Just a note, maybe you can make configurable through config file also
> the number of CPU and amount of memory of the VM.

Yes, that's definitelly something that's missing. It is easy to add so
I'll do that today.

Thanks!
-Lukas


> 
> Thanks,
> Stefano
> 

