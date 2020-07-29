Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECE923258B
	for <lists+io-uring@lfdr.de>; Wed, 29 Jul 2020 21:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgG2Tno (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jul 2020 15:43:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53951 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726365AbgG2Tno (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jul 2020 15:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596051823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tyP8sKccH9P5X5Wlgf/2+v/aSWnjC1k/zw6r/x/aLbo=;
        b=V6RlPax9qfCF3DNM0aO5NyUMvJOY1mehDXkDfjPVMvC7BFxGvAUza2d+den46Dk9gNs6/y
        Pdf4AkKJFO+zOvOZd9aTZFeQefuBiJedRlu+Z/Jr5JCtekHhtOporepiq/m5XF4QOiB28o
        kmi4HygAfdeHRhIEz/bfyhzqfmG3YJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-yHjPd_7sNfaU-rYbeF8SMQ-1; Wed, 29 Jul 2020 15:43:41 -0400
X-MC-Unique: yHjPd_7sNfaU-rYbeF8SMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F7348017FB;
        Wed, 29 Jul 2020 19:43:40 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F1C961176;
        Wed, 29 Jul 2020 19:43:40 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/4] fsstress: reduce the number of events when io_setup
References: <20200728182320.8762-1-zlang@redhat.com>
        <20200728182320.8762-3-zlang@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 29 Jul 2020 15:43:39 -0400
In-Reply-To: <20200728182320.8762-3-zlang@redhat.com> (Zorro Lang's message of
        "Wed, 29 Jul 2020 02:23:18 +0800")
Message-ID: <x49ft9am7is.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Zorro Lang <zlang@redhat.com> writes:

> The original number(128) of aio events for io_setup is a little big.
> When try to run lots of fsstress processes(e.g. -p 1000) always hit
> io_setup EAGAIN error, due to the nr_events exceeds the limit of
> available events. So reduce it from 128 to 64, to make more fsstress
> processes can do AIO test.

It looks to me as though there's only ever one request in flight.  I'd
just set it to 1.

Also, you've included another change not mentioned in your changelog.
Please make sure the changelog matches what's done in the patch.

-Jeff

>
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  ltp/fsstress.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 388ace50..a11206d4 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -28,6 +28,7 @@
>  #endif
>  #ifdef AIO
>  #include <libaio.h>
> +#define AIO_ENTRIES	64
>  io_context_t	io_ctx;
>  #endif
>  #ifdef URING
> @@ -699,8 +700,8 @@ int main(int argc, char **argv)
>  			}
>  			procid = i;
>  #ifdef AIO
> -			if (io_setup(128, &io_ctx) != 0) {
> -				fprintf(stderr, "io_setup failed");
> +			if (io_setup(AIO_ENTRIES, &io_ctx) != 0) {
> +				fprintf(stderr, "io_setup failed\n");
>  				exit(1);
>  			}
>  #endif
> @@ -714,7 +715,7 @@ int main(int argc, char **argv)
>  				doproc();
>  #ifdef AIO
>  			if(io_destroy(io_ctx) != 0) {
> -				fprintf(stderr, "io_destroy failed");
> +				fprintf(stderr, "io_destroy failed\n");
>  				return 1;
>  			}
>  #endif

