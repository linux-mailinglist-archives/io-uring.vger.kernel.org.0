Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111BC15D5D6
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 11:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgBNKeH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 05:34:07 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:36086 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbgBNKeH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 05:34:07 -0500
Received: by mail-lj1-f181.google.com with SMTP id r19so10152195ljg.3
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 02:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+Y+SDmHgj3Xg2YVD5/j22qGeYrVmopyK15eRhvUUe6U=;
        b=ljyX5lqa6p6OqWji8FAk6tQ7Hl0QMAWQ6ddfZF/wxExX7dnSHqEQnI7zIGLJmnx6jg
         RTfUxA+UTqvPH0LdcGC5fnUnapaU497p7gKjxzF2UXVKFLu07Iwv5HqKMrNXaZ140oTN
         Y/UE5GkprnCNQVO5I2r7EcR7NyT8/8U3+sW3mompbTi8G9kD+SAAZr63RK6Rx8/0gW6O
         ixAYfinR7favt1BPuojRTJXlbWoUF8YN/VsmL0Nd9zSGV5FdCkiYcMBHKnzQBXAqVwPy
         ejM+x4mzyBBwAyH9nNDHW91OCI9Vrzowpg5U6KBxZc9iBcMv5GcnSKe6cNvi3skuXIcE
         tW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Y+SDmHgj3Xg2YVD5/j22qGeYrVmopyK15eRhvUUe6U=;
        b=iq/bgBcY0/WOQcwOeBa8tPXme4CLGcM5sS6icPssYareF6uFxvcebH5Amcw5Pv80Qm
         YmoqWYdCB1UqSeyS7hEpfABnqW4ATyy8C8ZRwVA8mOaf9tgx5BVyj06xq7IwdnR5THng
         /IrCtHEbfCWoL1KIxlA7rVd+OjcfYmCi0PKSTgnUgUnbchh+pY/T9rulqr0CMxM6sCb7
         zr7D1G5JtkbSSRHETHH3IJxuFhYzh7xGdyaDrehHqYafsrJBwrfjFAYnzBlxphC9PWE2
         /jNz0+CdXM8w9rAit8+RojTk3NoIsgPTB+Yibmi1HKfl0LCvm6WA73FeEZZPVhDBQZ/u
         BHqw==
X-Gm-Message-State: APjAAAWNBZq1pfo0n+bAZI2iZwlDVrWmv5goBXeXcrPynDxgCyyAdbWN
        t53TbLF4W8zZzACeqGYKvT02s70HWWw=
X-Google-Smtp-Source: APXvYqyEgk9MpJbLRPk1ddR5M+OaKgVofUAP+zUK7swbkilPnR83mBoLVT8+YVYQMPAnKAyW4gj5og==
X-Received: by 2002:a2e:9e43:: with SMTP id g3mr1737213ljk.37.1581676444415;
        Fri, 14 Feb 2020 02:34:04 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id z8sm3308712ljk.13.2020.02.14.02.34.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:34:03 -0800 (PST)
Subject: Re: [FEATURE REQUEST] Specify a sqe won't generate a cqe
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        io-uring <io-uring@vger.kernel.org>
References: <9A41C624-3D2C-40BC-A910-59CBDC5BB76E@eoitek.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <30d88cf3-527e-4396-4934-fff13c449a80@gmail.com>
Date:   Fri, 14 Feb 2020 13:34:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <9A41C624-3D2C-40BC-A910-59CBDC5BB76E@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/2020 11:29 AM, Carter Li 李通洲 wrote:
> To implement io_uring_wait_cqe_timeout, we introduce a magic number
> called `LIBURING_UDATA_TIMEOUT`. The problem is that not only we
> must make sure that users should never set sqe->user_data to
> LIBURING_UDATA_TIMEOUT, but also introduce extra complexity to
> filter out TIMEOUT cqes.
> 
> Former discussion: https://github.com/axboe/liburing/issues/53
> 
> I’m suggesting introducing a new SQE flag called IOSQE_IGNORE_CQE
> to solve this problem.
> 
> For a sqe tagged with IOSQE_IGNORE_CQE flag, it won’t generate a cqe
> on completion. So that IORING_OP_TIMEOUT can be filtered on kernel
> side.
> 
> In addition, `IOSQE_IGNORE_CQE` can be used to save cq size.
> 
> For example `POLL_ADD(POLLIN)->READ/RECV` link chain, people usually
> don’t care the result of `POLL_ADD` is ( since it will always be
> POLLIN ), `IOSQE_IGNORE_CQE` can be set on `POLL_ADD` to save lots
> of cq size.
> 
> Besides POLL_ADD, people usually don’t care the result of POLL_REMOVE
> /TIMEOUT_REMOVE/ASYNC_CANCEL/CLOSE. These operations can also be tagged
> with IOSQE_IGNORE_CQE.
> 
> Thoughts?
> 

I like the idea! And that's one of my TODOs for the eBPF plans.
Let me list my use cases, so we can think how to extend it a bit.

1. In case of link fail, we need to reap all -ECANCELLED, analise it and
resubmit the rest. It's quite inconvenient. We may want to have CQE only
for not cancelled requests.

2. When chain succeeded, you in the most cases already know the result
of all intermediate CQEs, but you still need to reap and match them.
I'd prefer to have only 1 CQE per link, that is either for the first
failed or for the last request in the chain.

These 2 may shed much processing overhead from the userspace.

3. If we generate requests by eBPF even the notion of per-request event
may broke.
- eBPF creating new requests would also need to specify user-data, and
  this may be problematic from the user perspective.
- may want to not generate CQEs automatically, but let eBPF do it.

-- 
Pavel Begunkov
