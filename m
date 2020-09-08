Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E50A261A5F
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 20:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbgIHSfM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 14:35:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44811 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731649AbgIHSfE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 14:35:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599590103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r+6d6YkIdY+YQGAEycn6d3UOoU4GUenZsshYdPyY+rM=;
        b=AHcD0VfixaEWZpgNS/+565QygSYrMD/hVszuoSkphkLFHSf42fuSKFl1nxOHP6CedoRq3O
        Y1YxSLXGcxXbG79qtSnVGqOwo5+5FTvHxZxJSzXZ87KbuHdEHX4PaVWKKODDhPFnoEQdWz
        3y7/1Mr0fv3J3IfpGJbpDdaOjTanEvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-1jw1zUJIP0qKf718xR6LKw-1; Tue, 08 Sep 2020 14:35:02 -0400
X-MC-Unique: 1jw1zUJIP0qKf718xR6LKw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3961210930C0;
        Tue,  8 Sep 2020 18:35:01 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC5861002D49;
        Tue,  8 Sep 2020 18:35:00 +0000 (UTC)
Date:   Tue, 8 Sep 2020 14:34:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 2/5] fsstress: reduce the number of events when
 io_setup
Message-ID: <20200908183458.GB737175@bfoster>
References: <20200906175513.17595-1-zlang@redhat.com>
 <20200906175513.17595-3-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906175513.17595-3-zlang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 07, 2020 at 01:55:10AM +0800, Zorro Lang wrote:
> The original number(128) of aio events for io_setup too big. When try
> to run lots of fsstress processes(e.g. -p 1000) always hit io_setup
> EAGAIN error, due to the nr_events exceeds the limit of available
> events. Due to each fsstress process only does once libaio read/write
> operation each time. So reduce the aio events number to 1, to make more
> fsstress processes can do AIO test.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

Same as the previous version..?

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  ltp/fsstress.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 2c584ef0..b4a51376 100644
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

