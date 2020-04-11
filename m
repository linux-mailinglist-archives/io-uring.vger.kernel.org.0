Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 748151A53FE
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 01:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgDKXAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Apr 2020 19:00:30 -0400
Received: from mail-il1-f169.google.com ([209.85.166.169]:35508 "EHLO
        mail-il1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgDKXAa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Apr 2020 19:00:30 -0400
Received: by mail-il1-f169.google.com with SMTP id t10so5435040iln.2
        for <io-uring@vger.kernel.org>; Sat, 11 Apr 2020 16:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IST4gKpAA2mBd2083Fah0iwY0lS4FWAufZb2lCaE8H4=;
        b=cz2y1XdvcSRBK6SrPSKLzFLJhNVneVFcK3YZkNtq/qmIjQ5CQMa5QpOj+uizIWvEcE
         a/PpSarHlIdYblGo36d1sVwT2XV2L//oFYEMnxG1rbMkDHTQNL4R4pYRpfUQSoIb7GGe
         ynKQXqFSQ1Lgpalw+sv/s+tOY5SsgRwwVfov2q1LNxJTChfaBLTl3hMBIteEQwTXgJvd
         E/7RabbRw6hTQ1vMGd4m9OF8eVsDKLj53Q+ze7Qy5iB9VuOkCQ2C+4epeHltD8CsU+Ve
         OpcDmSQi4txOikERKSNnMU267mTpSy1UYXSCscdAhPD+6SOjevuL5eWKY0FzdeVtlMWc
         e4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IST4gKpAA2mBd2083Fah0iwY0lS4FWAufZb2lCaE8H4=;
        b=ag+PYMY0tX4rcg/blaJ0yO0yc4JFHKTThKH5kXqbfm3Tb206JQTfK49eyfk959c7mx
         +NWkB562d+24S/EKtSHoQ6b96ZLR13yF9MfuWWwROdF3d4L2OR3nLLYYABQDd9AceXRv
         YgH+If9tgjofIkb2gf6QlLMuGmRlkaVNcCV3NxCGJLxmE87AraBEoNdrpTujn+g+0L/S
         +D1+hoQCzWvSp0kIGob3lfUhczgoCQNjUBUXjGERqLDPilPwuaAVbaZew8U//bdfOQbW
         o7Rdm4a5Fna+kXevTHikXfxWDE0dGSQ6COPLA3f2vG4lfZsNIzPe9c+ljY3aXEIDAz0z
         ru5Q==
X-Gm-Message-State: AGi0PubjUN87qFUYqntF5x3nGPS8aIu7GN1K1X//AuU1Ot5tjgr1ykWZ
        y63XoBhGkDw1Ie1YUZqdRMmxCgaEkJU81jkRcdhGCh1DFVA=
X-Google-Smtp-Source: APiQypL4Qng9OaGG16feAvA8jp5dTWpMxP0YAPJlA6Pn/qxWt6khl9w8oJOwm6cHkkFFzDXK+3d/d322hufv08xFVnY=
X-Received: by 2002:a92:5ddc:: with SMTP id e89mr10272070ilg.15.1586646028433;
 Sat, 11 Apr 2020 16:00:28 -0700 (PDT)
MIME-Version: 1.0
From:   Hrvoje Zeba <zeba.hrvoje@gmail.com>
Date:   Sat, 11 Apr 2020 19:00:17 -0400
Message-ID: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
Subject: Odd timeout behavior
To:     io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000e8dfd305a30bd088"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--000000000000e8dfd305a30bd088
Content-Type: text/plain; charset="UTF-8"

Hi,

I've been looking at timeouts and found a case I can't wrap my head around.

Basically, If you submit OPs in a certain order, timeout fires before
time elapses where I wouldn't expect it to. The order is as follows:

poll(listen_socket, POLLIN) <- this never fires
nop(async)
timeout(1s, count=X)

If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
not fire (at least not immediately). This is expected apart from maybe
setting X=1 which would potentially allow the timeout to fire if nop
executes after the timeout is setup.

If you set it to 0xffffffff, it will always fire (at least on my
machine). Test program I'm using is attached.

The funny thing is that, if you remove the poll, timeout will not fire.

I'm using Linus' tree (v5.6-12604-gab6f762f0f53).

Could anybody shine a bit of light here?


Thank you,
Hrvoje

-- 
I doubt, therefore I might be.

--000000000000e8dfd305a30bd088
Content-Type: text/x-csrc; charset="US-ASCII"; name="nop-timeout.c"
Content-Disposition: attachment; filename="nop-timeout.c"
Content-Transfer-Encoding: base64
Content-ID: <f_k8w81k8r0>
X-Attachment-Id: f_k8w81k8r0

I2luY2x1ZGUgPGFzc2VydC5oPgojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPHN0ZGlvLmg+
CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5n
Lmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8dGltZS5oPgojaW5jbHVkZSA8cG9sbC5o
PgojaW5jbHVkZSA8c3lzL3RpbWUuaD4KI2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4KI2luY2x1ZGUg
PGFycGEvaW5ldC5oPgoKI2luY2x1ZGUgImxpYnVyaW5nLmgiCgpzdHJ1Y3QgaW9fdXJpbmdfc3Fl
KiBnZXRfc3FlKHN0cnVjdCBpb191cmluZyogcmluZykKewoJc3RydWN0IGlvX3VyaW5nX3NxZSog
c3FlID0gaW9fdXJpbmdfZ2V0X3NxZShyaW5nKTsKCWFzc2VydChzcWUgIT0gTlVMTCk7CglyZXR1
cm4gc3FlOwp9Cgp2b2lkIGVucXVldWVfbm9wKHN0cnVjdCBpb191cmluZyogcmluZykKewoJc3Ry
dWN0IGlvX3VyaW5nX3NxZSogc3FlID0gZ2V0X3NxZShyaW5nKTsKCglpb191cmluZ19wcmVwX25v
cChzcWUpOwoJaW9fdXJpbmdfc3FlX3NldF9kYXRhKHNxZSwgKHZvaWQqKTEpOwoJaW9fdXJpbmdf
c3FlX3NldF9mbGFncyhzcWUsIElPU1FFX0FTWU5DKTsKfQoKdm9pZCBlbnF1ZXVlX3RpbWVvdXQo
c3RydWN0IGlvX3VyaW5nKiByaW5nKQp7CglzdHJ1Y3QgaW9fdXJpbmdfc3FlKiBzcWUgPSBnZXRf
c3FlKHJpbmcpOwoJc3RhdGljIHN0cnVjdCBfX2tlcm5lbF90aW1lc3BlYyB0czsKCgl0cy50dl9z
ZWMgPSAxOwoJdHMudHZfbnNlYyA9IDA7CgoJaW9fdXJpbmdfcHJlcF90aW1lb3V0KHNxZSwgJnRz
LCAodW5zaWduZWQpLTEsIDApOwoJaW9fdXJpbmdfc3FlX3NldF9kYXRhKHNxZSwgKHZvaWQqKTIp
Owp9Cgp2b2lkIGVucXVldWVfcG9sbChzdHJ1Y3QgaW9fdXJpbmcqIHJpbmcsIGludCBmZCkKewoJ
c3RydWN0IGlvX3VyaW5nX3NxZSogc3FlID0gZ2V0X3NxZShyaW5nKTsKCglpb191cmluZ19wcmVw
X3BvbGxfYWRkKHNxZSwgZmQsIFBPTExJTiB8IFBPTExFUlIgfCBQT0xMSFVQKTsKCWlvX3VyaW5n
X3NxZV9zZXRfZGF0YShzcWUsICh2b2lkKikzKTsKfQoKaW50IGNyZWF0ZV9zb2NrZXQoKQp7Cglp
bnQgcyA9IHNvY2tldChBRl9JTkVULCBTT0NLX1NUUkVBTSB8IFNPQ0tfQ0xPRVhFQywgSVBQUk9U
T19UQ1ApOwoJYXNzZXJ0KHMgIT0gLTEpOwoKCWludCBmbGFncyA9IGZjbnRsKHMsIEZfR0VURkws
IDApOwoJYXNzZXJ0KGZsYWdzICE9IC0xKTsKCglmbGFncyB8PSBPX05PTkJMT0NLOwoKCWFzc2Vy
dChmY250bChzLCBGX1NFVEZMLCBmbGFncykgIT0gLTEpOwoKCXN0cnVjdCBzb2NrYWRkcl9pbiBh
ZGRyOwoKCWFkZHIuc2luX2ZhbWlseSA9IEFGX0lORVQ7CglhZGRyLnNpbl9wb3J0ID0gMHgxMjM2
OwoJYWRkci5zaW5fYWRkci5zX2FkZHIgPSAweDAxMDAwMDdmVTsKCglhc3NlcnQoYmluZChzLCAo
c3RydWN0IHNvY2thZGRyKikmYWRkciwgc2l6ZW9mKGFkZHIpKSAhPSAtMSk7Cglhc3NlcnQobGlz
dGVuKHMsIDEwMjQpICE9IC0xKTsKCglyZXR1cm4gczsKfQoKaW50IG1haW4oaW50IGFyZ2MsIGNo
YXIgKmFyZ3ZbXSkKewoJc3RydWN0IGlvX3VyaW5nIHJpbmc7CglpbnQgcmV0OwoKCXJldCA9IGlv
X3VyaW5nX3F1ZXVlX2luaXQoNCwgJnJpbmcsIDApOwoJaWYgKHJldCkgewoJCWZwcmludGYoc3Rk
ZXJyLCAicmluZyBzZXR1cCBmYWlsZWRcbiIpOwoJCXJldHVybiAxOwoJfQoKCWludCBzID0gY3Jl
YXRlX3NvY2tldCgpOwoJZW5xdWV1ZV9wb2xsKCZyaW5nLCBzKTsKCgllbnF1ZXVlX25vcCgmcmlu
Zyk7CgllbnF1ZXVlX3RpbWVvdXQoJnJpbmcpOwoKCXJldCA9IGlvX3VyaW5nX3N1Ym1pdF9hbmRf
d2FpdCgmcmluZywgMSk7CglpZiAocmV0ID09IC0xKSB7CgkJZnByaW50ZihzdGRlcnIsICJzdWJt
aXQgZmFpbGVkXG4iKTsKCQlyZXR1cm4gMTsKCX0KCglzdHJ1Y3QgaW9fdXJpbmdfY3FlKiBjcWU7
Cgl1aW50MzJfdCBoZWFkOwoJdWludDMyX3QgY291bnQgPSAwOwoKCWlvX3VyaW5nX2Zvcl9lYWNo
X2NxZSgmcmluZywgaGVhZCwgY3FlKSB7CgkJaWYgKGlvX3VyaW5nX2NxZV9nZXRfZGF0YShjcWUp
ID09ICh2b2lkKikyKQoJCQlmcHJpbnRmKHN0ZGVyciwgIlRpbWVvdXQgdHJpZ2dlcmVkIVxuIik7
CgoJCWNvdW50Kys7Cgl9CgoJaW9fdXJpbmdfY3FfYWR2YW5jZSgmcmluZywgY291bnQpOwoKCWlv
X3VyaW5nX3F1ZXVlX2V4aXQoJnJpbmcpOwoJcmV0dXJuIDA7Cn0K
--000000000000e8dfd305a30bd088--
