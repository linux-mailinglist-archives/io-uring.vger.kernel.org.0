Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0077D349B1B
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 21:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhCYUkd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 16:40:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230241AbhCYUkW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 16:40:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616704821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7uJ/V1bTwvig9f9AKI3u7uSUQp3VUNxC3YK1FhlyHsQ=;
        b=Q6TWVGL9Jn4YLnGy4ImnRl5FAo0tTxpAX/iD4WJiMpBb1V10aQ1fVJ8l+Lc39Bvev3CjVh
        5YiFhBzM4i1tuCodkZJO+kVMEWlHfWKxAdIWhJcxZ8YFjMPKxHvVNLlc4gjmmczLTshPzL
        X3AQ7Rhf3Ww1GakegayeqKVHNITYGNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-wGM5OXhCMs6M9Rj-vRg9yA-1; Thu, 25 Mar 2021 16:40:19 -0400
X-MC-Unique: wGM5OXhCMs6M9Rj-vRg9yA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FBAA107AFA5;
        Thu, 25 Mar 2021 20:40:18 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8D3D060D11;
        Thu, 25 Mar 2021 20:40:16 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 25 Mar 2021 21:40:17 +0100 (CET)
Date:   Thu, 25 Mar 2021 21:40:15 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
Message-ID: <20210325204014.GD28349@redhat.com>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
 <3a1c02a5-db6d-e3e1-6ff5-69dd7cd61258@kernel.dk>
 <m1zgyr2ddh.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zgyr2ddh.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/25, Eric W. Biederman wrote:
>
> So looking quickly the flip side of the coin is gdb (and other
> debuggers) needs a way to know these threads are special, so it can know
> not to attach.

may be,

> I suspect getting -EPERM (or possibly a different error code) when
> attempting attach is the right was to know that a thread is not
> available to be debugged.

may be.

But I don't think we can blame gdb. The kernel changed the rules, and this
broke gdb. IOW, I don't agree this is gdb bug.

Oleg.

