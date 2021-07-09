Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBC83C233D
	for <lists+io-uring@lfdr.de>; Fri,  9 Jul 2021 14:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhGIMH1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jul 2021 08:07:27 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:34508
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhGIMH1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jul 2021 08:07:27 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2021 08:07:26 EDT
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 13005401BE;
        Fri,  9 Jul 2021 11:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1625831717;
        bh=WQJt/rujabpC6j6jCpmi7LAcFfdIBX8ppv3eoy0WW0U=;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type;
        b=UPrNulqI6eXqI24HT0Y3q3LuJdP9oM+FMFbPZEB+XM0sPIGjI6PqEWfTibzJXMNPt
         CRvh4MMwRxasGkQMloASW+Uv75M+mZyZ1dZks6XnrjWpLIXr90Rc/rNVaxKmJ0LkKT
         72cQclYQ5qnUo4kCOpoEMmDaLWE51v4KSH1+uH/TQx2YHh2hl90gjEDMwTRGuSIafo
         k80io4WXl6fckGBGdJpTcM2gvRldXlZiuYS7znddixjIO8gW8vz3XMvyzfu+hZ3Fv+
         +dI55UKA8+iw7utUf9SOOUBhzuHfStpB7hMpRpjGrNGxY8Dl0tih09IYLBYyKcM7Pz
         qour85fGZETyw==
To:     Jens Axboe <axboe@kernel.dk>
From:   Colin Ian King <colin.king@canonical.com>
Subject: potential null pointer deference (or maybe invalid null check) in
 io_uring io_poll_remove_double()
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <fe70c532-e2a7-3722-58a1-0fa4e5c5ff2c@canonical.com>
Date:   Fri, 9 Jul 2021 12:55:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

I was triaging some outstanding Coverity static analysis warnings and
found a potential issue in the following commit:

commit 807abcb0883439af5ead73f3308310453b97b624
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Jul 17 17:09:27 2020 -0600

    io_uring: ensure double poll additions work with both request types

The analysis from Coverity is as follows:

4962 static int io_poll_double_wake(struct wait_queue_entry *wait,
unsigned mode,
4963                               int sync, void *key)
4964 {
4965        struct io_kiocb *req = wait->private;
4966        struct io_poll_iocb *poll = io_poll_get_single(req);
4967        __poll_t mask = key_to_poll(key);
4968
4969        /* for instances that support it check for an event match
first: */

    deref_ptr: Directly dereferencing pointer poll.

4970        if (mask && !(mask & poll->events))
4971                return 0;
4972        if (!(poll->events & EPOLLONESHOT))
4973                return poll->wait.func(&poll->wait, mode, sync, key);
4974
4975        list_del_init(&wait->entry);
4976

  Dereference before null check (REVERSE_INULL)
  check_after_deref: Null-checking poll suggests that it may be null,
but it has already been dereferenced on all paths leading to the check.

4977        if (poll && poll->head) {
4978                bool done;

pointer poll is being dereferenced on line 4970, however, on line 4977
it is being null checked. Either the null check is redundant (because it
can never be null) or it needs to be performed before the poll->events
read on line 4970.

Colin
