Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9905ABA02
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 23:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiIBVZi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 17:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIBVZi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 17:25:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A67558FB
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 14:25:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so6646508pja.4
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 14:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:references:cc:to:from:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=asJc5rCyP7lkCMwLG7QzVbqD4pLGOaufzlyyvveWhHc=;
        b=Wx8mD2wBWJAd/HY8clRaVqTwImHMvsnCMwT5Ww0ObgNU6iAbMdQfhKtMqaIiFOwQSt
         x753E1b38zNG1FOO0qCHrCt8gOJ3btlfvJwryHAtSDPQBydfXhL9eqhKdbD2FKUfdkmf
         fTWzNiOJLAS8g5rL2bbswFUjMowsRNNy2+aN1Wx1iH3czmCwq/uyc9vDAsOM15jwIf38
         JgeWSqYx4dEWLUcVHv8kS1eMhZ6Jv4FNpDLzDw+WujB4xQrELz6uVGujOs29f/FED3Qb
         tbS+BJVL94nqZWNCkACitmBhbqMlDdSO+Ncwd9/FDtzsiQRThl5d/sdE3pTBbXKcCdPP
         rVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:cc:to:from:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=asJc5rCyP7lkCMwLG7QzVbqD4pLGOaufzlyyvveWhHc=;
        b=M7MdvwIxgGIIyCtnHHmpPaPiPIxBQIoqosZ9FGJ7vnIIMqUAxFbxhEhGkedExtCXPu
         RkBNfpjTWQRrvkFSYT9CCXcQiZh+mJxiY/7TQQOd6plVRjWyBgPLqg3YLXlsLp4TiJfs
         8MD5L108WAFF1HDGS07lqnCmeA4mUGL1Rwr7b5puqfVn3zvG4cnvQyHTtipU2TGVQgp9
         3f8hP5GVypmxe0ENCTz6VOiRUA/EvDUg+IBI1A7n1Nd57eB7gtmDiZgtpqIzZN9cxxIg
         M+7fjWz+DhDp4S0f+sszYsV4IuzZO9QaUgWPCCDptKPtJfck1ZKIsg3uWX+uqGSRGWzb
         M1zw==
X-Gm-Message-State: ACgBeo0o0kfjsdPYZkvK1yTKCuYuYIkonmD48hjrMi77Iet6SJVZBpWw
        nzuHyRo8frb9eGtwWWF6eOfUTg==
X-Google-Smtp-Source: AA6agR505lcQSlqjDAs9FB8XnfhxdgqlD2/rUdW/L25ZTi1Bhi/UpJNKgl6MHaBYy4r00lz+JqPnUQ==
X-Received: by 2002:a17:90b:4a05:b0:1fe:289a:3ce1 with SMTP id kk5-20020a17090b4a0500b001fe289a3ce1mr6760308pjb.96.1662153935198;
        Fri, 02 Sep 2022 14:25:35 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h68-20020a625347000000b00537d0ed05ecsm2251924pfb.216.2022.09.02.14.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 14:25:34 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------bhhJg1e88Tg5uomucVsnEzQ9"
Message-ID: <c62c977d-9e81-c84c-e17c-e057295c071e@kernel.dk>
Date:   Fri, 2 Sep 2022 15:25:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH for-next v3 0/4] fixed-buffer for uring-cmd/passthrough
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
References: <CGME20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf@epcas5p1.samsung.com>
 <20220902151657.10766-1-joshi.k@samsung.com>
 <f1e8a7fa-a1f8-c60a-c365-b2164421f98d@kernel.dk>
 <2b4a935c-a6b1-6e42-ceca-35a8f09d8f46@kernel.dk>
 <20220902184608.GA6902@test-zns>
 <48856ca4-5158-154e-a1f5-124aadc9780f@kernel.dk>
In-Reply-To: <48856ca4-5158-154e-a1f5-124aadc9780f@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------bhhJg1e88Tg5uomucVsnEzQ9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/2/22 1:32 PM, Jens Axboe wrote:
> On 9/2/22 12:46 PM, Kanchan Joshi wrote:
>> On Fri, Sep 02, 2022 at 10:32:16AM -0600, Jens Axboe wrote:
>>> On 9/2/22 10:06 AM, Jens Axboe wrote:
>>>> On 9/2/22 9:16 AM, Kanchan Joshi wrote:
>>>>> Hi,
>>>>>
>>>>> Currently uring-cmd lacks the ability to leverage the pre-registered
>>>>> buffers. This series adds the support in uring-cmd, and plumbs
>>>>> nvme passthrough to work with it.
>>>>>
>>>>> Using registered-buffers showed peak-perf hike from 1.85M to 2.17M IOPS
>>>>> in my setup.
>>>>>
>>>>> Without fixedbufs
>>>>> *****************
>>>>> # taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
>>>>> submitter=0, tid=5256, file=/dev/ng0n1, node=-1
>>>>> polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
>>>>> Engine=io_uring, sq_ring=128, cq_ring=128
>>>>> IOPS=1.85M, BW=904MiB/s, IOS/call=32/31
>>>>> IOPS=1.85M, BW=903MiB/s, IOS/call=32/32
>>>>> IOPS=1.85M, BW=902MiB/s, IOS/call=32/32
>>>>> ^CExiting on signal
>>>>> Maximum IOPS=1.85M
>>>>
>>>> With the poll support queued up, I ran this one as well. tldr is:
>>>>
>>>> bdev (non pt)??? 122M IOPS
>>>> irq driven??? 51-52M IOPS
>>>> polled??????? 71M IOPS
>>>> polled+fixed??? 78M IOPS
>>
>> except first one, rest three entries are for passthru? somehow I didn't
>> see that big of a gap. I will try to align my setup in coming days.
> 
> Right, sorry it was badly labeled. First one is bdev with polling,
> registered buffers, etc. The others are all the passthrough mode. polled
> goes to 74M with the caching fix, so it's about a 74M -> 82M bump using
> registered buffers with passthrough and polling.
> 
>>> polled+fixed??? 82M
>>>
>>> I suspect the remainder is due to the lack of batching on the request
>>> freeing side, at least some of it. Haven't really looked deeper yet.
>>>
>>> One issue I saw - try and use passthrough polling without having any
>>> poll queues defined and it'll stall just spinning on completions. You
>>> need to ensure that these are processed as well - look at how the
>>> non-passthrough io_uring poll path handles it.
>>
>> Had tested this earlier, and it used to run fine. And it does not now.
>> I see that io are getting completed, irq-completion is arriving in nvme
>> and it is triggering task-work based completion (by calling
>> io_uring_cmd_complete_in_task). But task-work never got called and
>> therefore no completion happened.
>>
>> io_uring_cmd_complete_in_task -> io_req_task_work_add -> __io_req_task_work_add
>>
>> Seems task work did not get added. Something about newly added
>> IORING_SETUP_DEFER_TASKRUN changes the scenario.
>>
>> static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
>> {
>> ?????? struct io_uring_task *tctx = req->task->io_uring;
>> ?????? struct io_ring_ctx *ctx = req->ctx;
>> ?????? struct llist_node *node;
>>
>> ?????? if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>> ?????????????? io_req_local_work_add(req);
>> ?????????????? return;
>> ?????? }
>> ????....
>>
>> To confirm, I commented that in t/io_uring and it runs fine.
>> Please see if that changes anything for you? I will try to find the
>> actual fix tomorow.
> 
> Ah gotcha, yes that actually makes a lot of sense. I wonder if regular
> polling is then also broken without poll queues if
> IORING_SETUP_DEFER_TASKRUN is set. It should be, I'll check into
> io_iopoll_check().

A mix of fixes and just cleanups, here's what I got.

-- 
Jens Axboe


--------------bhhJg1e88Tg5uomucVsnEzQ9
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-cleanly-separate-request-types-for-iopoll.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-cleanly-separate-request-types-for-iopoll.patc";
 filename*1="h"
Content-Transfer-Encoding: base64

RnJvbSA1MDE1NTE4NjY0NGEzNTJiMjkwYjcyYzYxZTczOGY2MjY0MGQ1NjZhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IEZyaSwgMiBTZXAgMjAyMiAxNToxNjoyOSAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggMS8z
XSBpb191cmluZzogY2xlYW5seSBzZXBhcmF0ZSByZXF1ZXN0IHR5cGVzIGZvciBpb3BvbGwK
CkFmdGVyIHRoZSBhZGRpdGlvbiBvZiBpb3BvbGwgc3VwcG9ydCBmb3IgcGFzc3Rocm91Z2gs
IHRoZXJlJ3MgYSBiaXQgb2YKYSBtaXh1cCBoZXJlLiBDbGVhbiBpdCB1cCBhbmQgZ2V0IHJp
ZCBvZiB0aGUgY2FzdGluZyBmb3IgdGhlIHBhc3N0aHJvdWdoCmNvbW1hbmQgdHlwZS4KClNp
Z25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBpb191cmlu
Zy9ydy5jIHwgMTUgKysrKysrKysrLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRp
b25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2lvX3VyaW5nL3J3LmMgYi9p
b191cmluZy9ydy5jCmluZGV4IDk2OThhNzg5YjNkNS4uM2YwM2I2ZDJhNWEzIDEwMDY0NAot
LS0gYS9pb191cmluZy9ydy5jCisrKyBiL2lvX3VyaW5nL3J3LmMKQEAgLTk5NCw3ICs5OTQs
NyBAQCBpbnQgaW9fZG9faW9wb2xsKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LCBib29sIGZv
cmNlX25vbnNwaW4pCiAKIAl3cV9saXN0X2Zvcl9lYWNoKHBvcywgc3RhcnQsICZjdHgtPmlv
cG9sbF9saXN0KSB7CiAJCXN0cnVjdCBpb19raW9jYiAqcmVxID0gY29udGFpbmVyX29mKHBv
cywgc3RydWN0IGlvX2tpb2NiLCBjb21wX2xpc3QpOwotCQlzdHJ1Y3QgaW9fcncgKnJ3ID0g
aW9fa2lvY2JfdG9fY21kKHJlcSwgc3RydWN0IGlvX3J3KTsKKwkJc3RydWN0IGZpbGUgKmZp
bGUgPSByZXEtPmZpbGU7CiAJCWludCByZXQ7CiAKIAkJLyoKQEAgLTEwMDYsMTIgKzEwMDYs
MTUgQEAgaW50IGlvX2RvX2lvcG9sbChzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgYm9vbCBm
b3JjZV9ub25zcGluKQogCQkJYnJlYWs7CiAKIAkJaWYgKHJlcS0+b3Bjb2RlID09IElPUklO
R19PUF9VUklOR19DTUQpIHsKLQkJCXN0cnVjdCBpb191cmluZ19jbWQgKmlvdWNtZCA9IChz
dHJ1Y3QgaW9fdXJpbmdfY21kICopcnc7CisJCQlzdHJ1Y3QgaW9fdXJpbmdfY21kICppb3Vj
bWQ7CiAKLQkJCXJldCA9IHJlcS0+ZmlsZS0+Zl9vcC0+dXJpbmdfY21kX2lvcG9sbChpb3Vj
bWQpOwotCQl9IGVsc2UKLQkJCXJldCA9IHJ3LT5raW9jYi5raV9maWxwLT5mX29wLT5pb3Bv
bGwoJnJ3LT5raW9jYiwgJmlvYiwKLQkJCQkJCQlwb2xsX2ZsYWdzKTsKKwkJCWlvdWNtZCA9
IGlvX2tpb2NiX3RvX2NtZChyZXEsIHN0cnVjdCBpb191cmluZ19jbWQpOworCQkJcmV0ID0g
ZmlsZS0+Zl9vcC0+dXJpbmdfY21kX2lvcG9sbChpb3VjbWQsIHBvbGxfZmxhZ3MpOworCQl9
IGVsc2UgeworCQkJc3RydWN0IGlvX3J3ICpydyA9IGlvX2tpb2NiX3RvX2NtZChyZXEsIHN0
cnVjdCBpb19ydyk7CisKKwkJCXJldCA9IGZpbGUtPmZfb3AtPmlvcG9sbCgmcnctPmtpb2Ni
LCAmaW9iLCBwb2xsX2ZsYWdzKTsKKwkJfQogCQlpZiAodW5saWtlbHkocmV0IDwgMCkpCiAJ
CQlyZXR1cm4gcmV0OwogCQllbHNlIGlmIChyZXQpCi0tIAoyLjM1LjEKCg==
--------------bhhJg1e88Tg5uomucVsnEzQ9
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-nvme-use-separate-end-IO-handler-for-IOPOLL.patch"
Content-Disposition: attachment;
 filename="0002-nvme-use-separate-end-IO-handler-for-IOPOLL.patch"
Content-Transfer-Encoding: base64

RnJvbSAwYmM3OGM4NDNiODYzNmRjZGZlNDVkZDA3MzI4Y2E4MjZmYTY3ZjliIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IEZyaSwgMiBTZXAgMjAyMiAxNToxNzozMCAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggMi8z
XSBudm1lOiB1c2Ugc2VwYXJhdGUgZW5kIElPIGhhbmRsZXIgZm9yIElPUE9MTAoKRG9uJ3Qg
bmVlZCB0byByZWx5IG9uIHRoZSBjb29raWUgb3IgcmVxdWVzdCB0eXBlLCBzZXQgdGhlIHJp
Z2h0IGhhbmRsZXIKYmFzZWQgb24gaG93IHdlJ3JlIGhhbmRsaW5nIHRoZSBJTy4KClNpZ25l
ZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBkcml2ZXJzL252
bWUvaG9zdC9pb2N0bC5jIHwgMzAgKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tCiAx
IGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL252bWUvaG9zdC9pb2N0bC5jIGIvZHJpdmVycy9udm1lL2hvc3Qv
aW9jdGwuYwppbmRleCA3NzU2YjQzOWE2ODguLmYzNGFiZTk1ODIxZSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9udm1lL2hvc3QvaW9jdGwuYworKysgYi9kcml2ZXJzL252bWUvaG9zdC9pb2N0
bC5jCkBAIC0zODUsMjUgKzM4NSwzNiBAQCBzdGF0aWMgdm9pZCBudm1lX3VyaW5nX3Rhc2tf
Y2Ioc3RydWN0IGlvX3VyaW5nX2NtZCAqaW91Y21kKQogCWlvX3VyaW5nX2NtZF9kb25lKGlv
dWNtZCwgc3RhdHVzLCByZXN1bHQpOwogfQogCi1zdGF0aWMgdm9pZCBudm1lX3VyaW5nX2Nt
ZF9lbmRfaW8oc3RydWN0IHJlcXVlc3QgKnJlcSwgYmxrX3N0YXR1c190IGVycikKK3N0YXRp
YyB2b2lkIG52bWVfdXJpbmdfaW9wb2xsX2NtZF9lbmRfaW8oc3RydWN0IHJlcXVlc3QgKnJl
cSwgYmxrX3N0YXR1c190IGVycikKIHsKIAlzdHJ1Y3QgaW9fdXJpbmdfY21kICppb3VjbWQg
PSByZXEtPmVuZF9pb19kYXRhOwogCXN0cnVjdCBudm1lX3VyaW5nX2NtZF9wZHUgKnBkdSA9
IG52bWVfdXJpbmdfY21kX3BkdShpb3VjbWQpOwogCS8qIGV4dHJhY3QgYmlvIGJlZm9yZSBy
ZXVzaW5nIHRoZSBzYW1lIGZpZWxkIGZvciByZXF1ZXN0ICovCiAJc3RydWN0IGJpbyAqYmlv
ID0gcGR1LT5iaW87Ci0Jdm9pZCAqY29va2llID0gUkVBRF9PTkNFKGlvdWNtZC0+Y29va2ll
KTsKIAogCXBkdS0+cmVxID0gcmVxOwogCXJlcS0+YmlvID0gYmlvOwogCiAJLyoKIAkgKiBG
b3IgaW9wb2xsLCBjb21wbGV0ZSBpdCBkaXJlY3RseS4KLQkgKiBPdGhlcndpc2UsIG1vdmUg
dGhlIGNvbXBsZXRpb24gdG8gdGFzayB3b3JrLgogCSAqLwotCWlmIChjb29raWUgIT0gTlVM
TCAmJiBibGtfcnFfaXNfcG9sbChyZXEpKQotCQludm1lX3VyaW5nX3Rhc2tfY2IoaW91Y21k
KTsKLQllbHNlCi0JCWlvX3VyaW5nX2NtZF9jb21wbGV0ZV9pbl90YXNrKGlvdWNtZCwgbnZt
ZV91cmluZ190YXNrX2NiKTsKKwludm1lX3VyaW5nX3Rhc2tfY2IoaW91Y21kKTsKK30KKwor
c3RhdGljIHZvaWQgbnZtZV91cmluZ19jbWRfZW5kX2lvKHN0cnVjdCByZXF1ZXN0ICpyZXEs
IGJsa19zdGF0dXNfdCBlcnIpCit7CisJc3RydWN0IGlvX3VyaW5nX2NtZCAqaW91Y21kID0g
cmVxLT5lbmRfaW9fZGF0YTsKKwlzdHJ1Y3QgbnZtZV91cmluZ19jbWRfcGR1ICpwZHUgPSBu
dm1lX3VyaW5nX2NtZF9wZHUoaW91Y21kKTsKKwkvKiBleHRyYWN0IGJpbyBiZWZvcmUgcmV1
c2luZyB0aGUgc2FtZSBmaWVsZCBmb3IgcmVxdWVzdCAqLworCXN0cnVjdCBiaW8gKmJpbyA9
IHBkdS0+YmlvOworCisJcGR1LT5yZXEgPSByZXE7CisJcmVxLT5iaW8gPSBiaW87CisKKwkv
KgorCSAqIE1vdmUgdGhlIGNvbXBsZXRpb24gdG8gdGFzayB3b3JrLgorCSAqLworCWlvX3Vy
aW5nX2NtZF9jb21wbGV0ZV9pbl90YXNrKGlvdWNtZCwgbnZtZV91cmluZ190YXNrX2NiKTsK
IH0KIAogc3RhdGljIGludCBudm1lX3VyaW5nX2NtZF9pbyhzdHJ1Y3QgbnZtZV9jdHJsICpj
dHJsLCBzdHJ1Y3QgbnZtZV9ucyAqbnMsCkBAIC00NjQsNyArNDc1LDEwIEBAIHN0YXRpYyBp
bnQgbnZtZV91cmluZ19jbWRfaW8oc3RydWN0IG52bWVfY3RybCAqY3RybCwgc3RydWN0IG52
bWVfbnMgKm5zLAogCQkJYmxrX2ZsYWdzKTsKIAlpZiAoSVNfRVJSKHJlcSkpCiAJCXJldHVy
biBQVFJfRVJSKHJlcSk7Ci0JcmVxLT5lbmRfaW8gPSBudm1lX3VyaW5nX2NtZF9lbmRfaW87
CisJaWYgKGlzc3VlX2ZsYWdzICYgSU9fVVJJTkdfRl9JT1BPTEwpCisJCXJlcS0+ZW5kX2lv
ID0gbnZtZV91cmluZ19pb3BvbGxfY21kX2VuZF9pbzsKKwllbHNlCisJCXJlcS0+ZW5kX2lv
ID0gbnZtZV91cmluZ19jbWRfZW5kX2lvOwogCXJlcS0+ZW5kX2lvX2RhdGEgPSBpb3VjbWQ7
CiAKIAlpZiAoaXNzdWVfZmxhZ3MgJiBJT19VUklOR19GX0lPUE9MTCAmJiBycV9mbGFncyAm
IFJFUV9QT0xMRUQpIHsKLS0gCjIuMzUuMQoK
--------------bhhJg1e88Tg5uomucVsnEzQ9
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-fs-add-batch-and-poll-flags-to-the-uring_cmd_iopoll-.patch"
Content-Disposition: attachment;
 filename*0="0003-fs-add-batch-and-poll-flags-to-the-uring_cmd_iopoll-.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA5ZGFhMzliMTQ2ZjNhOGY0MTIxOTZkZjVlYjlmOTY4NmYzMDhlNWNjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IEZyaSwgMiBTZXAgMjAyMiAxNToxODowNSAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggMy8z
XSBmczogYWRkIGJhdGNoIGFuZCBwb2xsIGZsYWdzIHRvIHRoZSB1cmluZ19jbWRfaW9wb2xs
KCkKIGhhbmRsZXIKCldlIG5lZWQgdGhlIHBvbGxfZmxhZ3MgdG8ga25vdyBob3cgdG8gcG9s
bCBmb3IgdGhlIElPLCBhbmQgd2Ugc2hvdWxkCmhhdmUgdGhlIGJhdGNoIHN0cnVjdHVyZSBp
biBwcmVwYXJhdGlvbiBmb3Igc3VwcG9ydGluZyBiYXRjaGVkCmNvbXBsZXRpb25zIHdpdGgg
aW9wb2xsLgoKU2lnbmVkLW9mZi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgot
LS0KIGRyaXZlcnMvbnZtZS9ob3N0L2lvY3RsLmMgfCAxMiArKysrKysrKy0tLS0KIGRyaXZl
cnMvbnZtZS9ob3N0L252bWUuaCAgfCAgNiArKysrLS0KIGluY2x1ZGUvbGludXgvZnMuaCAg
ICAgICAgfCAgMyArKy0KIGlvX3VyaW5nL3J3LmMgICAgICAgICAgICAgfCAgMyArKy0KIDQg
ZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL252bWUvaG9zdC9pb2N0bC5jIGIvZHJpdmVycy9udm1lL2hvc3Qv
aW9jdGwuYwppbmRleCBmMzRhYmU5NTgyMWUuLjdhMGIxMmVmNDlhZSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9udm1lL2hvc3QvaW9jdGwuYworKysgYi9kcml2ZXJzL252bWUvaG9zdC9pb2N0
bC5jCkBAIC02MzcsNyArNjM3LDkgQEAgaW50IG52bWVfbnNfY2hyX3VyaW5nX2NtZChzdHJ1
Y3QgaW9fdXJpbmdfY21kICppb3VjbWQsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFncykKIAly
ZXR1cm4gbnZtZV9uc191cmluZ19jbWQobnMsIGlvdWNtZCwgaXNzdWVfZmxhZ3MpOwogfQog
Ci1pbnQgbnZtZV9uc19jaHJfdXJpbmdfY21kX2lvcG9sbChzdHJ1Y3QgaW9fdXJpbmdfY21k
ICppb3VjbWQpCitpbnQgbnZtZV9uc19jaHJfdXJpbmdfY21kX2lvcG9sbChzdHJ1Y3QgaW9f
dXJpbmdfY21kICppb3VjbWQsCisJCQkJIHN0cnVjdCBpb19jb21wX2JhdGNoICppb2IsCisJ
CQkJIHVuc2lnbmVkIGludCBwb2xsX2ZsYWdzKQogewogCXN0cnVjdCBiaW8gKmJpbzsKIAlp
bnQgcmV0ID0gMDsKQEAgLTY1MCw3ICs2NTIsNyBAQCBpbnQgbnZtZV9uc19jaHJfdXJpbmdf
Y21kX2lvcG9sbChzdHJ1Y3QgaW9fdXJpbmdfY21kICppb3VjbWQpCiAJCQlzdHJ1Y3QgbnZt
ZV9ucywgY2Rldik7CiAJcSA9IG5zLT5xdWV1ZTsKIAlpZiAodGVzdF9iaXQoUVVFVUVfRkxB
R19QT0xMLCAmcS0+cXVldWVfZmxhZ3MpICYmIGJpbyAmJiBiaW8tPmJpX2JkZXYpCi0JCXJl
dCA9IGJpb19wb2xsKGJpbywgTlVMTCwgMCk7CisJCXJldCA9IGJpb19wb2xsKGJpbywgaW9i
LCBwb2xsX2ZsYWdzKTsKIAlyY3VfcmVhZF91bmxvY2soKTsKIAlyZXR1cm4gcmV0OwogfQpA
QCAtNzM2LDcgKzczOCw5IEBAIGludCBudm1lX25zX2hlYWRfY2hyX3VyaW5nX2NtZChzdHJ1
Y3QgaW9fdXJpbmdfY21kICppb3VjbWQsCiAJcmV0dXJuIHJldDsKIH0KIAotaW50IG52bWVf
bnNfaGVhZF9jaHJfdXJpbmdfY21kX2lvcG9sbChzdHJ1Y3QgaW9fdXJpbmdfY21kICppb3Vj
bWQpCitpbnQgbnZtZV9uc19oZWFkX2Nocl91cmluZ19jbWRfaW9wb2xsKHN0cnVjdCBpb191
cmluZ19jbWQgKmlvdWNtZCwKKwkJCQkgICAgICBzdHJ1Y3QgaW9fY29tcF9iYXRjaCAqaW9i
LAorCQkJCSAgICAgIHVuc2lnbmVkIGludCBwb2xsX2ZsYWdzKQogewogCXN0cnVjdCBjZGV2
ICpjZGV2ID0gZmlsZV9pbm9kZShpb3VjbWQtPmZpbGUpLT5pX2NkZXY7CiAJc3RydWN0IG52
bWVfbnNfaGVhZCAqaGVhZCA9IGNvbnRhaW5lcl9vZihjZGV2LCBzdHJ1Y3QgbnZtZV9uc19o
ZWFkLCBjZGV2KTsKQEAgLTc1Miw3ICs3NTYsNyBAQCBpbnQgbnZtZV9uc19oZWFkX2Nocl91
cmluZ19jbWRfaW9wb2xsKHN0cnVjdCBpb191cmluZ19jbWQgKmlvdWNtZCkKIAkJcSA9IG5z
LT5xdWV1ZTsKIAkJaWYgKHRlc3RfYml0KFFVRVVFX0ZMQUdfUE9MTCwgJnEtPnF1ZXVlX2Zs
YWdzKSAmJiBiaW8KIAkJCQkmJiBiaW8tPmJpX2JkZXYpCi0JCQlyZXQgPSBiaW9fcG9sbChi
aW8sIE5VTEwsIDApOworCQkJcmV0ID0gYmlvX3BvbGwoYmlvLCBpb2IsIHBvbGxfZmxhZ3Mp
OwogCQlyY3VfcmVhZF91bmxvY2soKTsKIAl9CiAJc3JjdV9yZWFkX3VubG9jaygmaGVhZC0+
c3JjdSwgc3JjdV9pZHgpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9udm1lL2hvc3QvbnZtZS5o
IGIvZHJpdmVycy9udm1lL2hvc3QvbnZtZS5oCmluZGV4IGZkY2JjOTNkZWEyMS4uMjE2YWNi
ZTk1M2IzIDEwMDY0NAotLS0gYS9kcml2ZXJzL252bWUvaG9zdC9udm1lLmgKKysrIGIvZHJp
dmVycy9udm1lL2hvc3QvbnZtZS5oCkBAIC04MjEsOCArODIxLDEwIEBAIGxvbmcgbnZtZV9u
c19oZWFkX2Nocl9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZSwgdW5zaWduZWQgaW50IGNtZCwK
IAkJdW5zaWduZWQgbG9uZyBhcmcpOwogbG9uZyBudm1lX2Rldl9pb2N0bChzdHJ1Y3QgZmls
ZSAqZmlsZSwgdW5zaWduZWQgaW50IGNtZCwKIAkJdW5zaWduZWQgbG9uZyBhcmcpOwotaW50
IG52bWVfbnNfY2hyX3VyaW5nX2NtZF9pb3BvbGwoc3RydWN0IGlvX3VyaW5nX2NtZCAqaW91
Y21kKTsKLWludCBudm1lX25zX2hlYWRfY2hyX3VyaW5nX2NtZF9pb3BvbGwoc3RydWN0IGlv
X3VyaW5nX2NtZCAqaW91Y21kKTsKK2ludCBudm1lX25zX2Nocl91cmluZ19jbWRfaW9wb2xs
KHN0cnVjdCBpb191cmluZ19jbWQgKmlvdWNtZCwKKwkJc3RydWN0IGlvX2NvbXBfYmF0Y2gg
KmlvYiwgdW5zaWduZWQgaW50IHBvbGxfZmxhZ3MpOworaW50IG52bWVfbnNfaGVhZF9jaHJf
dXJpbmdfY21kX2lvcG9sbChzdHJ1Y3QgaW9fdXJpbmdfY21kICppb3VjbWQsCisJCXN0cnVj
dCBpb19jb21wX2JhdGNoICppb2IsIHVuc2lnbmVkIGludCBwb2xsX2ZsYWdzKTsKIGludCBu
dm1lX25zX2Nocl91cmluZ19jbWQoc3RydWN0IGlvX3VyaW5nX2NtZCAqaW91Y21kLAogCQl1
bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpOwogaW50IG52bWVfbnNfaGVhZF9jaHJfdXJpbmdf
Y21kKHN0cnVjdCBpb191cmluZ19jbWQgKmlvdWNtZCwKZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvZnMuaCBiL2luY2x1ZGUvbGludXgvZnMuaAppbmRleCBkNmJhZGQxOTc4NGYuLjAx
NjgxZDA2MWE2YSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9mcy5oCisrKyBiL2luY2x1
ZGUvbGludXgvZnMuaApAQCAtMjEzMiw3ICsyMTMyLDggQEAgc3RydWN0IGZpbGVfb3BlcmF0
aW9ucyB7CiAJCQkJICAgbG9mZl90IGxlbiwgdW5zaWduZWQgaW50IHJlbWFwX2ZsYWdzKTsK
IAlpbnQgKCpmYWR2aXNlKShzdHJ1Y3QgZmlsZSAqLCBsb2ZmX3QsIGxvZmZfdCwgaW50KTsK
IAlpbnQgKCp1cmluZ19jbWQpKHN0cnVjdCBpb191cmluZ19jbWQgKmlvdWNtZCwgdW5zaWdu
ZWQgaW50IGlzc3VlX2ZsYWdzKTsKLQlpbnQgKCp1cmluZ19jbWRfaW9wb2xsKShzdHJ1Y3Qg
aW9fdXJpbmdfY21kICppb3VjbWQpOworCWludCAoKnVyaW5nX2NtZF9pb3BvbGwpKHN0cnVj
dCBpb191cmluZ19jbWQgKiwgc3RydWN0IGlvX2NvbXBfYmF0Y2ggKiwKKwkJCQl1bnNpZ25l
ZCBpbnQgcG9sbF9mbGFncyk7CiB9IF9fcmFuZG9taXplX2xheW91dDsKIAogc3RydWN0IGlu
b2RlX29wZXJhdGlvbnMgewpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvcncuYyBiL2lvX3VyaW5n
L3J3LmMKaW5kZXggM2YwM2I2ZDJhNWEzLi40YTA2MTMyNmM2NjQgMTAwNjQ0Ci0tLSBhL2lv
X3VyaW5nL3J3LmMKKysrIGIvaW9fdXJpbmcvcncuYwpAQCAtMTAwOSw3ICsxMDA5LDggQEAg
aW50IGlvX2RvX2lvcG9sbChzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgYm9vbCBmb3JjZV9u
b25zcGluKQogCQkJc3RydWN0IGlvX3VyaW5nX2NtZCAqaW91Y21kOwogCiAJCQlpb3VjbWQg
PSBpb19raW9jYl90b19jbWQocmVxLCBzdHJ1Y3QgaW9fdXJpbmdfY21kKTsKLQkJCXJldCA9
IGZpbGUtPmZfb3AtPnVyaW5nX2NtZF9pb3BvbGwoaW91Y21kLCBwb2xsX2ZsYWdzKTsKKwkJ
CXJldCA9IGZpbGUtPmZfb3AtPnVyaW5nX2NtZF9pb3BvbGwoaW91Y21kLCAmaW9iLAorCQkJ
CQkJCQlwb2xsX2ZsYWdzKTsKIAkJfSBlbHNlIHsKIAkJCXN0cnVjdCBpb19ydyAqcncgPSBp
b19raW9jYl90b19jbWQocmVxLCBzdHJ1Y3QgaW9fcncpOwogCi0tIAoyLjM1LjEKCg==

--------------bhhJg1e88Tg5uomucVsnEzQ9--
