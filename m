Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516D225472E
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 16:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgH0OnQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 10:43:16 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46057 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728010AbgH0Olk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 10:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598539297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kSkJbE4XJrwDOFMLE7e16e7obrhoIIgU7bHmd2/ZWC4=;
        b=HDO4OhGKNgBp6QYNS+SMvx8dHCbko6RogmMZ74Dh+Hq4tb0wkUURO32DpxPnFUVQAmErFO
        a8f2AezJ1fzN3G2e2Ph+Mak+eWOsR666JDxlq01XFeZ1SV/j8cmiSes3isrRCUT2STRJcG
        jM9IF3JyYv48+A3CGkxEPmlrP5tYuWE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-Wj6Ra9VENC-_cRCNHY4bGQ-1; Thu, 27 Aug 2020 10:41:35 -0400
X-MC-Unique: Wj6Ra9VENC-_cRCNHY4bGQ-1
Received: by mail-wm1-f70.google.com with SMTP id f125so2218610wma.3
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 07:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kSkJbE4XJrwDOFMLE7e16e7obrhoIIgU7bHmd2/ZWC4=;
        b=epL1Ksyr4i1IPy086mpvCU86hAe+kpgZKiaaZ6F97knkwBZTrM1VV1Jm6Xb+Xd4UK/
         EzzNBkRSPLbjNteV0T6QCmjAUEmkXTMJ60TbYpO4xILQdLkPaLrW8Kj3w1F9rW8mxIWW
         TEa3lNjZGW/cztft5qgZ3rCX7uFOQ27F/QVOsRF3rXwU4/Z9ZnFS7FSFY99axaPK74Mz
         IqaH2ZgNKv3BZgkphLIRrBwOnvDJNfCUt8Xg16rrbbGRslNt3D5OobKfhv3pC8eNv9Sf
         aFhfT+FRNOoXaPe3x9HbPpYhQFlr4gp3NignAYgyYRx0Ewnzn42w8F4Mf29jRVQDwjYv
         9PJA==
X-Gm-Message-State: AOAM5331szF8aLEA82kzkDyLAI0Y1/F8LCE+kcHmKNuJi3NvseDwYsy9
        dltSSAGklulyTgCSq4rWAQh3+XW0vY5g3A439pQ2V8grQ4h+82kOYIvCkOAqC8KKYKxZdafXEST
        qGo5aVCpjrAd1/USabQY=
X-Received: by 2002:a05:600c:2292:: with SMTP id 18mr11627458wmf.136.1598539294168;
        Thu, 27 Aug 2020 07:41:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLjn6ioesLZuvJno4GpX4fuvfwIAu0+UbwSF5co10COtOk6HNz4fDGRY0086+HvxSJxGfKEA==
X-Received: by 2002:a05:600c:2292:: with SMTP id 18mr11627429wmf.136.1598539293910;
        Thu, 27 Aug 2020 07:41:33 -0700 (PDT)
Received: from steredhat.lan ([5.170.39.106])
        by smtp.gmail.com with ESMTPSA id a3sm5579959wme.34.2020.08.27.07.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 07:41:33 -0700 (PDT)
Date:   Thu, 27 Aug 2020 16:41:29 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Aleksa Sarai <asarai@suse.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200827144129.5yvu2icj7a5jfp3p@steredhat.lan>
References: <20200827134044.82821-1-sgarzare@redhat.com>
 <2ded8df7-6dcb-ee8a-c1fd-e0c420b7b95d@kernel.dk>
 <20200827141002.an34n2nx6m4dfhce@steredhat.lan>
 <f7c0ff79-87c0-6c7e-b048-b82a45d0f44a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7c0ff79-87c0-6c7e-b048-b82a45d0f44a@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 27, 2020 at 08:10:49AM -0600, Jens Axboe wrote:
> On 8/27/20 8:10 AM, Stefano Garzarella wrote:
> > On Thu, Aug 27, 2020 at 07:50:44AM -0600, Jens Axboe wrote:
> >> On 8/27/20 7:40 AM, Stefano Garzarella wrote:
> >>> v5:
> >>>  - explicitly assigned enum values [Kees]
> >>>  - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
> >>>  - added Kees' R-b tags
> >>>
> >>> v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
> >>> v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
> >>> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
> >>> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
> >>>
> >>> Following the proposal that I send about restrictions [1], I wrote this series
> >>> to add restrictions in io_uring.
> >>>
> >>> I also wrote helpers in liburing and a test case (test/register-restrictions.c)
> >>> available in this repository:
> >>> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
> >>>
> >>> Just to recap the proposal, the idea is to add some restrictions to the
> >>> operations (sqe opcode and flags, register opcode) to safely allow untrusted
> >>> applications or guests to use io_uring queues.
> >>>
> >>> The first patch changes io_uring_register(2) opcodes into an enumeration to
> >>> keep track of the last opcode available.
> >>>
> >>> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
> >>> handle restrictions.
> >>>
> >>> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
> >>> allowing the user to register restrictions, buffers, files, before to start
> >>> processing SQEs.
> >>>
> >>> Comments and suggestions are very welcome.
> >>
> >> Looks good to me, just a few very minor comments in patch 2. If you
> >> could fix those up, let's get this queued for 5.10.
> >>
> > 
> > Sure, I'll fix the issues. This is great :-)
> 
> Thanks! I'll pull in your liburing tests as well once we get the kernel
> side sorted.

Yeah. Let me know if you'd prefer that I send patches on io-uring ML.

About io-uring UAPI, do you think we should set explicitly the enum
values also for IOSQE_*_BIT and IORING_OP_*?

I can send a separated patch for this.

Thanks,
Stefano

