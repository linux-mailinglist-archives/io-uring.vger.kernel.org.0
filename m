Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AC42964D2
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 20:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902433AbgJVStK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 14:49:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2902420AbgJVStK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 14:49:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603392549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iXfDaAWBketQcSV06j5zjgysbHPt12Wzk+IUxgP2fOQ=;
        b=cOxIYeVVwouOlTzbABqGjVFkGSDRG3Fm170VAkNiOt2rDen1q11QPHZq8m/H1+evxah9tP
        9zACpdppoKJDH9KnKWQUuU8l4YNheEim9yiuzkT2sGftXewSJfDE0QjYSNnNyZYWbX9lOt
        vOS9R72gIpsLOyzO/tP/b2pi5aK6zX4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-SsxX0NAGMJ6fUdEhwNK3Zw-1; Thu, 22 Oct 2020 14:49:06 -0400
X-MC-Unique: SsxX0NAGMJ6fUdEhwNK3Zw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9AED1018F7E;
        Thu, 22 Oct 2020 18:49:05 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 693FF6EF41;
        Thu, 22 Oct 2020 18:49:05 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: remove req cancel in ->flush()
References: <6cffe73a8a44084289ac792e7b152e01498ea1ef.1603380957.git.asml.silence@gmail.com>
        <x491rhq6tcx.fsf@segfault.boston.devel.redhat.com>
        <8b1a53d2-d25f-2afb-7cf7-7a78f5d3ba29@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 22 Oct 2020 14:49:04 -0400
In-Reply-To: <8b1a53d2-d25f-2afb-7cf7-7a78f5d3ba29@kernel.dk> (Jens Axboe's
        message of "Thu, 22 Oct 2020 12:01:07 -0600")
Message-ID: <x49r1pq5c67.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 10/22/20 11:52 AM, Jeff Moyer wrote:
>> Pavel Begunkov <asml.silence@gmail.com> writes:
>> 
>>> Every close(io_uring) causes cancellation of all inflight requests
>>> carrying ->files. That's not nice but was neccessary up until recently.
>>> Now task->files removal is handled in the core code, so that part of
>>> flush can be removed.
>> 
>> I don't understand the motivation for this patch.  Why would an
>> application close the io_uring fd with outstanding requests?
>
> It normally wouldn't, of course. It's important to understand that this
> triggers for _any_ close. So if the app did a dup+close, then it'd
> still trigger.

Ah, I see.  That makes more sense, thanks.

-Jeff

