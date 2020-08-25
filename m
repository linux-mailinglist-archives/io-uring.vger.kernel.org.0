Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDCE251D57
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHYQin (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 12:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgHYQim (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 12:38:42 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C117C061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 09:38:42 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id p36so6024198qtd.12
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 09:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K1L6lYwRSk3CMELwgT4O8PjRVnx2Y5UPm5OGDRsPG5U=;
        b=c/iVIvuLDPOifySSaDm9RCPWMEz2W/JBX/l1yiGD5qEjLjt+lmGnYQf6tHYWDoQjde
         XH1D2kBLJU3/25pKPp9b+LVKF5vi6MQL2t7CtxgHU2nmxf0wJZHuYj1YJ7fq7mGhD36y
         WZq54JALPbmBQ/O1S7LqiTZdB4FRgFsbdJyOs0SbgCyYobScffedO85LAo+lWOGeJ5RP
         tvH/JeXgXrTlaeeDdBr7pmMFZL4vXzoh/0R1hzlEOUaZ5ba8NTTgjUTtrxsVfF8uR+tW
         sqNLZpVNu8puHAW+EO+DdBXLjNw0lRby0bCNCpYwf00F0XybpCSfqcnQgYYPd7d4OI3n
         PgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K1L6lYwRSk3CMELwgT4O8PjRVnx2Y5UPm5OGDRsPG5U=;
        b=P31x5Q98wKj0qblA99BizcsWFEm5hf4gilx0wzOKvuU8EGwztE02w+I2fy7+bfdOU5
         mhO5ijU+fhdzYMVclPTLBT3HY0J46tOV5ymKxitarYzqcyeGXzT9PkT3k4cOCgnsGtOc
         LrRGuLxakAInnk1ohTpzcRxuHvNgaOTuplYtvFTuXWV01DquOrwMjFo6/N9bnktjR+gV
         FvLIJQ07pk5Lt7H88ChQwIx1tGnCEsCB50ZIZ75gDlg54TeNEbOMvsV/yqfOchrd3K5z
         dDfvvQR14CQ3zhnHMrXqWrKMLPzQGBiiYOnsMOaPmm47ldfpa9mqE66DMw1DJt17ixcG
         RbGA==
X-Gm-Message-State: AOAM5303aT4wX9/SChA8XfcyGflSm8ULFdCSXwkuND7HV5oGUW69zVsN
        x4ZUXMtIc/VGyy2Kl35sx7SYB06AVU5HAmahuhk=
X-Google-Smtp-Source: ABdhPJxs4oUM0F3xJzlH24C1xxDfEExgu8s25raMXCJKkE5/4GPpncA8JseZ8VFa7WPrym8JTFxzzcbJS3cWjDuqXNo=
X-Received: by 2002:ac8:4b78:: with SMTP id g24mr10280129qts.248.1598373519849;
 Tue, 25 Aug 2020 09:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+o=0zd9JQj+B0Fe1cONCtMJdKkfQuT+Hzx9X9jRigrfZQ@mail.gmail.com>
 <639db33b-08f2-4e10-8f06-b6d345677df8@kernel.dk> <308222a7-8bd2-44a6-c46c-43adf5469fa3@kernel.dk>
 <c07b29d1-fff4-3019-4cba-0566c8a75fd0@kernel.dk>
In-Reply-To: <c07b29d1-fff4-3019-4cba-0566c8a75fd0@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Tue, 25 Aug 2020 18:38:28 +0200
Message-ID: <CAAss7+rKt6Eh7ozCz5syJSOjVVaZnrVSXi8zS8MxuPJ=kcUwCQ@mail.gmail.com>
Subject: Re: io_uring file descriptor address already in use error
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Not sure this is an actual bug, but depends on how you look at it. Your
> poll command has a reference to the file, which means that when you close
> it here:
>
>     assert(close(sock_listen_fd1) == 0);
>
> then that's not the final close. If you move the io_uring_queue_exit()
> before that last create_server_socket() it should work, since the poll
> will have been canceled (and hence the file closed) at that point.
>
>  That said, I don't believe we actually need the file after arming the
>  poll, so we could potentially close it once we've armed it. That would
>  make your example work.


ah okay that makes sense

> Actually we do need the file, in case we're re-arming poll. But as stated
> in the above email, this isn't unexpected behavior. You could cancel the
> poll before trying to setup the new server socket, that'd close it as
> well. Then the close() would actually close it. Ordering of the two
> operations wouldn't matter.
>
> Just to wrap this one up, the below patch would make it behave like you
> expect, and still retain the re-poll behavior we use on poll armed on
> behalf of an IO request. At this point we're not holding a reference to
> the file across the poll handler, and your close() would actually close
> the file since it's putting the last reference to it.
>
> But... Not actually sure this is warranted. Any io_uring request that
> operates on a file will hold a reference to it until it completes. The
> poll request in your example never completes. If you run poll(2) on a
> file and you close that file, you won't get a poll event triggered.
> It'll just sit there and wait on events that won't come in. poll(2)
> doesn't hold a reference to the file once it's armed the handler, so
> your example would work there.

oh thanks I'm gonna test that :) yeah I expected exactly the same
behaviour as in epoll(2) & pol(2) that's why I'm asking
to be honest it would be quite handy to have this patch(for netty), so
I don't have to cancel a poll or close ring file descriptor(I do of
course understand that if you won't push this patch)

is there no other way around to close the file descriptor? Even if I
remove the poll, it doesn't work
btw if understood correctly poll remove operation refers to all file
descriptors which arming a poll in the ring buffer right?
Is there a way to cancel a specific file descriptor poll?


---
Josef Grieb
