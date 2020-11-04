Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7042A67D7
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 16:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgKDPic (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 10:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730001AbgKDPib (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 10:38:31 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696B2C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 07:38:31 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id g7so19700648ilr.12
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 07:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language;
        bh=JPPTugsPvfD4kRhOYad78FzTFD4f1ltiv4KFF7h+Gs8=;
        b=D6uOHmYtgVdaZ0sR9rfva3UiYFvipqwKRTjelo/8lZaef4tCqC0/XEnueKzC9I7pGB
         9KZTYjQm+sLTUXfHBWXZ9GU220IamMBz1IpL1R/MlppIIe+t4W/U2IQtznT8FajdDQYY
         hEz5Wc1CLCgv3tHGxgDo5U9V4jHW1R7hFrotv/S4Qu1uNW4z2BAOMSc9MF+iR411RNlF
         GOirUOfB46YWSdNAsfQsxi70NBAuZZ4uREh+KhYuf7IU5AEpnAp5GrbxurR88HlXq+TU
         wHlaCAAXl1+QXlwBy5nJpMsRwRI/Fel6g9R7Ypk0OAZZGXaYrDSwlxNWBb0qksroOV2n
         zfFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=JPPTugsPvfD4kRhOYad78FzTFD4f1ltiv4KFF7h+Gs8=;
        b=avNGOJpBNvYic8KXBEspFnvX4MCxdwmXq698nTriwIK0FIngCaL+nMc+DNVLonlyi3
         Yby2aMcNkeRFaKIlXq2BbCNIj7qxFCaoJSlGsXBkWqGN30lFUC5UwLYyKbXEWPAOwSpd
         yPUwfJQAF/jcOt3Zh3BnfCgK7q5TdiSJwVGBlHm0PzEVqpardBxWy3POAJC4VaOEr6gD
         RZYRMkjYVufp6isCWAqaJmfS3kAmrzkyC+j/t2b8059sUAxjiueAamfR01PaTi3GX4a7
         81dHG140Ji5tl8EbRTxM/Gq9BHfvecv0zYkngqCbS7zRdpXwdHZdlWE30CDLpcpWlyFm
         NwZw==
X-Gm-Message-State: AOAM531dTOVaw+y7y00QbR7N2M9Cnl+8EObsLBZN+h56FQQ9XjuQ2t8a
        yOdT5mJhYOJx+qMPJrwsCYdbgntU+V0=
X-Google-Smtp-Source: ABdhPJw5d2QL2/ntVi9G++avqtQlNzmXDBcfjiOrJpzKZasTlhyOPneIeEnWFCYdy5p5TeXLCtLbng==
X-Received: by 2002:a92:c741:: with SMTP id y1mr20168625ilp.52.1604504310478;
        Wed, 04 Nov 2020 07:38:30 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:58d7:39e5:c2b2:c318])
        by smtp.googlemail.com with ESMTPSA id l65sm1787891ill.18.2020.11.04.07.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 07:38:29 -0800 (PST)
Subject: Re: io-uring and tcp sockets
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        io-uring@vger.kernel.org
References: <5324a8ca-bd5c-0599-d4d3-1e837338a7b5@gmail.com>
 <cd729952-d639-ec71-4567-d72c361fe023@samba.org>
 <f2f31220-3275-9201-0b58-a7bef4e2d51d@kernel.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fb72cffc-87f9-6072-3f3a-6648aacd310e@gmail.com>
Date:   Wed, 4 Nov 2020 08:38:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <f2f31220-3275-9201-0b58-a7bef4e2d51d@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------475203A9B2194DBC5750E961"
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------475203A9B2194DBC5750E961
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 11/4/20 7:50 AM, Jens Axboe wrote:
> On 11/4/20 4:21 AM, Stefan Metzmacher wrote:
>> Hi David,
>>
>>> New to io_uring but can't find this answer online, so reaching out.
>>>
>>> I was trying out io_uring with netperf - tcp stream sockets - and
>>> noticed a submission is called complete even with a partial send
>>> (io_send(), ret < sr->len). Saving the offset of what succeeded (plus
>>> some other adjustments) and retrying the sqe again solves the problem.
>>> But the issue seems fundamental so wondering if is intentional?
>>
>> I guess this is just the way it is currently.
>>
>> For Samba I'd also like to be sure to never get short write to a socket.
>>
>> There I'd like to keep the pipeline full by submitting as much sqe's as possible
>> (without waiting for completions on every single IORING_OP_SENDMSG/IORING_OP_SPLICE)
>> using IOSQE_IO_DRAIN or IOSQE_IO_LINK and maybe IOSQE_ASYNC or IORING_SETUP_SQPOLL.
>>
>> But for now I just used a single sqe with IOSQE_ASYNC at a time.
>>
>> Jens, do you see a way to overcome that limitation?
>>
>> As far as I understand the situation is completely fixed now and
>> it's no possible to get short reads and writes for file io anymore, is that correct?
> 
> Right, the regular file IO will not return short reads or writes, unless a
> blocking attempt returns 0 (or short). Which would be expected. The send/recvmsg
> side just returns what the socket read/write would return, similarly to if you
> did the normal system call variants of those calls.
> 
> It would not be impossible to make recvmsg/sendmsg handle this internally as
> well, we just need a good way to indicate the intent of "please satisfy the
> whole thing before return".
> 

Attached patch handles the full send request; sendmsg can be handled
similarly.

I take your comment to mean there should be an sq flag to opt-in to the
behavior change? Pointers to which flag set?

--------------475203A9B2194DBC5750E961
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-io_uring-Handle-incomplete-sends-for-stream-sockets.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-io_uring-Handle-incomplete-sends-for-stream-sockets.pat";
 filename*1="ch"

RnJvbSA5ZDZjYTI4MDUxMmQzYTUzOWM3NzE4NzlkODI2NDVhMGY3YjVhMjdkIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+
CkRhdGU6IE1vbiwgMiBOb3YgMjAyMCAxODozMTowMCAtMDcwMApTdWJqZWN0OiBbUEFUQ0hd
IGlvX3VyaW5nOiBIYW5kbGUgaW5jb21wbGV0ZSBzZW5kcyBmb3Igc3RyZWFtIHNvY2tldHMK
ClNpZ25lZC1vZmYtYnk6IERhdmlkIEFoZXJuIDxkc2FoZXJuQGdtYWlsLmNvbT4KLS0tCiBm
cy9pb191cmluZy5jIHwgMTkgKysrKysrKysrKysrKysrKystLQogMSBmaWxlIGNoYW5nZWQs
IDE3IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvaW9f
dXJpbmcuYyBiL2ZzL2lvX3VyaW5nLmMKaW5kZXggYWFlMGVmMmVjMzRkLi5kMTU1MTFkMWUy
ODQgMTAwNjQ0Ci0tLSBhL2ZzL2lvX3VyaW5nLmMKKysrIGIvZnMvaW9fdXJpbmcuYwpAQCAt
NDIxLDYgKzQyMSw3IEBAIHN0cnVjdCBpb19zcl9tc2cgewogCWludAkJCQltc2dfZmxhZ3M7
CiAJaW50CQkJCWJnaWQ7CiAJc2l6ZV90CQkJCWxlbjsKKwlzaXplX3QJCQkJb2Zmc2V0Owog
CXN0cnVjdCBpb19idWZmZXIJCSprYnVmOwogfTsKIApAQCAtNDE0OSw3ICs0MTUwLDggQEAg
c3RhdGljIGludCBpb19zZW5kKHN0cnVjdCBpb19raW9jYiAqcmVxLCBib29sIGZvcmNlX25v
bmJsb2NrLAogCWlmICh1bmxpa2VseSghc29jaykpCiAJCXJldHVybiByZXQ7CiAKLQlyZXQg
PSBpbXBvcnRfc2luZ2xlX3JhbmdlKFdSSVRFLCBzci0+YnVmLCBzci0+bGVuLCAmaW92LCAm
bXNnLm1zZ19pdGVyKTsKKwlyZXQgPSBpbXBvcnRfc2luZ2xlX3JhbmdlKFdSSVRFLCBzci0+
YnVmICsgc3ItPm9mZnNldCwgc3ItPmxlbiwgJmlvdiwKKwkJCQkgICZtc2cubXNnX2l0ZXIp
OwogCWlmICh1bmxpa2VseShyZXQpKQogCQlyZXR1cm4gcmV0OzsKIApAQCAtNDE3MSw4ICs0
MTczLDE4IEBAIHN0YXRpYyBpbnQgaW9fc2VuZChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgYm9v
bCBmb3JjZV9ub25ibG9jaywKIAlpZiAocmV0ID09IC1FUkVTVEFSVFNZUykKIAkJcmV0ID0g
LUVJTlRSOwogCi0JaWYgKHJldCA8IDApCisJaWYgKHJldCA8IDApIHsKIAkJcmVxX3NldF9m
YWlsX2xpbmtzKHJlcSk7CisJfSBlbHNlIGlmIChyZXQgPiAwICYmIHNvY2stPnR5cGUgPT0g
U09DS19TVFJFQU0pIHsKKwkJaWYgKHVubGlrZWx5KHJldCA8IHNyLT5sZW4pKSB7CisJCQlw
cl9kZWJ1ZygicmVxICVweCBzci0+b2Zmc2V0ICVsdSBzci0+bGVuICVsdSByZXQgJWRcbiIs
CisJCQkJIHJlcSwgc3ItPm9mZnNldCwgc3ItPmxlbiwgcmV0KTsKKwkJCXNyLT5sZW4gLT0g
cmV0OworCQkJc3ItPm9mZnNldCArPSByZXQ7CisJCQlyZXR1cm4gLUVBR0FJTjsKKwkJfQor
CQlyZXQgKz0gc3ItPm9mZnNldDsKKwl9CiAJX19pb19yZXFfY29tcGxldGUocmVxLCByZXQs
IDAsIGNzKTsKIAlyZXR1cm4gMDsKIH0KQEAgLTY0NjAsNiArNjQ3Miw5IEBAIHN0YXRpYyBp
bnQgaW9faW5pdF9yZXEoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIHN0cnVjdCBpb19raW9j
YiAqcmVxLAogCS8qIHNhbWUgbnVtZXJpY2FsIHZhbHVlcyB3aXRoIGNvcnJlc3BvbmRpbmcg
UkVRX0ZfKiwgc2FmZSB0byBjb3B5ICovCiAJcmVxLT5mbGFncyB8PSBzcWVfZmxhZ3M7CiAK
KwlpZiAocmVxLT5vcGNvZGUgPT0gSU9SSU5HX09QX1NFTkQgfHwgcmVxLT5vcGNvZGUgPT0g
SU9SSU5HX09QX1NFTkRNU0cpCisJCXJlcS0+c3JfbXNnLm9mZnNldCA9IDA7CisKIAlpZiAo
IWlvX29wX2RlZnNbcmVxLT5vcGNvZGVdLm5lZWRzX2ZpbGUpCiAJCXJldHVybiAwOwogCi0t
IAoyLjI1LjEKCg==
--------------475203A9B2194DBC5750E961--
