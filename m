Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D774EAE4F
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 15:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbiC2NWz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 09:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiC2NWz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 09:22:55 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E2F21828
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 06:21:12 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id pv16so35159954ejb.0
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 06:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=FOOhbUKVkgv0Ptct8sGyxTKGaS/9DHZnnYIjEfjIyrc=;
        b=X5fukXJIS6YyD0Y34yXIXTT6Ozb3IbCJQEvZ9iOqfcetQDPcz+V7TT3I/456UkogN/
         Z1weigmY1JWbfp4iWqYiiEhXvnrLSinV5TN1MdcW66XqddXsT1GaE3eClDBRstbrRcPA
         8w8Pp4l0vZebG4r0klK1wbLgy3A3jolN3rkZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=FOOhbUKVkgv0Ptct8sGyxTKGaS/9DHZnnYIjEfjIyrc=;
        b=aM+aGxYIcCob6fZfu4EIGZasDHkL1ZD6C3nb7J446duIRGeUIrgIqHuqlJmoJ8fy0z
         P7ybn732LNycx96gV4FdITlUMrN8wic+AI8Jlo6cK8fdz4dRMIhJz/Sbv5KOk1jxWzcs
         oLfpEO1apxxkWhqYTDLYaTN4f1jZI+ViNQdN0lqvNAP1pPF7q1gec6u3/3M9iuOo4Kh/
         MDr62lxBSu8S+57H+b+1iqbWc3Lgmfv52D8LFs/N+V70AfXTuAHE9tfZL1Q3z8a88kcm
         kOkCNxo3UFEROAu5gEbEBrz5cW4uEUgbDt0Bb75Z6Mfv96wg4OmAQpl7ZXDqCUWo252/
         svHQ==
X-Gm-Message-State: AOAM5302DMZfZSZVv/ycd+UvbxovV4KB1F8XIXgPzWoJdhg2DDcdDHSP
        1oTy1KyeAcKJtzfWoYRHXT5C4EVJetXN430qpmFkFYewEJXBhA==
X-Google-Smtp-Source: ABdhPJzeeDeEzSzKAPcJ+VkDbDV1Qk0VvucCbCcHk7uhE7rxAFW7Y85mMjTVdh2bnWYcm7lvF5QjtLgMquMJpJ9VDg8=
X-Received: by 2002:a17:907:9605:b0:6d7:24d1:f4ce with SMTP id
 gb5-20020a170907960500b006d724d1f4cemr34193969ejc.524.1648560070919; Tue, 29
 Mar 2022 06:21:10 -0700 (PDT)
MIME-Version: 1.0
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 29 Mar 2022 15:20:59 +0200
Message-ID: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
Subject: io_uring_prep_openat_direct() and link/drain
To:     io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000006b3b4a05db5b4d72"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--0000000000006b3b4a05db5b4d72
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm trying to read multiple files with io_uring and getting stuck,
because the link and drain flags don't seem to do what they are
documented to do.

Kernel is v5.17 and liburing is compiled from the git tree at
7a3a27b6a384 ("add tests for nonblocking accept sockets").

Without those flags the attached example works some of the time, but
that's probably accidental since ordering is not ensured.

Adding the drain or link flags make it even worse (fail in casese that
the unordered one didn't).

What am I missing?

Thanks,
Miklos

--0000000000006b3b4a05db5b4d72
Content-Type: text/x-csrc; charset="US-ASCII"; name="readfiles.c"
Content-Disposition: attachment; filename="readfiles.c"
Content-Transfer-Encoding: base64
Content-ID: <f_l1c5xvt10>
X-Attachment-Id: f_l1c5xvt10

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+
CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPGVyci5oPgojaW5jbHVkZSAibGlidXJpbmcu
aCIKCiNkZWZpbmUgQ0hFQ0tfTkVHRVJSKF9leHByKSBcCgkoeyB0eXBlb2YoX2V4cHIpIF9yZXQg
PSAoX2V4cHIpOyBpZiAoX3JldCA8IDApIHsgZXJybm8gPSAtX3JldDsgZXJyKDEsICNfZXhwcik7
IH0gX3JldDsgfSkKI2RlZmluZSBDSEVDS19OVUxMKF9leHByKSBcCgkoeyB0eXBlb2YoX2V4cHIp
IF9yZXQgPSAoX2V4cHIpOyBpZiAoX3JldCA9PSBOVUxMKSB7IGVycngoMSwgI19leHByICIgcmV0
dXJuZWQgTlVMTCIpOyB9IF9yZXQ7IH0pCgoKaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3Zb
XSkKewoJc3RydWN0IGlvX3VyaW5nIHJpbmc7CglpbnQgcmV0LCBvLCBpLCBqLCB4LCBudW0sIHNs
b3Q7CglzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWU7CglzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7
CgljaGFyICpzLCAqKmJ1ZnM7CglpbnQgKmZkczsKCWNvbnN0IHNpemVfdCBidWZzaXplID0gMTMx
MDcyOwoJY29uc3QgaW50IG9wc19wZXJfZmlsZSA9IDI7CgoJaWYgKGFyZ2MgPCAyKQoJCWVycngo
MSwgInVzYWdlOiAlcyBmaWxlIFsuLi5dIiwgYXJndlswXSk7CgoJbnVtID0gYXJnYyAtIDE7Cgli
dWZzID0gQ0hFQ0tfTlVMTChjYWxsb2MobnVtLCBzaXplb2YoYnVmc1swXSkpKTsKCWZkcyA9IENI
RUNLX05VTEwoY2FsbG9jKG51bSwgc2l6ZW9mKGZkc1swXSkpKTsKCWZvciAoaSA9IDA7IGkgPCBu
dW07IGkrKykgewoJCWJ1ZnNbaV0gPSBDSEVDS19OVUxMKG1hbGxvYyhidWZzaXplKSk7CgkJZmRz
W2ldID0gLTE7Cgl9CgoJcmV0ID0gQ0hFQ0tfTkVHRVJSKGlvX3VyaW5nX3F1ZXVlX2luaXQobnVt
ICogb3BzX3Blcl9maWxlLCAmcmluZywgMCkpOwoJcmV0ID0gQ0hFQ0tfTkVHRVJSKGlvX3VyaW5n
X3JlZ2lzdGVyX2ZpbGVzKCZyaW5nLCBmZHMsIG51bSkpOwoKCWZvciAoaSA9IDA7IGkgPCBudW07
IGkrKykgewoJCXNsb3QgPSBpOwoKCQlzcWUgPSBDSEVDS19OVUxMKGlvX3VyaW5nX2dldF9zcWUo
JnJpbmcpKTsKCQlzcWUtPnVzZXJfZGF0YSA9IGkgKiBvcHNfcGVyX2ZpbGU7CgkJaW9fdXJpbmdf
cHJlcF9vcGVuYXRfZGlyZWN0KHNxZSwgQVRfRkRDV0QsIGFyZ3ZbaSArIDFdLAoJCQkJCSAgICBP
X1JET05MWSwgMCwgc2xvdCk7Ci8vCQlzcWUtPmZsYWdzIHw9IElPU1FFX0lPX0RSQUlOOwovLwkJ
c3FlLT5mbGFncyB8PSBJT1NRRV9JT19MSU5LOwoKCQlzcWUgPSBDSEVDS19OVUxMKGlvX3VyaW5n
X2dldF9zcWUoJnJpbmcpKTsKCQlzcWUtPnVzZXJfZGF0YSA9IGkgKiBvcHNfcGVyX2ZpbGUgKyAx
OwoJCWlvX3VyaW5nX3ByZXBfcmVhZChzcWUsIHNsb3QsIGJ1ZnNbaV0sIGJ1ZnNpemUsIDApOwoJ
CXNxZS0+ZmxhZ3MgfD0gSU9TUUVfRklYRURfRklMRTsKLy8JCXNxZS0+ZmxhZ3MgfD0gSU9TUUVf
SU9fRFJBSU47Ci8vCQlzcWUtPmZsYWdzIHw9IElPU1FFX0lPX0xJTks7Cgl9CgoJcmV0ID0gQ0hF
Q0tfTkVHRVJSKGlvX3VyaW5nX3N1Ym1pdCgmcmluZykpOwoJaWYgKHJldCAhPSBudW0gKiBvcHNf
cGVyX2ZpbGUpCgkJd2FybngoImlvX3VyaW5nX3N1Ym1pdCBzdWJtaXR0ZWQgbGVzczogJWRcbiIs
IHJldCk7CgoJZm9yIChqID0gcmV0OyBqOyBqLS0pIHsKCQlDSEVDS19ORUdFUlIoaW9fdXJpbmdf
d2FpdF9jcWUoJnJpbmcsICZjcWUpKTsKCgkJeCA9IGNxZS0+dXNlcl9kYXRhICUgb3BzX3Blcl9m
aWxlOwoJCWkgPSBjcWUtPnVzZXJfZGF0YSAvIG9wc19wZXJfZmlsZTsKCQlwcmludGYoIiVpLyVp
IFslc10gPSAiLCBpLCB4LCBhcmd2W2kgKyAxXSk7CgoJCXJldCA9IGNxZS0+cmVzOwoJCWlmIChy
ZXQgPCAwKSB7CgkJCXByaW50ZigiRVJST1I6ICVzICglaSlcbiIsIHN0cmVycm9yKC1yZXQpLCBy
ZXQpOwoJCX0gZWxzZSBpZiAoeCA9PSAxKSB7CgkJCXMgPSBidWZzW2ldOwoKCQkJZm9yIChvID0g
MDsgbyA8IHJldDsgbyArPSBzdHJsZW4ocyArIG8pICsgMSkKCQkJCXByaW50ZigiXCIlLipzXCIg
IiwgcmV0IC0gbywgcyArIG8pOwoKCQkJcHJpbnRmKCIobGVuPSVpKVxuIiwgcmV0KTsKCQl9IGVs
c2UgaWYgKHggPT0gMCkgewoJCQlwcmludGYoIlNVQ0NFU1Mgb3BlblxuIik7CgkJfSBlbHNlIHsK
CQkJcHJpbnRmKCJTVUNDRVNTID8/P1xuIik7CgkJfQoJCWlvX3VyaW5nX2NxZV9zZWVuKCZyaW5n
LCBjcWUpOwoJfQoKCWlvX3VyaW5nX3F1ZXVlX2V4aXQoJnJpbmcpOwoJcmV0dXJuIDA7Cn0K
--0000000000006b3b4a05db5b4d72--
