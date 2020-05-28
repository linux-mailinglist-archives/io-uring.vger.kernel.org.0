Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A31B1E6B00
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 21:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406507AbgE1TbK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 15:31:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56297 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2406318AbgE1TbJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 15:31:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590694267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nYiWUB99KR8oQUbnJb1Edexk+M/o3Q8sut7E1T9tkIw=;
        b=E0BCI8AkAyMsv0zfMhw3GFtshRYfNvggHiXCGHSfAfyKfRggX98asxs4zWYWN4LOLFV1hH
        mmJRAYUfwJN/bg1C/LjBJsmm72DTXacDsym4G253K/3p1l74Y6oAF7UYFx7cNcaUKr0eIp
        HftpyR/G0Fi45+2l6Mq+sgLphwyN1Oo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-PGlJZFTyNoORd9wMgiSi9w-1; Thu, 28 May 2020 15:31:06 -0400
X-MC-Unique: PGlJZFTyNoORd9wMgiSi9w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE9AB107ACF4;
        Thu, 28 May 2020 19:31:04 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 785E661100;
        Thu, 28 May 2020 19:31:04 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        io-uring@vger.kernel.org
Subject: Re: [RFC 2/2] io_uring: mark REQ_NOWAIT for a non-mq queue as unspported
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
        <1589925170-48687-3-git-send-email-bijan.mottahedeh@oracle.com>
        <x495zcf29ie.fsf@segfault.boston.devel.redhat.com>
        <0ab35b4b-be67-8977-08ea-2998a4ac1a7e@kernel.dk>
        <798e24c7-b973-00c7-037f-4095e43515b7@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 28 May 2020 15:31:03 -0400
In-Reply-To: <798e24c7-b973-00c7-037f-4095e43515b7@kernel.dk> (Jens Axboe's
        message of "Thu, 28 May 2020 13:22:19 -0600")
Message-ID: <x49tuzzzwjs.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> I checked, and with the offending commit reverted, it behaves exactly
> like it should - io_uring doesn't hit endless retries, and we still
> return -EAGAIN to userspace for preadv2(..., RFW_NOWAIT) if not supported.
> I've queued up the revert.
>
> Jeff, the poll test above is supposed to fail as we can't poll on dm.
> So that part is expected.

OK, works for me.  Thanks for the quick turnaround.

-Jeff

