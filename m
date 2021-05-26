Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F90391C5D
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 17:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhEZPvV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 11:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbhEZPvM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 11:51:12 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBF5C061574
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 08:49:29 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w12so2146207edx.1
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 08:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hLvM0qZWdxlY7ci8mQoY0tiiY+8Mcy4oEt5BU4lJ9+k=;
        b=ggzK6VZhCRLTfWGjQrehiYwZ40mLNPjUpPXzYM3fAeBQPdZa8+CYKZvUBvdcSjODtY
         mvIVJ1vndejpV9VgryvmHn+T0d26E2VFQyfIVL3qP7lEqiN+aDcBCzkEtaiRdFyJhrsR
         puSF/5bx+BmzVnFfGPeVMFPbkcyjliw90/8cJBcFUO8DKNJsNGJsPRvwkViF0KFVez78
         tq0ff/Q5pX86sPp3t6Lc1vmZ2PsOjEISwanl5mLhptQAmNc5JkhosHpCQGDhvpUdLJ6i
         auNnJvr0TbO1RGGf/lr8KlaIAj5yG70+sSrjfpO9g1P63hWkvLYodX7pdF3ByP2OP6gi
         p+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hLvM0qZWdxlY7ci8mQoY0tiiY+8Mcy4oEt5BU4lJ9+k=;
        b=aawwJM2CCmI7ksP5zZhc864J+Dzyt3UyMHs/d3w3gSW2mUkXJpDwopFZA55wNVfL31
         iF9r2tjs/gOMEaDGoBE0AH3ZETGz53+034ycHnbKLmjsAiWFl+HetY04soKh4RL+cfMS
         udsXn0L4LsIuLlLbiSNUzKvGrfMf9YdlpXFjhO95eaWnNRmEKsPVl3Z2zZhG1tZn5Nxb
         /+ywCUluVo5EZTuC10CQA5zP3AIOJKsKWc+BmwMFXplTzTuJsvF9Z+uA1b4YxtYIqar/
         NJkLj+Ftp2Ex5TM+dLu/lYYzyJNwzHmmFSWDZx4OzPLPOpWFPRHMKQIEGPk4zzWJj6gA
         43sA==
X-Gm-Message-State: AOAM530Z18ZVg1EN/s6bHW74bPb4HVwtJL4wIelJPt8oV1+/IJUSyz9I
        WRmBTHvWFilT9I0yH3rWHJ2ipJWtwpbep8YiAi7uSw==
X-Google-Smtp-Source: ABdhPJzmgIJFBTXLdZvOp6D/+i59vYx4OZSxpIJQjeaRsrMNn5z0yDJEgqvwU+7tOeA0PSsmkvfxgCH0X7UOQIaFBqg=
X-Received: by 2002:aa7:d3c8:: with SMTP id o8mr38038619edr.181.1622044167887;
 Wed, 26 May 2021 08:49:27 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl> <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com> <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk> <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <0a668302-b170-31ce-1651-ddf45f63d02a@gmail.com> <CAHC9VhTAvcB0A2dpv1Xn7sa+Kh1n+e-dJr_8wSSRaxS4D0f9Sw@mail.gmail.com>
 <18823c99-7d65-0e6f-d508-a487f1b4b9e7@samba.org>
In-Reply-To: <18823c99-7d65-0e6f-d508-a487f1b4b9e7@samba.org>
From:   Victor Stewart <v@nametag.social>
Date:   Wed, 26 May 2021 11:49:16 -0400
Message-ID: <CAM1kxwjFeawYPudx+ARBMYXgMtU_ypwuSKP7x7U7AQ69LxGQgQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Paul Moore <paul@paul-moore.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> I'm wondering why it's not enough to have the native auditing just to happen.
>
> E.g. all (I have checked RECVMSG,SENDMSG,SEND and CONNECT) socket related io_uring opcodes
> already go via security_socket_{recvmsg,sendmsg,connect}()
>
> IORING_OP_OPENAT* goes via do_filp_open() which is in common with the open[at[2]]() syscalls
> and should also trigger audit_inode() and security_file_open().
>
> So why is there anything special needed for io_uring (now that the native worker threads are used)?
>
> Is there really any io_uring opcode that bypasses the security checks the corresponding native syscall
> would do? If so, I think that should just be fixed...

stefan's points crossed my mind as well.

but assuming iouring buy-in is required, from a design perspective,
rather than inserting these audit conditionals in the hotpath,
wouldn't a layering model work better?
aka enabling auditing changes the function entry point into io_uring
and passes operations through an auditing layer, then back to the main
entry point. then there is no
cost to audit disabled code, and you just force audit to pay whatever
double processing cost that entails.

V
