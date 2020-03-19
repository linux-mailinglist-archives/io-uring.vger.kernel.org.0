Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FA118B313
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2020 13:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgCSMNF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Mar 2020 08:13:05 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:41332 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgCSMNF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Mar 2020 08:13:05 -0400
Received: by mail-il1-f195.google.com with SMTP id l14so1964033ilj.8
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2020 05:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4Mnbl72bZj+kDoztsIxFNBQa1V+VuMgglOqPxlc9X2w=;
        b=MTvPyn0XZc3gUnXW8D2iLuwd+PUw9DBJe6l5mZL3axnh5+31BkJc2jzeT5hv1DNb5C
         GBrlOWrlWmHZMvreqlx4qUFO78qlTZvti63SMnGJsofDriURdMBx/Knn/Cf0xhHfmrPh
         H1ZqwO+baNrmA3zzsXKFqDampZUHsXgEY90yrlFPMhgHknrAyZTEw3LPkQcwBwZe0Uga
         yAAMnKtswCi2F2/khGz7kwM7de8evCTCkrIArIG1ICbXMW5GaDxgCVy4hHXvxzyFWZ2y
         i1qeIdzC9e1DuCNYqJ6MNecwlLS08couEJB4W8ZXqNNkMUtCPLpqiupp4/1/SAJsgMs5
         ++5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4Mnbl72bZj+kDoztsIxFNBQa1V+VuMgglOqPxlc9X2w=;
        b=L/5msd5E0gzVgZ5/pZjztI0btZIt7P4ZY84AQtr2bGpPawxuS8xBNnGR4m5R6EkD+D
         2cVIh0E7MtJg665BB0RlKv8YVb0Ck+2xyMFBb+C8gG52BM8odROmady5BX7GuhxFzlSv
         3q29h9+VLgCRmaco6zFaXKLwRDNa1wn2GXyyJNZck/xgFf4n7LcHU7hXLtWYNyBxp28Y
         6liWOR5zBnHVArn2Qqt0EuGY8H56QBAMXmeGeULyUDLmO+PpQQhkUy4nLWlOhOvzIGcR
         Ql+gsEpu14TdyGgfZTzA7eDhvNaxoMFtNCEI5TuQXBkbh2RS9VPJImdkRlc52afc1DHW
         BwmA==
X-Gm-Message-State: ANhLgQ1a5r07n4Qfmhk32wq13x1ZUMQADFi4HUugh+t4974C/r3sli7j
        f0lGN6ZelO9y25ZEd+KbBWlDakT9FQJGRBmbmMUsoiYeaUY=
X-Google-Smtp-Source: ADFU+vtI0SWAbsUJSDJQ2Cqlq0HLOrP5k2NmlSatpWcGhemy4my6tkNtuYn4R4jOQw2/DZMUbzuQdQwB/Denac6Ojag=
X-Received: by 2002:a92:da03:: with SMTP id z3mr2674007ilm.191.1584619983880;
 Thu, 19 Mar 2020 05:13:03 -0700 (PDT)
MIME-Version: 1.0
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 19 Mar 2020 19:12:52 +0700
Message-ID: <CAOKbgA7cgN=+zNVH9Jv1UHXC1qoWAgnPqZPPJuNaLUzzXOwwSg@mail.gmail.com>
Subject: openat ignores changes to RLIMIT_NOFILE?
To:     io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000003e921d05a1341797"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--0000000000003e921d05a1341797
Content-Type: text/plain; charset="UTF-8"

Hi,

It seems that openat calls issued via io_uring ignore changes to
RLIMIT_NOFILE. Maybe a wrong limit is checked. A short reproducer is
attached, it sets RLIMIT_NOFILE to a very low value and the sync
openat() call fails with "Too many open files", but io_uring one
succeeds. The resulting FD is completely usable, I've tried writing to
it successfully.

To be clear, originally I've encountered another side of this problem:
we increase the limit in our code, and io_uring's openat started to
fail after a while under load, while the sync calls executed on a
thread pool were working as expected. It's just easier to demo with
small limit.

Kernel 5.6-rc2, 5.6-rc6.

Hope it's the right place to report an issue like this.

Thanks.

-- 
Dmitry

--0000000000003e921d05a1341797
Content-Type: text/x-csrc; charset="US-ASCII"; name="test-io_uring-openat-rlimit.c"
Content-Disposition: attachment; filename="test-io_uring-openat-rlimit.c"
Content-Transfer-Encoding: base64
Content-ID: <f_k7ypo3ne0>
X-Attachment-Id: f_k7ypo3ne0

I2luY2x1ZGUgPGxpYnVyaW5nLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN0ZGlv
Lmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8
c3lzL3N0YXQuaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDxlcnJuby5oPgojaW5jbHVk
ZSA8c3lzL3Jlc291cmNlLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCiNkZWZpbmUgRElFKC4uLikg
ZG8ge1wKCQlmcHJpbnRmKHN0ZGVyciwgX19WQV9BUkdTX18pO1wKCQlhYm9ydCgpO1wKCX0gd2hp
bGUoMCk7CgpzdGF0aWMgY29uc3QgaW50IFJTSVpFID0gMjsKc3RhdGljIGNvbnN0IGludCBPUEVO
X0ZMQUdTID0gT19SRFdSIHwgT19DUkVBVDsKc3RhdGljIGNvbnN0IG1vZGVfdCBPUEVOX01PREUg
PSBTX0lSVVNSIHwgU19JV1VTUjsKCnZvaWQgc2V0dXBfcmxpbWl0KCkKewoJc3RydWN0IHJsaW1p
dCBybGltOwoJcmxpbS5ybGltX2N1ciA9IHJsaW0ucmxpbV9tYXggPSA1OyAvLyAzIHN0ZGlvIG9u
ZXMsIDEgZm9yIHVyaW5nLCAxIGZvciBkaXJmZAoJaWYgKHNldHJsaW1pdChSTElNSVRfTk9GSUxF
LCAmcmxpbSkgPT0gLTEpIHsKCQlESUUoInNldHJsaW1pdCBub2ZpbGU6ICVzXG4iLCBzdHJlcnJv
cihlcnJubykpOwoJfQp9Cgp2b2lkIG9wZW5fc3luYyhpbnQgZGZkLCBjb25zdCBjaGFyKiBmbikK
ewoJaW50IGZkID0gb3BlbmF0KGRmZCwgZm4sIE9QRU5fRkxBR1MsIE9QRU5fTU9ERSk7CglpZiAo
ZmQgPCAwKSB7CgkJZnByaW50ZihzdGRlcnIsICJzeW5jIG9wZW4gZmFpbGVkOiAlc1xuIiwgc3Ry
ZXJyb3IoZXJybm8pKTsKCX0KCWVsc2UgewoJCWZwcmludGYoc3RkZXJyLCAic3luYyBvcGVuIHN1
Y2NlZWRlZFxuIik7CgkJY2xvc2UoZmQpOwoJfQp9Cgp2b2lkIG9wZW5faW9fdXJpbmcoc3RydWN0
IGlvX3VyaW5nICpyaW5nLCBpbnQgZGZkLCBjb25zdCBjaGFyKiBmbikKewoJc3RydWN0IGlvX3Vy
aW5nX3NxZSAqc3FlOwoJc3FlID0gaW9fdXJpbmdfZ2V0X3NxZShyaW5nKTsKCWlmICghc3FlKSB7
CgkJZnByaW50ZihzdGRlcnIsICJmYWlsZWQgdG8gZ2V0IHNxZVxuIik7CgkJcmV0dXJuOwoJfQoJ
aW9fdXJpbmdfcHJlcF9vcGVuYXQoc3FlLCBkZmQsIGZuLCBPUEVOX0ZMQUdTLCBPUEVOX01PREUp
OwoJaW50IHJldCA9IGlvX3VyaW5nX3N1Ym1pdChyaW5nKTsKCWlmIChyZXQgPCAwKSB7CgkJZnBy
aW50ZihzdGRlcnIsICJmYWlsZWQgdG8gc3VibWl0IG9wZW5hdDogJXNcbiIsIHN0cmVycm9yKC1y
ZXQpKTsKCQlyZXR1cm47Cgl9CgoJc3RydWN0IGlvX3VyaW5nX2NxZSAqY3FlOwoJcmV0ID0gaW9f
dXJpbmdfd2FpdF9jcWUocmluZywgJmNxZSk7CglpbnQgZmQgPSBjcWUtPnJlczsKCWlvX3VyaW5n
X2NxZV9zZWVuKHJpbmcsIGNxZSk7CglpZiAocmV0IDwgMCkgewoJCWZwcmludGYoc3RkZXJyLCAi
d2FpdF9jcWUgZmFpbGVkOiAlc1xuIiwgc3RyZXJyb3IoLXJldCkpOwoJfQoJZWxzZSBpZiAoZmQg
PCAwKSB7CgkJZnByaW50ZihzdGRlcnIsICJpb191cmluZyBvcGVuYXQgZmFpbGVkOiAlc1xuIiwg
c3RyZXJyb3IoLWZkKSk7Cgl9CgllbHNlIHsKCQlmcHJpbnRmKHN0ZGVyciwgImlvX3VyaW5nIG9w
ZW5hdCBzdWNjZWVkZWRcbiIpOwoJCWNsb3NlKGZkKTsKCX0KfQoKaW50IG1haW4oaW50IGFyZ2Ms
IGNvbnN0IGNoYXIgKmFyZ3ZbXSkKewoJY29uc3QgY2hhciAqbW9kZSA9ICJpb191cmluZyI7Cglj
b25zdCBjaGFyICpmbiA9ICJpb191cmluZ19vcGVuYXRfdGVzdCI7CglzZXR1cF9ybGltaXQoKTsK
CWludCBkZmQgPSBvcGVuKCIvdG1wIiwgT19SRE9OTFkgfCBPX0RJUkVDVE9SWSk7CglpZiAoZGZk
IDwgMCkgewoJCURJRSgib3BlbiAvdG1wOiAlc1xuIiwgc3RyZXJyb3IoZXJybm8pKTsKCX0KCXN0
cnVjdCBpb191cmluZyByaW5nOwoJaW50IHJldCA9IGlvX3VyaW5nX3F1ZXVlX2luaXQoUlNJWkUs
ICZyaW5nLCAwKTsKCWlmIChyZXQgPCAwKSB7CgkJRElFKCJmYWlsZWQgdG8gaW5pdCBpb191cmlu
ZzogJXNcbiIsIHN0cmVycm9yKC1yZXQpKTsKCX0KCglvcGVuX3N5bmMoZGZkLCBmbik7CglvcGVu
X2lvX3VyaW5nKCZyaW5nLCBkZmQsIGZuKTsKCglpb191cmluZ19xdWV1ZV9leGl0KCZyaW5nKTsK
CWNsb3NlKGRmZCk7CglyZXR1cm4gMDsKfQo=
--0000000000003e921d05a1341797--
