Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E820243FC6
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 22:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHMUZ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 16:25:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47255 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726192AbgHMUZ2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 16:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597350327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R/1lID4CfUqj4HkTUuGT6Zf9zMAmnn6LOP756PrsGwQ=;
        b=WzPLhfm7o5NB9zGw2HOz6VZsVJBLWQUifcTdBGUrS6Z9F1B1qBV/4zhudhpNH0qzfa6tMu
        Kpk/aGNM3Ga3FcQSdk9POfPbpu3VHCaL+HzJiNJU+jThJesXyyo4QusUKO5Rt12byfaIt6
        TzLSArF1lW5rP+h6DVULE4ohQ3H+fow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-Q62nYMlCMr6aynN7rA1r8Q-1; Thu, 13 Aug 2020 16:25:25 -0400
X-MC-Unique: Q62nYMlCMr6aynN7rA1r8Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD2FB807321;
        Thu, 13 Aug 2020 20:25:24 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5944560C05;
        Thu, 13 Aug 2020 20:25:24 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
References: <20200813175605.993571-1-axboe@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 13 Aug 2020 16:25:23 -0400
In-Reply-To: <20200813175605.993571-1-axboe@kernel.dk> (Jens Axboe's message
        of "Thu, 13 Aug 2020 11:56:03 -0600")
Message-ID: <x497du2z424.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> Since we've had a few cases of applications not dealing with this
> appopriately, I believe the safest course of action is to ensure that
> we don't return short reads when we really don't have to.
>
> The first patch is just a prep patch that retains iov_iter state over
> retries, while the second one actually enables just doing retries if
> we get a short read back.

Have you run this through the liburing regression tests?

Tests  <eeed8b54e0df-test> <timeout-overflow> <read-write> failed

I'll take a look at the failures, but wanted to bring it to your
attention sooner rather than later.  I was using your io_uring-5.9
branch.

-Jeff

