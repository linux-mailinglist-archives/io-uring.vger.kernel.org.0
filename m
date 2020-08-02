Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE5E235978
	for <lists+io-uring@lfdr.de>; Sun,  2 Aug 2020 19:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgHBRTp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Aug 2020 13:19:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42314 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725793AbgHBRTo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Aug 2020 13:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596388783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rQMSjrPRC4wFlmbSDPDwXTgwvvtavqffSQ+AKyhY+pE=;
        b=cqauke+Chsd02m5kOVyWOWmfvIEEADwkWhcm1DFWYZzaRXUGsVyzRNbWHoqk5Ty3YvzyhT
        X2ier/xprUA1MQ0pEPiHkzjRwE4/qfXP4nPf3vc9BtDEFnwQ3ht/vwM35i+uU9rj1LYd65
        ez48h7YFHwQ8PYmRfls9/ZQsJAgniXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-ei1DFMbVNUitLzHTS7O-6g-1; Sun, 02 Aug 2020 13:19:41 -0400
X-MC-Unique: ei1DFMbVNUitLzHTS7O-6g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24D2F8005B0;
        Sun,  2 Aug 2020 17:19:40 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9314C5D9CD;
        Sun,  2 Aug 2020 17:19:39 +0000 (UTC)
Date:   Mon, 3 Aug 2020 01:32:10 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/4] fsstress: reduce the number of events when io_setup
Message-ID: <20200802173210.GN2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Jeff Moyer <jmoyer@redhat.com>, fstests@vger.kernel.org,
        io-uring@vger.kernel.org
References: <20200728182320.8762-1-zlang@redhat.com>
 <20200728182320.8762-3-zlang@redhat.com>
 <x49ft9am7is.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ft9am7is.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 29, 2020 at 03:43:39PM -0400, Jeff Moyer wrote:
> Zorro Lang <zlang@redhat.com> writes:
> 
> > The original number(128) of aio events for io_setup is a little big.
> > When try to run lots of fsstress processes(e.g. -p 1000) always hit
> > io_setup EAGAIN error, due to the nr_events exceeds the limit of
> > available events. So reduce it from 128 to 64, to make more fsstress
> > processes can do AIO test.
> 
> It looks to me as though there's only ever one request in flight.  I'd
> just set it to 1.
> 
> Also, you've included another change not mentioned in your changelog.
> Please make sure the changelog matches what's done in the patch.

Thanks Jeff, I'll rewrite this patch:) Do you have any review points about
those two IO_URING related patches (1/4 and 4/4), or it looks good to you?

Thanks,
Zorro

> 
> -Jeff
> 
> >
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  ltp/fsstress.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index 388ace50..a11206d4 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -28,6 +28,7 @@
> >  #endif
> >  #ifdef AIO
> >  #include <libaio.h>
> > +#define AIO_ENTRIES	64
> >  io_context_t	io_ctx;
> >  #endif
> >  #ifdef URING
> > @@ -699,8 +700,8 @@ int main(int argc, char **argv)
> >  			}
> >  			procid = i;
> >  #ifdef AIO
> > -			if (io_setup(128, &io_ctx) != 0) {
> > -				fprintf(stderr, "io_setup failed");
> > +			if (io_setup(AIO_ENTRIES, &io_ctx) != 0) {
> > +				fprintf(stderr, "io_setup failed\n");
> >  				exit(1);
> >  			}
> >  #endif
> > @@ -714,7 +715,7 @@ int main(int argc, char **argv)
> >  				doproc();
> >  #ifdef AIO
> >  			if(io_destroy(io_ctx) != 0) {
> > -				fprintf(stderr, "io_destroy failed");
> > +				fprintf(stderr, "io_destroy failed\n");
> >  				return 1;
> >  			}
> >  #endif
> 

