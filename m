Return-Path: <io-uring+bounces-13474-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uN4sGQOgDmoMAwYAu9opvQ
	(envelope-from <io-uring+bounces-13474-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 08:02:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B4859F47E
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 08:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 17F423021587
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 06:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9862829B78B;
	Thu, 21 May 2026 06:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oz3vridQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2FA2F872
	for <io-uring@vger.kernel.org>; Thu, 21 May 2026 06:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779343359; cv=pass; b=uyOZni5utzaVj5+kjCsSk2VQjIP5okJuvtus2ZyCwitX2Fytnu9dED1U7LRzdLUmPtscHh8WElwKij9Mtb721ofTP53B65CB5CzKTmIxhtEGlvtFZzyN72RPb9K3ZBZ52iDLWP6CIq4+bH9hlFRMVyC4ARCqiIZoSGiv+5Ev2SQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779343359; c=relaxed/simple;
	bh=on0ILn0KS9qHDvRs4SbpRKmIFYpuvVVWnJeX+tTtIPc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=swJN04Q2sXaPwdfkMyHDylh/nVynDiMSwtk5Yy4G0dIirr78n4/M/cdC0HTVBPuykLLcWurpMxQNa/NepQLm2C3N3H2jfE7fX9go/qvyV2xVrKD9LPy9RgLP9FVfrGDLbOUWpCEl8rGqpDp2mJJ/YEoq9p4+CVZqiITukZcN0KU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oz3vridQ; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51306c36c3eso65240181cf.0
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 23:02:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779343357; cv=none;
        d=google.com; s=arc-20240605;
        b=eCJsFcyYnWn6rPoEZ5ZoQ6d/qDO+2YxgVYAD0pwbhufOIltIjviq0bTRyTIaN+l8P4
         ixG2QTWvuJDdFJtS4Dy9Y7Z9CmDszO/N5TwvISvy7ICT0Ts6fzy/On0QH4bilEUSESMk
         JtBbiwxlIBuyZvnsmWSyyjL0HJCa+ySD4R+qzsm6S5dpSSZhCf9QRknBCKgf9S8Fq4dQ
         a2tBFft0ybEYBB6ls/hbwovFtsSx1q5anzHmhRi0Bi9l+jkovQ0yMPQC13X50iSmytw5
         tnvcA/PxrlDp4CNcPt6PcFdbYBLubT1Z8vHEcXRuca7CVGvSfJZZqZ+x+blYPlHF30Po
         iFNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=on0ILn0KS9qHDvRs4SbpRKmIFYpuvVVWnJeX+tTtIPc=;
        fh=8ki2b6xPemKHbZmg2nTwfTzGf/Hpa0Bq6a7IZTCWDZQ=;
        b=lbSrDvv0cMQ5hiSgNOF1+A0Otw3FHnP4ZvCjjgJpB4cdSsAOE8ZA75/MCj3j2+WJq2
         0lW2W4Qx0bedoeTGa9zy0bCqtDpUMyD4jg0M/op7aSYkoYH+3FdxryXgiuAfbdGQd/7f
         85Jo1sJ5TOJaQCl8LFDnXtgnOICDRPXky+nlwryyRY4wjHz8jPxqwOnfKulGduSKFdya
         Az5MwZeumeMFUhYCU/L07Tx0+DldYEVeQ7eRJO+lKY+plc5AlM9jG6D1Gxn4zDlQiBq0
         CkfX263mXCAbVeB1EdtHYrjRz1Ayq9pIXI/QvUY3afSsYt5yjzgO6gszn9v4JjXf/dYw
         CK4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779343357; x=1779948157; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=on0ILn0KS9qHDvRs4SbpRKmIFYpuvVVWnJeX+tTtIPc=;
        b=oz3vridQx82QLxbGYxfezAXkxRE8te3/vQSma67RzFDRVa059t4qnnSuGETw1amsMj
         y+sYXZhvAdMzY0OmJDt4dbO9veGgaD379N96Lza+SX5vnT9HdP7mUNnNPtDwKmM/aGD2
         u5Kuod7NLnHKeZnlZBDd/o/YbkMIP9R9VrPkQNDXLHAuWcOlZJyMnx6N2QiKtM1NZjhJ
         nFyuYI7EkKMh8t6xv/36ZtaP/DV6UW9Lq74yonBBbDZDSWVazG18/UGlgtHGHj269b+/
         TcPQMxbivTpzx+IBj1dTdLmqxnLJ1LPu1aa0AWHlYH6IefRd3RNmIhzyFRi49GAd63i6
         XhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779343357; x=1779948157;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=on0ILn0KS9qHDvRs4SbpRKmIFYpuvVVWnJeX+tTtIPc=;
        b=rXCDT2KvbLNpJM13IH1WEx3OR/GZRXQ/GOqzRYFh51EvQJ1aeCJL74LQdNKNJkeNF5
         MfFpPKRKNsGpz4ftvxURGUqMBWCT2yvFfLq60ylNvFJaC7VZSER1XFoh/DgMN6H0bNHJ
         g80pguLVhAcLE0SnUYBqoY/jsLY40GL3zpoxUKfxN3GoFU6W7A7M0Z8qqLdYBgtMVTi0
         MmHr6w0JaF5E1CDxvYTDieLK0ei9H8dgbIk9R4eTa0W9HRedtMHmh1TZDc5hd7yA4EBT
         2nvTh9Yn1nCwvg2iBLb0u/cFLfHG/MazldU9Vz+o7bmDx7K0Fg0k0qRTtbcoJH6sEH3B
         z1Aw==
X-Gm-Message-State: AOJu0YwKeRc2HyDdBtslVhjnGdXdNu6z6t74nBjIHN5htsGGvYbRbTjc
	8QuQqvRkt4KGT+mw7vZALH4xj+gxCcIvhpEK0J8NCtjQpiScFHoaQ6/rr+JnU1nEYNL7npUpoLY
	blt1Fbg2jexo0M20f/J8v6jPJ2nb0iRT825WT
X-Gm-Gg: Acq92OFLAVglRASe/oQR4MZm0sU5qiXFDT8kZxOSAVc3puTcq9zIciJs98s61OnIOnv
	S0euqW41M2BM0PTXLWpbYxSQ9e0h2Zxsx/ixFD6tE3GElIboZJjxi+2lWL4S49sut4B4JTidZIR
	URxEsqmf7reRGfd+igFtOjpJ2FIaCMw9KOSAZpxudXvfNODYhdU6e2Hd5jVimqzq/ioB/GNHO2H
	kHWbtEAI+/vWn5rhex4+4lQggOQLDs/akLprczeMpPbErEF+uAGgVvV9iNUg439KyBGNttEPvXY
	oHAnJzZlTZwVZDZoAAld9W4Q/FaW3T2bVD0bVsc=
X-Received: by 2002:ac8:6905:0:b0:50d:8050:a358 with SMTP id
 d75a77b69052e-516c55f62dcmr20685541cf.47.1779343356868; Wed, 20 May 2026
 23:02:36 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 21 May 2026 06:02:35 +0000
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 20 May 2026 23:02:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: JUNYI LIU <moss80199@gmail.com>
Date: Thu, 21 May 2026 06:02:35 +0000
X-Gm-Features: AVHnY4Jh3ywDiZJ-D18NSAuV6KvVAQujnWOeNsuer4Wwz3747sDspAsyHVbhz3A
Message-ID: <CADxpCqA4jsObAAgJRcSk2jh-X-VSyVQguk3hAV4_ntO8R5XrQw@mail.gmail.com>
Subject: io_uring MSG_RING SEND_FD skips file_receive LSM hook
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000b8af1b06524da8aa"
X-Spamd-Result: default: False [-1.06 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,multipart/alternative,text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13474-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[gmail.com:+];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:~,4:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[moss80199@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 09B4859F47E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

--000000000000b8af1b06524da8aa
Content-Type: multipart/alternative; boundary="000000000000b8af1a06524da8a8"

--000000000000b8af1a06524da8a8
Content-Type: text/plain; charset="UTF-8"

Hello,

I found that io_uring IORING_MSG_SEND_FD can install a registered file from
a source ring into a target ring fixed-file table without invoking the
security_file_receive() LSM hook used by classic fd receive paths.

I reproduced this in a disposable kernel lab with a BPF-LSM file_receive
deny policy: SCM_RIGHTS receipt was blocked and incremented the
file_receive counter, while MSG_RING SEND_FD installed the same file for a
lower-privileged receiver and did not increment the counter.

The attached plain-text report includes the affected path, tested versions,
observed result, claim boundary, and suggested fix direction. A tested
reproducer is available if you would like me to send it.

This report was prepared with AI assistance.

Regards,
JUNYI LIU

--000000000000b8af1a06524da8a8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<p>Hello,</p>
<p>I found that io_uring IORING_MSG_SEND_FD can install a registered file f=
rom a source ring into a target ring fixed-file table without invoking the =
security_file_receive() LSM hook used by classic fd receive paths.</p>
<p>I reproduced this in a disposable kernel lab with a BPF-LSM file_receive=
 deny policy: SCM_RIGHTS receipt was blocked and incremented the file_recei=
ve counter, while MSG_RING SEND_FD installed the same file for a lower-priv=
ileged receiver and did not increment the counter.</p>
<p>The attached plain-text report includes the affected path, tested versio=
ns, observed result, claim boundary, and suggested fix direction. A tested =
reproducer is available if you would like me to send it.</p>
<p>This report was prepared with AI assistance.</p>
<p>Regards,<br>
JUNYI LIU</p>

--000000000000b8af1a06524da8a8--
--000000000000b8af1b06524da8aa
Content-Type: text/plain; charset="US-ASCII"; name="report.txt"
Content-Disposition: attachment; filename="report.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: 33778eb862ac9e57_0.1

U3ViamVjdDogaW9fdXJpbmcgTVNHX1JJTkcgU0VORF9GRCBza2lwcyBzZWN1cml0eV9maWxlX3Jl
Y2VpdmUoKSBmb3IgdGFyZ2V0IGZpeGVkLWZpbGUgaW5zdGFsbGF0aW9uCgpSZXBvcnRlcjogSlVO
WUkgTElVCgpTdW1tYXJ5CgpJT1JJTkdfTVNHX1NFTkRfRkQgY2FuIHRyYW5zZmVyIGEgcmVnaXN0
ZXJlZCBmaWxlIGZyb20gYSBzb3VyY2UgaW9fdXJpbmcgaW50bwphIHRhcmdldCBpb191cmluZyBm
aXhlZC1maWxlIHRhYmxlIHdpdGhvdXQgaW52b2tpbmcgc2VjdXJpdHlfZmlsZV9yZWNlaXZlKCku
CkNsYXNzaWMgZmQgcmVjZWl2ZSBwYXRocyBzdWNoIGFzIFNDTV9SSUdIVFMgY2FsbCByZWNlaXZl
X2ZkKCksIGFuZCByZWNlaXZlX2ZkKCkKY2FsbHMgc2VjdXJpdHlfZmlsZV9yZWNlaXZlKGZpbGUp
IGJlZm9yZSBwdWJsaXNoaW5nIHRoZSByZWNlaXZlZCBmaWxlLiBDdXJyZW50Ck1TR19SSU5HIFNF
TkRfRkQgaW5zdGVhZCBjYWxscyBfX2lvX2ZpeGVkX2ZkX2luc3RhbGwoKSBkaXJlY3RseSBvbiB0
aGUgdGFyZ2V0CnJpbmcgZml4ZWQtZmlsZSB0YWJsZS4KClRoaXMgY3JlYXRlcyBhbiBMU00gbWVk
aWF0aW9uIGdhcCBmb3IgYXBwbGljYXRpb25zIHRoYXQgdXNlIGlvX3VyaW5nIE1TR19SSU5HClNF
TkRfRkQgZm9yIHRoZSBzYW1lIGZkLXBhc3NpbmcgdXNlIGNhc2VzIGFzIFNDTV9SSUdIVFMuIElu
IGEgbGl2ZSBsb2NhbCBsYWIsCmEgQlBGLUxTTSBmaWxlX3JlY2VpdmUgZGVueSBwb2xpY3kgYmxv
Y2tlZCBjbGFzc2ljIFNDTV9SSUdIVFMgcmVjZWlwdCBmb3IgYQpsb3dlci1wcml2aWxlZ2VkIHJl
Y2VpdmVyLCBidXQgdGhlIHNhbWUgcmVjZWl2ZXIgY291bGQgcmVhZCB0aGUgcHJvdGVjdGVkIGZp
bGUKYWZ0ZXIgTVNHX1JJTkcgU0VORF9GRCBpbnN0YWxsZWQgaXQgaW50byB0aGUgcmVjZWl2ZXIn
cyB0YXJnZXQgcmluZyBmaXhlZC1maWxlCnNsb3QuCgpBZmZlY3RlZCBjb2RlIHBhdGgKClRlc3Rl
ZCBzb3VyY2UgY29tbWl0Ogo2OTE2ZDU3MDNkZGY5YTM4ZjFmNmMyY2M3OTMzODFhMjRlZTkxNGM2
CgpSdW50aW1lIHJlcHJvZHVjdGlvbiBrZXJuZWw6CkxpbnV4IDYuMS4wLTQ4LWNsb3VkLWFtZDY0
LCBEZWJpYW4gNi4xLjE3Mi0xCgpUaGUgaXNzdWUgYXBwZWFycyB0byBiZSBwcmVzZW50IGZyb20g
dGhlIGludHJvZHVjdGlvbiBvZiBmaXhlZC1maWxlIHBhc3Npbmc6CmU2MTMwZWJhOGE4NDhhN2E2
YmE2YzUzNGJkOGY2ZDYwNzQ5YWUxYTkKaW9fdXJpbmc6IGFkZCBzdXBwb3J0IGZvciBwYXNzaW5n
IGZpeGVkIGZpbGUgZGVzY3JpcHRvcnMKClJlbGV2YW50IGN1cnJlbnQgc291cmNlIGJlaGF2aW9y
OgoKLSBmcy9maWxlLmMgcmVjZWl2ZV9mZCgpIGNhbGxzIHNlY3VyaXR5X2ZpbGVfcmVjZWl2ZShm
aWxlKS4KLSBmcy9maWxlLmMgcmVjZWl2ZV9mZF9yZXBsYWNlKCkgYWxzbyBjYWxscyBzZWN1cml0
eV9maWxlX3JlY2VpdmUoZmlsZSkuCi0gaW9fdXJpbmcvb3BlbmNsb3NlLmMgaW9faW5zdGFsbF9m
aXhlZF9mZCgpIGNhbGxzIHJlY2VpdmVfZmQoKS4KLSBpb191cmluZy9tc2dfcmluZy5jIGlvX21z
Z19pbnN0YWxsX2NvbXBsZXRlKCkgY2FsbHMKICBfX2lvX2ZpeGVkX2ZkX2luc3RhbGwodGFyZ2V0
X2N0eCwgc3JjX2ZpbGUsIG1zZy0+ZHN0X2ZkKSBkaXJlY3RseS4KLSBpb191cmluZy9tc2dfcmlu
Zy5jIGlvX21zZ19zZW5kX2ZkKCkgcmVhY2hlcyBpb19tc2dfaW5zdGFsbF9jb21wbGV0ZSgpCiAg
ZWl0aGVyIGRpcmVjdGx5IG9yIHRocm91Z2ggdGFyZ2V0IHRhc2sgd29yaywgZGVwZW5kaW5nIG9u
IHRhcmdldCByaW5nIGZsYWdzLgoKU2VjdXJpdHkgaW52YXJpYW50CgpUaGUgbWlzc2luZyBob29r
IG1hdHRlcnMgYmVjYXVzZSB0aGUga2VybmVsIGFscmVhZHkgdHJlYXRzIHJlY2VpdmluZyBhbiBv
cGVuCmZpbGUgYXMgYSBzZWN1cml0eS1yZWxldmFudCBvcGVyYXRpb246CgotIHNlY3VyaXR5X2Zp
bGVfcmVjZWl2ZSgpIGlzIGRvY3VtZW50ZWQgYXMgY2hlY2tpbmcgd2hldGhlciBhIHByb2Nlc3Mg
bWF5CiAgcmVjZWl2ZSBhbiBvcGVuIGZpbGUgZGVzY3JpcHRvciB2aWEgSVBDLgotIHJlY2VpdmVf
ZmQoKSBhbmQgcmVjZWl2ZV9mZF9yZXBsYWNlKCkgYm90aCBjYWxsIHRoYXQgaG9vayBiZWZvcmUg
aW5zdGFsbGluZwogIHJlY2VpdmVkIGZpbGVzLgotIFRoZSB1cHN0cmVhbSBmaXhlZC1mZC1pbnN0
YWxsIGhhcmRlbmluZyBjb21taXQKICAxNmJhZTNlMTM3Nzg0NjczNGVjNmI4N2VlZTQ1OWMwZjM1
NTE2OTJjIHNheXMgdGhlIGNyZWRlbnRpYWxzIHVzZWQgZm9yCiAgc2VjdXJpdHlfZmlsZV9yZWNl
aXZlKCkgYXJlIHNlY3VyaXR5IHJlbGV2YW50IHdoZW4gYW4gaW9fdXJpbmctcHJpdmF0ZSBmaWxl
CiAgZGVzY3JpcHRvciBpcyBtYWRlIGFjY2Vzc2libGUgdG8gYSB1c2Vyc3BhY2UgdGFzay4KLSBU
aGUgb3JpZ2luYWwgSU9SSU5HX01TR19TRU5EX0ZEIGNvbW1pdCBkZXNjcmliZXMgdGhlIGZlYXR1
cmUgYXMgc3VwcG9ydGluZwogIGNsYXNzaWMgU0NNX1JJR0hUUyB1c2UgY2FzZXMuCgpPYnNlcnZl
ZCBiZWhhdmlvcgoKVGhlIHJlcHJvZHVjZXIgdXNlZCBhIGRpc3Bvc2FibGUgUUVNVSBndWVzdCB3
aXRoIGEgQlBGLUxTTSBwcm9ncmFtIGF0dGFjaGVkIHRvCmxzbS9maWxlX3JlY2VpdmUuIFRoZSBC
UEYtTFNNIHByb2dyYW0gZGVuaWVkIGV2ZXJ5IGZpbGVfcmVjZWl2ZSBvcGVyYXRpb24gYW5kCmlu
Y3JlbWVudGVkIGEgY291bnRlciB3aGVuZXZlciB0aGUgaG9vayByYW4uCgpUaGUgbGl2ZSBydW4g
dXNlZCBhIGxvd2VyLXByaXZpbGVnZWQgcmVjZWl2ZXIgd2l0aCB1aWQvZ2lkIDY1NTM0LiBUaGUg
cmVjZWl2ZXIKY291bGQgbm90IG9wZW4gdGhlIHJvb3Qtb3duZWQgMDYwMCBzZWNyZXQgcGF0aCBk
aXJlY3RseS4gQ2xhc3NpYyBTQ01fUklHSFRTCnNlbmQgZnJvbSB0aGUgaGlnaGVyLXByaXZpbGVn
ZWQgcHJvY2VzcyBjb21wbGV0ZWQgb24gdGhlIHNlbmRlciBzaWRlLCBidXQgdGhlCnJlY2VpdmVy
IGRpZCBub3Qgb2J0YWluIGEgdXNhYmxlIGZkIHVuZGVyIHRoZSBmaWxlX3JlY2VpdmUgZGVueSBw
b2xpY3kuIFRoZQpCUEYgY291bnRlciBpbmNyZW1lbnRlZCBhZnRlciB0aGF0IFNDTV9SSUdIVFMg
cmVjZWl2ZSBhdHRlbXB0LgoKSW4gdGhlIHNhbWUgcnVuLCBJT1JJTkdfTVNHX1NFTkRfRkQgc3Vj
Y2Vzc2Z1bGx5IGluc3RhbGxlZCB0aGUgc2FtZSBvcGVuIGZpbGUKaW50byB0aGUgcmVjZWl2ZXIn
cyB0YXJnZXQgcmluZyBmaXhlZC1maWxlIHRhYmxlLiBUaGUgcmVjZWl2ZXIgdGhlbiByZWFkIHRo
ZQpzZWNyZXQgdGhyb3VnaCBJT1NRRV9GSVhFRF9GSUxFLiBUaGUgQlBGIGNvdW50ZXIgZGlkIG5v
dCBpbmNyZW1lbnQgZHVyaW5nIHRoZQpNU0dfUklORyBTRU5EX0ZEIHRyYW5zZmVyLgoKS2V5IG91
dHB1dCBmcm9tIHRoZSBsaXZlIHJ1bjoKCkJQRl9MU01fRklMRV9SRUNFSVZFX0RFTllfQVRUQUNI
RUQKQ09VTlRFUl9BRlRFUl9BVFRBQ0ggZmlsZV9yZWNlaXZlX2NvdW50PTAKQ1JPU1NfVUlEX1ND
TV9SSUdIVFNfU0VORF9SRVNVTFQ9MSBlcnJubz0wCnJlY2VpdmVyX3VpZD02NTUzNCByZWNlaXZl
cl9vcGVuX3NlY3JldF9lcnJubz0xMwpDUk9TU19VSURfU0NNX1JJR0hUU19SRUNWX1JFU1VMVCBm
ZD0tMiBlcnJubz0yCkNPVU5URVJfQUZURVJfU0NNX1JJR0hUUyBmaWxlX3JlY2VpdmVfY291bnQ9
MQpDUk9TU19VSURfTVNHX1JJTkdfU0VORF9GRF9SRVNVTFQ9MApDUk9TU19VSURfVEFSR0VUX01T
R19SSU5HX05PVElGWV9SRVNVTFQ9MApDUk9TU19VSURfVEFSR0VUX0ZJWEVEX1JFQURfUkVTVUxU
PTI3IGRhdGE9UFIwMzJfQ1JPU1NfVUlEX0xTTV9TRUNSRVQKUFIwMzJfQ1JPU1NfVUlEX0JQRl9M
U01fTVNHX1JJTkdfQllQQVNTX09SQUNMRQpDT1VOVEVSX0FGVEVSX01TR19SSU5HIGZpbGVfcmVj
ZWl2ZV9jb3VudD0xCgpJbnRlcnByZXRhdGlvbgoKU0NNX1JJR0hUUyBhbmQgTVNHX1JJTkcgU0VO
RF9GRCB3ZXJlIGV4ZXJjaXNlZCBpbiB0aGUgc2FtZSBndWVzdCB1bmRlciB0aGUgc2FtZQpmaWxl
X3JlY2VpdmUgZGVueSBwb2xpY3kuCgpUaGUgU0NNX1JJR0hUUyBjb250cm9sIHNob3dzIHRoYXQg
dGhlIExTTSBob29rIHdhcyBhY3RpdmUgYW5kIHRoYXQgdGhlCnJlY2VpdmVyIGRpZCBub3Qgb2J0
YWluIGEgdXNhYmxlIHJlY2VpdmVkIGZkLgoKVGhlIE1TR19SSU5HIFNFTkRfRkQgcGF0aCBzaG93
cyB0aGF0IHRoZSB0YXJnZXQgZml4ZWQtZmlsZSBpbnN0YWxsYXRpb24gZGlkCm5vdCBpbnZva2Ug
ZmlsZV9yZWNlaXZlIGFuZCBzdGlsbCBnYXZlIHRoZSBsb3dlci1wcml2aWxlZ2VkIHJlY2VpdmVy
IHVzYWJsZQpvcGVuLWZpbGUgYXV0aG9yaXR5LgoKU2VjdXJpdHkgaW1wYWN0CgpUaGlzIGlzIG5v
dCBhIG1lbW9yeSBjb3JydXB0aW9uIGJ1ZyBhbmQgSSBhbSBub3QgY2xhaW1pbmcgYW4gYXJiaXRy
YXJ5IHJvb3QKc2hlbGwgb3IgZ2VuZXJpYyBsb2NhbCBwcml2aWxlZ2UgZXNjYWxhdGlvbi4KClRo
ZSBzZWN1cml0eSBpbXBhY3QgaXMgYSByZWNlaXZlLXNpZGUgTFNNIG1lZGlhdGlvbiBieXBhc3Mg
Zm9yIGlvX3VyaW5nCmZpeGVkLWZpbGUgcGFzc2luZy4gSWYgYW4gYXBwbGljYXRpb24gb3IgYnJv
a2VyIHVzZXMgSU9SSU5HX01TR19TRU5EX0ZEIGFzIGFuClNDTV9SSUdIVFMtc3R5bGUgZmQtcGFz
c2luZyBtZWNoYW5pc20sIHRoZSByZWNlaXZpbmcgdGFzayBjYW4gb2J0YWluIHVzYWJsZQpvcGVu
LWZpbGUgYXV0aG9yaXR5IHRocm91Z2ggYSB0YXJnZXQgaW9fdXJpbmcgZml4ZWQgc2xvdCBldmVu
IHdoZW4gdGhlIGFjdGl2ZQpMU00gcG9saWN5IHdvdWxkIGRlbnkgY2xhc3NpYyBmZCByZWNlaXB0
IHRocm91Z2ggc2VjdXJpdHlfZmlsZV9yZWNlaXZlKCkuCgpUaGUgbGFiIHVzZWQgQlBGLUxTTSBi
ZWNhdXNlIGl0IHByb3ZpZGVzIGEgbmFycm93LCBkZXRlcm1pbmlzdGljIGxpdmUgb3JhY2xlLgpJ
IGhhdmUgbm90IHJlcGxheWVkIGEgZnVsbCBTRUxpbnV4LCBBcHBBcm1vciwgb3IgU21hY2sgcG9s
aWN5IHByb2ZpbGUsIHNvIEkgYW0Kbm90IGNsYWltaW5nIHBvbGljeS1zcGVjaWZpYyBpbXBhY3Qg
Zm9yIHRob3NlIExTTXMgYmV5b25kIHRoZSBzaGFyZWQgbWlzc2luZwpmaWxlX3JlY2VpdmUgaG9v
ay4KClN1Z2dlc3RlZCBmaXggZGlyZWN0aW9uCgpUaGUgZml4IHNob3VsZCBtYWtlIElPUklOR19N
U0dfU0VORF9GRCBlbmZvcmNlIHRoZSBzYW1lIHJlY2VpdmUtc2lkZSBzZWN1cml0eQpkZWNpc2lv
biBhcyBvdGhlciBmZCByZWNlaXZlIHBhdGhzIGJlZm9yZSBpbnN0YWxsaW5nIHRoZSBmaWxlIGlu
dG8gdGhlIHRhcmdldApyaW5nIGZpeGVkLWZpbGUgdGFibGUuCgpUaGUgbWFpbiBzdWJ0bGV0eSBp
cyBjcmVkZW50aWFsIGNvbnRleHQuIEZvciB0YXJnZXQgcmluZ3MgdGhhdCB1c2UgZGVmZXJyZWQK
dGFzayB3b3JrLCB0aGUgY2hlY2sgc2hvdWxkIHJ1biB3aXRoIHRoZSBpbnRlbmRlZCByZWNlaXZl
ciB0YXNrIGNvbnRleHQuIEZvcgpkaXJlY3QgaW5zdGFsbGF0aW9uIHBhdGhzLCB0aGUga2VybmVs
IGxpa2VseSBuZWVkcyBlaXRoZXIgYSByZWNlaXZlci1jb250ZXh0CnJ1bGUsIGEgZm9yY2VkIHRh
cmdldC10YXNrIGluc3RhbGxhdGlvbiBwYXRoIHdoZW4gYXZhaWxhYmxlLCBvciByZWplY3Rpb24g
b2YKY3Jvc3MtdGFzayBTRU5EX0ZEIGNhc2VzIHdoZXJlIHRoZSBjb3JyZWN0IHJlY2VpdmVyIGNy
ZWRlbnRpYWwgY29udGV4dCBjYW5ub3QKYmUgaWRlbnRpZmllZC4KCkEgcmVncmVzc2lvbiB0ZXN0
IHNob3VsZCBpbmNsdWRlOgoKLSBhbiBMU00gZmlsZV9yZWNlaXZlIGRlbnkgcG9saWN5IHdpdGgg
YSB2aXNpYmxlIGNvdW50ZXI7Ci0gYSBjbGFzc2ljIFNDTV9SSUdIVFMgY29udHJvbCB0aGF0IHRy
aWdnZXJzIHRoZSBob29rIGFuZCBkZW5pZXMgcmVjZWlwdDsKLSBhbiBJT1JJTkdfTVNHX1NFTkRf
RkQgYXR0ZW1wdCBpbnRvIGEgdGFyZ2V0IGZpeGVkLWZpbGUgc2xvdDsKLSB2ZXJpZmljYXRpb24g
dGhhdCB0aGUgdGFyZ2V0IGNhbm5vdCBjb25zdW1lIHRoZSBmaXhlZCBzbG90IGFmdGVyIHRoZSBm
aXguCgpSZXByb2R1Y2VyIHN0YXR1cwoKQSB0ZXN0ZWQgcmVwcm9kdWNlciBpcyBhdmFpbGFibGUu
IEkgZGlkIG5vdCBhdHRhY2ggaXQgaW4gdGhpcyBmaXJzdCBtZXNzYWdlCmJlY2F1c2UgdGhlIHJl
cG9ydCB3YXMgcHJlcGFyZWQgd2l0aCBBSSBhc3Npc3RhbmNlIGFuZCB0aGUgaW5pdGlhbCBjb250
YWN0IGlzCmJlaW5nIGtlcHQgdG8gYSBzaG9ydCBwbGFpbi10ZXh0IGVtYWlsIHBsdXMgYSBub24t
cnVubmFibGUgdGVjaG5pY2FsIHJlcG9ydC4KSSBjYW4gc2VuZCB0aGUgcmVwcm9kdWNlciBpZiB5
b3Ugd291bGQgbGlrZSB0byByZXZpZXcgaXQuCgpQcmlvci1hcnQgY2hlY2sKCkkgY2hlY2tlZCBs
b2NhbCB1cHN0cmVhbSBoaXN0b3J5IGFuZCBwdWJsaWMgc2VhcmNoIHRlcm1zIGFyb3VuZDoKCi0g
SU9SSU5HX01TR19TRU5EX0ZECi0gTVNHX1JJTkcgU0VORF9GRAotIHNlY3VyaXR5X2ZpbGVfcmVj
ZWl2ZQotIGZpbGVfcmVjZWl2ZQotIElPUklOR19PUF9GSVhFRF9GRF9JTlNUQUxMCgpJIGZvdW5k
IG5lYXJieSBoaXN0b3J5IGZvciBJT1JJTkdfTVNHX1NFTkRfRkQgYW5kIGZvciB0aGUgMjAyNApJ
T1JJTkdfT1BfRklYRURfRkRfSU5TVEFMTCBoYXJkZW5pbmcsIGJ1dCBJIGRpZCBub3QgZmluZCBh
biBleGFjdCBwdWJsaWMgZml4Cm9yIHJlcG9ydCBmb3IgTVNHX1JJTkcgU0VORF9GRCBza2lwcGlu
ZyBzZWN1cml0eV9maWxlX3JlY2VpdmUoKS4KCkNsYWltIGJvdW5kYXJ5CgpQcm92ZW46CgotIGEg
bGl2ZSBCUEYtTFNNIGxzbS9maWxlX3JlY2VpdmUgZGVueSBwb2xpY3kgd2FzIGF0dGFjaGVkOwot
IGNsYXNzaWMgU0NNX1JJR0hUUyBoaXQgdGhlIGZpbGVfcmVjZWl2ZSBob29rIGFuZCBkaWQgbm90
IGdpdmUgdGhlIHJlY2VpdmVyIGEKICB1c2FibGUgZmQ7Ci0gTVNHX1JJTkcgU0VORF9GRCBkaWQg
bm90IGhpdCB0aGUgaG9vazsKLSB0aGUgbG93ZXItcHJpdmlsZWdlZCByZWNlaXZlciByZWFkIHRo
ZSBwcm90ZWN0ZWQgZmlsZSB2aWEgdGhlIHRhcmdldCByaW5nCiAgZml4ZWQtZmlsZSBzbG90IGFm
dGVyIE1TR19SSU5HIFNFTkRfRkQuCgpOb3QgY2xhaW1lZDoKCi0gbWVtb3J5IGNvcnJ1cHRpb247
Ci0gYXJiaXRyYXJ5IHJvb3Qgc2hlbGw7Ci0gZ2VuZXJpYyBzYW5kYm94IG9yIGNvbnRhaW5lciBl
c2NhcGU7Ci0gU0VMaW51eC9BcHBBcm1vci9TbWFjayBwb2xpY3ktc3BlY2lmaWMgZXhwbG9pdGFi
aWxpdHkgd2l0aG91dCBhIGNvbmNyZXRlCiAgcG9saWN5IHJlcGxheTsKLSBleHBsb2l0YWJpbGl0
eSB3aGVyZSBhIGhpZ2hlci10cnVzdCBzZW5kZXIgbmV2ZXIgdXNlcyBNU0dfUklORyBTRU5EX0ZE
Lgo=
--000000000000b8af1b06524da8aa--

