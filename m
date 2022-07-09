Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2DC56CA01
	for <lists+io-uring@lfdr.de>; Sat,  9 Jul 2022 16:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiGIOWB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jul 2022 10:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiGIOWA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jul 2022 10:22:00 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDB6BF68
        for <io-uring@vger.kernel.org>; Sat,  9 Jul 2022 07:21:59 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y141so1311335pfb.7
        for <io-uring@vger.kernel.org>; Sat, 09 Jul 2022 07:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=weVutNk5E0jpQpvwAzwnyT7Z8VTkphOgHjaf6wJekRM=;
        b=mOpgN8tete0DMhDmOPAY7j4E/FV4q+gJSmZVEvPiTG+6qMxaabJLQn/wMpVL5ye0ll
         xm3diND1quTW+gyjmASpgejvgXPSx8BN1qgIZmkDwYwisNPo3NcWFgc2YJH3MU7HDVkD
         BeDMRAq4d6WkjAvzscg5xu6oT6/SD9l1CdbI0+9XeCywkVcM2ybJcMCxhzt32USn9LIr
         ZH/SUDVMUSzwhIHgqKJVBIr1+z3JYo6Zsm/AaH5gRXENSN5n+96tHAVEuyYGKS20NdTy
         TCnS/rLHqKvYDaW4mPn4rUv8bXWVHA16xkJUkbn+s6jYep4rK6YtZ/gUCUaXdEDxTcGa
         4vDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=weVutNk5E0jpQpvwAzwnyT7Z8VTkphOgHjaf6wJekRM=;
        b=KmCYwRQOPBF0tL/ZS1iuwCPYUC4McA4D5P3VDF/3iX+aiY5F3rIENqxp/9urUyZilM
         3/GBPR2xdgFErCMX26FrwRNER7M1E1Gqbr0EBqQE7SP1NxXJIW4radI4bbojCAnggJJR
         aI3OU2iFaYtNXDzKjBRqkaiRJ0EtQQuaO281Yj/tK1+I+75RlzwN6paPyvmE5fdhApLW
         w1NmFIUWBSHf+5h15a8Fxz8NzkY2/YCXi+VmlR5zCtfWT9NbVCP9t3iJMP2dnBtLNmwF
         OJ+plx7fGztuMRuJLyClDSdX0sv2E59A424P7tbZQz/InFQohbIYyBjccMrn/st5nT2C
         4ayw==
X-Gm-Message-State: AJIora+3sYBQpJAHkFQPJjDEYg99LmOrraPbEQphD9V8FfHzBOJ5bVnO
        AuPXzFibKeEZy+nmo9VBkCuQM7+hBqZr1xGctZEyzJKA
X-Google-Smtp-Source: AGRyM1vNW8iyA1wXg56fjHtExZwd/bLWIaOBwPcacTAExPcQk8lD4Y4MEk5LD8adFs1kRGa8NUZvheSxONxLCtzGD44=
X-Received: by 2002:a63:b341:0:b0:40d:677:881a with SMTP id
 x1-20020a63b341000000b0040d0677881amr7836429pgt.407.1657376519218; Sat, 09
 Jul 2022 07:21:59 -0700 (PDT)
MIME-Version: 1.0
From:   Hrvoje Zeba <zeba.hrvoje@gmail.com>
Date:   Sat, 9 Jul 2022 10:21:48 -0400
Message-ID: <CAEsUgYg5zx5Zk_wp9=YXf5Y+qPh9vx7adDN=B_rpa3zoh2YSew@mail.gmail.com>
Subject: recvmsg not honoring O_NONBLOCK
To:     io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000b0108805e3600a31"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--000000000000b0108805e3600a31
Content-Type: text/plain; charset="UTF-8"

Hi folks,

I was adapting msquic library to work with iouring and found an issue
with recvmsg() where it ignores O_NONBLOCK flag set on the file
descriptor. If MSG_DONTWAIT is set in flags, it behaves as expected.
I've attached a simple test which currently just hangs on iouring's
recvmsg(). I'm guessing sendmsg() behaves the same way but I have no
idea how to fill the buffer to reliably test it.

Best,
Hrvoje

-- 
I doubt, therefore I might be.

--000000000000b0108805e3600a31
Content-Type: text/x-csrc; charset="US-ASCII"; name="recvmsg_test.c"
Content-Disposition: attachment; filename="recvmsg_test.c"
Content-Transfer-Encoding: base64
Content-ID: <f_l5dz3a5y0>
X-Attachment-Id: f_l5dz3a5y0

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxhc3NlcnQuaD4KI2luY2x1ZGUgPGxpYnVyaW5n
Lmg+CiNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+CiNpbmNsdWRlIDxuZXRpbmV0L2luLmg+CiNpbmNs
dWRlIDxuZXRpbmV0L3VkcC5oPgoKdm9pZCByZWN2bXNnX3N5c2NhbGwoaW50IHMpCnsKICAgIHN0
cnVjdCBzb2NrYWRkcl9pbiBhZGRyOwoKICAgIGNoYXIgYnVmZlsxMDI0XTsKICAgIHN0cnVjdCBp
b3ZlYyBpb3YgPSB7CiAgICAgICAgLmlvdl9iYXNlID0gYnVmZiwKICAgICAgICAuaW92X2xlbiA9
IHNpemVvZihidWZmKQogICAgfTsKCiAgICBzdHJ1Y3QgbXNnaGRyIG1zZyA9IHsKICAgICAgICAu
bXNnX25hbWUgPSAmYWRkciwKICAgICAgICAubXNnX25hbWVsZW4gPSBzaXplb2YoYWRkciksCiAg
ICAgICAgLm1zZ19pb3YgPSAmaW92LAogICAgICAgIC5tc2dfaW92bGVuID0gMSwKICAgIH07Cgog
ICAgaW50IHJlcyA9IHJlY3Ztc2cocywgJm1zZywgMC8qTVNHX0RPTlRXQUlUKi8pOwoKICAgIGFz
c2VydChyZXMgPT0gLTEpOwogICAgYXNzZXJ0KGVycm5vID09IEVBR0FJTik7Cn0KCnZvaWQgcmVj
dm1zZ19pb3VyaW5nKGludCBzKQp7CiAgICBzdHJ1Y3Qgc29ja2FkZHJfaW4gYWRkcjsKCiAgICBj
aGFyIGJ1ZmZbMTAyNF07CiAgICBzdHJ1Y3QgaW92ZWMgaW92ID0gewogICAgICAgIC5pb3ZfYmFz
ZSA9IGJ1ZmYsCiAgICAgICAgLmlvdl9sZW4gPSBzaXplb2YoYnVmZikKICAgIH07CgogICAgc3Ry
dWN0IG1zZ2hkciBtc2cgPSB7CiAgICAgICAgLm1zZ19uYW1lID0gJmFkZHIsCiAgICAgICAgLm1z
Z19uYW1lbGVuID0gc2l6ZW9mKGFkZHIpLAogICAgICAgIC5tc2dfaW92ID0gJmlvdiwKICAgICAg
ICAubXNnX2lvdmxlbiA9IDEsCiAgICB9OwoKICAgIHN0cnVjdCBpb191cmluZyByaW5nOwoKICAg
IGludCByZXMgPSBpb191cmluZ19xdWV1ZV9pbml0KDEwMjQsICZyaW5nLCAwKTsKICAgIGFzc2Vy
dChyZXMgPT0gMCk7CgogICAgc3RydWN0IGlvX3VyaW5nX2NxZSAqY3FlOwogICAgc3RydWN0IGlv
X3VyaW5nX3NxZSogc3FlOwoKICAgIHNxZSA9IGlvX3VyaW5nX2dldF9zcWUoJnJpbmcpOwogICAg
aW9fdXJpbmdfcHJlcF9yZWN2bXNnKHNxZSwgcywgJm1zZywgMC8qTVNHX0RPTlRXQUlUKi8pOwoK
ICAgIHJlcyA9IGlvX3VyaW5nX3N1Ym1pdCgmcmluZyk7CiAgICBhc3NlcnQocmVzID09IDEpOwoK
ICAgIHJlcyA9IGlvX3VyaW5nX3dhaXRfY3FlKCZyaW5nLCAmY3FlKTsKICAgIGFzc2VydChyZXMg
PT0gMCk7CgogICAgYXNzZXJ0KGNxZS0+cmVzID09IC1FQUdBSU4pOwoKICAgIGlvX3VyaW5nX2Nx
ZV9zZWVuKCZyaW5nLCBjcWUpOwoKICAgIGlvX3VyaW5nX3F1ZXVlX2V4aXQoJnJpbmcpOwp9Cgpp
bnQgbWFpbihpbnQgYXJnYywgY29uc3QgY2hhciogYXJndltdKQp7CiAgICBpbnQgcyA9IHNvY2tl
dChBRl9JTkVULCBTT0NLX0RHUkFNIHwgU09DS19OT05CTE9DSywgMCk7CiAgICBhc3NlcnQocyAh
PSAtMSk7CgogICAgc3RydWN0IHNvY2thZGRyX2luIGFkZHIgPSB7CiAgICAgICAgLnNpbl9mYW1p
bHkgPSBBRl9JTkVULAogICAgICAgIC5zaW5fcG9ydCA9IDB4MDAxMCwKICAgICAgICAuc2luX2Fk
ZHIuc19hZGRyID0gMHgwMTAwMDA3ZlVMCiAgICB9OwoKICAgIGludCByZXMgPSBiaW5kKHMsIChz
dHJ1Y3Qgc29ja2FkZHIqKSgmYWRkciksIHNpemVvZihhZGRyKSk7CiAgICBhc3NlcnQocmVzID09
IDApOwoKICAgIHJlY3Ztc2dfc3lzY2FsbChzKTsKICAgIHJlY3Ztc2dfaW91cmluZyhzKTsKCiAg
ICByZXR1cm4gMDsKfQo=
--000000000000b0108805e3600a31--
