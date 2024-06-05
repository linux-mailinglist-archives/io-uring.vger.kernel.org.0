Return-Path: <io-uring+bounces-2104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D80E38FC307
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 07:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 653B61F21170
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 05:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8738C07;
	Wed,  5 Jun 2024 05:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=s.muenzel.net header.i=@s.muenzel.net header.b="ceGhlh77"
X-Original-To: io-uring@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A7762171
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 05:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717565249; cv=none; b=EDcNcA0X9TMcM9c+1G4n+UJh8CtL/mWuNL8dT0XL+a7o42AotmyDLXqRoiaDvpKmeXlGA2vPFJa979cOUGPxT9Y+COZYROCcYvFwQRr8GpAa/W9urgwx/xZY3c1UU3Yl54YfVza2Q9OEa2WHvLi7nqkpANL7xNmEIYxepGhsBU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717565249; c=relaxed/simple;
	bh=lUdXT4EJDwyLEOyQQYwaIlJR/WnTCbQVQ6FitFIjdIk=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:References:
	 From:In-Reply-To; b=KSDuxOUyveMY9Akuwj+dzA3eVc5Lw3iNkb1i9XYMqkGKTdzLKMGamqLX9unUYnF+Qvpk8BSRXQN+/nfrDwb8Y2dGlRLfqMwxP+B16AqhEiuPdXYQTV3K9U7Q31oC1vFh4qrh/pk5rDK19oFfQbHoVvac/ZypeG458GH/dKhaMns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=s.muenzel.net; spf=pass smtp.mailfrom=s.muenzel.net; dkim=pass (1024-bit key) header.d=s.muenzel.net header.i=@s.muenzel.net header.b=ceGhlh77; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=s.muenzel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=s.muenzel.net
X-Envelope-To: axboe@kernel.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s.muenzel.net;
	s=default; t=1717565241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fr2oooiX9HIo6N1auZF4belPhJceqqVdLR+t5eMXAV0=;
	b=ceGhlh77tsw5Awlr6x4WoSdKigvOHz6YDEIzfQF5henvbLBCs+5odExBRBZUyk3ui1eH/d
	6jj5cUDs08gMS45Sep4E/rDEqEemJ+igcjXGqe3p3XBBYTUDBjUOLxqDx06vKPN5iBEIka
	5vm5OSJeZbpdAqVYQn5jFF5fb3DGofQ=
X-Envelope-To: io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="------------7VXEky8tSqLP2K0dHE4epZRr"
Message-ID: <0817a90d-7c0b-4a70-85f0-06537dd8e54b@s.muenzel.net>
Date: Wed, 5 Jun 2024 07:25:16 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: madvise/fadvise 32-bit length
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
 <db4d32d6-cc71-4903-92cf-b1867b8c7d12@kernel.dk>
 <2d4d3434-401c-42c2-b450-40dec4689797@kernel.dk>
 <c9059b69-96d0-45e6-8d05-e44298d7548e@s.muenzel.net>
 <d6e2f493-87ca-4203-8d23-2ced10d47d02@kernel.dk>
 <8b08398d-a66d-42ad-a776-78b52d5231c4@s.muenzel.net>
 <c6c149ac-ce0e-4c21-b235-03b5d8250d86@kernel.dk>
 <b7fd035e-6ec2-4482-93e9-acb7436ca07e@s.muenzel.net>
 <70ac49de-f753-486f-b68e-60f08c652195@kernel.dk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Stefan <source@s.muenzel.net>
In-Reply-To: <70ac49de-f753-486f-b68e-60f08c652195@kernel.dk>
X-Migadu-Flow: FLOW_OUT

This is a multi-part message in MIME format.
--------------7VXEky8tSqLP2K0dHE4epZRr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/2024 16:49, Jens Axboe wrote:
> On 6/2/24 2:58 AM, Stefan wrote:
>> On 1/6/2024 20:33, Jens Axboe wrote:
>>> On 6/1/24 9:51 AM, Stefan wrote:
>>>> On 1/6/2024 17:35, Jens Axboe wrote:
>>>>> On 6/1/24 9:22 AM, Stefan wrote:
>>>>>> On 1/6/2024 17:05, Jens Axboe wrote:
>>>>>>> On 6/1/24 8:19 AM, Jens Axboe wrote:
>>>>>>>> On 6/1/24 3:43 AM, Stefan wrote:
>>>>>>>>> io_uring uses the __u32 len field in order to pass the length to
>>>>>>>>> madvise and fadvise, but these calls use an off_t, which is 64bit on
>>>>>>>>> 64bit platforms.
>>>>>>>>>
>>>>>>>>> When using liburing, the length is silently truncated to 32bits (so
>>>>>>>>> 8GB length would become zero, which has a different meaning of "until
>>>>>>>>> the end of the file" for fadvise).
>>>>>>>>>
>>>>>>>>> If my understanding is correct, we could fix this by introducing new
>>>>>>>>> operations MADVISE64 and FADVISE64, which use the addr3 field instead
>>>>>>>>> of the length field for length.
>>>>>>>>
>>>>>>>> We probably just want to introduce a flag and ensure that older stable
>>>>>>>> kernels check it, and then use a 64-bit field for it when the flag is
>>>>>>>> set.
>>>>>>>
>>>>>>> I think this should do it on the kernel side, as we already check these
>>>>>>> fields and return -EINVAL as needed. Should also be trivial to backport.
>>>>>>> Totally untested... Might want a FEAT flag for this, or something where
>>>>>>> it's detectable, to make the liburing change straight forward.
>>>>>>>
>>>>>>>
>>>>>>> diff --git a/io_uring/advise.c b/io_uring/advise.c
>>>>>>> index 7085804c513c..cb7b881665e5 100644
>>>>>>> --- a/io_uring/advise.c
>>>>>>> +++ b/io_uring/advise.c
>>>>>>> @@ -17,14 +17,14 @@
>>>>>>>      struct io_fadvise {
>>>>>>>          struct file            *file;
>>>>>>>          u64                offset;
>>>>>>> -    u32                len;
>>>>>>> +    u64                len;
>>>>>>>          u32                advice;
>>>>>>>      };
>>>>>>>        struct io_madvise {
>>>>>>>          struct file            *file;
>>>>>>>          u64                addr;
>>>>>>> -    u32                len;
>>>>>>> +    u64                len;
>>>>>>>          u32                advice;
>>>>>>>      };
>>>>>>>      @@ -33,11 +33,13 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>      #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
>>>>>>>          struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
>>>>>>>      -    if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
>>>>>>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>>>>>>              return -EINVAL;
>>>>>>>            ma->addr = READ_ONCE(sqe->addr);
>>>>>>> -    ma->len = READ_ONCE(sqe->len);
>>>>>>> +    ma->len = READ_ONCE(sqe->off);
>>>>>>> +    if (!ma->len)
>>>>>>> +        ma->len = READ_ONCE(sqe->len);
>>>>>>>          ma->advice = READ_ONCE(sqe->fadvise_advice);
>>>>>>>          req->flags |= REQ_F_FORCE_ASYNC;
>>>>>>>          return 0;
>>>>>>> @@ -78,11 +80,13 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>      {
>>>>>>>          struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
>>>>>>>      -    if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
>>>>>>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>>>>>>              return -EINVAL;
>>>>>>>            fa->offset = READ_ONCE(sqe->off);
>>>>>>> -    fa->len = READ_ONCE(sqe->len);
>>>>>>> +    fa->len = READ_ONCE(sqe->addr);
>>>>>>> +    if (!fa->len)
>>>>>>> +        fa->len = READ_ONCE(sqe->len);
>>>>>>>          fa->advice = READ_ONCE(sqe->fadvise_advice);
>>>>>>>          if (io_fadvise_force_async(fa))
>>>>>>>              req->flags |= REQ_F_FORCE_ASYNC;
>>>>>>>
>>>>>>
>>>>>>
>>>>>> If we want to have the length in the same field in both *ADVISE
>>>>>> operations, we can put a flag in splice_fd_in/optlen.
>>>>>
>>>>> I don't think that part matters that much.
>>>>>
>>>>>> Maybe the explicit flag is a bit clearer for users of the API
>>>>>> compared to the implicit flag when setting sqe->len to zero?
>>>>>
>>>>> We could go either way. The unused fields returning -EINVAL if set right
>>>>> now can serve as the flag field - if you have it set, then that is your
>>>>> length. If not, then the old style is the length. That's the approach I
>>>>> took, rather than add an explicit flag to it. Existing users that would
>>>>> set the 64-bit length fields would get -EINVAL already. And since the
>>>>> normal flags field is already used for advice flags, I'd prefer just
>>>>> using the existing 64-bit zero fields for it rather than add a flag in
>>>>> an odd location. Would also make for an easier backport to stable.
>>>>>
>>>>> But don't feel that strongly about that part.
>>>>>
>>>>> Attached kernel patch with FEAT added, and liburing patch with 64
>>>>> versions added.
>>>>>
>>>>
>>>> Sounds good!
>>>> Do we want to do anything about the current (32-bit) functions in
>>>> liburing? They silently truncate the user's values, so either marking
>>>> them deprecated or changing the type of length in the arguments to a
>>>> __u32 could help.
>>>
>>> I like changing it to an __u32, and then we'll add a note to the man
>>> page for them as well (with references to the 64-bit variants).
>>>
>>> I still need to write a test and actually test the patches, but I'll get
>>> to that Monday. If you want to write a test case that checks the 64-bit
>>> range, then please do!
>>>
>>
>> Maybe something like the following for madvise?
>> Create an 8GB file initialized with 0xaa, punch a (8GB - page_size)
>> hole using MADV_REMOVE, and check the contents. It requires support
>> for FALLOC_FL_PUNCH_HOLE in the filesystem.
> 
> I think that looks very reasonable, and it's better than the DONTNEED
> and timings, it was always a pretty shitty test. We just need to ensure
> that we return T_EXIT_SKIP if the fs it's being run on doesn't support
> punching holes.
> 
> FWIW, I did put the liburing changes in an 'advise' branch, so you could
> generate a patch against that. Once we're happy with it, it can get
> pulled into master.
> 

Here's the patch against your branch.

--------------7VXEky8tSqLP2K0dHE4epZRr
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-Change-madvise-test-to-use-MADV_REMOVE.patch"
Content-Disposition: attachment;
 filename="0001-Change-madvise-test-to-use-MADV_REMOVE.patch"
Content-Transfer-Encoding: base64

RnJvbSAxNTcwY2ZkYzQ5NGM5ZjM4YmFjODRmN2ZjODM3ZjY5Zjk5ODg4YWMwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmYW4gTXVlbnplbCA8c291cmNlQHMubXVlbnpl
bC5uZXQ+CkRhdGU6IE1vbiwgMyBKdW4gMjAyNCAxODo0MDoyNyArMDIwMApTdWJqZWN0OiBb
UEFUQ0hdIENoYW5nZSBtYWR2aXNlIHRlc3QgdG8gdXNlIE1BRFZfUkVNT1ZFCgpDcmVhdGUg
YW4gOEdCIGZpbGUgaW5pdGlhbGl6ZWQgd2l0aCAweGFhLCBwdW5jaCBhICg4R0IgLSBwYWdl
X3NpemUpCmhvbGUgdXNpbmcgTUFEVl9SRU1PVkUsIGFuZCBjaGVjayB0aGUgY29udGVudHMu
ClJlcXVpcmVzIHN1cHBvcnQgZm9yIEZBTExPQ19GTF9QVU5DSF9IT0xFIGluIHRoZSBmaWxl
c3lzdGVtLCB3aGljaAppcyBjaGVja2VkIGZvcgoKU2lnbmVkLW9mZi1ieTogU3RlZmFuIE11
ZW56ZWwgPHNvdXJjZUBzLm11ZW56ZWwubmV0PgotLS0KIHRlc3QvaGVscGVycy5jIHwgIDM5
ICsrKysrKysrKy0tLS0tLQogdGVzdC9tYWR2aXNlLmMgfCAxMzEgKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCA2
NCBpbnNlcnRpb25zKCspLCAxMDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvdGVzdC9o
ZWxwZXJzLmMgYi90ZXN0L2hlbHBlcnMuYwppbmRleCA3NzkzNDdmLi5mZjUyNzNkIDEwMDY0
NAotLS0gYS90ZXN0L2hlbHBlcnMuYworKysgYi90ZXN0L2hlbHBlcnMuYwpAQCAtNzYsOCAr
NzYsOSBAQCB2b2lkICp0X2NhbGxvYyhzaXplX3Qgbm1lbWIsIHNpemVfdCBzaXplKQogICov
CiBzdGF0aWMgdm9pZCBfX3RfY3JlYXRlX2ZpbGUoY29uc3QgY2hhciAqZmlsZSwgc2l6ZV90
IHNpemUsIGNoYXIgcGF0dGVybikKIHsKLQlzc2l6ZV90IHJldDsKLQljaGFyICpidWY7CisJ
c3NpemVfdCByZXQgPSAwOworCXNpemVfdCBzaXplX3JlbWFpbmluZzsKKwljaGFyICpidWYs
ICpidWZfbG9jOwogCWludCBmZDsKIAogCWJ1ZiA9IHRfbWFsbG9jKHNpemUpOwpAQCAtODYs
MTEgKzg3LDE5IEBAIHN0YXRpYyB2b2lkIF9fdF9jcmVhdGVfZmlsZShjb25zdCBjaGFyICpm
aWxlLCBzaXplX3Qgc2l6ZSwgY2hhciBwYXR0ZXJuKQogCWZkID0gb3BlbihmaWxlLCBPX1dS
T05MWSB8IE9fQ1JFQVQsIDA2NDQpOwogCWFzc2VydChmZCA+PSAwKTsKIAotCXJldCA9IHdy
aXRlKGZkLCBidWYsIHNpemUpOworCXNpemVfcmVtYWluaW5nID0gc2l6ZTsKKwlidWZfbG9j
ID0gYnVmOworCXdoaWxlIChzaXplX3JlbWFpbmluZyA+IDApIHsKKwkJcmV0ID0gd3JpdGUo
ZmQsIGJ1Zl9sb2MsIHNpemVfcmVtYWluaW5nKTsKKwkJaWYgKHJldCA8PSAwKQorCQkJYnJl
YWs7CisJCXNpemVfcmVtYWluaW5nIC09IHJldDsKKwkJYnVmX2xvYyArPSByZXQ7CisJfQog
CWZzeW5jKGZkKTsKIAljbG9zZShmZCk7CiAJZnJlZShidWYpOwotCWFzc2VydChyZXQgPT0g
c2l6ZSk7CisJYXNzZXJ0KHNpemVfcmVtYWluaW5nID09IDApOwogfQogCiB2b2lkIHRfY3Jl
YXRlX2ZpbGUoY29uc3QgY2hhciAqZmlsZSwgc2l6ZV90IHNpemUpCkBAIC0yNjQsNyArMjcz
LDcgQEAgYm9vbCB0X3Byb2JlX2RlZmVyX3Rhc2tydW4odm9pZCkKIAlpbnQgcmV0OwogCiAJ
cmV0ID0gaW9fdXJpbmdfcXVldWVfaW5pdCgxLCAmcmluZywgSU9SSU5HX1NFVFVQX1NJTkdM
RV9JU1NVRVIgfAotCQkJCQkgICAgSU9SSU5HX1NFVFVQX0RFRkVSX1RBU0tSVU4pOworCQkJ
CSAgSU9SSU5HX1NFVFVQX0RFRkVSX1RBU0tSVU4pOwogCWlmIChyZXQgPCAwKQogCQlyZXR1
cm4gZmFsc2U7CiAJaW9fdXJpbmdfcXVldWVfZXhpdCgmcmluZyk7CkBAIC0yOTEsMTIgKzMw
MCwxMiBAQCB1bnNpZ25lZCBfX2lvX3VyaW5nX2ZsdXNoX3NxKHN0cnVjdCBpb191cmluZyAq
cmluZykKIAkJCWlvX3VyaW5nX3NtcF9zdG9yZV9yZWxlYXNlKHNxLT5rdGFpbCwgdGFpbCk7
CiAJfQogCS8qCi0JKiBUaGlzIGxvYWQgbmVlZHMgdG8gYmUgYXRvbWljLCBzaW5jZSBzcS0+
a2hlYWQgaXMgd3JpdHRlbiBjb25jdXJyZW50bHkKLQkqIGJ5IHRoZSBrZXJuZWwsIGJ1dCBp
dCBkb2Vzbid0IG5lZWQgdG8gYmUgbG9hZF9hY3F1aXJlLCBzaW5jZSB0aGUKLQkqIGtlcm5l
bCBkb2Vzbid0IHN0b3JlIHRvIHRoZSBzdWJtaXNzaW9uIHF1ZXVlOyBpdCBhZHZhbmNlcyBr
aGVhZCBqdXN0Ci0JKiB0byBpbmRpY2F0ZSB0aGF0IGl0J3MgZmluaXNoZWQgcmVhZGluZyB0
aGUgc3VibWlzc2lvbiBxdWV1ZSBlbnRyaWVzCi0JKiBzbyB0aGV5J3JlIGF2YWlsYWJsZSBm
b3IgdXMgdG8gd3JpdGUgdG8uCi0JKi8KKwkgKiBUaGlzIGxvYWQgbmVlZHMgdG8gYmUgYXRv
bWljLCBzaW5jZSBzcS0+a2hlYWQgaXMgd3JpdHRlbiBjb25jdXJyZW50bHkKKwkgKiBieSB0
aGUga2VybmVsLCBidXQgaXQgZG9lc24ndCBuZWVkIHRvIGJlIGxvYWRfYWNxdWlyZSwgc2lu
Y2UgdGhlCisJICoga2VybmVsIGRvZXNuJ3Qgc3RvcmUgdG8gdGhlIHN1Ym1pc3Npb24gcXVl
dWU7IGl0IGFkdmFuY2VzIGtoZWFkIGp1c3QKKwkgKiB0byBpbmRpY2F0ZSB0aGF0IGl0J3Mg
ZmluaXNoZWQgcmVhZGluZyB0aGUgc3VibWlzc2lvbiBxdWV1ZSBlbnRyaWVzCisJICogc28g
dGhleSdyZSBhdmFpbGFibGUgZm9yIHVzIHRvIHdyaXRlIHRvLgorCSAqLwogCXJldHVybiB0
YWlsIC0gSU9fVVJJTkdfUkVBRF9PTkNFKCpzcS0+a2hlYWQpOwogfQogCkBAIC0zMDYsMTMg
KzMxNSwxMyBAQCB1bnNpZ25lZCBfX2lvX3VyaW5nX2ZsdXNoX3NxKHN0cnVjdCBpb191cmlu
ZyAqcmluZykKIHZvaWQgdF9lcnJvcihpbnQgc3RhdHVzLCBpbnQgZXJybnVtLCBjb25zdCBj
aGFyICpmb3JtYXQsIC4uLikKIHsKIAl2YV9saXN0IGFyZ3M7Ci0gICAgCXZhX3N0YXJ0KGFy
Z3MsIGZvcm1hdCk7CisJdmFfc3RhcnQoYXJncywgZm9ybWF0KTsKIAogCXZmcHJpbnRmKHN0
ZGVyciwgZm9ybWF0LCBhcmdzKTsKLSAgICAJaWYgKGVycm51bSkKLSAgICAgICAgCWZwcmlu
dGYoc3RkZXJyLCAiOiAlcyIsIHN0cmVycm9yKGVycm51bSkpOworCWlmIChlcnJudW0pCisJ
CWZwcmludGYoc3RkZXJyLCAiOiAlcyIsIHN0cmVycm9yKGVycm51bSkpOwogCiAJZnByaW50
ZihzdGRlcnIsICJcbiIpOwogCXZhX2VuZChhcmdzKTsKLSAgICAJZXhpdChzdGF0dXMpOwor
CWV4aXQoc3RhdHVzKTsKIH0KZGlmZiAtLWdpdCBhL3Rlc3QvbWFkdmlzZS5jIGIvdGVzdC9t
YWR2aXNlLmMKaW5kZXggNzkzOGVjNC4uY2Y1Y2Y0YyAxMDA2NDQKLS0tIGEvdGVzdC9tYWR2
aXNlLmMKKysrIGIvdGVzdC9tYWR2aXNlLmMKQEAgLTE1LDM0ICsxNSw3IEBACiAjaW5jbHVk
ZSAiaGVscGVycy5oIgogI2luY2x1ZGUgImxpYnVyaW5nLmgiCiAKLSNkZWZpbmUgRklMRV9T
SVpFCSgxMjggKiAxMDI0KQotCi0jZGVmaW5lIExPT1BTCQkxMDAKLSNkZWZpbmUgTUlOX0xP
T1BTCTEwCi0KLXN0YXRpYyB1bnNpZ25lZCBsb25nIGxvbmcgdXRpbWVfc2luY2UoY29uc3Qg
c3RydWN0IHRpbWV2YWwgKnMsCi0JCQkJICAgICAgY29uc3Qgc3RydWN0IHRpbWV2YWwgKmUp
Ci17Ci0JbG9uZyBsb25nIHNlYywgdXNlYzsKLQotCXNlYyA9IGUtPnR2X3NlYyAtIHMtPnR2
X3NlYzsKLQl1c2VjID0gKGUtPnR2X3VzZWMgLSBzLT50dl91c2VjKTsKLQlpZiAoc2VjID4g
MCAmJiB1c2VjIDwgMCkgewotCQlzZWMtLTsKLQkJdXNlYyArPSAxMDAwMDAwOwotCX0KLQot
CXNlYyAqPSAxMDAwMDAwOwotCXJldHVybiBzZWMgKyB1c2VjOwotfQotCi1zdGF0aWMgdW5z
aWduZWQgbG9uZyBsb25nIHV0aW1lX3NpbmNlX25vdyhzdHJ1Y3QgdGltZXZhbCAqdHYpCi17
Ci0Jc3RydWN0IHRpbWV2YWwgZW5kOwotCi0JZ2V0dGltZW9mZGF5KCZlbmQsIE5VTEwpOwot
CXJldHVybiB1dGltZV9zaW5jZSh0diwgJmVuZCk7Ci19CisjZGVmaW5lIEZJTEVfU0laRSAg
ICAoOFVMTCAqIDEwMjRVTEwgKiAxMDI0VUxMICogMTAyNFVMTCkKIAogc3RhdGljIGludCBk
b19tYWR2aXNlKHN0cnVjdCBpb191cmluZyAqcmluZywgdm9pZCAqYWRkciwgb2ZmX3QgbGVu
LCBpbnQgYWR2aWNlKQogewpAQCAtNzYsODMgKzQ5LDY4IEBAIHN0YXRpYyBpbnQgZG9fbWFk
dmlzZShzdHJ1Y3QgaW9fdXJpbmcgKnJpbmcsIHZvaWQgKmFkZHIsIG9mZl90IGxlbiwgaW50
IGFkdmljZSkKIAkJdW5saW5rKCIubWFkdmlzZS50bXAiKTsKIAkJZXhpdCgwKTsKIAl9IGVs
c2UgaWYgKHJldCkgewotCQlmcHJpbnRmKHN0ZGVyciwgImNxZS0+cmVzPSVkXG4iLCBjcWUt
PnJlcyk7CisJCWZwcmludGYoc3RkZXJyLCAiY3FlLT5yZXM9JWQgKCVzKVxuIiwgY3FlLT5y
ZXMsCisJCQlzdHJlcnJvcigtY3FlLT5yZXMpKTsKIAl9CiAJaW9fdXJpbmdfY3FlX3NlZW4o
cmluZywgY3FlKTsKIAlyZXR1cm4gcmV0OwogfQogCi1zdGF0aWMgbG9uZyBkb19jb3B5KGlu
dCBmZCwgY2hhciAqYnVmLCB2b2lkICpwdHIpCi17Ci0Jc3RydWN0IHRpbWV2YWwgdHY7Ci0K
LQlnZXR0aW1lb2ZkYXkoJnR2LCBOVUxMKTsKLQltZW1jcHkoYnVmLCBwdHIsIEZJTEVfU0la
RSk7Ci0JcmV0dXJuIHV0aW1lX3NpbmNlX25vdygmdHYpOwotfQotCiBzdGF0aWMgaW50IHRl
c3RfbWFkdmlzZShzdHJ1Y3QgaW9fdXJpbmcgKnJpbmcsIGNvbnN0IGNoYXIgKmZpbGVuYW1l
KQogewotCXVuc2lnbmVkIGxvbmcgY2FjaGVkX3JlYWQsIHVuY2FjaGVkX3JlYWQsIGNhY2hl
ZF9yZWFkMjsKKwlzaXplX3QgcGFnZV9zaXplOworCXVuc2lnbmVkIGNoYXIgY29udGVudHM7
CiAJaW50IGZkLCByZXQ7Ci0JY2hhciAqYnVmOwotCXZvaWQgKnB0cjsKKwl1bnNpZ25lZCBj
aGFyICpwdHI7CiAKLQlmZCA9IG9wZW4oZmlsZW5hbWUsIE9fUkRPTkxZKTsKKwlwYWdlX3Np
emUgPSBzeXNjb25mKF9TQ19QQUdFX1NJWkUpOworCisJZmQgPSBvcGVuKGZpbGVuYW1lLCBP
X1JEV1IpOwogCWlmIChmZCA8IDApIHsKIAkJcGVycm9yKCJvcGVuIik7CiAJCXJldHVybiAx
OwogCX0KIAotCWJ1ZiA9IHRfbWFsbG9jKEZJTEVfU0laRSk7CisJcmV0ID0KKwkgICAgZmFs
bG9jYXRlKGZkLCBGQUxMT0NfRkxfUFVOQ0hfSE9MRSB8IEZBTExPQ19GTF9LRUVQX1NJWkUs
IHBhZ2Vfc2l6ZSwKKwkJICAgICAgcGFnZV9zaXplKTsKKwlpZiAocmV0ID09IC0xICYmIGVy
cm5vID09IEVPUE5PVFNVUFApCisJCXJldHVybiAzOwogCi0JcHRyID0gbW1hcChOVUxMLCBG
SUxFX1NJWkUsIFBST1RfUkVBRCwgTUFQX1BSSVZBVEUsIGZkLCAwKTsKKwlwdHIgPSBtbWFw
KE5VTEwsIEZJTEVfU0laRSwgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwgTUFQX1NIQVJFRCwg
ZmQsIDApOwogCWlmIChwdHIgPT0gTUFQX0ZBSUxFRCkgewogCQlwZXJyb3IoIm1tYXAiKTsK
IAkJcmV0dXJuIDE7CiAJfQogCi0JY2FjaGVkX3JlYWQgPSBkb19jb3B5KGZkLCBidWYsIHB0
cik7Ci0JaWYgKGNhY2hlZF9yZWFkID09IC0xKQotCQlyZXR1cm4gMTsKLQotCWNhY2hlZF9y
ZWFkID0gZG9fY29weShmZCwgYnVmLCBwdHIpOwotCWlmIChjYWNoZWRfcmVhZCA9PSAtMSkK
LQkJcmV0dXJuIDE7Ci0KLQlyZXQgPSBkb19tYWR2aXNlKHJpbmcsIHB0ciwgRklMRV9TSVpF
LCBNQURWX0RPTlRORUVEKTsKKwlyZXQgPQorCSAgICBkb19tYWR2aXNlKHJpbmcsIHB0ciAr
IDIgKiBwYWdlX3NpemUsIEZJTEVfU0laRSAtIHBhZ2Vfc2l6ZSwKKwkJICAgICAgIE1BRFZf
UkVNT1ZFKTsKIAlpZiAocmV0KQogCQlyZXR1cm4gMTsKIAotCXVuY2FjaGVkX3JlYWQgPSBk
b19jb3B5KGZkLCBidWYsIHB0cik7Ci0JaWYgKHVuY2FjaGVkX3JlYWQgPT0gLTEpCi0JCXJl
dHVybiAxOwotCi0JcmV0ID0gZG9fbWFkdmlzZShyaW5nLCBwdHIsIEZJTEVfU0laRSwgTUFE
Vl9ET05UTkVFRCk7Ci0JaWYgKHJldCkKLQkJcmV0dXJuIDE7Ci0KLQlyZXQgPSBkb19tYWR2
aXNlKHJpbmcsIHB0ciwgRklMRV9TSVpFLCBNQURWX1dJTExORUVEKTsKLQlpZiAocmV0KQot
CQlyZXR1cm4gMTsKLQotCW1zeW5jKHB0ciwgRklMRV9TSVpFLCBNU19TWU5DKTsKLQotCWNh
Y2hlZF9yZWFkMiA9IGRvX2NvcHkoZmQsIGJ1ZiwgcHRyKTsKLQlpZiAoY2FjaGVkX3JlYWQy
ID09IC0xKQotCQlyZXR1cm4gMTsKLQotCWlmIChjYWNoZWRfcmVhZCA8IHVuY2FjaGVkX3Jl
YWQgJiYKLQkgICAgY2FjaGVkX3JlYWQyIDwgdW5jYWNoZWRfcmVhZCkKLQkJcmV0dXJuIDA7
CisJZm9yIChzaXplX3QgaSA9IDA7IGkgPCBGSUxFX1NJWkU7IGkrKykgeworCQljb250ZW50
cyA9IHB0cltpXTsKKwkJaWYgKGNvbnRlbnRzICYmIGkgPiBwYWdlX3NpemUpIHsKKwkJCWZw
cmludGYoc3RkZXJyLAorCQkJCSJJbiByZW1vdmVkIHBhZ2UgYXQgJWx1IGJ1dCBjb250ZW50
cz0leFxuIiwgaSwKKwkJCQljb250ZW50cyk7CisJCQlyZXR1cm4gMjsKKwkJfSBlbHNlIGlm
IChjb250ZW50cyAhPSAweGFhICYmIGkgPCBwYWdlX3NpemUpIHsKKwkJCWZwcmludGYoc3Rk
ZXJyLAorCQkJCSJJbiBub24tcmVtb3ZlZCBwYWdlIGF0ICVsdSBidXQgY29udGVudHM9JXhc
biIsCisJCQkJaSwgY29udGVudHMpOworCQkJcmV0dXJuIDI7CisJCX0KKwl9CiAKLQlyZXR1
cm4gMjsKKwlyZXR1cm4gMDsKIH0KIAogaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3Zb
XSkKIHsKIAlzdHJ1Y3QgaW9fdXJpbmcgcmluZzsKLQlpbnQgcmV0LCBpLCBnb29kLCBiYWQ7
CisJaW50IHJldCA9IDA7CiAJY2hhciAqZm5hbWU7CiAKIAlpZiAoYXJnYyA+IDEpIHsKQEAg
LTE2NywyMyArMTI1LDEyIEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pCiAJ
CWdvdG8gZXJyOwogCX0KIAotCWdvb2QgPSBiYWQgPSAwOwotCWZvciAoaSA9IDA7IGkgPCBM
T09QUzsgaSsrKSB7Ci0JCXJldCA9IHRlc3RfbWFkdmlzZSgmcmluZywgZm5hbWUpOwotCQlp
ZiAocmV0ID09IDEpIHsKLQkJCWZwcmludGYoc3RkZXJyLCAidGVzdF9tYWR2aXNlIGZhaWxl
ZFxuIik7Ci0JCQlnb3RvIGVycjsKLQkJfSBlbHNlIGlmICghcmV0KQotCQkJZ29vZCsrOwot
CQllbHNlIGlmIChyZXQgPT0gMikKLQkJCWJhZCsrOwotCQlpZiAoaSA+PSBNSU5fTE9PUFMg
JiYgIWJhZCkKLQkJCWJyZWFrOworCXJldCA9IHRlc3RfbWFkdmlzZSgmcmluZywgZm5hbWUp
OworCWlmIChyZXQpIHsKKwkJZnByaW50ZihzdGRlcnIsICJ0ZXN0X21hZHZpc2UgZmFpbGVk
XG4iKTsKKwkJZ290byBlcnI7CiAJfQogCi0JLyogdG9vIGhhcmQgdG8gcmVsaWFibHkgdGVz
dCwganVzdCBpZ25vcmUgKi8KLQlpZiAoKDApICYmIGJhZCA+IGdvb2QpCi0JCWZwcmludGYo
c3RkZXJyLCAiU3VzcGljaW91cyB0aW1pbmdzICgldSA+ICV1KVxuIiwgYmFkLCBnb29kKTsK
IAlpZiAoZm5hbWUgIT0gYXJndlsxXSkKIAkJdW5saW5rKGZuYW1lKTsKIAlpb191cmluZ19x
dWV1ZV9leGl0KCZyaW5nKTsKQEAgLTE5MSw1ICsxMzgsNyBAQCBpbnQgbWFpbihpbnQgYXJn
YywgY2hhciAqYXJndltdKQogZXJyOgogCWlmIChmbmFtZSAhPSBhcmd2WzFdKQogCQl1bmxp
bmsoZm5hbWUpOworCWlmIChyZXQgPT0gMykKKwkJcmV0dXJuIFRfRVhJVF9TS0lQOwogCXJl
dHVybiBUX0VYSVRfRkFJTDsKIH0KLS0gCjIuNDUuMQoK

--------------7VXEky8tSqLP2K0dHE4epZRr--

