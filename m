Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316A0245515
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 02:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgHPAhF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 20:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgHPAhF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 20:37:05 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3060DC061786
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 17:37:05 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id w9so9845400qts.6
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 17:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rqory6RW3CNYR2hveDLeRFFPPL3sJ+4XUKnOrQgSUjE=;
        b=JDfKrPCxpx07/e64Wk1EsNLLMPGfwSylvcnfyKBFXh3/B4V3xwmCqe8ceo54FcWPGq
         kzx2jOji4q0ZF5xqReNRLhrVsTyiMRWuUElIXXN56chSfcYabNPSkTmnHU72kQHptrhE
         Bog5oMTO8IY876UTnBj+MBwRvdBjOl3JFlboyUMZuDxYexq0Y1MvIync31ABimrM7VK1
         rIaxLcGfsj/z2J0+E9if1gCJPi1RLTKlMDlKQocLJXnSYg7WtBm2FszQvxUoEglrYKOt
         gSNgVaR3Tw84NzI4+flgFIWOl+WD9miZ9fxmn9huXou6c1f4sq80xd4KepVXYSDPYofp
         dnkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rqory6RW3CNYR2hveDLeRFFPPL3sJ+4XUKnOrQgSUjE=;
        b=c2gKoWNW4Tet5KU3ILnKSUHzRVgW0PiIIOr8swRSoMd+VspudSqFPW1qlxULw21OcL
         t6r9BTyc/h8UObp5qUY+9/+tDGHeyX5hTSttOdDkfxZlFggmumRuw47wqKVArOjSzPb0
         6IqAtVq84ZWatzsedveXcTmoJFl5ODoojUdYiCtmtLOfwOsMgUFdsTB+PZqcAmpdNhWX
         3vNTsZpjMwHgOiy1UDi/iXYEFM+v1819eR/EMPhxz13Sdfz9cPQ50K8CJEnqCFtmhNSS
         MCVIOUO3rZ1hkLOooCfPc6jFHkX8Jufl4NxXF556cXYxoDmHzII8LhLskN4IH7wTV6nu
         3eHw==
X-Gm-Message-State: AOAM533YM9hFZGHRcO+05AomkVCwysDLZX3lQ5s/EY1UfbUHnBYkQAWU
        CJni3UXSaIIWdEx6wdr83uy49AWPvGb3u1k7U1c=
X-Google-Smtp-Source: ABdhPJwUOm7kffZRzpPO7yjQR99c/Yz2O1fgHGKYb42D+LbowlYMeKMlM9w4kWEATmTXkJsMeNi8t0p0mcuH14/mzPw=
X-Received: by 2002:ac8:70cd:: with SMTP id g13mr8075686qtp.53.1597538224407;
 Sat, 15 Aug 2020 17:37:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk> <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com> <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk> <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk> <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
 <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk> <904b4d74-09ec-0bd3-030a-59b09fb1a7da@kernel.dk>
In-Reply-To: <904b4d74-09ec-0bd3-030a-59b09fb1a7da@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 16 Aug 2020 02:36:53 +0200
Message-ID: <CAAss7+r8CZMVmxj0_mHTPUVbp3BzT4LGa2uEUjCK1NpXQnDkdw@mail.gmail.com>
Subject: Re: io_uring process termination/killing is not working
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: multipart/mixed; boundary="00000000000061a2a105acf3da47"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--00000000000061a2a105acf3da47
Content-Type: text/plain; charset="UTF-8"

> Please try:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=41d3344604e80db0e466f9deca5262b0914e4827
>
> There was a bug with the -EAGAIN doing repeated retries on sockets that
> are marked non-blocking.
>

no it's not working, however I received the read event after
the second request (instead of the third request before) via Telnet

--
Josef Grieb

--00000000000061a2a105acf3da47
Content-Type: text/x-c-code; charset="US-ASCII"; name="io_uring_read_issue.c"
Content-Disposition: attachment; filename="io_uring_read_issue.c"
Content-Transfer-Encoding: base64
Content-ID: <f_kdwcsjui0>
X-Attachment-Id: f_kdwcsjui0

I2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8bmV0aW5ldC9p
bi5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3Ry
aW5nLmg+CiNpbmNsdWRlIDxzdHJpbmdzLmg+CiNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+CiNpbmNs
dWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHBvbGwuaD4KI2luY2x1ZGUgImxpYnVyaW5nLmgiCgoj
ZGVmaW5lIEJBQ0tMT0cgNTEyCgojZGVmaW5lIFBPUlQgOTcwMAoKc3RydWN0IGlvX3VyaW5nIHJp
bmc7CgpjaGFyIGJ1ZlsxMDBdOwoKdm9pZCBhZGRfcG9sbChpbnQgZmQsIHVuc2lnbmVkIGludCBw
b2xsX21hc2spIHsKICAgIHN0cnVjdCBpb191cmluZ19zcWUgKnNxZSA9IGlvX3VyaW5nX2dldF9z
cWUoJnJpbmcpOwogICAgaW9fdXJpbmdfcHJlcF9wb2xsX2FkZChzcWUsIGZkLCBwb2xsX21hc2sp
OwogICAgc3FlLT51c2VyX2RhdGEgPSAxOwogICAgc3FlLT5mbGFncyB8PSBJT1NRRV9JT19MSU5L
Owp9Cgp2b2lkIGFkZF9hY2NlcHQoaW50IGZkKSB7CiAgICBzdHJ1Y3QgaW9fdXJpbmdfc3FlICpz
cWUgPSBpb191cmluZ19nZXRfc3FlKCZyaW5nKTsKICAgIGlvX3VyaW5nX3ByZXBfYWNjZXB0KHNx
ZSwgZmQsIDAsIDAsIFNPQ0tfTk9OQkxPQ0sgfCBTT0NLX0NMT0VYRUMpOwogICAgc3FlLT51c2Vy
X2RhdGEgPSAyOwp9Cgp2b2lkIGFkZF9yZWFkKGludCBmZCkgewogICAgc3RydWN0IGlvX3VyaW5n
X3NxZSAqc3FlID0gaW9fdXJpbmdfZ2V0X3NxZSgmcmluZyk7CiAgICBpb191cmluZ19wcmVwX3Jl
YWQoc3FlLCBmZCwgJmJ1ZiwgMTAwLCAwKTsKICAgIHNxZS0+dXNlcl9kYXRhID0gMzsKfQoKaW50
IHNldHVwX2lvX3VyaW5nKCkgewogICAgaW50IHJldCA9IGlvX3VyaW5nX3F1ZXVlX2luaXQoMTYs
ICZyaW5nLCAwKTsKICAgIGlmIChyZXQpIHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIlVuYWJs
ZSB0byBzZXR1cCBpb191cmluZzogJXNcbiIsIHN0cmVycm9yKC1yZXQpKTsKICAgICAgICByZXR1
cm4gMTsKICAgIH0KICAgIHJldHVybiAwOwp9CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJn
dltdKSB7CgogICAgc3RydWN0IHNvY2thZGRyX2luIHNlcnZfYWRkcjsKCiAgICBzZXR1cF9pb191
cmluZygpOwogICAgCiAgICBpbnQgc29ja19saXN0ZW5fZmQgPSBzb2NrZXQoQUZfSU5FVCwgU09D
S19TVFJFQU0gfCBTT0NLX05PTkJMT0NLLCAwKTsKICAgIGNvbnN0IGludCB2YWwgPSAxOwogICAg
c2V0c29ja29wdChzb2NrX2xpc3Rlbl9mZCwgU09MX1NPQ0tFVCwgU09fUkVVU0VBRERSLCAmdmFs
LCBzaXplb2YodmFsKSk7CgogICAgbWVtc2V0KCZzZXJ2X2FkZHIsIDAsIHNpemVvZihzZXJ2X2Fk
ZHIpKTsKICAgIHNlcnZfYWRkci5zaW5fZmFtaWx5ID0gQUZfSU5FVDsKICAgIHNlcnZfYWRkci5z
aW5fcG9ydCA9IGh0b25zKFBPUlQpOwogICAgc2Vydl9hZGRyLnNpbl9hZGRyLnNfYWRkciA9IElO
QUREUl9BTlk7CgogICAgaWYgKGJpbmQoc29ja19saXN0ZW5fZmQsIChzdHJ1Y3Qgc29ja2FkZHIg
Kikmc2Vydl9hZGRyLCBzaXplb2Yoc2Vydl9hZGRyKSkgPCAwKSB7CiAgICAgICAgIHBlcnJvcigi
RXJyb3IgYmluZGluZyBzb2NrZXRcbiIpOwogICAgICAgICBleGl0KDEpOwogICAgIH0KICAgIGlm
IChsaXN0ZW4oc29ja19saXN0ZW5fZmQsIEJBQ0tMT0cpIDwgMCkgewogICAgICAgICBwZXJyb3Io
IkVycm9yIGxpc3RlbmluZyBvbiBzb2NrZXRcbiIpOwogICAgICAgICBleGl0KDEpOwogICAgfQoK
ICAgIHNldHVwX2lvX3VyaW5nKCk7CgogICAgYWRkX3BvbGwoc29ja19saXN0ZW5fZmQsIFBPTExJ
Tik7CiAgICBhZGRfYWNjZXB0KHNvY2tfbGlzdGVuX2ZkKTsKICAgIGlvX3VyaW5nX3N1Ym1pdCgm
cmluZyk7CgogICAgd2hpbGUgKDEpIHsKICAgICAgICBzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7
CiAgICAgICAgaW9fdXJpbmdfd2FpdF9jcWUoJnJpbmcsICZjcWUpOwoKICAgICAgICBwcmludGYo
IlJlczogcmVzOiAlZFxuIiwgY3FlLT5yZXMpOwogICAgICAgIAogICAgICAgIGlmIChjcWUtPnVz
ZXJfZGF0YSA9PSAxKSB7CiAgICAgICAgICAgIHByaW50ZigiUG9sbCBFdmVudFxuIik7CiAgICAg
ICAgfQogICAgICAgIAogICAgICAgIGlmIChjcWUtPnVzZXJfZGF0YSA9PSAyICYmIGNxZS0+cmVz
ID4gMCkgewogICAgICAgICAgICBwcmludGYoIkFjY2VwdCBFdmVudFxuIik7CiAgICAgICAgICAg
ICAgICAgICAgCiAgICAgICAgICAgIGFkZF9wb2xsKHNvY2tfbGlzdGVuX2ZkLCBQT0xMSU4pOwog
ICAgICAgICAgICBhZGRfYWNjZXB0KHNvY2tfbGlzdGVuX2ZkKTsKCiAgICAgICAgICAgIGFkZF9w
b2xsKGNxZS0+cmVzLCBQT0xMSU4pOwogICAgICAgICAgICBhZGRfcmVhZChjcWUtPnJlcyk7CiAg
ICAgICAgfQoKICAgICAgICBpZiAoY3FlLT51c2VyX2RhdGEgPT0gMykgewogICAgICAgICAgICBw
cmludGYoIlJlYWQgQnVmOiAlcyBcbiIsIGJ1Zik7CiAgICAgICAgfQogICAgICAgIGlvX3VyaW5n
X3N1Ym1pdCgmcmluZyk7CgogICAgICAgIGlvX3VyaW5nX2NxZV9zZWVuKCZyaW5nLCBjcWUpOwog
ICAgfQoKICAgIGlvX3VyaW5nX3F1ZXVlX2V4aXQoJnJpbmcpOwoKICAgIHJldHVybiAwOwp9
--00000000000061a2a105acf3da47--
