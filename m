Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903364EC799
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 16:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiC3PAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 11:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242336AbiC3PAF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 11:00:05 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9456143
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 07:58:19 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h1so24779940edj.1
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 07:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZiX19yj7rEkzPFMkYa7W7ck7Ox5YrAfpCSVo96Az6NM=;
        b=T8Rc+oBPOZgq0XPxdMz0JJpY1xqGKX6LTjxbDbcRUVmDDfhDHp0YvqSWB5eKD/PBVl
         HZBf5fASFNxSNZphwLd/Nenr/v6/iTHw8+62kMQNZWTiiZeBgeqW3SgVxM5bPjYGT+8R
         6QlgRlaZna6fPACXnf/t8Tz+9wzbSMRm47exI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZiX19yj7rEkzPFMkYa7W7ck7Ox5YrAfpCSVo96Az6NM=;
        b=pK478st89/zzC4ZigZwoLmHLNJxeJS1LmwdoyKFCXmbn6M8TvRAlMQGHw31dx79iyU
         TB5VQKXUoVywhJ3uqsQcmxvsH6wrg0Y/sMglzVB3HoibL0h+7RT33bYfRTBa2pOJ7o4C
         RvkSszuybxBEoCzYz78higBy8Uj3f1d1s+fVv6uhBAvpJ05iFVnYKXuPw/RXAJDfabp2
         iYJ0VJJ5BTWpn5gNWKhqeiG0CL5yAf9dA4hiyXndqHNuLzzlzjdBt+wt89pKbhVFQAS6
         xV6jkbE/xAg+DnSia0Reha3AVR64AoyoIz14tTNCawHNg8DFTHEu5fFhrcY8BCkl9z1Q
         vXIw==
X-Gm-Message-State: AOAM531WZkOrndwIrS+0/NoMiY/DQzFUXfhBVhnEycla190YsHEGT6wJ
        G8njlP7Akq/TScJb6EBiG0JEtTfHS9kgBVNQ9SYX0gaJb9ki6g==
X-Google-Smtp-Source: ABdhPJzWP8iq3PX0QHG0Tywq5vSn2uSYILQEThbQUo6ZmsdfiafO9PUlY9xn8qovPL6G2zzdhm8pKuctf8Ov9sogBKM=
X-Received: by 2002:a50:fe07:0:b0:419:323:baee with SMTP id
 f7-20020a50fe07000000b004190323baeemr10912780edt.221.1648652298232; Wed, 30
 Mar 2022 07:58:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk> <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk> <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk> <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk> <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk> <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk> <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
In-Reply-To: <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 30 Mar 2022 16:58:06 +0200
Message-ID: <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
Subject: Re: io_uring_prep_openat_direct() and link/drain
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000009856d205db70c6b8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--0000000000009856d205db70c6b8
Content-Type: text/plain; charset="UTF-8"

Next issue:  seems like file slot reuse is not working correctly.
Attached program compares reads using io_uring with plain reads of
proc files.

In the below example it is using two slots alternately but the number
of slots does not seem to matter, read is apparently always using a
stale file (the prior one to the most recent open on that slot).  See
how the sizes of the files lag by two lines:

root@kvm:~# ./procreads
procreads: /proc/1/stat: ok (313)
procreads: /proc/2/stat: ok (149)
procreads: /proc/3/stat: read size mismatch 313/150
procreads: /proc/4/stat: read size mismatch 149/154
procreads: /proc/5/stat: read size mismatch 150/161
procreads: /proc/6/stat: read size mismatch 154/171
...

Any ideas?

Thanks,
Miklos

--0000000000009856d205db70c6b8
Content-Type: text/x-csrc; charset="US-ASCII"; name="procreads.c"
Content-Disposition: attachment; filename="procreads.c"
Content-Transfer-Encoding: base64
Content-ID: <f_l1dovtuo0>
X-Attachment-Id: f_l1dovtuo0

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+
CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPGRpcmVudC5oPgojaW5jbHVkZSA8dW5pc3Rk
Lmg+CiNpbmNsdWRlIDxlcnIuaD4KI2luY2x1ZGUgImxpYnVyaW5nLmgiCgojZGVmaW5lIENIRUNL
X05FR0VSUihfZXhwcikgXAoJKHsgdHlwZW9mKF9leHByKSBfcmV0ID0gKF9leHByKTsgaWYgKF9y
ZXQgPCAwKSB7IGVycm5vID0gLV9yZXQ7IGVycigxLCAjX2V4cHIpOyB9IF9yZXQ7IH0pCiNkZWZp
bmUgQ0hFQ0tfTlVMTChfZXhwcikgXAoJKHsgdHlwZW9mKF9leHByKSBfcmV0ID0gKF9leHByKTsg
aWYgKF9yZXQgPT0gTlVMTCkgeyBlcnJ4KDEsICNfZXhwciAiIHJldHVybmVkIE5VTEwiKTsgfSBf
cmV0OyB9KQoKc3NpemVfdCByZWFkZmlsZV91cmluZyhzdHJ1Y3QgaW9fdXJpbmcgKnJpbmcsIGlu
dCBzbG90LAoJCSAgICAgICBjb25zdCBjaGFyICpwYXRoLCBjaGFyICpidWYsIHNpemVfdCBzaXpl
KQp7CglzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWU7CglzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7
CglpbnQgcmV0LCBpOwoJdW5zaWduZWQgaW50IHN1bSA9IDA7CgoJZm9yIChpID0gMDsgcGF0aFtp
XTsgaSsrKQoJCXN1bSArPSBwYXRoW2ldOwoKCXNxZSA9IGlvX3VyaW5nX2dldF9zcWUocmluZyk7
Cglpb191cmluZ19wcmVwX29wZW5hdF9kaXJlY3Qoc3FlLCBBVF9GRENXRCwgcGF0aCwgT19SRE9O
TFksIDAsIHNsb3QpOwoJc3FlLT5mbGFncyA9IElPU1FFX0lPX0xJTksgfCBJT1NRRV9DUUVfU0tJ
UF9TVUNDRVNTOwoJc3FlLT51c2VyX2RhdGEgPSAweGRlYWQwMDAwICsgc3VtOwoKCXNxZSA9IGlv
X3VyaW5nX2dldF9zcWUocmluZyk7Cglpb191cmluZ19wcmVwX3JlYWQoc3FlLCBzbG90LCBidWYs
IHNpemUsIDApOwoJc3FlLT5mbGFncyA9IElPU1FFX0ZJWEVEX0ZJTEU7CglzcWUtPnVzZXJfZGF0
YSA9IDB4ZmVlZDAwMDAgKyBzdW07CgoJcmV0ID0gQ0hFQ0tfTkVHRVJSKGlvX3VyaW5nX3N1Ym1p
dF9hbmRfd2FpdChyaW5nLCAxKSk7CglpZiAocmV0IDwgMikKCQl3YXJueCgic2hvcnQgc3VibWl0
IGNvdW50OiAlaSIsIHJldCk7CgoJcmV0ID0gQ0hFQ0tfTkVHRVJSKGlvX3VyaW5nX3dhaXRfY3Fl
KHJpbmcsICZjcWUpKTsKCglpZiAoKGNxZS0+dXNlcl9kYXRhICYgMHhmZmZmKSAhPSBzdW0pCgkJ
d2FybngoIndyb25nIHN1bTogJXggKHNob3VsZCBiZSAleCkiLCh1bnNpZ25lZCBpbnQpIGNxZS0+
dXNlcl9kYXRhLCBzdW0pOwoJaWYgKGNxZS0+cmVzID49IDAgJiYgKGNxZS0+dXNlcl9kYXRhICYg
MHhmZmZmMDAwMCkgIT0gMHhmZWVkMDAwMCkKCQl3YXJueCgibm90IHNraXBwZWQ6ICV4IiwgKHVu
c2lnbmVkIGludCkgY3FlLT51c2VyX2RhdGEpOwoKCXJldCA9IGNxZS0+cmVzOwoJaW9fdXJpbmdf
Y3FlX3NlZW4ocmluZywgY3FlKTsKCWlmIChyZXQgPCAwKSB7CgkJZXJybm8gPSAtcmV0OwoJCXdh
cm4oImZhaWxlZCB0byBvcGVuIG9yIHJlYWQgJXMiLCBwYXRoKTsKCX0KCglyZXR1cm4gcmV0Owp9
CgpzdGF0aWMgc3NpemVfdCByZWFkZmlsZV9wbGFpbihjb25zdCBjaGFyICpwYXRoLCBjaGFyICpi
dWYsIHNpemVfdCBzaXplKQp7CglpbnQgZmQ7Cglzc2l6ZV90IHJldDsKCglmZCA9IG9wZW4ocGF0
aCwgT19SRE9OTFkpOwoJaWYgKGZkID09IC0xKQoJCXJldHVybiAtZXJybm87CgoJcmV0ID0gcmVh
ZChmZCwgYnVmLCBzaXplKTsKCWlmIChyZXQgPT0gLTEpCgkJcmV0dXJuIC1lcnJubzsKCgljbG9z
ZShmZCk7CgoJcmV0dXJuIHJldDsKfQoKaW50IG1haW4odm9pZCkKewoJaW50IGZkc1tdID0geyAt
MSwgLTEgfTsKCXN0cnVjdCBpb191cmluZyByaW5nOwoJY2hhciAqbmFtZSwgcGF0aFs0MDk2XSwg
YnVmMVs0MDk2XSwgYnVmMls0MDk2XTsKCURJUiAqZHA7CglzdHJ1Y3QgZGlyZW50ICpkZTsKCXNz
aXplX3QgcmV0MSwgcmV0MjsKCWludCBzbG90ID0gMDsKCXVuc2lnbmVkIGludCBudW1zbG90cyA9
IHNpemVvZihmZHMpL3NpemVvZihmZHNbMF0pOwoKCUNIRUNLX05FR0VSUihpb191cmluZ19xdWV1
ZV9pbml0KDMyLCAmcmluZywgMCkpOwoJQ0hFQ0tfTkVHRVJSKGlvX3VyaW5nX3JlZ2lzdGVyX2Zp
bGVzKCZyaW5nLCBmZHMsIG51bXNsb3RzKSk7CgoJZHAgPSBDSEVDS19OVUxMKG9wZW5kaXIoIi9w
cm9jIikpOwoJd2hpbGUgKChkZSA9IHJlYWRkaXIoZHApKSkgewoJCW5hbWUgPSBkZS0+ZF9uYW1l
OwoJCWlmIChuYW1lWzBdID4gJzAnICYmIG5hbWVbMF0gPD0gJzknKSB7CgkJCXNwcmludGYocGF0
aCwgIi9wcm9jLyVzL3N0YXQiLCBuYW1lKTsKCQkJcmV0MSA9IHJlYWRmaWxlX3VyaW5nKCZyaW5n
LCBzbG90LCBwYXRoLCBidWYxLCBzaXplb2YoYnVmMSkpOwoJCQlyZXQyID0gcmVhZGZpbGVfcGxh
aW4ocGF0aCwgYnVmMiwgc2l6ZW9mKGJ1ZjIpKTsKCQkJaWYgKHJldDEgIT0gcmV0MikKCQkJCXdh
cm54KCIlczogcmVhZCBzaXplIG1pc21hdGNoICV6aS8lemkiLAoJCQkJICAgICAgcGF0aCwgcmV0
MSwgcmV0Mik7CgkJCWVsc2UgaWYgKHJldDEgPiAwICYmIG1lbWNtcChidWYxLCBidWYyLCByZXQx
KSkKCQkJCXdhcm54KCIlczogZGF0YSBtaXNtYXRjaCIsIHBhdGgpOwoJCQllbHNlIHsKCQkJCXdh
cm54KCIlczogb2sgKCV6aSkiLCBwYXRoLCByZXQxKTsKCQkJfQoKCQkJc2xvdCA9IChzbG90ICsg
MSkgJSBudW1zbG90czsKCQl9Cgl9CgljbG9zZWRpcihkcCk7CglyZXR1cm4gMDsKfQo=
--0000000000009856d205db70c6b8--
