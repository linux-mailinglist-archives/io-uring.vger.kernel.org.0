Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B202B15F93D
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 23:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgBNWIJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 17:08:09 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43361 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgBNWII (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 17:08:08 -0500
Received: by mail-lf1-f66.google.com with SMTP id 9so7740982lfq.10
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 14:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EOnxQ29nW6q/oFLiEGQt+o0NnkrJlvHBiIqJVTvoqsg=;
        b=gotL2+qrzLvoZp38NJ8oaGMKiVnhONIgVhjei+CfhjB2fkGaJA3BPayPjJ3tfO+pCQ
         ScJfGp7rS7PAQHVIRnUUvDLEPTgGSx5kfeJRt0mDgPX7RHAKN2rz3CnedLufppr9whEE
         balgyURvaANBJj1oJGjUjALE/YaITta9HmOsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EOnxQ29nW6q/oFLiEGQt+o0NnkrJlvHBiIqJVTvoqsg=;
        b=PuHSGxdqI8QYBwqi8PMffGsYrXbpVuakvFEbbJ9vXvuXQpLCYf5kL1tm2E84gTcfui
         vAFB7ySx9+oSs5qVjF8XdNreC0pjSrXUfGFDGfxzyffVBHRcXJ+PigA3eE2fkomc8QWN
         yrMD7NHpU/BfbIkUFbbRpR8/coR5+hIAHFGkjEkX9v3ZShoDyaD/wLBsPM3UAHoXUYgJ
         zsVF0zRYNq+HkacgOI+BTAYzqxV3X9nzKKUonYGYRUuwHPEH5xQyE0v9NtiC7gUAXdyW
         GRZ0qvA6pQq00kZXlP3x3F38sIBAen5z3vIZlR2qklxbYnqneb5fiQ8KYRMugEu8RsC8
         LnRA==
X-Gm-Message-State: APjAAAXJro/vQ5FME6KrffxwvzVIUWwOY8pHxLr+JdBTgR8pr3q7HCcq
        5WRruivdZeMCE5f2rjAx5zASWqEgikc=
X-Google-Smtp-Source: APXvYqylYkgDN+G3JUkXfVndNtEbl/YJgpv6mYDQqzHK55FQlk3QIxnDdRsORwAxk945xwAFAbBuiw==
X-Received: by 2002:a19:4ad0:: with SMTP id x199mr2645373lfa.13.1581718086305;
        Fri, 14 Feb 2020 14:08:06 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id u15sm3478585lfl.87.2020.02.14.14.08.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 14:08:05 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id 9so7740927lfq.10
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 14:08:05 -0800 (PST)
X-Received: by 2002:a19:c7d8:: with SMTP id x207mr2719756lff.142.1581718084244;
 Fri, 14 Feb 2020 14:08:04 -0800 (PST)
MIME-Version: 1.0
References: <d72d51a9-488d-c75b-4daf-bb74960c7531@kernel.dk>
In-Reply-To: <d72d51a9-488d-c75b-4daf-bb74960c7531@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 14 Feb 2020 14:07:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wixEw+wKJzwfEFnBYLNt5zU6zA2kpNVu_36e33_zsawKA@mail.gmail.com>
Message-ID: <CAHk-=wixEw+wKJzwfEFnBYLNt5zU6zA2kpNVu_36e33_zsawKA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.6-rc2
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 14, 2020 at 8:45 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Here's a set of fixes for io_uring that should go into this release.

Whaa?

          for_each_node(node) {
+                if (!node_online(node))
+                        continue;

that's just silly.

We have 'for_each_online_node()' for this.

There's something like four patterns of that pointless thing.

And in io_wq_create(), do you really want to allocate that wqe for
nodes that aren't online? Right now you _allocate_ the node data for
them (using a non-node-specific allocation), but then you won't
actually create the thread for them io_wq_manager().

Plus if the node online status changes, it looks like you'll mess up
_anyway_, in that  io_wq_manager() will first create the workers on
one set of nodes, but then perhaps set the state flags for a
completely different set of nodes if some onlining/offlining has
happened.

I've pulled this, but Jens, you need to be more careful. This all
looks like completely random state that nobody spent any time thinking
about.

Seriously, this "io_uring FIXES ONLY" needs to be stricter than what
you seem to be doing here. This "fix" is opening up a lot of new
possibilities for inconsistencies in the data structures.

               Linus
