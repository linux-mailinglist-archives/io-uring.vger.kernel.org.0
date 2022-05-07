Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BD451E873
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 18:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359327AbiEGQPm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 12:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243610AbiEGQPl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 12:15:41 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D1811A14
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 09:11:54 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id s14so10150273plk.8
        for <io-uring@vger.kernel.org>; Sat, 07 May 2022 09:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=If1DeGHPUYcX07EGfNVy1HMKD2wMF0Ei4FQQQdwO/oc=;
        b=Xs/XtA8Z70aWy2hsBds3wPE/Qm24qRsCoHCGzxM6uYvvAAKV55ngIvLS4esQUZGfu0
         cEm6YTRpsKAwrVnO7RAhfbiFc9hDBi3yYRVjV6jtA0SSS7Jfof1tm2Epw5dlmEj5exix
         LkV+4gKmWMnZemg5i8Q19K6bopw7w94TovrZ8etWfFGhi6/4kuUpcypE9FXQfJmaIfH2
         XCyOGquIR1T/4F6tQmEs+EsBOZgIqomZ/Fk0l4+btofXczpIN4HlO9Dgu+nVbUnkEMpb
         J7wH2Is3mk/3hSRI1TuolYH1IEvee4LnYR6f9tbJ2KYF/OB40XBkhbPUGYiByGnGo1Uf
         S0OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=If1DeGHPUYcX07EGfNVy1HMKD2wMF0Ei4FQQQdwO/oc=;
        b=SJBv9hzg84NT2szbK5DGlmfdEe18mSaFTR6b/ev2JGP0H3hcRohoEyGsO1lXTf9N8V
         /K3sCL3d+BjZMrYR0CXtbSQJLWR3wd0o+WDmiVXg7RMMoAtWi3bpZ359v8LmJ9esErj+
         bW0/SNEkoV5rTftHTE6gRsQzU/cxNXlTO4D76yHcRBGXIckJqfbMe/hXwwMQL1exxzSB
         URYoeMi4bn9FiAEC0OUyl8OTxyZBpIrtVGcHGW9KnRvju6cbwyg4nY4SLoCsKhdtbYGG
         erA0mFI78EgOzVfw6LIROWesIsnjwIos6CsSBPiaOmHZqoIaiHLXp8t2i6vjLpK+hK/B
         +PJg==
X-Gm-Message-State: AOAM5307glqR5KRMfaqsRbU1qtxDoiZXP1AHUSSSe8RAeOLVMQccnMtQ
        KOHKe1KY5wFzom2+FQb2Lb3xXQ==
X-Google-Smtp-Source: ABdhPJyGB4edTD7Ch9fjSDvh7j0a51pfT2G1AZl2HtzJxirfeQEUsxVuINjdEkCNrU5QOtLRSCjzlw==
X-Received: by 2002:a17:902:ea09:b0:15e:b761:3ca2 with SMTP id s9-20020a170902ea0900b0015eb7613ca2mr8844457plg.121.1651939913915;
        Sat, 07 May 2022 09:11:53 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id bt21-20020a17090af01500b001d967248885sm9387474pjb.29.2022.05.07.09.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 09:11:53 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------0gTUj8jgb4XT0ADq7TLsd8Bk"
Message-ID: <f0a6c58f-62c0-737b-7125-9f75f8432496@kernel.dk>
Date:   Sat, 7 May 2022 10:11:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 0/4] fast poll multishot mode
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
 <305fd65b-310c-9a9b-cb8c-6cbc3d00dbcb@kernel.dk>
 <390a7780-b02b-b086-803c-a8540abfd436@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <390a7780-b02b-b086-803c-a8540abfd436@gmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------0gTUj8jgb4XT0ADq7TLsd8Bk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/22 10:05 AM, Hao Xu wrote:
>> But we still need to consider direct accept with multishot... Should
>> probably be an add-on patch as I think it'd get a bit more complicated
>> if we need to be able to cheaply find an available free fixed fd slot.
>> I'll try and play with that.
> 
> I'm tending to use a new mail account to send v4 rather than the gmail
> account since the git issue seems to be network related.
> I'll also think about the fixed fd problem.

Two basic attached patches that attempt do just alloc a fixed file
descriptor for this case. Not tested at all... We return the fixed file
slot in this case since we have to, to let the application know what was
picked. I kind of wish we'd done that with direct open/accept to begin
with anyway, a bit annoying that fixed vs normal open/accept behave
differently.

Anyway, something to play with, and I'm sure it can be made better.

-- 
Jens Axboe

--------------0gTUj8jgb4XT0ADq7TLsd8Bk
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-have-multishot-accept-alloc-new-fixed-file-.patch"
Content-Disposition: attachment;
 filename*0="0002-io_uring-have-multishot-accept-alloc-new-fixed-file-.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA2NmU4NWUzNzlkMjczOTQzOThhMTFkMDJiZDAxYWJmNDQ5ZDdiZGUzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFNhdCwgNyBNYXkgMjAyMiAxMDowODozMSAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBpb191cmluZzogaGF2ZSBtdWx0aXNob3QgYWNjZXB0IGFsbG9jIG5ldyBmaXhlZCBmaWxl
IHNsb3QKClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0t
CiBmcy9pb191cmluZy5jIHwgMzQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LQogMSBmaWxlIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvaW9fdXJpbmcuYyBiL2ZzL2lvX3VyaW5nLmMKaW5kZXggMTNiOTkw
NDBhZTkwLi44OGI5NWI4MjhiZWQgMTAwNjQ0Ci0tLSBhL2ZzL2lvX3VyaW5nLmMKKysrIGIv
ZnMvaW9fdXJpbmcuYwpAQCAtMjU4LDYgKzI1OCw3IEBAIHN0cnVjdCBpb19yc3JjX3B1dCB7
CiBzdHJ1Y3QgaW9fZmlsZV90YWJsZSB7CiAJc3RydWN0IGlvX2ZpeGVkX2ZpbGUgKmZpbGVz
OwogCXVuc2lnbmVkIGxvbmcgKmJpdG1hcDsKKwl1bnNpZ25lZCBpbnQgYWxsb2NfaGludDsK
IH07CiAKIHN0cnVjdCBpb19yc3JjX25vZGUgewpAQCAtNTcyMSw4ICs1NzIyLDcgQEAgc3Rh
dGljIGludCBpb19hY2NlcHRfcHJlcChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgY29uc3Qgc3Ry
dWN0IGlvX3VyaW5nX3NxZSAqc3FlKQogCQlyZXR1cm4gLUVJTlZBTDsKIAogCWFjY2VwdC0+
ZmlsZV9zbG90ID0gUkVBRF9PTkNFKHNxZS0+ZmlsZV9pbmRleCk7Ci0JaWYgKGFjY2VwdC0+
ZmlsZV9zbG90ICYmICgoYWNjZXB0LT5mbGFncyAmIFNPQ0tfQ0xPRVhFQykgfHwKLQkgICBm
bGFncyAmIElPUklOR19BQ0NFUFRfTVVMVElTSE9UKSkKKwlpZiAoYWNjZXB0LT5maWxlX3Ns
b3QgJiYgKGFjY2VwdC0+ZmxhZ3MgJiBTT0NLX0NMT0VYRUMpKQogCQlyZXR1cm4gLUVJTlZB
TDsKIAlpZiAoYWNjZXB0LT5mbGFncyAmIH4oU09DS19DTE9FWEVDIHwgU09DS19OT05CTE9D
SykpCiAJCXJldHVybiAtRUlOVkFMOwpAQCAtNTc1MCw2ICs1NzUwLDE4IEBAIHN0YXRpYyBp
bmxpbmUgdm9pZCBpb19wb2xsX2NsZWFuKHN0cnVjdCBpb19raW9jYiAqcmVxKQogCQlfX2lv
X3BvbGxfY2xlYW4ocmVxKTsKIH0KIAorc3RhdGljIGludCBpb19maWxlX2JpdG1hcF9nZXQo
c3RydWN0IGlvX3JpbmdfY3R4ICpjdHgpCit7CisJc3RydWN0IGlvX2ZpbGVfdGFibGUgKnRh
YmxlID0gJmN0eC0+ZmlsZV90YWJsZTsKKwlpbnQgcmV0OworCisJcmV0ID0gZmluZF9uZXh0
X3plcm9fYml0KHRhYmxlLT5iaXRtYXAsIGN0eC0+bnJfdXNlcl9maWxlcywKKwkJCQkgdGFi
bGUtPmFsbG9jX2hpbnQpOworCWlmICh1bmxpa2VseShyZXQgPT0gY3R4LT5ucl91c2VyX2Zp
bGVzKSkKKwkJcmV0dXJuIC1FTkZJTEU7CisJcmV0dXJuIHJldDsKK30KKwogc3RhdGljIGlu
dCBpb19hY2NlcHQoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9m
bGFncykKIHsKIAlzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCA9IHJlcS0+Y3R4OwpAQCAtNTc4
Nyw4ICs1Nzk5LDE5IEBAIHN0YXRpYyBpbnQgaW9fYWNjZXB0KHN0cnVjdCBpb19raW9jYiAq
cmVxLCB1bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpCiAJCWZkX2luc3RhbGwoZmQsIGZpbGUp
OwogCQlyZXQgPSBmZDsKIAl9IGVsc2UgewotCQlyZXQgPSBpb19pbnN0YWxsX2ZpeGVkX2Zp
bGUocmVxLCBmaWxlLCBpc3N1ZV9mbGFncywKLQkJCQkJICAgIGFjY2VwdC0+ZmlsZV9zbG90
IC0gMSk7CisJCWludCBmaXhlZF9zbG90ID0gYWNjZXB0LT5maWxlX3Nsb3QgLSAxOworCisJ
CWlmIChyZXEtPmZsYWdzICYgUkVRX0ZfQVBPTExfTVVMVElTSE9UICYmIGFjY2VwdC0+Zmls
ZV9zbG90KSB7CisJCQlmaXhlZF9zbG90ID0gaW9fZmlsZV9iaXRtYXBfZ2V0KGN0eCk7CisJ
CQlpZiAodW5saWtlbHkoZml4ZWRfc2xvdCA8IDApKSB7CisJCQkJcmV0ID0gZml4ZWRfc2xv
dDsKKwkJCQlnb3RvIGVycjsKKwkJCX0KKwkJfQorCisJCXJldCA9IGlvX2luc3RhbGxfZml4
ZWRfZmlsZShyZXEsIGZpbGUsIGlzc3VlX2ZsYWdzLCBmaXhlZF9zbG90KTsKKwkJaWYgKCFy
ZXQgJiYgcmVxLT5mbGFncyAmIFJFUV9GX0FQT0xMX01VTFRJU0hPVCkKKwkJCXJldCA9IGZp
eGVkX3Nsb3Q7CiAJfQogCiAJaWYgKCEocmVxLT5mbGFncyAmIFJFUV9GX0FQT0xMX01VTFRJ
U0hPVCkpIHsKQEAgLTU4MTUsNiArNTgzOCw3IEBAIHN0YXRpYyBpbnQgaW9fYWNjZXB0KHN0
cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpCiAJICogc2lu
Y2UgdGhlIHVwcGVyIGxheWVyIHdobyBjYWxsZWQgaW9fcXVldWVfc3FlKCkgY2Fubm90IGdl
dCBlcnJvcnMKIAkgKiBoYXBwZW5lZCBoZXJlLgogCSAqLworZXJyOgogCWlvX3BvbGxfY2xl
YW4ocmVxKTsKIAlyZXR1cm4gcmV0OwogfQpAQCAtODczNiwxMSArODc2MCwxMyBAQCBzdGF0
aWMgdm9pZCBpb19mcmVlX2ZpbGVfdGFibGVzKHN0cnVjdCBpb19maWxlX3RhYmxlICp0YWJs
ZSkKIHN0YXRpYyBpbmxpbmUgdm9pZCBpb19maWxlX2JpdG1hcF9zZXQoc3RydWN0IGlvX2Zp
bGVfdGFibGUgKnRhYmxlLCBpbnQgYml0KQogewogCV9fc2V0X2JpdChiaXQsIHRhYmxlLT5i
aXRtYXApOworCXRhYmxlLT5hbGxvY19oaW50ID0gYml0ICsgMTsKIH0KIAogc3RhdGljIGlu
bGluZSB2b2lkIGlvX2ZpbGVfYml0bWFwX2NsZWFyKHN0cnVjdCBpb19maWxlX3RhYmxlICp0
YWJsZSwgaW50IGJpdCkKIHsKIAlfX2NsZWFyX2JpdChiaXQsIHRhYmxlLT5iaXRtYXApOwor
CXRhYmxlLT5hbGxvY19oaW50ID0gYml0OwogfQogCiBzdGF0aWMgdm9pZCBfX2lvX3NxZV9m
aWxlc191bnJlZ2lzdGVyKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4KQotLSAKMi4zNS4xCgo=

--------------0gTUj8jgb4XT0ADq7TLsd8Bk
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-track-fixed-files-with-a-bitmap.patch"
Content-Disposition: attachment;
 filename="0001-io_uring-track-fixed-files-with-a-bitmap.patch"
Content-Transfer-Encoding: base64

RnJvbSBmNDgwMWY5NWMwMWU3NDRiZDMzNmQ2NGNjZmE1ZWZkMjlhMjg2OWUyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFNhdCwgNyBNYXkgMjAyMiAwOTo1NjoxMyAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBpb191cmluZzogdHJhY2sgZml4ZWQgZmlsZXMgd2l0aCBhIGJpdG1hcAoKU2lnbmVkLW9m
Zi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgotLS0KIGZzL2lvX3VyaW5nLmMg
fCAzMiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQs
IDMxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9pb191
cmluZy5jIGIvZnMvaW9fdXJpbmcuYwppbmRleCAzNThjMTk1ZTJkOTkuLjEzYjk5MDQwYWU5
MCAxMDA2NDQKLS0tIGEvZnMvaW9fdXJpbmcuYworKysgYi9mcy9pb191cmluZy5jCkBAIC0y
NTcsNiArMjU3LDcgQEAgc3RydWN0IGlvX3JzcmNfcHV0IHsKIAogc3RydWN0IGlvX2ZpbGVf
dGFibGUgewogCXN0cnVjdCBpb19maXhlZF9maWxlICpmaWxlczsKKwl1bnNpZ25lZCBsb25n
ICpiaXRtYXA7CiB9OwogCiBzdHJ1Y3QgaW9fcnNyY19ub2RlIHsKQEAgLTc2NDUsNiArNzY0
Niw3IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IGZpbGUgKmlvX2ZpbGVfZ2V0X2ZpeGVkKHN0
cnVjdCBpb19raW9jYiAqcmVxLCBpbnQgZmQsCiAJLyogbWFzayBpbiBvdmVybGFwcGluZyBS
RVFfRiBhbmQgRkZTIGJpdHMgKi8KIAlyZXEtPmZsYWdzIHw9IChmaWxlX3B0ciA8PCBSRVFf
Rl9TVVBQT1JUX05PV0FJVF9CSVQpOwogCWlvX3JlcV9zZXRfcnNyY19ub2RlKHJlcSwgY3R4
LCAwKTsKKwlXQVJOX09OX09OQ0UoIXRlc3RfYml0KGZkLCBjdHgtPmZpbGVfdGFibGUuYml0
bWFwKSk7CiBvdXQ6CiAJaW9fcmluZ19zdWJtaXRfdW5sb2NrKGN0eCwgaXNzdWVfZmxhZ3Mp
OwogCXJldHVybiBmaWxlOwpAQCAtODcxMSwxMyArODcxMywzNCBAQCBzdGF0aWMgYm9vbCBp
b19hbGxvY19maWxlX3RhYmxlcyhzdHJ1Y3QgaW9fZmlsZV90YWJsZSAqdGFibGUsIHVuc2ln
bmVkIG5yX2ZpbGVzKQogewogCXRhYmxlLT5maWxlcyA9IGt2Y2FsbG9jKG5yX2ZpbGVzLCBz
aXplb2YodGFibGUtPmZpbGVzWzBdKSwKIAkJCQlHRlBfS0VSTkVMX0FDQ09VTlQpOwotCXJl
dHVybiAhIXRhYmxlLT5maWxlczsKKwlpZiAodW5saWtlbHkoIXRhYmxlLT5maWxlcykpCisJ
CXJldHVybiBmYWxzZTsKKworCXRhYmxlLT5iaXRtYXAgPSBiaXRtYXBfemFsbG9jKG5yX2Zp
bGVzLCBHRlBfS0VSTkVMX0FDQ09VTlQpOworCWlmICh1bmxpa2VseSghdGFibGUtPmJpdG1h
cCkpIHsKKwkJa3ZmcmVlKHRhYmxlLT5maWxlcyk7CisJCXJldHVybiBmYWxzZTsKKwl9CisK
KwlyZXR1cm4gdHJ1ZTsKIH0KIAogc3RhdGljIHZvaWQgaW9fZnJlZV9maWxlX3RhYmxlcyhz
dHJ1Y3QgaW9fZmlsZV90YWJsZSAqdGFibGUpCiB7CiAJa3ZmcmVlKHRhYmxlLT5maWxlcyk7
CisJYml0bWFwX2ZyZWUodGFibGUtPmJpdG1hcCk7CiAJdGFibGUtPmZpbGVzID0gTlVMTDsK
Kwl0YWJsZS0+Yml0bWFwID0gTlVMTDsKK30KKworc3RhdGljIGlubGluZSB2b2lkIGlvX2Zp
bGVfYml0bWFwX3NldChzdHJ1Y3QgaW9fZmlsZV90YWJsZSAqdGFibGUsIGludCBiaXQpCit7
CisJX19zZXRfYml0KGJpdCwgdGFibGUtPmJpdG1hcCk7Cit9CisKK3N0YXRpYyBpbmxpbmUg
dm9pZCBpb19maWxlX2JpdG1hcF9jbGVhcihzdHJ1Y3QgaW9fZmlsZV90YWJsZSAqdGFibGUs
IGludCBiaXQpCit7CisJX19jbGVhcl9iaXQoYml0LCB0YWJsZS0+Yml0bWFwKTsKIH0KIAog
c3RhdGljIHZvaWQgX19pb19zcWVfZmlsZXNfdW5yZWdpc3RlcihzdHJ1Y3QgaW9fcmluZ19j
dHggKmN0eCkKQEAgLTg3MzIsNiArODc1NSw3IEBAIHN0YXRpYyB2b2lkIF9faW9fc3FlX2Zp
bGVzX3VucmVnaXN0ZXIoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgpCiAJCQljb250aW51ZTsK
IAkJaWYgKGlvX2ZpeGVkX2ZpbGVfc2xvdCgmY3R4LT5maWxlX3RhYmxlLCBpKS0+ZmlsZV9w
dHIgJiBGRlNfU0NNKQogCQkJY29udGludWU7CisJCWlvX2ZpbGVfYml0bWFwX2NsZWFyKCZj
dHgtPmZpbGVfdGFibGUsIGkpOwogCQlmcHV0KGZpbGUpOwogCX0KICNlbmRpZgpAQCAtOTEz
NSw2ICs5MTU5LDcgQEAgc3RhdGljIGludCBpb19zcWVfZmlsZXNfcmVnaXN0ZXIoc3RydWN0
IGlvX3JpbmdfY3R4ICpjdHgsIHZvaWQgX191c2VyICphcmcsCiAJCX0KIAkJZmlsZV9zbG90
ID0gaW9fZml4ZWRfZmlsZV9zbG90KCZjdHgtPmZpbGVfdGFibGUsIGkpOwogCQlpb19maXhl
ZF9maWxlX3NldChmaWxlX3Nsb3QsIGZpbGUpOworCQlpb19maWxlX2JpdG1hcF9zZXQoJmN0
eC0+ZmlsZV90YWJsZSwgaSk7CiAJfQogCiAJaW9fcnNyY19ub2RlX3N3aXRjaChjdHgsIE5V
TEwpOwpAQCAtOTE5NSw2ICs5MjIwLDcgQEAgc3RhdGljIGludCBpb19pbnN0YWxsX2ZpeGVk
X2ZpbGUoc3RydWN0IGlvX2tpb2NiICpyZXEsIHN0cnVjdCBmaWxlICpmaWxlLAogCQlpZiAo
cmV0KQogCQkJZ290byBlcnI7CiAJCWZpbGVfc2xvdC0+ZmlsZV9wdHIgPSAwOworCQlpb19m
aWxlX2JpdG1hcF9jbGVhcigmY3R4LT5maWxlX3RhYmxlLCBzbG90X2luZGV4KTsKIAkJbmVl
ZHNfc3dpdGNoID0gdHJ1ZTsKIAl9CiAKQEAgLTkyMDIsNiArOTIyOCw3IEBAIHN0YXRpYyBp
bnQgaW9faW5zdGFsbF9maXhlZF9maWxlKHN0cnVjdCBpb19raW9jYiAqcmVxLCBzdHJ1Y3Qg
ZmlsZSAqZmlsZSwKIAlpZiAoIXJldCkgewogCQkqaW9fZ2V0X3RhZ19zbG90KGN0eC0+Zmls
ZV9kYXRhLCBzbG90X2luZGV4KSA9IDA7CiAJCWlvX2ZpeGVkX2ZpbGVfc2V0KGZpbGVfc2xv
dCwgZmlsZSk7CisJCWlvX2ZpbGVfYml0bWFwX3NldCgmY3R4LT5maWxlX3RhYmxlLCBzbG90
X2luZGV4KTsKIAl9CiBlcnI6CiAJaWYgKG5lZWRzX3N3aXRjaCkKQEAgLTkyNDMsNiArOTI3
MCw3IEBAIHN0YXRpYyBpbnQgaW9fY2xvc2VfZml4ZWQoc3RydWN0IGlvX2tpb2NiICpyZXEs
IHVuc2lnbmVkIGludCBpc3N1ZV9mbGFncykKIAkJZ290byBvdXQ7CiAKIAlmaWxlX3Nsb3Qt
PmZpbGVfcHRyID0gMDsKKwlpb19maWxlX2JpdG1hcF9jbGVhcigmY3R4LT5maWxlX3RhYmxl
LCBvZmZzZXQpOwogCWlvX3JzcmNfbm9kZV9zd2l0Y2goY3R4LCBjdHgtPmZpbGVfZGF0YSk7
CiAJcmV0ID0gMDsKIG91dDoKQEAgLTkyOTIsNiArOTMyMCw3IEBAIHN0YXRpYyBpbnQgX19p
b19zcWVfZmlsZXNfdXBkYXRlKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LAogCQkJaWYgKGVy
cikKIAkJCQlicmVhazsKIAkJCWZpbGVfc2xvdC0+ZmlsZV9wdHIgPSAwOworCQkJaW9fZmls
ZV9iaXRtYXBfY2xlYXIoJmN0eC0+ZmlsZV90YWJsZSwgaSk7CiAJCQluZWVkc19zd2l0Y2gg
PSB0cnVlOwogCQl9CiAJCWlmIChmZCAhPSAtMSkgewpAQCAtOTMyMCw2ICs5MzQ5LDcgQEAg
c3RhdGljIGludCBfX2lvX3NxZV9maWxlc191cGRhdGUoc3RydWN0IGlvX3JpbmdfY3R4ICpj
dHgsCiAJCQl9CiAJCQkqaW9fZ2V0X3RhZ19zbG90KGRhdGEsIGkpID0gdGFnOwogCQkJaW9f
Zml4ZWRfZmlsZV9zZXQoZmlsZV9zbG90LCBmaWxlKTsKKwkJCWlvX2ZpbGVfYml0bWFwX3Nl
dCgmY3R4LT5maWxlX3RhYmxlLCBpKTsKIAkJfQogCX0KIAotLSAKMi4zNS4xCgo=

--------------0gTUj8jgb4XT0ADq7TLsd8Bk--
