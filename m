Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6C01A245C
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 16:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgDHOvh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 10:51:37 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:45720 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgDHOvg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 10:51:36 -0400
Received: by mail-io1-f47.google.com with SMTP id i19so246020ioh.12
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 07:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=9lOsuvSeby8kvzpQygwGXUOd+vqDt6XltsVMYcXumzE=;
        b=dYPQOqKqpz5VeLNTzoJZZI4ZLprPwfCEhs0UAFzkzQohZKXsbUWuxUD/k0eQYwi97M
         y+Ytc/oOc4nE0P6nL7sO50AROJhJCcYesoFQuUzpGeXGqoNyVHMBVWemcS8m1vYSYBEt
         xsiqL2uQHUdEbtFoMK2sOnscyzRsge/M4dfDELATxUoU7pl5Pt5HsFI7/J/usXdEepjA
         H1gVd9lR88Stg+W+WgihuAYl6P2D57rtrfVt8ZIPeEWuHL4vqyIWeJ+f/m5oIOjJZilJ
         pt4JqG1XCy4AdGDDXl2zzPHEDUd55/Y7bUCZVkMwidkZjQsqp9T0hWcu7WYHBC/QTcY2
         LXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9lOsuvSeby8kvzpQygwGXUOd+vqDt6XltsVMYcXumzE=;
        b=cq2A4LudNw8a+S3Wgc3tPGJ+TtV+zxeC7jNH7h2N8Qy5E9hOnV7weXqZ8MSUKOm27z
         7Z0HvElH96JrssXQTUFGidyU1LadaoMkQdkqJxs5fM59e84kt/94UO/1zIApn3L8EjK7
         Ml1iKsgoBAs5cRpq33KCthGXbBXYKgSrqOHLUKTn4Qg8rWuu7kRt0P0fLIWHV9qmWqCs
         RHg0NVzagwm/HADYhJU9Oj1F1XXinup/roJAOjBfAt1OaRpfYVS1N0umJ0l/A4rE3yDk
         9ULc8ykFzkC8Dy5bJmDpS88uarOmm+meKXqsxhm4XB5zl8N9HGz0HFpA28VaPImhi2mS
         F+/w==
X-Gm-Message-State: AGi0PuZ47BfQdD4+k0jynno+d6q/raGRYMWBrOYU32j0Y+Hfit/H3CVl
        /jhATQfTGSmF65A8PypZPouDUk0KFNM3irAUmGuXdKj/v4A=
X-Google-Smtp-Source: APiQypI5+ZvaB7sBaGKm2RMu+mF+pQj+XSQ0cGCZGfJxn/j3tRK1tgFejX9DdrJmdPl4wX6U0paF8DgqWZjnlOTOXuw=
X-Received: by 2002:a02:2944:: with SMTP id p65mr101858jap.89.1586357495510;
 Wed, 08 Apr 2020 07:51:35 -0700 (PDT)
MIME-Version: 1.0
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 8 Apr 2020 21:51:23 +0700
Message-ID: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
Subject: io_uring's openat doesn't work with large (2G+) files
To:     io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000020c2305a2c8a3a1"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--000000000000020c2305a2c8a3a1
Content-Type: text/plain; charset="UTF-8"

Hi,

io_uring's openat seems to produce FDs that are incompatible with
large files (>2GB). If a file (smaller than 2GB) is opened using
io_uring's openat then writes -- both using io_uring and just sync
pwrite() -- past that threshold fail with EFBIG. If such a file is
opened with sync openat, then both io_uring's writes and sync writes
succeed. And if the file is larger than 2GB then io_uring's openat
fails right away, while the sync one works.

Kernel versions: 5.6.0-rc2, 5.6.0.

A couple of reproducers attached, one demos successful open with
failed writes afterwards, and another failing open (in comparison with
sync  calls).

The output of the former one for example:

*** sync openat
openat succeeded
sync write at offset 0
write succeeded
sync write at offset 4294967296
write succeeded

*** sync openat
openat succeeded
io_uring write at offset 0
write succeeded
io_uring write at offset 4294967296
write succeeded

*** io_uring openat
openat succeeded
sync write at offset 0
write succeeded
sync write at offset 4294967296
write failed: File too large

*** io_uring openat
openat succeeded
io_uring write at offset 0
write succeeded
io_uring write at offset 4294967296
write failed: File too large

-- 
Dmitry

--000000000000020c2305a2c8a3a1
Content-Type: text/x-csrc; charset="US-ASCII"; name="test-io_uring-write-large-offset.c"
Content-Disposition: attachment; 
	filename="test-io_uring-write-large-offset.c"
Content-Transfer-Encoding: base64
Content-ID: <f_k8rg0xau1>
X-Attachment-Id: f_k8rg0xau1

I2luY2x1ZGUgPGxpYnVyaW5nLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN0ZGlv
Lmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8
c3lzL3N0YXQuaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDxlcnJuby5oPgojaW5jbHVk
ZSA8c3lzL3Jlc291cmNlLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCnN0YXRpYyBjb25zdCBpbnQg
UlNJWkUgPSAyOwpzdGF0aWMgY29uc3QgaW50IE9QRU5fRkxBR1MgPSBPX1JEV1IgfCBPX0NSRUFU
OwpzdGF0aWMgY29uc3QgbW9kZV90IE9QRU5fTU9ERSA9IFNfSVJVU1IgfCBTX0lXVVNSOwoKI2Rl
ZmluZSBESUUoLi4uKSBkbyB7XAoJCWZwcmludGYoc3RkZXJyLCBfX1ZBX0FSR1NfXyk7XAoJCWFi
b3J0KCk7XAoJfSB3aGlsZSgwKTsKCnZvaWQgZG9fd3JpdGUoc3RydWN0IGlvX3VyaW5nICpyaW5n
LCBpbnQgc3luYywgaW50IGZkLCBvZmZfdCBvZmZzZXQpCnsKCWZwcmludGYoc3RkZXJyLCAiJXMg
d3JpdGUgYXQgb2Zmc2V0ICVsbGRcbiIsIHN5bmMgPyAic3luYyI6ICJpb191cmluZyIsIG9mZnNl
dCk7CgljaGFyIGJ1ZltdID0gInNvbWUgdGVzdCB3cml0ZSBidWYiOwoJaW50IHJlczsKCWlmIChz
eW5jKSB7CgkJcmVzID0gcHdyaXRlKGZkLCBidWYsIHNpemVvZihidWYpLCBvZmZzZXQpOwoJCWlm
IChyZXMgPCAwKSB7CgkJCXJlcyA9IC1lcnJubzsKCQl9Cgl9CgllbHNlIHsKCQlzdHJ1Y3QgaW9f
dXJpbmdfc3FlICpzcWU7CgkJc3FlID0gaW9fdXJpbmdfZ2V0X3NxZShyaW5nKTsKCQlpZiAoIXNx
ZSkgewoJCQlmcHJpbnRmKHN0ZGVyciwgImZhaWxlZCB0byBnZXQgc3FlXG4iKTsKCQkJcmV0dXJu
OwoJCX0KCQlpb191cmluZ19wcmVwX3dyaXRlKHNxZSwgZmQsIGJ1Ziwgc2l6ZW9mKGJ1ZiksIG9m
ZnNldCk7CgkJaW50IHJldCA9IGlvX3VyaW5nX3N1Ym1pdChyaW5nKTsKCQlpZiAocmV0IDwgMCkg
ewoJCQlmcHJpbnRmKHN0ZGVyciwgImZhaWxlZCB0byBzdWJtaXQgd3JpdGU6ICVzXG4iLCBzdHJl
cnJvcigtcmV0KSk7CgkJCXJldHVybjsKCQl9CgoJCXN0cnVjdCBpb191cmluZ19jcWUgKmNxZTsK
CQlyZXQgPSBpb191cmluZ193YWl0X2NxZShyaW5nLCAmY3FlKTsKCQlyZXMgPSBjcWUtPnJlczsK
CQlpb191cmluZ19jcWVfc2VlbihyaW5nLCBjcWUpOwoJCWlmIChyZXQgPCAwKSB7CgkJCWZwcmlu
dGYoc3RkZXJyLCAid2FpdF9jcWUgZmFpbGVkOiAlc1xuIiwgc3RyZXJyb3IoLXJldCkpOwoJCQly
ZXR1cm47CgkJfQoJfQoJaWYgKHJlcyA8IDApIHsKCQlmcHJpbnRmKHN0ZGVyciwgIndyaXRlIGZh
aWxlZDogJXNcbiIsIHN0cmVycm9yKC1yZXMpKTsKCX0KCWVsc2UgewoJCWZwcmludGYoc3RkZXJy
LCAid3JpdGUgc3VjY2VlZGVkXG4iKTsKCX0KfQoKdm9pZCB0ZXN0X29wZW5fd3JpdGUoc3RydWN0
IGlvX3VyaW5nICpyaW5nLCBpbnQgc3luY19vcGVuLCBpbnQgc3luY193cml0ZSwgaW50IGRmZCwg
Y29uc3QgY2hhciogZm4pCnsKCWZwcmludGYoc3RkZXJyLCAiXG4qKiogJXMgb3BlbmF0XG4iLCBz
eW5jX29wZW4gPyAic3luYyIgOiAiaW9fdXJpbmciKTsKCXN0cnVjdCBpb191cmluZ19zcWUgKnNx
ZTsKCWludCBmZCA9IC0xOwoJaWYgKHN5bmNfb3BlbikgewoJCWZkID0gb3BlbmF0KGRmZCwgZm4s
IE9QRU5fRkxBR1MsIE9QRU5fTU9ERSk7CgkJaWYgKGZkIDwgMCkgewoJCQlmZCA9IC1lcnJubzsK
CQl9Cgl9CgllbHNlIHsKCQlzcWUgPSBpb191cmluZ19nZXRfc3FlKHJpbmcpOwoJCWlmICghc3Fl
KSB7CgkJCWZwcmludGYoc3RkZXJyLCAiZmFpbGVkIHRvIGdldCBzcWVcbiIpOwoJCQlyZXR1cm47
CgkJfQoJCWlvX3VyaW5nX3ByZXBfb3BlbmF0KHNxZSwgZGZkLCBmbiwgT1BFTl9GTEFHUywgT1BF
Tl9NT0RFKTsKCQlpbnQgcmV0ID0gaW9fdXJpbmdfc3VibWl0KHJpbmcpOwoJCWlmIChyZXQgPCAw
KSB7CgkJCWZwcmludGYoc3RkZXJyLCAiZmFpbGVkIHRvIHN1Ym1pdCBvcGVuYXQ6ICVzXG4iLCBz
dHJlcnJvcigtcmV0KSk7CgkJCXJldHVybjsKCQl9CgoJCXN0cnVjdCBpb191cmluZ19jcWUgKmNx
ZTsKCQlyZXQgPSBpb191cmluZ193YWl0X2NxZShyaW5nLCAmY3FlKTsKCQlmZCA9IGNxZS0+cmVz
OwoJCWlvX3VyaW5nX2NxZV9zZWVuKHJpbmcsIGNxZSk7CgkJaWYgKHJldCA8IDApIHsKCQkJZnBy
aW50ZihzdGRlcnIsICJ3YWl0X2NxZSBmYWlsZWQ6ICVzXG4iLCBzdHJlcnJvcigtcmV0KSk7CgkJ
CXJldHVybjsKCQl9Cgl9CglpZiAoZmQgPCAwKSB7CgkJZnByaW50ZihzdGRlcnIsICJvcGVuYXQg
ZmFpbGVkOiAlc1xuIiwgc3RyZXJyb3IoLWZkKSk7Cgl9CgllbHNlIHsKCQlmcHJpbnRmKHN0ZGVy
ciwgIm9wZW5hdCBzdWNjZWVkZWRcbiIpOwoJCWRvX3dyaXRlKHJpbmcsIHN5bmNfd3JpdGUsIGZk
LCAwKTsKCQlkb193cml0ZShyaW5nLCBzeW5jX3dyaXRlLCBmZCwgMXVsbCA8PCAzMik7CgkJY2xv
c2UoZmQpOwoJfQp9CgppbnQgbWFpbigpCnsKCWludCBkZmQgPSBvcGVuKCIvdG1wIiwgT19SRE9O
TFkgfCBPX0RJUkVDVE9SWSk7CglpZiAoZGZkIDwgMCkgewoJCURJRSgib3BlbiAvdG1wOiAlc1xu
Iiwgc3RyZXJyb3IoZXJybm8pKTsKCX0KCXN0cnVjdCBpb191cmluZyByaW5nOwoJaW50IHJldCA9
IGlvX3VyaW5nX3F1ZXVlX2luaXQoUlNJWkUsICZyaW5nLCAwKTsKCWlmIChyZXQgPCAwKSB7CgkJ
RElFKCJmYWlsZWQgdG8gaW5pdCBpb191cmluZzogJXNcbiIsIHN0cmVycm9yKC1yZXQpKTsKCX0K
Cgl0ZXN0X29wZW5fd3JpdGUoJnJpbmcsIDEsIDEsIGRmZCwgImlvX3VyaW5nX29wZW5hdF93cml0
ZV90ZXN0MSIpOwoJdGVzdF9vcGVuX3dyaXRlKCZyaW5nLCAxLCAwLCBkZmQsICJpb191cmluZ19v
cGVuYXRfd3JpdGVfdGVzdDIiKTsKCXRlc3Rfb3Blbl93cml0ZSgmcmluZywgMCwgMSwgZGZkLCAi
aW9fdXJpbmdfb3BlbmF0X3dyaXRlX3Rlc3QzIik7Cgl0ZXN0X29wZW5fd3JpdGUoJnJpbmcsIDAs
IDAsIGRmZCwgImlvX3VyaW5nX29wZW5hdF93cml0ZV90ZXN0NCIpOwoKCWlvX3VyaW5nX3F1ZXVl
X2V4aXQoJnJpbmcpOwoJY2xvc2UoZGZkKTsKCXJldHVybiAwOwp9Cg==
--000000000000020c2305a2c8a3a1
Content-Type: text/x-csrc; charset="US-ASCII"; name="test-io_uring-openat-large-file.c"
Content-Disposition: attachment; 
	filename="test-io_uring-openat-large-file.c"
Content-Transfer-Encoding: base64
Content-ID: <f_k8rg0xa10>
X-Attachment-Id: f_k8rg0xa10

I2luY2x1ZGUgPGxpYnVyaW5nLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN0ZGlv
Lmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8
c3lzL3N0YXQuaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDxlcnJuby5oPgojaW5jbHVk
ZSA8c3lzL3Jlc291cmNlLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCiNkZWZpbmUgRElFKC4uLikg
ZG8ge1wKCQlmcHJpbnRmKHN0ZGVyciwgX19WQV9BUkdTX18pO1wKCQlhYm9ydCgpO1wKCX0gd2hp
bGUoMCk7CgpzdGF0aWMgY29uc3QgaW50IFJTSVpFID0gMjsKc3RhdGljIGNvbnN0IGludCBPUEVO
X0ZMQUdTID0gT19SRFdSIHwgT19DUkVBVDsKc3RhdGljIGNvbnN0IG1vZGVfdCBPUEVOX01PREUg
PSBTX0lSVVNSIHwgU19JV1VTUjsKCnZvaWQgb3Blbl9zeW5jKGludCBkZmQsIGNvbnN0IGNoYXIq
IGZuKQp7CglpbnQgZmQgPSBvcGVuYXQoZGZkLCBmbiwgT1BFTl9GTEFHUywgT1BFTl9NT0RFKTsK
CWlmIChmZCA8IDApIHsKCQlmcHJpbnRmKHN0ZGVyciwgInN5bmMgb3BlbiBmYWlsZWQ6ICVzXG4i
LCBzdHJlcnJvcihlcnJubykpOwoJfQoJZWxzZSB7CgkJZnByaW50ZihzdGRlcnIsICJzeW5jIG9w
ZW4gc3VjY2VlZGVkXG4iKTsKCQljbG9zZShmZCk7Cgl9Cn0KCnZvaWQgb3Blbl9pb191cmluZyhz
dHJ1Y3QgaW9fdXJpbmcgKnJpbmcsIGludCBkZmQsIGNvbnN0IGNoYXIqIGZuKQp7CglzdHJ1Y3Qg
aW9fdXJpbmdfc3FlICpzcWU7CglzcWUgPSBpb191cmluZ19nZXRfc3FlKHJpbmcpOwoJaWYgKCFz
cWUpIHsKCQlmcHJpbnRmKHN0ZGVyciwgImZhaWxlZCB0byBnZXQgc3FlXG4iKTsKCQlyZXR1cm47
Cgl9Cglpb191cmluZ19wcmVwX29wZW5hdChzcWUsIGRmZCwgZm4sIE9QRU5fRkxBR1MsIE9QRU5f
TU9ERSk7CglpbnQgcmV0ID0gaW9fdXJpbmdfc3VibWl0KHJpbmcpOwoJaWYgKHJldCA8IDApIHsK
CQlmcHJpbnRmKHN0ZGVyciwgImZhaWxlZCB0byBzdWJtaXQgb3BlbmF0OiAlc1xuIiwgc3RyZXJy
b3IoLXJldCkpOwoJCXJldHVybjsKCX0KCglzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7CglyZXQg
PSBpb191cmluZ193YWl0X2NxZShyaW5nLCAmY3FlKTsKCWludCBmZCA9IGNxZS0+cmVzOwoJaW9f
dXJpbmdfY3FlX3NlZW4ocmluZywgY3FlKTsKCWlmIChyZXQgPCAwKSB7CgkJZnByaW50ZihzdGRl
cnIsICJ3YWl0X2NxZSBmYWlsZWQ6ICVzXG4iLCBzdHJlcnJvcigtcmV0KSk7Cgl9CgllbHNlIGlm
IChmZCA8IDApIHsKCQlmcHJpbnRmKHN0ZGVyciwgImlvX3VyaW5nIG9wZW5hdCBmYWlsZWQ6ICVz
XG4iLCBzdHJlcnJvcigtZmQpKTsKCX0KCWVsc2UgewoJCWZwcmludGYoc3RkZXJyLCAiaW9fdXJp
bmcgb3BlbmF0IHN1Y2NlZWRlZFxuIik7CgkJY2xvc2UoZmQpOwoJfQp9CgppbnQgcHJlcGFyZV9m
aWxlKGludCBkZmQsIGNvbnN0IGNoYXIqIGZuKQp7Cgljb25zdCBjaGFyIGJ1ZltdID0gImZvbyI7
CglpbnQgZmQgPSBvcGVuYXQoZGZkLCBmbiwgT1BFTl9GTEFHUywgT1BFTl9NT0RFKTsKCWlmIChm
ZCA8IDApIHsKCQlmcHJpbnRmKHN0ZGVyciwgInByZXBhcmUvb3BlbjogJXNcbiIsIHN0cmVycm9y
KGVycm5vKSk7CgkJcmV0dXJuIC0xOwoJfQoJaW50IHJlcyA9IHB3cml0ZShmZCwgYnVmLCBzaXpl
b2YoYnVmKSwgMXVsbCA8PCAzMik7CglpZiAocmVzIDwgMCkgewoJCWZwcmludGYoc3RkZXJyLCAi
cHJlcGFyZS9wd3JpdGU6ICVzXG4iLCBzdHJlcnJvcihlcnJubykpOwoJfQoJY2xvc2UoZmQpOwoJ
cmV0dXJuIHJlcyA8IDAgPyByZXMgOiAwOwp9CgppbnQgbWFpbigpCnsKCWNvbnN0IGNoYXIgKmZu
ID0gImlvX3VyaW5nX29wZW5hdF90ZXN0IjsKCWludCBkZmQgPSBvcGVuKCIvdG1wIiwgT19SRE9O
TFkgfCBPX0RJUkVDVE9SWSk7CglpZiAoZGZkIDwgMCkgewoJCURJRSgib3BlbiAvdG1wOiAlc1xu
Iiwgc3RyZXJyb3IoZXJybm8pKTsKCX0KCXN0cnVjdCBpb191cmluZyByaW5nOwoJaW50IHJldCA9
IGlvX3VyaW5nX3F1ZXVlX2luaXQoUlNJWkUsICZyaW5nLCAwKTsKCWlmIChyZXQgPCAwKSB7CgkJ
RElFKCJmYWlsZWQgdG8gaW5pdCBpb191cmluZzogJXNcbiIsIHN0cmVycm9yKC1yZXQpKTsKCX0K
CglpZiAoIXByZXBhcmVfZmlsZShkZmQsIGZuKSkgewoJCW9wZW5fc3luYyhkZmQsIGZuKTsKCQlv
cGVuX2lvX3VyaW5nKCZyaW5nLCBkZmQsIGZuKTsKCX0KCglpb191cmluZ19xdWV1ZV9leGl0KCZy
aW5nKTsKCWNsb3NlKGRmZCk7CglyZXR1cm4gMDsKfQo=
--000000000000020c2305a2c8a3a1--
