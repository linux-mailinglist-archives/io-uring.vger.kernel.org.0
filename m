Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156E61567AE
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 21:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBHUUv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 15:20:51 -0500
Received: from mail-lf1-f49.google.com ([209.85.167.49]:35518 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbgBHUUv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 15:20:51 -0500
Received: by mail-lf1-f49.google.com with SMTP id z18so1573311lfe.2
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 12:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xSbq2cHDOXvrbtGkDvl6O+nkS/90uIV9Uwlskixzqw4=;
        b=ItKHRS4mr0GXdj0NJemBoY7T8r3L271J6enD+MtCHkDpgSFlTyNGATzTKR0NbyvkzR
         Vqp4hHx+aZMXCiW3xL7yOz5Q3eNj3zbICF9mt8nemkf+yI8W21fj+EaTF81L9R9fasS5
         c2bom/0QejyYdrXoOS8bxlTeGYRWA0lR6CEAOftVYHbRyxEh3QSQYk8BIv4jVTBTU5Y/
         PBrsNG0deB0/13qQEPDip2b1AmpkYxFub5Ilddghbys+9KBqtp45L62qHuHNLpR32EYP
         qqmES46xzuch2Fdja3V93z/iA1qnpHDCE/qXyXgv1VJVVm3Ahijpbe/oha7bkhglLh+A
         nzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xSbq2cHDOXvrbtGkDvl6O+nkS/90uIV9Uwlskixzqw4=;
        b=mtbGmlQrosPFQDdjvRxixTJkEeR4r3A6iOd6NKrQtfEy243hfGfkd9KVlTsp96djon
         8S3kkT42EurdXuSHQGSlT891JhFA0tVayidddPydiu+iQCuWgDZN7s8ZleHGF2G9iOKE
         qxZt+VcVRUqnAR7HsNbMKWflH4fFpM1HLRXPd5cQ8BTmvvPREjbXKOUnw2R6vSpO64NG
         Y1eaf+tJ9Tz72t4vHBvEda+CGWvui29HsWF93fw+4s0GdUtZBrJFzzYFe8fX5xxmfGh4
         sDq10/PJQLJ+Mip/svQQdyBw2jyZLXAPrQcLGtK/9vkLDjgpmO5fWASXErOUxmED4Uht
         d/Qw==
X-Gm-Message-State: APjAAAU5j4CUayw0e1cu0eiyA3mtyVoeGXlRG+IvuKGFewYZ7dV4t6W+
        4BtA+PXvlE/iK1TwPvsRdblXnoGOlJrDnMHhd70cKGZ75VY=
X-Google-Smtp-Source: APXvYqzneSiy08XdaomIBIabZVkIUGQTV7zjimsLC8ZNzRSWzrE44OcEiBVh2k0a0sh12/cv/co8zdDG8gx1kyl9BWs=
X-Received: by 2002:a19:c014:: with SMTP id q20mr2608087lff.208.1581193248923;
 Sat, 08 Feb 2020 12:20:48 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
 <cfc6191b-9db3-9ba7-9776-09b66fa56e76@gmail.com> <CAD-J=zbMcPx1Q5PTOK2VTBNVA+PQX1DrYhXvVRa2tPRXd_2RYQ@mail.gmail.com>
 <9ec6cbf7-0f0b-f777-8507-199e8837df94@scylladb.com> <CAD-J=zZm2B8-EXiX8j2AT5Q0zTCi5rB1gQzzOaYi3JoO1jcqOw@mail.gmail.com>
In-Reply-To: <CAD-J=zZm2B8-EXiX8j2AT5Q0zTCi5rB1gQzzOaYi3JoO1jcqOw@mail.gmail.com>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Sat, 8 Feb 2020 15:20:37 -0500
Message-ID: <CAD-J=zZwH7ceTaAS=ck5_5thGN_ne1kVXOJzZfBK-gorzwNLxg@mail.gmail.com>
Subject: Re: shutdown not affecting connection?
To:     Avi Kivity <avi@scylladb.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Content-Type: multipart/mixed; boundary="000000000000ec8c8a059e163d26"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--000000000000ec8c8a059e163d26
Content-Type: text/plain; charset="UTF-8"

>
>
> > Perhaps you can reduce the
> > problem to a small C reproducer?
> >
> That was my intended next step, yes

s***, I didn't resist and I had to explain to my wife that no, I don't
like io_uring more than I like her.

But here it is.

This is a modification of test/connect.c.
I added a pthread comparison example that should achieve the same
sequence of events:
- try to sync connect
- wait a bit
- shutdown

I added a fixed wait for pthread to make sure that shutdown is not
called before connect.

For io_uring, the shutdown is configurable with the program argument.
This works just fine if I sleep before shutdown (as I would expect from a race).
This hangs every time if I don't.

Unless I am missing something I don't think this is the expected behavior

--000000000000ec8c8a059e163d26
Content-Type: text/x-csrc; charset="US-ASCII"; name="connect.c"
Content-Disposition: attachment; filename="connect.c"
Content-Transfer-Encoding: base64
Content-ID: <f_k6e1mhwl0>
X-Attachment-Id: f_k6e1mhwl0

LyoKICogQ2hlY2sgdGhhdCBJT1JJTkdfT1BfQ09OTkVDVCB3b3Jrcywgd2l0aCBhbmQgd2l0aG91
dCBvdGhlciBzaWRlCiAqIGJlaW5nIG9wZW4uCiAqLwojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1
ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CgojaW5jbHVkZSA8ZXJybm8uaD4KI2lu
Y2x1ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHBvbGwuaD4KI2lu
Y2x1ZGUgPHN5cy9zb2NrZXQuaD4KI2luY2x1ZGUgPG5ldGluZXQvaW4uaD4KI2luY2x1ZGUgPG5l
dGluZXQvdGNwLmg+CgojaW5jbHVkZSAibGlidXJpbmcuaCIKCiNpbmNsdWRlIDxwdGhyZWFkLmg+
CgpzdGF0aWMgaW50IGNyZWF0ZV9zb2NrZXQodm9pZCkKewoJaW50IGZkOwoKCWZkID0gc29ja2V0
KEFGX0lORVQsIFNPQ0tfU1RSRUFNLCBJUFBST1RPX1RDUCk7CglpZiAoZmQgPT0gLTEpIHsKCQlw
ZXJyb3IoInNvY2tldCgpIik7CgkJcmV0dXJuIC0xOwoJfQoKCXJldHVybiBmZDsKfQoKc3RhdGlj
IGludCBzdWJtaXRfYW5kX3dhaXQoc3RydWN0IGlvX3VyaW5nICpyaW5nLCBpbnQgZmQsIGludCAq
cmVzLCBpbnQgc2xlZXBfZm9yKQp7CglzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7CglpbnQgcmV0
OwoKCXJldCA9IGlvX3VyaW5nX3N1Ym1pdChyaW5nKTsKCWlmIChyZXQgIT0gMSkgewoJCWZwcmlu
dGYoc3RkZXJyLCAiaW9fdXNpbmdfc3VibWl0OiBnb3QgJWRcbiIsIHJldCk7CgkJcmV0dXJuIDE7
Cgl9CglpZiAoc2xlZXBfZm9yKSB7CgkgICAgc2xlZXAoc2xlZXBfZm9yKTsKCX0KCXNodXRkb3du
KGZkLCBTSFVUX1JEV1IpOwoKCXdoaWxlICghaW9fdXJpbmdfY3FfcmVhZHkocmluZykpIHt9Cgly
ZXQgPSBpb191cmluZ19wZWVrX2NxZShyaW5nLCAmY3FlKTsKCWlmIChyZXQgPCAwKSB7CgkgICAg
cHJpbnRmKCJwZWVrIGNxZT9cbiIpOwoJICAgIHJldHVybiAtMTsKCX0KCgkqcmVzID0gY3FlLT5y
ZXM7Cglpb191cmluZ19jcWVfc2VlbihyaW5nLCBjcWUpOwoJcmV0dXJuIDA7Cn0KCnN0YXRpYyB2
b2lkICoKdGhyZWFkX3N0YXJ0KHZvaWQgKmFyZykKewoJaW50IGZkID0gKGludCkodWludDY0X3Qp
YXJnOwoJc2xlZXAoMSk7CglzaHV0ZG93bihmZCwgU0hVVF9SRFdSKTsKCXJldHVybiBOVUxMOwp9
CgpzdGF0aWMgaW50IHB0aHJlYWRfY29ubmVjdF9zb2NrZXQoaW50IGZkLCBpbnQgKmNvZGUpCnsK
CXN0cnVjdCBzb2NrYWRkcl9pbiBhZGRyOwoJaW50IHJldDsKCgltZW1zZXQoJmFkZHIsIDAsIHNp
emVvZihhZGRyKSk7CglhZGRyLnNpbl9mYW1pbHkgPSBBRl9JTkVUOwoJYWRkci5zaW5fcG9ydCA9
IDA7CglhZGRyLnNpbl9hZGRyLnNfYWRkciA9IDB4MTAwMTBhYzsKCglwdGhyZWFkX2F0dHJfdCBh
dHRyOwoJaW50IHMgPSBwdGhyZWFkX2F0dHJfaW5pdCgmYXR0cik7CglpZiAocyAhPSAwKSB7Cgkg
ICAgcGVycm9yKCJwdGhyZWFkX2F0dHJfaW5pdCIpOwoJICAgIHJldHVybiAtMTsKCX0KCglwdGhy
ZWFkX3QgdGhyOwoJcyA9IHB0aHJlYWRfY3JlYXRlKCZ0aHIsICZhdHRyLCAmdGhyZWFkX3N0YXJ0
LCAodm9pZCopKHVpbnQ2NF90KWZkKTsKCWlmIChzICE9IDApIHsKCSAgICBwZXJyb3IoInB0aHJl
YWRfY3JlYXRlIik7CgkgICAgcmV0dXJuIC0xOwoJfQoKCXJldCA9IGNvbm5lY3QoZmQsIChzdHJ1
Y3Qgc29ja2FkZHIqKSZhZGRyLCBzaXplb2YoYWRkcikpOwoKCXJldHVybiAocmV0IDwgMCk7Cn0K
CnN0YXRpYyBpbnQgY29ubmVjdF9zb2NrZXQoc3RydWN0IGlvX3VyaW5nICpyaW5nLCBpbnQgZmQs
IGludCAqY29kZSwgaW50IHNsZWVwX2ZvcikKewoJc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlOwoJ
c3RydWN0IHNvY2thZGRyX2luIGFkZHI7CglpbnQgcmVzOwoKCW1lbXNldCgmYWRkciwgMCwgc2l6
ZW9mKGFkZHIpKTsKCWFkZHIuc2luX2ZhbWlseSA9IEFGX0lORVQ7CglhZGRyLnNpbl9wb3J0ID0g
MDsKCWFkZHIuc2luX2FkZHIuc19hZGRyID0gMHgxMDAxMGFjOwoKCXNxZSA9IGlvX3VyaW5nX2dl
dF9zcWUocmluZyk7CglpZiAoIXNxZSkgewoJCWZwcmludGYoc3RkZXJyLCAidW5hYmxlIHRvIGdl
dCBzcWVcbiIpOwoJCXJldHVybiAtMTsKCX0KCglpb191cmluZ19wcmVwX2Nvbm5lY3Qoc3FlLCBm
ZCwgKHN0cnVjdCBzb2NrYWRkciopJmFkZHIsIHNpemVvZihhZGRyKSk7CglzcWUtPnVzZXJfZGF0
YSA9IDE7Cglpb191cmluZ19zcWVfc2V0X2ZsYWdzKHNxZSwgSU9TUUVfQVNZTkMpOwoKCXJldHVy
biBzdWJtaXRfYW5kX3dhaXQocmluZywgZmQsICZyZXMsIHNsZWVwX2Zvcik7Cn0KCnN0YXRpYyBp
bnQgdGVzdF9jb25uZWN0KHN0cnVjdCBpb191cmluZyAqcmluZywgaW50IHVzZV91cmluZywgaW50
IHNsZWVwX2ZvcikKewoJaW50IGNvbm5lY3RfZmQ7CglpbnQgcmV0LCBjb2RlID0gMDsKCgljb25u
ZWN0X2ZkID0gY3JlYXRlX3NvY2tldCgpOwoJaWYgKGNvbm5lY3RfZmQgPT0gLTEpCgkJcmV0dXJu
IC0xOwoKCWlmICh1c2VfdXJpbmcpIHsKCQlyZXQgPSBjb25uZWN0X3NvY2tldChyaW5nLCBjb25u
ZWN0X2ZkLCAmY29kZSwgc2xlZXBfZm9yKTsKCX0gZWxzZSB7CgkJcmV0ID0gcHRocmVhZF9jb25u
ZWN0X3NvY2tldChjb25uZWN0X2ZkLCAmY29kZSk7Cgl9CgoJaWYgKHJldCA9PSAtMSkKCQlnb3Rv
IGVycjsKCglpZiAoY29kZSAhPSAwKSB7CgkJZnByaW50ZihzdGRlcnIsICJjb25uZWN0IGZhaWxl
ZCB3aXRoICVkXG4iLCBjb2RlKTsKCQlnb3RvIGVycjsKCX0KCgljbG9zZShjb25uZWN0X2ZkKTsK
CglyZXR1cm4gMDsKCmVycjoKCWNsb3NlKGNvbm5lY3RfZmQpOwoJcmV0dXJuIC0xOwp9CgppbnQg
bWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdKQp7CglzdHJ1Y3QgaW9fdXJpbmcgcmluZzsKCWlu
dCByZXQ7CglpbnQgc2xlZXBfZm9yOwogICAKCWlmIChhcmdjID09IDEpIHsKCSAgICBzbGVlcF9m
b3IgPSAwOwoJfSBlbHNlIHsKCSAgICBzbGVlcF9mb3IgPSBhdG9pKGFyZ3ZbMV0pOwoJfQoKCXJl
dCA9IGlvX3VyaW5nX3F1ZXVlX2luaXQoOCwgJnJpbmcsIDApOwoJaWYgKHJldCA9PSAtMSkgewoJ
CXBlcnJvcigiaW9fdXJpbmdfcXVldWVfc2V0dXAoKSIpOwoJCXJldHVybiAxOwoJfQoKCXJldCA9
IHRlc3RfY29ubmVjdCgmcmluZywgMCwgc2xlZXBfZm9yKTsKCWlmIChyZXQgPT0gMCkgewoJICAg
IHByaW50Zigic2h1dHRpbmcgZG93biBhIHNvY2tldCB0cnlpbmcgdG8gY29ubmVjdCB3b3JrcyB3
aXRoIHB0aHJlYWRcbiIpOwoJfSBlbHNlIHsKCSAgICByZXR1cm4gLTE7Cgl9CgkKCXJldCA9IHRl
c3RfY29ubmVjdCgmcmluZywgMSwgc2xlZXBfZm9yKTsKCWlmIChyZXQgPT0gMCkgewoJICAgIHBy
aW50Zigic2h1dHRpbmcgZG93biBhIHNvY2tldCB0cnlpbmcgdG8gY29ubmVjdCB3aXRoIHVyaW5n
IHdvcmtzIHRvbywgd2FpdGVkICVkIHMgYmVmb3JlIHNodXRkb3duXG4iLCBzbGVlcF9mb3IpOwoJ
fSBlbHNlIHsKCSAgICByZXR1cm4gLTE7Cgl9CgoJaW9fdXJpbmdfcXVldWVfZXhpdCgmcmluZyk7
CglyZXR1cm4gMDsKfQo=
--000000000000ec8c8a059e163d26--
