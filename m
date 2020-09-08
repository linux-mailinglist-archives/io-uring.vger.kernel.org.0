Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8162260D2D
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 10:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgIHION (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 04:14:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31569 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729624AbgIHIOK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 04:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599552848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g7XnmiL30sAnPcB3AzinB00t7FaVkVHEiXk7l9h6Wbo=;
        b=VtkPdRhAgZ0nt2IJvcmSqmvx04wvQXCwtgrhoORdJCUAAh58AH23OCYFt2ubjKXNFyNWcB
        5s9hIIkleSGatOo2j0MKKx6Ln2oHzo5DjUfKt2KpyM9NyJ1CPjhVGOVZ8HXG0dV56Ks06D
        L5k8mGsXLNE23GrhMCQIkpVBSm6c1pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-4Y9dwhZQMJypELTz8dvtDQ-1; Tue, 08 Sep 2020 04:14:06 -0400
X-MC-Unique: 4Y9dwhZQMJypELTz8dvtDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4FB41005E5B;
        Tue,  8 Sep 2020 08:14:05 +0000 (UTC)
Received: from work (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15F1D7D8AE;
        Tue,  8 Sep 2020 08:14:04 +0000 (UTC)
Date:   Tue, 8 Sep 2020 10:14:00 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 2/2] runtests: add ability to exclude tests
Message-ID: <20200908081400.pytf6abmvp7ke7my@work>
References: <20200907132225.4181-1-lczerner@redhat.com>
 <20200907132225.4181-2-lczerner@redhat.com>
 <9123fe5b-f57c-258a-64c3-71fa4859040b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9123fe5b-f57c-258a-64c3-71fa4859040b@kernel.dk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 07, 2020 at 01:34:38PM -0600, Jens Axboe wrote:
> On 9/7/20 7:22 AM, Lukas Czerner wrote:
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> This patch really needs some justification. I generally try to make sure
> that older kernel skip tests appropriately, sometimes I miss some and I
> fix them up when I find them.
> 
> So just curious what the use case is here for skipping tests? Not
> adverse to doing it, just want to make sure it's for the right reasons.

I think this is very useful, at least for me, in situation where some
tests are causeing problems (like hangs, panics) that are not fixed yet,
but I would still like to run entire tests suite to make sure my changes
in didn't break anything else. I find it especially usefull in rapidly
evolving project like this.

I have a V2 patches with that justification in place and some minor
changes. I'll be sending that (hopefuly it won't take hours this time).

Thanks!
-Lukas

> 
> -- 
> Jens Axboe
> 

