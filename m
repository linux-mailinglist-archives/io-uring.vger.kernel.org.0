Return-Path: <io-uring+bounces-4146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF3C89B5299
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 20:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 707E11F24530
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 19:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB598206979;
	Tue, 29 Oct 2024 19:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lfOgEOGt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0435D204924
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 19:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730229537; cv=none; b=n/8v5ydarQqI4EcMcqCXDns8kVEj0qTNlfgIDNzmN5Ex/B5qkeOiQ7nmf+jpb3vmz9ek1zre5jSnLwTtiy+lQiodLhP9vUceLUE07xDCb807iFDBEYNZjVLQVRMBSLVKV+mAfLPpQ+ZX8afkK+djdpDxqL95VDD75+zLrWdPTGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730229537; c=relaxed/simple;
	bh=NU+pkBvHXZ7g+qz0vCVfLbXwDerrUS/hQ/uWDC1I4MU=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:Cc:
	 References:In-Reply-To; b=TcNI5PkUQ5HGOgiGBFfo7oG5vA+I4kQVnApCu4wuhymty2YdLs/4MxXaVfAKdJgRswN9X9nddq3/Gx/nb6vAmW5x1vsKyGTydvPshoLsoAEKFphT2qvv05LtFxNQ2ItHkrISSaZw+MY3bdYXu4970amYLpwwbXjAOW2kEDVqPGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lfOgEOGt; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83aba237c03so202267339f.3
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 12:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730229533; x=1730834333; darn=vger.kernel.org;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ff0fWwKAFmtS1BRpcn37NSlmaz7+bgC3hmlM1VvfBWU=;
        b=lfOgEOGtMDJ9KG7TewoF90JWvl+85KY3+vasADlL/XAoYr13/vXJ4dLXDP+fGljUFh
         yY3NuPvIHZLO3kz76uNEh2D/FKVxm/V07kggKHcUGnVdVTfUhkHIR2m+glFXUiiSDEAU
         RQioPu8PoE11u+btfLX8LBSQHHvRfIUf8hDPkO6kT077zQL+3Z+W/w9gHmUsffbTstjR
         kihoh8TQmorhS/uhv3izQLaJc2aO9/BQpotW6jiPg71HRE6G/M+Oxz0MkfXazbzjprcN
         /yMSfYAvYenrS5rhemx+ObXehKwpHuyxpzEhLLaWifoOfvKBeQhfQd8XBFPdsJ/JrcGQ
         IYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730229533; x=1730834333;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ff0fWwKAFmtS1BRpcn37NSlmaz7+bgC3hmlM1VvfBWU=;
        b=iuzKmnbdB/uhU7QC1abBjfDgMAeAFaAej5hrSQZ19joKsitDJVWeJYkJW+1J223IhP
         0LnXaX09QikRBqGBAa3uxE4KyTNytSdYJg95MVjI+Z+1d9w+kAdPRaBAKXi2jxfeno6u
         u3PoJkwLVKR8Cu1FQLH/6USfiJ65/AMaZo9Q3wk1hGjNIFWi6FTlXLBXXzmJdTjD8DIB
         8UzsxlMMs+NsPywsoEgqP4sBCP97+i5y4UQ4v9gRhPhjRGudQOKTnNuuDsIHYk1f+E7F
         /jrVD3ucHO6TcrxLPn5x/IiktDPsMDBdblW3+nGKJYyTKIurlKdyd5zo6KqPRRA+fjKw
         aAOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUA0IGYgtxk62t1hVirp77vMUepSLKaHZFGLiRkmAMbv0DRFWQBJuJ4SLLWd/jAPOOdhJShXxmG7w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaIxV+D6RjRF16nQlQITXVid7+znY152Lq7v63OEp/LpHz0zS/
	3cpp79a+Iham9c+qWcuKKnaC/vW3z5U3NRvg4OGp3y3yLZP0r6qnIN+ywDasJXs=
X-Google-Smtp-Source: AGHT+IEQqdBWhZi7e8p10eGEdyiOXqQepjYqFeASalCw7+hepw9+DOJGDgUkYI7PltNDJZIjgMs8Iw==
X-Received: by 2002:a05:6602:6b0c:b0:82a:4419:6156 with SMTP id ca18e2360f4ac-83b1c5df220mr1510886439f.14.1730229532918;
        Tue, 29 Oct 2024 12:18:52 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b137c9996sm209320039f.1.2024.10.29.12.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 12:18:51 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------4Ma6l89VyTyktPSc2NjK3K2p"
Message-ID: <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
Date: Tue, 29 Oct 2024 13:18:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
Content-Language: en-US
In-Reply-To: <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>

This is a multi-part message in MIME format.
--------------4Ma6l89VyTyktPSc2NjK3K2p
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/24 11:04 AM, Jens Axboe wrote:
>> To make my position clear, I think the table approach will turn
>> much better API-wise if the performance suffices, and we can only know
>> that experimentally. I tried that idea with sockets back then, and it
>> was looking well. It'd be great if someone tries to implement and
>> compare it, though I don't believe I should be trying it, so maybe Ming
>> or Jens can, especially since Jens already posted a couple series for
>> problems standing in the way, i.e global rsrc nodes and late buffer
>> binding. In any case, I'm not opposing to the series if Jens decides to
>> merge it.
> 
> With the rsrc node stuff sorted out, I was thinking last night that I
> should take another look at this. While that work was (mostly) done
> because of the lingering closes, it does nicely enable ephemeral buffers
> too.
> 
> I'll take a stab at it... While I would love to make progress on this
> feature proposed in this series, it's arguably more important to do it
> in such a way that we can live with it, long term.

Ming, here's another stab at this, see attached patch. It adds a
LOCAL_BUF opcode, which maps a user provided buffer to a io_rsrc_node
that opcodes can then use. The buffer is visible ONLY within a given
submission - in other words, only within a single io_uring_submit()
call. The buffer provided is done so at prep time, which means you don't
need to serialize with the LOCAL_BUF op itself. You can do:

sqe = io_uring_get_sqe(ring);
io_uring_prep_local_buf(sqe, buffer, length, tag);

sqe = io_uring_get_sqe(ring);
io_uring_prep_whatever_op_fixed(sqe, buffer, length, foo);

and have 'whatever' rely on the buffer either being there to use, or the
import failing with -EFAULT. No IOSQE_IO_LINK or similar is needed.
Obviously if you do:

sqe = io_uring_get_sqe(ring);
io_uring_prep_local_buf(sqe, buffer, length, tag);

sqe = io_uring_get_sqe(ring);
io_uring_prep_read_thing_fixed(sqe, buffer, length, foo);
sqe->flags |= IOSQE_IO_LINK;

sqe = io_uring_get_sqe(ring);
io_uring_prep_write_thing_fixed(sqe, buffer, length, foo);

then the filling of the buffer and whoever uses the filled buffer will
need to be serialized, to ensure the buffer content is valid for the
write.

Any opcode using the ephemeral/local buffer will need to grab a
reference to it, just like what is done for normal registered buffers.
If assigned to req->rsrc_node, then it'll be put as part of normal
completion. Hence no special handling is needed for this. The reference
that submit holds is assigned by LOCAL_BUF, and will be put when
submission ends. Hence no requirement that opcodes finish before submit
ends, they have their own ref.

All of that should make sense, I think. I'm attaching the most basic of
test apps I wrote to test this, as well as using:

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 30448f343c7f..89662f305342 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -338,7 +338,10 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (unlikely(ret))
 		return ret;
 
-	node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
+	if (ctx->submit_state.rsrc_node != rsrc_empty_node)
+		node = ctx->submit_state.rsrc_node;
+	else
+		node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
 	if (!node)
 		return -EFAULT;
 	io_req_assign_rsrc_node(req, node);

just so I could test it with normal read/write fixed and do a zero copy
read/write operation where the write file ends up with the data from the
read file.

When you run the test app, you should see:

axboe@m2max-kvm ~/g/liburing (reg-wait)> test/local-buf.t
buffer 0xaaaada34a000
res=0, ud=0x1
res=4096, ud=0x2
res=4096, ud=0x3
res=0, ud=0xaaaada34a000

which shows LOCAL_BUF completing first, then a 4k read, then a 4k write,
and finally the notification for the buffer being done. The test app
sets up the tag to be the buffer address, could obviously be anything
you want.

Now, this implementation requires a user buffer, and as far as I'm told,
you currently have kernel buffers on the ublk side. There's absolutely
no reason why kernel buffers cannot work, we'd most likely just need to
add a IORING_RSRC_KBUFFER type to handle that. My question here is how
hard is this requirement? Reason I ask is that it's much simpler to work
with userspace buffers. Yes the current implementation maps them
everytime, we could certainly change that, however I don't see this
being an issue. It's really no different than O_DIRECT, and you only
need to map them once for a read + whatever number of writes you'd need
to do. If a 'tag' is provided for LOCAL_BUF, it'll post a CQE whenever
that buffer is unmapped. This is a notification for the application that
it's done using the buffer. For a pure kernel buffer, we'd either need
to be able to reference it (so that we KNOW it's not going away) and/or
have a callback associated with the buffer.

Would it be possible for ublk to require the user side to register a
range of memory that should be used for the write buffers, such that
they could be mapped in the kernel instead? Maybe this memory is already
registered as such? I don't know all the details of the ublk zero copy,
but I would imagine there's some flexibility here in terms of how it
gets setup.

ublk would then need to add opcodes that utilize LOCAL_BUF for this,
obviously. As it stands, with the patch, nobody can access these
buffers, we'd need a READ_LOCAL_FIXED etc to have opcodes be able to
access them. But that should be fine, you need specific opcodes for zero
copy anyway. You can probably even reuse existing opcodes, and just add
something like IORING_URING_CMD_LOCAL as a flag rather than
IORING_URING_CMD_FIXED that is used now for registered buffers.

Let me know what you think. Like I mentioned, this is just a rough
patch. It does work though and it is safe, but obviously only does
userspace memory right now. It sits on top of my io_uring-rsrc branch,
which rewrites the rsrc handling.

-- 
Jens Axboe
--------------4Ma6l89VyTyktPSc2NjK3K2p
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-add-support-for-an-ephemeral-per-submit-buf.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-add-support-for-an-ephemeral-per-submit-buf.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAwMTU5MWJlN2Q2Njg3OTYxOGZiOGY4OTY1MTQxYWMyNGU5MzM0MDY4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFR1ZSwgMjkgT2N0IDIwMjQgMTI6MDA6NDggLTA2MDAKU3ViamVjdDogW1BBVENIXSBp
b191cmluZzogYWRkIHN1cHBvcnQgZm9yIGFuIGVwaGVtZXJhbCBwZXItc3VibWl0IGJ1ZmZl
cgoKVXNlIHRoZSByZXdyaXR0ZW4gcnNyYyBub2RlIG1hbmFnZW1lbnQgdG8gcHJvdmlkZSBh
IGJ1ZmZlciB0aGF0J3MgbG9jYWwKdG8gdGhpcyBzdWJtaXNzaW9uIG9ubHksIGl0J2xsIGdl
dCBwdXQgd2hlbiBkb25lLiBPcGNvZGVzIHdpbGwgbmVlZApzcGVjaWFsIHN1cHBvcnQgZm9y
IHV0aWxpemluZyB0aGUgYnVmZmVyLCByYXRoZXIgdGhhbiBncmFiYmluZyBhCnJlZ2lzdGVy
ZWQgYnVmZmVyIGZyb20gdGhlIG5vcm1hbCByaW5nIGJ1ZmZlciB0YWJsZS4KClRoZSBidWZm
ZXIgaXMgcHVyZWx5IHN1Ym1pc3Npb24gd2lkZSwgaXQgb25seSBleGlzdHMgd2l0aGluIHRo
YXQKc3VibWlzc2lvbi4gSXQgaXMgcHJvdmlkZWQgYXQgcHJlcCB0aW1lLCBzbyB1c2VycyBv
ZiB0aGUgYnVmZmVyIG5lZWQKbm90IHVzZSBzZXJpYWxpemluZyBJT1NRRV9JT19MSU5LIHRv
IHJlbHkgb24gYmVpbmcgYWJsZSB0byB1c2UgaXQuCk9idmlvdXNseSBtdWx0aXBsZSByZXF1
ZXN0cyBhcmUgdXNpbmcgdGhlIHNhbWUgYnVmZmVyIGFuZCBuZWVkCnNlcmlhbGl6YXRpb24g
YmV0d2VlbiB0aGVtLCB0aG9zZSBkZXBlbmRlbmNpZXMgbXVzdCBiZSBleHByZXNzZWQuCgpT
aWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+Ci0tLQogaW5jbHVk
ZS9saW51eC9pb191cmluZ190eXBlcy5oIHwgIDEgKwogaW5jbHVkZS91YXBpL2xpbnV4L2lv
X3VyaW5nLmggIHwgIDEgKwogaW9fdXJpbmcvaW9fdXJpbmcuYyAgICAgICAgICAgIHwgIDIg
KysKIGlvX3VyaW5nL29wZGVmLmMgICAgICAgICAgICAgICB8ICA3ICsrKysrKysKIGlvX3Vy
aW5nL3JzcmMuYyAgICAgICAgICAgICAgICB8IDMwICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKwogaW9fdXJpbmcvcnNyYy5oICAgICAgICAgICAgICAgIHwgIDMgKysrCiA2IGZp
bGVzIGNoYW5nZWQsIDQ0IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L2lvX3VyaW5nX3R5cGVzLmggYi9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nX3R5cGVzLmgK
aW5kZXggYzI4MzE3OWIwYzg5Li4wY2UxNTUzNzQwMTYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
bGludXgvaW9fdXJpbmdfdHlwZXMuaAorKysgYi9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nX3R5
cGVzLmgKQEAgLTIwOCw2ICsyMDgsNyBAQCBzdHJ1Y3QgaW9fc3VibWl0X3N0YXRlIHsKIAli
b29sCQkJbmVlZF9wbHVnOwogCWJvb2wJCQljcV9mbHVzaDsKIAl1bnNpZ25lZCBzaG9ydAkJ
c3VibWl0X25yOworCXN0cnVjdCBpb19yc3JjX25vZGUJKnJzcmNfbm9kZTsKIAlzdHJ1Y3Qg
YmxrX3BsdWcJCXBsdWc7CiB9OwogCmRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgv
aW9fdXJpbmcuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9pb191cmluZy5oCmluZGV4IGNlNThj
NDU5MGRlNi4uYTdkMGFhZjZkYWY1IDEwMDY0NAotLS0gYS9pbmNsdWRlL3VhcGkvbGludXgv
aW9fdXJpbmcuaAorKysgYi9pbmNsdWRlL3VhcGkvbGludXgvaW9fdXJpbmcuaApAQCAtMjU5
LDYgKzI1OSw3IEBAIGVudW0gaW9fdXJpbmdfb3AgewogCUlPUklOR19PUF9GVFJVTkNBVEUs
CiAJSU9SSU5HX09QX0JJTkQsCiAJSU9SSU5HX09QX0xJU1RFTiwKKwlJT1JJTkdfT1BfTE9D
QUxfQlVGLAogCiAJLyogdGhpcyBnb2VzIGxhc3QsIG9idmlvdXNseSAqLwogCUlPUklOR19P
UF9MQVNULApkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvaW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lv
X3VyaW5nLmMKaW5kZXggM2E1MzVlOWU4YWMzLi5kNTE3ZDZhMGZkMzkgMTAwNjQ0Ci0tLSBh
L2lvX3VyaW5nL2lvX3VyaW5nLmMKKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwpAQCAtMjIw
NSw2ICsyMjA1LDcgQEAgc3RhdGljIHZvaWQgaW9fc3VibWl0X3N0YXRlX2VuZChzdHJ1Y3Qg
aW9fcmluZ19jdHggKmN0eCkKIAkJaW9fcXVldWVfc3FlX2ZhbGxiYWNrKHN0YXRlLT5saW5r
LmhlYWQpOwogCS8qIGZsdXNoIG9ubHkgYWZ0ZXIgcXVldWluZyBsaW5rcyBhcyB0aGV5IGNh
biBnZW5lcmF0ZSBjb21wbGV0aW9ucyAqLwogCWlvX3N1Ym1pdF9mbHVzaF9jb21wbGV0aW9u
cyhjdHgpOworCWlvX3B1dF9yc3JjX25vZGUoc3RhdGUtPnJzcmNfbm9kZSk7CiAJaWYgKHN0
YXRlLT5wbHVnX3N0YXJ0ZWQpCiAJCWJsa19maW5pc2hfcGx1Zygmc3RhdGUtPnBsdWcpOwog
fQpAQCAtMjIyMCw2ICsyMjIxLDcgQEAgc3RhdGljIHZvaWQgaW9fc3VibWl0X3N0YXRlX3N0
YXJ0KHN0cnVjdCBpb19zdWJtaXRfc3RhdGUgKnN0YXRlLAogCXN0YXRlLT5zdWJtaXRfbnIg
PSBtYXhfaW9zOwogCS8qIHNldCBvbmx5IGhlYWQsIG5vIG5lZWQgdG8gaW5pdCBsaW5rX2xh
c3QgaW4gYWR2YW5jZSAqLwogCXN0YXRlLT5saW5rLmhlYWQgPSBOVUxMOworCXN0YXRlLT5y
c3JjX25vZGUgPSByc3JjX2VtcHR5X25vZGU7CiB9CiAKIHN0YXRpYyB2b2lkIGlvX2NvbW1p
dF9zcXJpbmcoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgpCmRpZmYgLS1naXQgYS9pb191cmlu
Zy9vcGRlZi5jIGIvaW9fdXJpbmcvb3BkZWYuYwppbmRleCAzZGU3NWVjYTFjOTIuLmFlMThl
NDAzYTdiYyAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvb3BkZWYuYworKysgYi9pb191cmluZy9v
cGRlZi5jCkBAIC01MTUsNiArNTE1LDEwIEBAIGNvbnN0IHN0cnVjdCBpb19pc3N1ZV9kZWYg
aW9faXNzdWVfZGVmc1tdID0gewogCQkucHJlcAkJCT0gaW9fZW9wbm90c3VwcF9wcmVwLAog
I2VuZGlmCiAJfSwKKwlbSU9SSU5HX09QX0xPQ0FMX0JVRl0gPSB7CisJCS5wcmVwCQkJPSBp
b19sb2NhbF9idWZfcHJlcCwKKwkJLmlzc3VlCQkJPSBpb19sb2NhbF9idWYsCisJfSwKIH07
CiAKIGNvbnN0IHN0cnVjdCBpb19jb2xkX2RlZiBpb19jb2xkX2RlZnNbXSA9IHsKQEAgLTc0
NCw2ICs3NDgsOSBAQCBjb25zdCBzdHJ1Y3QgaW9fY29sZF9kZWYgaW9fY29sZF9kZWZzW10g
PSB7CiAJW0lPUklOR19PUF9MSVNURU5dID0gewogCQkubmFtZQkJCT0gIkxJU1RFTiIsCiAJ
fSwKKwlbSU9SSU5HX09QX0xPQ0FMX0JVRl0gPSB7CisJCS5uYW1lCQkJPSAiTE9DQUxfQlVG
IiwKKwl9LAogfTsKIAogY29uc3QgY2hhciAqaW9fdXJpbmdfZ2V0X29wY29kZSh1OCBvcGNv
ZGUpCmRpZmYgLS1naXQgYS9pb191cmluZy9yc3JjLmMgYi9pb191cmluZy9yc3JjLmMKaW5k
ZXggNmUzMDY3OTE3NWFhLi45NjIxYmE1MzNiMzUgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL3Jz
cmMuYworKysgYi9pb191cmluZy9yc3JjLmMKQEAgLTEwNjksMyArMTA2OSwzMyBAQCBpbnQg
aW9fcmVnaXN0ZXJfY2xvbmVfYnVmZmVycyhzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgdm9p
ZCBfX3VzZXIgKmFyZykKIAkJZnB1dChmaWxlKTsKIAlyZXR1cm4gcmV0OwogfQorCitpbnQg
aW9fbG9jYWxfYnVmX3ByZXAoc3RydWN0IGlvX2tpb2NiICpyZXEsIGNvbnN0IHN0cnVjdCBp
b191cmluZ19zcWUgKnNxZSkKK3sKKwlzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCA9IHJlcS0+
Y3R4OworCXN0cnVjdCBpb19zdWJtaXRfc3RhdGUgKnN0YXRlID0gJmN0eC0+c3VibWl0X3N0
YXRlOworCXN0cnVjdCBwYWdlICpsYXN0X2hwYWdlID0gTlVMTDsKKwlzdHJ1Y3QgaW9fcnNy
Y19ub2RlICpub2RlOworCXN0cnVjdCBpb3ZlYyBpb3Y7CisJX191NjQgdGFnOworCisJaWYg
KHN0YXRlLT5yc3JjX25vZGUgIT0gcnNyY19lbXB0eV9ub2RlKQorCQlyZXR1cm4gLUVCVVNZ
OworCisJaW92Lmlvdl9iYXNlID0gdTY0X3RvX3VzZXJfcHRyKFJFQURfT05DRShzcWUtPmFk
ZHIpKTsKKwlpb3YuaW92X2xlbiA9IFJFQURfT05DRShzcWUtPmxlbik7CisJdGFnID0gUkVB
RF9PTkNFKHNxZS0+YWRkcjIpOworCisJbm9kZSA9IGlvX3NxZV9idWZmZXJfcmVnaXN0ZXIo
Y3R4LCAmaW92LCAmbGFzdF9ocGFnZSk7CisJaWYgKElTX0VSUihub2RlKSkKKwkJcmV0dXJu
IFBUUl9FUlIobm9kZSk7CisKKwlub2RlLT50YWcgPSB0YWc7CisJc3RhdGUtPnJzcmNfbm9k
ZSA9IG5vZGU7CisJcmV0dXJuIDA7Cit9CisKK2ludCBpb19sb2NhbF9idWYoc3RydWN0IGlv
X2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFncykKK3sKKwlyZXR1cm4gSU9V
X09LOworfQpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvcnNyYy5oIGIvaW9fdXJpbmcvcnNyYy5o
CmluZGV4IGM5ZjQyNDkxYzc0Ny4uYmU5YjQ5MGM0MDBlIDEwMDY0NAotLS0gYS9pb191cmlu
Zy9yc3JjLmgKKysrIGIvaW9fdXJpbmcvcnNyYy5oCkBAIC0xNDEsNCArMTQxLDcgQEAgc3Rh
dGljIGlubGluZSB2b2lkIF9faW9fdW5hY2NvdW50X21lbShzdHJ1Y3QgdXNlcl9zdHJ1Y3Qg
KnVzZXIsCiAJYXRvbWljX2xvbmdfc3ViKG5yX3BhZ2VzLCAmdXNlci0+bG9ja2VkX3ZtKTsK
IH0KIAoraW50IGlvX2xvY2FsX2J1Zl9wcmVwKHN0cnVjdCBpb19raW9jYiAqcmVxLCBjb25z
dCBzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUpOworaW50IGlvX2xvY2FsX2J1ZihzdHJ1Y3Qg
aW9fa2lvY2IgKnJlcSwgdW5zaWduZWQgaW50IGlzc3VlX2ZsYWdzKTsKKwogI2VuZGlmCi0t
IAoyLjQ1LjIKCg==
--------------4Ma6l89VyTyktPSc2NjK3K2p
Content-Type: text/x-csrc; charset=UTF-8; name="local-buf.c"
Content-Disposition: attachment; filename="local-buf.c"
Content-Transfer-Encoding: base64

LyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IE1JVCAqLwojaW5jbHVkZSA8ZXJybm8uaD4K
I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHVuaXN0
ZC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KCiNpbmNsdWRl
ICJsaWJ1cmluZy5oIgojaW5jbHVkZSAiaGVscGVycy5oIgoKaW50IG1haW4oaW50IGFyZ2Ms
IGNoYXIgKmFyZ3ZbXSkKewoJc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlOwoJc3RydWN0IGlv
X3VyaW5nX2NxZSAqY3FlOwoJc3RydWN0IGlvX3VyaW5nIHJpbmc7Cgl2b2lkICpidWZmZXI7
CglpbnQgcmV0LCBpbl9mZCwgb3V0X2ZkLCBpOwoJY2hhciBidWZyWzY0XSwgYnVmd1s2NF07
CgoJaWYgKHBvc2l4X21lbWFsaWduKCZidWZmZXIsIDQwOTYsIDQwOTYpKQoJCXJldHVybiAx
OwoKCXByaW50ZigiYnVmZmVyICVwXG4iLCBidWZmZXIpOwoKCXNwcmludGYoYnVmciwgIi5s
b2NhbC1idWYtcmVhZC4lZFxuIiwgZ2V0cGlkKCkpOwoJdF9jcmVhdGVfZmlsZV9wYXR0ZXJu
KGJ1ZnIsIDQwOTYsIDB4NWEpOwoKCXNwcmludGYoYnVmdywgIi5sb2NhbC1idWYtd3JpdGUu
JWRcbiIsIGdldHBpZCgpKTsKCXRfY3JlYXRlX2ZpbGVfcGF0dGVybihidWZ3LCA0MDk2LCAw
eDAwKTsKCglpbl9mZCA9IG9wZW4oYnVmciwgT19SRE9OTFkgfCBPX0RJUkVDVCk7CglpZiAo
aW5fZmQgPCAwKSB7CgkJcGVycm9yKCJvcGVuIik7CgkJcmV0dXJuIDE7Cgl9CgoJb3V0X2Zk
ID0gb3BlbihidWZ3LCBPX1dST05MWSB8IE9fRElSRUNUKTsKCWlmIChvdXRfZmQgPCAwKSB7
CgkJcGVycm9yKCJvcGVuIik7CgkJcmV0dXJuIDE7Cgl9CgoJaW9fdXJpbmdfcXVldWVfaW5p
dCg4LCAmcmluZywgSU9SSU5HX1NFVFVQX1NJTkdMRV9JU1NVRVIgfCBJT1JJTkdfU0VUVVBf
REVGRVJfVEFTS1JVTik7CgoJLyogYWRkIGxvY2FsIGJ1ZiAqLwoJc3FlID0gaW9fdXJpbmdf
Z2V0X3NxZSgmcmluZyk7Cglpb191cmluZ19wcmVwX3J3KElPUklOR19PUF9MT0NBTF9CVUYs
IHNxZSwgMCwgYnVmZmVyLCA0MDk2LCAodW5zaWduZWQgbG9uZykgYnVmZmVyKTsKCXNxZS0+
dXNlcl9kYXRhID0gMTsKCglzcWUgPSBpb191cmluZ19nZXRfc3FlKCZyaW5nKTsKCWlvX3Vy
aW5nX3ByZXBfcmVhZF9maXhlZChzcWUsIGluX2ZkLCBidWZmZXIsIDQwOTYsIDAsIDApOwoJ
c3FlLT5mbGFncyB8PSBJT1NRRV9JT19MSU5LOwoJc3FlLT51c2VyX2RhdGEgPSAyOwoKCXNx
ZSA9IGlvX3VyaW5nX2dldF9zcWUoJnJpbmcpOwoJaW9fdXJpbmdfcHJlcF93cml0ZV9maXhl
ZChzcWUsIG91dF9mZCwgYnVmZmVyLCA0MDk2LCAwLCAwKTsKCXNxZS0+dXNlcl9kYXRhID0g
MzsKCQoJcmV0ID0gaW9fdXJpbmdfc3VibWl0KCZyaW5nKTsKCWlmIChyZXQgIT0gMykgewoJ
CWZwcmludGYoc3RkZXJyLCAic3VibWl0OiAlZFxuIiwgcmV0KTsKCQlyZXR1cm4gMTsKCX0K
Cglmb3IgKGkgPSAwOyBpIDwgNDsgaSsrKSB7CgkJcmV0ID0gaW9fdXJpbmdfd2FpdF9jcWUo
JnJpbmcsICZjcWUpOwoJCWlmIChyZXQpIHsKCQkJZnByaW50ZihzdGRlcnIsICJ3YWl0OiAl
ZFxuIiwgcmV0KTsKCQkJcmV0dXJuIDE7CgkJfQoJCXByaW50ZigicmVzPSVkLCB1ZD0weCVs
eFxuIiwgY3FlLT5yZXMsIChsb25nKSBjcWUtPnVzZXJfZGF0YSk7CgkJaW9fdXJpbmdfY3Fl
X3NlZW4oJnJpbmcsIGNxZSk7Cgl9CgoJcmV0dXJuIDA7Cn0K

--------------4Ma6l89VyTyktPSc2NjK3K2p--

