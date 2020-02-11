Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59216158900
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 04:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgBKDp1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Feb 2020 22:45:27 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38398 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgBKDp1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Feb 2020 22:45:27 -0500
Received: by mail-lj1-f196.google.com with SMTP id w1so9922160ljh.5
        for <io-uring@vger.kernel.org>; Mon, 10 Feb 2020 19:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jytg3OiOV0i3x3tzTQ7/WZ7ZtblmSwGkEv/FTZLqVf8=;
        b=tChqH8TRpUFBBIFCGYvMn5JtwvD22TOXvwzJQI+bcyOM+IFajKPy8EFbHP3E7l0VH2
         fVnPGsC3kecZsHpytYZxr0dKN4Qe0P5eELBFCKgNOWeCK51gWjv3GmzLv1QwwuF20Gds
         Oa2cPXy9Y8asFEbiWHYPZ96SK6rmNXunxGEp2e+a37YSjcptSUAMen0t+bZjBzaC9l/H
         uO3H3XRXbeWb1w8nvrpXVO3Zw0t8PBB0Wi3sFD8clHsQMsSG6/yKXmWHMigaz6GzVWWb
         cUvxRGq05G8CUdo9ywHyDp9FFWDK6rr84hCXIsMMkMxI3bbTDy0lnuxwm0w6zS/XPCJ3
         IaSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jytg3OiOV0i3x3tzTQ7/WZ7ZtblmSwGkEv/FTZLqVf8=;
        b=T48iU5uDvmZpdclTtU2LcNHGthtSeUILyvCx+Z/bnbi8NugVRokgMCvPP+R/RUsGSH
         evbAcdMb/9Wd5fiFmgmJAmvpMSMDas/orJSjOK1ZckJRx7TD+8fiRKeAHRKwz/0n+YAO
         qqupuN9YuhvA8N2MocK/DyCaUCdl68ggE35ixXu5tbr+gKq0tcmJhYc36gRj0oH9TTpP
         Ma/Y4TS4mz6yknB23TDC4/bqmSK9OR4D54SODrMy7VYAeDY1Wh8uNu1tXDCjFNIU4UqE
         xo8F+Hp/7wBLfJM/7F0DllUq5LUsTDkCqtwR0aKEoSV6/Ma6NrxhEiE4t3Frko38nkXS
         vwzg==
X-Gm-Message-State: APjAAAV25s2L8hrVJY7zRxpFraiy20RPJoFlmXYqBWwOWlcihIvxrJyE
        R3DojMIc1lsr8mwC/6+UBqI+a5sk65YRT8rXn7K4zw==
X-Google-Smtp-Source: APXvYqw+MERlm935mTNIZKJ0xaGMiBLJtT4bFZNxfF+6A83d+E8OZ1zz0TN6KT9cFaflGJpRgBfUxiEgIsQSJhfm7pI=
X-Received: by 2002:a2e:9052:: with SMTP id n18mr2817551ljg.251.1581392724602;
 Mon, 10 Feb 2020 19:45:24 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
 <6c32ccd9-6d00-5c57-48cc-25fd4f48d5e7@kernel.dk>
In-Reply-To: <6c32ccd9-6d00-5c57-48cc-25fd4f48d5e7@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Mon, 10 Feb 2020 22:45:13 -0500
Message-ID: <CAD-J=zYNXej09AarnJDqgvX5U5aNLh4ez6hddWzWvg-625c1mA@mail.gmail.com>
Subject: Re: Kernel BUG when registering the ring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: multipart/mixed; boundary="00000000000099d7e7059e44af87"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--00000000000099d7e7059e44af87
Content-Type: text/plain; charset="UTF-8"

It crashes all the same

New backtrace attached - looks very similar to the old one, although
not identical.

On Mon, Feb 10, 2020 at 10:25 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/10/20 6:22 PM, Glauber Costa wrote:
> > Hello my dear io_uring friends
> >
> > Today I tried to run my tests on a different, more powerful hardware
> > (70+ Hyperthreads) and it crashed on creating the ring.
> >
> > I don't recall anything fancy in my code for creating the ring -
> > except maybe that I size the cq ring differently than the sq ring.
> >
> > The backtrace attached leads me to believe that we just accessed a
> > null struct somewhere
>
> Yeah, but it's in the alloc code, it's not in io-wq/io_uring.
> Here's where it is crashing:
>
> struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
> {
>         [...]
>         for_each_node(node) {
>                 struct io_wqe *wqe;
>
>                 wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, node);
>
> I guess the node isn't online, and that's why it's crashing. Try the
> below for starters, it should get it going.
>
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 182aa17dc2ca..3898165baccb 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -1115,8 +1116,11 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>
>         for_each_node(node) {
>                 struct io_wqe *wqe;
> +               int alloc_node = node;
>
> -               wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, node);
> +               if (!node_online(alloc_node))
> +                       alloc_node = NUMA_NO_NODE;
> +               wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
>                 if (!wqe)
>                         goto err;
>                 wq->wqes[node] = wqe;
>
> --
> Jens Axboe
>

--00000000000099d7e7059e44af87
Content-Type: text/plain; charset="US-ASCII"; name="newtrace.txt"
Content-Disposition: attachment; filename="newtrace.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_k6hccsfp0>
X-Attachment-Id: f_k6hccsfp0

WyAgIDUyLjk3NjcyM10gT29wczogMDAwMCBbIzFdIFNNUCBOT1BUSQpbICAgNTIuOTc2NzYzXSBD
UFU6IDU2IFBJRDogMjEwNyBDb21tOiBpb193cV9tYW5hZ2VyIE5vdCB0YWludGVkIDUuNS4wKyAj
NwpbICAgNTIuOTc2ODI2XSBIYXJkd2FyZSBuYW1lOiBJbnRlbCBDb3Jwb3JhdGlvbiBTMjYwMFdG
VC9TMjYwMFdGVCwgQklPUyBTRTVDNjIwLjg2Qi4wMi4wMS4wMDA4LjAzMTkyMDE5MTU1OSAwMy8x
OS8yMDE5ClsgICA1Mi45NzY5MjNdIFJJUDogMDAxMDpfX2FsbG9jX3BhZ2VzX25vZGVtYXNrKzB4
MTMyLzB4MzQwClsgICA1Mi45NzY5NzVdIENvZGU6IDE4IDAxIDc1IDA0IDQxIDgwIGNlIDgwIDg5
IGU4IDQ4IDhiIDU0IDI0IDA4IDhiIDc0IDI0IDFjIGMxIGU4IDBjIDQ4IDhiIDNjIDI0IDgzIGUw
IDAxIDg4IDQ0IDI0IDIwIDQ4IDg1IGQyIDBmIDg1IDc0IDAxIDAwIDAwIDwzYj4gNzcgMDggMGYg
ODIgNmIgMDEgMDAgMDAgNDggODkgN2MgMjQgMTAgODkgZWEgNDggOGIgMDcgYjkgMDAgMDIKWyAg
IDUyLjk3NzE0NF0gUlNQOiAwMDE4OmZmZmZhNDhlY2U3NWJjODggRUZMQUdTOiAwMDAxMDI0Ngpb
ICAgNTIuOTc3MTk4XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiAwMDAwMDAwMDAwMDAwMDAw
IFJDWDogMDAwMDAwMDAwMDAwZThlOApbICAgNTIuOTc3MjY1XSBSRFg6IDAwMDAwMDAwMDAwMDAw
MDAgUlNJOiAwMDAwMDAwMDAwMDAwMDAyIFJESTogMDAwMDAwMDAwMDAwMjA4MApbICAgNTIuOTc3
MzMyXSBSQlA6IDAwMDAwMDAwMDAwMTJjYzAgUjA4OiBmZmZmOGI1NGQ4M2E4YTAwIFIwOTogMDAw
MDAwMDAwMDAwMDAwMgpbICAgNTIuOTc3Mzk5XSBSMTA6IDAwMDAwMDAwMDAwMDBkYzAgUjExOiBm
ZmZmOGI1NGUwODAwMTAwIFIxMjogMDAwMDAwMDAwMDAwMDAwMApbICAgNTIuOTc3NDY1XSBSMTM6
IDAwMDAwMDAwMDAwMTJjYzAgUjE0OiAwMDAwMDAwMDAwMDAwMDAxIFIxNTogZmZmZjhiNTRlMTEz
MDBmMApbICAgNTIuOTc3NTMwXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjhi
NTRlMTEwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICA1Mi45Nzc2MDVdIENT
OiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKWyAgIDUyLjk3
NzY2MF0gQ1IyOiAwMDAwMDAwMDAwMDAyMDg4IENSMzogMDAwMDAwZDdlNjYwYTAwNCBDUjQ6IDAw
MDAwMDAwMDA3NjA2ZTAKWyAgIDUyLjk3NzcyNV0gRFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTog
MDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDUyLjk3Nzc5MV0gRFIz
OiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZlMGZmMCBEUjc6IDAwMDAwMDAwMDAw
MDA0MDAKWyAgIDUyLjk3Nzg1OF0gUEtSVTogNTU1NTU1NTQKWyAgIDUyLjk3Nzg4N10gQ2FsbCBU
cmFjZToKWyAgIDUyLjk3NzkyNl0gIGFsbG9jX3NsYWJfcGFnZSsweDQ2LzB4MzIwClsgICA1Mi45
Nzc5NjddICBuZXdfc2xhYisweDlkLzB4NGUwClsgICA1Mi45NzgwMDRdICA/IGFjY291bnRfZW50
aXR5X2VucXVldWUrMHg5Yy8weGQwClsgICA1Mi45NzgwNTVdICBfX19zbGFiX2FsbG9jKzB4NTA3
LzB4NmEwClsgICA1Mi45NzgwOTddICA/IGNyZWF0ZV9pb193b3JrZXIuaXNyYS4wKzB4MzUvMHgx
ODAKWyAgIDUyLjk3ODE0N10gID8gYWN0aXZhdGVfdGFzaysweDdhLzB4MTYwClsgICA1Mi45Nzgx
ODddICA/IGNoZWNrX3ByZWVtcHRfY3VycisweDRhLzB4OTAKWyAgIDUyLjk3ODIzMF0gID8gdHR3
dV9kb193YWtldXArMHgxOS8weDE0MApbICAgNTIuOTc4MjczXSAgX19zbGFiX2FsbG9jKzB4MWMv
MHgzMApbICAgNTIuOTc4MzEyXSAga21lbV9jYWNoZV9hbGxvY19ub2RlX3RyYWNlKzB4YTYvMHgy
NjAKWyAgIDUyLjk3ODM2NF0gIGNyZWF0ZV9pb193b3JrZXIuaXNyYS4wKzB4MzUvMHgxODAKWyAg
IDUyLjk3ODQxMl0gIGlvX3dxX21hbmFnZXIrMHhhNC8weDI1MApbICAgNTIuOTc4NDQ4XSAga3Ro
cmVhZCsweGY5LzB4MTMwClsgICA1Mi45Nzg0NzldICA/IGNyZWF0ZV9pb193b3JrZXIuaXNyYS4w
KzB4MTgwLzB4MTgwClsgICA1Mi45Nzg1MjFdICA/IGt0aHJlYWRfcGFyaysweDkwLzB4OTAKWyAg
IDUyLjk3ODU2MF0gIHJldF9mcm9tX2ZvcmsrMHgxZi8weDQwClsgICA1Mi45Nzg1OThdIE1vZHVs
ZXMgbGlua2VkIGluOiBpcDZ0X1JFSkVDVCBuZl9yZWplY3RfaXB2NiBpcDZ0X3JwZmlsdGVyIGlw
dF9SRUpFQ1QgbmZfcmVqZWN0X2lwdjQgeHRfY29ubnRyYWNrIGVidGFibGVfbmF0IGVidGFibGVf
YnJvdXRlIGlwNnRhYmxlX25hdCBpcDZ0YWJsZV9tYW5nbGUgaXA2dGFibGVfcmF3IGlwNnRhYmxl
X3NlY3VyaXR5IGlwdGFibGVfbmF0IG5mX25hdCBpcHRhYmxlX21hbmdsZSBpcHRhYmxlX3JhdyBp
cHRhYmxlX3NlY3VyaXR5IG5mX2Nvbm50cmFjayBuZl9kZWZyYWdfaXB2NiBuZl9kZWZyYWdfaXB2
NCBpcF9zZXQgbmZuZXRsaW5rIGVidGFibGVfZmlsdGVyIGVidGFibGVzIGlwNnRhYmxlX2ZpbHRl
ciBpcDZfdGFibGVzIGlwdGFibGVfZmlsdGVyIGliX2lzZXJ0IGlzY3NpX3RhcmdldF9tb2QgaWJf
c3JwdCB0YXJnZXRfY29yZV9tb2QgaWJfc3JwIHNjc2lfdHJhbnNwb3J0X3NycCBpYl9pcG9pYiB2
ZmF0IGZhdCBpYl91bWFkIHJwY3JkbWEgc3VucnBjIHJkbWFfdWNtIGliX2lzZXIgcmRtYV9jbSBp
bnRlbF9yYXBsX21zciBpbnRlbF9yYXBsX2NvbW1vbiBpd19jbSBpYl9jbSBpc3N0X2lmX2NvbW1v
biBsaWJpc2NzaSBzY3NpX3RyYW5zcG9ydF9pc2NzaSBza3hfZWRhYyB4ODZfcGtnX3RlbXBfdGhl
cm1hbCBpbnRlbF9wb3dlcmNsYW1wIGNvcmV0ZW1wIGt2bV9pbnRlbCBrdm0gaXJxYnlwYXNzIGk0
MGl3IGNyY3QxMGRpZl9wY2xtdWwgY3JjMzJfcGNsbXVsIGlUQ09fd2R0IGdoYXNoX2NsbXVsbmlf
aW50ZWwgaWJfdXZlcmJzIGlUQ09fdmVuZG9yX3N1cHBvcnQgaW50ZWxfY3N0YXRlIGlwbWlfc3Np
ZiBpYl9jb3JlIGludGVsX3VuY29yZSBqb3lkZXYgaW50ZWxfcmFwbF9wZXJmIGlvYXRkbWEgbWVp
X21lIHBjc3BrciBscGNfaWNoIGkyY19pODAxIG1laSBzd2l0Y2h0ZWMgaXBtaV9zaSBkY2EgaXBt
aV9kZXZpbnRmIGlwbWlfbXNnaGFuZGxlciBkYXhfcG1lbSBkYXhfcG1lbV9jb3JlIGFjcGlfcG93
ZXJfbWV0ZXIgYWNwaV9wYWQKWyAgIDUyLjk3ODY1NV0gIGlwX3RhYmxlcyB4ZnMgbGliY3JjMzJj
IHJma2lsbCBuZF9wbWVtIG5kX2J0dCBhc3QgaTJjX2FsZ29fYml0IGRybV92cmFtX2hlbHBlciBk
cm1fdHRtX2hlbHBlciB0dG0gZHJtX2ttc19oZWxwZXIgY2VjIGRybSBpNDBlIG1lZ2FyYWlkX3Nh
cyBjcmMzMmNfaW50ZWwgbnZtZSBudm1lX2NvcmUgbmZpdCBsaWJudmRpbW0gd21pIHBrY3M4X2tl
eV9wYXJzZXIKWyAgIDUyLjk5NDI1MF0gQ1IyOiAwMDAwMDAwMDAwMDAyMDg4ClsgICA1Mi45OTU2
MDddIC0tLVsgZW5kIHRyYWNlIDU2Yjk1YWFlZjkxN2ZkZmUgXS0tLQpbICAgNTMuMDg3MDc0XSBS
SVA6IDAwMTA6X19hbGxvY19wYWdlc19ub2RlbWFzaysweDEzMi8weDM0MApbICAgNTMuMDg3ODA3
XSBDb2RlOiAxOCAwMSA3NSAwNCA0MSA4MCBjZSA4MCA4OSBlOCA0OCA4YiA1NCAyNCAwOCA4YiA3
NCAyNCAxYyBjMSBlOCAwYyA0OCA4YiAzYyAyNCA4MyBlMCAwMSA4OCA0NCAyNCAyMCA0OCA4NSBk
MiAwZiA4NSA3NCAwMSAwMCAwMCA8M2I+IDc3IDA4IDBmIDgyIDZiIDAxIDAwIDAwIDQ4IDg5IDdj
IDI0IDEwIDg5IGVhIDQ4IDhiIDA3IGI5IDAwIDAyClsgICA1My4wODkxODFdIFJTUDogMDAxODpm
ZmZmYTQ4ZWNlNzViYzg4IEVGTEFHUzogMDAwMTAyNDYKWyAgIDUzLjA4OTg0NV0gUkFYOiAwMDAw
MDAwMDAwMDAwMDAwIFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAwMDAwMDAwMDAwMGU4ZTgK
WyAgIDUzLjA5MDUwMl0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAw
MiBSREk6IDAwMDAwMDAwMDAwMDIwODAKWyAgIDUzLjA5MTE0MV0gUkJQOiAwMDAwMDAwMDAwMDEy
Y2MwIFIwODogZmZmZjhiNTRkODNhOGEwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDIKWyAgIDUzLjA5
MTc3MF0gUjEwOiAwMDAwMDAwMDAwMDAwZGMwIFIxMTogZmZmZjhiNTRlMDgwMDEwMCBSMTI6IDAw
MDAwMDAwMDAwMDAwMDAKWyAgIDUzLjA5MjM5MV0gUjEzOiAwMDAwMDAwMDAwMDEyY2MwIFIxNDog
MDAwMDAwMDAwMDAwMDAwMSBSMTU6IGZmZmY4YjU0ZTExMzAwZjAKWyAgIDUzLjA5MzAyMF0gRlM6
ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4YjU0ZTExMDAwMDAoMDAwMCkga25sR1M6
MDAwMDAwMDAwMDAwMDAwMApbICAgNTMuMDkzNjU5XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAw
MDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICA1My4wOTQyOThdIENSMjogMDAwMDAwMDAwMDAw
MjA4OCBDUjM6IDAwMDAwMGQ3ZTY2MGEwMDQgQ1I0OiAwMDAwMDAwMDAwNzYwNmUwClsgICA1My4w
OTQ5NDddIERSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAw
MDAwMDAwMDAwMDAwMDAwClsgICA1My4wOTU1ODhdIERSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6
IDAwMDAwMDAwZmZmZTBmZjAgRFI3OiAwMDAwMDAwMDAwMDAwNDAwCgo=
--00000000000099d7e7059e44af87--
