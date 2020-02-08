Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD4815649C
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 14:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgBHNzk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 08:55:40 -0500
Received: from mail-lf1-f50.google.com ([209.85.167.50]:45470 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbgBHNzk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 08:55:40 -0500
Received: by mail-lf1-f50.google.com with SMTP id 203so1177815lfa.12
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 05:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=VKSE2BbtXqegzNlLJjEiZJ1ytxdynWBVVJeET1WVwJQ=;
        b=Tf5KdK514fCm+RmiVF+jdUWuJGA42WQmHx2zl/KKDm038Is+s60QsC/98vDvzOVRW8
         LiOyshsGTwfMF2MA7ydQ51X/H8U5N/wzy8SsT5gcSkXD7XgrDW/i1oeGMsvZhMsKqQG2
         sAX8dwdUntf4ruT4SG7B2Rpm04QQkaGoVZ5fqb1whiyMKhxpUUYkq+O2jUsdL91nmaIj
         oC46iflYzlLepkJMNKt/MFfltxDuGC+9xjAhreL6Q0qb7Fe+TnQSFyZ6yS8xOkT8L1JK
         CoXQkd6eQoxwyxzKzD6COf45bVXs7kTEAa6QWfpAJcBggvkID8zayn12z8z7ZdM1+Hov
         7eXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VKSE2BbtXqegzNlLJjEiZJ1ytxdynWBVVJeET1WVwJQ=;
        b=f8Z0Vx9lkB1TeZvBrrDz99wYrohO+lAM/Il+5OTJclg3xgZ5eUCH+RC32mE+C4xKYp
         GqrB0wGgDQe1URAg7VRHRC5JDZYUn2V5pKpHK0U10CPrW9QQ3Xyzy4wpLudrSswRI7+n
         +Acm3Jk/fXRMUEvxfY2jJUecYbS7MTNixK41RIFs7ulF9M6jkh5sgwx7IGXVNEXg2Hxk
         7ixfD+CfW8gEQBR+RTvp+1FrKGpI1HrB3bEiAX/LHs65P9uIHuj2dUzO1jrj0FwMweoZ
         LRxl+eV0kuZNQMVhHUU+jmYxnBFiNYFp9lnYNyr+PlzhK+kSXFHVicQwa4+FlFAgU27Y
         rnNw==
X-Gm-Message-State: APjAAAUonkg9p4BRWG/FCIY5Nrr1DKJf5hmeQGEspe7wFQFlPMkVqAOx
        d2xM02kAKBdgQQlQpycNVJJP/K9T1SPFT/xjyN1fWA1ARnnF/A==
X-Google-Smtp-Source: APXvYqzj6hMbDtCfvvPLoPZt85Ox1SyufXiVtyKD7BCG8OVrA9QMBo/5mcY9C77b6VdpIAy2LsfDQhCvHS+bouSxdpU=
X-Received: by 2002:a19:c210:: with SMTP id l16mr2024860lfc.35.1581170136904;
 Sat, 08 Feb 2020 05:55:36 -0800 (PST)
MIME-Version: 1.0
From:   Glauber Costa <glauber@scylladb.com>
Date:   Sat, 8 Feb 2020 08:55:25 -0500
Message-ID: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
Subject: shutdown not affecting connection?
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi

I've been trying to make sense of some weird behavior with the seastar
implementation of io_uring, and started to suspect a bug in io_uring's
connect.

The situation is as follows:

- A connect() call is issued (and in the backend I can choose if I use
uring or not)
- The connection is supposed to take a while to establish.
- I call shutdown on the file descriptor

If io_uring is not used:
- connect() starts by  returning EINPROGRESS as expected, and after
the shutdown the file descriptor is finally made ready for epoll. I
call getsockopt(SOL_SOCKET, SO_ERROR), and see the error (104)

if io_uring is used:
- if the SQE has the IOSQE_ASYNC flag on, connect() never returns.
- if the SQE *does not* have the IOSQE_ASYNC flag on, then most of the
time the test works as intended and connect() returns 104, but
occasionally it hangs too. Note that, seastar may choose not to call
io_uring_enter immediately and batch sqes.

Sounds like some kind of race?

I know C++ probably stinks like the devil for you guys, but if you are
curious to see the code, this fails one of our unit tests:

https://github.com/scylladb/seastar/blob/master/tests/unit/connect_test.cc
See test_connection_attempt_is_shutdown
(above is the master seastar tree, not including the io_uring implementation)

Please let me know if this rings a bell and if there is anything I
should be verifying here
