Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA281587E5
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 02:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgBKBWv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Feb 2020 20:22:51 -0500
Received: from mail-lj1-f179.google.com ([209.85.208.179]:34691 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbgBKBWu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Feb 2020 20:22:50 -0500
Received: by mail-lj1-f179.google.com with SMTP id x7so9701355ljc.1
        for <io-uring@vger.kernel.org>; Mon, 10 Feb 2020 17:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=LClKpp4LNDuMCIBKCbl82Soq0whrHZZdHwEhAJCjTVw=;
        b=eE+wHg5v7R1+6Ad1SvrhOtBlP4aYlpc9/VsUrJ4MQoYpd5ZkXxwjd/b+t+WaILgJJ9
         q5kU6ZrBcKCebbUMAjsteXS1drnTJTKOodmI2mFRV/EuhjkfhVfhBt7U83nBp1A2mnic
         p6IqrNctGzEs0WNvdOb2UBM5xAYVll3bxY2StLTMZkYLio5MAWx7U3LultHXBZ9pMd8W
         8H6RlN8WrH5JLyAyCcMSl93ywaVsYloRCA9iYdBdebCII4cYc3uQDUR6xWL9Nody0L2u
         BWuTfHoNtkBy2VfSkR8CwBmm/zVrZe+j39+Yv+1GHLpSuDZNsoMaxveXcyWzBkUG5sAq
         1hRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LClKpp4LNDuMCIBKCbl82Soq0whrHZZdHwEhAJCjTVw=;
        b=IeqJ+Fs9Htsl5qJ671HHW7VSjv2f+Nyh+GLM2cA3+g2+ngeF3l+ywHUEeCkgnbiHI/
         lEg6RHz9T5C2NDhrqNwGz18RZp5UyzAb7hqGJN8Gm6CE+dbThJ5U8RXWExbDfDSW2ATf
         4vzntEl9tdunH79v1DikB5KxxbB6S3CdSFmeH/azd3kGdk6iNdTCQ62l7E4zR+RiSTGo
         R6iM009kqGNCF+Y76eqFmYPp5ip3K0/zt7YctbMWVYevYG0w8i+2F9hULKCB9DEPnPQU
         LUlpAKS1G1wf586kbf6xEulHLgEXynt5Br5SPGWWdaAsztBXcPmKqdU3x5EK63Moy2A3
         +02w==
X-Gm-Message-State: APjAAAVMKK3Wz2VBluWehpFFsARP/x2AjPxJP65qV/sFBj/pcOvBMt3r
        aAiVFsUYPArbWtxzgkt/CWr9BTp7uaOU83x+9mQNv4+QngCb6Q==
X-Google-Smtp-Source: APXvYqyyMOaOXN5pKMe6R5y9TAaFfceoCnj9bSsj4qXF3AqQ0FCjcRKffuknlTe3R0FOlVFg8Ly7FX3uUfk/a4mrLhw=
X-Received: by 2002:a05:651c:1049:: with SMTP id x9mr2638191ljm.233.1581384168537;
 Mon, 10 Feb 2020 17:22:48 -0800 (PST)
MIME-Version: 1.0
From:   Glauber Costa <glauber@scylladb.com>
Date:   Mon, 10 Feb 2020 20:22:37 -0500
Message-ID: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
Subject: Kernel BUG when registering the ring
To:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: multipart/mixed; boundary="0000000000009eae62059e42b15c"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--0000000000009eae62059e42b15c
Content-Type: text/plain; charset="UTF-8"

Hello my dear io_uring friends

Today I tried to run my tests on a different, more powerful hardware
(70+ Hyperthreads) and it crashed on creating the ring.

I don't recall anything fancy in my code for creating the ring -
except maybe that I size the cq ring differently than the sq ring.

The backtrace attached leads me to believe that we just accessed a
null struct somewhere

Hash is ba2db2d4d262f7ccf6fe86b00c3538056d7c5218

--0000000000009eae62059e42b15c
Content-Type: text/plain; charset="US-ASCII"; name="creation.txt"
Content-Disposition: attachment; filename="creation.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_k6h76l6m0>
X-Attachment-Id: f_k6h76l6m0

WyAgODk0LjkxODkyN10gWEZTIChudm1lMG4xcDEpOiBNb3VudGluZyBWNSBGaWxlc3lzdGVtClsg
IDg5NC45Mjg5NjRdIFhGUyAobnZtZTBuMXAxKTogRW5kaW5nIGNsZWFuIG1vdW50ClsgIDg5NC45
MzAxMTFdIHhmcyBmaWxlc3lzdGVtIGJlaW5nIG1vdW50ZWQgYXQgL3Zhci9kaXNrMSBzdXBwb3J0
cyB0aW1lc3RhbXBzIHVudGlsIDIwMzggKDB4N2ZmZmZmZmYpClsgIDkwMS4wMDA4MjBdIEJVRzog
dW5hYmxlIHRvIGhhbmRsZSBwYWdlIGZhdWx0IGZvciBhZGRyZXNzOiAwMDAwMDAwMDAwMDAyMDg4
ClsgIDkwMS4wMDA4ODddICNQRjogc3VwZXJ2aXNvciByZWFkIGFjY2VzcyBpbiBrZXJuZWwgbW9k
ZQpbICA5MDEuMDAwOTI3XSAjUEY6IGVycm9yX2NvZGUoMHgwMDAwKSAtIG5vdC1wcmVzZW50IHBh
Z2UKWyAgOTAxLjAwMDk2OV0gUEdEIDE3NDEwMWIwNjcgUDREIDE3NDEwMWIwNjcgUFVEIDE3YzMw
Y2QwNjcgUE1EIDAgClsgIDkwMS4wMDEwMTldIE9vcHM6IDAwMDAgWyMxXSBTTVAgTk9QVEkKWyAg
OTAxLjAwMTA1Ml0gQ1BVOiA0MCBQSUQ6IDIxNDQgQ29tbTogaW9fdGVzdGVyIE5vdCB0YWludGVk
IDUuNS4wKyAjNgpbICA5MDEuMDAxMTAxXSBIYXJkd2FyZSBuYW1lOiBJbnRlbCBDb3Jwb3JhdGlv
biBTMjYwMFdGVC9TMjYwMFdGVCwgQklPUyBTRTVDNjIwLjg2Qi4wMi4wMS4wMDA4LjAzMTkyMDE5
MTU1OSAwMy8xOS8yMDE5ClsgIDkwMS4wMDExODddIFJJUDogMDAxMDpfX2FsbG9jX3BhZ2VzX25v
ZGVtYXNrKzB4MTMyLzB4MzQwClsgIDkwMS4wMDEyMzFdIENvZGU6IDE4IDAxIDc1IDA0IDQxIDgw
IGNlIDgwIDg5IGU4IDQ4IDhiIDU0IDI0IDA4IDhiIDc0IDI0IDFjIGMxIGU4IDBjIDQ4IDhiIDNj
IDI0IDgzIGUwIDAxIDg4IDQ0IDI0IDIwIDQ4IDg1IGQyIDBmIDg1IDc0IDAxIDAwIDAwIDwzYj4g
NzcgMDggMGYgODIgNmIgMDEgMDAgMDAgNDggODkgN2MgMjQgMTAgODkgZWEgNDggOGIgMDcgYjkg
MDAgMDIKWyAgOTAxLjAwMTM3MF0gUlNQOiAwMDE4OmZmZmZiOGJlNGQwYjdjMjggRUZMQUdTOiAw
MDAxMDI0NgpbICA5MDEuMDAxNDEzXSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiAwMDAwMDAw
MDAwMDAwMDAwIFJDWDogMDAwMDAwMDAwMDAwZThlOApbICA5MDEuMDAxNDY2XSBSRFg6IDAwMDAw
MDAwMDAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMDAyIFJESTogMDAwMDAwMDAwMDAwMjA4MApb
ICA5MDEuMDAxNDk5XSBSQlA6IDAwMDAwMDAwMDAwMTJjYzAgUjA4OiAwMDAwMDAwMDAwMDAwMDAw
IFIwOTogMDAwMDAwMDAwMDAwMDAwMgpbICA5MDEuMDAxNTE2XSBSMTA6IDAwMDAwMDAwMDAwMDBk
YzAgUjExOiBmZmZmOTk1YzYwNDAwMTAwIFIxMjogMDAwMDAwMDAwMDAwMDAwMApbICA5MDEuMDAx
NTM0XSBSMTM6IDAwMDAwMDAwMDAwMTJjYzAgUjE0OiAwMDAwMDAwMDAwMDAwMDAxIFIxNTogZmZm
Zjk5NWM2MGRiMDBmMApbICA5MDEuMDAxNTUyXSBGUzogIDAwMDA3ZjRkMTE1Y2E5MDAoMDAwMCkg
R1M6ZmZmZjk5NWM2MGQ4MDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgIDkwMS4w
MDE1NzJdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMK
WyAgOTAxLjAwMTU4Nl0gQ1IyOiAwMDAwMDAwMDAwMDAyMDg4IENSMzogMDAwMDAwMTdjY2E2NjAw
MiBDUjQ6IDAwMDAwMDAwMDA3NjA2ZTAKWyAgOTAxLjAwMTYwNF0gRFIwOiAwMDAwMDAwMDAwMDAw
MDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgOTAxLjAw
MTYyMl0gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZlMGZmMCBEUjc6IDAw
MDAwMDAwMDAwMDA0MDAKWyAgOTAxLjAwMTY0MF0gUEtSVTogNTU1NTU1NTQKWyAgOTAxLjAwMTY0
N10gQ2FsbCBUcmFjZToKWyAgOTAxLjAwMTY2M10gIGFsbG9jX3NsYWJfcGFnZSsweDQ2LzB4MzIw
ClsgIDkwMS4wMDE2NzZdICBuZXdfc2xhYisweDlkLzB4NGUwClsgIDkwMS4wMDE2ODddICBfX19z
bGFiX2FsbG9jKzB4NTA3LzB4NmEwClsgIDkwMS4wMDE3MDJdICA/IGlvX3dxX2NyZWF0ZSsweGI0
LzB4MmEwClsgIDkwMS4wMDE3MTNdICBfX3NsYWJfYWxsb2MrMHgxYy8weDMwClsgIDkwMS4wMDE3
MjVdICBrbWVtX2NhY2hlX2FsbG9jX25vZGVfdHJhY2UrMHhhNi8weDI2MApbICA5MDEuMDAxNzM4
XSAgaW9fd3FfY3JlYXRlKzB4YjQvMHgyYTAKWyAgOTAxLjAwMTc1MF0gIGlvX3VyaW5nX3NldHVw
KzB4OTdmLzB4YWEwClsgIDkwMS4wMDE3NjJdICA/IGlvX3JlbW92ZV9wZXJzb25hbGl0aWVzKzB4
MzAvMHgzMApbICA5MDEuMDAxNzc2XSAgPyBpb19wb2xsX3RyaWdnZXJfZXZmZCsweDMwLzB4MzAK
WyAgOTAxLjAwMTc5MV0gIGRvX3N5c2NhbGxfNjQrMHg1Yi8weDFjMApbICA5MDEuMDAxODA2XSAg
ZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NDQvMHhhOQpbICA5MDEuMDAxODIwXSBS
SVA6IDAwMzM6MHg3ZjRkMTE2Y2IxZWQKWyAgOTAxLjAwMTgzMV0gQ29kZTogMDAgYzMgNjYgMmUg
MGYgMWYgODQgMDAgMDAgMDAgMDAgMDAgOTAgZjMgMGYgMWUgZmEgNDggODkgZjggNDggODkgZjcg
NDggODkgZDYgNDggODkgY2EgNGQgODkgYzIgNGQgODkgYzggNGMgOGIgNGMgMjQgMDggMGYgMDUg
PDQ4PiAzZCAwMSBmMCBmZiBmZiA3MyAwMSBjMyA0OCA4YiAwZCA2YiA1YyAwYyAwMCBmNyBkOCA2
NCA4OSAwMSA0OApbICA5MDEuMDAxODc1XSBSU1A6IDAwMmI6MDAwMDdmZmY2NDFkZGY1OCBFRkxB
R1M6IDAwMDAwMjAyIE9SSUdfUkFYOiAwMDAwMDAwMDAwMDAwMWE5ClsgIDkwMS4wMDE4OTRdIFJB
WDogZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAwMDA3ZmZmNjQxZGUwZjAgUkNYOiAwMDAwN2Y0ZDEx
NmNiMWVkClsgIDkwMS4wMDE5MTFdIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDA3ZmZm
NjQxZGRmYjAgUkRJOiAwMDAwMDAwMDAwMDAwMDgwClsgIDkwMS4wMDE5MjhdIFJCUDogMDAwMDAw
MDAwMDAwMDA4MCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwNjAwMDAwMDgxYzIwClsg
IDkwMS4wMDI0NzFdIFIxMDogMDAwMDdmNGQxMTVjOTgwMCBSMTE6IDAwMDAwMDAwMDAwMDAyMDIg
UjEyOiAwMDAwN2ZmZjY0MWRkZmIwClsgIDkwMS4wMDI5NzFdIFIxMzogMDAwMDdmZmY2NDFkZTBm
MCBSMTQ6IDAwMDA3ZmZmNjQxZGUwYzAgUjE1OiAwMDAwN2ZmZjY0MWRlNGU4ClsgIDkwMS4wMDM0
NzBdIE1vZHVsZXMgbGlua2VkIGluOiBpcDZ0X1JFSkVDVCBuZl9yZWplY3RfaXB2NiBpcDZ0X3Jw
ZmlsdGVyIGlwdF9SRUpFQ1QgbmZfcmVqZWN0X2lwdjQgeHRfY29ubnRyYWNrIGVidGFibGVfbmF0
IGVidGFibGVfYnJvdXRlIGlwNnRhYmxlX25hdCBpcDZ0YWJsZV9tYW5nbGUgaXA2dGFibGVfcmF3
IGlwNnRhYmxlX3NlY3VyaXR5IGlwdGFibGVfbmF0IG5mX25hdCBpcHRhYmxlX21hbmdsZSBpcHRh
YmxlX3JhdyBpcHRhYmxlX3NlY3VyaXR5IG5mX2Nvbm50cmFjayBuZl9kZWZyYWdfaXB2NiBuZl9k
ZWZyYWdfaXB2NCBpcF9zZXQgbmZuZXRsaW5rIGVidGFibGVfZmlsdGVyIGVidGFibGVzIGlwNnRh
YmxlX2ZpbHRlciBpcDZfdGFibGVzIGlwdGFibGVfZmlsdGVyIGliX2lzZXJ0IGlzY3NpX3Rhcmdl
dF9tb2QgaWJfc3JwdCB0YXJnZXRfY29yZV9tb2QgaWJfc3JwIHNjc2lfdHJhbnNwb3J0X3NycCBp
Yl9pcG9pYiB2ZmF0IGZhdCBpYl91bWFkIGludGVsX3JhcGxfbXNyIGludGVsX3JhcGxfY29tbW9u
IHJwY3JkbWEgaXNzdF9pZl9jb21tb24gc3VucnBjIHJkbWFfdWNtIGliX2lzZXIgc2t4X2VkYWMg
cmRtYV9jbSB4ODZfcGtnX3RlbXBfdGhlcm1hbCBpbnRlbF9wb3dlcmNsYW1wIGl3X2NtIGNvcmV0
ZW1wIGt2bV9pbnRlbCBpYl9jbSBsaWJpc2NzaSBzY3NpX3RyYW5zcG9ydF9pc2NzaSBrdm0gaXJx
YnlwYXNzIGNyY3QxMGRpZl9wY2xtdWwgY3JjMzJfcGNsbXVsIGk0MGl3IGdoYXNoX2NsbXVsbmlf
aW50ZWwgaWJfdXZlcmJzIGlUQ09fd2R0IGlUQ09fdmVuZG9yX3N1cHBvcnQgaW50ZWxfY3N0YXRl
IGliX2NvcmUgaXBtaV9zc2lmIGludGVsX3VuY29yZSBqb3lkZXYgaW50ZWxfcmFwbF9wZXJmIG1l
aV9tZSBpMmNfaTgwMSBpb2F0ZG1hIHN3aXRjaHRlYyBwY3Nwa3IgbHBjX2ljaCBtZWkgaXBtaV9z
aSBkY2EgaXBtaV9kZXZpbnRmIGlwbWlfbXNnaGFuZGxlciBkYXhfcG1lbSBkYXhfcG1lbV9jb3Jl
IGFjcGlfcG93ZXJfbWV0ZXIgYWNwaV9wYWQKWyAgOTAxLjAwMzUwNF0gIGlwX3RhYmxlcyB4ZnMg
bGliY3JjMzJjIHJma2lsbCBuZF9wbWVtIG5kX2J0dCBhc3QgaTJjX2FsZ29fYml0IGRybV92cmFt
X2hlbHBlciBkcm1fdHRtX2hlbHBlciB0dG0gZHJtX2ttc19oZWxwZXIgY2VjIGRybSBpNDBlIG1l
Z2FyYWlkX3NhcyBjcmMzMmNfaW50ZWwgbnZtZSBudm1lX2NvcmUgbmZpdCBsaWJudmRpbW0gd21p
IHBrY3M4X2tleV9wYXJzZXIKWyAgOTAxLjAwOTIxM10gQ1IyOiAwMDAwMDAwMDAwMDAyMDg4Clsg
IDkwMS4wMDk4MTRdIC0tLVsgZW5kIHRyYWNlIDJiYjhiMTJmN2RjNTg5ODEgXS0tLQpbICA5MDEu
MTA5OTA3XSBSSVA6IDAwMTA6X19hbGxvY19wYWdlc19ub2RlbWFzaysweDEzMi8weDM0MApbICA5
MDEuMTEwNTQ2XSBDb2RlOiAxOCAwMSA3NSAwNCA0MSA4MCBjZSA4MCA4OSBlOCA0OCA4YiA1NCAy
NCAwOCA4YiA3NCAyNCAxYyBjMSBlOCAwYyA0OCA4YiAzYyAyNCA4MyBlMCAwMSA4OCA0NCAyNCAy
MCA0OCA4NSBkMiAwZiA4NSA3NCAwMSAwMCAwMCA8M2I+IDc3IDA4IDBmIDgyIDZiIDAxIDAwIDAw
IDQ4IDg5IDdjIDI0IDEwIDg5IGVhIDQ4IDhiIDA3IGI5IDAwIDAyClsgIDkwMS4xMTE3NjFdIFJT
UDogMDAxODpmZmZmYjhiZTRkMGI3YzI4IEVGTEFHUzogMDAwMTAyNDYKWyAgOTAxLjExMjM2OF0g
UkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAwMDAwMDAw
MDAwMGU4ZTgKWyAgOTAxLjExMjk4Ml0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAw
MDAwMDAwMDAwMiBSREk6IDAwMDAwMDAwMDAwMDIwODAKWyAgOTAxLjExMzU5Nl0gUkJQOiAwMDAw
MDAwMDAwMDEyY2MwIFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDIK
WyAgOTAxLjExNDIwNl0gUjEwOiAwMDAwMDAwMDAwMDAwZGMwIFIxMTogZmZmZjk5NWM2MDQwMDEw
MCBSMTI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgOTAxLjExNDgyMV0gUjEzOiAwMDAwMDAwMDAwMDEy
Y2MwIFIxNDogMDAwMDAwMDAwMDAwMDAwMSBSMTU6IGZmZmY5OTVjNjBkYjAwZjAKWyAgOTAxLjEx
NTQxOF0gRlM6ICAwMDAwN2Y0ZDExNWNhOTAwKDAwMDApIEdTOmZmZmY5OTVjNjBkODAwMDAoMDAw
MCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICA5MDEuMTE2MDE5XSBDUzogIDAwMTAgRFM6IDAw
MDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgIDkwMS4xMTY2MTldIENSMjogMDAw
MDAwMDAwMDAwMjA4OCBDUjM6IDAwMDAwMDE3Y2NhNjYwMDIgQ1I0OiAwMDAwMDAwMDAwNzYwNmUw
ClsgIDkwMS4xMTcyMzNdIERSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAw
MDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwClsgIDkwMS4xMTc4MzldIERSMzogMDAwMDAwMDAwMDAw
MDAwMCBEUjY6IDAwMDAwMDAwZmZmZTBmZjAgRFI3OiAwMDAwMDAwMDAwMDAwNDAwClsgIDkwMS4x
MTg0NDRdIFBLUlU6IDU1NTU1NTU0Cgo=
--0000000000009eae62059e42b15c--
