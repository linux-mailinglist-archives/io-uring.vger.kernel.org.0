Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E13644142E
	for <lists+io-uring@lfdr.de>; Mon,  1 Nov 2021 08:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhKAHbQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Nov 2021 03:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbhKAHbN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Nov 2021 03:31:13 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D67C0613B9
        for <io-uring@vger.kernel.org>; Mon,  1 Nov 2021 00:28:33 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r12so61574988edt.6
        for <io-uring@vger.kernel.org>; Mon, 01 Nov 2021 00:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4R9B/sJ3SkTmwgevgezogVNj0pw+/Ioeg5KdJ4MvjgQ=;
        b=gZR+2VGt9qWwrm0WE2K4p5YrT7DEJAgqzpUnAK4wT2EH+9ztMw7pGswfd2pJZh/Vx/
         Yhjbgv9A0yupny49Yus6xKvrbcsLFh5NKXN2WntiFu0A4wk2U9bnlL8RNO87J7dYN5dU
         vf4xH0lVB88odXLa0KYlOF70htkDxZ0k513ZUFWHerlBA5j0quNN5rl8ZzN8ymRSWZC/
         j2e2pjHu3HGnMDMbgZumo+BcDaCAu3wkuWu6BC12EF2Dad7Xgs8iz1+AGHJYdc+RNY89
         XzsLi5/9ygwZX3crTqm//iM40n3UfZith8hdsbbzzSmMiUoHbVCvjUIQxLE8d32/xR3Z
         e6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4R9B/sJ3SkTmwgevgezogVNj0pw+/Ioeg5KdJ4MvjgQ=;
        b=5xSBozH6TqXyn1AMEyaPf4Sn3XMC0s1XIQye2N2AlhEX3Oh6r3VmCEHs+x8ZAPv9RS
         YgEo6RsNvgMrE69p+IfIIWTow06saJARwuKGD0byJNM1zicNHw9d0VJjrTs9sDuxK1s6
         ht/d7ohpYUAXZFtbCO3FXz7/KjG2FYzOYBpjEsRHV6wBHkUFBG0rQZK4CPsm8vJg1mm+
         4whL9rZ+0jtHDqMRLTY1Hsht6vgsldRI8dmtx+lca1c/xrMhpoKvzsnkiwUD9VYHj9ay
         7IZCUrREP1jsWyW9rZzdaZ+W/4ML9sDbXk9yZs95IuCqQh7rItCI5/mcGzs5NllcoyeF
         vedQ==
X-Gm-Message-State: AOAM531zwtmWhI+t0eRFxgKex9ZyDLKmGBo+uh1tp4lKXQmnx3Wwif7F
        /mFDO4uxZBJxep5J8X7iFgZfkRcSm4rk+jPuCCyRpg==
X-Google-Smtp-Source: ABdhPJx4TkhqePAQREHt6jMQNaImJqUkrdYWmhMNAyhCDD4C0bFqSidFL4tq20PRQ8u2UOjMVGv9FfNeo1c4Je+fSr0=
X-Received: by 2002:a50:da48:: with SMTP id a8mr38843227edk.146.1635751711791;
 Mon, 01 Nov 2021 00:28:31 -0700 (PDT)
MIME-Version: 1.0
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com> <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com> <YXz0roPH+stjFygk@eldamar.lan>
In-Reply-To: <YXz0roPH+stjFygk@eldamar.lan>
From:   Daniel Black <daniel@mariadb.org>
Date:   Mon, 1 Nov 2021 18:28:19 +1100
Message-ID: <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
Subject: Re: uring regression - lost write request
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000b9096305cfb51f27"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--000000000000b9096305cfb51f27
Content-Type: text/plain; charset="UTF-8"

On Sat, Oct 30, 2021 at 6:30 PM Salvatore Bonaccorso <carnil@debian.org> wrote:

> > > I'm retesting https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.14.14/
> > > in earnest. I did get some assertions, but they may have been
> > > unrelated. The testing continues...
> >
> > Thanks for the work on pinpointing it. I'll wait for your conclusion
> > then, it'll give us an idea what we should look for.
>
> Were you able to pinpoint the issue?

Retesting on the ubuntu mainline 5.14.14 and 5.14.15 was unable to
reproduce the issue in a VM.

Using Fedora (34) 5.14.14 and 5.14.15 kernel I am reasonably able to
reproduce this, and it is now reported as
https://bugzilla.redhat.com/show_bug.cgi?id=2018882.

I've so far been unable to reproduce this issue on 5.15.0-rc7 inside a
(Ubuntu-21.10) VM.

Marko did using a other heavy flushing sysbench script (modified
version attached - slightly lower specs, and can be used on distro
install) was able to see the fault (qps goes to 0) using Debian sid
userspace and 5.15-rc6/5.15-rc7 Ubuntu mainline kernels.
https://jira.mariadb.org/browse/MDEV-26674?focusedCommentId=203645&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-203645

Note if using a mariadb-10.6.5 (not quite released), there's a change
of defaults to avoid this bug, mtr options
--mysqld=--innodb_use_native_aio=1 --nowarnings  will test this
however.

--000000000000b9096305cfb51f27
Content-Type: application/x-shellscript; name="Mariarebench-MDEV-23855.sh"
Content-Disposition: attachment; filename="Mariarebench-MDEV-23855.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_kvgbyqjq0>
X-Attachment-Id: f_kvgbyqjq0

IyEvYmluL2Jhc2gKc2V0IC14IC12CjogJHtTUkNUUkVFPS9tYXJpYWRiLzEwLjVtfQo6ICR7TURJ
Uj0vZGV2L3NobS8xMC41bX0KSURJUj0kQkxEVFJFRS9pbmNsdWRlCjogJHtURElSPS90bXAvc2J0
ZXN0fQpMRF9MSUJSQVJZX1BBVEg9IiRNRElSL2xpYm15c3FsIgpNWVNRTF9TT0NLPSRURElSL215
c3FsZC5zb2NrCk1ZU1FMX1VTRVI9cm9vdApCRU5DSF9USU1FPTEyMDAKQkVOQ0hfVEhSRUFEUz0i
OCIKIyBGcmVxdWVudGx5IHVzZWQgdGVzdHM6IG9sdHBfdXBkYXRlX2luZGV4LCBvbHRwX3VwZGF0
ZV9ub25faW5kZXgsIG9sdHBfcmVhZF93cml0ZSwgY29ubmVjdCwgb2x0cF9yZWFkX29ubHksIG9s
dHBfcG9pbnRfc2VsZWN0ClNZU0JFTkNIPSJzeXNiZW5jaCAvdXNyL3NoYXJlL3N5c2JlbmNoL29s
dHBfdXBkYXRlX2luZGV4Lmx1YSBcCiAgLS1teXNxbC1zb2NrZXQ9JE1ZU1FMX1NPQ0sgXAogIC0t
bXlzcWwtdXNlcj0kTVlTUUxfVVNFUiBcCiAgLS1teXNxbC1kYj10ZXN0IFwKICAtLXBlcmNlbnRp
bGU9OTkgXAogIC0tdGFibGVzPTggXAogIC0tdGFibGVfc2l6ZT0yMDAwMDAiClBGUz1vZmYKICAj
LS1teXNxbF9zdG9yYWdlX2VuZ2luZT1hcmlhIC0tcG9pbnRfc2VsZWN0cz0xMDAwIC0tc2ltcGxl
X3Jhbmdlcz0wIC0tc3VtX3Jhbmdlcz0wIC0tb3JkZXJfcmFuZ2VzPTAgLS1kaXN0aW5jdF9yYW5n
ZXM9MCBcCiAgIy0tYXJpYS1wYWdlY2FjaGUtYnVmZmVyLXNpemU9MjA0OE0gXAojcm0gLXJmICIk
VERJUiIKI2NkICRNRElSCm15c3FsX2luc3RhbGxfZGIgLS11c2VyPSIkVVNFUk5BTUUiIC0tZGF0
YWRpcj0iJFRESVIiIC0tYXV0aC1yb290LWF1dGhlbnRpY2F0aW9uLW1ldGhvZD1ub3JtYWwKI2Nk
IC4uLwpudW1hY3RsIC0tY3B1bm9kZWJpbmQgMCAtLWxvY2FsYWxsb2MgXApteXNxbGQgLS1uby1k
ZWZhdWx0cyAtLWdkYiAtLWNvcmUtZmlsZSAtLWxvb3NlLWRlYnVnLXN5bmMtdGltZW91dD0zMDAg
LS1pbm5vZGIgXAogIC0tZGF0YWRpcj0iJFRESVIiICAtLXNvY2tldD0kTVlTUUxfU09DSyBcCiAg
LS1pbm5vZGJfbG9nX2ZpbGVfc2l6ZT0yNTZNXAogIC0taW5ub2RiX2J1ZmZlcl9wb29sX3NpemU9
OEcgXAogIC0taW5ub2RiX2lvX2NhcGFjaXR5PTcwMDAwXAogIC0taW5ub2RiX2lvX2NhcGFjaXR5
X21heD05MDAwMCBcCiAgLS1pbm5vZGJfZmx1c2hfbG9nX2F0X3RyeF9jb21taXQ9MCBcCiAgLS1p
bm5vZGJfYWRhcHRpdmVfZmx1c2hpbmdfbHdtPTAgXAogIC0taW5ub2RiX2ZpbGUtcGVyLXRhYmxl
PTEgXAogIC0taW5ub2RiLWZhc3Qtc2h1dGRvd249MCBcCiAgLS1pbm5vZGItZmx1c2gtbWV0aG9k
PU9fRElSRUNUIFwKICAtLWlubm9kYl9mbHVzaF9zeW5jPTEgXAogIC0taW5ub2RiX2xydV9zY2Fu
X2RlcHRoPTEwMjQgXAogIC0taW5ub2RiX2xydV9mbHVzaF9zaXplPTI1NiBcClwKICAtLW1heC1j
b25uZWN0aW9ucz0yMDQ4IFwKICAtLXRhYmxlX29wZW5fY2FjaGU9NDA5NiBcCiAgLS1tYXhfcHJl
cGFyZWRfc3RtdF9jb3VudD0xMDQ4NTc2IFwKICAtLWFyaWEtY2hlY2twb2ludC1pbnRlcnZhbD0w
IFwKXAogIC0tbG9vc2UtcGVyZm9ybWFuY2Utc2NoZW1hLWNvbnN1bWVyLWV2ZW50c193YWl0c19j
dXJyZW50PW9uIFwKICAtLWxvb3NlLXBlcmZvcm1hbmNlLXNjaGVtYS1jb25zdW1lci1ldmVudHNf
c3RhdGVtZW50c19jdXJyZW50PW9mZiBcCiAgLS1sb29zZS1wZXJmb3JtYW5jZS1zY2hlbWEtY29u
c3VtZXItc3RhdGVtZW50c19kaWdlc3Q9b2ZmIFwKICAtLWxvb3NlLXBlcmZvcm1hbmNlLXNjaGVt
YS1pbnN0cnVtZW50PSclPW9mZicgXAogIC0tbG9vc2UtcGVyZm9ybWFuY2Utc2NoZW1hLWluc3Ry
dW1lbnQ9J3dhaXQvc3luY2gvbXV0ZXgvJT1vbicgXAogIC0tbG9vc2UtcGVyZm9ybWFuY2Utc2No
ZW1hLWluc3RydW1lbnQ9J3dhaXQvc3luY2gvcndsb2NrLyU9b24nIFwKICAtLWxvb3NlLXBlcmZv
cm1hbmNlLXNjaGVtYT0kUEZTID4gIiRURElSIi9teXNxbGQuZXJyIDI+JjEgJgp0aW1lbz02MDAK
ZWNobyAtbiAid2FpdGluZyBmb3Igc2VydmVyIHRvIGNvbWUgdXAgIgp3aGlsZSBbICR0aW1lbyAt
Z3QgMCBdCmRvCiAgbXlzcWxhZG1pbiAtUyAkTVlTUUxfU09DSyAtdSAkTVlTUUxfVVNFUiAtYiAt
cyBwaW5nICYmIGJyZWFrCiAgZWNobyAtbiAiLiIKICB0aW1lbz0kKCgkdGltZW8gLSAxKSkKICBz
bGVlcCAxCmRvbmUKCmlmIFsgJHRpbWVvIC1lcSAwIF0KdGhlbgogIGVjaG8gIiBzZXJ2ZXIgbm90
IHN0YXJ0aW5nISBBYm9ydCEiCiAgYnJlYWsKZmkKCm51bWFjdGwgLS1jcHVub2RlYmluZCAwIC0t
bG9jYWxhbGxvYyAkU1lTQkVOQ0ggLS10aHJlYWRzPSRCRU5DSF9USFJFQURTIGNsZWFudXAgfHwg
ZWNobyBhbHJlYWR5IGNsZWFuCm51bWFjdGwgLS1jcHVub2RlYmluZCAwIC0tbG9jYWxhbGxvYyAk
U1lTQkVOQ0ggLS10aHJlYWRzPSRCRU5DSF9USFJFQURTIHByZXBhcmUKCmZvciBpIGluICRCRU5D
SF9USFJFQURTCmRvCiAgbXlzcWwgLS1uby1kZWZhdWx0cyAtdSAkTVlTUUxfVVNFUiAtUyAkTVlT
UUxfU09DSyAtZSAidHJ1bmNhdGUgdGFibGUgZXZlbnRzX3dhaXRzX3N1bW1hcnlfZ2xvYmFsX2J5
X2V2ZW50X25hbWUiIHBlcmZvcm1hbmNlX3NjaGVtYQogIG51bWFjdGwgLS1jcHVub2RlYmluZCAw
IC0tbG9jYWxhbGxvYyAkU1lTQkVOQ0ggLS1yYW5kLXNlZWQ9NDIgLS1yYW5kLXR5cGU9dW5pZm9y
bSAtLW1heC1yZXF1ZXN0cz0wIC0tdGltZT0kQkVOQ0hfVElNRSAtLXJlcG9ydC1pbnRlcnZhbD01
IC0tdGhyZWFkcz0kaSBydW4KICBbICIkUEZTIiA9ICJvZmYiIF0gfHwKICBteXNxbCAtdSAkTVlT
UUxfVVNFUiAtUyAkTVlTUUxfU09DSyAtZQogICJzZWxlY3QgRVZFTlRfTkFNRSxDT1VOVF9TVEFS
LFJPVU5EKFNVTV9USU1FUl9XQUlULzEwMDAwMDAwMDAwMDAsMikgQVMgU0VDT05EUyxTVU1fVElN
RVJfV0FJVCxNSU5fVElNRVJfV0FJVCxBVkdfVElNRVJfV0FJVCxNQVhfVElNRVJfV0FJVCBcCiAg
ZnJvbSBwZXJmb3JtYW5jZV9zY2hlbWEuZXZlbnRzX3dhaXRzX3N1bW1hcnlfZ2xvYmFsX2J5X2V2
ZW50X25hbWUgb3JkZXIgYnkgc3VtX3RpbWVyX3dhaXQgZGVzYyBsaW1pdCAyMCIgcGVyZm9ybWFu
Y2Vfc2NoZW1hCmRvbmUKCiMkU1lTQkVOQ0ggY2xlYW51cApteXNxbGFkbWluIC11ICRNWVNRTF9V
U0VSIC1TICRNWVNRTF9TT0NLIHNodXRkb3duCg==
--000000000000b9096305cfb51f27--
