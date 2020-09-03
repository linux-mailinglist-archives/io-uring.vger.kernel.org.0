Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB9E25C1CE
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 15:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgICNn5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 09:43:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37932 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728946AbgICMpk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 08:45:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599137107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m1k+1Fl356vo9AAqbk3SpwAuGly6cRqlIiS7ohn/hyE=;
        b=g8ReEfKdyOlOa+oB/PJqy9/skXgcu/omb9FZaBIS9kc+ll7W6ih414c7nfWGzlM6udS0KO
        CtS16zj4kJF1Ybu9w6jKI+x/18clxdqzOZ7wUmWEvlUdA6sZRo8bqrQ79rbeNswDA3a/Lu
        901GyaDe6xEpd/7GjvLjovIEpNLaKzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-Ez4KycI2MUSXvcpjnRll-w-1; Thu, 03 Sep 2020 08:43:00 -0400
X-MC-Unique: Ez4KycI2MUSXvcpjnRll-w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA3611019625;
        Thu,  3 Sep 2020 12:42:59 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF6AF3C04;
        Thu,  3 Sep 2020 12:42:58 +0000 (UTC)
Date:   Thu, 3 Sep 2020 08:42:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 2/4] fsstress: reduce the number of events when
 io_setup
Message-ID: <20200903124257.GB444163@bfoster>
References: <20200823063032.17297-1-zlang@redhat.com>
 <20200823063032.17297-3-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823063032.17297-3-zlang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 23, 2020 at 02:30:30PM +0800, Zorro Lang wrote:
> The original number(128) of aio events for io_setup too big. When try
> to run lots of fsstress processes(e.g. -p 1000) always hit io_setup
> EAGAIN error, due to the nr_events exceeds the limit of available
> events. Due to each fsstress process only does once libaio read/write
> operation each time. So reduce the aio events number to 1, to make more
> fsstress processes can do AIO test.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  ltp/fsstress.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 7a0e278a..ef2017a8 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -28,6 +28,7 @@
>  #endif
>  #ifdef AIO
>  #include <libaio.h>
> +#define AIO_ENTRIES	1
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
> -- 
> 2.20.1
> 

