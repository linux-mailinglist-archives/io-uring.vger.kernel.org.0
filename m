Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B253242E54
	for <lists+io-uring@lfdr.de>; Wed, 12 Aug 2020 19:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgHLR7A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Aug 2020 13:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbgHLR7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Aug 2020 13:59:00 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB72EC061383
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 10:58:59 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b14so2873049qkn.4
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 10:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=WOWfWvl0qTMvfEkuwaS+wD7STMvOcpDuyiFGaVqQjn0=;
        b=K2D2JFmtkjtWVzTo9tENIn8u760euFAM01P2J9Rpu2FE0XY6gqGV0cZiqV5HSJehVQ
         O1bEDbofCx4fizZuXyEHC+xEHnWs4S5ByLK7V01/95aXxlU8PgtAslP4KNOhwrO1tRrW
         Pg2Nm9AW/ioEe2nW8H8mplG/yYpc0O2PE/Hord71NoifA4jlCKRC5GDaP0UzaZmqf8Up
         1cg12Qtc5S6tV7Unn382ClhbDB5Qw7hm1HZDt6oYps50kd2lO5CMIkeFV34eaO3sgWzW
         uYA/hHyQ+VYXwXxU9AmIxXuih3N91YtrA8VHbKoy80uNK5DPBkMzIvno83Gv3QY/K44+
         LF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=WOWfWvl0qTMvfEkuwaS+wD7STMvOcpDuyiFGaVqQjn0=;
        b=AqwCSc0D7XVgmEJKx0lLn7k74ZvHq/v9fIr2BO+cBa6QC6PZfWXVS/PNLCfhK9DNhU
         sZM688U1s+97xJnFI4cLsw/5fAhDWT8R4PrTZSezfsj4YRF2KOJbjq4Oegh5bGCzJ/v4
         gX8MGI5mfk50Ur1DRd8Q+i2CruXYvMlzzjAtSg4aMzCzBJKsb3BUf4YvF2DIsQrFngy3
         5LOzP8hhEgjIfcHqkZkZB6Mi9qMDOcWKT57iK6ncZBgTBx5PtJhzdjMfMH1owY8WRc2u
         uUZg2nM8JjnBXQAhYKC2ddPBuxXpO9mAsUhaTNmzbyHeXR26fZ/eJAx5njuiBfmPAUhm
         Y0Kg==
X-Gm-Message-State: AOAM5331LPoyUy9fZrMXd/VrUbOcBN0PYAASdSmAXwVuQT950WNEDXRE
        UgU63/0GRJnZGLXMjLEQoi+//KITovYqSXkiM/doeb3D
X-Google-Smtp-Source: ABdhPJwbS8+1syRVIVfROAcz6o1uzj3F9f3M9hfbU3xBU5LtDb6KJqtCOie0TkBfRdSWF1hvEBOjnOXK5RfZOkwoXVI=
X-Received: by 2002:a37:c15:: with SMTP id 21mr1044830qkm.422.1597255138547;
 Wed, 12 Aug 2020 10:58:58 -0700 (PDT)
MIME-Version: 1.0
From:   Josef <josef.grieb@gmail.com>
Date:   Wed, 12 Aug 2020 19:58:47 +0200
Message-ID: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
Subject: io_uring process termination/killing is not working
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, norman@apache.org
Content-Type: multipart/mixed; boundary="000000000000262f5505acb1f1be"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--000000000000262f5505acb1f1be
Content-Type: text/plain; charset="UTF-8"

Hi,

I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
doesn't work to kill this process(always state D or D+), literally I
have to terminate my VM because even the kernel can't kill the process
and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
works

I've attached a file to reproduce it
or here
https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c

---
Josef

--000000000000262f5505acb1f1be
Content-Type: application/octet-stream; name="io_uring_process.c"
Content-Disposition: attachment; filename="io_uring_process.c"
Content-Transfer-Encoding: base64
Content-ID: <f_kdro5mn70>
X-Attachment-Id: f_kdro5mn70

I2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8bmV0aW5ldC9p
bi5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3Ry
aW5nLmg+CiNpbmNsdWRlIDxzdHJpbmdzLmg+CiNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+CiNpbmNs
dWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHBvbGwuaD4KI2luY2x1ZGUgImxpYnVyaW5nLmgiCgoj
ZGVmaW5lIEJBQ0tMT0cgNTEyCgojZGVmaW5lIFBPUlQgOTEwMAoKc3RydWN0IGlvX3VyaW5nIHJp
bmc7Cgp2b2lkIGFkZF9wb2xsKHN0cnVjdCBpb191cmluZyAqcmluZywgaW50IGZkKSB7CiAgICBz
dHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUgPSBpb191cmluZ19nZXRfc3FlKHJpbmcpOwogICAgaW9f
dXJpbmdfcHJlcF9wb2xsX2FkZChzcWUsIGZkLCBQT0xMSU4pOwogICAgc3FlLT5mbGFncyB8PSBJ
T1NRRV9JT19MSU5LOwp9Cgp2b2lkIGFkZF9hY2NlcHQoc3RydWN0IGlvX3VyaW5nICpyaW5nLCBp
bnQgZmQpIHsKICAgIHN0cnVjdCBpb191cmluZ19zcWUgKnNxZSA9IGlvX3VyaW5nX2dldF9zcWUo
cmluZyk7CiAgICBpb191cmluZ19wcmVwX2FjY2VwdChzcWUsIGZkLCAwLCAwLCBTT0NLX05PTkJM
T0NLIHwgU09DS19DTE9FWEVDKTsKICAgIHNxZS0+ZmxhZ3MgfD0gSU9TUUVfSU9fTElOSzsKfQoK
aW50IHNldHVwX2lvX3VyaW5nKCkgewogICAgaW50IHJldCA9IGlvX3VyaW5nX3F1ZXVlX2luaXQo
MTYsICZyaW5nLCAwKTsKICAgIGlmIChyZXQpIHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIlVu
YWJsZSB0byBzZXR1cCBpb191cmluZzogJXNcbiIsIHN0cmVycm9yKC1yZXQpKTsKICAgICAgICBy
ZXR1cm4gMTsKICAgIH0KICAgIHJldHVybiAwOwp9CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAq
YXJndltdKSB7CgogICAgc3RydWN0IHNvY2thZGRyX2luIHNlcnZfYWRkcjsKCiAgICBzZXR1cF9p
b191cmluZygpOwogICAgCiAgICBpbnQgc29ja19saXN0ZW5fZmQgPSBzb2NrZXQoQUZfSU5FVCwg
U09DS19TVFJFQU0gfCBTT0NLX05PTkJMT0NLLCAwKTsKICAgIGNvbnN0IGludCB2YWwgPSAxOwog
ICAgc2V0c29ja29wdChzb2NrX2xpc3Rlbl9mZCwgU09MX1NPQ0tFVCwgU09fUkVVU0VBRERSLCAm
dmFsLCBzaXplb2YodmFsKSk7CgogICAgbWVtc2V0KCZzZXJ2X2FkZHIsIDAsIHNpemVvZihzZXJ2
X2FkZHIpKTsKICAgIHNlcnZfYWRkci5zaW5fZmFtaWx5ID0gQUZfSU5FVDsKICAgIHNlcnZfYWRk
ci5zaW5fcG9ydCA9IGh0b25zKFBPUlQpOwogICAgc2Vydl9hZGRyLnNpbl9hZGRyLnNfYWRkciA9
IElOQUREUl9BTlk7CgogICAgaWYgKGJpbmQoc29ja19saXN0ZW5fZmQsIChzdHJ1Y3Qgc29ja2Fk
ZHIgKikmc2Vydl9hZGRyLCBzaXplb2Yoc2Vydl9hZGRyKSkgPCAwKSB7CiAgICAgICAgIHBlcnJv
cigiRXJyb3IgYmluZGluZyBzb2NrZXRcbiIpOwogICAgICAgICBleGl0KDEpOwogICAgIH0KICAg
IGlmIChsaXN0ZW4oc29ja19saXN0ZW5fZmQsIEJBQ0tMT0cpIDwgMCkgewogICAgICAgICBwZXJy
b3IoIkVycm9yIGxpc3RlbmluZyBvbiBzb2NrZXRcbiIpOwogICAgICAgICBleGl0KDEpOwogICAg
fQoKICAgIHNldHVwX2lvX3VyaW5nKCk7CgogICAgYWRkX3BvbGwoJnJpbmcsIHNvY2tfbGlzdGVu
X2ZkKTsKICAgIGFkZF9hY2NlcHQoJnJpbmcsIHNvY2tfbGlzdGVuX2ZkKTsKICAgIGlvX3VyaW5n
X3N1Ym1pdCgmcmluZyk7CgogICAgCiAgICB3aGlsZSAoMSkgewogICAgICAgIHN0cnVjdCBpb191
cmluZ19jcWUgKmNxZTsKICAgICAgICBpb191cmluZ193YWl0X2NxZSgmcmluZywgJmNxZSk7Cgog
ICAgfQoKICAgIGlvX3VyaW5nX3F1ZXVlX2V4aXQoJnJpbmcpOwoKICAgIHJldHVybiAwOwp9
--000000000000262f5505acb1f1be--
