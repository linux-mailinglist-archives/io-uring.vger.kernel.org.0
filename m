Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6EA4D3F44
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 03:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiCJCec (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 21:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbiCJCeb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 21:34:31 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74F5D95E8
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 18:33:30 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id bx5so3981992pjb.3
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 18:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to;
        bh=TpNUacxSmepPvSZZZlXB7HfU2BNZII1I7PG4TvbRDVs=;
        b=TUcr4r86j7sg/HCSUxKHAIIt/6sTSSuSSBAdKETV2wkrfCLfqNADxdsjMAsMRokhsm
         6/+D7upxyDqpvs7e3xPQwX2I2JdPAfqo1pqHs2L+26HaCFS8dBQAsKL7GEA0hRLiWJgG
         lZF4bUdA3ldlPdDJTCA+rKQkdID7yHDqyqc6DgdQ12M+/ZHPL/6FryR/9nSIhoxaPiEq
         Igb8KtON4hR5hWTC/m8PqIcIgHsTPHGZtzoCWgrQ7pJhkCJe7tpCKNBeyA6E2o4Tz48u
         yy0yDY2ksWHjRf1xGRO6xLfPMsGgu0C1npTzUSLu4rK5djCTNZIKhPxJqKQbBGeKaJw4
         DljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to;
        bh=TpNUacxSmepPvSZZZlXB7HfU2BNZII1I7PG4TvbRDVs=;
        b=HyhyFT2TOfAGiEHfJsoEH0N+IeDT7JtzGnen46JC98RsF+CJQ453r45lUWt4LLTUvj
         fZkUrfBd0oT766iN+3cdggJtEZdVdlXHGlFUUMO2jtb06rRSpNHLiSSwBxTW1PZyUymc
         8hZ/sDkz1nxrMc3ajh05NGMo1uCoVscrgwK4xRqAtMOfvASX+PcUSX1ACtu0KXD5a9xC
         CsCIRAjB0JnrBgaat7Dopgx3OSBZeKXgcqTG+t7gr5idFKkk9V4vtH5lM1/gpCpJgmlR
         RB06TTdcT19dj0bYfUgju9JMaerZ87B4FKZpaXKEr/6wHr+CiNfUxSLXXwHqlOb9uzsz
         iwng==
X-Gm-Message-State: AOAM531fhrp8Y/wdyr+14M47UfN0iw7B7AIf+QArRm1AJy3nBVQr81h2
        QDs9S0UaeLsMMeJnTOdUKU8GSRTXBWBVfzkx
X-Google-Smtp-Source: ABdhPJw55jiJ1KNS2nOTCoj8OAdDgVbS3Q1kpoabPrWvFIdZvDJOKf4Fw5pmlVNrakg5tGi5FbVElg==
X-Received: by 2002:a17:902:b597:b0:151:e24e:a61e with SMTP id a23-20020a170902b59700b00151e24ea61emr2863366pls.66.1646879610188;
        Wed, 09 Mar 2022 18:33:30 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j6-20020a63b606000000b003808b0ea96fsm3512580pgf.66.2022.03.09.18.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 18:33:29 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------a0QqRW4Dg40uHVGvOPVtvEfG"
Message-ID: <1f58dbfa-9b1f-5627-89aa-2dda3e2844ab@kernel.dk>
Date:   Wed, 9 Mar 2022 19:33:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <f4db0d4c-0ea3-3efa-7e28-bc727b7bc05a@kernel.dk>
In-Reply-To: <f4db0d4c-0ea3-3efa-7e28-bc727b7bc05a@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------a0QqRW4Dg40uHVGvOPVtvEfG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/9/22 6:55 PM, Jens Axboe wrote:
> On 3/9/22 6:36 PM, Jens Axboe wrote:
>> On 3/9/22 4:49 PM, Artyom Pavlov wrote:
>>> Greetings!
>>>
>>> A common approach for multi-threaded servers is to have a number of
>>> threads equal to a number of cores and launch a separate ring in each
>>> one. AFAIK currently if we want to send an event to a different ring,
>>> we have to write-lock this ring, create SQE, and update the index
>>> ring. Alternatively, we could use some kind of user-space message
>>> passing.
>>>
>>> Such approaches are somewhat inefficient and I think it can be solved
>>> elegantly by updating the io_uring_sqe type to allow accepting fd of a
>>> ring to which CQE must be sent by kernel. It can be done by
>>> introducing an IOSQE_ flag and using one of currently unused padding
>>> u64s.
>>>
>>> Such feature could be useful for load balancing and message passing
>>> between threads which would ride on top of io-uring, i.e. you could
>>> send NOP with user_data pointing to a message payload.
>>
>> So what you want is a NOP with 'fd' set to the fd of another ring, and
>> that nop posts a CQE on that other ring? I don't think we'd need IOSQE
>> flags for that, we just need a NOP that supports that. I see a few ways
>> of going about that:
>>
>> 1) Add a new 'NOP' that takes an fd, and validates that that fd is an
>>    io_uring instance. It can then grab the completion lock on that ring
>>    and post an empty CQE.
>>
>> 2) We add a FEAT flag saying NOP supports taking an 'fd' argument, where
>>    'fd' is another ring. Posting CQE same as above.
>>
>> 3) We add a specific opcode for this. Basically the same as #2, but
>>    maybe with a more descriptive name than NOP.
>>
>> Might make sense to pair that with a CQE flag or something like that, as
>> there's no specific user_data that could be used as it doesn't match an
>> existing SQE that has been issued. IORING_CQE_F_WAKEUP for example.
>> Would be applicable to all the above cases.
>>
>> I kind of like #3 the best. Add a IORING_OP_RING_WAKEUP command, require
>> that sqe->fd point to a ring (could even be the ring itself, doesn't
>> matter). And add IORING_CQE_F_WAKEUP as a specific flag for that.
> 
> Something like the below, totally untested. The request will complete on
> the original ring with either 0, for success, or -EOVERFLOW if the
> target ring was already in an overflow state. If the fd specified isn't
> an io_uring context, then the request will complete with -EBADFD.
> 
> If you have any way of testing this, please do. I'll write a basic
> functionality test for it as well, but not until tomorrow.
> 
> Maybe we want to include in cqe->res who the waker was? We can stuff the
> pid/tid in there, for example.

Made the pid change, and also wrote a test case for it. Only change
otherwise is adding a completion trace event as well. Patch below
against for-5.18/io_uring, and attached the test case for liburing.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e04f718319d..b21f85a48224 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1105,6 +1105,9 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_WAKEUP_RING] = {
+		.needs_file		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -4235,6 +4238,44 @@ static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_wakeup_ring_prep(struct io_kiocb *req,
+			       const struct io_uring_sqe *sqe)
+{
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index || sqe->off ||
+		     sqe->len || sqe->rw_flags || sqe->splice_fd_in ||
+		     sqe->buf_index || sqe->personality))
+		return -EINVAL;
+
+	if (req->file->f_op != &io_uring_fops)
+		return -EBADFD;
+
+	return 0;
+}
+
+static int io_wakeup_ring(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_uring_cqe *cqe;
+	struct io_ring_ctx *ctx;
+	int ret = 0;
+
+	ctx = req->file->private_data;
+	spin_lock(&ctx->completion_lock);
+	cqe = io_get_cqe(ctx);
+	if (cqe) {
+		WRITE_ONCE(cqe->user_data, 0);
+		WRITE_ONCE(cqe->res, 0);
+		WRITE_ONCE(cqe->flags, IORING_CQE_F_WAKEUP);
+	} else {
+		ret = -EOVERFLOW;
+	}
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
 static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -6568,6 +6609,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
+	case IORING_OP_WAKEUP_RING:
+		return io_wakeup_ring_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6851,6 +6894,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_LINKAT:
 		ret = io_linkat(req, issue_flags);
 		break;
+	case IORING_OP_WAKEUP_RING:
+		ret = io_wakeup_ring(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 787f491f0d2a..088232133594 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -143,6 +143,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_WAKEUP_RING,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -199,9 +200,11 @@ struct io_uring_cqe {
  *
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
  * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
+ * IORING_CQE_F_WAKEUP	Wakeup request CQE, no link to an SQE
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
+#define IORING_CQE_F_WAKEUP		(1U << 2)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,

-- 
Jens Axboe

--------------a0QqRW4Dg40uHVGvOPVtvEfG
Content-Type: text/x-patch; charset=UTF-8; name="wakeup-ring.patch"
Content-Disposition: attachment; filename="wakeup-ring.patch"
Content-Transfer-Encoding: base64

Y29tbWl0IGQwN2QxN2FkYWI1YjkxOGJkMDU0M2NlNzhmNzVhNDc0N2EwNTczNzkKQXV0aG9y
OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRhdGU6ICAgV2VkIE1hciA5IDE5OjMx
OjU3IDIwMjIgLTA3MDAKCiAgICB0ZXN0L3dha2V1cC1yaW5nOiBhZGQgdGVzdCBjYXNlcyBm
b3IgSU9SSU5HX09QX1dBS0VVUF9SSU5HCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEplbnMg
QXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KCmRpZmYgLS1naXQgYS8uZ2l0aWdub3JlIGIvLmdp
dGlnbm9yZQppbmRleCBjOWRjNzdmYmUxNjIuLjk2MWZkOWU5NmRjNyAxMDA2NDQKLS0tIGEv
LmdpdGlnbm9yZQorKysgYi8uZ2l0aWdub3JlCkBAIC0xMjgsNiArMTI4LDcgQEAKIC90ZXN0
L3RpbWVvdXQtb3ZlcmZsb3cKIC90ZXN0L3VubGluawogL3Rlc3Qvd2FrZXVwLWhhbmcKKy90
ZXN0L3dha2V1cC1yaW5nCiAvdGVzdC9tdWx0aWNxZXNfZHJhaW4KIC90ZXN0L3BvbGwtbXNo
b3QtdXBkYXRlCiAvdGVzdC9yc3JjX3RhZ3MKZGlmZiAtLWdpdCBhL3NyYy9pbmNsdWRlL2xp
YnVyaW5nL2lvX3VyaW5nLmggYi9zcmMvaW5jbHVkZS9saWJ1cmluZy9pb191cmluZy5oCmlu
ZGV4IGE3ZDE5M2QwZGYzOC4uOGY5MTliNDJhOGVhIDEwMDY0NAotLS0gYS9zcmMvaW5jbHVk
ZS9saWJ1cmluZy9pb191cmluZy5oCisrKyBiL3NyYy9pbmNsdWRlL2xpYnVyaW5nL2lvX3Vy
aW5nLmgKQEAgLTE0Nyw2ICsxNDcsNyBAQCBlbnVtIHsKIAlJT1JJTkdfT1BfTUtESVJBVCwK
IAlJT1JJTkdfT1BfU1lNTElOS0FULAogCUlPUklOR19PUF9MSU5LQVQsCisJSU9SSU5HX09Q
X1dBS0VVUF9SSU5HLAogCiAJLyogdGhpcyBnb2VzIGxhc3QsIG9idmlvdXNseSAqLwogCUlP
UklOR19PUF9MQVNULApkaWZmIC0tZ2l0IGEvdGVzdC9NYWtlZmlsZSBiL3Rlc3QvTWFrZWZp
bGUKaW5kZXggZjQyMWY1MzZkZjg3Li40YWFmYmFlODI2Y2EgMTAwNjQ0Ci0tLSBhL3Rlc3Qv
TWFrZWZpbGUKKysrIGIvdGVzdC9NYWtlZmlsZQpAQCAtMTUxLDYgKzE1MSw3IEBAIHRlc3Rf
c3JjcyA6PSBcCiAJdGltZW91dC1vdmVyZmxvdy5jIFwKIAl1bmxpbmsuYyBcCiAJd2FrZXVw
LWhhbmcuYyBcCisJd2FrZXVwLXJpbmcuYyBcCiAJc2tpcC1jcWUuYyBcCiAJIyBFT0wKIApA
QCAtMjIxLDYgKzIyMiw3IEBAIHJpbmctbGVhazI6IG92ZXJyaWRlIExERkxBR1MgKz0gLWxw
dGhyZWFkCiBwb2xsLW1zaG90LXVwZGF0ZTogb3ZlcnJpZGUgTERGTEFHUyArPSAtbHB0aHJl
YWQKIGV4aXQtbm8tY2xlYW51cDogb3ZlcnJpZGUgTERGTEFHUyArPSAtbHB0aHJlYWQKIHBv
bGxmcmVlOiBvdmVycmlkZSBMREZMQUdTICs9IC1scHRocmVhZAord2FrZXVwLXJpbmc6IG92
ZXJyaWRlIExERkxBR1MgKz0gLWxwdGhyZWFkCiAKIGluc3RhbGw6ICQodGVzdF90YXJnZXRz
KSBydW50ZXN0cy5zaCBydW50ZXN0cy1sb29wLnNoCiAJJChJTlNUQUxMKSAtRCAtZCAtbSA3
NTUgJChkYXRhZGlyKS9saWJ1cmluZy10ZXN0LwpkaWZmIC0tZ2l0IGEvdGVzdC93YWtldXAt
cmluZy5jIGIvdGVzdC93YWtldXAtcmluZy5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4
IDAwMDAwMDAwMDAwMC4uMGNjYWU5MmQ0YzkzCi0tLSAvZGV2L251bGwKKysrIGIvdGVzdC93
YWtldXAtcmluZy5jCkBAIC0wLDAgKzEsMTcyIEBACisvKiBTUERYLUxpY2Vuc2UtSWRlbnRp
ZmllcjogTUlUICovCisvKgorICogRGVzY3JpcHRpb246IHRlc3QgcmluZyB3YWtldXAgY29t
bWFuZAorICoKKyAqLworI2luY2x1ZGUgPGVycm5vLmg+CisjaW5jbHVkZSA8c3RkaW8uaD4K
KyNpbmNsdWRlIDx1bmlzdGQuaD4KKyNpbmNsdWRlIDxzdGRsaWIuaD4KKyNpbmNsdWRlIDxz
dHJpbmcuaD4KKyNpbmNsdWRlIDxmY250bC5oPgorI2luY2x1ZGUgPHB0aHJlYWQuaD4KKwor
I2luY2x1ZGUgImxpYnVyaW5nLmgiCisKK3N0YXRpYyBpbnQgbm9fd2FrZXVwOworCitzdGF0
aWMgaW50IHRlc3Rfb3duKHN0cnVjdCBpb191cmluZyAqcmluZykKK3sKKwlzdHJ1Y3QgaW9f
dXJpbmdfY3FlICpjcWU7CisJc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlOworCWludCByZXQs
IGk7CisKKwlzcWUgPSBpb191cmluZ19nZXRfc3FlKHJpbmcpOworCWlmICghc3FlKSB7CisJ
CWZwcmludGYoc3RkZXJyLCAiZ2V0IHNxZSBmYWlsZWRcbiIpOworCQlnb3RvIGVycjsKKwl9
CisKKwlzcWUtPm9wY29kZSA9IElPUklOR19PUF9XQUtFVVBfUklORzsKKwlzcWUtPmZkID0g
cmluZy0+cmluZ19mZDsKKwlzcWUtPnVzZXJfZGF0YSA9IDE7CisKKwlyZXQgPSBpb191cmlu
Z19zdWJtaXQocmluZyk7CisJaWYgKHJldCA8PSAwKSB7CisJCWZwcmludGYoc3RkZXJyLCAi
c3FlIHN1Ym1pdCBmYWlsZWQ6ICVkXG4iLCByZXQpOworCQlnb3RvIGVycjsKKwl9CisKKwlm
b3IgKGkgPSAwOyBpIDwgMjsgaSsrKSB7CisJCXJldCA9IGlvX3VyaW5nX3BlZWtfY3FlKHJp
bmcsICZjcWUpOworCQlpZiAocmV0IDwgMCkgeworCQkJZnByaW50ZihzdGRlcnIsICJ3YWl0
IGNvbXBsZXRpb24gJWRcbiIsIHJldCk7CisJCQlnb3RvIGVycjsKKwkJfQorCQlzd2l0Y2gg
KGNxZS0+dXNlcl9kYXRhKSB7CisJCWNhc2UgMToKKwkJCWlmIChjcWUtPnJlcyA9PSAtRUlO
VkFMIHx8IGNxZS0+cmVzID09IC1FT1BOT1RTVVBQKSB7CisJCQkJbm9fd2FrZXVwID0gMTsK
KwkJCQlyZXR1cm4gMDsKKwkJCX0KKwkJCWlmIChjcWUtPnJlcyAhPSAwKSB7CisJCQkJZnBy
aW50ZihzdGRlcnIsICJ3YWtldXAgcmVzICVkXG4iLCBjcWUtPnJlcyk7CisJCQkJcmV0dXJu
IC0xOworCQkJfQorCQkJYnJlYWs7CisJCWNhc2UgMDoKKwkJCWlmICghKGNxZS0+ZmxhZ3Mg
JiAoMVUgPDwgMikpKSB7CisJCQkJZnByaW50ZihzdGRlcnIsICJpbnZhbGlkIGZsYWdzICV4
XG4iLCBjcWUtPmZsYWdzKTsKKwkJCQlyZXR1cm4gLTE7CisJCQl9CisJCQlicmVhazsKKwkJ
fQorCQlpb191cmluZ19jcWVfc2VlbihyaW5nLCBjcWUpOworCX0KKworCXJldHVybiAwOwor
ZXJyOgorCXJldHVybiAxOworfQorCitzdGF0aWMgdm9pZCAqd2FpdF9jcWVfZm4odm9pZCAq
ZGF0YSkKK3sKKwlzdHJ1Y3QgaW9fdXJpbmcgKnJpbmcgPSBkYXRhOworCXN0cnVjdCBpb191
cmluZ19jcWUgKmNxZTsKKwlpbnQgcmV0OworCisJcmV0ID0gaW9fdXJpbmdfd2FpdF9jcWUo
cmluZywgJmNxZSk7CisJaWYgKHJldCkgeworCQlmcHJpbnRmKHN0ZGVyciwgIndhaXQgY3Fl
ICVkXG4iLCByZXQpOworCQlnb3RvIGVycjsKKwl9CisKKwlpZiAoIShjcWUtPmZsYWdzICYg
KDFVIDw8IDIpKSkgeworCQlmcHJpbnRmKHN0ZGVyciwgImludmFsaWQgZmxhZ3MgJXhcbiIs
IGNxZS0+ZmxhZ3MpOworCQlnb3RvIGVycjsKKwl9CisKKwlyZXR1cm4gTlVMTDsKK2VycjoK
KwlyZXR1cm4gKHZvaWQgKikgKHVuc2lnbmVkIGxvbmcpIDE7Cit9CisKK3N0YXRpYyBpbnQg
dGVzdF9yZW1vdGUoc3RydWN0IGlvX3VyaW5nICpyaW5nLCBzdHJ1Y3QgaW9fdXJpbmcgKnRh
cmdldCkKK3sKKwlzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7CisJc3RydWN0IGlvX3VyaW5n
X3NxZSAqc3FlOworCWludCByZXQ7CisKKwlzcWUgPSBpb191cmluZ19nZXRfc3FlKHJpbmcp
OworCWlmICghc3FlKSB7CisJCWZwcmludGYoc3RkZXJyLCAiZ2V0IHNxZSBmYWlsZWRcbiIp
OworCQlnb3RvIGVycjsKKwl9CisKKwlzcWUtPm9wY29kZSA9IElPUklOR19PUF9XQUtFVVBf
UklORzsKKwlzcWUtPmZkID0gdGFyZ2V0LT5yaW5nX2ZkOworCXNxZS0+dXNlcl9kYXRhID0g
MTsKKworCXJldCA9IGlvX3VyaW5nX3N1Ym1pdChyaW5nKTsKKwlpZiAocmV0IDw9IDApIHsK
KwkJZnByaW50ZihzdGRlcnIsICJzcWUgc3VibWl0IGZhaWxlZDogJWRcbiIsIHJldCk7CisJ
CWdvdG8gZXJyOworCX0KKworCXJldCA9IGlvX3VyaW5nX3BlZWtfY3FlKHJpbmcsICZjcWUp
OworCWlmIChyZXQgPCAwKSB7CisJCWZwcmludGYoc3RkZXJyLCAid2FpdCBjb21wbGV0aW9u
ICVkXG4iLCByZXQpOworCQlnb3RvIGVycjsKKwl9CisJaWYgKGNxZS0+cmVzICE9IDApIHsK
KwkJZnByaW50ZihzdGRlcnIsICJ3YWtldXAgcmVzICVkXG4iLCBjcWUtPnJlcyk7CisJCXJl
dHVybiAtMTsKKwl9CisKKwlpb191cmluZ19jcWVfc2VlbihyaW5nLCBjcWUpOworCXJldHVy
biAwOworZXJyOgorCXJldHVybiAxOworfQorCitpbnQgbWFpbihpbnQgYXJnYywgY2hhciAq
YXJndltdKQoreworCXN0cnVjdCBpb191cmluZyByaW5nLCByaW5nMjsKKwlwdGhyZWFkX3Qg
dGhyZWFkOworCXZvaWQgKnRyZXQ7CisJaW50IHJldDsKKworCWlmIChhcmdjID4gMSkKKwkJ
cmV0dXJuIDA7CisKKwlyZXQgPSBpb191cmluZ19xdWV1ZV9pbml0KDgsICZyaW5nLCAwKTsK
KwlpZiAocmV0KSB7CisJCWZwcmludGYoc3RkZXJyLCAicmluZyBzZXR1cCBmYWlsZWQ6ICVk
XG4iLCByZXQpOworCQlyZXR1cm4gMTsKKwl9CisJcmV0ID0gaW9fdXJpbmdfcXVldWVfaW5p
dCg4LCAmcmluZzIsIDApOworCWlmIChyZXQpIHsKKwkJZnByaW50ZihzdGRlcnIsICJyaW5n
IHNldHVwIGZhaWxlZDogJWRcbiIsIHJldCk7CisJCXJldHVybiAxOworCX0KKworCXB0aHJl
YWRfY3JlYXRlKCZ0aHJlYWQsIE5VTEwsIHdhaXRfY3FlX2ZuLCAmcmluZzIpOworCisJcmV0
ID0gdGVzdF9vd24oJnJpbmcpOworCWlmIChyZXQpIHsKKwkJZnByaW50ZihzdGRlcnIsICJ0
ZXN0X293biBmYWlsZWRcbiIpOworCQlyZXR1cm4gcmV0OworCX0KKwlpZiAobm9fd2FrZXVw
KQorCQlyZXR1cm4gMDsKKworCXJldCA9IHRlc3RfcmVtb3RlKCZyaW5nLCAmcmluZzIpOwor
CWlmIChyZXQpIHsKKwkJZnByaW50ZihzdGRlcnIsICJ0ZXN0X3JlbW90ZSBmYWlsZWRcbiIp
OworCQlyZXR1cm4gcmV0OworCX0KKworCXB0aHJlYWRfam9pbih0aHJlYWQsICZ0cmV0KTsK
KworCXJldHVybiAwOworfQo=

--------------a0QqRW4Dg40uHVGvOPVtvEfG--
