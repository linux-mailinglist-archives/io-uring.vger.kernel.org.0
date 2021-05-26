Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDC9390E22
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 04:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhEZCGD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 May 2021 22:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbhEZCGA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 May 2021 22:06:00 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7BEC061756
        for <io-uring@vger.kernel.org>; Tue, 25 May 2021 19:04:28 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y7so21042468eda.2
        for <io-uring@vger.kernel.org>; Tue, 25 May 2021 19:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AVDziIe4V6YxS8ijZfxm39fjCEHx8wW3u92rBRAH8wk=;
        b=wO+80CzEAh2K7zjQM/+DAnqTpqxNNVW5Jdf0wlMQ8P4pL3oox/BSLi2p/cUcQIIseY
         5NHP2F2BEMjNLtOXvK5SSrkFDgxHvO/D7d7QnuX+L4xm48YH9ahiJNoYtCqm2imnh6H3
         11kAOkwpwqV2bO5gUwjHgu3AYJI+XuECE5mH1GwfKY/TSkQkfvvotCyt57HRRXh/GQHw
         zkewwScEbupzXXC6ksgTeAxR09CoSUzt/1YXPmgkvyqeED+LaoOOfrSY6QG3Cl6HC4Vg
         OuMwbo+ryg+zLZSt5wmB9juExFO/KmuGSHCal+vzCamHKvqy1rBT0/iaJRR0JczLKHU/
         4CGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AVDziIe4V6YxS8ijZfxm39fjCEHx8wW3u92rBRAH8wk=;
        b=No2OJke2Ihf0cM2Bk+8YaBFIMxAfNWZKcYaRir/NG7FOdxFn4kXBDVQJqSFkrDPp4p
         7dFpFjck9TNkUVEsjv5e+72INtws1boULa+NzCfek98dDnXyBgBe3/qpuj733kWbqbPI
         Ss8ysAxhwqwx1QpF/GhIb9HUmcHuViJTTslnnhroRmyvELioYnmnRM0tKMrJWwK7DP88
         lgUGVnjGf0iJOrEWrw+bR9Ec0bNYy6SUbjikXXUM4KsHn0105xYZQD7S5bJiHQZmYoeR
         pVCpmZ7mvLn1NIvbqbDDIm8PZUS1MEGrNMJ1/9MvYrULMpAD4NCEuB39mgMjvoh9AHUO
         9fvw==
X-Gm-Message-State: AOAM532PLcR9tho2rUSGlVtY+iViiOx1PcqbJlf+Gvu/wL52vvxUWnJW
        DyHWgZVLSz9O45KIu6hpUKXs4DtgkC3MPA0EImnB
X-Google-Smtp-Source: ABdhPJzLxVYWHyIPDuzmWEqrz4zwzl/MN/HfR7rgSiIG2g2/GNZnsS+o3skTAZzrh5FnnRtatTsqRTZDXToXHCfXJnw=
X-Received: by 2002:aa7:c7cd:: with SMTP id o13mr12537237eds.269.1621994667198;
 Tue, 25 May 2021 19:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl> <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com> <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
In-Reply-To: <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 25 May 2021 22:04:16 -0400
Message-ID: <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 25, 2021 at 9:11 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 5/24/21 1:59 PM, Paul Moore wrote:
> > That said, audit is not for everyone, and we have build time and
> > runtime options to help make life easier.  Beyond simply disabling
> > audit at compile time a number of Linux distributions effectively
> > shortcut audit at runtime by adding a "never" rule to the audit
> > filter, for example:
> >
> >  % auditctl -a task,never
>
> As has been brought up, the issue we're facing is that distros have
> CONFIG_AUDIT=y and hence the above is the best real world case outside
> of people doing custom kernels. My question would then be how much
> overhead the above will add, considering it's an entry/exit call per op.
> If auditctl is turned off, what is the expectation in turns of overhead?

I commented on that case in my last email to Pavel, but I'll try to go
over it again in a little more detail.

As we discussed earlier in this thread, we can skip the req->opcode
check before both the _entry and _exit calls, so we are left with just
the bare audit calls in the io_uring code.  As the _entry and _exit
functions are small, I've copied them and their supporting functions
below and I'll try to explain what would happen in CONFIG_AUDIT=y,
"task,never" case.

+  static inline struct audit_context *audit_context(void)
+  {
+    return current->audit_context;
+  }

+  static inline bool audit_dummy_context(void)
+  {
+    void *p = audit_context();
+    return !p || *(int *)p;
+  }

+  static inline void audit_uring_entry(u8 op)
+  {
+    if (unlikely(audit_enabled && audit_context()))
+      __audit_uring_entry(op);
+  }

We have one if statement where the conditional checks on two
individual conditions.  The first (audit_enabled) is simply a check to
see if anyone has "turned on" auditing at runtime; historically this
worked rather well, and still does in a number of places, but ever
since systemd has taken to forcing audit on regardless of the admin's
audit configuration it is less useful.  The second (audit_context())
is a check to see if an audit_context has been allocated for the
current task.  In the case of "task,never" current->audit_context will
be NULL (see audit_alloc()) and the __audit_uring_entry() slowpath
will never be called.

Worst case here is checking the value of audit_enabled and
current->audit_context.  Depending on which you think is more likely
we can change the order of the check so that the
current->audit_context check is first if you feel that is more likely
to be NULL than audit_enabled is to be false (it may be that way now).

+  static inline void audit_uring_exit(int success, long code)
+  {
+    if (unlikely(!audit_dummy_context()))
+      __audit_uring_exit(success, code);
+  }

The exit call is very similar to the entry call, but in the
"task,never" case it is very simple as the first check to be performed
is the current->audit_context check which we know to be NULL.  The
__audit_uring_exit() slowpath will never be called.

> aio never had any audit logging as far as I can tell. I think it'd make
> a lot more sense to selectively enable audit logging only for opcodes
> that we care about. File open/create/unlink/mkdir etc, that kind of
> thing. File level operations that people would care about logging. Would
> they care about logging a buffer registration or a polled read from a
> device/file? I highly doubt it, and we don't do that for alternative
> methods either. Doesn't really make sense for a lot of the other
> operations, imho.

We would need to check with the current security requirements (there
are distro people on the linux-audit list that keep track of that
stuff), but looking at the opcodes right now my gut feeling is that
most of the opcodes would be considered "security relevant" so
selective auditing might not be that useful in practice.  It would
definitely clutter the code and increase the chances that new opcodes
would not be properly audited when they are merged.

-- 
paul moore
www.paul-moore.com
