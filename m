Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B57154F8E8
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 16:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381543AbiFQOHp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 10:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382620AbiFQOHo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 10:07:44 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762FA13F22
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:07:42 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u2so4284028pfc.2
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to;
        bh=4yprwm9eTbm++5Uh+rLLpjQ2X1oEAZjMbfBnQD/KuX8=;
        b=OZ3HXlAeXB3pSPyLW0aSE0QA4OF+Meg5HRzyCDRW0eAS/ItqGpk4q/N+I+ABhlszhQ
         fQxb6aDKH+YLBNxtx2npWo9rH0/PaQGTZkFSmcbeEa9yGYvunU32QsJdwTLHRlZZazJw
         dESwlTgOdI4Can2yyNO4p5f570udnlfbzg3A9mdfJFPfh6CQbMDwYIQxe/CelV8wXXIz
         KGxRntib3ne+LL5oVX7FMORwvba/Ba47QoGqhc+tK14NvTkUxJpG1I9+hlzyJVPVNXqX
         wA6tDAiRQee/ngRRPVaqTJ4Q9aFr2SjLjgShz7LMcj3oUj6L4Xby5QyZ7EQQFXnqU1mL
         weBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to;
        bh=4yprwm9eTbm++5Uh+rLLpjQ2X1oEAZjMbfBnQD/KuX8=;
        b=fo73ysZltjpzt3Z+d7Ptk779wmmUD30E5i7c15fN2CvKa9c/ZPiI1SjX7TbWZfllek
         m5G+Dsp3qM8OlLyuDxmd+oI21xlBrTzrJ6sHO/tRoRXNxieggZT7M1Uoau4OHF2ADBIf
         IFcMwbC+JRKf/fY/5WrMGJIcyz+lLOHCLSrBp1AQliDvaL7GP4o5fAD/5T9KqxmZ5O9T
         +M5d60EngDQY4vnlBNnpJPfXhqmTyTdUk+tjsjpUjxScRsO5tXG6X6FJDLLHyE3ZYeg3
         GpKeLnokiHv3MZF81yJ1rAWlY8SLiZXZ9YLRycmlHxk2tDF2KY7pdYu3cfb+ZuleryG8
         PsWg==
X-Gm-Message-State: AJIora/emlZyNxQphYwrkJwSfbWZoqWYpOlbyItqbQUuLgyeuWmfRygb
        NrsV2Z/IkqxOsyshf8bEF2K9FZxfbP6fZQ==
X-Google-Smtp-Source: AGRyM1vw6do4pio+dHdVnD2kN8mr73NRvRPsamvGaLHwNHARCJ4awFJ0J7huniw+WNKrK/bpy5X+yQ==
X-Received: by 2002:a63:5706:0:b0:3fc:a31b:9083 with SMTP id l6-20020a635706000000b003fca31b9083mr9196975pgb.333.1655474861381;
        Fri, 17 Jun 2022 07:07:41 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z14-20020a170902ccce00b001635b86a790sm3623427ple.44.2022.06.17.07.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 07:07:38 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------K2hQYmX7hs0AWCqS6B90mC22"
Message-ID: <6a48a16e-db4a-2a0d-4d85-35c48b715d6f@kernel.dk>
Date:   Fri, 17 Jun 2022 08:07:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCHSET RFC for-next 0/2] Add direct descriptor ring passing
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220617134504.368706-1-axboe@kernel.dk>
In-Reply-To: <20220617134504.368706-1-axboe@kernel.dk>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------K2hQYmX7hs0AWCqS6B90mC22
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/22 7:45 AM, Jens Axboe wrote:
> Hi,
> 
> One of the things we currently cannot do with direct descriptors is pass
> it to another application or ring. This adds support for doing so, through
> the IORING_OP_MSG_RING ring-to-ring messaging opcode.
> 
> Some unresolved questions in patch 2 that need debating.

Here's the basic test case I wrote for it.

-- 
Jens Axboe

--------------K2hQYmX7hs0AWCqS6B90mC22
Content-Type: text/x-csrc; charset=UTF-8; name="fd-pass.c"
Content-Disposition: attachment; filename="fd-pass.c"
Content-Transfer-Encoding: base64

LyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IE1JVCAqLwovKgogKiBEZXNjcmlwdGlvbjog
cnVuIHZhcmlvdXMgZml4ZWQgZmlsZSBmZCBwYXNzaW5nIHRlc3RzCiAqCiAqLwojaW5jbHVk
ZSA8ZXJybm8uaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2lu
Y2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxmY250bC5o
PgoKI2luY2x1ZGUgImxpYnVyaW5nLmgiCiNpbmNsdWRlICJoZWxwZXJzLmgiCgojZGVmaW5l
IEZTSVpFCTEyOAojZGVmaW5lIFBBVAkweDlhCgpzdGF0aWMgaW50IHZlcmlmeV9maXhlZF9y
ZWFkKHN0cnVjdCBpb191cmluZyAqcmluZywgaW50IGZpeGVkX2ZkLCBpbnQgZmFpbCkKewoJ
c3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlOwoJc3RydWN0IGlvX3VyaW5nX2NxZSAqY3FlOwoJ
Y2hhciBidWZbRlNJWkVdOwoJaW50IGk7CgkKCXNxZSA9IGlvX3VyaW5nX2dldF9zcWUocmlu
Zyk7Cglpb191cmluZ19wcmVwX3JlYWQoc3FlLCBmaXhlZF9mZCwgYnVmLCBGU0laRSwgMCk7
CglzcWUtPmZsYWdzIHw9IElPU1FFX0ZJWEVEX0ZJTEU7Cglpb191cmluZ19zdWJtaXQocmlu
Zyk7CgoJaW9fdXJpbmdfd2FpdF9jcWUocmluZywgJmNxZSk7CglpZiAoY3FlLT5yZXMgIT0g
RlNJWkUpIHsKCQlpZiAoZmFpbCAmJiBjcWUtPnJlcyA9PSAtRUJBREYpCgkJCXJldHVybiAw
OwoJCWZwcmludGYoc3RkZXJyLCAiUmVhZDogJWRcbiIsIGNxZS0+cmVzKTsKCQlyZXR1cm4g
MTsKCX0KCWlvX3VyaW5nX2NxZV9zZWVuKHJpbmcsIGNxZSk7CgoJZm9yIChpID0gMDsgaSA8
IEZTSVpFOyBpKyspIHsKCQlpZiAoYnVmW2ldICE9IFBBVCkgewoJCQlmcHJpbnRmKHN0ZGVy
ciwgImdvdCAleCwgd2FudGVkICV4XG4iLCBidWZbaV0sIFBBVCk7CgkJCXJldHVybiAxOwoJ
CX0KCX0KCglyZXR1cm4gMDsKfQoKc3RhdGljIGludCB0ZXN0KGNvbnN0IGNoYXIgKmZpbGVu
YW1lKQp7CglzdHJ1Y3QgaW9fdXJpbmcgc3JpbmcsIGRyaW5nOwoJc3RydWN0IGlvX3VyaW5n
X3NxZSAqc3FlOwoJc3RydWN0IGlvX3VyaW5nX2NxZSAqY3FlOwoJaW50IHJldDsKCglyZXQg
PSBpb191cmluZ19xdWV1ZV9pbml0KDgsICZzcmluZywgMCk7CglpZiAocmV0KSB7CgkJZnBy
aW50ZihzdGRlcnIsICJyaW5nIHNldHVwIGZhaWxlZDogJWRcbiIsIHJldCk7CgkJcmV0dXJu
IDE7Cgl9CglyZXQgPSBpb191cmluZ19xdWV1ZV9pbml0KDgsICZkcmluZywgMCk7CglpZiAo
cmV0KSB7CgkJZnByaW50ZihzdGRlcnIsICJyaW5nIHNldHVwIGZhaWxlZDogJWRcbiIsIHJl
dCk7CgkJcmV0dXJuIDE7Cgl9CgoJcmV0ID0gaW9fdXJpbmdfcmVnaXN0ZXJfZmlsZXNfc3Bh
cnNlKCZzcmluZywgOCk7CglpZiAocmV0KSB7CgkJZnByaW50ZihzdGRlcnIsICJyZWdpc3Rl
ciBmaWxlcyBmYWlsZWQgJWRcbiIsIHJldCk7CgkJcmV0dXJuIDE7Cgl9CglyZXQgPSBpb191
cmluZ19yZWdpc3Rlcl9maWxlc19zcGFyc2UoJmRyaW5nLCA4KTsKCWlmIChyZXQpIHsKCQlm
cHJpbnRmKHN0ZGVyciwgInJlZ2lzdGVyIGZpbGVzIGZhaWxlZCAlZFxuIiwgcmV0KTsKCQly
ZXR1cm4gMTsKCX0KCgkvKiBvcGVuIGRpcmVjdCBkZXNjcmlwdG9yICovCglzcWUgPSBpb191
cmluZ19nZXRfc3FlKCZzcmluZyk7Cglpb191cmluZ19wcmVwX29wZW5hdF9kaXJlY3Qoc3Fl
LCBBVF9GRENXRCwgZmlsZW5hbWUsIDAsIDA2NDQsIDApOwoJaW9fdXJpbmdfc3VibWl0KCZz
cmluZyk7CglyZXQgPSBpb191cmluZ193YWl0X2NxZSgmc3JpbmcsICZjcWUpOwoJaWYgKHJl
dCkgewoJCWZwcmludGYoc3RkZXJyLCAid2FpdCBjcWUgZmFpbGVkICVkXG4iLCByZXQpOwoJ
CXJldHVybiAxOwoJfQoJaWYgKGNxZS0+cmVzKSB7CgkJZnByaW50ZihzdGRlcnIsICJjcWUg
cmVzICVkXG4iLCBjcWUtPnJlcyk7CgkJcmV0dXJuIDE7Cgl9Cglpb191cmluZ19jcWVfc2Vl
bigmc3JpbmcsIGNxZSk7CgoJLyogdmVyaWZ5IGRhdGEgaXMgc2FuZSBmb3Igc291cmNlIHJp
bmcgKi8KCWlmICh2ZXJpZnlfZml4ZWRfcmVhZCgmc3JpbmcsIDAsIDApKQoJCXJldHVybiAx
OwoKCS8qIHNlbmQgZGlyZWN0IGRlc2NyaXB0b3IgdG8gZGVzdGluYXRpb24gcmluZyAqLwoJ
c3FlID0gaW9fdXJpbmdfZ2V0X3NxZSgmc3JpbmcpOwoJaW9fdXJpbmdfcHJlcF9tc2dfcmlu
ZyhzcWUsIGRyaW5nLnJpbmdfZmQsIDAsIDB4ODksIDApOwoJc3FlLT5hZGRyID0gMTsKCXNx
ZS0+YWRkcjMgPSAwOwoJc3FlLT5maWxlX2luZGV4ID0gMTsKCWlvX3VyaW5nX3N1Ym1pdCgm
c3JpbmcpOwoKCXJldCA9IGlvX3VyaW5nX3dhaXRfY3FlKCZzcmluZywgJmNxZSk7CglpZiAo
cmV0KSB7CgkJZnByaW50ZihzdGRlcnIsICJ3YWl0IGNxZSBmYWlsZWQgJWRcbiIsIHJldCk7
CgkJcmV0dXJuIDE7Cgl9CglpZiAoY3FlLT5yZXMpIHsKCQlmcHJpbnRmKHN0ZGVyciwgIm1z
Z19yaW5nIGZhaWxlZCAlZFxuIiwgY3FlLT5yZXMpOwoJCXJldHVybiAxOwoJfQoJaW9fdXJp
bmdfY3FlX3NlZW4oJnNyaW5nLCBjcWUpOwoKCS8qIGdldCBwb3N0ZWQgY29tcGxldGlvbiBm
b3IgdGhlIHBhc3NpbmcgKi8KCXJldCA9IGlvX3VyaW5nX3dhaXRfY3FlKCZkcmluZywgJmNx
ZSk7CglpZiAocmV0KSB7CgkJZnByaW50ZihzdGRlcnIsICJ3YWl0IGNxZSBmYWlsZWQgJWRc
biIsIHJldCk7CgkJcmV0dXJuIDE7Cgl9CglpZiAoY3FlLT51c2VyX2RhdGEgIT0gMHg4OSkg
ewoJCWZwcmludGYoc3RkZXJyLCAiYmFkIHVzZXJfZGF0YSAlbGRcbiIsIChsb25nKSBjcWUt
PnJlcyk7CgkJcmV0dXJuIDE7Cgl9Cglpb191cmluZ19jcWVfc2VlbigmZHJpbmcsIGNxZSk7
CgoJLyogbm93IHZlcmlmeSB3ZSBjYW4gcmVhZCB0aGUgc2FuZSBkYXRhIGZyb20gdGhlIGRl
c3RpbmF0aW9uIHJpbmcgKi8KCWlmICh2ZXJpZnlfZml4ZWRfcmVhZCgmZHJpbmcsIDAsIDAp
KQoJCXJldHVybiAxOwoKCS8qIGNsb3NlIGRlc2NyaXB0b3IgaW4gc291cmNlIHJpbmcgKi8K
CXNxZSA9IGlvX3VyaW5nX2dldF9zcWUoJnNyaW5nKTsKCWlvX3VyaW5nX3ByZXBfY2xvc2Vf
ZGlyZWN0KHNxZSwgMCk7Cglpb191cmluZ19zdWJtaXQoJnNyaW5nKTsKCglyZXQgPSBpb191
cmluZ193YWl0X2NxZSgmc3JpbmcsICZjcWUpOwoJaWYgKHJldCkgewoJCWZwcmludGYoc3Rk
ZXJyLCAid2FpdCBjcWUgZmFpbGVkICVkXG4iLCByZXQpOwoJCXJldHVybiAxOwoJfQoJaWYg
KGNxZS0+cmVzKSB7CgkJZnByaW50ZihzdGRlcnIsICJkaXJlY3QgY2xvc2UgZmFpbGVkICVk
XG4iLCBjcWUtPnJlcyk7CgkJcmV0dXJuIDE7Cgl9Cglpb191cmluZ19jcWVfc2Vlbigmc3Jp
bmcsIGNxZSk7CgoJLyogY2hlY2sgdGhhdCBzb3VyY2UgcmluZyBmYWlscyBhZnRlciBjbG9z
ZSAqLwoJaWYgKHZlcmlmeV9maXhlZF9yZWFkKCZzcmluZywgMCwgMSkpCgkJcmV0dXJuIDE7
CgoJLyogY2hlY2sgd2UgY2FuIHN0aWxsIHJlYWQgZnJvbSBkZXN0aW5hdGlvbiByaW5nICov
CglpZiAodmVyaWZ5X2ZpeGVkX3JlYWQoJmRyaW5nLCAwLCAwKSkKCQlyZXR1cm4gMTsKCgly
ZXR1cm4gMDsKfQoKaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkKewoJY2hhciBm
bmFtZVs4MF07CglpbnQgcmV0OwoKCWlmIChhcmdjID4gMSkKCQlyZXR1cm4gMDsKCglzcHJp
bnRmKGZuYW1lLCAiLmZkLXBhc3MuJWQiLCBnZXRwaWQoKSk7Cgl0X2NyZWF0ZV9maWxlX3Bh
dHRlcm4oZm5hbWUsIEZTSVpFLCBQQVQpOwoKCXJldCA9IHRlc3QoZm5hbWUpOwoJaWYgKHJl
dCkgewoJCWZwcmludGYoc3RkZXJyLCAidGVzdCBmYWlsZWRcbiIpOwoJCXJldHVybiByZXQ7
Cgl9CgoJcmV0dXJuIDA7Cn0K

--------------K2hQYmX7hs0AWCqS6B90mC22--
